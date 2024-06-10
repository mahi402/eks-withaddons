variable "eks_cluster_id" {
  description = "EKS Cluster ID"
  type        = string
}

variable "create_kubernetes_namespace" {
  description = "Should the module create the namespace"
  type        = bool
  default     = true
}
