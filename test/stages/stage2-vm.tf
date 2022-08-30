module "azure-vm" {
  source              = "./module"

  name_prefix         = "${local.name_prefix}-vm"
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnets.id
}