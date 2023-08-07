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