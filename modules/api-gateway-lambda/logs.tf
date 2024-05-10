# cloudwatch log iam role ----------------------------
resource "aws_iam_role" "api_gateway_cloudwatch_logs" {
  name = "api-gateway-cloudwatch-logs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_cloudwatch_logs" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
  role       = aws_iam_role.api_gateway_cloudwatch_logs.name
}

resource "aws_iam_role_policy" "api_gateway_cloudwatch_logs" {
  name = "api-gateway-cloudwatch-logs"
  role = aws_iam_role.api_gateway_cloudwatch_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# api gateway logs ----------------------------
resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "/aws/api-gateway/${aws_api_gateway_rest_api.api.name}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "api_gateway_stage_logs" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api.id}/${aws_api_gateway_deployment.prod_deployment.stage_name}"
  retention_in_days = 30
}

# api gateway account ----------------------------
# NOTE: for logging in api gateway, the iam role has to be added to the 'gateway account'
# and this is one per region.. so check if this needs to be removed from this module
resource "aws_api_gateway_account" "api_gateway_account" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch_logs.arn
}