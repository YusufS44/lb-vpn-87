#-----------------------US-2 Office Network-----------------------
resource "google_compute_network" "us2-net-1" {
  name = var.network-us2
  description = "US-2 Office Network"
  auto_create_subnetworks = false
  routing_mode = "GLOBAL"
  mtu = 1460
}
#subnet
resource "google_compute_subnetwork" "us2-subnet-1" {
  name          = var.subnetwork-us2
  ip_cidr_range = var.subnetwork-us2-ip
  network       = google_compute_network.us2-net-1.self_link
  region        = var.region-side-us2
}

#------------------------------Firewall Rules------------------------------
resource "google_compute_firewall" "us2-fw" {
  name = "us2-fw"
  network = google_compute_network.us2-net-1.self_link
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports = ["80", "22"]
  }
  source_tags = ["vpn"]
  source_ranges = ["10.157.0.0/24", "35.235.240.0/20"]
  target_tags = ["us1", "iap-ssh-allowed"]
}

#-----------------------US-2 Office Gateway-----------------------
/*resource "google_compute_vpn_gateway" "us2-gate" {
  name = "vpn-gateway-us2"
  network = google_compute_network.us2-net-1.id
  region = var.region-side-us2
  depends_on = [google_compute_subnetwork.us2-subnet-1]
}*/

#IP Address
/*resource "google_compute_address" "us2-ip" {
  name = "us2-ip"
  region = var.region-side-us2
}*/

#-----------------------US-2 Office Forwarding Rules-----------------------
/*resource "google_compute_forwarding_rule" "us2-rule" {
  name = "us2-rule"
  region = var.region-side-us2
  ip_protocol = "ESP"
  ip_address = google_compute_address.us2-ip.address
  target = google_compute_vpn_gateway.us2-gate.self_link
  depends_on = [google_compute_vpn_gateway.us2-gate]
}

resource "google_compute_forwarding_rule" "us2-rule2" {
  name = "us2-rule2"
  region = var.region-side-us2
  ip_protocol = "UDP"
  port_range = "500"
  ip_address = google_compute_address.us2-ip.address
  target = google_compute_vpn_gateway.us2-gate.self_link
  depends_on = [google_compute_vpn_gateway.us2-gate]
}

resource "google_compute_forwarding_rule" "us2-rule3" {
  name = "us2-rule3"
  region = var.region-side-us2
  ip_protocol = "UDP"
  port_range = "4500"
  ip_address = google_compute_address.us2-ip.address
  target = google_compute_vpn_gateway.us2-gate.self_link
  depends_on = [google_compute_vpn_gateway.us2-gate]
}

#-----------------------US-2 Office Tunnel-----------------------
resource "google_compute_vpn_tunnel" "us2-tunnel" {
  name = "vpn-tunnel-us2"
  peer_ip = google_compute_address.eu-ip.address
  shared_secret = var.vpn-key
  local_traffic_selector = [var.subnetwork-europe-ip]
  target_vpn_gateway = google_compute_vpn_gateway.us2-gate.id
  vpn_gateway_interface = "0"
  depends_on = [google_compute_forwarding_rule.us2-rule]
}

#-----------US-2 Office Next Hop to Final Destination--------------
resource "google_compute_route" "us2-route" {
  name         = "route-us2"
  network      = google_compute_network.us2-net-1.self_link
  dest_range   = var.subnetwork-europe-ip
  priority = 1000
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.us2-tunnel.id
  depends_on = [ google_compute_vpn_tunnel.us2-tunnel ]
}*/

#US-2 Instance
resource "google_compute_instance" "us2-instance" {
  depends_on = [ google_compute_subnetwork.us2-subnet-1 ]
  name         = var.instance-name-us2
  machine_type = var.instance-type-us2
  zone         = var.zone-side-us2
  tags         = ["vpn", "us2", "iam-ssh-allowed"]
  boot_disk {
    initialize_params {
      image = var.instance-image-us2
    }
  }
  network_interface {
    network = google_compute_network.us2-net-1.id
    subnetwork = google_compute_subnetwork.us2-subnet-1.id
    access_config {
    }
  }
}