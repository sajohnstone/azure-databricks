# Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "this" {
  count = var.boolean_create_log_analytics ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
}
