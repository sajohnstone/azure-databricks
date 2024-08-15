resource "azurerm_databricks_access_connector" "this" {
  count = var.use_storage_account == true ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "databricks_storage_credential" "this" {
  count    = var.use_storage_account == true ? 1 : 0
  provider = databricks.workspace

  name = azurerm_databricks_access_connector.this[0].name
  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.this[0].id
  }
  owner   = var.owner
  comment = var.comment
}

resource "azurerm_role_assignment" "this" {
  count = var.use_storage_account == true ? 1 : 0

  scope                = azurerm_storage_account.this[0].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.this[0].identity[0].principal_id

  depends_on = [azurerm_storage_account.this[0], azurerm_storage_container.this[0]]
}

resource "databricks_external_location" "this" {
  count    = var.use_storage_account == true ? 1 : 0
  provider = databricks.workspace

  name            = var.name
  url             = "abfss://${azurerm_storage_container.this[0].name}@${azurerm_storage_account.this[0].name}.dfs.core.windows.net/"
  credential_name = databricks_storage_credential.this[0].id

  owner   = var.owner
  comment = var.comment
}
