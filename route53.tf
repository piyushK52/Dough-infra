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