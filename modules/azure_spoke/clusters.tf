# Create SQL Warehouses for each t-shirt size

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_sql_endpoint" "sql_warehouse" {
  for_each         = var.sql_warehouse_sizes
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

resource "databricks_cluster" "job_cluster" {
  for_each      = var.cluster_sizes
  cluster_name  = "job-cluster-${each.key}"
  spark_version = data.databricks_spark_version.latest_lts.id
  node_type_id  = each.value.node_type_id
  num_workers   = 1
  autoscale {
    min_workers = 1
    max_workers = each.value.max_num_clusters
  }
  autotermination_minutes = 20

  spark_conf = {
    "spark.master"                           = "local[*]"
    "spark.databricks.repl.allowedLanguages" = "python,sql",
    "spark.databricks.cluster.profile"       = "SingleNode"
  }

  custom_tags = var.tags

  workload_type {
    clients {
      jobs      = true
      notebooks = false
    }
  }
}

resource "databricks_cluster" "gp_cluster" {
  for_each      = var.cluster_sizes
  cluster_name  = "gp-cluster-${each.key}"
  spark_version = data.databricks_spark_version.latest_lts.id
  node_type_id  = each.value.node_type_id
  autoscale {
    min_workers = 1
    max_workers = each.value.max_num_clusters
  }
  autotermination_minutes = 20

  spark_conf = {
    "spark.master" = "local[*]"
  }

  custom_tags = var.tags

  workload_type {
    clients {
      jobs      = true
      notebooks = false
    }
  }
}

resource "databricks_cluster" "job_serverless" {
  cluster_name            = "job-cluster-serverless"
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = "Standard_DS3_v2"
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 3
  }

  spark_conf = {
    "spark.databricks.repl.allowedLanguages" = "python,sql",
    "spark.databricks.cluster.profile"       = "serverless"
  }

  custom_tags = var.tags

  workload_type {
    clients {
      jobs      = true
      notebooks = false
    }
  }
}
