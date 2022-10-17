
variable "resource_group_name" {
  type        = string
  description = "The name of the Azure resource group where the VM is to be provisioned. The VM will be provisioned in the same location as the resource group."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the Azure VNet."
}

variable "subnet_id" {
  type        = string
  description = "The Azure subnet id to which to attach the virtual machine private NIC"
}

# variable "azurerm_network_interface_accelerated_networking" {
#   type        = bool
#   description = "Use SSH key for access to Linux VM (default = \"true\")"
#   default     = true
# }

variable "name_prefix" {
  type        = string
  description = "Name to prefix resources created"
  default     = "open-vpn"
}

variable "pub_ssh_key_file" {
  type        = string
  description = "Path to the public SSH key for VM access."
  default     = ""
}

variable "private_key_file" {
  type        = string
  description = "Path to the SSH private key for remote access."
  default     = ""
}

variable "private_ip_address_allocation_type" {
  type        = string
  description = "The Azure subnet private ip address alocation type - Dynamic or Static (default = \"Dynamic\")"
  default     = "Dynamic"
}

variable "admin_username" {
  type        = string
  description = "Username for the admin user (default = \"adminuser\")"
  default     = "azureuser"
}

variable "bootstrap_script" {
  type        = string
  description = "Path to file with the bootstrap script (default = \"./template/user-data.sh\")"
  default     = ""
}

variable "vm_size" {
  type        = string
  description = "This is the size of Virtual Machine (defualt = \"Standard_F2\")"
  default     = "Standard_B1s"
}

variable "storage_type" {
  type        = string
  description = "Storage account type (default = \"StandardSSD_LRS\")"
  default     = "StandardSSD_LRS"
}

variable "vm_public_ip_sku" {
  type        = string
  description = "Public IP SKU Size (default = \"Standard\")"
  default     = "Standard"
}

variable "vm_public_ip_allocation_method" {
  type        = string
  description = "The Azure subnet Public ip address alocation type - Dynamic or Static (default = \"Dynamic\")"
  default     = "Static"
}
