resource "aws_cloudfront_origin_access_identity" "external_ui_bucket_access_identity" {
  comment = "External UI bucket access"
}

# module "payment_success_external_service" {
#   source = "./modules/external-static-service"

#   bucket                                     = "stripe-payment"
#   cname                                      = "payment.banodoco.ai"
#   cf_ssl_cert                                = aws_acm_certificate.wild_card_banodoco_ssl_cert.arn
#   aws_cloudfront_origin_access_identity_arn  = aws_cloudfront_origin_access_identity.external_ui_bucket_access_identity.iam_arn
#   aws_cloudfront_origin_access_identity_path = aws_cloudfront_origin_access_identity.external_ui_bucket_access_identity.cloudfront_access_identity_path
# }