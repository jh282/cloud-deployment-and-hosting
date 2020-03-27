module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v2.0"

  name            = var.name
  cidr            = var.vpc_cidr
  azs             = local.az_list
  private_subnets = var.private_subnet_cidr
  public_subnets  = var.public_subnet_cidr

  map_public_ip_on_launch = false

  enable_nat_gateway = true
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
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.ec2.id]
  iam_instance_profile = module.ec2_profile.this_iam_instance_profile_id
  user_data            = data.template_file.user_data.rendered

  # Auto scaling group
  asg_name                  = var.name
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = var.name
      propagate_at_launch = true
    },
    {
      key                 = "Cluster"
      value               = var.name
      propagate_at_launch = true
    }
  ]
}

resource "aws_security_group" "ec2" {
  name   = "${var.name}-ec2"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Inbound from ALB"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = module.vpc.public_subnets_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "ec2_profile" {
  source = "./modules/ecs-instance-profile"
  name   = var.name
}
