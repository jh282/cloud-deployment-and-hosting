variable "name" {
  type    = string
  default = "cdah"
}

variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "Default region for AWS resources"
}

# VPC Variables

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "private_subnet_cidr" {
  type        = list
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "List of private subnet CIDR blocks"
}

variable "public_subnet_cidr" {
  type        = list
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  description = "List of public subnet CIDR blocks"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["a", "b", "c"]
  description = "List of Availability Zones (excluding region)"
}

# ASG Variables

variable "min_ec2_capacity" {
  type        = number
  default     = 1
  description = "Minimum number of EC2 instances to run in ASG"
}

variable "max_ec2_capacity" {
  type        = number
  default     = 3
  description = "Maximum number of EC2 instances to run in ASG"
}

variable "desired_ec2_capacity" {
  type        = number
  default     = 1
  description = "Desired number of EC2 instances to run in ASG"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Default instance size for ecs instances"
}

# ECS Variables

variable "container_port" {
  type        = number
  default     = 80
  description = "Port container will listen on"
}

variable "container_protocol" {
  type        = string
  default     = "HTTP"
  description = "Protocol the container will listen on"
}

variable "min_ecs_capacity" {
  type        = number
  default     = 1
  description = "Minimum number of containers to run in ECS service"
}

variable "max_ecs_capacity" {
  type        = number
  default     = 15
  description = "Maximum number of containers to run in ECS service"
}

variable "desired_ecs_capacity" {
  type        = number
  default     = 1
  description = "Desired number of containers to run in ECS service"
}
