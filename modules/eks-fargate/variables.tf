# EKS Cluster Variables Configuration
variable "cluster_name" {
  type        = string
  description = "The name of your EKS Cluster"
  validation {
    condition     = 20 >= length(var.cluster_name) && length(var.cluster_name) > 0 && can(regex("^[0-9A-Za-z][A-Za-z0-9-_]+$", var.cluster_name))
    error_message = "'cluster_name' should be between 1 and 20 characters, start with alphanumeric character and contain alphanumeric characters, dashes and underscores."
  }
}

variable "k8s-version" {
  type        = string
  description = "Required K8s version"
  validation {
    condition     = can(regex("^[0-9].[0-9][0-9]+$", var.k8s-version))
    error_message = "k8s-version to be among 1.22, 1.23."
  }
}
variable "policy_arns" {
  description = "A list of managed IAM policies to attach to the IAM role"
  type        = list(string)
  default     = []
}

variable "role_service_fargate" {
  type        = list(string)
  default     = ["eks-fargate-pods.amazonaws.com", "eks.amazonaws.com"]
  description = "Aws service of the iam role"
}



#########Cloudwatch logs for EKS cLuster

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "cluster_service_ipv4_cidr" {
  description = "service ipv4 cidr for the kubernetes cluster"
  type        = string
  default     = null
}

variable "cluster_create_timeout" {
  description = "Timeout value when creating the EKS cluster."
  type        = string
  default     = "30m"
}
variable "cluster_delete_timeout" {
  description = "Timeout value when deleting the EKS cluster."
  type        = string
  default     = "30m"
}

### addons variables ##########
variable "vpcni" {
  type        = string
  description = "vpc cni name"
  default     = "vpc-cni"
}

variable "kube_proxy" {
  type        = string
  description = "kube proxy name"
  default     = "kube-proxy"
}
variable "addon_version" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = null
}

variable "additional_sg_cidr_ingress_rules" {
  description = "Ingress rule for the CIDR network range"
  type = list(object({
    from             = number
    to               = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    description      = string
  }))
  default = []
}

variable "additional_sg_cidr_egress_rules" {
  description = "Egress rule for the CIDR network range"
  type = list(object({
    from             = number
    to               = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    description      = string
  }))
  default = []
}
# Variables for aws_ssm_parameter


variable "parameter_vpc_id_name" {
  type        = string
  description = "Id of vpc stored in aws_ssm_parameter"
}

variable "parameter_subnet_id1_name" {
  type        = string
  description = "Name of the subnet id stored in aws_ssm_parameter"
}

variable "parameter_subnet_id2_name" {
  type        = string
  description = "Name of the subnet id stored in aws_ssm_parameter"
}

variable "parameter_subnet_id3_name" {
  type        = string
  description = "Name of the subnet id stored in aws_ssm_parameter"
}


variable "AppID" {
  description = "Identify the application this asset belongs to by its AMPS APP ID.Format = APP-####"
  type        = number
}

variable "Environment" {
  type        = string
  description = "The environment in which the resource is provisioned and used, such as Dev, Test, QA, Prod."
}

variable "tags" {
  description = "(optional) Tags to assign to the cluster"
  type        = map(string)
  default     = null
}




variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = true
}

variable "aws_kms_key_arn" {
  description = "KMS encryption key for the EKS cluster"
  type        = string
  validation {
    condition     = var.aws_kms_key_arn == null || can(regex("^arn:aws:kms:\\w+(?:-\\w+)+:[[:digit:]]{12}:key/([a-zA-Z0-9])+(.*)$", var.aws_kms_key_arn))
    error_message = "KMS ARN is required and the allowed format is arn:aws:kms:us-west-2:514712703977:key/e41b54e1-23ca-4906-8ca0-417f10463731"
  }

}


variable "resources" {
  description = "(Required) List of strings with resources to be encrypted."
  type        = list(string)
  default     = ["secrets"]
}


