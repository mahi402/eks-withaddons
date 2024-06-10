
output "team_sa_irsa_iam_role" {
  description = "IAM role name for Teams EKS Service Account (IRSA)"
  value = tomap({
    for k, v in aws_iam_role.team_sa_irsa : k => v.name
  })
}

output "team_sa_irsa_iam_role_arn" {
  description = "IAM role ARN for Teams EKS Service Account (IRSA)"
  value = tomap({
    for k, v in aws_iam_role.team_sa_irsa : k => v.arn
  })
}


output "auth-map-managed" {
  value = local.application_teams_config_map

}

output "auth-map-platform" {
  value = local.platform_teams_config_map

}

