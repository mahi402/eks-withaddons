variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}

variable "policy_file_name" {
  description = "The name of the policy"
  type        = string
  default     = "policy.json"
}

variable "eks_cluster_id" {
  description = "EKS Cluster Id"
  type        = string
}

