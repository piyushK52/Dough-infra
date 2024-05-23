resource "aws_api_gateway_api_key" "api_key" {
  name = "utility-api-key"
}

output "api_key_value" {
  description = "The value of the API Gateway API key"
  value       = aws_api_gateway_api_key.api_key.value
  sensitive   = true
}

module "api_gateway" {
  source = "./modules/api-gateway-lambda"

  api_name = "img-utility-api"
  api_key  = aws_api_gateway_api_key.api_key

  burst_limit = 1000    # no. of concurrent calls
  rate_limit  = 2000    # max no. of calls per second

  endpoints = {
    "generate-zip" = {
      lambda_function_name = aws_lambda_function.generate_zip.function_name
      lambda_invoke_arn    = aws_lambda_function.generate_zip.invoke_arn
    }
    "generate-collage" = {
      lambda_function_name = aws_lambda_function.generate_collage.function_name
      lambda_invoke_arn    = aws_lambda_function.generate_collage.invoke_arn
    }
    "refresh-url" = {
      lambda_function_name = aws_lambda_function.refresh_url.function_name
      lambda_invoke_arn    = aws_lambda_function.refresh_url.invoke_arn
    }
    "file-zip" = {
      lambda_function_name = aws_lambda_function.file_zip.function_name
      lambda_invoke_arn    = aws_lambda_function.file_zip.invoke_arn
    }
  }
}

output "api_gateway_rest_api_id" {
  description = "The ID of the API Gateway REST API"
  value       = module.api_gateway.api_gateway_rest_api_id
}

output "api_gateway_deployment_invoke_url" {
  description = "The URL to invoke the API Gateway deployment"
  value       = module.api_gateway.api_gateway_deployment_invoke_url
}