#regions***************************

variable "region-main-eu" {
  description = "europe-west2"
  default     = "europe-west2"
}

variable "region-side-us1" {
  description = "us-east1"
  default     = "us-east1"
}

variable "region-side-us2" {
  description = "us-central1"
  default     = "us-central1"
}

variable "region-side-asia" {
  description = "asia-east2"
  default     = "asia-east2"
}

#network names***************************

variable "network-europe" {
  description = "hq-europe"
  default     = "hq-europe"
}

variable "network-us1" {
  description = "branch-us1"
  default     = "branch-us1"
}

variable "network-us2" {
  description = "branch-us2"
  default     = "branch-us2"
}

variable "network-asia" {
  description = "branch-asia"
  default     = "branch-asia"
}


#subnet names***************************

variable "subnetwork-europe" {
  description = "subnetwork-hq-europe"
  default     = "subnetwork-hq-europe"
}

variable "subnetwork-us1" {
  description = "subnetwork-branch-us1"
  default     = "subnetwork-branch-us1"
}

variable "subnetwork-us2" {
  description = "subnetwork-branch-us2"
  default     = "subnetwork-branch-us2"
}

variable "subnetwork-asia" {
  description = "subnetwork-branch-asia"
  default     = "subnetwork-branch-asia"
}


#subnet ip-range***************************

variable "subnetwork-europe-ip" {
  description = "subnetwork-hq-europe"
  default     = "10.157.0.0/24"
}

variable "subnetwork-us1-ip" {
  description = "subnetwork-branch-us1"
  default     = "172.16.0.0/24"
}

variable "subnetwork-us2-ip" {
  description = "subnetwork-branch-us2"
  default     = "172.17.0.0/24"
}

variable "subnetwork-asia-ip" {
  description = "subnetwork-branch-asia"
  default     = "192.168.0.0/24"
}

#zones***************************

variable "zone-main-eu" {
  description = "europe-west2-a"
  default     = "europe-west2-a"
}

variable "zone-side-us1" {
  description = "us-east1-b"
  default     = "us-east1-b"
}

variable "zone-side-us2" {
  description = "us-central1-a"
  default     = "us-central1-a"
}

variable "zone-side-asia" {
  description = "asia-east2-a"
  default     = "asia-east2-a"
}

#firewall names***************************

variable "firewall-europe" {
  description = "firewall_europe"
  default     = "firewall-europe"
}

variable "firewall-us1" {
  description = "firewall_us1"
  default     = "firewall-us1"
}

variable "firewall-us2" {
  description = "firewall_us2"
  default     = "firewall-us2"
}

variable "firewall-asia" {
  description = "firewall_asia"
  default     = "firewall-asia"
}

#elastic IP name*************************

variable "elastic-ip-address-name-europe" {
  description = "elastic_ip_address_name_hq-europe"
  default     = "elastic-ip-address-name-hq-europe"
}

variable "elastic-ip-addressname-us1" {
  description = "elastic_ip_address_name_branch-us1"
  default     = "elastic-ip-address-name-branch-us1"
}

variable "elastic-ip-address-name-us2" {
  description = "elastic_ip_address_name_branch-us2"
  default     = "elastic-ip-address-name-branch-us2"
}

variable "elastic-ip-address-name-asia" {
  description = "elastic_ip_address_name_branch-asia"
  default     = "elastic-ip-address-name-branch-asia"
}

#instance***********************************

variable "instance-name-europe" {
  description = "instance_europe"
  default     = "instance-europe"
}

variable "instance-name-us1" {
  description = "instance_us1"
  default     = "instance-us1"
}

variable "instance-name-us2" {
  description = "instance_us2"
  default     = "instance-us2"
}

variable "instance-name-asia" {
  description = "instance_asia"
  default     = "instance-asia"
}

#instance type and image***********************************

variable "instance-type-europe" {
  description = "n2-standard-2"
  default     = "n2-standard-2"
}

variable "instance-image-europe" {
  description = "debian-cloud/debian-11"
  default     = "debian-cloud/debian-11"
}

#---------------------------------------------------------
variable "instance-type-us1" {
  description = "n2-standard-2"
  default     = "n2-standard-2"
}

variable "instance-image-us1" {
  description = "debian-cloud/debian-11"
  default     = "debian-cloud/debian-11"
}

#----------------------------------------------------------
variable "instance-type-us2" {
  description = "n2-standard-2"
  default     = "n2-standard-2"
}

variable "instance-image-us2" {
  description = "debian-cloud/debian-11"
  default     = "debian-cloud/debian-11"
}

#----------------------------------------------------------
variable "instance-type-asia" {
  description = "n2-standard-2"
  default     = "n2-standard-2"
}

variable "instance-image-asia" {
  description = "windows-cloud/windows-2016"
  default     = "windows-cloud/windows-2016"
}

#secret key************************************

variable "key_name" {
  description = "secret-key"
  default     = "secret-key"
}

variable "vpn-key" {
  description = "vpn-key"
  default     = "ds983m7ju30k"
}

#gateway names************************************

variable "gateway-name-europe" {
  description = "gateway_name_hq-europe"
  default     = "gateway-name-hq-europe"
}

variable "gateway-name-us1" {
  description = "gateway_name_branch-us1"
  default     = "gateway-name-branch-us1"
}

variable "gateway-name-us2" {
  description = "gateway_name_branch-us2"
  default     = "gateway-name-branch-us2"
}

variable "gateway-name-asia" {
  description = "gateway_name_branch-asia"
  default     = "gateway-name-branch-asia"
}
