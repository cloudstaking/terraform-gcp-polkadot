locals {
  firewall_name = var.firewall_name != "" ? var.firewall_name : "${var.instance_name}-sg"
}

resource "google_compute_instance" "validator" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2004-lts"
      size  = var.disk_size
    }
  }

  metadata = {
    ssh-keys  = "ubuntu:${var.ssh_key}"
    user-data = module.cloud_init.clout_init
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

resource "google_compute_firewall" "validator" {
  name      = local.firewall_name
  network   = "default"
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # nginx (reverse-proxy for p2p port)
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  # node-exporter
  allow {
    protocol = "tcp"
    ports    = ["9100"]
  }
}

module "cloud_init" {
  source = "github.com/cloudstaking/terraform-cloudinit-polkadot?ref=main"

  application_layer                = var.application_layer
  additional_volume                = false
  cloud_provider                   = "gcp"
  chain                            = var.chain
  polkadot_additional_common_flags = var.polkadot_additional_common_flags
  enable_polkashots                = var.enable_polkashots
  p2p_port                         = var.p2p_port
  proxy_port                       = var.proxy_port
  public_fqdn                      = var.public_fqdn
  http_username                    = var.http_username
  http_password                    = var.http_password
}

