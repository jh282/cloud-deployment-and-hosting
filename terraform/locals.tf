locals {
  az_list = [
    for az in var.availability_zones :
    "${var.region}${az}"
  ]

  common_tags = {
    name      = var.name
    Terraform = "true"
  }
}
