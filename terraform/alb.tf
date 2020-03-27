output "alb_public_address" {
  value = "${module.alb.this_lb_dns_name}"
}

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
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name_prefix      = "cdah"
      backend_protocol = "HTTP"
      backend_port     = 80
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
