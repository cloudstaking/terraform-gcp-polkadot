variable "instance_name" {
  description = "Name of the Scaleway instance"
}

variable "ssh_key" {
  description = "SSH Key to attach to the machine"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "zone" {
  description = "Zone where to deploy the validator"
}

variable "enable_polkashots" {
  description = "Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io"
}
