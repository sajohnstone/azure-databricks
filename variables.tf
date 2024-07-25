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
