#-----------------------US-1 Office Network-----------------------
resource "google_compute_network" "us1-net-1" {
  name = var.network-us1
  description = "US-1 Office Network"
  auto_create_subnetworks = false
  routing_mode = "GLOBAL"
  mtu = 1460
}
#subnet
resource "google_compute_subnetwork" "us1-subnet-1" {
  name          = var.subnetwork-us1
  ip_cidr_range = var.subnetwork-us1-ip
  network       = google_compute_network.us1-net-1.self_link
  region        = var.region-side-us1
}

#------------------------------Firewall Rules------------------------------
resource "google_compute_firewall" "us1-fw" {
  name = "us1-fw"
  network = google_compute_network.us1-net-1.self_link
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports = ["80", "22"]
  }
  source_tags = ["vpn"]
  source_ranges = ["10.157.0.0/24", "35.235.240.0/20"]
  target_tags = ["us2", "iap-ssh-allowed"]
}

#-----------------------US-1 Office Gateway-----------------------
/*resource "google_compute_vpn_gateway" "us1-gate" {
  name = "vpn-gateway-us1"
  network = google_compute_network.us1-net-1.id
  region = var.region-side-us1
  depends_on = [google_compute_subnetwork.us1-subnet-1]
}

#IP Address
resource "google_compute_address" "us1-ip" {
  name = "us1-ip"
  region = var.region-side-us1
}

/*#-----------------------US-1 Office Forwarding Rules-----------------------
resource "google_compute_forwarding_rule" "us1-rule" {
  name = "us1-rule"
  region = var.region-side-us1
  ip_protocol = "ESP"
  ip_address = google_compute_address.us1-ip.address
  target = google_compute_vpn_gateway.us1-gate.self_link
  depends_on = [google_compute_vpn_gateway.us1-gate]
}

resource "google_compute_forwarding_rule" "us1-rule2" {
  name = "us1-rule2"
  region = var.region-side-us1
  ip_protocol = "UDP"
  port_range = "500"
  ip_address = google_compute_address.us1-ip.address
  target = google_compute_vpn_gateway.us1-gate.self_link
  depends_on = [google_compute_vpn_gateway.us1-gate]
}

resource "google_compute_forwarding_rule" "us1-rule3" {
  name = "us1-rule3"
  region = var.region-side-us1
  ip_protocol = "UDP"
  port_range = "4500"
  ip_address = google_compute_address.us1-ip.address
  target = google_compute_vpn_gateway.us1-gate.self_link
  depends_on = [google_compute_vpn_gateway.us1-gate]
}

#-----------------------US-1 Office Tunnel-----------------------
resource "google_compute_vpn_tunnel" "us1-tunnel" {
  name = "vpn-tunnel-us1"
  peer_ip = google_compute_address.eu-ip.address
  shared_secret = var.vpn-key
  local_traffic_selector = [var.subnetwork-europe-ip]
  target_vpn_gateway = google_compute_vpn_gateway.us1-gate.id
  vpn_gateway_interface = "0"
  depends_on = [google_compute_forwarding_rule.us1-rule]
}

#-----------US-1 Office Next Hop to Final Destination--------------
resource "google_compute_route" "us1-route" {
  name         = "route-us1"
  network      = google_compute_network.us1-net-1.self_link
  dest_range   = var.subnetwork-europe-ip
  priority = 1000
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.us1-tunnel.id
  depends_on = [ google_compute_vpn_tunnel.us1-tunnel ]
}*/

# US-1 Instance
resource "google_compute_instance" "us1-instance" {
  depends_on = [ google_compute_subnetwork.us1-subnet-1 ]
  name         = var.instance-name-us1
  machine_type = var.instance-type-us1
  zone         = var.zone-side-us1
  boot_disk {
    initialize_params {
      image = var.instance-image-us1
    }
  }
  network_interface {
    network = google_compute_network.us1-net-1.id
    subnetwork = google_compute_subnetwork.us1-subnet-1.id
    access_config {
    }
  }

  tags = ["us1", "vpn", "iam-ssh-allowed"]
}