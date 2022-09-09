locals {
  net_if_name    = "${var.name_prefix}-nic"
  ip_config_name = "${var.name_prefix}-ip-config"
  vm_name        = "${var.name_prefix}-vm"
  os_disk_name   = "${var.name_prefix}-osdisk"
  public_ip_name = "${var.name_prefix}-pip"
  key_name       = "${var.name_prefix}-key"

  bootstrap_script = var.bootstrap_script == "" ? var.machine_type == "Linux" ? "${path.module}/templates/linux_user-data.sh" : "${path.module}/templates/win_user-data" : var.bootstrap_script
}

// Get resource group details
data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

// OpenVPN VM Configurations

resource "azurerm_linux_virtual_machine" "vm-openvpn" {
  # count = var.machine_type == "Linux" && var.use_ssh ? 1 : 0

  name                = local.vm_name
  computer_name       = local.vm_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  size                = var.vm_size
  admin_username      = var.admin_username
  custom_data         = base64encode(templatefile(local.bootstrap_script, {}))

  network_interface_ids = [data.azurerm_network_interface.vm_nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.pub_ssh_key == "" ? data.local_file.pub_key[0].content : var.pub_ssh_key
  }

  os_disk {
    name                 = local.os_disk_name
    caching              = "ReadWrite"
    storage_account_type = var.storage_type
  }

  plan {
    name      = var.openvpn_image_sku
    product   = var.openvpn_image_offer
    publisher = var.openvpn_image_publisher
  }

  source_image_reference {
    publisher = var.openvpn_image_publisher
    offer     = var.openvpn_image_offer
    sku       = var.openvpn_image_sku
    version   = var.openvpn_image_version
  }
}

data "azurerm_virtual_machine" "vm" {
  #   name                = var.machine_type == "Linux" ? var.use_ssh ? azurerm_linux_virtual_machine.vm-openvpn[0].name : azurerm_linux_virtual_machine.vm-pwd[0].name : azurerm_windows_virtual_machine.vm[0].name
  name                = var.machine_type
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

// Create public IP and public NIC if required
resource "azurerm_public_ip" "vm_public_ip" {
  # count = var.public ? 1 : 0

  name                = local.public_ip_name
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  sku                 = var.vm_public_ip_sku
  allocation_method   = var.vm_public_ip_allocation_method
}

resource "azurerm_network_interface" "public" {
  # count = var.public ? 1 : 0

  name                          = "${local.net_if_name}-public"
  location                      = data.azurerm_resource_group.resource_group.location
  resource_group_name           = data.azurerm_resource_group.resource_group.name
  enable_accelerated_networking = var.azurerm_network_interface_accelerated_networking

  ip_configuration {
    name                          = local.ip_config_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation_type
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

// Read the NIC info for whichever one was required (public or private)
data "azurerm_network_interface" "vm_nic" {
  name                = azurerm_network_interface.public.name
  resource_group_name = data.azurerm_resource_group.resource_group.name
}


// Create ssh key for Open VPN Server if not provided

resource "tls_private_key" "key" {
  count = var.machine_type == "Linux" && var.create_ssh && var.use_ssh ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "private_key" {
  count = var.machine_type == "Linux" && var.create_ssh && var.use_ssh ? 1 : 0

  content         = tls_private_key.key[0].private_key_pem
  filename        = "${path.cwd}/${local.key_name}"
  file_permission = "0600"
}

resource "local_file" "public_key" {
  count = var.machine_type == "Linux" && var.create_ssh && var.use_ssh ? 1 : 0

  content         = tls_private_key.key[0].public_key_openssh
  filename        = "${path.cwd}/${local.key_name}.pub"
  file_permission = "0644"
}

data "local_file" "pub_key" {
  count = var.machine_type == "Linux" && var.create_ssh && var.use_ssh ? 1 : 0

  depends_on = [
    local_file.public_key
  ]

  filename = "${path.cwd}/${local.key_name}.pub"
}
