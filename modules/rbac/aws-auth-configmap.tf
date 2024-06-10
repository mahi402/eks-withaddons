resource "kubernetes_config_map" "aws_auth" {
  count = var.create && var.create_aws_auth_configmap ? 1 : 0

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(
      distinct(concat(
        local.merged_map_roles,
        local.managed_node_group_aws_auth_config_map,
        local.fargate_aws_auth_config_map,
        local.application_teams_config_map,
        local.readonly_config_map,
        local.platform_teams_config_map,
        var.map_roles,
      ))
    )
    mapUsers    = yamlencode(var.map_users)
    mapAccounts = yamlencode(var.map_accounts)
  }

  lifecycle {
    # We are ignoring the data here since we will manage it with the resource below
    # This is only intended to be used in scenarios where the configmap does not exist
    ignore_changes = [data]
  }


}


locals {
  create_aws_auth_configmap = var.create_aws_auth_configmap
  manage_aws_auth_configmap = !local.create_aws_auth_configmap
}




resource "kubernetes_config_map_v1_data" "aws_auth" {
  count = var.create && local.manage_aws_auth_configmap ? 1 : 0

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(
      distinct(concat(
        local.merged_map_roles,
        local.managed_node_group_aws_auth_config_map,
        local.fargate_aws_auth_config_map,
        local.application_teams_config_map,
        local.readonly_config_map,
        local.platform_teams_config_map,
        var.map_roles,
      ))
    )
    mapUsers    = yamlencode(var.map_users)
    mapAccounts = yamlencode(var.map_accounts)
  }
  force = true
  # depends_on = [
  #   # Required for instances where the configmap does not exist yet to avoid race condition
  #   data.http.wait_for_cluster
  # ]
}
