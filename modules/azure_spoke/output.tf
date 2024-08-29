output "id" {
  value = azurerm_databricks_workspace.this.id
}

output "workspace_id" {
  value = azurerm_databricks_workspace.this.workspace_id
}

output "workspace_url" {
  value = azurerm_databricks_workspace.this.workspace_url
}

output "default_warehouse_id" {
  value = databricks_sql_endpoint.sql_warehouse["default"].id
}

output "default_cluster_id" {
  value = databricks_cluster.cluster["default"].id
}

output "serverless_warehouse_id" {
  value = databricks_sql_endpoint.sql_warehouse["serverless"].id
}

output "serverless_cluster_id" {
  value = databricks_cluster.cluster["serverless"].id
}
