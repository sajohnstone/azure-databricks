resource "azurerm_databricks_workspace" "this" {
  name                          = local.name_prefix
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  sku                           = var.databricks_sku

  public_network_access_enabled         = !local.configuration.use_private_link
  network_security_group_rules_required = local.configuration.use_private_link ? "NoAzureDatabricksRules" : "AllRules"

  custom_parameters {
    no_public_ip                                         = local.configuration.use_private_link
    virtual_network_id                                   = azurerm_virtual_network.this.id
    public_subnet_name                                   = azurerm_subnet.subnet["${local.name_prefix}-public"].name
    private_subnet_name                                  = azurerm_subnet.subnet["${local.name_prefix}-private"].name
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.association["${local.name_prefix}-private"].id
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.association["${local.name_prefix}-public"].id
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.association,
  ]
}

resource "databricks_metastore_assignment" "this" {
  provider = databricks.workspace

  metastore_id         = var.metastore_id
  workspace_id         = azurerm_databricks_workspace.this.workspace_id
  default_catalog_name = "hive_metastore"
}
