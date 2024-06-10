locals {
  partition             = data.aws_partition.current.partition
  account_id            = data.aws_caller_identity.current.account_id
  eks_oidc_issuer_url   = var.eks_oidc_provider != null ? var.eks_oidc_provider : replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")
  eks_oidc_provider_arn = "arn:${local.partition}:iam::${local.account_id}:oidc-provider/${local.eks_oidc_issuer_url}"

  merged_map_roles = var.map_roles
  team_manifests = flatten([
    for team_name, team_data in var.application_teams :
    try(fileset(path.root, "${team_data.manifests_dir}/*"), [])
  ])

}

locals {

  context = {
    # Data resources
    aws_region_name = data.aws_region.current.name
    # aws_caller_identity
    aws_caller_identity_account_id = data.aws_caller_identity.current.account_id
    aws_caller_identity_arn        = data.aws_caller_identity.current.arn
    # aws_partition
    aws_partition_id         = data.aws_partition.current.id
    aws_partition_dns_suffix = data.aws_partition.current.dns_suffix

    eks_cluster_id = var.eks_cluster_id
  }

  # Managed node IAM Roles for aws-auth
  managed_node_group_aws_auth_config_map = var.managed_node_groups == true ? [
    {
      rolearn : try("arn:${local.context.aws_partition_id}:iam::${local.context.aws_caller_identity_account_id}:role/${join("-", [var.eks_cluster_id, "workernode-role"])}")
      username : "system:node:{{EC2PrivateDNSName}}"
      groups : [
        "system:bootstrappers",
        "system:nodes"
      ]
    }
  ] : []

  fargate_aws_auth_config_map = var.fargate_type == true ? [
    {
      rolearn : try("arn:${local.context.aws_partition_id}:iam::${local.context.aws_caller_identity_account_id}:role/${join("-", [var.eks_cluster_id, "fargate-role"])}")
      username : "system:node:{{SessionName}}"
      groups : [
        "system:bootstrappers",
        "system:nodes",
        "system:node-proxier"
      ]
    }
  ] : []








  platform_teams_config_map = length(var.platform_teams) > 0 ? [
    for each in var.platform_teams : {
      rolearn : each
      username : "${element(split("/", "${each}"), 1)}"
      groups : [
        "system:masters"
      ]
    }
  ] : []

  application_teams_config_map = length(var.application_teams) > 0 ? [
    for team_name, team_data in var.application_teams : {
      rolearn : "arn:${local.partition}:iam::${local.account_id}:role/${var.application_team_role}"
      username : "${team_name}"
      groups : [
        "${team_name}-group"
      ]
    }
  ] : []


  readonly_config_map = length(var.readonly_roles) > 0 ? [
    for each in var.readonly_roles : {
      rolearn : "arn:${local.partition}:iam::${local.account_id}:role/${each}"
      username : each
      groups : [
        "readonly"
      ]
    }
  ] : []
}


