resource "azurerm_databricks_access_connector" "external" {
  name                = local.name_prefix
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

resource "databricks_storage_credential" "external" {
  provider = databricks.workspace

  name = azurerm_databricks_access_connector.external.name
  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.external.id
  }
  #owner   = databricks_group.uc_admins.display_name
  comment = "External Storage Account"

  depends_on = [databricks_metastore_assignment.this]
}

resource "azurerm_role_assignment" "external" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.external.identity[0].principal_id

  depends_on = [azurerm_storage_account.this, azurerm_storage_container.this]
}

resource "databricks_external_location" "external" {
  provider = databricks.workspace

  name = local.name_prefix
  url  = "abfss://${azurerm_storage_container.this.name}@${azurerm_storage_account.this.name}.dfs.core.windows.net/"

  credential_name = databricks_storage_credential.external.id
  #owner           = databricks_group.uc_admins.display_name
  comment = "External Location"
}
