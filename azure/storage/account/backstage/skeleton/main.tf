module "storage_account" {
  source = "git::https://github.com/FA9-lab/platform-infrastructure.git//azure/storage/account/terraform?ref=main"

  storage_account_name = "${{ values.storageAccountName }}"
  resource_group_name  = "${{ values.resourceGroup }}"
  location             = "${{ values.region }}"
  environment          = "${{ values.environment }}"
}
