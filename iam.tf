data "template_file" "ec2_ssm_read_policy_json" {
  template = file("./templates/iam/ec2-ssm-policy.json.tpl")
}

resource "aws_iam_policy" "ec2_read_policy" {
  name        = "EC2-SSM-Read-Policy"
  description = "Provides permission to read ssm"
  policy      = data.template_file.ec2_ssm_read_policy_json.rendered
}

data "template_file" "ec2_s3_access_policy_json" {
  template = file("./templates/iam/ec2-s3-policy.json.tpl")
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "EC2-s3-access-Policy"
  description = "Provides full access of s3 to ec2"
  policy      = data.template_file.ec2_s3_access_policy_json.rendered
}

resource "aws_iam_role" "ec2_ssm_access_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "RoleForEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "ssm-policy-attachment" {
  name       = "ssm-policy-attachment"
  roles      = [aws_iam_role.ec2_ssm_access_role.name]
  policy_arn = aws_iam_policy.ec2_read_policy.arn
}

resource "aws_iam_policy_attachment" "s3_access_policy_attachment" {
  name       = "s3-policy-attachment"
  roles      = [aws_iam_role.ec2_ssm_access_role.name]
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_instance_profile" "ec2_ssm_access_profile" {
  name = "ec2_ssm_access_profile"
  role = aws_iam_role.ec2_ssm_access_role.name
}
