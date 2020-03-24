locals {
  env                   = substr(var.env, 0, 3)
  name                  = "${var.name}-${local.env}"

  az_list = [
      for az in var.availability_zones:
      "${var.region}${az}"
    ]

  common_tags = {
    name      = var.name
    Terraform = "true"
  }
}
