output "validator_public_ip" {
  value       = google_compute_instance.validator.*.network_interface.0.access_config.0.nat_ip
  description = "Validator public IP address, you can use it to SSH into it"
}
