provider "azurerm" {
  subscription_id = var.azure_subscription_id
  features {}
}

# Define the Databricks Workspace provider
provider "databricks" {
  alias                       = "workspace"
  azure_workspace_resource_id = azurerm_databricks_workspace.this.id
}

# Define the Databricks Account provider
provider "databricks" {
  alias      = "account"
  host       = "https://accounts.azuredatabricks.net"
  account_id = var.databricks_account_id
}
