# VPC Network and Subnet
/*resource "google_compute_network" "eu-net-1" {
  name                    = var.network-europe
  auto_create_subnetworks = false
}*/

resource "google_compute_subnetwork" "scrappy" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_ip_cidr_range
  region        = var.region-main-eu
  network       = google_compute_network.eu-net-1.name
}

# Instance Template
resource "google_compute_instance_template" "south-park" {
  name         = "south-park"
  machine_type = var.machine-type

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = google_compute_network.eu-net-1.id
    subnetwork = google_compute_subnetwork.scrappy.id
  }
}

# Managed Instance Group
resource "google_compute_instance_group_manager" "instance_group_manager" {
    name               = "instance-group-manager"
    base_instance_name = "internal-lb-vm"
    target_size        = 3
    zone               = var.zone-main-eu
    version {
        name = "version-1"
        instance_template = google_compute_instance_template.south-park.self_link_unique
    }
}

# Health Check
resource "google_compute_region_health_check" "green-mushroom-hc" {
  name               = "green-mushroom-hc"
  region = var.region-main-eu
  check_interval_sec = 1
  timeout_sec        = 1
  healthy_threshold = 2
  unhealthy_threshold = 10

  tcp_health_check {
    port = 80
  }
}

# BS Fowarding Rule
resource "google_compute_forwarding_rule" "internal_lb" {
  name                = "internal-lb"
  region = var.region-main-eu
  load_balancing_scheme = "INTERNAL"
  backend_service     = google_compute_region_backend_service.ilb-bs-87.self_link
  network             = var.network-europe
  subnetwork = var.subnetwork-europe
  ports               = ["80"]
}
#Backend Service
resource "google_compute_region_backend_service" "ilb-bs-87" {
  name = "ilb-bs-87"
  region = var.region-main-eu
  health_checks = [google_compute_region_health_check.green-mushroom-hc.self_link]
  protocol = "TCP"
  timeout_sec = 10
  
  backend {
    group = google_compute_instance_group_manager.instance_group_manager.instance_group
  }
}

