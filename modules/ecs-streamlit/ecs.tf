resource "aws_ecs_cluster" "main" {
  name = "${var.team}-${var.app_name}-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.team}-${var.app_name}-task"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions = jsonencode([
    {
      "name" : "${var.team}-${var.app_name}",
      "image" : "${var.aws_account_no}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.app_name}:latest",
      "cpu" : "${var.fargate_cpu}",
      "memory" : "${var.fargate_memory}",
      "essential" : true,
      "networkMode" : "awsvpc",
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/${var.team}/${var.app_name}",
          "awslogs-region" : "${var.aws_region}",
          "awslogs-stream-prefix" : "${var.team}/${var.app_name}"
        }
      },
      "portMappings" : [
        {
          "containerPort" : "${var.app_port}",
          "hostPort" : "${var.app_port}",
          "protocol" : "tcp"
        }
      ],
      "environment": var.environment_variables
    }
  ])
}

resource "aws_ecs_service" "service" {
  name                              = "${var.team}-${var.app_name}-service"
  cluster                           = aws_ecs_cluster.main.id
  task_definition                   = aws_ecs_task_definition.app.arn
  desired_count                     = var.app_count
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 120

  network_configuration {
    security_groups  = var.security_group_id_list
    subnets          = var.private_subnet_ids
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "${var.team}-${var.app_name}"
    container_port   = var.app_port
  }

  depends_on = [var.module_depends_on]

  dynamic "service_registries" {
    for_each = var.discovery_service_arn != null ? [1] : []
    content {
      registry_arn = var.discovery_service_arn
    }
  }
}