resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/${var.team}/${var.app_name}"
  retention_in_days = 90

  tags = {
    Name = "${var.team}-${var.app_name}-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "${var.team}-${var.app_name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}