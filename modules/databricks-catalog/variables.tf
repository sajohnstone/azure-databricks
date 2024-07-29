variable "name" {
  type        = string
  description = "The name of the Databricks catalog to be created."
}

variable "metastore_id" {
  type        = string
  description = "The unique identifier of the Metastore to which the catalog belongs."
  default     = null
}

variable "comment" {
  type        = string
  description = "A comment or description for the Databricks catalog."
  default     = "This catalog is managed by Terraform."
}

variable "owner" {
  type        = string
  description = "The owner of the Databricks catalog."
  default     = null
}

variable "use_storage_account" {
  type        = bool
  description = "Indicates whether to create a dedicated Storage Account (recommended) instead of using the Metastore's storage."
  default     = true
}

variable "storage_account_name" {
  type        = string
  description = "The name of the Azure Storage Account to be used for the catalog."
  default     = null
}

variable "container_name" {
  type        = string
  description = "The name of the container within the Azure Storage Account."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
  default     = {}
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

variable "account_replication_type" {
  type        = string
  description = "The replication type for the Azure Storage Account. Possible values are 'LRS' (Locally-redundant storage), 'GRS' (Geo-redundant storage), etc."
  default     = "LRS"
}
