module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name            = var.name
  cidr            = var.vpc_cidr
  azs             = local.az_list
  private_subnets = var.private_subnet_cidr
  public_subnets  = var.public_subnet_cidr

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = local.common_tags
}

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = var.name

  # Launch configuration
  lc_name = var.name

  image_id             = data.aws_ami.amazon_linux_ecs.id
  instance_type        = "t2.micro"
  security_groups      = [module.vpc.default_security_group_id]
  iam_instance_profile = module.ec2-profile.this_iam_instance_profile_id
  user_data            = data.template_file.user_data.rendered

  # Auto scaling group
  asg_name                  = var.name
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 0
  wait_for_capacity_timeout = 0

  tags = [
  {
    key                 = "Environment"
    value               = var.env
    propagate_at_launch = true
  },
  {
    key                 = "Cluster"
    value               = var.name
    propagate_at_launch = true
  },
]
}

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  name   = var.name
}

module "ec2-profile" {
  source = "./modules/ecs-instance-profile"
  name   = var.name
}
