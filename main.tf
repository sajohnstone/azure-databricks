resource "azurerm_resource_group" "this" {
  name     = local.name_prefix
  location = var.location
}
