resource "aws_s3_bucket" "tf_state_bucket" {
  bucket = "banodoco-backend-tf-new"
}


# --------------- BANODOCO DATA BUCKET (PROD BUCKET)
resource "aws_s3_bucket" "banodoco_data_bucket" {
  bucket = "banodoco-data-bucket"
}

resource "aws_s3_bucket_ownership_controls" "prod_ownership_control" {
  bucket = aws_s3_bucket.banodoco_data_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "prod_access_block" {
  bucket = aws_s3_bucket.banodoco_data_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


data "aws_iam_policy_document" "allow_read_from_public_prod" {
  statement {
    effect = "Allow"

    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.banodoco_data_bucket.arn,
      "${aws_s3_bucket.banodoco_data_bucket.arn}/*",
    ]
  }

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.ec2_ssm_access_role.arn]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.banodoco_data_bucket.arn,
      "${aws_s3_bucket.banodoco_data_bucket.arn}/*",
    ]
  }
  
}

resource "aws_s3_bucket_acl" "banodoco_data_acl_prod" {
  depends_on = [
    aws_s3_bucket_ownership_controls.prod_ownership_control,
    aws_s3_bucket_public_access_block.prod_access_block
  ]

  bucket = aws_s3_bucket.banodoco_data_bucket.id
  access_control_policy {
    grant {
      grantee {
        type = "CanonicalUser"
        id = data.aws_canonical_user_id.current.id
      }
      permission = "WRITE"
    }

    grant {
      grantee {
        type = "CanonicalUser"
        id = data.aws_canonical_user_id.current.id
      }
      permission = "READ"
    }
    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}

resource "aws_s3_bucket_policy" "allow_read_from_public_prod" {
  bucket = aws_s3_bucket.banodoco_data_bucket.id
  policy = data.aws_iam_policy_document.allow_read_from_public_prod.json
}


# --------------- BANODOCO DATA BUCKET PUBLIC (MOSTLY FOR TEST DATA)
resource "aws_s3_bucket" "banodoco_data_bucket_public" {
  bucket = "banodoco-data-bucket-public"
}

resource "aws_s3_bucket_ownership_controls" "staging_ownership_control" {
  bucket = aws_s3_bucket.banodoco_data_bucket_public.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "staging_access_block" {
  bucket = aws_s3_bucket.banodoco_data_bucket_public.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_read_from_public" {
  bucket = aws_s3_bucket.banodoco_data_bucket_public.id
  policy = data.aws_iam_policy_document.allow_read_from_public.json
}

data "aws_iam_policy_document" "allow_read_from_public" {
  statement {
    effect = "Allow"

    principals {
      type = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.banodoco_data_bucket_public.arn,
      "${aws_s3_bucket.banodoco_data_bucket_public.arn}/*",
    ]
  }

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.ec2_ssm_access_role.arn]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.banodoco_data_bucket_public.arn,
      "${aws_s3_bucket.banodoco_data_bucket_public.arn}/*",
    ]
  }
  
}

resource "aws_s3_bucket_acl" "banodoco_data_acl_public" {
  depends_on = [
    aws_s3_bucket_ownership_controls.staging_ownership_control,
    aws_s3_bucket_public_access_block.staging_access_block
  ]

  bucket = aws_s3_bucket.banodoco_data_bucket_public.id
  access_control_policy {
    grant {
      grantee {
        type = "CanonicalUser"
        id = data.aws_canonical_user_id.current.id
      }
      permission = "WRITE"
    }

    grant {
      grantee {
        type = "CanonicalUser"
        id = data.aws_canonical_user_id.current.id
      }
      permission = "READ"
    }
    owner {
      id = data.aws_canonical_user_id.current.id
    }
  }
}

# -------------------------------------------------------------