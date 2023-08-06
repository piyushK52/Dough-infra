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