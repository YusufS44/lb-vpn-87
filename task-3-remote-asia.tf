#-----------------------Asia Office Network-----------------------
resource "google_compute_network" "asia-net-1" {
  name = var.network-asia
  description = "asia Office Network"
  auto_create_subnetworks = false
  routing_mode = "GLOBAL"
  mtu = 1460
}
#subnet
resource "google_compute_subnetwork" "asia-subnet-1" {
  name          = var.subnetwork-asia
  ip_cidr_range = var.subnetwork-asia-ip
  network       = google_compute_network.asia-net-1.self_link
  region        = var.region-side-asia
}

#------------------------------Firewall Rules------------------------------
resource "google_compute_firewall" "asia-fw" {
  name = "asia-fw"
  network = google_compute_network.asia-net-1.self_link
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports = ["3389"]
  }
  source_tags = ["asia"]
  source_ranges = ["10.157.0.0/24"]
}

#-----------------------Asia Office Gateway-----------------------
resource "google_compute_vpn_gateway" "asia-gate" {
  name = "vpn-gateway-asia"
  network = google_compute_network.asia-net-1.id
  region = var.region-side-asia
  depends_on = [google_compute_subnetwork.asia-subnet-1]
}

#IP Address
resource "google_compute_address" "asia-ip" {
  name = "asia-ip"
  region = var.region-side-asia
}

#-----------------------Asia Office Forwarding Rules-----------------------
resource "google_compute_forwarding_rule" "asia-rule" {
  name = "asia-rule"
  region = var.region-side-asia
  ip_protocol = "ESP"
  ip_address = google_compute_address.asia-ip.address
  target = google_compute_vpn_gateway.asia-gate.self_link
  depends_on = [google_compute_vpn_gateway.asia-gate]
}

resource "google_compute_forwarding_rule" "asia-rule2" {
  name = "asia-rule2"
  region = var.region-side-asia
  ip_protocol = "UDP"
  port_range = "500"
  ip_address = google_compute_address.asia-ip.address
  target = google_compute_vpn_gateway.asia-gate.self_link
  depends_on = [google_compute_vpn_gateway.asia-gate]
}

resource "google_compute_forwarding_rule" "asia-rule3" {
  name = "asia-rule3"
  region = var.region-side-asia
  ip_protocol = "UDP"
  port_range = "4500"
  ip_address = google_compute_address.asia-ip.address
  target = google_compute_vpn_gateway.asia-gate.self_link
  depends_on = [google_compute_vpn_gateway.asia-gate]
}

#-----------------------Asia Office Tunnel-----------------------
resource "google_compute_vpn_tunnel" "asia-tunnel" {
  name = "vpn-tunnel-asia"
  peer_ip = google_compute_address.eu-ip.address
  shared_secret = var.vpn-key
  local_traffic_selector = [var.subnetwork-europe-ip]
  target_vpn_gateway = google_compute_vpn_gateway.asia-gate.id
  vpn_gateway_interface = "0"
  depends_on = [google_compute_forwarding_rule.asia-rule]
}

#-----------Asia Office Next Hop to Final Destination--------------
resource "google_compute_route" "asia-route" {
  name         = "route-asia"
  network      = google_compute_network.asia-net-1.self_link
  dest_range   = var.subnetwork-europe-ip
  priority = 1000
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.asia-tunnel.id
  depends_on = [ google_compute_vpn_tunnel.asia-tunnel ]
}

#Asia VM
resource "google_compute_instance" "asia-vm" {
  depends_on = [ google_compute_subnetwork.asia-subnet-1 ]
  name         = var.instance-name-asia
  machine_type = var.instance-type-asia
  zone         = var.zone-side-asia
  boot_disk {
    initialize_params {
      image = var.instance-image-asia
    }
  }
  network_interface {
    network = google_compute_network.asia-net-1.id
    subnetwork = google_compute_subnetwork.asia-subnet-1.id
    access_config {
    }
  }

  tags = ["asia", "vpn"]
}