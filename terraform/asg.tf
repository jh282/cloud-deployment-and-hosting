## ASG for ECS EC2 Instances

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = var.name

  # Launch config
  lc_name              = var.name
  image_id             = data.aws_ami.amazon_linux_ecs.id
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.ecs_ec2.id]
  iam_instance_profile = aws_iam_instance_profile.ecs_ec2.id
  user_data            = data.template_file.user_data.rendered

  # Auto scaling group
  asg_name                  = var.name
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_type         = "EC2"
  min_size                  = var.min_ec2_capacity
  max_size                  = var.max_ec2_capacity
  desired_capacity          = var.desired_ec2_capacity
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

## ECS EC2 Security Group

resource "aws_security_group" "ecs_ec2" {
  name   = "${var.name}_ec2"
  vpc_id = module.vpc.vpc_id

  ingress {
    description     = "Inbound from ALB SG"
    from_port       = 1024
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "To AWS API"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## ECS EC2 IAM

resource "aws_iam_role" "ecs_ec2" {
  name = "${var.name}-ecs-instance-role"
  path = "/ecs/"

  assume_role_policy = data.template_file.ec2_assume_role_policy.rendered
}

resource "aws_iam_instance_profile" "ecs_ec2" {
  name = "${var.name}-ecs-instance-profile"
  role = aws_iam_role.ecs_ec2.name
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_container" {
  role       = aws_iam_role.ecs_ec2.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch" {
  role       = aws_iam_role.ecs_ec2.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
