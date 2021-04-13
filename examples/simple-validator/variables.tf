variable "instance_name" {
  description = "Name of the Scaleway instance"
}

variable "ssh_key" {
  description = "SSH Key to attach to the machine"
}

variable "zone" {
  description = "Zone where to deploy the validator"
}
