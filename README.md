### Classic-vpn-static configuration 

Add the following roles to the service account
```
Project Editor
Compute Admin
Compute Network Admin
```

```
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
```

### Dynamic VPN configuration
```
resource "google_compute_router" "cr-europe-west-to-prod-vpc" {
  name    = "cr-europe-west2-to-prod-vpc-tunnels"
  region  = "europe-west2"
  network = "default"
  project = var.project_id

  bgp {
    asn = "64519"
  }
}

module "vpn-module-dynamic" {
  source  = "terraform-google-modules/vpn/google"


  project_id               = "${var.project_id}"
  network                  = "${var.network}"
  region                   = "europe-west2"
  gateway_name             = "vpn-gw-dynamic"
  tunnel_name_prefix       = "vpn-tn-dynamic"
  shared_secret            = "secrets"
  tunnel_count             = 2
  peer_ips                 = ["1.1.1.1","2.2.2.2"]

  cr_name                  = "cr-europe-west2-tunnels"
  bgp_cr_session_range     = ["169.254.0.1/30", "169.254.0.3/30"]
  bgp_remote_session_range = ["169.254.0.2", "169.254.0.4"]
  peer_asn                 = ["64516", "64517"]
}
```
