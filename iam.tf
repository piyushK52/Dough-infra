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

data "template_file" "ecs_task_execution_policy_json" {
  template = file("./templates/iam/ecs-policy.json.tpl")
}

data "template_file" "ecs_task_protection_policy_json" {
  template = file("./templates/iam/ecs-task-protection-policy.json.tpl")
}

resource "aws_iam_policy" "ecs_task_protection_update_policy" {
  name        = "ecs-task-protection-policy"
  description = "IAM policy for ECS task protection"
  policy      = data.template_file.ecs_task_protection_policy_json.rendered
}

# this is the role that your application code running inside the container assumes
resource "aws_iam_role" "ecs_task_role" {
  name               = "ecs-task-role"
  assume_role_policy = data.template_file.ecs_task_execution_policy_json.rendered
}

# this role is used by the ECS agent and the Docker daemon.
# it's used for actions that need to be performed before your container starts and for supporting operations.
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs-task-execution-role"
  assume_role_policy = data.template_file.ecs_task_execution_policy_json.rendered
}

# some things that this policy helps in - pull container images from ECR, send container logs to CloudWatch, interact with ssm etc..
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

resource "aws_iam_role_policy_attachment" "s3_full_access_policy_attachment_ecs_task" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.ecs_task_role.id
}

resource "aws_iam_role_policy_attachment" "ssm_permissions_policy_attachment_ecs_task" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  role       = aws_iam_role.ecs_task_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_task_protection_policy_attachment_ecs_task" {
  policy_arn  = aws_iam_policy.ecs_task_protection_update_policy.arn
  role        = aws_iam_role.ecs_task_role.name
}

# backend user for s3 access ---------------------------------------
resource "aws_iam_user" "s3_user" {
  name = "s3-access-user"
}

resource "aws_iam_user_policy_attachment" "s3_policy_attachment" {
  user       = aws_iam_user.s3_user.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_access_key" "s3_access_key" {
  user = aws_iam_user.s3_user.name
}

output "iam_user_access_key" {
  value = aws_iam_access_key.s3_access_key.secret
  sensitive = true
}

output "iam_user_access_key_id" {
  value = aws_iam_access_key.s3_access_key.id
  sensitive = true
}

# ------------------------------------------------------------------
