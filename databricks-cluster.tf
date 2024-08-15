data "databricks_node_type" "smallest" {
  provider = databricks.workspace

  local_disk = true
  depends_on = [
    module.spoke
  ]
}

data "databricks_spark_version" "latest_lts" {
  provider = databricks.workspace

  long_term_support = true
  depends_on = [
    module.spoke
  ]
}

resource "databricks_cluster" "this" {
  provider = databricks.workspace

  cluster_name            = local.name
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = data.databricks_node_type.smallest.id
  autotermination_minutes = 20
  num_workers             = 2
  data_security_mode      = "USER_ISOLATION"
  autoscale {
    min_workers = 1
    max_workers = 3
  }
}
