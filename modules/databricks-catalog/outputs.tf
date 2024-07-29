output "catalog_name" {
  description = "The ID of the resource group"
  value       = databricks_catalog.this.name
}