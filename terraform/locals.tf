locals {
  common_tags = {
    Terraform = "true"
  }
  
  az_list = ["${var.region}${var.availability_zones[0]}", "${var.region}${var.availability_zones[1]}", "${var.region}${var.availability_zones[2]}"]
}
