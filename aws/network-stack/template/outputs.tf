
output "lbc_iam_role_arn" {
  value       = aws_iam_role.lbc.arn
  description = "ARN of role used for Load Balancer Controller"
}

output "lbc_service_account_name" {
  value       = local.lbc_service_account_name
  description = "Name of service account for LBC in Kubernetes"
}
