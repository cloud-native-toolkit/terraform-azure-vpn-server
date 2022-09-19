
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
  default     = "opn-vpn"
}

variable "machine_type" {
  type        = string
  description = "The type of VM to create - (default = \"Linux\")"
  default     = "Linux"
}

variable "use_ssh" {
  type        = bool
  description = "Use SSH key for access to Linux VM (default = \"true\")"
  default     = true
}

variable "pub_ssh_key" {
  type        = string
  description = "Public SSH key for VM access. Provide an empty variable for windows VMs as it is not used."
  default     = ""
}

variable "create_ssh" {
  type        = bool
  description = "Flag to determine whether to create an SSH key pair (default = \"true\")"
  default     = true
}

variable "public" {
  type        = bool
  description = "Flag to indicate if VM shoudl have a public IP allocated (default = \"true\")"
  default     = true
}

variable "private_ip_address_allocation_type" {
  type        = string
  description = "The Azure subnet private ip address alocation type - Dynamic or Static (default = \"Dynamic\")"
  default     = "Dynamic"
}

variable "admin_username" {
  type        = string
  description = "Username for the admin user (default = \"adminuser\")"
  default     = "adminuser"
}

variable "bootstrap_script" {
  type        = string
  description = "Path to file with the bootstrap script (default = \"./template/user-data.sh\")"
  default     = ""
}

variable "vm_size" {
  type        = string
  description = "This is the size of Virtual Machine (defualt = \"Standard_F2\")"
  default     = "Standard_D2_v3"
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


# variable "openvpn_image_publisher" {
#   type        = string
#   description = "Open VPN OS image publisher name (default = \"openvpn\")"
#   default     = "openvpn"
# }

# variable "openvpn_image_offer" {
#   type        = string
#   description = "Open VPN OS image source offer (default = \"openvpnas\")"
#   default     = "openvpnas"
# }

# variable "openvpn_image_sku" {
#   type        = string
#   description = "Open VPN OS image SKU (defualt = \"access_server_byol\")"
#   default     = "access_server_byol"
# }

# variable "openvpn_image_version" {
#   type        = string
#   description = "Linux OS image version (default = \"latest\")"
#   default     = "latest"
# }


