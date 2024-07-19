
terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.5"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.4"
    }

  }
}
