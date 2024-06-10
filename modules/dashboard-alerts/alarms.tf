locals {
  base_name = var.eks_cluster_id
}

resource "aws_cloudwatch_metric_alarm" "cluster_dimensions" {
  for_each = var.cluster_dimensions != {} ? var.cluster_dimensions : {}

  alarm_name          = "${local.base_name}-${each.key}"
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = "1"
  metric_name         = each.value.metric_name
  namespace           = "ContainerInsights"
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = "alarm container insights metrics"
  alarm_actions       = [var.sns-topic]
  dimensions = {
    ClusterName = var.eks_cluster_id,
  }

  tags = merge(var.tags, {
    "Name" = "${local.base_name}-${each.key}"
  })
}

resource "aws_cloudwatch_metric_alarm" "namespace_dimensions" {
  for_each = var.namespace_dimensions != {} ? var.namespace_dimensions : {}

  alarm_name          = "${local.base_name}-${each.key}"
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = "1"
  metric_name         = each.value.metric_name
  namespace           = "ContainerInsights"
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = "alarm container insights metrics"
  alarm_actions       = [var.sns-topic]
  dimensions = {
    ClusterName = var.eks_cluster_id,
    Namespace   = each.value.namespace,
  }

  tags = merge(var.tags, {
    "Name" = "${local.base_name}-${each.key}"
  })
}

resource "aws_cloudwatch_metric_alarm" "service_dimensions" {
  for_each = var.service_dimensions != {} ? var.service_dimensions : {}

  alarm_name          = "${local.base_name}-${each.key}"
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = "1"
  metric_name         = each.value.metric_name
  namespace           = "ContainerInsights"
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = "alarm container insights metrics"
  alarm_actions       = [var.sns-topic]
  dimensions = {
    ClusterName = var.eks_cluster_id,
    Namespace   = each.value.namespace,
    Service     = each.value.service,
  }

  tags = merge(var.tags, {
    "Name" = "${local.base_name}-${each.key}"
  })
}

resource "aws_cloudwatch_metric_alarm" "pod_dimensions" {
  for_each = var.pod_dimensions != {} ? var.pod_dimensions : {}

  alarm_name          = "${local.base_name}-${each.key}"
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = "1"
  metric_name         = each.value.metric_name
  namespace           = "ContainerInsights"
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = "alarm container insights metrics"
  alarm_actions       = [var.sns-topic]
  dimensions = {
    ClusterName = var.eks_cluster_id,
    Namespace   = each.value.namespace,
    PodName     = each.value.pod,
  }

  tags = merge(var.tags, {
    "Name" = "${local.base_name}-${each.key}"
  })
}
