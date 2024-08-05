terraform {
  required_providers {
    databricks = {
      configuration_aliases = [ databricks.workspace, databricks.account ]
      source                = "databricks/databricks"
      version               = "~> 1.4"
    }
    azurerm = {

      source  = "hashicorp/azurerm"
      version = "~> 3.1"
    }
  }
}
