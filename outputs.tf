output "id" {
  value = azurerm_linux_virtual_machine.vm-openvpn.id
}

output "vm_public_ip" {
  value = azurerm_public_ip.vm_public_ip.ip_address
}

output "vm_public_fqdn" {
  value = azurerm_public_ip.vm_public_ip.fqdn
}

output "admin_username" {
  depends_on = [
    azurerm_linux_virtual_machine.vm-openvpn
  ]
  value = var.admin_username
}
