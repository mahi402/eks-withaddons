output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks-fargate.cluster_id
}

output "oidc_provider_url" {

  description = "oidc provider url"
  value       = module.eks-fargate.cluster_oidc_issuer_url
}

output "oidc_provider" {
  description = "oidc provider with out https://"
  value       = module.eks-fargate.oidc_provider

}

/* output "codebuild_role_arn" {
  value       = module.codebuild_iam_role_eks[*].role_arn
  description = "The Amazon Resource Name (ARN) specifying the code build role"
} */