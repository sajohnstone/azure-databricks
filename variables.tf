variable "metastore_id" {
  type        = string
  description = "The ID of the Metastore"
}

variable "databricks_account_id" {
  type        = string
  description = "The ID of the Databricks account"
}

variable "azure_subscription_id" {
  type        = string
  description = "The ID of the Azure subscription"
}

variable "client_secret" {
  description = "SP Secret"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant"
  type        = string
}

variable "client_id" {
  description = "Azure Client"
  type        = string
}
