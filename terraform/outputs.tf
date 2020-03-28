output "website_address" {
  value = module.alb.this_lb_dns_name
}

output "ecr_url" {
  vault = aws_ecr_repository.cdah.repository_url
}
