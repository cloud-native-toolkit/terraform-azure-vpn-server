
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

variable "pub_ssh_key_file" {
  type        = string
  description = "Path to the public SSH key for VM access."
}

variable "private_key_file" {
  type        = string
  description = "Path to the SSH private key for remote access."
}

variable "private_network_cidrs" {
  type = list(string)
  description = "List of CIDRs in the private network reachable via the VPN server."
}

variable "private_dns" {
  type = list(string)
  description = "List of private DNS servers"
  default = ["168.63.129.16"]
}

variable "name_prefix" {
  type        = string
  description = "Name to prefix resources created"
  default     = "open-vpn"
}

variable "client_network" {
  type = string
  description = "Network address for VPN clients (default = \"172.27.224.0\")"
  default = "172.27.224.0"
}

variable "client_network_bits" {
  type = string
  description = "Number of netmask bits for the VPN client network (default = \"24\")"
  default = "24"
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
