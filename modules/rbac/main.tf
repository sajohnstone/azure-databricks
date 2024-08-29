
# Flatten the list of cluster names and make it a set of unique values
locals {
  cluster_names = distinct(flatten([
    for group, permissions in var.databricks_permissions : concat(
      permissions.cluster.can_manage,
      permissions.cluster.can_restart
    )
  ]))
  sql_endpoints = distinct(flatten([
    for group, permissions in var.databricks_permissions : concat(
      permissions.sql_endpoint.can_manage,
      permissions.sql_endpoint.can_use,
    )
  ]))
  jobs = distinct(flatten([
    for group, permissions in var.databricks_permissions : concat(
      permissions.job.can_manage,
      permissions.job.can_view,
      permissions.job.can_run,
    )
  ]))
  cluster_policies = distinct(flatten([
    for group, permissions in var.databricks_permissions : concat(
      permissions.cluster_policy.can_use
    )
  ]))
}

# Fetch cluster IDs based on names
data "databricks_cluster" "clusters" {
  for_each     = toset(local.cluster_names)
  cluster_name = each.value
}

resource "databricks_permissions" "cluster_permissions_can_manage" {
  for_each = data.databricks_cluster.clusters

  cluster_id = each.value.id

  dynamic "access_control" {
    for_each = [
      for group, permissions in var.databricks_permissions :
      {
        group_name       = group
        permission_level = "CAN_MANAGE"
        condition        = contains(permissions.cluster.can_manage, each.key)
      }
    ]
    content {
      group_name       = access_control.value.group_name
      permission_level = access_control.value.permission_level
    }
  }
}

resource "databricks_permissions" "cluster_permissions_can_restart" {
  for_each = data.databricks_cluster.clusters

  cluster_id = each.value.id

  dynamic "access_control" {
    for_each = [
      for group, permissions in var.databricks_permissions :
      {
        group_name       = group
        permission_level = "CAN_RESTART"
        condition        = contains(permissions.cluster.can_restart, each.key)
      }
    ]
    content {
      group_name       = access_control.value.group_name
      permission_level = access_control.value.permission_level
    }
  }
}

# Fetch SQL Endpoint IDs based on names
data "databricks_sql_warehouse" "sql_endpoints" {
  for_each = toset(local.sql_endpoints)
  name     = each.value
}

resource "databricks_permissions" "sql_endpoint_permissions_can_use" {
  for_each = data.databricks_sql_warehouse.sql_endpoints

  sql_endpoint_id = each.value.id

  dynamic "access_control" {
    for_each = [
      for group, permissions in var.databricks_permissions : {
        group_name       = group
        permission_level = "CAN_USE"
        condition        = contains(permissions.sql_endpoint.can_use, each.key)
      }
    ]
    content {
      group_name       = access_control.value.group_name
      permission_level = access_control.value.permission_level
    }
  }
}

resource "databricks_permissions" "sql_endpoint_permissions_can_manage" {
  for_each = data.databricks_sql_warehouse.sql_endpoints

  sql_endpoint_id = each.value.id

  dynamic "access_control" {
    for_each = [
      for group, permissions in var.databricks_permissions : {
        group_name       = group
        permission_level = "CAN_MANAGE"
        condition        = contains(permissions.sql_endpoint.can_manage, each.key)
      }
    ]
    content {
      group_name       = access_control.value.group_name
      permission_level = access_control.value.permission_level
    }
  }
}

# Fetch Job IDs based on names
data "databricks_job" "jobs" {
  for_each = toset(local.jobs)
  job_name = each.value
}

resource "databricks_permissions" "job_permissions_can_manage" {
  for_each = data.databricks_job.jobs

  job_id = each.value.id

  dynamic "access_control" {
    for_each = [
      for group, permissions in var.databricks_permissions : {
        group_name       = group
        permission_level = "CAN_MANAGE"
        condition        = contains(permissions.job.can_manage, each.key)
      }
    ]
    content {
      group_name       = access_control.value.group_name
      permission_level = access_control.value.permission_level
    }
  }
}

resource "databricks_permissions" "job_permissions_can_view" {
  for_each = data.databricks_job.jobs

  job_id = each.value.id

  dynamic "access_control" {
    for_each = [
      for group, permissions in var.databricks_permissions : {
        group_name       = group
        permission_level = "CAN_VIEW"
        condition        = contains(permissions.job.can_view, each.key)
      }
    ]
    content {
      group_name       = access_control.value.group_name
      permission_level = access_control.value.permission_level
    }
  }
}

resource "databricks_permissions" "job_permissions_can_run" {
  for_each = data.databricks_job.jobs

  job_id = each.value.id

  dynamic "access_control" {
    for_each = [
      for group, permissions in var.databricks_permissions : {
        group_name       = group
        permission_level = "CAN_MANAGE_RUN"
        condition        = contains(permissions.job.can_run, each.key)
      }
    ]
    content {
      group_name       = access_control.value.group_name
      permission_level = access_control.value.permission_level
    }
  }
}

# Fetch Cluster Policy IDs based on names
data "databricks_cluster_policy" "cluster_policies" {
  for_each = toset(local.cluster_policies)
  name     = each.value
}

resource "databricks_permissions" "cluster_policy_permissions_can_use" {
  for_each = data.databricks_cluster_policy.cluster_policies

  cluster_policy_id = each.value.id

  dynamic "access_control" {
    for_each = [
      for group, permissions in var.databricks_permissions : {
        group_name       = group
        permission_level = "CAN_USE"
        condition        = contains(permissions.cluster_policy.can_use, each.key)
      }
    ]
    content {
      group_name       = access_control.value.group_name
      permission_level = access_control.value.permission_level
    }
  }
}
