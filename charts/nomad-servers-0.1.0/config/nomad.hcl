data_dir   = "/var/nomad-server/data"
bind_addr  = "0.0.0.0"

tls {
  http = true
  rpc  = true

  ca_file   = "/etc/nomad-server/certs/ca.crt"
  cert_file = "/etc/nomad-server/certs/tls.crt"
  key_file  = "/etc/nomad-server/certs/tls.key"

  verify_server_hostname = true
  verify_https_client    = false
}

ports {
  http = 4646
  rpc  = 4647
  serf = 4648
}

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled = false
}

ui {
  enabled = true
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