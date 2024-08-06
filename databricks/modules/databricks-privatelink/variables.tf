variable "name" {
  type        = string
  description = "The name of the Databricks catalog to be created."
}

variable "location" {
  type        = string
  description = "The Azure region where the resources will be created."
  default     = null
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group in which the resources will be created."
  default     = null
}

variable "databricks_privatelink_subnet" {
  type        = string
  description = "The name of the subnet where privatelinks should reside."
}

variable "databricks_vnet_name" {
  type        = string
  description = "The VNet id used for PrivateLink."
}

variable "workspace_id" {
  type        = string
  description = "The id of the workspace."
}

variable "use_frontend_privatelink" {
  type        = bool
  description = "Turns on frontend private link."
  default     = true
}

variable "use_backend_privatelink" {
  type        = bool
  description = "Turns on backend private link."
  default     = true
}

variable "databricks_vnet_rg_name" {
  type        = string
  description = "The name of the resource group where the vnet sits."
}
