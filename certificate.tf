# banodoco.ai
# ---------------------------------
resource "aws_acm_certificate" "wild_card_banodoco_ssl_cert" {
  domain_name       = "*.banodoco.ai"
  validation_method = "DNS"
}

resource "aws_acm_certificate" "banodoco_ssl_cert" {
  domain_name       = "banodoco.ai"
  validation_method = "DNS"
}

resource "aws_acm_certificate" "wild_card_cloudfront_banodoco_ssl_cert" {
  provider          = aws.east_1
  domain_name       = "*.banodoco.ai"
  validation_method = "DNS"
}

# bndc.ai
# -----------------------------------
resource "aws_acm_certificate" "wild_card_bndc_ssl_cert" {
  domain_name       = "*.bndc.ai"
  validation_method = "DNS"
}

resource "aws_acm_certificate" "bndc_ssl_cert" {
  domain_name       = "bndc.ai"
  validation_method = "DNS"
}

resource "aws_acm_certificate" "wild_card_cloudfront_bndc_ssl_cert" {
  provider          = aws.east_1
  domain_name       = "*.bndc.ai"
  validation_method = "DNS"
}