resource "random_uuid" "randomuuid" {}

data "template_file" "public_alb_s3_policy" {
  template = file("./templates/s3/policy.json.tpl")

  vars = {
    aws_account_no     = aws_caller_identity.current.account_id
    uuid               = random_uuid.randomuuid.result
    logging_account_id = aws_caller_identity.current.account_id
    bucket_name        = "banodoco-ai-public-alb-logs"
  }
}

resource "aws_s3_bucket" "public_lb_logs_bucket" {
  bucket        = "banodoco-ai-public-alb-logs"
  acl           = "log-delivery-write"
  policy        = data.template_file.public_alb_s3_policy.rendered
  force_destroy = true
}