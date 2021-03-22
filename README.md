# terraform-scaleway-polkadot

Terraform module for provisioning ready-to-use _single node_ (or optionally _active-standby_) Kusama/Polkadot validators in AWS. Besides infrastructure (security group, instance, volume, etc), it also does:

- Pulls the latest snapshot from [Polkashots](https://polkashots.io)
- Creates a docker-compose with the [latest polkadot's release](https://github.com/paritytech/polkadot/releases) and nginx reverse-proxy (for libp2p port).

## Usage

```hcl
module "kusama_validator" {
  source = "github.com/cloudstaking/terraform-gcp-polkadot?ref=1.0.0"

  instance_name = "ksm-validator"
  ssh_key       = "ssh-rsa XXX"
  chain         = "kusama"
}
```

If `enable_polkashots` is set, it'll take ~10 minutes to download and extract the latest snapshot. You can check the process within the instance with `tail -f  /var/log/cloud-init-output.log`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| github | n/a |
| google | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [github_release](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/release) |
| [google_compute_firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) |
| [google_compute_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| chain | Chain name: kusama or polkadot. Variable required to download the latest snapshot from polkashots.io | `string` | `"kusama"` | no |
| disk\_size | Disk size. Because chain state constantly grows check the [requirements in the wiki](https://guide.kusama.network/docs/en/mirror-maintain-guides-how-to-validate-kusama) for the advisable sizes | `number` | `200` | no |
| enable\_polkashots | Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io | `bool` | `true` | no |
| firewall\_name | Firewall name | `string` | `""` | no |
| firewall\_whitelisted\_ssh\_ip | List of CIDRs the instance is going to accept SSH connections from. | `string` | `"0.0.0.0/0"` | no |
| instance\_name | Name of the instance | `string` | `"validator"` | no |
| machine\_type | Machine-type/Instance-type: for Kusama n1-standard-2 is fine, for Polkadot maybe n1-highmem-8. This constantly change, check requirements section in the Polkadot wiki | `string` | `"n1-standard-2"` | no |
| polkadot\_additional\_common\_flags | Application layer - when `enable_application_layer_docker = true`, the content of this variable will be appended to the polkadot command arguments | `string` | `""` | no |
| ssh\_key | SSH Key to use for the instance | `any` | n/a | yes |
| tags | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| zone | Zone where to deploy the validator | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| validator\_public\_ip | Validator public IP address, you can use it to SSH into it |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
