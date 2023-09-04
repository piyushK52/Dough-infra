# ecr policy
data "aws_iam_policy_document" "ecr_policy" {
  statement {
    actions   = ["ecr:GetAuthorizationToken", "ecr:BatchCheckLayerAvailability", "ecr:GetDownloadUrlForLayer", "ecr:GetRepositoryPolicy", "ecr:DescribeRepositories", "ecr:ListImages", "ecr:DescribeImages", "ecr:BatchGetImage", "ecr:InitiateLayerUpload", "ecr:UploadLayerPart", "ecr:CompleteLayerUpload", "ecr:PutImage"]
    resources = ["*"]
  }
}

# allowing pipeline to register new task
data "aws_iam_policy_document" "ecs_policy" {
  statement {
    actions   = ["ecs:RegisterTaskDefinition", "ecs:DescribeServices", "ecs:UpdateService", "ecs:ListTasks", "ecs:ExecuteCommand"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "pass_role_policy" {
  statement {
    actions   = ["iam:GetRole", "iam:PassRole"]
    resources = [
      aws_iam_role.ecs_task_execution_role.arn,
      aws_iam_role.ecs_task_role.arn
    ]
  }
}

resource "aws_iam_policy" "pass_role_policy" {
  name        = "PassEcsTaskRolePolicy"
  description = "Allows passing the ecs-task-role to ECS tasks."
  policy = data.aws_iam_policy_document.pass_role_policy.json
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "ecr-policy"
  description = "Custom ECR policy"
  policy      = data.aws_iam_policy_document.ecr_policy.json
}

resource "aws_iam_policy" "ecs_policy" {
  name        = "ecs-policy"
  description = "Custom ECS policy"
  policy      = data.aws_iam_policy_document.ecs_policy.json
}

resource "aws_iam_user" "ecr_user" {
  name = "pipeline_user"
}

resource "aws_iam_access_key" "ecr_access_key" {
  user = aws_iam_user.ecr_user.name
}

resource "aws_iam_policy_attachment" "attach_ecr_policy" {
  name       = "attach-ecr-policy"
  policy_arn = aws_iam_policy.ecr_policy.arn
  users      = [aws_iam_user.ecr_user.name]
}

resource "aws_iam_policy_attachment" "attach_ecs_policy" {
  name       = "attach-ecs-policy"
  policy_arn = aws_iam_policy.ecs_policy.arn
  users      = [aws_iam_user.ecr_user.name]
}

resource "aws_iam_user_policy_attachment" "attach_pass_role_policy" {
  user       = aws_iam_user.ecr_user.name
  policy_arn = aws_iam_policy.pass_role_policy.arn
}

# access keys
output "access_key" {
  value = aws_iam_access_key.ecr_access_key.id
  sensitive = true
}

output "secret_key" {
  value = aws_iam_access_key.ecr_access_key.secret
  sensitive = true
}

# streamlit frontend
module "banodoco_frontend" {
    source = "./modules/repository"

    app_name            = "banodoco-frontend"
}

# django backend
module "banodoco_backend" {
    source  = "./modules/repository"

    app_name            = "banodoco-backend"
}

# streamlit website
module "banodoco_website" {
    source  = "./modules/repository"

    app_name            = "banodoco-website"
}