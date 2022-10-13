locals {
   bootstrap_script = var.bootstrap_script == "" ? "${path.module}/templates/vm_user-data.sh" : var.bootstrap_script
   openvpn-test-script = "${path.module}/scripts/openvpn-test.sh"
   private-key-file = "${var.name_prefix}-key"
}

// Open-VPN VM Configurations
module "openvpn-server" {

  source                             = "github.com/cloud-native-toolkit/terraform-azure-vm?ref=v2.0.2"
  name_prefix                        = var.name_prefix
  resource_group_name                = var.resource_group_name
  subnet_id                          = var.subnet_id
  create_ssh                         = var.create_ssh
  use_ssh                            = var.use_ssh
  machine_type                       = var.machine_type
  private_ip_address_allocation_type = var.private_ip_address_allocation_type

  vm_size          = var.vm_size
  storage_type     = var.storage_type
  admin_username   = var.admin_username
  bootstrap_script = local.bootstrap_script
  
}

resource "null_resource" "print_name" {
   depends_on = [
    module.openvpn-server
  ]

  provisioner "local-exec" {
      command = "chmod 400 ${local.private-key-file} ; ${local.openvpn-test-script} ${module.openvpn-server.vm_private_ip} ${module.openvpn-server.vm_public_ip} ${local.private-key-file} ${var.admin_username} "
  }
}


