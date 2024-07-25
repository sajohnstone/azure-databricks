resource "databricks_job" "catalog_migration" {
  provider = databricks.workspace

  name = "catalog-migration"

  new_cluster {
    cluster_name  = local.name_prefix
    spark_version = data.databricks_spark_version.latest_lts.id
    node_type_id  = data.databricks_node_type.smallest.id
    num_workers = 1
  }


  task {
    task_key = "create-sample-data"
    notebook_task {
      notebook_path = databricks_notebook.create_sample_data.path
    }
  }

  task {
    task_key = "migrate-schema"
    notebook_task {
      notebook_path = databricks_notebook.migrate_schema.path
    }
  }

  task {
    task_key = "migrate-data"
    notebook_task {
      notebook_path = databricks_notebook.migrate_data.path
    }
  }
  depends_on = [databricks_cluster.this]
}
