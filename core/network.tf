resource "azurerm_virtual_network" "this" {
  for_each            = local.network.vnets
  address_space       = each.value.vnet_address_space
  name                = "${local.name_prefix}-${each.key}-vnet"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  for_each = local.subnets

  name                 = "snet-${each.value.snet_key}"
  address_prefixes     = each.value.address_prefixes
  virtual_network_name = azurerm_virtual_network.this[each.value.vnet_key].name

  resource_group_name = azurerm_resource_group.this.name

  // add delegation for the public/private subnets
  dynamic "delegation" {
    for_each = try(regex("host|container", each.value.snet_key), null) != null ? [1] : []

    content {
      name = "delegation-to-databricks"
      service_delegation {
        name = "Microsoft.Databricks/workspaces"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
        ]
      }
    }
  }
}

resource "azurerm_network_security_group" "this" {
  for_each = local.subnets

  name                = each.value.snet_key
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  dynamic "security_rule" {
    for_each = lookup(local.network.nsg_rules, each.value.snet_key, [])

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "abw-subnets" {
  for_each = local.subnets

  subnet_id                 = azurerm_subnet.this[each.value.full_key].id
  network_security_group_id = azurerm_network_security_group.this[each.value.full_key].id
}

module "vnet_peering" {
  source   = "claranet/vnet-peering/azurerm"
  version  = "5.1.0"
  for_each = local.network.peerings

  providers = {
    azurerm.src = azurerm
    azurerm.dst = azurerm
  }

  vnet_src_id  = azurerm_virtual_network.this[each.value.src-vnet-key].id
  vnet_dest_id = azurerm_virtual_network.this["hub"].id

  allow_forwarded_src_traffic  = true
  allow_forwarded_dest_traffic = true

  allow_virtual_src_network_access  = true
  allow_virtual_dest_network_access = true
}
