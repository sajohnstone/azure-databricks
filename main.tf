resource "azurerm_resource_group" "hub" {
  name     = "${local.name}-hub"
  location = local.location
}

module "hub" {
  source = "./modules/azure_hub"

  name                         = local.name
  location                     = azurerm_resource_group.hub.location
  resource_group_name          = azurerm_resource_group.hub.name
  azure_subscription_id        = local.workspace.databricks.azure_subscription_id
  tags                         = local.workspace.tags
  vnets                        = local.workspace.network.vnets
  peerings                     = local.workspace.network.peerings
  nsg_rules                    = local.workspace.network.nsg_rules
  boolean_create_bastion       = false
  boolean_create_log_analytics = true

  providers = {
    azurerm = azurerm
  }
}

resource "azurerm_resource_group" "spoke" {
  name     = "${local.name}-spoke"
  location = local.location
}

module "spoke" {
  source = "./modules/azure_spoke"

  name                = "${local.name}-spoke"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  tags                = local.workspace.tags

  metastore_id               = var.metastore_id
  databricks_account_id      = var.databricks_account_id
  azure_subscription_id      = local.workspace.databricks.azure_subscription_id
  boolean_adb_private_link   = false
  boolean_adfs_privatelink   = false
  storage_account_name       = ""
  boolean_enable_logging     = true
  log_analytics_workspace_id = module.hub.log_analytics_workspace_id
  databricks_sku             = local.workspace.databricks.sku

  spoke_vnet_name          = "${local.name}-nonprod-vnet"
  spoke_private_subnet     = "snet-${local.name}-nonprod-host"
  spoke_public_subnet      = "snet-${local.name}-nonprod-container"
  spoke_privatelink_subnet = "snet-${local.name}-nonprod-privatelink"
  spoke_public_nsg         = "${local.name}-nonprod-host"
  spoke_private_nsg        = "${local.name}-nonprod-container"

  hub_resource_group_name = "${local.name}-hub"
  hub_vnet_name           = "${local.name}-hub-vnet"
  hub_privatelink_subnet  = "snet-${local.name}-hub-privatelink"

  providers = {
    azurerm              = azurerm
    databricks.account   = databricks.account
    databricks.workspace = databricks.workspace
  }

  depends_on = [module.hub]
}

module "rbac" {
  source = "./modules/rbac"

  providers = {
    azurerm              = azurerm
    databricks.account   = databricks.account
    databricks.workspace = databricks.workspace
  }

  depends_on = [module.spoke]  
}
