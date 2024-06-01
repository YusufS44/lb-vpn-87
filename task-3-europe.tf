#-----------------Home Office Network-----------------
resource "google_compute_network" "eu-net-1" {
  name = var.network-europe
  description = "Home Office Network"
  auto_create_subnetworks = false
  routing_mode = "GLOBAL"
  mtu = 1460
}
#subnet
resource "google_compute_subnetwork" "eu-subnet-1" {
  name          = var.subnetwork-europe
  ip_cidr_range = var.subnetwork-europe-ip
  network       = google_compute_network.eu-net-1.self_link
  region        = var.region-main-eu
}

#Firewall Rules
resource "google_compute_firewall" "eu-fw" {
  name = "eu-fw"
  network = google_compute_network.eu-net-1.self_link
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports = ["80", "22"]
  }
  source_tags = ["vpn"]
 source_ranges = ["10.157.0.0/24", "192.168.0.0/24", "35.235.240.0/20", "10.31.1.0/24"]
  target_tags = ["us1", "us2", "asia", "internal-lb"]
}

#-----------------Home Office Gateway-----------------
resource "google_compute_vpn_gateway" "eu-gate" {
  name = "vpn-gateway-europe"
  network = google_compute_network.eu-net-1.id
  region = var.region-main-eu
  depends_on = [google_compute_subnetwork.eu-subnet-1]
}

#IP Address
resource "google_compute_address" "eu-ip" {
  name = "eu-ip"
  region = var.region-main-eu
}

#-----------------Home Office Forwarding Rules---------
resource "google_compute_forwarding_rule" "eu-rule" {
  name = "eu-rule"
  region = var.region-main-eu
  ip_protocol = "ESP"
  ip_address = google_compute_address.eu-ip.address
  target = google_compute_vpn_gateway.eu-gate.self_link
  depends_on = [google_compute_vpn_gateway.eu-gate]
}

resource "google_compute_forwarding_rule" "eu-rule2" {
  name = "eu-rule2"
  region = var.region-main-eu
  ip_protocol = "UDP"
  port_range = "500"
  ip_address = google_compute_address.eu-ip.address
  target = google_compute_vpn_gateway.eu-gate.self_link
  depends_on = [google_compute_vpn_gateway.eu-gate]
}

resource "google_compute_forwarding_rule" "eu-rule3" {
  name = "eu-rule3"
  region = var.region-main-eu
  ip_protocol = "UDP"
  port_range = "4500"
  ip_address = google_compute_address.eu-ip.address
  target = google_compute_vpn_gateway.eu-gate.self_link
  depends_on = [google_compute_vpn_gateway.eu-gate]
}

#-----------------Home Office Tunnel to ASIA-1-------------------
resource "google_compute_vpn_tunnel" "eu-tunnel" {
  name = "vpn-tunnel-europe"
  peer_ip = google_compute_address.asia-ip.address
  shared_secret = var.vpn-key
  local_traffic_selector = [var.subnetwork-asia-ip]
  target_vpn_gateway = google_compute_vpn_gateway.eu-gate.id
  vpn_gateway_interface = "0"
  depends_on = [google_compute_forwarding_rule.eu-rule, google_compute_forwarding_rule.eu-rule2, google_compute_forwarding_rule.eu-rule3]
}

#-------Home Office Next Hop to Final Destination-------
resource "google_compute_route" "eu-route" {
  name = "route-europe"
  network = google_compute_network.eu-net-1.id
  dest_range = var.subnetwork-asia-ip
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.eu-tunnel.id
  priority = 1000
  depends_on = [google_compute_vpn_tunnel.eu-tunnel]
}

#-------------------Home Office Instance------------------
resource "google_compute_instance" "eu-instance" {
  depends_on = [ google_compute_subnetwork.eu-subnet-1, google_compute_route.eu-route ]
  name         = "vpn-instance-europe"
  machine_type = var.instance-type-europe
  zone         = var.zone-main-eu
  tags         = ["vpn"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = google_compute_network.eu-net-1.id
    subnetwork = google_compute_subnetwork.eu-subnet-1.id
    access_config {
    }
  }

 metadata = {
    startup_script = "\n<html>\n    <head>\n        <title>My First Webpage</title>\n    </head>\n    <body>\n        <h1>I love coffee</h1>\n        <p>Hello world!</p>\n    </body>\n\n    <img src=\"coffee.jpg\" width=500/>\n    <img src=\"beach.jpg\" width=500/>\n</html>\n\n"
  }

}

# -----------Route traffic from VPN to Internal Load Balancer's Subnet---------------
resource "google_compute_route" "inside-line-backer" {
  name = "inside-line-backer"
  network = google_compute_network.eu-net-1.id
  dest_range = var.subnet_ip_cidr_range2
  next_hop_instance = google_compute_instance.eu-instance.self_link
  priority = 1000
  depends_on = [google_compute_instance.eu-instance]
}