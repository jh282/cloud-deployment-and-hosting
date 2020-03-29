## ALB in public subnet, listening for HTTP requests

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = var.name

  load_balancer_type = "application"

  subnets         = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id
  security_groups = [aws_security_group.alb.id]

  http_tcp_listeners = [
    {
      port               = var.container_port
      protocol           = var.container_protocol
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name_prefix      = var.name
      backend_protocol = var.container_protocol
      backend_port     = var.container_port
      target_type      = "instance"
    }
  ]

  tags = local.common_tags
}

## ALB Security Group

resource "aws_security_group" "alb" {
  name   = "${var.name}-alb"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Limit egress only to ECS EC2 Security Group

resource "aws_security_group_rule" "to_ecs" {
  description              = "To backend ECS"
  type                     = "egress"
  from_port                = 1024
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_ec2.id
  security_group_id        = aws_security_group.alb.id
}
