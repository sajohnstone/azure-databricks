resource "databricks_job" "catalog_migration" {
  provider = databricks.workspace
  name = "catalog-migration"


  parameter {
      name  = "source_catalog"
      default = databricks_catalog.sandbox.name
  }
  parameter {
    name  = "target_catalog"
    default = databricks_catalog.sandbox_new.name
  }

  task {
    task_key = "create-sample-data"
    notebook_task {
      notebook_path = databricks_notebook.create_sample_data.path
    }
  }

  task {
    task_key = "migrate-schema"
    depends_on {
      task_key = "create-sample-data"
    }
    notebook_task {
      notebook_path = databricks_notebook.migrate_schema.path
    }
  }

  task {
    task_key = "migrate-data"
    depends_on {
      task_key = "migrate-schema"
    }
    notebook_task {
      notebook_path = databricks_notebook.migrate_data.path
    }
  }
  depends_on = [databricks_cluster.this]
}
