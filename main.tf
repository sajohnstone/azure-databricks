locals {
  naming = {
    location = {
      "australiaeast" = "aue"
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "this" {
  name = format("rg-%s-%s-%s",
  local.naming.location[var.location], var.environment, var.project)
  location = var.location
}

resource "azurerm_key_vault" "this" {
  name = format("kv-%s-%s-%s",
  local.naming.location[var.location], var.environment, var.project)
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    secret_permissions = [
      "Get",
      "Set",
      "Delete",
      "Recover",
      "Purge"
    ]
  }
}

resource "azurerm_databricks_workspace" "this" {
  name = format("dbs-%s-%s-%s",
  local.naming.location[var.location], var.environment, var.project)
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = var.databricks_sku
  custom_parameters {
    virtual_network_id  = azurerm_virtual_network.this.id
    public_subnet_name  = azurerm_subnet.public.name
    private_subnet_name = azurerm_subnet.private.name
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
    public_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.public.id
  }
  
  depends_on = [
    azurerm_subnet_network_security_group_association.public,
    azurerm_subnet_network_security_group_association.private,
  ]
}
