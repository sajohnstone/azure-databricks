# Front-end ui and browser_auth
resource "azurerm_private_dns_zone" "databricks-frontend" {
  count    = var.use_frontend_privatelink == true ? 1 : 0

  name                = "privatelink.azuredatabricks.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "databricks-frontend" {
  count    = var.use_frontend_privatelink == true ? 1 : 0

  name                  = "link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.databricks-frontend[0].name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false

  depends_on = [ azurerm_private_endpoint.frontend[0] ]
}

/*
# Backend
resource "azurerm_private_dns_zone" "databricks-backend" {
  count    = var.use_backend_privatelink == true ? 1 : 0

  name                = "privatelink.azuredatabricks.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "databricks-backend" {
  count    = var.use_backend_privatelink == true ? 1 : 0

  name                  = "link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.databricks-backend[0].name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false
}
*/