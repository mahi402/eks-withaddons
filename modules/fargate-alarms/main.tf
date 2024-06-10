
#####Cloud watch metric alarm created for pod level cpu
resource "aws_cloudwatch_metric_alarm" "eks-fargate-pod-cpu-alarm" {
  alarm_name                = local.podcpu-alarm
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.cpu-evaluation-periods
  threshold                 = var.fargate-cpu-threshold
  alarm_description         = "Request error rate has exceeded 10%"
  insufficient_data_actions = []
  actions_enabled           = "true"
  alarm_actions             = [var.sns-topic]

  metric_query {
    id          = "mm0farm0"
    return_data = true
    metric {
      metric_name = "pod_cpu_limit"
      namespace   = "ContainerInsights"
      period      = "60"
      stat        = "Sum"

      dimensions = {
        ClusterName = var.addon_context.eks_cluster_id,
        LaunchType  = "fargate"
      }
    }
  }

  tags = var.addon_context.tags
}

#####Cloud watch metric alarm created for pod level network

resource "aws_cloudwatch_metric_alarm" "eks-fargate-pod-network-alarm" {
  alarm_name                = local.network-alarm
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.network-evaluation-period
  threshold                 = var.network-threshold
  alarm_description         = "Request error rate has exceeded 10%"
  insufficient_data_actions = []
  actions_enabled           = "true"
  alarm_actions             = [var.sns-topic]
  metric_query {
    id          = "mm1farm0"
    return_data = true
    metric {
      metric_name = "pod_network_tx_bytes"
      namespace   = "ContainerInsights"
      period      = "60"
      stat        = "Average"


      dimensions = {
        ClusterName = var.addon_context.eks_cluster_id,
        LaunchType  = "fargate"
      }
    }
  }
  tags = var.addon_context.tags
}

#####Cloud watch metric alarm created for pod level memory

resource "aws_cloudwatch_metric_alarm" "eks-fargate-pod-mem-alarm" {
  alarm_name                = local.podmem-alarm
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.mem-evaluation-periods
  threshold                 = var.fargate-mem-threshold
  alarm_description         = "Request error rate has exceeded 10%"
  insufficient_data_actions = []
  actions_enabled           = "true"
  alarm_actions             = [var.sns-topic]

  metric_query {
    id          = "mm0farm0"
    return_data = true
    metric {
      metric_name = "pod_memory_limit"
      namespace   = "ContainerInsights"
      period      = "60"
      stat        = "Sum"

      dimensions = {
        ClusterName = var.addon_context.eks_cluster_id,
        LaunchType  = "fargate"
      }
    }
  }
  tags = var.addon_context.tags

}