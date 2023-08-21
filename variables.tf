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
    default     = 8501
}

variable infra_config {
    description = "env values"
    type        = map(object({
        banodoco_frontend = object({
            cname       = string
            instances   = number
            cpu         = number
            memory      = number             
        })
    }))

    default = {
        banodoco_frontend = {
            instances = 1
            cpu       = 512
            memory    = 2048
            cname     = "app.banodoco.ai"
        }
    }
}