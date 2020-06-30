module "vpn-module-static" {
  source  = "terraform-google-modules/vpn/google"

  project_id         = "${var.project_id}"
  network            = "${var.network}"
  region             = "europe-west2"
  gateway_name       = "vpn-gw-static"
  tunnel_name_prefix = "vpn-tn-static"
  shared_secret      = "secrets"
  tunnel_count       = 1 
  peer_ips           = ["1.1.1.1","2.2.2.2"]

  route_priority     = 1000
  remote_subnet      = ["10.200.10.0/24","10.200.20.0/24"]
}
