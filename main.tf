locals {
  net_if_name    = "${var.name_prefix}-nic"
  ip_config_name = "${var.name_prefix}-ip-config"
  vm_name        = "${var.name_prefix}-opnvm"
  os_disk_name   = "${var.name_prefix}-osdisk"
  public_ip_name = "${var.name_prefix}-pip"
  key_name       = "${var.name_prefix}-key"

  bootstrap_script = var.bootstrap_script == "" ? "${path.module}/templates/linux_user-data.sh" : var.bootstrap_script
}

// Get resource group details
data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

// OpenVPN VM Configurations
module "openvpn-server" {

  source                             = "github.com/cloud-native-toolkit/terraform-azure-vm?ref=v2.0.2"
  name_prefix                        = local.vm_name
  resource_group_name                = var.resource_group_name
  subnet_id                          = var.subnet_id
  create_ssh                         = var.create_ssh
  use_ssh                            = var.use_ssh
  machine_type                       = var.machine_type
  private_ip_address_allocation_type = var.private_ip_address_allocation_type

  vm_size          = var.vm_size
  storage_type     = var.storage_type
  admin_username   = var.admin_username
  bootstrap_script = locals.bootstrap_script

}

# data "azurerm_linux_virtual_machine" "vm" {
#   name                = data.azurerm_linux_virtual_machine.name
#   resource_group_name = data.azurerm_resource_group.resource_group.name
# } 


