datacenter = "development"
node_name = "local-client"
data_dir   = "data/consul"

server    = false
leave_on_terminate = true

retry_join = [
  "192.168.200.2",
  "192.168.200.4"
]

encrypt = "5MqpAPSrmDeYbYYXBbYNf/Qy2H9Z3Dd9X8VwySZUtgM="
acl {
  tokens {
    default = "d9cb81dc-948a-b14c-f9a2-a818cbcd149e"
  }
}

ports {
  http = -1
  https = 8501
  grpc = -1,
  grpc_tls = 8502,
  serf_lan = 8301
}

verify_incoming_rpc    = false

tls {
  defaults {
    verify_incoming        = false
    verify_outgoing        = false
    verify_server_hostname = false
    ca_file = "certs/consul-ca.crt"
  }
}

auto_encrypt = {
  tls = true
}

connect {
  enabled = true
}

bind_addr      = "0.0.0.0"
client_addr    = "0.0.0.0"
advertise_addr = "192.168.200.10"
