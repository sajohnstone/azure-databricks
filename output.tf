output "storage_account" {
  sensitive = true
  value = {
    name           = azurerm_storage_account.this.name
    container_name = azurerm_storage_data_lake_gen2_filesystem.this.name
    access_key     = azurerm_storage_account.this.primary_access_key
  }
}

