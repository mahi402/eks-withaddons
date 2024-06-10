
variable "addon_context" {
  description = "Input configuration for the addon"
  type = object({
    aws_caller_identity_account_id = string
    aws_caller_identity_arn        = string
    aws_eks_cluster_endpoint       = string
    aws_partition_id               = string
    aws_region_name                = string
    eks_cluster_id                 = string
    eks_oidc_issuer_url            = string
    eks_oidc_provider_arn          = string
    tags                           = map(string)
    irsa_iam_role_path             = string
    irsa_iam_permissions_boundary  = string
  })
}

variable "sns-topic" {
  description = "input email for alarm notification"
  type        = string

}

variable "fargate-cpu-threshold" {
  description = "threshold percent as per user need to be set for fargate pod cpu"
  type        = number

}

variable "cpu-evaluation-periods" {
  description = "threshold percent as per user need to be set for fargate pod cpu"
  type        = number

}

variable "network-evaluation-period" {
  description = "threshold percent as per user need to be set for fargate pod cpu"
  type        = number

}

variable "network-threshold" {
  description = "threshold percent as per user need to be set for fargate pod cpu"
  type        = number

}

variable "fargate-mem-threshold" {
  description = "threshold percent as per user need to be set for fargate pod cpu"
  type        = number

}

variable "mem-evaluation-periods" {
  description = "threshold percent as per user need to be set for fargate pod cpu"
  type        = number

}