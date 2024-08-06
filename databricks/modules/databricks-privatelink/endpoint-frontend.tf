resource "azurerm_private_endpoint" "frontend" {
  count = var.use_frontend_privatelink == true ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_link_subnet_name

  private_service_connection {
    name                           = "${var.name}-frontend"
    private_connection_resource_id = var.workspace_id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-front"
    private_dns_zone_ids = [azurerm_private_dns_zone.this.id]
  }
}

resource "azurerm_private_dns_a_record" "databricks_ui_api" {
  count = var.use_frontend_privatelink == true ? 1 : 0

  name                = "adb-${var.workspace_id}.${var.location}.${azurerm_private_dns_zone.databricks-frontend[0].name}"
  zone_name           = azurerm_private_dns_zone.this[0].name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.frontend[0].private_service_connection[0].private_ip_address]

  depends_on = [azurerm_private_endpoint.frontend[0], azurerm_private_dns_zone.this]
}

resource "azurerm_private_dns_a_record" "browser_authentication" {
  count = var.use_frontend_privatelink == true ? 1 : 0

  name                = "adb-${var.workspace_id}.2.${var.location}.${azurerm_private_dns_zone.databricks-frontend[0].name}"
  zone_name           = azurerm_private_dns_zone.this[0].name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.frontend[0].private_service_connection[0].private_ip_address]

  depends_on = [azurerm_private_endpoint.frontend[0], azurerm_private_dns_zone.this]
}
