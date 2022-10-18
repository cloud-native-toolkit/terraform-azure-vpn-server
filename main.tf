locals {
   client_config_file = "${var.name_prefix}-client.ovpn"
   server_config_file = "${var.name_prefix}-vpn-config.json"
}

// Open-VPN VM Configurations
module "openvpn-server" {

  source                             = "github.com/cloud-native-toolkit/terraform-azure-vm?ref=v2.0.2"
  name_prefix                        = var.name_prefix
  resource_group_name                = var.resource_group_name
  subnet_id                          = var.subnet_id
  create_ssh                         = false
  use_ssh                            = true
  public                             = true
  pub_ssh_key                        = file(var.pub_ssh_key_file)
  machine_type                       = "Linux"
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

resource "local_file" "server_config" {
  content = templatefile("${path.module}/templates/server-config.json.tftpl",{
    PUBLIC_IP             = module.openvpn-server.vm_public_ip
    CLIENT_NETWORK_BITS   = var.client_network_bits
    CLIENT_NETWORK        = var.client_network
    NETWORK_CIDRS         = var.private_network_cidrs
    PRIVATE_DNS_SVRS      = var.private_dns
  })
  filename = "${path.cwd}/${local.server_config_file}"
  file_permission = "0600"
}

resource "null_resource" "update_config" {
  depends_on = [
    local_file.server_config,
    time_sleep.wait_for_bootrap
  ]

  triggers = {
    ssh_key     = var.private_key_file
    username    = module.openvpn-server.admin_username
    config_file = local.server_config_file
    public_ip   = module.openvpn-server.vm_public_ip
    work_dir    = path.cwd
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/update-svr-config.sh"

    environment = {
      CONFIG_FILE   = self.triggers.config_file
      WORK_DIR      = self.triggers.work_dir
      VM_PUBLIC_IP  = self.triggers.public_ip
      VM_USERNAME   = self.triggers.username
      KEY_FILE      = self.triggers.ssh_key
     }
  }
 
}

resource "null_resource" "download_client_config" {
   depends_on = [
    module.openvpn-server,
    null_resource.update_config
  ]

  triggers = {
    private_ip  = module.openvpn-server.vm_private_ip
    public_ip   = module.openvpn-server.vm_public_ip
    ssh_key     = var.private_key_file
    username    = module.openvpn-server.admin_username
    config_file = local.client_config_file
    work_dir    = path.cwd
  }

  provisioner "local-exec" {
      command = "${path.module}/scripts/download-client-config.sh"

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


