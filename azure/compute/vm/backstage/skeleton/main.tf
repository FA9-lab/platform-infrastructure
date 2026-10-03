module "vm" {
  source = "git::https://github.com/FA9-lab/platform-infrastructure.git//azure/compute/vm/terraform?ref=main"

  application   = "${{ values.application }}"
  environment   = "${{ values.environment }}"
  region        = "${{ values.region }}"
  request_id    = "${{ values.requestId }}"
  deployment_id = "${{ values.deploymentId }}"

  resource_group = "${{ values.resourceGroup }}"
  subnet_id      = "${{ values.subnetId }}"

  vm_size              = "${{ values.vmSize }}"
  admin_username       = "azureadmin"
  admin_ssh_public_key = "${{ values.adminSshPublicKey }}"
}
