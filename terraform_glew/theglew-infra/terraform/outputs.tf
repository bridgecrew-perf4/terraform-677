# outputs.tf

output "alb_production_hostname" {
  value = aws_alb.production.dns_name
}

output "alb_develop_hostname" {
  value = aws_alb.develop.dns_name
}

output "alb_staging_hostname" {
  value = aws_alb.staging.dns_name
}
