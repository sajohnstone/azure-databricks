data "azurerm_client_config" "current" {}

data "azurerm_subnet" "public" {
  name                 = var.databricks_public_subnet
  virtual_network_name = var.databricks_vnet_name
  resource_group_name  = var.databricks_vnet_rg_name
}

data "azurerm_subnet" "private" {
  name                 = var.databricks_private_subnet
  virtual_network_name = var.databricks_vnet_name
  resource_group_name  = var.databricks_vnet_rg_name
}

data "azurerm_subnet" "privatelink" {
  name                 = var.databricks_privatelink_subnet
  virtual_network_name = var.databricks_vnet_name
  resource_group_name  = var.databricks_vnet_rg_name
}

data "azurerm_virtual_network" "this" {
  name                = var.databricks_vnet_name
  resource_group_name = var.databricks_vnet_rg_name
}
