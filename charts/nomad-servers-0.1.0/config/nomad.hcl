region     = "global"
datacenter = "global"
data_dir   = "/var/nomad/data"
bind_addr  = "0.0.0.0"

tls {
  http = true
  rpc  = true

  ca_file   = "/ca.cert"
  cert_file = "/tls.crt"
  key_file  = "/tls.key"

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
  encrypt          = "mw4m3LcGW3cKb3MKoF2QH3l1nLS1B5hzLh7mPNB5W+o="
}

client {
  enabled = false
}

ui {
  enabled = true
  label {
    text             = "Global Cluster"
    background_color = "yellow"
    text_color       = "#000000"
  }
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