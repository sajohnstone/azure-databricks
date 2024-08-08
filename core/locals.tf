locals {
  name_prefix       = "${var.environment}-${var.project}-${local.naming.location[var.location]}"
  name_prefix_short = "${var.environment}${var.project}${local.naming.location[var.location]}"
  naming = {
    location = {
      "australiaeast" = "aue"
    }
  }

  network = {
    nsg_rules = {
      "${local.name_prefix}-prod-privatelink" = [
        {
          access                     = "Allow"
          description                = ""
          destination_address_prefix = "*"
          destination_port_range     = "3306"
          direction                  = "Inbound"
          name                       = "AllowAnyCustom3306Inbound"
          priority                   = 1021
          protocol                   = "*"
          source_address_prefix      = "*"
          source_port_range          = "*"
        },
        {
          access                     = "Allow"
          description                = ""
          destination_address_prefix = "*"
          destination_port_range     = "443"
          direction                  = "Inbound"
          name                       = "Allow443"
          priority                   = 1001
          protocol                   = "*"
          source_address_prefix      = "*"
          source_port_range          = "*"
        },
        {
          access                     = "Allow"
          description                = ""
          destination_address_prefix = "*"
          destination_port_range     = "6666"
          direction                  = "Inbound"
          name                       = "AllowAnyCustom6666Inbound"
          priority                   = 1011
          protocol                   = "*"
          source_address_prefix      = "*"
          source_port_range          = "*"
        },
        {
          access                     = "Allow"
          description                = ""
          destination_address_prefix = "*"
          destination_port_range     = "8443-8451"
          direction                  = "Inbound"
          name                       = "AllowAnyCustom8443-8451Inbound"
          priority                   = 1031
          protocol                   = "*"
          source_address_prefix      = "*"
          source_port_range          = "*"
        },
      ]
      "${local.name_prefix}-hub-public" = [
        {

          access                     = "Allow"
          description                = ""
          destination_address_prefix = "*"
          destination_port_range     = "3389"
          direction                  = "Inbound"
          name                       = "AllowAnyRDPInbound"
          priority                   = 100
          protocol                   = "Tcp"
          source_address_prefix      = var.your_ip
          source_port_range          = "*"
        }
      ]
    }
    vnets = {
      "hub" = {
        vnet_address_space = ["10.0.4.0/22"]
        subnets = [
          {
            name           = "${local.name_prefix}-hub-host"
            address_prefix = ["10.0.4.0/24"]
          },
          {
            name           = "${local.name_prefix}-hub-container"
            address_prefix = ["10.0.5.0/24"]
          },
          {
            name           = "${local.name_prefix}-hub-privatelink"
            address_prefix = ["10.0.6.0/24"]
          },
          {
            name           = "${local.name_prefix}-hub-public"
            address_prefix = ["10.0.7.0/24"]
          }
        ]
      }
      "onprem" = {
        vnet_address_space = ["10.0.8.0/22"]
        subnets = [
          {
            name           = "${local.name_prefix}-onprem-private"
            address_prefix = ["10.0.8.0/23"]
          },
          {
            name           = "${local.name_prefix}-onprem-public"
            address_prefix = ["10.0.10.0/23"]
          }
        ]
      }
      "prod" = {
        vnet_address_space = ["10.0.0.0/22"]
        subnets = [
          {
            name           = "${local.name_prefix}-prod-host"
            address_prefix = ["10.0.0.0/24"]
          },
          {
            name           = "${local.name_prefix}-prod-container"
            address_prefix = ["10.0.1.0/24"]
          },
          {
            name           = "${local.name_prefix}-prod-application"
            address_prefix = ["10.0.2.0/25"]
          },
          {
            name           = "${local.name_prefix}-prod-privatelink"
            address_prefix = ["10.0.2.128/26"]
          },
          {
            name           = "${local.name_prefix}-prod-management"
            address_prefix = ["10.0.2.192/26"]
          }
          # 10.0.3.0 reserved            
        ]
      }
    }

    service_delegation_name = "Microsoft.Databricks/workspaces"
    delegation_actions = [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
    ]
    peerings = {
      "prod-to-hub" = {
        src-vnet-key = "prod"
      }
      "onprem-to-hub" = {
        src-vnet-key = "onprem"
      }
    }
  }
  // Re-organize subnets to a map
  subnets = { for item in flatten([for key, value in local.network.vnets : [
    for snet in value.subnets : {
      full_key         = "${key}-${snet.name}"
      snet_key         = snet.name
      address_prefixes = snet.address_prefix
      vnet_key         = key
    }]
  ]) : item.full_key => item }
}
