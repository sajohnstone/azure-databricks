resource "azurerm_resource_group" "this" {
  name     = local.name_prefix
  location = var.location
}

module "privatelink" {
  count    = local.configuration.use_private_link == true ? 1 : 0
  source = "./modules/databricks-privatelink"

  name                     = "${local.name_prefix}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  virtual_network_id       = azurerm_virtual_network.this.id
  private_link_subnet_name = azurerm_subnet.subnet["${local.name_prefix}-privatelink"].id
  workspace_id             = azurerm_databricks_workspace.this.id
  use_frontend_privatelink = true
  use_backend_privatelink  = true

  depends_on = [
    azurerm_virtual_network.this
  ]
}