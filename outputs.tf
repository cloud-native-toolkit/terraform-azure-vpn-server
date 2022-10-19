output "id" {
  value       = module.openvpn-server.id
  description = "The Azure id of the created VPN server"
}

output "vm_public_ip" {
  value       = module.openvpn-server.vm_public_ip
  description = "The public IP address of the created VPN server"
}

output "vm_public_fqdn" {
  value       = module.openvpn-server.vm_public_fqdn
  description = "The FQDN of the public IP address"
}

output "admin_username" {
  depends_on = [
    module.openvpn-server
  ]
  value       = var.admin_username
  description = "The administrator username of the created VPN server"
}

output "vm_private_ip" {
  value       = module.openvpn-server.vm_private_ip
  description = "The private IP address of the created VPN server"
}

output "client_config_file" {
  depends_on = [
    null_resource.download_client_config
  ]
  value = "${path.cwd}/${local.client_config_file}"
  description = "The full path and filename of the created VPN client connection file"
}
