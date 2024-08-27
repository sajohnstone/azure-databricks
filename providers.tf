provider "azurerm" {
  subscription_id = var.azure_subscription_id
  features {}
}

# Define the Databricks Workspace provider
provider "databricks" {
  alias                       = "workspace"
  azure_workspace_resource_id = module.spoke.id
}

# Define the Databricks Account provider
provider "databricks" {
  alias      = "account"
  host       = "https://accounts.azuredatabricks.net"
  account_id = var.databricks_account_id
  azure_client_id     = local.workspace.databricks.client_id
  azure_tenant_id     = local.workspace.databricks.tenant_id
  azure_client_secret = local.workspace.databricks.client_secret
}
