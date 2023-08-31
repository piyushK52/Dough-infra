#target group for where to redirect requests, with health check
resource "aws_alb_target_group" "app" {
  name        = "${var.team}-${var.app_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200-399"
    timeout             = "5"
    path                = var.app_health_check_path
    unhealthy_threshold = "5"
    healthy_threshold   = "2"
  }

  stickiness {
    type              = "lb_cookie"
    enabled           = var.sticky_cookies ? true : false
    cookie_duration   = 604800
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "default_listener_rule" {
  listener_arn = var.alb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app.arn
  }

  condition {
    host_header {
      values = [var.app_cname]
    }
  }
}

resource "aws_lb_listener_rule" "health_check_listener_rule" {
  listener_arn = var.alb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app.arn
  }

  condition {
    host_header {
      values = [var.app_cname]
    }
  }

  condition {
    path_pattern {
      values = [var.app_health_check_path, var.app_info_path]
    }
  }
}