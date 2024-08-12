/*
  *** Once the catalog-migration-to-tem job has been run remove the sandbox to remove the catalog and uncomment the new catalog
*/

module "sandbox" {
  source = "./modules/databricks-catalog"
  providers = {
    databricks.workspace = databricks.workspace
    databricks.account   = databricks.account
  }

  name                = "${var.environment}_${var.project}_sandbox"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  metastore_id        = var.metastore_id
  use_storage_account = false

  depends_on = [
    databricks_metastore_assignment.this
  ]
}

/*
module "sandbox_new" {
  source = "./modules/databricks-catalog"
  providers = {
    databricks.workspace = databricks.workspace
    databricks.account   = databricks.account
  }

  name                = "${var.environment}_${var.project}_sandbox"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  metastore_id        = var.metastore_id
  use_storage_account = true

  storage_account_name = "${local.name_prefix_short}sa"
  container_name       = "data"

  depends_on = [
    databricks_metastore_assignment.this
  ]
}
*/