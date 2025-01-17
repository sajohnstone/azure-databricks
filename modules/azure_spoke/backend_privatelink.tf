# Define a private endpoint resource for the backend
resource "azurerm_private_endpoint" "backend" {
  count = var.boolean_adb_private_link == true ? 1 : 0

  name                = "${var.name}-backend"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = data.azurerm_subnet.privatelink.id

  # Configure the private service connection
  private_service_connection {
    name                           = "ple-${var.name}-backend"
    private_connection_resource_id = azurerm_databricks_workspace.this.id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }

  # Configure the private DNS zone group
  private_dns_zone_group {
    name                 = "private-dns-zone-backend"
    private_dns_zone_ids = [azurerm_private_dns_zone.backend.id]
  }

  tags = var.tags
}

resource "azurerm_private_dns_zone" "backend" {
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Define a virtual network link for the private DNS zone and the backend virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "backend" {
  count = var.boolean_adb_private_link == true ? 1 : 0

  name                  = "databricks-vnetlink-backend"
  resource_group_name   = var.hub_resource_group_name
  private_dns_zone_name = "privatelink.azuredatabricks.net"
  virtual_network_id    = data.azurerm_virtual_network.spoke_vnet.id

  tags = var.tags
}
