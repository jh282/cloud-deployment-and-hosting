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
