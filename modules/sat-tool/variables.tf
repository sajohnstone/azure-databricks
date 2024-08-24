variable "workspace_id" {
  type        = number
  description = "Should be the string of numbers in the workspace URL arg (e.g. https://<workspace>.azuredatabricks.net/?o=1234567890123456)"
}

variable "sqlw_id" {
  type        = string
  description = "16 character SQL Warehouse ID: Type new to have one created or enter an existing SQL Warehouse ID"
}

variable "job_cluster_id" {
  type        = string
  description = "16 character SQL Warehouse ID: Type new to have one created or enter an existing SQL Warehouse ID"
}

variable "secret_scope_name" {
  description = "Name of secret scope for SAT secrets"
  type        = string
  default     = "sat_scope"
}

variable "notification_email" {
  type        = string
  description = "Optional user email for notifications. If not specified, current user's email will be used"
  default     = ""
}

variable "databricks_url" {
  description = "Should look like https://<workspace>.azuredatabricks.net"
  type        = string
}

variable "account_console_id" {
  description = "Databricks Account Console ID"
  type        = string
}

variable "client_id" {
  description = "Service Principal Application (client) ID"
  type        = string
}

variable "tenant_id" {
  description = "The Directory (tenant) ID for the application registered in Azure AD"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscriptionId"
  type        = string
}

variable "client_secret" {
  description = "SP Secret"
  type        = string
}
