/*
resource "databricks_library" "pypi_libraries" {
  for_each   = databricks_cluster.gp_cluster
  cluster_id = each.value.id
  pypi {
    package = "langchain"
  }
}
*/

resource "databricks_cluster_policy" "default" {
  name       = "Default cluster policy"
  definition = file("${path.module}/cluster_policies/default.json")
}
