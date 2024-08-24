resource "databricks_repo" "security_analysis_tool" {
  url    = "https://github.com/databricks-industry-solutions/security-analysis-tool.git"
  branch = "main"
  path   = "/Workspace/Applications/SAT_TF"
}

resource "databricks_job" "initializer" {
  name = "SAT Initializer Notebook (one-time)"

  task {
    existing_cluster_id = var.job_cluster_id
    task_key = "Initializer"
    library {
      pypi {
        package = "dbl-sat-sdk"
      }
    }
    notebook_task {
      notebook_path = "${databricks_repo.security_analysis_tool.workspace_path}/notebooks/security_analysis_initializer"
    }
  }
}

resource "databricks_job" "driver" {
  name = "SAT Driver Notebook"

  task {
    existing_cluster_id = var.job_cluster_id
    task_key        = "Driver"
    library {
      pypi {
        package = "dbl-sat-sdk"
      }
    }
    notebook_task {
      notebook_path = "${databricks_repo.security_analysis_tool.workspace_path}/notebooks/security_analysis_driver"
    }
  }

  schedule {
    #E.G. At 08:00:00am, on every Monday, Wednesday and Friday, every month; For more: http://www.quartz-scheduler.org/documentation/quartz-2.3.0/tutorials/crontrigger.html
    quartz_cron_expression = "0 0 8 ? * Mon,Wed,Fri"
    # The system default is UTC; For more: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    timezone_id = "America/New_York"
  }
}
