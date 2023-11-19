data_dir   = "/var/nomad-server/data"
bind_addr  = "0.0.0.0"

ports {
  http = 4646
  rpc  = 4647
  serf = 4648
}

server {
  enabled          = true
}

client {
  enabled = false
}

ui {
  enabled = true
}

consul {
  ssl = true
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
  prometheus_metrics         = true
}

log_level            = "INFO"
log_json             = true
log_rotate_duration  = "24h"
log_rotate_max_files = 10