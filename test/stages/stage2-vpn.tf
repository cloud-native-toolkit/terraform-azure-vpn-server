module "azure-vm-opnvpn" {
  source = "./module"

  name_prefix          = "${local.name_prefix}-openvpn"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.vnet.name
  subnet_id            = module.subnets.id
  pub_ssh_key_file     = module.test-keys.pub_key_file
  private_key_file     = module.test-keys.private_key_file
}