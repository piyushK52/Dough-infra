resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.name}-subnet-group"
  }
}

resource "aws_elasticache_cluster" "redis_cluster" {
  cluster_id           = "redis-cluster"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.2"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_security_group.id]
}

resource "aws_security_group" "redis_security_group" {
  name        = "${var.name}-redis-sg"
  description = "Security group for ${var.name} Redis"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "redis_security_group_ingress_ec2" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = var.ec2_security_group
  security_group_id        = aws_security_group.redis_security_group.id
  description              = "acces from ec2 tasks"
}

resource "aws_security_group_rule" "redis_security_group_full_egress" {
  type              = "egress"
  protocol          = "all"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.redis_security_group.id
  description       = "Full access to the Internet"
}
