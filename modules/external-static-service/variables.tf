variable "bucket" {
  type = string
}

variable "aws_cloudfront_origin_access_identity_arn" {
  type = string
}

variable "aws_cloudfront_origin_access_identity_path" {
  type = string
}

variable "cname" {
  type = string
}

variable "cf_ssl_cert" {
  type = string
}
