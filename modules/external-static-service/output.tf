output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.ui_distribution.domain_name
}
