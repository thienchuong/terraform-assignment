output "secret_manager_name_ssh_key" {
  value = "${local.name}-ssh-private-key"
}

output "secret_manager_arn_ssh_key" {
  value = aws_secretsmanager_secret.ssh_private_key.arn
}

output "vpc_info" {
  value = module.vpc
}

output "bastion_info" {
  value = module.bastion
}

output "webapp_info" {
  value = module.webapp
}

output "lambda_info" {
  value = module.lambda
}