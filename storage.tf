resource "azurerm_storage_account" "this" {
  name                     = local.name_prefix_short
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  account_kind             = "StorageV2"
  is_hns_enabled           = true #required for DB / ADLS Gen 2
}

resource "azurerm_storage_container" "this" {
  name                  = "${local.name_prefix_short}container"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.this]
}
