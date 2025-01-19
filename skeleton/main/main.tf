data "aws_availability_zones" "available" {}

locals {
  project_name = "assignment"
  name         = "${local.project_name}-${var.env}"
}

################################################################################
# Networking
################################################################################

module "vpc" {
  source = "../../modules/vpc"

  name                             = "${local.name}-vpc"
  create_igw                       = true
  create_nat_gateway               = true
  create_private_nat_gateway_route = true
  azs                              = slice(data.aws_availability_zones.available.names, 0, 3)

  # Depends on env
  cidr_block             = var.cidr_block
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  public_subnets         = var.public_subnets
  private_subnets        = var.private_subnets
}

################################################################################
# Instances
################################################################################

module "bastion" {
  source = "../../modules/ec2"

  name                     = "${local.name}-bastion"
  ami                      = data.aws_ami.latest_ubuntu.id
  subnet_id                = module.vpc.public_subnet_ids[0]
  instance_type            = "t3.micro"
  vpc_security_group_ids   = [aws_security_group.bastion.id]
  key_name                 = aws_key_pair.ssh_key.key_name
  iam_instance_profile_arn = aws_iam_instance_profile.common.arn
  root_block_device = [
    {
      encrypted             = true
      volume_type           = "gp2"
      volume_size           = 8
      delete_on_termination = true
    }
  ]

}

module "webapp" {
  source = "../../modules/ec2"

  name                       = local.name
  ami                        = data.aws_ami.latest_ubuntu.id
  subnet_id                  = module.vpc.private_subnet_ids[0]
  monitoring                 = true
  create_launch_template_asg = true
  asg_tags = {
    Name = "${local.name}-webapp"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
    echo "Hello, World!" > /var/www/html/index.html
    systemctl start nginx
    systemctl enable nginx
  EOF

  vpc_security_group_ids   = [aws_security_group.app.id]
  key_name                 = aws_key_pair.ssh_key.key_name
  iam_instance_profile_arn = aws_iam_instance_profile.common.arn
  vpc_zone_identifier      = module.vpc.private_subnet_ids

  # Depends on env
  instance_type                         = var.instance_type
  min_size                              = var.min_size
  max_size                              = var.max_size
  desired_capacity                      = var.desired_capacity
  launch_template_block_device_mappings = var.webapp_block_device_mapping
}

################################################################################
# Lambda
################################################################################

data "archive_file" "lambda_verify_alb" {
  type             = "zip"
  source_file      = "${path.module}/templates/lambda/main.py"
  output_file_mode = "0666"
  output_path      = "${path.module}/templates/lambda/lambda_function.zip"
}

module "lambda" {
  source = "../../modules/lambda"

  function_name    = "${local.name}-lambda-verify-alb"
  description      = "Lambda function to implement healthcheck of Load Balancer"
  create_role      = true
  role_name        = "${local.name}-lambda-verify-alb-role"
  handler          = "main.lambda_handler"
  runtime          = "python3.12"
  source_path      = "${path.module}/templates/lambda/lambda_function.zip"
  source_code_hash = data.archive_file.lambda_verify_alb.output_base64sha256

  attach_policy_json                 = true
  policy_json                        = data.aws_iam_policy_document.lambda_sns.json
  policy_name_suffix_additional_json = "cloudwatch-event"

  environment_variables = {
    ALB_DNS_URL   = aws_lb.this.dns_name
    SNS_TOPIC_ARN = var.sns_topic_arn
  }

  allowed_triggers = {
    ALBHealthcheck = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.alb_healthcheck.arn
    }
  }
}

resource "aws_cloudwatch_event_rule" "alb_healthcheck" {
  name                = "ALBHealthcheck"
  description         = "Application Loadbalancer Healthcheck"
  schedule_expression = var.schedule_expression
  force_destroy       = true
}

resource "aws_cloudwatch_event_target" "alb_healthcheck" {
  rule = aws_cloudwatch_event_rule.alb_healthcheck.name
  arn  = module.lambda.lambda_arn
}
