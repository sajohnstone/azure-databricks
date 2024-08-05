resource "azurerm_storage_account" "this" {
  count    = var.use_storage_account == true ? 1 : 0

  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_replication_type = var.account_replication_type
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"
  account_kind             = "StorageV2"
  is_hns_enabled           = true
}

resource "azurerm_storage_container" "this" {
  count    = var.use_storage_account == true ? 1 : 0
  
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.this[0].name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.this[0]]
}
