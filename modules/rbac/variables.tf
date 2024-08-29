variable "databricks_permissions" {
  type = map(object({
    cluster = object({
      can_manage  = list(string)
      can_restart = list(string)
    })
    sql_endpoint = object({
      can_use    = list(string)
      can_manage = list(string)
    })
    job = object({
      can_manage = list(string)
      can_view   = list(string)
      can_run    = list(string)
    })
    cluster_policy = object({
      can_use = list(string)
    })
  }))
  default = {
    "analysts" = {
      cluster = {
        can_manage  = ["default-cluster"]
        can_restart = ["default-cluster", "serverless-cluster"]
      }
      sql_endpoint = {
        can_use    = ["sql-warehouse-default", "sql-warehouse-serverless"]
        can_manage = ["sql-warehouse-default"]
      }
      job = {
        can_manage = ["catalog-migration-to-temp"]
        can_view   = ["catalog-migration-to-temp"]
        can_run    = ["catalog-migration-to-temp"]
      }
      cluster_policy = {
        can_use = ["Default cluster policy"]
      }
    }
    "ml_scientists" = {
      cluster = {
        can_manage  = ["default-cluster"]
        can_restart = ["default-cluster", "serverless-cluster"]
      }
      sql_endpoint = {
        can_use    = ["sql-warehouse-default", "sql-warehouse-serverless"]
        can_manage = ["sql-warehouse-default"]
      }
      job = {
        can_manage = ["catalog-migration-to-temp"]
        can_view   = ["catalog-migration-to-temp"]
        can_run    = ["catalog-migration-to-temp"]
      }
      cluster_policy = {
        can_use = ["Default cluster policy"]
      }
    }
  }
}
