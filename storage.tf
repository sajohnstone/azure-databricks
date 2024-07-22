resource "azurerm_storage_account" "this" {
  name = format("sa%s%s%s",
  local.naming.location[var.location], var.environment, var.project)
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "BlobStorage"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  name = format("fs%s%s%s",
  local.naming.location[var.location], var.environment, var.project)
  storage_account_id = azurerm_storage_account.this.id
}
