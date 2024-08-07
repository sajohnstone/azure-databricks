locals {
  name_prefix       = "${var.environment}-${var.project}-${local.naming.location[var.location]}"
  name_prefix_short = "${var.environment}${var.project}${local.naming.location[var.location]}"
  naming = {
    location = {
      "australiaeast" = "aue"
    }
  }

  network = {
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
