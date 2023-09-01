# public lb security group
resource "aws_security_group" "public_lb_security_group" {
  name        = "public-lb-security-group"
  description = "Security group for public Load Balancer"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "public_lb_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_lb_security_group.id
}

resource "aws_security_group_rule" "public_lb_egress" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_lb_security_group.id
}
#---------------------------------------------------------------------

resource "aws_alb" "public_lb" {
  name               = "public-load-balancer"
  subnets            = aws_subnet.private.*.id
  security_groups    = [aws_security_group.public_lb_security_group.id]
  internal           = false
  load_balancer_type = "application"
  idle_timeout       = 240

  access_logs {
    enabled = true
    bucket  = aws_s3_bucket.public_lb_logs_bucket.bucket
  }
}

resource "aws_alb_listener" "public_lb_listener" {
  load_balancer_arn = aws_alb.public_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "contact admin for access"
      status_code  = 403
    }
  }
}

resource "aws_lb_listener_certificate" "wildcard_certificate" {
  listener_arn    = aws_alb_listener.public_lb_listener.arn
  certificate_arn = aws_acm_certificate.wild_card_banodoco_ssl_cert.arn
}

resource "aws_lb_listener_certificate" "domain_certificate" {
  listener_arn    = aws_alb_listener.public_lb_listener.arn
  certificate_arn = aws_acm_certificate.banodoco_ssl_cert.arn
}