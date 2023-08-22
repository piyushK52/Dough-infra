resource "aws_route53_zone" "banodoco" {
    name = "banodoco.ai"
}

resource "aws_route53_record" "banodoco_website" {
  zone_id = aws_route53_zone.banodoco.zone_id
  name    = "banodoco.ai"
  type    = "A"
  ttl     = "300"
  records = [
    aws_instance.banodoco_website.public_ip
  ]
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