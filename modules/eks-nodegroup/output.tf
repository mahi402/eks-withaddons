output "cluster_id" {
  description = "The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready"
  value       = try(aws_eks_cluster.eks_cluster.id, "")
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API."
  value       = try(aws_eks_cluster.eks_cluster.endpoint, "")
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = try(aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "")
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = try(aws_eks_cluster.eks_cluster.certificate_authority[0].data, "")
}

/* output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if `enable_irsa = true`"
  value       = try(aws_iam_openid_connect_provider.oidc_provider[0].arn, null)
} */

output "node_group" {
  description = "node groups"
  value       = aws_eks_node_group.eks-nodegroup[*]
}


output "kubeproxy-status" {
  description = "addon-kubeproxy status"
  value       = try(aws_eks_addon.addon-kubeproxy.id, "")

}
################################################################################
# IRSA
################################################################################

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value       = try(replace(aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", ""), "")
}