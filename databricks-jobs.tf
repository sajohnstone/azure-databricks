resource "databricks_job" "catalog_migration_to_temp" {
  provider = databricks.workspace

  name                = "catalog-migration-to-temp"
  existing_cluster_id = module.spoke.small_job_cluster_id

  #create-sample-data
  task {
    task_key = "create-sample-data"
    notebook_task {
      notebook_path = databricks_notebook.create_sample_data.path
      base_parameters = {
        catalog_name = module.sandbox.catalog_name
      }
    }
  }

  #create-tmp-catalog
  task {
    task_key            = "create-tmp-catalog"
    existing_cluster_id = module.spoke.small_job_cluster_id

    depends_on {
      task_key = "create-sample-data"
    }
    notebook_task {
      notebook_path = databricks_notebook.create_catalog.path
      base_parameters = {
        catalog_name = "dev_databricksstu_tmp"
      }
    }
  }

  #migrate-data-to-tmp
  task {
    task_key            = "migrate-data-to-tmp"
    existing_cluster_id = module.spoke.small_job_cluster_id
    depends_on {
      task_key = "create-tmp-catalog"
    }
    notebook_task {
      notebook_path = databricks_notebook.migrate_data.path
      base_parameters = {
        source_catalog = module.sandbox.catalog_name
        target_catalog = "dev_databricksstu_tmp"
      }
    }
  }

  #test-data-to-tmp
  task {
    task_key            = "test-data-to-tmp"
    existing_cluster_id = module.spoke.small_job_cluster_id
    depends_on {
      task_key = "migrate-data-to-tmp"
    }
    notebook_task {
      notebook_path = databricks_notebook.run_tests.path
      base_parameters = {
        source_catalog = module.sandbox.catalog_name
        target_catalog = "dev_databricksstu_tmp"
      }
    }
  }
}

resource "databricks_job" "catalog_migration_temp_to_new_catalog" {
  provider = databricks.workspace

  name                = "catalog-temp-to-new-catlog"
  existing_cluster_id = module.spoke.small_job_cluster_id

  #migrate-tmp-to-data
  task {
    task_key            = "migrate-tmp-to-data"
    existing_cluster_id = module.spoke.small_job_cluster_id
    notebook_task {
      notebook_path = databricks_notebook.migrate_data.path
      base_parameters = {
        source_catalog = "dev_databricksstu_tmp"
        target_catalog = "${local.name}_sandbox"
      }
    }
  }

  #test-data-to-tmp
  task {
    task_key            = "test-tmp-to-data"
    existing_cluster_id = module.spoke.small_job_cluster_id
    depends_on {
      task_key = "migrate-tmp-to-data"
    }
    notebook_task {
      notebook_path = databricks_notebook.run_tests.path
      base_parameters = {
        source_catalog = "dev_databricksstu_tmp"
        target_catalog = "${local.name}_sandbox"
      }
    }
  }

  #drop-source-catalog (NOTE will need to remove this in TF after this is applied)
  task {
    task_key            = "drop-source-catalog"
    existing_cluster_id = module.spoke.small_job_cluster_id
    depends_on {
      task_key = "test-tmp-to-data"
    }
    notebook_task {
      notebook_path = databricks_notebook.drop_catalog.path
      base_parameters = {
        catalog_name = "dev_databricksstu_tmp"
      }
    }
  }
}

