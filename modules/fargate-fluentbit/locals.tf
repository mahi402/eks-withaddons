locals {

  cwlog_group         = "/${var.addon_context.eks_cluster_id}/fluentbit"
  cwlog_stream_prefix = "fluentbit"

  default_config = {
    output_conf  = <<-EOF
    [OUTPUT]
      Name cloudwatch_logs
      Match *
      region ${var.addon_context.aws_region_name}
      log_group_name ${local.cwlog_group}
      log_stream_prefix ${local.cwlog_stream_prefix}
      auto_create_group true
    EOF
    filters_conf = <<-EOF
    [FILTER]
      Name parser
      Match *
      Parser crio
      Key_Name log
      Preserve_Key True
      Reserve_Data True
    [FILTER]
      Name kubernetes
      Match kube.*
      Merge_Log On
      Keep_Log Off
      Buffer_Size 0
      Kube_Meta_Cache_TTL 300s
    EOF
    parsers_conf = <<-EOF
    [PARSER]
      Name crio
      Format json
      Time_Key time
      Time_Keep On
    EOF
    flb_log_cw   = true
  }

  config = merge(
    local.default_config,
    var.addon_config
  )
}

