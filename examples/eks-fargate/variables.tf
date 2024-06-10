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

variable "eks-param-name" {
  type        = string
  description = "the eks cluster parameter store name"
  default     = null
}

variable "efsvolumeid" {
  description = "EFS Volume ID"
  type        = string

}

variable "enable_external_secrets" {
  description = "Enable AWS externalsecrets for eks "
  type        = bool
  default     = false
}

variable "account_num" {
  type        = string
  description = "Target AWS account number, mandatory"

}


variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "user" {
  description = "User id for aws session"
  type        = string
  default     = "rh1b"
}

variable "fargate_type" {
  description = "fargate iam role arn"
  type        = bool
  default     = true
}
variable "managed_node_groups" {
  type        = bool
  description = "Determines if managed node groups are provisioned"
  default     = false
}

variable "aws_role" {
  description = "AWS role to assume"
  type        = string
  default     = "eks-test"
}


######### app #######
variable "AppID" {
  description = "Identify the application this asset belongs to by its AMPS APP ID.Format = APP-####"
  type        = number
}

variable "Environment" {
  type        = string
  description = "The environment in which the resource is provisioned and used, such as Dev, Test, QA, Prod."
}

variable "DataClassification" {
  type        = string
  description = "Classification of data - can be made conditionally required based on Compliance.One of the following: Public, Internal, Confidential, Restricted, Privileged (only one)"
}

variable "Compliance" {
  type        = list(string)
  description = "Compliance	Identify assets with compliance requirements (SOX, HIPAA, etc.) Note: not adding NERC workloads to cloud"
}

variable "CRIS" {
  type        = string
  description = "Cyber Risk Impact Score High, Medium, Low (only one)"
}


variable "Notify" {
  type        = list(string)
  description = "Who to notify for system failure or maintenance. Should be a group or list of email addresses."
}

variable "Owner" {
  type        = list(string)
  description = "List three owners of the system, as defined by AMPS Director, Client Owner and IT Leadeg LANID1_LANID2_LANID3"
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

variable "enable_aws_load_balancer_controller" {
  description = "Enable AWS Load Balancer Controller add-on"
  type        = bool
  default     = false
}

#-----------kube state metrics-------------
variable "enable_kube_state_metrics" {
  description = "Enable kube state metrics add-on"
  type        = bool
  default     = false
}


variable "create_codebuild_iam_role_eks" {
  description = "apply create_codebuild_iam_role_eks"
  type        = bool
  default     = true
}


#####codebuild role

variable "policy_file_name" {
  description = "The name of the policy"
  type        = string
  default     = "policy.json"
}


########values for eks external-dns

variable "external_dns_role" {
  description = "Enable external dns assumption role"
  type        = string
  default     = ""
}
variable "eks_domain_env" {
  description = "Enable external dns add-on"
  type        = string
  default     = "nonprod"
}

variable "enable_external_dns" {
  description = "Enable external dns add-on"
  type        = bool
  default     = false
}

variable "aws_kms_key_arn" {
  description = "KMS encryption key for the EKS cluster"
  type        = string
  validation {
    condition     = var.aws_kms_key_arn == null || can(regex("^arn:aws:kms:\\w+(?:-\\w+)+:[[:digit:]]{12}:key/([a-zA-Z0-9])+(.*)$", var.aws_kms_key_arn))
    error_message = "KMS ARN is required and the allowed format is arn:aws:kms:us-west-2:514712703977:key/e41b54e1-23ca-4906-8ca0-417f10463731"
  }

}

variable "enable_fargate_efs" {
  description = "Enable AWS EFS for eks fargate"
  type        = bool
  default     = false
}





variable "enable_fargate_fluentbit" {
  description = "Enable AWS for FluentBit add-on"
  type        = bool
  default     = false
}

variable "enable_fargate_insights" {
  description = "Enable AWS for FluentBit add-on"
  type        = bool
  default     = false
}

variable "create_fargatecloudwatch_dashboards" {
  description = "Enable cloudwatch dashboards for eks fargate"
  type        = bool
  default     = false
}


variable "create_fargatecloudwatch_alarms" {
  description = "Enable cloudwatch alarms for eks fargate"
  type        = bool
  default     = false
}

variable "sns-topic" {
  description = "input email for alarm notification"
  type        = string
  default     = ""
}

variable "cpu-evaluation-periods" {
  description = "threshold percent as per user need to be set for fargate pod cpu"
  type        = number

}
variable "fargate-cpu-threshold" {
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


variable "application_team_role" {
  description = "The iam role by adfs which will be used by the application_team to perform kubeapi calls"
  type        = string
  default     = "SuperAdmin"
}

variable "readonly_roles" {
  type        = list(string)
  description = " List of iam roles by adfs that would support the namespaces for troubleshooting"
  default     = ["readonly"]
}
variable "create_aws_auth_configmap" {
  description = "Where to create auth map or not"
  type        = bool
  default     = false
}
