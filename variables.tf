variable "resource_group_name" {
  type        = string
  description = "The name of the Azure resource group where the VM is to be provisioned. The VM will be provisioned in the same location as the resource group."
}

variable "subnet_id" {
  type        = string
  description = "The Azure subnet id to which to attach the virtual machine private NIC"
}

variable "name_prefix" {
  type        = string
  description = "Name to prefix resources created"
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

// Open VPN OS image properties
variable "openvpn_image_publisher" {
  type        = string
  description = "Open VPN OS image publisher name (default = \"openvpn\")"
  default     = "openvpn"
}

variable "openvpn_image_offer" {
  type        = string
  description = "Open VPN OS image source offer (default = \"openvpnas\")"
  default     = "openvpnas"
}

variable "openvpn_image_sku" {
  type        = string
  description = "Open VPN OS image SKU (defualt = \"access_server_byol\")"
  default     = "access_server_byol"
}

variable "openvpn_image_version" {
  type        = string
  description = "Linux OS image version (default = \"latest\")"
  default     = "latest"
}
