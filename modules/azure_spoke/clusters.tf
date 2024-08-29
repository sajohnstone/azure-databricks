resource "databricks_sql_endpoint" "sql_warehouse" {
  for_each         = var.sql_warehouse_sizes
  name             = "sql-warehouse-${each.key}"
  cluster_size     = each.value.cluster_size
  max_num_clusters = each.value.max_num_clusters

  # Optional settings, customize as needed
  min_num_clusters          = 1
  spot_instance_policy      = "COST_OPTIMIZED"
  enable_photon             = each.value.enable_photon
  enable_serverless_compute = each.value.enable_serverless_compute
  auto_stop_mins            = 10
  tags {
    dynamic "custom_tags" {
      for_each = merge(var.tags)
      content {
        key   = custom_tags.key
        value = custom_tags.value
      }
    }
  }
}

resource "databricks_cluster" "cluster" {
  for_each = var.cluster_sizes

  cluster_name  = "${each.key}-cluster"
  spark_version = data.databricks_spark_version.latest_lts.id
  node_type_id  = each.value.node_type_id
  policy_id     = databricks_cluster_policy.default.id
  num_workers   = 1
  autoscale {
    min_workers = 1
    max_workers = each.value.max_num_clusters
  }
  autotermination_minutes = 20

  spark_conf = {
    "spark.databricks.repl.allowedLanguages" = "python,sql",
    "spark.databricks.cluster.profile"       = each.value.profile
  }

  custom_tags = var.tags

  workload_type {
    clients {
      jobs      = each.value.jobs
      notebooks = each.value.notebooks
    }
  }
}
