######## output file  #############
output "cluster_id" {
  description = "The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready"
  value       = try(aws_eks_cluster.eks-cluster.id, "")
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = try(aws_eks_cluster.eks-cluster.endpoint, "")
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = try(aws_eks_cluster.eks-cluster.certificate_authority[0].data, "")
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = try(aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer, "")
}

################################################################################
# IRSA
################################################################################

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value       = try(replace(aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer, "https://", ""), "")
}

output "cluster_security_group_id" {
  description = "the cluster security to be passed to other modules"
  value       = aws_eks_cluster.eks-cluster.vpc_config[0].cluster_security_group_id
}

output "fargate_profiles" {
  description = "fargate profiles"
  value       = aws_eks_fargate_profile.fargate-default[*]
}

output "aws_iam_fargate_arn" {
  description = "fargate role for auth config map"
  value       = module.aws_iam_fargate.arn
}