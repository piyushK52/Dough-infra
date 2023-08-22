resource "aws_security_group" "ecs_security_group" {
  name        = "ecs-sg"
  description = "Security group for ECs"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = ""
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.public_lb_security_group.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "ecs_streamlit_frontend" {
  source = "./modules/ecs-streamlit"

  alb_domain_name    = aws_alb.public_lb.dns_name
  alb_listener_arn   = aws_alb_listener.public_lb_listener.arn
  app_cname          = var.infra_config.banodoco_frontend.cname
  app_name           = "banodoco-frontend"
  aws_region         = var.aws_region
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  private_subnet_ids = aws_subnet.private.*.id
  security_group_id  = aws_security_group.ecs_security_group.id
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  vpc_id             = aws_vpc.main.id
  app_count          = var.infra_config.banodoco_frontend.instances
  fargate_cpu        = var.infra_config.banodoco_frontend.cpu
  fargate_memory     = var.infra_config.banodoco_frontend.memory
  environment        = var.env

  aws_account_no        = data.aws_caller_identity.current.account_id
  team                  = "backend"

  ssl_certificate    = aws_acm_certificate.wild_card_banodoco_ssl_cert.arn
  public_lb_name     = aws_alb.public_lb.name
  public_lb_dns_name = aws_alb.public_lb.dns_name

  module_depends_on = aws_alb_listener.public_lb_listener
}