variable "parameter_vpc_id_name" {
  type        = string
  description = "Id of vpc stored in aws_ssm_parameter"
  default     = ""
}
variable "parameter_subnet_id1_name" {
  type        = string
  description = "Name of the subnet id stored in aws_ssm_parameter"
  default     = ""
}

variable "parameter_subnet_id2_name" {
  type        = string
  description = "Name of the subnet id stored in aws_ssm_parameter"
  default     = ""
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
  type        = string
}

#-----------AWS LB Ingress Controller-------------
variable "enable_aws_load_balancer_controller" {
  description = "Enable AWS Load Balancer Controller add-on"
  type        = bool
  default     = false
}

variable "aws_load_balancer_controller_helm_config" {
  description = "AWS Load Balancer Controller Helm Chart config"
  type        = any
  default     = {}
}

variable "eks_cluster_id" {
  description = "EKS Cluster Id"
  type        = string
}

variable "custom_image_registry_uri" {
  description = "Custom image registry URI map of `{region = dkr.endpoint }`"
  type        = map(string)
  default     = {}
}

variable "eks_oidc_provider" {
  type = any
}

variable "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  type        = string
  default     = ""
}

variable "eks_cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  type        = string
  default     = ""
}


variable "eks_cluster_version" {
  description = "The Kubernetes version for the cluster"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
  type        = map(string)
  default     = {}
}



variable "irsa_iam_role_path" {
  description = "IAM role path for IRSA roles"
  type        = string
  default     = "/"
}

variable "irsa_iam_permissions_boundary" {
  description = "IAM permissions boundary for IRSA roles"
  type        = string
  default     = ""
}

##enable_cni_metrics_helper

variable "enable_cni_metrics_helper" {
  description = "Enable cni metrics helper add-on"
  type        = bool
  default     = false
}

variable "cni_metrics_helper_templates_helm_config" {
  description = "cni metrics helper Helm Chart config"
  type        = any
  default     = {}
}

#external dns 
variable "eks_domain_env" {
  description = "[NONPROD/PROD] Pick one of the nonprod or prod to choose the domain for the EKS cluster"
  type        = string
  default     = ""
}

variable "enable_external_dns" {
  description = "External DNS add-on"
  type        = bool
  default     = false
}

variable "external_dns_role" {
  description = "Enable external dns assumption role"
  type        = string
  default     = ""
}

variable "external_dns_helm_config" {
  description = "External DNS Helm Chart config"
  type        = any
  default = {

  }
}

variable "external_dns_irsa_policies" {
  description = "Additional IAM policies for a IAM role for service accounts"
  type        = list(string)
  default     = []
}

variable "external_dns_private_zone" {
  type        = bool
  description = "Determines if referenced Route53 zone is private."
  default     = false
}

variable "external_dns_route53_zone_arns" {
  type    = list(string)
  default = []
}

#-----------COREDNS AUTOSCALER-------------
variable "enable_coredns_autoscaler" {
  description = "Enable CoreDNS autoscaler add-on"
  type        = bool
  default     = false
}

variable "coredns_autoscaler_helm_config" {
  description = "CoreDNS Autoscaler Helm Chart config"
  type        = any
  default     = {}
}

#-----------CLUSTER AUTOSCALER-------------
variable "enable_cluster_autoscaler" {
  description = "Enable Cluster autoscaler add-on"
  type        = bool
  default     = false
}

variable "cluster_autoscaler_helm_config" {
  description = "Cluster Autoscaler Helm Chart config"
  type        = any
  default     = {}
}

#-----------METRIC SERVER-------------
variable "enable_metrics_server" {
  description = "Enable metrics server add-on"
  type        = bool
  default     = false
}

variable "metrics_server_helm_config" {
  description = "Metrics Server Helm Chart config"
  type        = any
  default     = {}
}

#-----------kube state metrics-------------
variable "enable_kube_state_metrics" {
  description = "Enable kube state metrics add-on"
  type        = bool
  default     = false
}

variable "kube_state_metrics_helm_config" {
  description = "Metrics Server Helm Chart config"
  type        = any
  default     = {}
}

#-----------opa_gatekeeper-------------
variable "enable_opa_gatekeeper" {
  description = "Enable opa_gatekeeper add-on"
  type        = bool
  default     = false
}

