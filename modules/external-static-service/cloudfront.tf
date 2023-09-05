resource "aws_cloudfront_distribution" "ui_distribution" {

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_200"
  http_version        = "http2"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/error.html"
  }

  viewer_certificate {
    acm_certificate_arn      = var.cf_ssl_cert
    minimum_protocol_version = "TLSv1.1_2016"
    ssl_support_method       = "sni-only"
  }

  aliases = [var.cname]

  origin {
    domain_name = aws_s3_bucket.ui_s3_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.ui_s3_bucket.id

    s3_origin_config {
      origin_access_identity = var.aws_cloudfront_origin_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.ui_s3_bucket.id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    smooth_streaming       = false
    compress               = true

    forwarded_values {
      query_string = true

      headers = []

      cookies {
        forward = "none"
      }
    }
  }
}
