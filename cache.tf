module "backend_banodoco_redis" {
  source = "./modules/redis"

  name               = "banodoco-redis"
  private_subnet_ids = aws_subnet.private.*.id
  vpc_id             = aws_vpc.main.id
  ec2_security_group = aws_security_group.ec2_security_group.id
  ecs_security_group = aws_security_group.ecs_security_group.id
}

output "redis_conn_url" {
  description = "The URL to invoke the API Gateway deployment"
  value       = module.backend_banodoco_redis.redis_endpoint
}