variable "opa_gatekeeper_helm_config" {
  description = "opa_gatekeeper Helm Chart config"
  type        = any
  default     = {}
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


variable "opa_constraints_helm_config" {
  description = "gatekeeper constraints Helm Chart config"
  type        = any
  default     = {}
}

variable "opa_templates_helm_config" {
  description = "gatekeeper templates Helm Chart config"
  type        = any
  default     = {}
}

variable "enable_aws_efs_csi_driver" {
  description = "Enable AWS EFS CSI Driver add-on"
  type        = bool
  default     = false
}

variable "efs_csi_driver_templates_helm_config" {
  description = "Enable AWS EFS CSI Driver add-on for Helm Chart config"
  type        = any
  default     = {}
}

variable "enable_self_managed_aws_ebs_csi_driver" {
  description = "Enable AWS EFS CSI Driver add-on"
  type        = bool
  default     = false
}

variable "ebs_csi_driver_templates_helm_config" {
  description = "Enable AWS EFS CSI Driver add-on for Helm Chart config"
  type        = any
  default     = {}
}




variable "enable_fargate_efs" {
  description = "Enable AWS EFS for eks fargate"
  type        = bool
  default     = false
}

variable "efsvolumeid" {
  description = "EFS Volume ID"
  type        = string

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

variable "aws_for_fluentbit_helm_config" {
  description = "AWS for FluentBit Helm Chart config"
  type        = any
  default     = {}
}

variable "aws_for_fluentbit_irsa_policies" {
  description = "Additional IAM policies for a IAM role for service accounts"
  type        = list(string)
  default     = []
}

variable "aws_for_fluentbit_cw_log_group_name" {
  description = "FluentBit CloudWatch Log group name"
  type        = string
  default     = null
}

variable "aws_for_fluentbit_cw_log_group_retention" {
  description = "FluentBit CloudWatch Log group retention period"
  type        = number
  default     = 90
}

variable "aws_for_fluentbit_cw_log_group_kms_key_arn" {
  description = "FluentBit CloudWatch Log group KMS Key"
  type        = string
  default     = null
}

variable "external_sercrets_templates_helm_config" {
  description = "AWS external secerets Controller Helm Chart config"
  type        = any
  default     = {}
}

variable "enable_external_secrets" {
  description = "Enable AWS EFS for eks fargate"
  type        = bool
  default     = false
}

#-----------FARGATE FLUENT BIT-------------
variable "enable_fargate_fluentbit" {
  description = "Enable AWS for FluentBit add-on"
  type        = bool
  default     = false
}

variable "fargate_fluentbit_addon_config" {
  description = "Fargate fluentbit add-on config"
  type        = any
  default     = {}
}

variable "enable_fargate_insights" {
  description = "Enable AWS for FluentBit add-on"
  type        = bool
  default     = false
}

variable "aws_kms_key_arn" {
  description = "KMS encryption key for the EKS cluster"
  type        = string

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
  default     = []
}

variable "create_eks_dashboard" {
  description = "eks dashboard true/false"
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

}

variable "cpu-evaluation-periods" {
  description = "threshold percent as per user need to be set for fargate pod cpu"
  type        = number
  default     = 0
}
variable "fargate-cpu-threshold" {
  description = "threshold percent as per user need to be set for fargate pod cpu"
  type        = number
  default     = 0
}

variable "network-evaluation-period" {
  description = "threshold percent as per user need to be set for fargate pod cpu"
  type        = number
  default     = 0
}

variable "network-threshold" {
  description = "threshold percent as per user need to be set for fargate pod cpu"
  type        = number
  default     = 0
}
variable "fargate-mem-threshold" {
  description = "threshold percent as per user need to be set for fargate pod cpu"
  type        = number
  default     = 0
}

variable "mem-evaluation-periods" {
  description = "threshold percent as per user need to be set for fargate pod cpu"
  type        = number
  default     = 0

}

variable "enable_aws_cloudwatch_metrics" {
  description = "Enable AWS CloudWatch Metrics add-on for Container Insights"
  type        = bool
  default     = false
}

variable "aws_cloudwatch_metrics_helm_config" {
  description = "AWS CloudWatch Metrics Helm Chart config"
  type        = any
  default     = {}
}

variable "aws_cloudwatch_metrics_irsa_policies" {
  description = "Additional IAM policies for a IAM role for service accounts"
  type        = list(string)
  default     = []
}

variable "parameter_subnet_id3_name" {
  type        = string
  description = "Name of the subnet id stored in aws_ssm_parameter"
}
