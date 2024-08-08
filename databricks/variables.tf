variable "location" {
  type        = string
  description = "(Optional) The location for resource deployment"
  default     = "australiaeast"
}

variable "environment" {
  type        = string
  description = "(Required) Three character environment name"
  validation {
    condition     = length(var.environment) <= 3
    error_message = "Err: Environment cannot be longer than three characters."
  }
}

variable "project" {
  type        = string
  description = "(Required) The project name"
}

variable "metastore_id" {
  type        = string
  description = "(Required) The ID of the Metastore"
}

variable "databricks_account_id" {
  type        = string
  description = "(Required) The ID of the Databricks"
}

variable "databricks_sku" {
  type        = string
  description = "(Optional) The SKU to use for the databricks instance"
  validation {
    condition     = can(regex("standard|premium|trial", var.databricks_sku))
    error_message = "Err: Valid options are ‘standard’, ‘premium’ or ‘trial’."
  }
}

variable "azure_subscription_id" {
  type        = string
  description = "The ID of the Azure subscription"
}

variable "databricks_vnet_name" {
  type        = string
}

variable "databricks_vnet_rg_name" {
  type        = string
}

variable "databricks_private_subnet" {
  type        = string
}

variable "databricks_public_subnet" {
  type        = string
}

variable "databricks_privatelink_subnet" {
  type        = string
}

variable "public_subnet_nsg_id" {
  description = "The the ID of the NSG associated with the public subnet."
  type        = string
  default     = null
}

variable "private_subnet_nsg_id" {
  description = "The the ID of the NSG associated with the public subnet."
  type        = string
  default     = null
}

variable "hub_privatelink_subnet" {
  description = "The the ID of the subnet in the hub network."
  type        = string
  default     = null
}
