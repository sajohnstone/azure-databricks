resource "azurerm_private_endpoint" "browser-auth" {
  count    = var.use_frontend_privatelink == true ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_link_subnet_name

  private_service_connection {
    name                           = "default"
    private_connection_resource_id = var.workspace_id
    is_manual_connection           = false
    subresource_names              = ["browser_authentication"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.databricks-frontend[0].id]
  }
}
