locals {
  name            = "external-secrets"
  service_account = try(var.helm_config.service_account, "${local.name}-sa")

  # https://github.com/external-secrets/external-secrets/blob/main/deploy/charts/external-secrets/Chart.yaml
  helm_config = merge(
    {
      name             = local.name
      chart            = local.name
      repository       = "${path.module}"
      version          = "0.6.0"
      create_namespace = false
      namespace        = local.name
      description      = "The External Secrets Operator Helm chart default configuration"
    },
    var.helm_config
  )

  set_values = [
    {
      name  = "serviceAccount.name"
      value = local.service_account
    },
    {
      name  = "installCRDs"
      value = true
    },
    {
      name  = "serviceAccount.create"
      value = false
    },
    {
      name  = "webhook.serviceAccount.name"
      value = local.service_account
    },
    {
      name  = "webhook.port"
      value = 9443
    },
    {
      name  = "readinessProbe.port"
      value = 8080
    },
    {
      name  = "webhook.serviceAccount.create"
      value = false
    },
    {
      name  = "certController.serviceAccount.name"
      value = local.service_account
    },
    {
      name  = "certController.serviceAccount.create"
      value = false
    }
  ]

  irsa_config = {
    kubernetes_namespace              = local.helm_config["namespace"]
    kubernetes_service_account        = local.service_account
    create_kubernetes_namespace       = try(local.helm_config["create_namespace"], true)
    create_kubernetes_service_account = true
    irsa_iam_policies                 = concat([aws_iam_policy.external_secrets.arn], var.irsa_policies)
  }


}


locals {
  cluster_name        = var.addon_context.eks_cluster_id
  secretsmanager_name = join("-", [local.cluster_name, "secret-fargate"])
  kmskey_name         = join("-", [local.cluster_name, "kms-fargate"])
  irsa_iam_role       = join("-", [local.cluster_name, "extsecrets-sa"])
  namespace           = "external-secrets"
  region              = var.addon_context.aws_region_name


}
