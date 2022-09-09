output "id" {
  value = data.azurerm_virtual_machine.vm.id
}

output "vm_public_ip" {
  value = var.public ? data.azurerm_virtual_machine.vm.public_ip_address : ""
}

output "vm_public_fqdn" {
  value = var.public ? azurerm_public_ip.vm_public_ip.fqdn : ""
  # value = var.public ? azurerm_public_ip.vm_public_ip[0].fqdn : ""
}

output "admin_username" {
  depends_on = [
    data.azurerm_virtual_machine.vm
  ]
  value = var.admin_username
}
