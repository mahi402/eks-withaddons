## BASIC Configuration:  Please review and validate the values below
account_num        = "976679223297"
aws_region         = "us-west-2"
aws_role           = "CloudAdmin"
user               = "sdfds"
AppID              = "3402"
Environment        = "Dev"      #Dev, Test, QA, Prod (only one) */
DataClassification = "Internal" #Public, Internal, Confidential, Restricted, Privileged (only one)
CRIS               = "Low"      #"Cyber Risk Impact Score High, Medium, Low (only one)"
Notify             = ["dfsd@tek.com", "df@tek.com", "fsd@tek.com"]
Owner              = ["sdf", "sdf", "dsfd"] #"List three owners of the system, as defined by AMPS Director, Client Owner and IT Leadeg"
Compliance         = ["SOX", "HIPAA"]


##### EKS managed node group ##################
node_groups = [
  {
    name             = "node-group-1"
    ami_type         = "AL2_x86_64"
    instance_types   = ["t2.large"]
    type_of_instance = "t2.large"
    labels           = { Environment = "tekyantra" }
    scaling_config = {
      desired_size = 1
      max_size     = 15
      min_size     = 1
    }
  },
  {
    name             = "node-group-2"
    ami_type         = "AL2_x86_64"
    instance_types   = ["t2.xlarge"]
    type_of_instance = "t2.xlarge"
    scaling_config = {
      desired_size = 1
      max_size     = 15
      min_size     = 1
    }
  }
]

## Advanced Configuration: No need to customize anything below this point
######## service account #############
#aws_ssm_parameter ####
parameter_vpc_id_name     = "/vpc/id"
parameter_subnet_id1_name = "/vpc/privatesubnet1/id"
parameter_subnet_id2_name = "/vpc/privatesubnet3/id"
parameter_subnet_id3_name = "/vpc/privatesubnet2/id"

k8s-version     = "1.24"
cluster_name    = "rocon-internal"

##KMS key for encrypting the EKS cluster
aws_kms_key_arn = "arn:aws:kms:us-west-2:976679223297:key/826da770-ab2c-4556-b105-f67781fa2c6f"
# Choose the required addons and set the values to true to install
enable_aws_load_balancer_controller = true
enable_cni_metrics_helper           = true

enable_external_dns = true
eks_domain_env      = "nonprod"

#uncomment if creating the cluster in non shared account, also this is diff for prod account
#external_dns_role = "arn:aws:iam::514712703977:role/TFCBR53Role"

efsvolumeid               = "fs-abcedf" # this is fargate-efs module.
enable_aws_efs_csi_driver = true
#rbac variables
managed_node_groups = true


enable_aws_cloudwatch_metrics = true
enable_coredns_autoscaler     = true
enable_cluster_autoscaler     = true

enable_metrics_server     = true
enable_kube_state_metrics = true



enable_prisma_twistlock_defender = false
enable_aws_for_fluentbit         = true

##for secret manager and parameter store secrets
enable_external_secrets = false


enable_self_managed_aws_ebs_csi_driver = false

sns-topic = "arn:aws:sns:us-west-2:750713712981:eks-alarms-topic"
# Cluster dimensions
cluster_dimensions = {
  "cluster-node-cpu-utilization" = {
    metric_name         = "node_cpu_utilization",
    comparison_operator = "GreaterThanOrEqualToThreshold",
    period              = "60",
    statistic           = "Average"
    threshold           = "50",
  },
  "cluster-node-memory-utilization" = {
    metric_name         = "node_memory_utilization",
    comparison_operator = "GreaterThanOrEqualToThreshold",
    period              = "60",
    statistic           = "Average"
    threshold           = "50",
  },
}

namespace_dimensions = {}
# Service dimensions
service_dimensions = {
  "test-number-of-pods" = {
    metric_name         = "service_number_of_running_pods",
    comparison_operator = "LessThanOrEqualToThreshold",
    period              = "60",
    statistic           = "Average"
    threshold           = "0",
    namespace           = "default",
    service             = "ratings",
  },
}

# Pod dimensions
pod_dimensions = {
  "test-cpu-utilization" = {
    metric_name         = "pod_cpu_utilization_over_pod_limit",
    comparison_operator = "GreaterThanOrEqualToThreshold",
    period              = "60",
    statistic           = "Average"
    threshold           = "95",
    namespace           = "default",
    pod                 = "memconsumer",
  },
  "test-memory-utilization" = {
    metric_name         = "pod_memory_utilization_over_pod_limit",
    comparison_operator = "GreaterThanOrEqualToThreshold",
    period              = "60",
    statistic           = "Average"
    threshold           = "95",
    namespace           = "default",
    pod                 = "memconsumer",
  },
}

endpoint             = ["xcvxc@tek.com"]
create_eks_dashboard = false
