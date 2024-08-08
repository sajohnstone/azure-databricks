data "azurerm_subnet" "privatelink" {
  name                 = var.databricks_privatelink_subnet
  virtual_network_name = var.databricks_vnet_name
  resource_group_name  = var.databricks_vnet_rg_name
}

data "azurerm_virtual_network" "this" {
  name                = var.databricks_vnet_name
  resource_group_name = var.databricks_vnet_rg_name
}

data "azurerm_databricks_workspace" "this" {
  name                = var.workspace_name
  resource_group_name = var.resource_group_name
}

data "azurerm_storage_account" "this" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}
