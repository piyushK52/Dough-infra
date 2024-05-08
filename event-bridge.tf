# EventBridge rule: freq = 5 mins
resource "aws_cloudwatch_event_rule" "trigger_lambda_every_5_minutes" {
  name                = "trigger-cleanup-cron-lambda"
  description         = "Trigger the cleanup_cron Lambda function every 5 minutes"
  schedule_expression = "rate(5 minutes)"
}

# EventBridge target
resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.trigger_lambda_every_5_minutes.name
  arn       = aws_lambda_function.cleanup_cron.arn
  target_id = "invoke-cleanup-cron-lambda"
}

# INFO - Gives an external source (like a CloudWatch Event Rule, SNS, or S3) permission to access the Lambda function
# this achieves the above by updating the resource policy of the lambda function
resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cleanup_cron.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.trigger_lambda_every_5_minutes.arn
}
