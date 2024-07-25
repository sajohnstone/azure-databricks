resource "databricks_catalog" "sandbox" {
  provider = databricks.workspace

  metastore_id = var.metastore_id
  name         = "${var.environment}_${var.project}_sandbox"
  comment      = "this catalog is managed by terraform"
  #owner        = databricks_group.uc_admins.display_name

  properties = {
    purpose = "testing"
  }

  depends_on = [
    databricks_metastore_assignment.this
  ]
}

resource "databricks_catalog" "sandbox_new" {
  provider = databricks.workspace

  metastore_id = var.metastore_id
  name         = "${var.environment}_${var.project}_sandbox_new"
  comment      = "this catalog is managed by terraform"
  #owner        = databricks_group.uc_admins.display_name
  storage_root = "abfss://${azurerm_storage_container.this.name}@${azurerm_storage_account.this.name}.dfs.core.windows.net/"

  properties = {
    purpose = "testing"
  }

  depends_on = [
    databricks_metastore_assignment.this,
    azurerm_storage_account.this,
    databricks_external_location.external
  ]
}
