resource "aws_route53_zone" "banodoco" {
    name = "banodoco.ai"
}

resource "aws_route53_record" "banodoco_website" {
  zone_id = aws_route53_zone.banodoco.zone_id
  name    = "banodoco.ai"
  type    = "A"

  alias {
    name                   = aws_alb.public_lb.dns_name
    zone_id                = aws_alb.public_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www_banodoco_website" {
  zone_id = aws_route53_zone.banodoco.zone_id
  name    = "www.banodoco.ai"
  type    = "CNAME"
  ttl     = 300
  records = ["banodoco.ai"]
}

resource "aws_route53_record" "banodoco_frontend_app" {
  zone_id = aws_route53_zone.banodoco.zone_id
  name    = "app.banodoco.ai"
  type    = "A"

  alias {
    name                   = aws_alb.public_lb.dns_name
    zone_id                = aws_alb.public_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "banodoco_backend_app" {
  zone_id = aws_route53_zone.banodoco.zone_id
  name    = "api.banodoco.ai"
  type    = "A"

  alias {
    name                   = aws_alb.public_lb.dns_name
    zone_id                = aws_alb.public_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "banodoco_scale_server_app" {
  zone_id = aws_route53_zone.banodoco.zone_id
  name    = "ss.banodoco.ai"
  type    = "A"

  alias {
    name                   = aws_alb.public_lb.dns_name
    zone_id                = aws_alb.public_lb.zone_id
    evaluate_target_health = true
  }
}


resource "aws_route53_record" "payment_static_page" {
  zone_id = aws_route53_zone.banodoco.zone_id
  name    = "payment.banodoco.ai"
  type    = "A"

  alias {
    name                    = "${module.payment_success_external_service.cloudfront_domain_name}"
    zone_id                 = "Z2FDTNDATAQYW2"
    evaluate_target_health  = false
  }
}

# GOOGLE WORKSPACE VERIFICATION
resource "aws_route53_record" "txt_record" {
  zone_id = aws_route53_zone.banodoco.zone_id
  name    = ""
  type    = "TXT"
  ttl     = 300
  records = ["google-site-verification=pEVHas4MOI24-OStHRdnw49QUwIk52vNRHiX1qyqTMI"]
}

# BNDC.ai
# --------------------------------------

resource "aws_route53_zone" "bndc" {
    name = "bndc.ai"
}

resource "aws_route53_record" "bndc_payment_static_page" {
  zone_id = aws_route53_zone.bndc.zone_id
  name    = "payment.bndc.ai"
  type    = "A"

  alias {
    name                    = "${module.payment_bndc_success_external_service.cloudfront_domain_name}"
    zone_id                 = "Z2FDTNDATAQYW2"
    evaluate_target_health  = false
  }
}

resource "aws_route53_record" "bndc_api_record" {
  zone_id = aws_route53_zone.bndc.zone_id
  name    = "api.bndc.ai"
  type    = "A"
  ttl     = "3600"
  records = [aws_instance.discord_bndc_bot.public_ip]
}