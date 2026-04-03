
output "cluster_arn" {
  value       = aws_eks_cluster.main.arn
  description = "ARN of the EKS cluster"
}

output "cluster_id" {
  value       = aws_eks_cluster.main.id
  description = "ID of the EKS Cluster"
}

output "cluster_oidc_provider" {
  value       = aws_eks_cluster.main.identity[0].oidc[0]["issuer"]
  description = "Issuer for cluster's OIDC provider"
}
