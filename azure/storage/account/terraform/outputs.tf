output "storage_account_id" {
  description = "Azure resource ID of the Storage Account"
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "Name of the provisioned Storage Account"
  value       = azurerm_storage_account.this.name
}

output "primary_blob_endpoint" {
  description = "Primary Blob Storage endpoint"
  value       = azurerm_storage_account.this.primary_blob_endpoint
}
