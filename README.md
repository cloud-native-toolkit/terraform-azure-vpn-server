# Azure VPN Server

## Module overview

Module creates an Azure VPN Server. It includes the following resources:
- tls_private_key
- openvpn-server

### Software dependencies

- terraform >= 1.2.6

### Terraform providers

- Azure provider >= 3.0.0

### Module dependencies

This modules makes use of the output from other modules:
- Azure Resource Group - github.com/cloud-native-toolkit/terraform-azure-resource-group
- Azure VNet - github.com/cloud-native-toolkit/terraform-azure-vnet
- Azure Subnets - github.com/cloud-native-toolkit/terraform-azure-subnets
- Azure SSH Key - github.com/cloud-native-toolkit/teraform-azure-ssh-key

## Example Usage

```hcl-terraform
module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-azure-resource-group"

  resource_group_name = "mytest-rg"
  region              = var.region
}

module "vnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-vnet"

  name_prefix         = "mytest"
  resource_group_name = module.resource_group.name
  region              = module.resource_group.region
  address_prefixes    = ["10.0.0.0/18"]
}

module "subnets" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets"

  resource_group_name = module.resource_group.name
  region              = module.resource_group.region
  vnet_name           = module.vnet.name
  ipv4_cidr_blocks    = ["10.0.0.0/24"]
  acl_rules           = []
}

module "vm" {
  source               = "github.com/cloud-native-toolkit/terraform-azure-vm"
  
  name_prefix         = "mytest-vm"
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnets.id
}
```
## Variables

### Inputs

This module has the following input variables:
| Variable | Mandatory / Optional | Default Value | Description |
| -------------------------------- | --------------| ------------------ | ----------------------------------------------------------------------------- |
| resource_group_name | Mandatory |  | The resource group to which to associate the VPN Server  |
| virtual_network_name | Mandatory |  | The virtual network to which to associate the VPN Server  |
| subnet_id | Mandatory | | The id of the subnet to which to associate the VPN Server| 
| pub_ssh_key_file | Mandatory | | Path to the public SSH key for VPN Server access. |
| private_key_file | Mandatory | | Path to the private SSH key for VPN Server access. |
| private_network_cidrs | Mandatory | | List of CIDRs in the private network reachable via the VPN server. |
| private_dns | Optional | ["168.63.129.16"] | List of private DNS servers. |
| name_prefix | Optional | open-vpn | Name to prefix resources created |
| client_network | Optional | 172.27.224.0 | Network address for VPN clients (default = \"172.27.224.0\") |
| client_network_bits | Optional | 24 | Number of netmask bits for the VPN client network (default = \"24\") |
| private_ip_address_allocation_type | Optional | Dynamic | The Azure subnet private ip address alocation type - Dynamic or Static (default = \"Dynamic\") |
| admin_username | Optional | azureuser | Username for the admin user (default = \"azureuser\") |
| bootstrap_script | Mandatory | | Path to file with the bootstrap script (default = \"./template/user-data.sh\") |
| vm_size | Optional | Standard_F2 | This is the size of Virtual Machine (defualt = \"Standard_F2\") |
| storage_type | Optional | Standard_LRS | Storage account type |
| vm_public_ip_sku | Optional | Standard | Public IP SKU Size (default = \"Standard\" |
| vm_public_ip_allocation_method | Optional | Static | The Azure subnet Public ip address alocation type - Dynamic or Static (default = \"Static\" |

### Outputs

The module outputs the following values:
| Output | Description |
| -------------------------------- | -------------------------------------------------------------------------- |
| id | The Id of the deployed vpn server |
| vm_public_ip | The address of the public IP if created |
| vm_public_fqdn | The FQDN of the public IP if created |
| vm_private_ip | The address of the VM on the supplied subnet |
| admin_username | The name of the administrator username |
| client_config_file | VPN server client configuration file to connect vpn server |

