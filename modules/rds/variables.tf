variable "name" {
  description = "name of the rds instance"
  type        = string
}

variable "vpc_id" {
  description = "the Id of the VPC that this instance will run on"
  type        = string
}

variable "private_subnet_ids" {
  description = "ids of private subnets"
  type        = list(string)
}

variable "username" {
  description = "root username for rds"
  type        = string
}

variable "password" {
  description = "root password for rds"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "instance size for rds"
  type        = string
}

variable "allocated_storage" {
  description = "inital storage for the rds instance"
  type        = number
}

variable "max_allocated_storage" {
  description = "max allowed storage for rds instance"
  type        = number
}


variable "ecs_security_group" {
  type = string
}


variable "proxy_machine_ip" {
  type = string
}
