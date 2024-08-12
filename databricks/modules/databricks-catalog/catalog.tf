resource "databricks_catalog" "this" {
  count = var.create_catalog == true ? 1 : 0

  provider = databricks.workspace

  metastore_id = var.metastore_id
  name         = var.name
  comment      = var.comment
  owner        = var.owner
  storage_root = var.use_storage_account == true ? "abfss://${azurerm_storage_container.this[0].name}@${azurerm_storage_account.this[0].name}.dfs.core.windows.net/" : null

  depends_on = [
    azurerm_storage_account.this[0],
    databricks_external_location.this[0]
  ]
}
