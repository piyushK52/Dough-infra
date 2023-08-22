resource "random_uuid" "randomuuid" {}

data "template_file" "public_alb_s3_policy" {
  template = file("./templates/s3/policy.json.tpl")

  vars = {
    aws_account_no     = data.aws_caller_identity.current.account_id
    uuid               = random_uuid.randomuuid.result
    logging_account_id = var.logging_policy_account_id_map[var.aws_region]
    bucket_name        = "banodoco-ai-public-alb-logs"
  }
}

resource "aws_s3_bucket" "public_lb_logs_bucket" {
  bucket        = "banodoco-ai-public-alb-logs"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "public_lb_s3_policy" {
  bucket = aws_s3_bucket.public_lb_logs_bucket.id
  policy = data.template_file.public_alb_s3_policy.rendered
}

resource "aws_s3_bucket_ownership_controls" "public_lb_log_ownership_controls" {
  bucket = aws_s3_bucket.public_lb_logs_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_lb_log_access" {
  bucket = aws_s3_bucket.public_lb_logs_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "public_lb_log_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.public_lb_log_ownership_controls,
    aws_s3_bucket_public_access_block.public_lb_log_access,
  ]

  bucket = aws_s3_bucket.public_lb_logs_bucket.id
  acl    = "log-delivery-write"
}


variable "logging_policy_account_id_map" {
  description = "A map containing the AWS account IDs for assigning S3 write policy for logging"
  type        = map(number)

  default = {
    us-east-1      = 127311923021
    us-east-2      = 033677994240
    us-west-1      = 027434742980
    us-west-2      = 797873946194
    ca-central-1   = 985666609251
    eu-central-1   = 054676820928
    eu-west-1      = 156460612806
    eu-west-2      = 652711504416
    eu-west-3      = 009996457667
    eu-north-1     = 897822967062
    ap-east-1      = 754344448648
    ap-northeast-1 = 582318560864
    ap-northeast-2 = 600734575887
    ap-northeast-3 = 383597477331
    ap-southeast-1 = 114774131450
    ap-southeast-2 = 783225319266
    ap-south-1     = 718504428378
    me-south-1     = 076674570225
    sa-east-1      = 507241528517
  }
}