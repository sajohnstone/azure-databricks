variable "location" {
  type        = string
  description = "(Optional) The location for resource deployment"
  default     = "australiaeast"
}

variable "resource_group_name" {
  type        = string
  description = "(Optional) The name of the resource group."
  default     = "australiaeast"
}

variable "name" {
  type        = string
  description = "The name that will be used for resources"
}

variable "azure_subscription_id" {
  type        = string
  description = "The ID of the Azure subscription"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
  default     = {}
}

variable "boolean_create_bastion" {
  type        = bool
  description = "Creates bastion in hub. Required if using PrivateLink."
  default     = false
}

variable "boolean_create_log_analytics" {
  type        = bool
  description = "Creates log analytics"
  default     = true
}

variable "vnets" {
  type = map(object({
    vnet_address_space = list(string)
    subnets = list(object({
      name           = string
      address_prefix = list(string)
    }))
  }))
  description = "The vnet structure"
}

variable "peerings" {
  type = map(object({
    src-vnet-key = string
  }))
}

variable "nsg_rules" {
  type = map(list(object({
    access                     = string
    description                = string
    destination_address_prefix = string
    destination_port_range     = string
    direction                  = string
    name                       = string
    priority                   = number
    protocol                   = string
    source_address_prefix      = string
    source_port_range          = string
  })))
}
