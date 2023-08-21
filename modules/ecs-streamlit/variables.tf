variable "team" {
  description = "Name of team. Used in created resources names"
  type        = string
}

variable "environment" {
  description = "The name of this environment, e.g. dev, integ, prod"
  type        = string
}

variable "aws_account_no" {
  description = "AWS account number"
  type        = string
}

variable "app_cname" {
  description = "The Cloudfront CName of this application"
  type        = string
}

variable "alb_domain_name" {
  description = "The domain name of the ALB"
  type        = string
}

variable "alb_listener_arn" {
  description = "The ARN of the ALB request listener"
  type        = string
}

variable "cf_authorization_hash" {
  description = "Value to accept for CloudFront authorization"
  type        = string
}

variable "app_count" {
  description = "Number of instances of this service to create"
  type        = number
}

variable "app_health_check_path" {
  description = "The name of the endpoint to hit to determine if the application is healthy"
  type        = string
  default     = "/"
}

variable "app_info_path" {
  description = "The name of the endpoint to hit to get info about this app"
  type        = string
  default     = "/info"
}

variable "app_name" {
  description = "The name of this application"
  type        = string
}

variable "app_port" {
  description = "The port that this app runs on in the Docker image"
  type        = number
  default     = 8080
}

variable "aws_region" {
  description = "The AWS region this service is running in."
  type        = string
}

variable "execution_role_arn" {
  description = "The ARN for the AWS role that has permission to execute the service"
  type        = string
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  type        = number
}

variable "fargate_memory" {
  description = "Amount of Fargate memory to provision in MiB"
  type        = number
}

variable "private_subnet_ids" {
  description = "The private subnet that this server is to run on"
  type        = list(string)
}

variable "security_group_id" {
  description = "The ID of the security group for this service"
  type        = string
}

variable "task_role_arn" {
  description = "The ARN of the task role that should be assigned to this task"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the subnet that this service runs on"
  type        = string
}

variable "module_depends_on" {
  type    = any
  default = null
}

variable "ssl_certificate" {
  type = string
}

variable "public_lb_name" {
  type = string
}

variable "public_lb_dns_name" {
  type = string
}

variable "assign_public_ip" {
  type    = bool
  default = true
}
