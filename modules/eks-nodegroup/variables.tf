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

variable "role_service" {
  type        = list(string)
  default     = ["eks.amazonaws.com"]
  description = "Aws service of the iam role"
}

variable "policy_arns" {
  description = "A list of managed IAM policies to attach to the IAM role"
  type        = list(string)
  default     = []
}

variable "role_service_managed" {
  type        = list(string)
  default     = ["ec2.amazonaws.com"]
  description = "Aws service of the iam role"
}

### eks new variables ########

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = false
}


variable "node_groups" {
  description = "(optional) Node groups to create within this EKS cluster"
  type = list(object({
    ami_type             = optional(string)
    capacity_type        = optional(string)
    disk_size            = optional(number)
    force_update_version = optional(bool)
    instance_types       = optional(list(string))
    labels               = optional(map(string))
    launch_template = optional(object({
      id      = optional(string)
      name    = optional(string)
      version = number
    }))
    name             = optional(string)
    name_prefix      = optional(string)
    type_of_instance = optional(string)
    remote_access = optional(object({
    }))
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
    tags = optional(map(string))
    taints = optional(list(object({
      key    = string
      value  = optional(string)
      effect = string
    })))
    update_config = optional(object({
      max_unavailable            = optional(number)
      max_unavailable_percentage = optional(number)
    }))
    version = optional(string)
  }))
  default = []
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
  default     = "15m"
}
variable "cluster_update_timeout" {
  description = "Timeout value when updating the EKS cluster."
  type        = string
  default     = "60m"
}

variable "root_block_size" {
  type        = string
  default     = "20"
  description = "Size of the root EBS block device"
}




variable "tags" {
  description = "(optional) Tags to assign to the cluster"
  type        = map(string)
  default     = null
}
variable "create" {
  description = "Use to toggle creation of sources by this module"
  type        = bool
  default     = true
}

variable "addon_version" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = null
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


################################################################################
# EKS Managed Node Group
################################################################################

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type        = any
  default     = {}
}



################################################################################
# Launch template
################################################################################

variable "create_launch_template" {
  description = "Determines whether to create a launch template or not. If set to `false`, EKS will use its own default launch template"
  type        = bool
  default     = true
}


variable "launch_template_id" {
  description = "The ID of an existing launch template to use. Required when `create_launch_template` = `false` and `use_custom_launch_template` = `true`"
  type        = string
  default     = ""
}

variable "launch_template_name" {
  description = "Name of launch template to be created"
  type        = string
  default     = null
}

variable "launch_template_use_name_prefix" {
  description = "Determines whether to use `launch_template_name` as is or create a unique name beginning with the `launch_template_name` as the prefix"
  type        = bool
  default     = true
}

variable "launch_template_description" {
  description = "Description of the launch template"
  type        = string
  default     = null
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance(s) will be EBS-optimized"
  type        = bool
  default     = null
}

variable "ami_id" {
  description = "The AMI from which to launch the instance. If not supplied, EKS will use its own default image"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "The key name that should be used for the instance(s)"
  type        = string
  default     = null
}


variable "launch_template_default_version" {
  description = "Default version of the launch template"
  type        = string
  default     = null
}

variable "update_launch_template_default_version" {
  description = "Whether to update the launch templates default version on each update. Conflicts with `launch_template_default_version`"
  type        = bool
  default     = true
}


variable "kernel_id" {
  description = "The kernel ID"
  type        = string
  default     = null
}

################################################################################
# EKS Managed Node Group
################################################################################


variable "name" {
  description = "Name of the EKS managed node group"
  type        = string
  default     = ""
}


variable "launch_template_version" {
  description = "Launch template version number. The default is `$Default`"
  type        = string
  default     = null
}


variable "timeouts" {
  description = "Create, update, and delete timeout configurations for the node group"
  type        = map(string)
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

