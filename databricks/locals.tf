locals {
  name_prefix       = "${var.environment}-${var.project}-${local.naming.location[var.location]}"
  name_prefix_short = "${var.environment}${var.project}${local.naming.location[var.location]}"
  naming = {
    location = {
      "australiaeast" = "aue"
    }
  }
  tags = {
    project     = var.project
    environment = var.environment
  }

  configuration = {
    use_private_link = false
  }

  network = {
    vnet_address_space = "10.0.0.0/22"
    subnets = [
      {
        name           = "${local.name_prefix}-private"
        address_prefix = "10.0.0.0/24"
      },
      {
        name           = "${local.name_prefix}-public"
        address_prefix = "10.0.1.0/24"
      },
      {
        name           = "${local.name_prefix}-application"
        address_prefix = "10.0.2.0/25"
      },
      {
        name           = "${local.name_prefix}-privatelink"
        address_prefix = "10.0.2.128/26"
      },
      {
        name           = "${local.name_prefix}-management"
        address_prefix = "10.0.2.192/26"
      }     
      # 10.0.3.0/24 reserved            
    ]
    service_delegation_name = "Microsoft.Databricks/workspaces"
    delegation_actions = [
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
    ]
  }
}
