resource "azurerm_resource_group" "this" {
  name     = local.name_prefix
  location = var.location
}

module "privatelink" {
  count  = local.configuration.use_private_link == true ? 1 : 0
  source = "./modules/databricks-privatelink"

  name                          = local.name_prefix
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  databricks_vnet_name          = data.azurerm_virtual_network.this.name
  databricks_privatelink_subnet = data.azurerm_subnet.privatelink.name
  workspace_name                = azurerm_databricks_workspace.this.name
  databricks_vnet_rg_name       = var.databricks_vnet_rg_name
  use_frontend_privatelink      = true
  use_backend_privatelink       = true
  use_adfs_privatelink          = false
  storage_account_name          = module.sandbox_new.storage_account_name

  depends_on = [
    data.azurerm_virtual_network.this,
    module.module.sandbox,
    module.module.sandbox_new
  ]
}
