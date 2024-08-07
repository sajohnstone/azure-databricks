resource "azurerm_private_endpoint" "frontend" {
  name                = "${var.name}-frontend"
  location            = var.location
  resource_group_name = var.databricks_vnet_rg_name
  subnet_id           = var.hub_private_link_info.subnet_id

  private_service_connection {
    name                           = "ple-${var.name}-front"
    private_connection_resource_id = azurerm_databricks_workspace.this.id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-front"
    private_dns_zone_ids = [var.hub_private_link_info.dns_zone_id]
  }
}
