variable "tf_backend_s3_bucket_name" {
    description = "Bucket name for tf backend"
    type        = string
    default     = "banodoco-infra"
}

variable "aws_region" {
    default     = "ap-south-1"
}

variable "env" {
    type        = string
    default     = "staging"
}

variable "az_count" {
    description = "Number of avaliability zone in a given region"
    default     = 2
}

variable app_port {
    description = "Port at which streamlit is running"
    default     = 5500
}

variable infra_config {
    description = "env values"
    type        = object({
        banodoco_frontend = object({
            cname           = string
            instances       = number
            cpu             = number
            memory          = number
            app_port        = number
            sticky_cookies  = bool
        }),
        banodoco_website = object({
            cname           = string
            instances       = number
            cpu             = number
            memory          = number
            app_port        = number
            sticky_cookies  = bool
        }),
        banodoco_backend = object({
            cname           = string
            instances       = number
            cpu             = number
            memory          = number
            app_port        = number
            sticky_cookies  = bool
        }),
        banodoco_ai_rds = object({
            allocated_storage       = number
            max_allocated_storage   = number
            instance_class          = string
            username                = string
            password                = string
        })
    })

    default = {
        banodoco_frontend = {
            instances       = 3
            cpu             = 512
            memory          = 2048
            cname           = "app.banodoco.ai"
            app_port        = 5500
            sticky_cookies  = true
        },
        banodoco_website = {
            instances       = 2
            cpu             = 512
            memory          = 2048
            cname           = "banodoco.ai"
            app_port        = 5500
            sticky_cookies  = true
        },
        banodoco_backend = {
            instances       = 1
            cpu             = 512
            memory          = 2048
            cname           = "api.banodoco.ai"
            app_port        = 8080
            sticky_cookies  = false
        },
        banodoco_ai_rds = {
            allocated_storage     = 50
            max_allocated_storage = 100
            instance_class        = "db.t3.micro"
            username              = "banodoco_admin"
            password              = "knmsjjGFWPBVP4Jq"
      }
    }
}