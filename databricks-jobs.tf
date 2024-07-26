resource "databricks_job" "catalog_migration" {
  provider = databricks.workspace

  name                = "catalog-migration"
  existing_cluster_id = databricks_cluster.this.id

  parameter {
    name    = "source_catalog"
    default = databricks_catalog.sandbox.name
  }
  parameter {
    name    = "target_catalog"
    default = databricks_catalog.sandbox_new.name
  }

  task {
    task_key = "create-sample-data"
    notebook_task {
      notebook_path = databricks_notebook.create_sample_data.path
    }
  }

  task {
    task_key = "migrate-data"
    depends_on {
      task_key = "create-sample-data"
    }
    notebook_task {
      notebook_path = databricks_notebook.migrate_data.path
    }
  }

  task {
    task_key = "run-tests"
    depends_on {
      task_key = "migrate-data"
    }
    notebook_task {
      notebook_path = databricks_notebook.run_tests.path
    }
  }
  depends_on = [databricks_cluster.this]
}
