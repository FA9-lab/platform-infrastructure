variable "storage_account_name" {
  description = "Globally unique Azure Storage Account name"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Storage Account name must be 3–24 lowercase letters or numbers."
  }
}

variable "resource_group_name" {
  description = "Existing landing-zone resource group"
  type        = string
}

variable "location" {
  description = "Azure region approved by the landing-zone policy"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment tag required by Azure Policy"
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}
