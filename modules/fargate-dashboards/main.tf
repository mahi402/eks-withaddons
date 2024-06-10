#cpu utilization ,memory,network of fargate cluster dashboard
resource "aws_cloudwatch_dashboard" "cloudwatch-dashboard" {
  dashboard_name = local.cloudwatch-dashboard

  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 6,
            "width": 12,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "region": "${var.addon_context.aws_region_name}",
                "title": "Memory Utilization-Total Cluster Level",
                "legend": {
                    "position": "right"
                },
                "timezone": "Local",
                "metrics": [
                    [ { "id": "expr1m0", "label": "${var.addon_context.eks_cluster_id}", "expression": "(mm1m0 + mm1farm0) * 100 / (mm0m0 + mm0farm0)", "stat": "Average" } ],
                    [ "ContainerInsights", "node_memory_limit", "ClusterName", "${var.addon_context.eks_cluster_id}", { "id": "mm0m0", "visible": false, "stat": "Sum" } ],
                    [ "ContainerInsights", "pod_memory_limit", "ClusterName", "${var.addon_context.eks_cluster_id}", "LaunchType", "fargate", { "id": "mm0farm0", "visible": false, "stat": "Sum" } ],
                    [ "ContainerInsights", "node_memory_working_set", "ClusterName", "${var.addon_context.eks_cluster_id}", { "id": "mm1m0", "visible": false, "stat": "Sum" } ],
                    [ "ContainerInsights", "pod_memory_working_set", "ClusterName", "${var.addon_context.eks_cluster_id}", "LaunchType", "fargate", { "id": "mm1farm0", "visible": false, "stat": "Sum" } ]
                ],
                "start": "-P0DT0H5M0S",
                "end": "P0D",
                "liveData": false,
                "period": 60,
                "yAxis": {
                    "left": {
                        "min": 0,
                        "showUnits": false,
                        "label": "Percent"
                    }
                },
                "view": "timeSeries",
                "stacked": true
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 6,
            "x": 12,
            "type": "metric",
            "properties": {
                "region": "${var.addon_context.aws_region_name}",
                "title": " POD Memory Utilization",
                "legend": {
                    "position": "right"
                },
                "timezone": "Local",
                "metrics": [
                    [ "ContainerInsights", "pod_memory_limit", "ClusterName", "${var.addon_context.eks_cluster_id}", "LaunchType", "fargate", { "id": "mm0farm0", "visible": true, "stat": "Sum" } ]
                ],
                "start": "-P0DT0H5M0S",
                "end": "P0D",
                "liveData": false,
                "period": 60,
                "yAxis": {
                    "left": {
                        "min": 0,
                        "showUnits": false,
                        "label": "Percent"
                    }
                },
                "view": "timeSeries",
                "stacked": true
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 0,
            "x": 12,
            "type": "metric",
            "properties": {
                "region": "${var.addon_context.aws_region_name}",
                "title": "Total CPU Utilization",
                "legend": {
                    "position": "right"
                },
                "timezone": "Local",
                "metrics": [
                    [ { "id": "expr1m0", "label": "${var.addon_context.eks_cluster_id}", "expression": "(mm1m0 + mm1farm0) * 100 / (mm0m0 + mm0farm0)", "stat": "Average" } ],
                    [ "ContainerInsights", "node_cpu_limit", "ClusterName", "${var.addon_context.eks_cluster_id}", { "id": "mm0m0", "visible": false, "stat": "Sum" } ],
                    [ "ContainerInsights", "pod_cpu_limit", "ClusterName", "${var.addon_context.eks_cluster_id}", "LaunchType", "fargate", { "id": "mm0farm0", "visible": false, "stat": "Sum" } ],
                    [ "ContainerInsights", "node_cpu_usage_total", "ClusterName", "${var.addon_context.eks_cluster_id}", { "id": "mm1m0", "visible": false, "stat": "Sum" } ],
                    [ "ContainerInsights", "pod_cpu_usage_total", "ClusterName", "${var.addon_context.eks_cluster_id}", "LaunchType", "fargate", { "id": "mm1farm0", "visible": false, "stat": "Sum" } ]
                ],
                "start": "-P0DT0H5M0S",
                "end": "P0D",
                "liveData": false,
                "period": 60,
                "yAxis": {
                    "left": {
                        "min": 0,
                        "showUnits": false,
                        "label": "Percent"
                    }
                },
                "view": "timeSeries",
                "stacked": false
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 6,
            "x": 0,
            "type": "metric",
            "properties": {
                "region": "${var.addon_context.aws_region_name}",
                "title": "POD CPU Utilization",
                "legend": {
                    "position": "right"
                },
                "timezone": "Local",
                "metrics": [
                    [ "ContainerInsights", "pod_cpu_limit", "ClusterName", "${var.addon_context.eks_cluster_id}", "LaunchType", "fargate", { "id": "mm0farm0", "visible": true, "stat": "Sum" } ]
                ],
                "start": "-P0DT0H5M0S",
                "end": "P0D",
                "liveData": false,
                "period": 60,
                "yAxis": {
                    "left": {
                        "min": 0,
                        "showUnits": false,
                        "label": "Percent"
                    }
                },
                "view": "timeSeries",
                "stacked": false
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 12,
            "x": 12,
            "type": "metric",
            "properties": {
                "region": "${var.addon_context.aws_region_name}",
                "title": "POD CPU Utilization Total",
                "legend": {
                    "position": "right"
                },
                "timezone": "Local",
                "metrics": [
                    [ "ContainerInsights", "pod_cpu_usage_total", "ClusterName", "${var.addon_context.eks_cluster_id}", "LaunchType", "fargate", { "id": "mm1farm0", "visible": true, "stat": "Sum" } ]
                ],
                "start": "-P0DT0H5M0S",
                "end": "P0D",
                "liveData": false,
                "period": 60,
                "yAxis": {
                    "left": {
                        "min": 0,
                        "showUnits": false,
                        "label": "Percent"
                    }
                },
                "view": "timeSeries",
                "stacked": false
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 12,
            "x": 0,
            "type": "metric",
            "properties": {
                "region": "${var.addon_context.aws_region_name}",
                "title": "Network TX",
                "legend": {
                    "position": "bottom"
                },
                "timezone": "Local",
                "metrics": [
                    [ { "id": "expr1m0", "label": "${var.addon_context.eks_cluster_id}", "expression": "mm1m0 + mm1farm0", "stat": "Average" } ],
                    [ "ContainerInsights", "pod_network_tx_bytes", "ClusterName", "${var.addon_context.eks_cluster_id}", { "id": "mm1m0", "visible": false } ],
                    [ "ContainerInsights", "pod_network_tx_bytes", "ClusterName", "${var.addon_context.eks_cluster_id}", "LaunchType", "fargate", { "id": "mm1farm0", "visible": false } ]
                ],
                "start": "-P0DT0H5M0S",
                "end": "P0D",
                "liveData": false,
                "period": 60,
                "view": "timeSeries",
                "stacked": false
            }
        }
    ]
}
EOF

}

