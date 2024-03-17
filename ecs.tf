# internal namespace & discovery service -----------------------------
resource "aws_service_discovery_private_dns_namespace" "internal" {
  name = "mvp.internal"
  description = "service discovery dns namespace for user service"

  vpc = aws_vpc.main.id
}

resource "aws_service_discovery_service" "backend" {
  name = "banodoco-backend"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.internal.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}


locals {
  environment_variables = [
    {
      "name": "SERVER_URL",
      "value": "${aws_service_discovery_service.backend.name}.${aws_service_discovery_private_dns_namespace.internal.name}"
    },
    {
      "name": "TEST_2",
      "value": "test"
    }
  ]
}


# ----------------------------------------------------------------------

resource "aws_security_group" "ecs_discovery_security_group" {
  name        = "ecs-discovery-sg"
  description = "Security group for ECS discovery"
  vpc_id      = aws_vpc.main.id

  ingress {
    description            = "other ECS services"
    protocol               = "tcp"
    from_port              = 0
    to_port                = 65535
    security_groups        = [aws_security_group.ecs_security_group.id]
  }
}

resource "aws_security_group" "ecs_security_group" {
  name        = "ecs-sg"
  description = "Security group for ECs"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "streamlit access"
    protocol        = "tcp"
    from_port       = var.infra_config.banodoco_frontend.app_port
    to_port         = var.infra_config.banodoco_frontend.app_port
    security_groups = [aws_security_group.public_lb_security_group.id]
  }

  ingress {
    description     = "django access"
    protocol        = "tcp"
    from_port       = var.infra_config.banodoco_backend.app_port
    to_port         = var.infra_config.banodoco_backend.app_port
    security_groups = [aws_security_group.public_lb_security_group.id]
  }


  # ingress {
  #   description     = "Allow traffic from EC2 machine"
  #   protocol        = "tcp"
  #   from_port       = 0
  #   to_port         = 65535
  #   cidr_blocks     = ["${aws_instance.proxy_machine.private_ip}/32"]
  # }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# module "ecs_streamlit_frontend" {
#   source = "./modules/ecs-streamlit"

#   alb_domain_name             = aws_alb.public_lb.dns_name
#   alb_listener_arn            = aws_alb_listener.public_lb_listener.arn
#   app_cname                   = var.infra_config.banodoco_frontend.cname
#   app_name                    = "banodoco-frontend"
#   aws_region                  = var.aws_region
#   execution_role_arn          = aws_iam_role.ecs_task_execution_role.arn
#   private_subnet_ids          = aws_subnet.private.*.id
#   security_group_id_list      = [aws_security_group.ecs_security_group.id, aws_security_group.ecs_discovery_security_group.id]
#   task_role_arn               = aws_iam_role.ecs_task_role.arn
#   vpc_id                      = aws_vpc.main.id
#   app_count                   = var.infra_config.banodoco_frontend.instances
#   fargate_cpu                 = var.infra_config.banodoco_frontend.cpu
#   fargate_memory              = var.infra_config.banodoco_frontend.memory
#   environment                 = var.env
#   app_health_check_path       = "/healthz"
#   app_port                    = var.infra_config.banodoco_frontend.app_port
#   sticky_cookies              = var.infra_config.banodoco_frontend.sticky_cookies

#   aws_account_no = data.aws_caller_identity.current.account_id
#   team           = "backend"

#   ssl_certificate    = aws_acm_certificate.wild_card_banodoco_ssl_cert.arn
#   public_lb_name     = aws_alb.public_lb.name
#   public_lb_dns_name = aws_alb.public_lb.dns_name

#   module_depends_on = aws_alb_listener.public_lb_listener
#   environment_variables = local.environment_variables
# }

module "ecs_banodoco_backend" {
  source = "./modules/ecs-streamlit"

  alb_domain_name             = aws_alb.public_lb.dns_name
  alb_listener_arn            = aws_alb_listener.public_lb_listener.arn
  app_cname                   = var.infra_config.banodoco_backend.cname
  app_name                    = "banodoco-backend"
  aws_region                  = var.aws_region
  execution_role_arn          = aws_iam_role.ecs_task_execution_role.arn
  private_subnet_ids          = aws_subnet.private.*.id
  security_group_id_list      = [aws_security_group.ecs_security_group.id, aws_security_group.ecs_discovery_security_group.id]
  task_role_arn               = aws_iam_role.ecs_task_role.arn
  vpc_id                      = aws_vpc.main.id
  app_count                   = var.infra_config.banodoco_backend.instances
  fargate_cpu                 = var.infra_config.banodoco_backend.cpu
  fargate_memory              = var.infra_config.banodoco_backend.memory
  environment                 = var.env
  app_health_check_path       = "/health-check"
  app_port                    = var.infra_config.banodoco_backend.app_port
  sticky_cookies              = var.infra_config.banodoco_backend.sticky_cookies

  aws_account_no = data.aws_caller_identity.current.account_id
  team           = "backend"

  ssl_certificate    = aws_acm_certificate.wild_card_banodoco_ssl_cert.arn
  public_lb_name     = aws_alb.public_lb.name
  public_lb_dns_name = aws_alb.public_lb.dns_name

  module_depends_on = aws_alb_listener.public_lb_listener
  discovery_service_arn = aws_service_discovery_service.backend.arn
}

module "ecs_streamlit_website" {
  source = "./modules/ecs-streamlit"

  alb_domain_name             = aws_alb.public_lb.dns_name
  alb_listener_arn            = aws_alb_listener.public_lb_listener.arn
  app_cname                   = var.infra_config.banodoco_website.cname
  app_name                    = "banodoco-website"
  aws_region                  = var.aws_region
  execution_role_arn          = aws_iam_role.ecs_task_execution_role.arn
  private_subnet_ids          = aws_subnet.private.*.id
  security_group_id_list      = [aws_security_group.ecs_security_group.id, aws_security_group.ecs_discovery_security_group.id]
  task_role_arn               = aws_iam_role.ecs_task_role.arn
  vpc_id                      = aws_vpc.main.id
  app_count                   = var.infra_config.banodoco_website.instances
  fargate_cpu                 = var.infra_config.banodoco_website.cpu
  fargate_memory              = var.infra_config.banodoco_website.memory
  environment                 = var.env
  app_health_check_path       = "/healthz"
  app_port                    = var.infra_config.banodoco_website.app_port
  sticky_cookies              = var.infra_config.banodoco_website.sticky_cookies

  aws_account_no = data.aws_caller_identity.current.account_id
  team           = "frontend"

  ssl_certificate    = aws_acm_certificate.banodoco_ssl_cert.arn
  public_lb_name     = aws_alb.public_lb.name
  public_lb_dns_name = aws_alb.public_lb.dns_name

  module_depends_on = aws_alb_listener.public_lb_listener
}