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
