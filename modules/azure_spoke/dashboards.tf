# Create the /Shared/dashboards directory
resource "databricks_directory" "dashboards" {
  path       = "/Shared/dashboards"
}

resource "databricks_dashboard" "users" {
  display_name      = "databricks-usage-dashboard"
  warehouse_id      = databricks_sql_endpoint.serverless.id
  file_path         = "${path.module}/dashboards/users.lvdash.json"
  embed_credentials = false // Optional
  parent_path       = "/Shared/dashboards"

  depends_on = [databricks_sql_endpoint.serverless, databricks_directory.dashboards]
}

resource "databricks_dashboard" "jobs" {
  display_name      = "databricks-jobs-dashboard"
  warehouse_id      = databricks_sql_endpoint.serverless.id
  file_path         = "${path.module}/dashboards/jobs.lvdash.json"
  embed_credentials = false // Optional
  parent_path       = "/Shared/dashboards"

  depends_on = [databricks_sql_endpoint.serverless, databricks_directory.dashboards]
}

resource "databricks_dashboard" "serverless" {
  display_name      = "databricks-serverless-dashboard"
  warehouse_id      = databricks_sql_endpoint.serverless.id
  file_path         = "${path.module}/dashboards/serverless.lvdash.json"
  embed_credentials = false // Optional
  parent_path       = "/Shared/dashboards"

  depends_on = [databricks_sql_endpoint.serverless, databricks_directory.dashboards]
}
