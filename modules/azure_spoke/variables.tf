variable "name" {
  type        = string
  description = "The name that will be used for resources"
}

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

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
  default     = {}
}

variable "hub_resource_group_name" {
  type        = string
  description = "(Required) The name of the hub resource group."
}

variable "metastore_id" {
  type        = string
  description = "(Required) The ID of the Metastore"
}

variable "databricks_account_id" {
  type        = string
  description = "(Required) The ID of the Databricks"
}

variable "azure_subscription_id" {
  type        = string
  description = "The ID of the Azure subscription"
}

variable "boolean_adb_private_link" {
  type        = bool
  description = "Use Azure Databricks PrivateLink"
  default     = true
}

variable "boolean_adfs_privatelink" {
  type        = bool
  description = "Use ADFS PrivateLink"
  default     = true
}

variable "boolean_enable_logging" {
  type        = bool
  description = "Enables logging"
  default     = true
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "The id of the log analytics workspace (required if logging enabled)"
}

variable "databricks_sku" {
  type        = string
  description = "(Optional) The SKU to use for the databricks instance"
  validation {
    condition     = can(regex("standard|premium|trial", var.databricks_sku))
    error_message = "Err: Valid options are ‘standard’, ‘premium’ or ‘trial’."
  }
}

variable "spoke_vnet_name" {
  type        = string
  description = "The name of spoke Vnet"
}

variable "spoke_private_subnet" {
  type        = string
  description = "The name of spoke private subnet"
}

variable "spoke_public_subnet" {
  type        = string
  description = "The name of spoke public subnet"
}

variable "spoke_privatelink_subnet" {
  type = string
}

variable "spoke_public_nsg" {
  description = "The the ID of the NSG associated with the public subnet."
  type        = string
  default     = null
}

variable "spoke_private_nsg" {
  description = "The the ID of the NSG associated with the public subnet."
  type        = string
  default     = null
}

variable "hub_privatelink_subnet" {
  description = "The the ID of the subnet in the hub network."
  type        = string
  default     = null
}

variable "hub_vnet_name" {
  description = "The the ID of the Vnet in the hub network."
  type        = string
  default     = null
}

variable "storage_account_name" {
  description = "The ID of the storage account used for private link e.g. the one the catalog is using."
  type        = string
  default     = null
}