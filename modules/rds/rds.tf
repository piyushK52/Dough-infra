data "aws_iam_policy_document" "monitoring_rds_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "monitoring_rds_iam_assume_role" {
  name               = "${var.name}-rds-monitoring-role"
  assume_role_policy = data.aws_iam_policy_document.monitoring_rds_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "monitoring_rds_iam_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  role       = aws_iam_role.monitoring_rds_iam_assume_role.id
}

resource "aws_security_group" "rds_security_group" {
  name        = "${var.name}-rds-sg"
  description = "Security group for ${var.name} RDS"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "rds_security_group_ingress_ecs_task" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = var.ecs_security_group
  security_group_id        = aws_security_group.rds_security_group.id
  description              = "acces from ecs"
}

resource "aws_security_group_rule" "rds_security_group_ingress_proxy_machine" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["${var.proxy_machine_ip}/32"]
  security_group_id = aws_security_group.rds_security_group.id
  description       = "acces from proxy machinie"
}

resource "aws_security_group_rule" "rds_security_group_full_egress" {
  type              = "egress"
  protocol          = "all"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_security_group.id
  description       = "Full access to the Internet"
}

# full ingress access: temporary
resource "aws_security_group_rule" "rds_security_group_full_ingress" {
  type              = "ingress"
  protocol          = "all"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_security_group.id
  description       = "Full access to the Internet"
}

resource "aws_db_parameter_group" "rds_parameter_group" {
  name   = "${var.name}-parameter-group"
  family = "postgres13"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.name}-subnet-group"
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier                            = var.name
  instance_class                        = var.instance_class
  allocated_storage                     = var.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  engine                                = "postgres"
  engine_version                        = "13.10"
  storage_type                          = "gp2"
  username                              = var.username
  password                              = var.password
  db_subnet_group_name                  = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids                = [aws_security_group.rds_security_group.id]
  parameter_group_name                  = aws_db_parameter_group.rds_parameter_group.name
  backup_retention_period               = 7
  publicly_accessible                   = true
  skip_final_snapshot                   = true
  port                                  = "5432"
  iam_database_authentication_enabled   = true
  maintenance_window                    = "Sun:05:00-Sun:06:00"
  backup_window                         = "03:00-04:00"
  enabled_cloudwatch_logs_exports       = ["postgresql", "upgrade"]
  copy_tags_to_snapshot                 = true
  apply_immediately                     = true
  multi_az                              = false
  monitoring_interval                   = "30"
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  monitoring_role_arn                   = aws_iam_role.monitoring_rds_iam_assume_role.arn
}