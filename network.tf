resource "azurerm_virtual_network" "this" {
  name = format("vn-%s-%s-%s",
  local.naming.location[var.location], var.environment, var.project)

  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "private" {
  name = format("sn-%s-%s-%s-priv",
  local.naming.location[var.location], var.environment, var.project)

  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.0.0/24"]

  delegation {
    name = "databricks-delegation"

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

resource "azurerm_network_security_group" "private" {
  name = format("nsg-%s-%s-%s-priv",
  local.naming.location[var.location], var.environment, var.project)

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.private.id
}

resource "azurerm_subnet" "public" {
  name = format("sn-%s-%s-%s-pub",
  local.naming.location[var.location], var.environment, var.project)

  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "databricks-delegation"

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

resource "azurerm_network_security_group" "public" {
  name = format("nsg-%s-%s-%s-pub",
  local.naming.location[var.location], var.environment, var.project)

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.public.id
}