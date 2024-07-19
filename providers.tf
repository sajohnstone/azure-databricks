provider "azurerm" {
  features {}
}

provider "azuread" {
}

provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.this.id
}