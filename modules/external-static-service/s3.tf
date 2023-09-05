resource "aws_s3_bucket" "ui_s3_bucket" {
  bucket              = "banodoco-prod-${var.bucket}"
  acl                 = "private"
  acceleration_status = "Enabled"
  versioning {
    enabled = true
  }
}

data "aws_iam_policy_document" "ui_s3_cloudfront_policy_template" {
  statement {
    actions = ["s3:ListBucket", "s3:GetObject"]
    resources = [
      aws_s3_bucket.ui_s3_bucket.arn,
      "${aws_s3_bucket.ui_s3_bucket.arn}/*"
    ]

    principals {
      type = "AWS"
      identifiers = [
        var.aws_cloudfront_origin_access_identity_arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "ui_s3_bucket_policy" {
  bucket = aws_s3_bucket.ui_s3_bucket.id
  policy = data.aws_iam_policy_document.ui_s3_cloudfront_policy_template.json
}
