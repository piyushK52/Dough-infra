module "banodoco_rds" {
  source = "./modules/rds"

  name                    = "banodoco-ai"
  private_subnet_ids      = aws_subnet.private.*.id
  vpc_id                  = aws_vpc.main.id
  ecs_security_group      = aws_security_group.ecs_security_group.id
  username                = var.infra_config.banodoco_ai_rds.username
  password                = var.infra_config.banodoco_ai_rds.password
  instance_class          = var.infra_config.banodoco_ai_rds.instance_class
  allocated_storage       = var.infra_config.banodoco_ai_rds.allocated_storage
  max_allocated_storage   = var.infra_config.banodoco_ai_rds.max_allocated_storage
  proxy_machine_ip        = aws_instance.banodoco_website.private_ip
}

output "resource_id" {
  value = module.banodoco_rds.resource_id
}

output "address" {
  value = module.banodoco_rds.address
}

output "port" {
  value = module.banodoco_rds.port
}
