# Create SQL Warehouses for each t-shirt size
resource "databricks_sql_endpoint" "sql_warehouse" {
  for_each         = var.warehouse_sizes
  name             = "sql-warehouse-${each.key}"
  cluster_size     = each.value.cluster_size
  max_num_clusters = each.value.max_num_clusters

  # Optional settings, customize as needed
  min_num_clusters          = 1
  spot_instance_policy      = "COST_OPTIMIZED"
  enable_photon             = each.value.enable_photon
  enable_serverless_compute = false
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

resource "databricks_sql_endpoint" "serverless" {
  name                      = "sql-warehouse-serverless"
  cluster_size              = "Small"
  enable_serverless_compute = true
  max_num_clusters          = 1

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

