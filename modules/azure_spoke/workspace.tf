resource "azurerm_databricks_workspace" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.databricks_sku

  public_network_access_enabled         = !var.boolean_adb_private_link
  network_security_group_rules_required = var.boolean_adb_private_link ? "NoAzureDatabricksRules" : "AllRules"

  custom_parameters {
    no_public_ip                                         = var.boolean_adb_private_link
    virtual_network_id                                   = data.azurerm_virtual_network.spoke_vnet.id
    public_subnet_name                                   = data.azurerm_subnet.public.name
    private_subnet_name                                  = data.azurerm_subnet.private.name
    private_subnet_network_security_group_association_id = data.azurerm_network_security_group.private_subnet_nsg.id
    public_subnet_network_security_group_association_id  = data.azurerm_network_security_group.public_subnet_nsg.id
  }

  depends_on = [
    data.azurerm_subnet.public,
    data.azurerm_subnet.private,
    data.azurerm_virtual_network.spoke_vnet
  ]
}

resource "databricks_metastore_assignment" "this" {
  provider = databricks.workspace

  metastore_id = var.metastore_id
  workspace_id = azurerm_databricks_workspace.this.workspace_id
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  count = var.boolean_enable_logging ? 1 : 0

  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_databricks_workspace.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "jobs"
  }
  enabled_log {
    category = "clusters"
  }
  enabled_log {
    category = "accounts"
  }
  enabled_log {
    category = "dbfs"
  }
 // enabled_log {
 //   category = "notebooks"
 // }
  enabled_log {
    category = "workspace"
  }
}
