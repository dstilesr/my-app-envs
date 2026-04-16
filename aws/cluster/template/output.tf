output "region" {
  description = "AWS Region where cluster is deployed"
  value       = var.region
}

output "cluster_arn" {
  value       = aws_eks_cluster.main.arn
  description = "ARN of the EKS cluster"
}

output "cluster_id" {
  value       = aws_eks_cluster.main.id
  description = "ID of the EKS Cluster"
}

output "cluster_name" {
  value       = aws_eks_cluster.main.id
  description = "Name of the EKS Cluster"
}

output "cluster_oidc_provider" {
  value       = aws_eks_cluster.main.identity[0].oidc[0]["issuer"]
  description = "Issuer for cluster's OIDC provider"
}

output "node_group_arns" {
  description = "ARNs of the cluster node groups"
  value       = { for k, v in aws_eks_node_group.main_groups : k => v.arn }
}

output "node_group_capacity_types" {
  description = "Capacity Types of the cluster node groups"
  value       = { for k, v in aws_eks_node_group.main_groups : k => v.capacity_type }
}

output "node_group_subnets" {
  description = "Subnets for the cluster node groups"
  value       = { for k, v in aws_eks_node_group.main_groups : k => v.subnet_ids }
}
