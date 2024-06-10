output "eks-cloudwatch-dashboard-arn" {
  value = module.eks_cloudwatch_dashboard_and_alerts[*].eks-cloudwatch-dashboard-arn

}
