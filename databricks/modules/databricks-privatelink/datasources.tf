data "azurerm_subnet" "privatelink" {
  name                 = var.private_link_subnet_name
  virtual_network_name = var.databricks_vnet_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_virtual_network" "this" {
  name                = var.databricks_vnet_name
  resource_group_name = var.resource_group_name
}
