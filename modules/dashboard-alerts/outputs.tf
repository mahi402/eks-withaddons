output "eks-cloudwatch-dashboard-arn" {
  value = aws_cloudwatch_dashboard.main[*].dashboard_arn

}

