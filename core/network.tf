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
    for_each = try(regex("public|private", each.value.snet_key), null) != null ? [1] : []

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

# an empty NSG to associate to the workspace public/private subnets
resource "azurerm_network_security_group" "empty" {
  name                = "nsg-abw-empty"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "AllowAnyRDPInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.your_ip
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "abw-subnets" {
  for_each = { for key, value in local.subnets : key => value if try(regex("public|private", value.snet_key), null) != null }

  subnet_id                 = azurerm_subnet.this[each.value.full_key].id
  network_security_group_id = azurerm_network_security_group.empty.id
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

  allow_forwarded_src_traffic  = false
  allow_forwarded_dest_traffic = false

  allow_virtual_src_network_access  = false
  allow_virtual_dest_network_access = false
}
