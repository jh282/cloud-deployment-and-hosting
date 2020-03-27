module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = var.name

  load_balancer_type = "application"

  subnets         = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id
  security_groups = [aws_security_group.alb_sg.id]

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

resource "aws_security_group" "alb_sg" {
  name   = "${var.name}-alb"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "To backend ECS"
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
  }
}
