module "skeleton" {
  source = "../../skeleton/main"

  env                         = "dev"
  cidr_block                  = "192.168.0.0/16"
  public_subnets              = ["192.168.0.0/24", "192.168.1.0/24"]
  private_subnets             = ["192.168.3.0/24", "192.168.4.0/24"]
  single_nat_gateway          = true
  instance_type               = "t3.micro"
  bastion_allowed_cidr_blocks = ["14.186.116.64/32"]
  min_size                    = 1
  max_size                    = 1
  desired_capacity            = 1
  limited_s3_bucket           = ["tet-archive"]
  webapp_block_device_mapping = [
    {
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 8
        volume_type           = "gp2"
      }
    },
    {
      device_name = "/dev/sda1"
      no_device   = 1
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 8
        volume_type           = "gp2"
      }
    }
  ]
  sns_topic_arn       = "arn:aws:sns:ap-southeast-1:267583709295:general-notification"
  schedule_expression = "rate(5 minutes)"


}
