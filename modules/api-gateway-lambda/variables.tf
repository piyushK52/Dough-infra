variable "api_name" {
  description = "The name of the API Gateway REST API"
  type        = string
}

variable "endpoints" {
  description = "A map of endpoint paths and their corresponding Lambda function configurations"
  type        = map(object({
    lambda_function_name = string
    lambda_invoke_arn    = string
  }))
}

variable "burst_limit" {
  description = "The API Gateway usage plan burst limit"
  type        = number
  default     = 1000
}

variable "rate_limit" {
  description = "The API Gateway usage plan rate limit"
  type        = number
  default     = 2000
}

variable "api_key" {
  description = "The API Gateway API key resource"
}