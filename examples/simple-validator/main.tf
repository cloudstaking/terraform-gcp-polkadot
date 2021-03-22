provider "google" {
  region = "us-central1"
}

module "validator" {
  source = "../../"

  instance_name     = var.instance_name
  ssh_key           = var.ssh_key
  zone              = var.zone
  enable_polkashots = var.enable_polkashots
}
