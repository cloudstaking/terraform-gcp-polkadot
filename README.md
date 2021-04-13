# terraform-scaleway-polkadot

Terraform module to bootstrap ready-to-use _single node_ (or optionally _active-standby_) Kusama/Polkadot validators in GCP. Besides infrastructure components (security group, instance, volume, etc), it also:

- Optionally pulls latest snapshot from [Polkashots](https://polkashots.io)
- [Node exporter](https://github.com/prometheus/node_exporter) with HTTPs to securly pull metrics from your monitoring systems.
- Nginx as a reverse proxy for libp2p
- Support for different deplotments methods: either using docker/docker-compose or deploying the binary itself in the host.

It uses the latest official Ubuntu 20.04 LTS (no custom image). 


## Usage

```hcl
module "kusama_validator" {
  source = "github.com/cloudstaking/terraform-gcp-polkadot?ref=1.1.0"

  instance_name = "ksm-validator"
  ssh_key       = "ssh-rsa XXX"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| cloud_init | github.com/cloudstaking/terraform-cloudinit-polkadot?ref=main |  |

## Resources

| Name |
|------|
| [google_compute_firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) |
| [google_compute_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ssh\_key | SSH Key to use for the instance | `string` | n/a | yes |
| zone | Zone where to deploy the validator | `string` | n/a | yes |
| application\_layer | You can deploy the Polkadot using docker containers or in the host itself (using the binary) | `string` | `"host"` | no |
| chain | Chain name: kusama or polkadot. Variable required to download the latest snapshot from polkashots.io | `string` | `"kusama"` | no |
| disk\_size | Disk size. Because chain state constantly grows check the [requirements in the wiki](https://guide.kusama.network/docs/en/mirror-maintain-guides-how-to-validate-kusama) for the advisable sizes | `number` | `200` | no |
| enable\_polkashots | Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io | `bool` | `false` | no |
| firewall\_name | Firewall name | `string` | `""` | no |
| http\_password | Password to access endpoints (e.g node\_exporter) | `string` | `""` | no |
| http\_username | Username to access endpoints (e.g node\_exporter) | `string` | `""` | no |
| instance\_name | Name of the instance | `string` | `"validator"` | no |
| machine\_type | Machine-type/Instance-type: for Kusama n1-standard-2 is fine, for Polkadot maybe n1-highmem-8. This constantly change, check requirements section in the Polkadot wiki | `string` | `"n1-standard-2"` | no |
| p2p\_port | P2P port for Polkadot service, used in `--listen-addr` args | `number` | `30333` | no |
| polkadot\_additional\_common\_flags | CLI arguments appended to the polkadot service (e.g validator name) | `string` | `""` | no |
| proxy\_port | nginx reverse-proxy port to expose Polkadot's libp2p port. Polkadot's libp2p port should not be exposed directly for security reasons (DOS) | `number` | `80` | no |
| public\_fqdn | Public domain for validator. If set, Caddy will use it to request LetsEncrypt certs. This variable is particulary useful to provide a secure channel (HTTPs) for [node\_exporter](https://github.com/prometheus/node_exporter) | `string` | `""` | no |
| tags | A map of tags to add to all resources. | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| http\_password | Password to access private endpoints (e.g node\_exporter) |
| http\_username | Username to access private endpoints (e.g node\_exporter) |
| validator\_public\_ip | Validator public IP address, you can use it to SSH into it |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
