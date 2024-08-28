variable "name" {
  description = "name of the rds instance"
  type        = string
}

variable "vpc_id" {
  description = "the Id of the VPC that this instance will run on"
  type        = string
}

variable "ec2_security_group" {
    description = "the Id of the security group that the ec2 instances will run on"
    type        = string
}

variable "ecs_security_group" {
    description = "the Id of the security group that the ecs instances will run on"
    type        = string
}

variable "private_subnet_ids" {
  description = "the Ids of the private subnets that this instance will run on"
  type        = list(string)
}