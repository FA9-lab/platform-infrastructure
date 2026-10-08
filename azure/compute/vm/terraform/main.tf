locals {
  resource_name = "${var.application}-${var.environment}-${var.region}-${var.deployment_id}-${var.request_id}"

  common_tags = {
    Application  = var.application
    Environment  = var.environment
    Region       = var.region
    DeploymentId = var.deployment_id
    RequestId    = var.request_id
    ManagedBy    = "PELab-IDP"
  }
}

resource "azurerm_network_interface" "this" {
  name                = "${local.resource_name}-nic"
  location            = var.region
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.common_tags
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = local.resource_name
  location            = var.region
  resource_group_name = var.resource_group
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.this.id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = local.common_tags
}
