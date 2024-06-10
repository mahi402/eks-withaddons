/*
 * # AWS eks fargate usage example.
 * Terraform usage example which creates eks fargate profile in AWS
*/
# Filename     : eks-modules/aws/modules/eks/examples/eks-fargate/main.tf
#  Author      : Trianz
#  Description : The terraform module creates eks fargate profile.

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





############TO provision EKS-FARGATE along with profiles and namespaces.

module "eks-fargate" {

  source             = "../../modules/eks-fargate"
  cluster_name              = var.cluster_name
  parameter_subnet_id1_name = var.parameter_subnet_id1_name
  parameter_subnet_id2_name = var.parameter_subnet_id2_name
  parameter_subnet_id3_name = var.parameter_subnet_id3_name
  AppID                     = local.AppID
  Environment               = local.Environment
  parameter_vpc_id_name     = var.parameter_vpc_id_name
  k8s-version               = var.k8s-version
  aws_kms_key_arn           = var.aws_kms_key_arn
  aws_region                = var.aws_region
  tags                      = module.tags.tags


}

##########for creating codebuild role###########
/* 
module "codebuild_iam_role_eks" {
  depends_on       = [module.eks-fargate]
  count            = var.create_codebuild_iam_role_eks ? 1 : 0
  source           = "../../modules/codebuild-iam-role"
  eks_cluster_id   = module.eks-fargate.cluster_id
  tags             = module.tags.tags
  policy_file_name = var.policy_file_name
}
 */
###Module to deploy all addons including load balancer,fluendtbit etc...##############
#####Please input true or false in .tfvars#######

module "eks_kubernetes_addons" {
  depends_on = [module.eks-fargate]
  source     = "../../modules/kubernetes-addons"
  #These are the details related to the individual eks cluster
  eks_cluster_id            = module.eks-fargate.cluster_id
  eks_cluster_endpoint      = module.eks-fargate.cluster_endpoint
  eks_oidc_provider         = module.eks-fargate.oidc_provider
  eks_cluster_version       = var.k8s-version
  enable_external_dns       = var.enable_external_dns
  external_dns_role         = var.external_dns_role
  enable_fargate_efs        = var.enable_fargate_efs
  eks_domain_env            = var.eks_domain_env
  efsvolumeid               = var.efsvolumeid
  parameter_vpc_id_name     = var.parameter_vpc_id_name
  parameter_subnet_id1_name = var.parameter_subnet_id1_name
  parameter_subnet_id2_name = var.parameter_subnet_id2_name
  parameter_subnet_id3_name = var.parameter_subnet_id3_name
  #addons 
  enable_aws_load_balancer_controller = var.enable_aws_load_balancer_controller
  enable_kube_state_metrics           = var.enable_kube_state_metrics
  enable_external_secrets             = var.enable_external_secrets

  aws_kms_key_arn                     = var.aws_kms_key_arn
  enable_fargate_fluentbit            = var.enable_fargate_fluentbit
  enable_fargate_insights             = var.enable_fargate_insights
  create_fargatecloudwatch_dashboards = var.create_fargatecloudwatch_dashboards
  create_fargatecloudwatch_alarms     = var.create_fargatecloudwatch_alarms
  cpu-evaluation-periods              = var.cpu-evaluation-periods
  fargate-cpu-threshold               = var.fargate-cpu-threshold
  network-evaluation-period           = var.network-evaluation-period
  network-threshold                   = var.network-threshold
  mem-evaluation-periods              = var.mem-evaluation-periods
  fargate-mem-threshold               = var.fargate-mem-threshold
  sns-topic                           = var.sns-topic
  tags                                = module.tags.tags

}



module "aws_eks_rbac" {
  depends_on           = [module.eks-fargate]
  source               = "../../modules/rbac"
  eks_cluster_id       = module.eks-fargate.cluster_id
  eks_cluster_endpoint = module.eks-fargate.cluster_endpoint
  eks_oidc_provider    = module.eks-fargate.oidc_provider
  fargate_type         = var.fargate_type
  #  managed_role_group_iam = var.role_name_managed
  managed_node_groups                = var.managed_node_groups
  application_team_role              = var.application_team_role
  readonly_roles                     = var.readonly_roles
  cluster_certificate_authority_data = module.eks-fargate.cluster_certificate_authority_data
  create_aws_auth_configmap          = var.create_aws_auth_configmap
  tags                               = module.tags.tags
  map_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/CloudAdmin"
      username = "Cloudadmin"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/SuperAdmin"
      username = "Superadmin"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TFCBProvisioningRole"
      username = "TFCBSuperadmin"
      groups   = ["system:masters"]
    }
  ]


  platform_teams = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${join("-", [module.eks-fargate.cluster_id, "codebuild"])}"]


  application_teams = {
    team-alpha = {
      "labels" = {
        "appName"     = "alpha-team-app",
        "projectName" = "project-alpha",
        "environment" = "example",
        "domain"      = "example",
        "uuid"        = "example",
        "billingCode" = "example",
        "branch"      = "example"
      }
      "quota" = {
        "requests.cpu"    = "1000m",
        "requests.memory" = "4Gi",
        "limits.cpu"      = "2000m",
        "limits.memory"   = "8Gi",
        "pods"            = "10",
        "secrets"         = "10",
        "services"        = "10"
      }


      manifests_dir = "./manifests-team-alpha"
      users         = [data.aws_caller_identity.current.arn, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.application_team_role}"]
    }

    team-beta = {
      "labels" = {
        "appName"     = "beta-team-app",
        "projectName" = "project-beta",
      }
      "quota" = {
        "requests.cpu"    = "2000m",
        "requests.memory" = "4Gi",
        "limits.cpu"      = "4000m",
        "limits.memory"   = "16Gi",
        "pods"            = "20",
        "secrets"         = "20",
        "services"        = "20"
      }

      manifests_dir = "./manifests-team-beta"
      users         = [data.aws_caller_identity.current.arn, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.application_team_role}"]
    }

  }
}
