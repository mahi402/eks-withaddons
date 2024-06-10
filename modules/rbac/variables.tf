variable "application_teams" {
  description = "Map of maps of teams to create"
  type        = any
  default     = {}
}

variable "platform_teams" {
  description = "Map of maps of teams to create"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "eks_cluster_id" {
  description = "EKS Cluster name"
  type        = string
}

variable "eks_oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  type        = string
  default     = null
}

variable "eks_cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  type        = string
  default     = null
}

variable "managed_node_groups" {
  type        = bool
  description = "Set this value to true if managed node groups are created , for fargate its false"
  default     = false
}
variable "map_roles" {
  type        = list(any)
  description = "Allow list of iam roles to access kubernetes cluster which will be added to masters group(admin)"
  default     = []
}
variable "map_users" {
  type        = list(any)
  description = "Allow users to access kubernetes cluster"
  default     = []
}
variable "map_accounts" {
  type        = list(string)
  description = "Allow accounts to access kubernetes cluster, specially cross account"
  default     = []
}
variable "application_team_role" {
  type        = string
  description = "Allow iam roles to allow limited access to the namespaces but no to the entire cluster"
  default     = ""
}
variable "readonly_roles" {
  type        = list(string)
  description = "Just readonly permissions for the whole cluster, please pass in role names"
  default     = []
}

variable "create_aws_auth_configmap" {
  description = "Where to create auth map or not"
  type        = bool
  default     = false
}

variable "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  type        = string
  default     = ""
}
variable "iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "create" {
  type        = bool
  description = "create"
  default     = true
}

variable "wait_for_cluster_timeout" {
  description = "A timeout (in seconds) to wait for cluster to be available."
  type        = number
  default     = 300
}

variable "fargate_type" {
  description = "fargate iam role arn"
  type        = bool
  default     = false
}
