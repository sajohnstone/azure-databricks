output "catalog_name" {
  description = "The ID of the resource group"
  value       = databricks_catalog.this[0].name
}

output "storage_account_name" {
  value = var.use_storage_account == true ? azurerm_storage_account.this[0].name : ""
}
