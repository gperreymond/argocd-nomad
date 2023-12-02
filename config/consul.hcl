datacenter = "development"
node_name = "local-client"
data_dir   = "data/consul"

server    = false
leave_on_terminate = true

retry_join = [
  "consul.docker.localhost"
]

encrypt = "QtOqjxF9w4Vd0IxZIx0t93L1wauqH7YF+srq7iMkkBM="
acl {
  tokens {
    default = "9c12ae0e-8f15-76b5-e189-dc4f08c6b976"
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
