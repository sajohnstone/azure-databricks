locals {
  # Decode the JSON response from the ifconfig.co API to get the public IP address of the host machine
  ifconfig_co_json = jsondecode(data.http.my_public_ip.response_body)

  workspace  = local.env[terraform.workspace]
  name       = "adb-stu-${terraform.workspace}"
  short_name = "adbstu${terraform.workspace}"
  location   = "australiaeast"

  env = {
    dev = {
      tags = {
        owner       = "stu.johnstone@mantelgroup.com.au"
        environment = "test"
      }
      databricks = {
        sku                   = "premium"
        databricks_account_id = var.databricks_account_id
        client_id             = var.client_id
        tenant_id             = var.tenant_id
        azure_subscription_id = var.azure_subscription_id
        client_secret         = var.client_secret
      }
      network = {
        vnets = {
          "hub" = {
            vnet_address_space = ["10.0.4.0/22"]
            subnets = [
              {
                name           = "${local.name}-hub-host"
                address_prefix = ["10.0.4.0/24"]
              },
              {
                name           = "${local.name}-hub-container"
                address_prefix = ["10.0.5.0/24"]
              },
              {
                name           = "${local.name}-hub-privatelink"
                address_prefix = ["10.0.6.0/24"]
              },
              {
                name           = "${local.name}-hub-public"
                address_prefix = ["10.0.7.0/24"]
              }
            ]
          }
          "onprem" = {
            vnet_address_space = ["10.0.8.0/22"]
            subnets = [
              {
                name           = "${local.name}-onprem-private"
                address_prefix = ["10.0.8.0/23"]
              },
              {
                name           = "${local.name}-onprem-public"
                address_prefix = ["10.0.10.0/23"]
              }
            ]
          }
          "nonprod" = {
            vnet_address_space = ["10.0.0.0/22"]
            subnets = [
              {
                name           = "${local.name}-nonprod-host"
                address_prefix = ["10.0.0.0/24"]
              },
              {
                name           = "${local.name}-nonprod-container"
                address_prefix = ["10.0.1.0/24"]
              },
              {
                name           = "${local.name}-nonprod-application"
                address_prefix = ["10.0.2.0/25"]
              },
              {
                name           = "${local.name}-nonprod-privatelink"
                address_prefix = ["10.0.2.128/26"]
              },
              {
                name           = "${local.name}-nonprod-management"
                address_prefix = ["10.0.2.192/26"]
              }
              # 10.0.3.0 reserved            
            ]
          }
        }
        peerings = {
          "nonprod-to-hub" = {
            src-vnet-key = "nonprod"
          }
          "onprem-to-hub" = {
            src-vnet-key = "onprem"
          }
        }
        nsg_rules = {
          "${local.name}-prod-privatelink" = [
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
          "${local.name}-hub-public" = [
            {

              access                     = "Allow"
              description                = ""
              destination_address_prefix = "*"
              destination_port_range     = "3389"
              direction                  = "Inbound"
              name                       = "AllowAnyRDPInbound"
              priority                   = 100
              protocol                   = "Tcp"
              source_address_prefix      = local.ifconfig_co_json.ip
              source_port_range          = "*"
            }
          ]
        }
      }
    }
    prod = {
    }
  }
}
