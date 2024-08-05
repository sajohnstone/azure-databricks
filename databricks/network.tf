resource "azurerm_virtual_network" "this" {
  name                = local.name_prefix
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [local.network.vnet_address_space]
}

resource "azurerm_network_security_group" "nsg" {
  for_each = {
    for subnet in local.network.subnets : subnet.name => subnet
  }

  name                = each.value.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_subnet" "subnet" {
  for_each = {
    for subnet in local.network.subnets : subnet.name => subnet
  }

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]

  delegation {
    name = "databricks-delegation"

    service_delegation {
      name    = local.network.service_delegation_name
      actions = local.network.delegation_actions
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "association" {
  for_each = {
    for subnet in local.network.subnets : subnet.name => subnet
  }

  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}