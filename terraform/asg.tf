module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = var.name

  # Launch configuration
  lc_name = var.name

  image_id             = data.aws_ami.amazon_linux_ecs.id
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.ecs_ec2.id]
  iam_instance_profile = aws_iam_instance_profile.ecs_ec2.id
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

resource "aws_security_group" "ecs_ec2" {
  name   = "${var.name}-ec2"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Inbound from ALB"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ecs_ec2" {
  name = "${var.name}_ecs_instance_role"
  path = "/ecs/"

  assume_role_policy = data.template_file.ec2_assume_role_policy.rendered
}

resource "aws_iam_instance_profile" "ecs_ec2" {
  name = "${var.name}_ecs_instance_profile"
  role = aws_iam_role.ecs_ec2.name
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_container" {
  role = aws_iam_role.ecs_ec2.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch" {
  role = aws_iam_role.ecs_ec2.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
