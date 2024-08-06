resource "azurerm_private_endpoint" "frontend" {
  count    = var.use_frontend_privatelink == true ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_link_subnet_name

  private_service_connection {
    name                           = "databricks-connection"
    private_connection_resource_id = var.workspace_id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api", "browser_authentication"]
  }
}

resource "azurerm_private_dns_a_record" "databricks_ui_api" {
  name                = "adb-${azurerm_databricks_workspace.this.workspace_id}.${var.location}.${azurerm_private_dns_zone.databricks-frontend[0].name}"
  zone_name           = azurerm_private_dns_zone.databricks-frontend[0].name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.frontend[0].private_service_connection[0].private_ip_address]
}

resource "azurerm_private_dns_a_record" "browser_authentication" {
  name                = "adb-${azurerm_databricks_workspace.this.workspace_id}.2.${var.location}.${azurerm_private_dns_zone.databricks-frontend[0].name}"
  zone_name           = azurerm_private_dns_zone.databricks-frontend.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.frontend[0].private_service_connection[0].private_ip_address]
}

