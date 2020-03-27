variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "Default region for AWS resources"
}

variable "name" {
  type    = string
  default = "cdah"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC resource"
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

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Default instance size for ecs instances"
}

variable "container_port" {
  type        = number
  default     = 80
  description = "Port container will listen on"
}

variable "container_protocol" {
  type        = string
  default     = "HTTP"
  description = "Port container will listen on"
}
