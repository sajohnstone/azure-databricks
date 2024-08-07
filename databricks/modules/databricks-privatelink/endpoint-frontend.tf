resource "azurerm_private_endpoint" "frontend" {
  count = var.use_frontend_privatelink == true ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.privatelink.id

  private_service_connection {
    name                           = "${var.name}-frontend"
    private_connection_resource_id = data.azurerm_databricks_workspace.this.id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-front"
    private_dns_zone_ids = [azurerm_private_dns_zone.this.id]
  }
}

/*
resource "azurerm_private_dns_a_record" "databricks_ui_api" {
  count = var.use_frontend_privatelink == true ? 1 : 0

  name                = lower(var.name)
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.frontend[0].private_service_connection[0].private_ip_address]

  depends_on = [azurerm_private_endpoint.frontend[0], azurerm_private_dns_zone.this]
}

resource "azurerm_private_dns_a_record" "browser_authentication" {
  count = var.use_frontend_privatelink == true ? 1 : 0

  name                = lower("adb-${var.workspace_id}.2.${var.location}.${azurerm_private_dns_zone.this.name}")
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.frontend[0].private_service_connection[0].private_ip_address]

  depends_on = [azurerm_private_endpoint.frontend[0], azurerm_private_dns_zone.this]
}
*/