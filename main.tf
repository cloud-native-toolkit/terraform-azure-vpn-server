locals {
   private-key-file = "${var.name_prefix}-key"
   client_config_file = "${var.name_prefix}-client.ovpn"
}

// Open-VPN VM Configurations
module "openvpn-server" {

  source                             = "github.com/cloud-native-toolkit/terraform-azure-vm?ref=v2.0.2"
  name_prefix                        = var.name_prefix
  resource_group_name                = var.resource_group_name
  subnet_id                          = var.subnet_id
  create_ssh                         = true
  use_ssh                            = var.use_ssh
  pub_ssh_key                        = var.pub_ssh_key
  machine_type                       = var.machine_type
  private_ip_address_allocation_type = var.private_ip_address_allocation_type

  vm_size          = var.vm_size
  storage_type     = var.storage_type
  admin_username   = var.admin_username
  bootstrap_script = "${path.module}/templates/vm_user-data.sh"
  
}

resource "time_sleep" "wait_for_bootrap" {
  depends_on = [
    module.openvpn-server
  ]

  create_duration = "120s"
}

resource "null_resource" "download_config" {
   depends_on = [
    module.openvpn-server,
    time_sleep.wait_for_bootrap
  ]

  triggers = {
    private_ip  = module.openvpn-server.vm_private_ip
    public_ip   = module.openvpn-server.vm_public_ip
    ssh_key     = local.private-key-file
    username    = module.openvpn-server.admin_username
    config_file = local.client_config_file
    work_dir    = path.cwd
  }

  provisioner "local-exec" {
      command = "${path.module}/scripts/download-config.sh"

      environment = {
        VM_PRIVATE_IP       = self.triggers.private_ip
        VM_PUBLIC_IP        = self.triggers.public_ip
        KEY_FILE            = self.triggers.ssh_key
        VM_USERNAME         = self.triggers.username
        CLIENT_CONFIG_FILE  = self.triggers.config_file
        WORK_DIR            = self.triggers.work_dir
       }
  }

  provisioner "local-exec" {
    when = destroy

    command = "rm ${self.triggers.work_dir}/${self.triggers.config_file}"
  }
}


