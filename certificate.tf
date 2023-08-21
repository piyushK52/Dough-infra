resource "aws_acm_certificate" "wild_card_banodoco_ssl_cert" {
  domain_name       = "*.banodoco.ai"
  validation_method = "DNS"
}