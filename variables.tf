variable "firewall_name" {
  default     = ""
  description = "Firewall name"
}

variable "firewall_whitelisted_ssh_ip" {
  default     = "0.0.0.0/0"
  description = "List of CIDRs the instance is going to accept SSH connections from."
}

variable "instance_name" {
  default     = "validator"
  description = "Name of the instance"
}

variable "zone" {
  description = "Zone where to deploy the validator"
}

variable "machine_type" {
  default     = "n1-standard-2"
  description = "Machine-type/Instance-type: for Kusama n1-standard-2 is fine, for Polkadot maybe n1-highmem-8. This constantly change, check requirements section in the Polkadot wiki"
}

variable "disk_size" {
  description = "Disk size. Because chain state constantly grows check the [requirements in the wiki](https://guide.kusama.network/docs/en/mirror-maintain-guides-how-to-validate-kusama) for the advisable sizes"
  default     = 200
}

variable "chain" {
  description = "Chain name: kusama or polkadot. Variable required to download the latest snapshot from polkashots.io"
  default     = "kusama"
}

variable "enable_polkashots" {
  default     = true
  description = "Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io"
  type        = bool
}

variable "ssh_key" {
  description = "SSH Key to use for the instance"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "polkadot_additional_common_flags" {
  default     = ""
  description = "Application layer - when `enable_application_layer_docker = true`, the content of this variable will be appended to the polkadot command arguments"
}
