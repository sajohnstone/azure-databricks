resource "azurerm_private_endpoint" "frontend" {
  count = var.boolean_adb_private_link == true ? 1 : 0

  name                = "${var.name}-frontend"
  location            = var.location
  resource_group_name = var.hub_resource_group_name
  subnet_id           = data.azurerm_subnet.hub_privatelink_subnet.id

  private_service_connection {
    name                           = "ple-${var.name}-front"
    private_connection_resource_id = azurerm_databricks_workspace.this.id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-front"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.auth_front.id]
  }
}
