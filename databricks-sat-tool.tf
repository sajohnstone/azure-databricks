module "sat-tool" {
  source = "./modules/sat-tool"
  providers = {
    databricks.workspace = databricks.workspace
    databricks.account   = databricks.account
  }

  workspace_id   = module.spoke.workspace_id
  databricks_url = module.spoke.workspace_url
  sqlw_id        = module.spoke.small_sql_warehouse_id
  job_cluster_id = module.spoke.small_job_cluster_id

  account_console_id = local.workspace.databricks.databricks_account_id
  client_id          = local.workspace.databricks.client_id
  tenant_id          = local.workspace.databricks.tenant_id
  subscription_id    = local.workspace.databricks.azure_subscription_id
  client_secret      = local.workspace.databricks.client_secret
  #secret_id = "768e42fb-4b86-459b-9178-855d9a2cd156"

  depends_on = [
    module.spoke
  ]
}
