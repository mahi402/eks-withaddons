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



variable "role_service" {
  type        = list(string)
  default     = ["eks.amazonaws.com"]
  description = "Aws service of the iam role"
}


variable "role_service_managed" {
  type        = list(string)
  default     = ["ec2.amazonaws.com"]
  description = "Aws service of the iam role"
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



variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

variable "veleros3bucket" {
  description = "AWS region"
  default     = ""
  type        = string
}

### eks new variables ########

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  type        = bool
  default     = true
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

variable "root_block_size" {
  type        = string
  default     = "20"
  description = "Size of the root EBS block device"
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


variable "enable_aws_load_balancer_controller" {
  description = "Enable AWS Load Balancer Controller add-on"
  type        = bool
  default     = false
}

variable "enable_cni_metrics_helper" {
  description = "Enable CNI metrics helper add-on"
  type        = bool
  default     = false
}

variable "enable_aws_efs_csi_driver" {
  description = "Enable AWS EFS CSI Driver add-on"
  type        = bool
  default     = false
}

variable "enable_external_dns" {
  description = "Enable external dns add-on"
  type        = bool
  default     = false
}


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


variable "managed_node_groups" {
  type        = bool
  description = "Determines if managed node groups are provisioned"
  default     = false
}

variable "fargate_type" {
  description = "fargate iam role arn"
  type        = bool
  default     = false
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

#-----------COREDNS AUTOSCALER-------------
variable "enable_coredns_autoscaler" {
  description = "Enable CoreDNS autoscaler add-on"
  type        = bool
  default     = false
}


#-----------CLUSTER AUTOSCALER-------------
variable "enable_cluster_autoscaler" {
  description = "Enable Cluster autoscaler add-on"
  type        = bool
  default     = false
}


#-----------METRIC SERVER-------------
variable "enable_metrics_server" {
  description = "Enable metrics server add-on"
  type        = bool
  default     = false
}


#-----------kube state metrics-------------
variable "enable_kube_state_metrics" {
  description = "Enable kube state metrics add-on"
  type        = bool
  default     = false
}


#-----------opa_gatekeeper-------------
variable "enable_opa_gatekeeper" {
  description = "Enable opa_gatekeeper add-on"
  type        = bool
  default     = false
}


variable "enable_opa_templates" {
  description = "apply gatekeeper templates"
  type        = bool
  default     = false
}

variable "enable_opa_constraints" {
  description = "apply gatekeeper templates"
  type        = bool
  default     = false
}



# codebuild iam role 
variable "policy_file_name" {
  description = "The name of the policy"
  type        = string
  default     = "policy.json"
}

variable "create_codebuild_iam_role_eks" {
  description = "apply create_codebuild_iam_role_eks"
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

variable "enable_prisma_twistlock_defender" {
  description = "to enable true or false to install twistlock defender deamonset on eks nodegroup"
  type        = bool
  default     = false
}

#-----------AWS FOR FLUENT BIT-------------
variable "enable_aws_for_fluentbit" {
  description = "Enable AWS for FluentBit add-on"
  type        = bool
  default     = false
}


variable "enable_external_secrets" {
  description = "Enable AWS externalsecrets for eks "
  type        = bool
  default     = false
}



variable "enable_self_managed_aws_ebs_csi_driver" {
  description = "Enable AWS EFS CSI Driver add-on"
  type        = bool
  default     = false
}


variable "account_num" {
  type        = string
  description = "Target AWS account number, mandatory"

}

variable "aws_role" {
  description = "AWS role to assume"
  type        = string
  default     = "eks-test"
}

variable "user" {
  description = "User id for aws session"
  type        = string
  default     = "rh1b"
}

#-----------AWS CloudWatch Metrics-------------
variable "enable_aws_cloudwatch_metrics" {
  description = "Enable AWS CloudWatch Metrics add-on for Container Insights"
  type        = bool
  default     = false
}


variable "cluster_dimensions" {
  description = "List of metrics to notify. <br>metric_name is the metric name to be notified. <br>comparison_operator is the type of comparison operation. <br>period is the aggregation period (seconds). <br>statistic is the type of statistics. <br>threshold is the threshold. <br>Specify an empty map if you do not want to notify Cluster level alerts."
  type = map(object({
    metric_name         = string
    comparison_operator = string
    period              = string
    statistic           = string
    threshold           = string
  }))
  default = {}
}

variable "namespace_dimensions" {
  description = "List of metrics to notify. <br>metric_name is the metric name to be notified. <br>period is the aggregation period (seconds). <br>statistic is the type of statistics. <br>threshold is the threshold. <br>namespace is the namespace name to be notified. <br>Specify an empty map if you do not want to notify Namespace level alerts."
  type = map(object({
    metric_name         = string
    comparison_operator = string
    period              = string
    statistic           = string
    threshold           = string
    namespace           = string
  }))
  default = {}
}

variable "service_dimensions" {
  description = "List of metrics to notify. <br>metric_name is the metric name to be notified. <br>period is the aggregation period (seconds). <br>statistic is the type of statistics. <br>threshold is the threshold. <br>namespace is the name of the namespace where the notification target Service operates. <br>Service is the Pod name to be notified. <br>Specify an empty map if you do not want to notify Service level alerts."
  type = map(object({
    metric_name         = string
    comparison_operator = string
    period              = string
    statistic           = string
    threshold           = string
    namespace           = string
    service             = string
  }))
  default = {}
}

variable "pod_dimensions" {
  description = "List of metrics to notify. <br>metric_name is the metric name to be notified. <br>period is the aggregation period (seconds). <br>statistic is the type of statistics. <br>threshold is the threshold. <br>namespace is the name of the namespace where the pod to be notified runs. <br>Pod is the pod name to be notified. <br>Specify an empty map if you do not want to perform Pod-level alert notifications."
  type = map(object({
    metric_name         = string
    comparison_operator = string
    period              = string
    statistic           = string
    threshold           = string
    namespace           = string
    pod                 = string
  }))
  default = {}
}

variable "endpoint" {
  description = "Notifications"
  type        = list(string)
}

variable "create_eks_dashboard" {
  description = "eks dashboard true/false"
  type        = bool
}


variable "sns-topic" {
  description = "input email for alarm notification"
  type        = string
  default     = ""
}

variable "efsvolumeid" {
  description = "EFS Volume ID"
  type        = string

}

