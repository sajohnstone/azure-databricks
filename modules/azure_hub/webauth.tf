# This resource block defines a databricks workspace for webauth
resource "azurerm_databricks_workspace" "webauth" {
  name                                  = join("_", ["WEB_AUTH_DO_NOT_DELETE", upper(var.name)])
  location                              = var.location
  resource_group_name                   = var.resource_group_name
  sku                                   = "premium"
  public_network_access_enabled         = false
  network_security_group_rules_required = "NoAzureDatabricksRules"

  # This custom_parameters block specifies additional parameters for the databricks workspace
  custom_parameters {
    no_public_ip                                         = true
    virtual_network_id                                   = azurerm_virtual_network.this["hub"].id
    private_subnet_name                                  = azurerm_subnet.this["hub-${var.name}-hub-container"].name
    public_subnet_name                                   = azurerm_subnet.this["hub-${var.name}-hub-host"].name
    private_subnet_network_security_group_association_id = azurerm_network_security_group.this["hub-${var.name}-hub-container"].id
    public_subnet_network_security_group_association_id  = azurerm_network_security_group.this["hub-${var.name}-hub-host"].id
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

# This resource block defines a private DNS zone Databricks
resource "azurerm_private_dns_zone" "auth_front" {
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = var.resource_group_name
}

# This resource block defines a private endpoint for webauth
resource "azurerm_private_endpoint" "webauth" {
  name                = "webauth-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.this["hub-${var.name}-hub-privatelink"].id

  depends_on = [azurerm_subnet.this] # for proper destruction order

  # This private_service_connection block specifies the connection details for the private endpoint
  private_service_connection {
    name                           = "pl-webauth"
    private_connection_resource_id = azurerm_databricks_workspace.webauth.id
    is_manual_connection           = false
    subresource_names              = ["browser_authentication"]
  }

  # This private_dns_zone_group block specifies the private DNS zone to associate with the private endpoint
  private_dns_zone_group {
    name                 = "private-dns-zone-webauth"
    private_dns_zone_ids = [azurerm_private_dns_zone.auth_front.id]
  }
}


resource "azurerm_private_dns_zone_virtual_network_link" "webauth" {
  name                  = "databricks-vnetlink-backend-hub"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = "privatelink.azuredatabricks.net"
  virtual_network_id    = azurerm_virtual_network.this["hub"].id

  tags = var.tags
}
