resource "azurerm_private_endpoint" "backend" {
  count = var.use_frontend_privatelink == true ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.privatelink.id

  # Configure the private service connection
  private_service_connection {
    name                           = "${var.name}-backend"
    private_connection_resource_id = var.workspace_id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  # Configure the private DNS zone group
  private_dns_zone_group {
    name                 = "private-dns-zone-backend"
    private_dns_zone_ids = [azurerm_private_dns_zone.this.id]
  }
}