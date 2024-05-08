# defining lambda-role -------------
data "aws_iam_policy_document" "lambda_edge_role_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_iam_assume_role" {
  name               = "lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_edge_role_assume_policy.json
}

# attaching policy to the role ----------------

# general lambda policy - gives access to ssm and logs
data "template_file" "lambda_general_policy_file" {
  template = file("./templates/iam/lambda-general-policy.json.tpl")
}

resource "aws_iam_policy" "lambda_general_policy" {
  name        = "General-lambda-policy"
  description = "Provides full access of ssm and logs"
  policy      = data.template_file.lambda_general_policy_file.rendered
}

# temp s3 lambda policy - gives full access to the temp s3 folder
data "template_file" "lambda_temp_s3_file" {
  template = file("./templates/iam/lambda-temp-s3-policy.json.tpl")
}

resource "aws_iam_policy" "lambda_temp_s3_policy" {
  name        = "Temp-S3-lambda-policy"
  description = "Provides full access of temp s3 bucket"
  policy      = data.template_file.lambda_temp_s3_file.rendered
}

# attaching policies to the role
resource "aws_iam_role_policy_attachment" "lambda_general_policy_attachment" {
  role       = aws_iam_role.lambda_iam_assume_role.name
  policy_arn = aws_iam_policy.lambda_general_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_general_s3_temp_attachment" {
  role       = aws_iam_role.lambda_iam_assume_role.name
  policy_arn = aws_iam_policy.lambda_temp_s3_policy.arn
}

resource "aws_lambda_function" "cleanup_cron" {
  filename      = "./lambda/lambda_cleanup_cron.zip"
  function_name = "lambda_cleanup_cron"
  role          = aws_iam_role.lambda_iam_assume_role.arn
  handler       = "lambda_handler.lambda_handler"
  publish       = true

  source_code_hash = filebase64sha256("./lambda/lambda_cleanup_cron.zip")

  runtime = "python3.10"

  memory_size = 128
  timeout = 100

  depends_on = [
    aws_iam_role_policy_attachment.lambda_general_policy_attachment,
    aws_iam_role_policy_attachment.lambda_general_s3_temp_attachment
  ]
}