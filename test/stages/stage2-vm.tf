module "azure-vm" {
  source              = "./module"

  name_prefix         = "${local.name_prefix}-vm"
  resource_group_name = module.resource_group.name
  virtual_network_name = module.vnet.name
  subnet_id           = module.subnets.id
}