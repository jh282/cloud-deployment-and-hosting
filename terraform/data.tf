## Source correct ECS optimised image

data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

## Create user-data for ECS optimised EC2 instance

data "template_file" "user_data" {
  template = file("${path.module}/templates/user-data.tpl")

  vars = {
    name = module.ecs.this_ecs_cluster_name
  }
}

## Create container def for image

data "template_file" "container_definition" {
  template = file("${path.module}/templates/container_definition.tpl")

  vars = {
    name           = var.name
    container_port = var.container_port
    image          = data.aws_ecr_repository.cdah.repository_url
  }
}

data "template_file" "ecs_assume_role_policy" {
  template = file("${path.module}/templates/assume_role_policy.tpl")

  vars = {
    role = "ecs"
  }
}

data "template_file" "ec2_assume_role_policy" {
  template = file("${path.module}/templates/assume_role_policy.tpl")

  vars = {
    role = "ec2"
  }
}

## Source correct ECR repo

data "aws_ecr_repository" "cdah" {
  name = var.name
}
