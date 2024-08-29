data "azurerm_client_config" "current" {}

data "azurerm_subnet" "public" {
  name                 = var.spoke_public_subnet
  virtual_network_name = var.spoke_vnet_name
  resource_group_name  = var.hub_resource_group_name
}

data "azurerm_subnet" "private" {
  name                 = var.spoke_private_subnet
  virtual_network_name = var.spoke_vnet_name
  resource_group_name  = var.hub_resource_group_name
}

data "azurerm_network_security_group" "public_subnet_nsg" {
  name                = var.spoke_public_nsg
  resource_group_name = var.hub_resource_group_name
}

data "azurerm_network_security_group" "private_subnet_nsg" {
  name                = var.spoke_private_nsg
  resource_group_name = var.hub_resource_group_name
}

data "azurerm_subnet" "privatelink" {
  name                 = var.spoke_privatelink_subnet
  virtual_network_name = var.spoke_vnet_name
  resource_group_name  = var.hub_resource_group_name
}

data "azurerm_virtual_network" "spoke_vnet" {
  name                = var.spoke_vnet_name
  resource_group_name = var.hub_resource_group_name
}

data "azurerm_private_dns_zone" "auth_front" {
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = var.hub_resource_group_name
}

data "azurerm_subnet" "hub_privatelink_subnet" {
  name                 = var.hub_privatelink_subnet
  virtual_network_name = var.hub_vnet_name
  resource_group_name  = var.hub_resource_group_name
}

data "azurerm_storage_account" "this" {
  count = var.boolean_adfs_privatelink ? 1 : 0

  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}
