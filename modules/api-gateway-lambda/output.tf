output "api_gateway_rest_api_id" {
  description = "The ID of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.api.id
}

output "api_gateway_deployment_invoke_url" {
  description = "The URL to invoke the API Gateway deployment"
  value       = aws_api_gateway_deployment.prod_deployment.invoke_url
}