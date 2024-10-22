resource "databricks_notebook" "create_sample_data" {
  provider = databricks.workspace

  content_base64 = base64encode(file("./python/create_sample_data.py"))
  path           = "/code/create_sample_data"
  language       = "PYTHON"
}

resource "databricks_notebook" "run_tests" {
  provider = databricks.workspace

  content_base64 = base64encode(file("./python/run_tests.py"))
  path           = "/code/run_tests"
  language       = "PYTHON"
}

resource "databricks_notebook" "migrate_data" {
  provider = databricks.workspace

  content_base64 = base64encode(file("./python/migrate_data.py"))
  path           = "/code/migrate_data"
  language       = "PYTHON"
}

resource "databricks_notebook" "create_catalog" {
  provider = databricks.workspace

  content_base64 = base64encode(file("./python/create_catalog.py"))
  path           = "/code/create_catalog"
  language       = "PYTHON"
}

resource "databricks_notebook" "drop_catalog" {
  provider = databricks.workspace

  content_base64 = base64encode(file("./python/drop_catalog.py"))
  path           = "/code/drop_catalog"
  language       = "PYTHON"
}
