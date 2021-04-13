terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
  required_version = ">= 0.13"
}

provider "google" {
  region = "us-central1"
}

module "validator" {
  source = "../../"

  instance_name                    = var.instance_name
  ssh_key                          = var.ssh_key
  zone                             = var.zone
  enable_polkashots                = true
  polkadot_additional_common_flags = "--name=CLOUDSTAKING-TEST --telemetry-url 'wss://telemetry.polkadot.io/submit/ 1'"

  # This is optional
  tags = ["blue", "terraform"]
}
