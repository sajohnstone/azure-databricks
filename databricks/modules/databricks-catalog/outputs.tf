output "catalog_name" {
  description = "The ID of the resource group"
  value       = databricks_catalog.this.name
}

output "storage_account_name" {
  value = azurerm_storage_account.this[0].name
}