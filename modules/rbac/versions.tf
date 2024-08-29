
terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.1"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.4"
      configuration_aliases = [
        databricks.account,
        databricks.workspace,
      ]
    }
  }
}


