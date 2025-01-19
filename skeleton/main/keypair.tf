resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "${local.name}-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_secretsmanager_secret" "ssh_private_key" {
  name_prefix = "${local.name}-ssh-private-key"
  description = "Common SSH private key."
}

resource "aws_secretsmanager_secret_version" "ssh_private_key" {
  secret_id     = aws_secretsmanager_secret.ssh_private_key.id
  secret_string = tls_private_key.ssh_key.private_key_pem
}
