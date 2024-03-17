resource "aws_security_group" "ec2_security_group" {
  name        = "ec2-security-group"
  description = "Security group for ec2"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "ssh_request" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.ec2_security_group.id
  description              = "Access from internet"
}

resource "aws_security_group_rule" "http_request" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.ec2_security_group.id
  description              = "Access from internet"
}

resource "aws_security_group_rule" "https_request" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.ec2_security_group.id
  description              = "Access from internet"
}

resource "aws_security_group_rule" "streamlit_server" {
  type                     = "ingress"
  from_port                = 8501
  to_port                  = 8501
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.ec2_security_group.id
  description              = "Access from internet"
}

resource "aws_security_group_rule" "ec2_security_group_full_egress" {
  type              = "egress"
  protocol          = "all"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_security_group.id
  description       = "Full access to the Internet"
}

resource "aws_instance" "proxy_machine" {
  ami                       = "ami-06984ea821ac0a879"
  instance_type             = "t2.micro"
  vpc_security_group_ids    = [
    aws_security_group.ec2_security_group.id
  ]
  key_name                  = "banodoco_key"
  subnet_id                 = aws_subnet.public[0].id
  associate_public_ip_address = "true"
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_access_profile.name

  tags = {
    Name = "proxy_machine"
  }
}

resource "aws_instance" "github_workflow" {
  ami                       = "ami-06984ea821ac0a879"
  instance_type             = "t2.micro"
  vpc_security_group_ids    = [
    aws_security_group.ec2_security_group.id
  ]
  key_name                  = "banodoco_key"
  subnet_id                 = aws_subnet.public[0].id
  associate_public_ip_address = "true"
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_access_profile.name

  tags = {
    Name = "github_workflow"
  }
}

# resource "aws_instance" "test_instance" {
#   ami                       = "ami-06984ea821ac0a879"
#   instance_type             = "t2.medium"
#   vpc_security_group_ids    = [
#     aws_security_group.ec2_security_group.id
#   ]
#   key_name                  = "banodoco_key"
#   subnet_id                 = aws_subnet.public[0].id
#   associate_public_ip_address = "true"
#   iam_instance_profile = aws_iam_instance_profile.ec2_ssm_access_profile.name

#   root_block_device {
#     volume_type           = "gp2"
#     volume_size           = 20
#     delete_on_termination = true
#   }

#   tags = {
#     Name = "test_instance"
#   }
# }

# resource "aws_instance" "discord_bndc_bot" {
#   ami                       = "ami-0f5ee92e2d63afc18"
#   instance_type             = "t2.medium"
#   vpc_security_group_ids    = [
#     aws_security_group.ec2_security_group.id
#   ]
#   key_name                  = "banodoco_key"
#   subnet_id                 = aws_subnet.public[0].id
#   associate_public_ip_address = "true"
#   iam_instance_profile = aws_iam_instance_profile.ec2_ssm_access_profile.name

#   tags = {
#     Name = "discord_bndc_bot"
#   }
# }
