module "test-keys" {
  source = "github.com/cloud-native-toolkit/terraform-azure-ssh-key?ref=v1.0.6"

  resource_group_name = module.resource_group.name
  region              = module.resource_group.region
  store_path          = "${path.cwd}/.ssh"
}