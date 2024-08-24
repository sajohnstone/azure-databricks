output "id" {
  value = azurerm_databricks_workspace.this.id
}

output "workspace_id" {
  value = azurerm_databricks_workspace.this.workspace_id
}

output "workspace_url" {
  value = azurerm_databricks_workspace.this.workspace_url
}

output "small_sql_warehouse_id" {
  value = databricks_sql_endpoint.sql_warehouse["small"].id
}

output "small_job_cluster_id" {
  value = databricks_cluster.job_cluster["small"].id
}
