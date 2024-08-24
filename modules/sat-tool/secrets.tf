resource "databricks_secret_scope" "sat" {
  name = var.secret_scope_name
}

resource "databricks_secret" "client_secret" {
  key          = "client-secret"
  string_value = var.client_secret
  scope        = databricks_secret_scope.sat.id
}

resource "databricks_secret" "subscription_id" {
  key          = "subscription-id"
  string_value = var.subscription_id
  scope        = databricks_secret_scope.sat.id
}

resource "databricks_secret" "tenant_id" {
  key          = "tenant-id"
  string_value = var.tenant_id
  scope        = databricks_secret_scope.sat.id
}

resource "databricks_secret" "client_id" {
  key          = "client-id"
  string_value = var.client_id
  scope        = databricks_secret_scope.sat.id
}

resource "databricks_secret" "user_email" {
  key          = "user-email-for-alerts"
  string_value = var.notification_email == "" ? data.databricks_current_user.me.user_name : var.notification_email
  scope        = databricks_secret_scope.sat.id
}

resource "databricks_token" "pat" {
  lifetime_seconds = 86400 * 90
  comment          = "Security Analysis Tool"
}

resource "databricks_secret" "pat" {
  key          = "sat-token-${var.workspace_id}"
  string_value = databricks_token.pat.token_value
  scope        = databricks_secret_scope.sat.id
}

resource "databricks_secret" "account_console_id" {
  key          = "account-console-id"
  string_value = var.account_console_id
  scope        = databricks_secret_scope.sat.id
}

resource "databricks_secret" "sql_warehouse_id" {
  key          = "sql-warehouse-id"
  string_value = var.sqlw_id
  scope        = databricks_secret_scope.sat.id
}

