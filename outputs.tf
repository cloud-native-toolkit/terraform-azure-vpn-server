output "id" {
  value = module.openvpn-server.id
}

output "vm_public_ip" {
  value = module.openvpn-server.vm_public_ip
}

output "vm_public_fqdn" {
  value = module.openvpn-server.vm_public_fqdn
}

output "admin_username" {
  depends_on = [
    module.openvpn-server
  ]
  value = var.admin_username
}
