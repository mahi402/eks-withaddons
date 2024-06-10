/*
 * # Terraform usage example which creates eks multiple node groups in AWS
 * This module will create eks managed groups for ec2 instances.
*/
# Filename     : eks-modules/aws/modules/eks/examples/eks-nodegroups/main.tf
#  Date        : 26 May 2022
#  Author      : Trianz
#  Description : eks-node group creation

#### Cluster Locals ########
locals {
  AppID              = var.AppID
  Environment        = var.Environment
  DataClassification = var.DataClassification
  CRIS               = var.CRIS
  Notify             = var.Notify
  Owner              = var.Owner
  Compliance         = var.Compliance

}

#### Tags module ########
module "tags" {
  source             = "../../../tags"
  AppID              = local.AppID
  Environment        = local.Environment
  DataClassification = local.DataClassification
  CRIS               = local.CRIS
  Notify             = local.Notify
  Owner              = local.Owner
  Compliance         = local.Compliance
}



## EKS  Module #####
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"
  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version
  subnet_ids      = module.vpc.private_subnets

  enable_irsa = true

  tags = {
    cluster = "demo"
  }

  vpc_id = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = ["t3.medium"]
    vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }

  eks_managed_node_groups = {

    node_group = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
    }
  }
}

 
module "eks_kubernetes_addons" {
  depends_on = [module.aws_eks_rbac]
  source     = "../../modules/kubernetes-addons"

  #These are the details related to the individual eks cluster
  parameter_vpc_id_name              = var.parameter_vpc_id_name
  parameter_subnet_id1_name          = var.parameter_subnet_id1_name
  parameter_subnet_id2_name          = var.parameter_subnet_id2_name
  parameter_subnet_id3_name          = var.parameter_subnet_id3_name
  eks_cluster_id                     = module.eks.cluster_id
  eks_cluster_endpoint               = module.eks.cluster_endpoint
  eks_oidc_provider                  = module.eks.oidc_provider
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data

  eks_cluster_version = var.k8s-version

  #addons 
  enable_aws_load_balancer_controller = var.enable_aws_load_balancer_controller
  enable_coredns_autoscaler           = var.enable_coredns_autoscaler
  aws_kms_key_arn               = var.aws_kms_key_arn
  enable_aws_cloudwatch_metrics = var.enable_aws_cloudwatch_metrics
  create_eks_dashboard          = var.create_eks_dashboard
  cluster_dimensions            = var.cluster_dimensions
  pod_dimensions                = var.pod_dimensions
  namespace_dimensions          = var.namespace_dimensions
  service_dimensions            = var.service_dimensions
  aws_region                    = var.aws_region
  endpoint                      = var.Notify
  efsvolumeid                   = var.efsvolumeid
  enable_cni_metrics_helper     = var.enable_cni_metrics_helper
  enable_aws_efs_csi_driver     = var.enable_aws_efs_csi_driver
  enable_external_dns           = var.enable_external_dns
  external_dns_role             = var.external_dns_role
  eks_domain_env                = var.eks_domain_env

  enable_self_managed_aws_ebs_csi_driver = var.enable_self_managed_aws_ebs_csi_driver
  ebs_csi_driver_templates_helm_config = {
    kubernetes_version = var.k8s-version
  }
  external_sercrets_templates_helm_config = {
    create_namespace = false
  }

  enable_aws_for_fluentbit                 = var.enable_aws_for_fluentbit
  aws_for_fluentbit_cw_log_group_retention = 30

  

  enable_prisma_twistlock_defender = var.enable_prisma_twistlock_defender
  enable_cluster_autoscaler        = var.enable_cluster_autoscaler
  enable_metrics_server            = var.enable_metrics_server
  enable_kube_state_metrics        = var.enable_kube_state_metrics
  enable_external_secrets          = var.enable_external_secrets
  sns-topic                        = var.sns-topic
  tags                             = module.tags.tags

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    "777777777777",
    "888888888888",
  ]
}


module "fargate_profile" {
  source = "terraform-aws-modules/eks/aws//modules/fargate-profile"

  name         = "separate-fargate-profile"
  cluster_name = "my-cluster"

  subnet_ids = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
  selectors = [{
    namespace = "kube-system"
  }]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}