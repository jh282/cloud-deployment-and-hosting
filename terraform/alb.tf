# module "alb" {
#   source  = "terraform-aws-modules/alb/aws"
#   version = "~> 5.0"
#
#   name = "external"
#
#   load_balancer_type = "application"
#
#   subnets         = module.vpc.public_subnets
#   vpc_id          = module.vpc.vpc_id
#   security_groups = list
#
#   https_listeners = [
#     {
#       port               = 443
#       protocol           = "HTTPS"
#       # certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
#       target_group_index = 0
#     }
#   ]
#
#   target_groups = [
#     {
#       name_prefix      = "default"
#       backend_protocol = "HTTP"
#       backend_port     = 80
#       target_type      = "instance"
#     }
#   ]
#
#   tags = local.tags
# }
