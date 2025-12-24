terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

provider "proxmox" {
  pm_api_url = "http://192.168.86.206:8006/api2/json"
  pm_tls_insecure = true
  pm_user = "terraform-prov@pve"
  pm_password = "SET ME"
}
