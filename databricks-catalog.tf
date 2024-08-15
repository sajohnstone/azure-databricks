/*
  *** Once the catalog-migration-to-tem job has been run remove the sandbox to remove the catalog and uncomment the new catalog
*/


module "sandbox" {
  source = "./modules/databricks-catalog"
  providers = {
    databricks.workspace = databricks.workspace
    databricks.account   = databricks.account
  }

  name                = "${local.name}_sandbox"
  resource_group_name = azurerm_resource_group.spoke.name
  location            = azurerm_resource_group.spoke.location
  metastore_id        = var.metastore_id
  use_storage_account = false

  depends_on = [
    module.spoke
  ]
}

/*
module "sandbox_new" {
  source = "./modules/databricks-catalog"
  providers = {
    databricks.workspace = databricks.workspace
    databricks.account   = databricks.account
  }

  name                 = "${local.name}_sandbox"
  resource_group_name  = azurerm_resource_group.this.name
  location             = azurerm_resource_group.this.location
  metastore_id         = var.metastore_id
  use_storage_account  = true
  create_catalog       = false
  storage_account_name = "${local.short_name}sa"
  container_name       = "data"

  depends_on = [
    module.spoke
  ]
}
*/
