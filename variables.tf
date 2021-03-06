variable "firewall_name" {
  default     = ""
  description = "Firewall name"
  type        = string
}

variable "instance_name" {
  default     = "validator"
  description = "Name of the instance"
  type        = string
}

variable "zone" {
  description = "Zone where to deploy the validator"
  type        = string
}

variable "machine_type" {
  default     = "n1-standard-2"
  description = "Machine-type/Instance-type: for Kusama n1-standard-2 is fine, for Polkadot maybe n1-highmem-8. This constantly change, check requirements section in the Polkadot wiki"
  type        = string
}

variable "disk_size" {
  description = "Disk size. Because chain state constantly grows check the [requirements in the wiki](https://guide.kusama.network/docs/en/mirror-maintain-guides-how-to-validate-kusama) for the advisable sizes"
  default     = 200
  type        = number
}

variable "ssh_key" {
  description = "SSH Key to use for the instance"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = list(any)
  default     = []
}

#####################
# Application Layer #
#####################

variable "application_layer" {
  type        = string
  default     = "host"
  description = "You can deploy the Polkadot using docker containers or in the host itself (using the binary)"

  validation {
    condition     = can(regex("^docker|host", var.application_layer))
    error_message = "It can be either \"host\" or \"docker\"."
  }
}

variable "chain" {
  description = "Chain name: kusama or polkadot. Variable required to download the latest snapshot from polkashots.io"
  default     = "kusama"
}

variable "enable_polkashots" {
  default     = false
  description = "Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io"
  type        = bool
}

variable "polkadot_additional_common_flags" {
  default     = ""
  description = "CLI arguments appended to the polkadot service (e.g validator name)"
}

variable "p2p_port" {
  default     = 30333
  type        = number
  description = "P2P port for Polkadot service, used in `--listen-addr` args"
}

variable "proxy_port" {
  default     = 80
  type        = number
  description = "nginx reverse-proxy port to expose Polkadot's libp2p port. Polkadot's libp2p port should not be exposed directly for security reasons (DOS)"
}

variable "public_fqdn" {
  description = "Public domain for validator. If set, Caddy will use it to request LetsEncrypt certs. This variable is particulary useful to provide a secure channel (HTTPs) for [node_exporter](https://github.com/prometheus/node_exporter)"
  default     = ""
  type        = string
}

variable "http_username" {
  description = "Username to access endpoints (e.g node_exporter)"
  default     = ""
  type        = string
}

variable "http_password" {
  description = "Password to access endpoints (e.g node_exporter)"
  default     = ""
  type        = string
}

