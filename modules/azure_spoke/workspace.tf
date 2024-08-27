locals {
  ## Source: https://docs.databricks.com/en/admin/account-settings/audit-logs.html
  security_logs_critial = [
    "accounts",       # Events related to accounts, users, groups, and IP access lists.  Check for user management, access changes, and potential unauthorized access.
    "dbfs",           # Events related to DBFS. Check for data access and potential exfiltration attempts.
    "gitCredentials", # Events related to Git credentials for Databricks Git folders. See also repos.  Check for cred misuse
    "iamRole",        # Events related to IAM role permissions.  Check for to changes to identity and access management,
    "secrets",        # Events related to secrets.  Check for changes in secrets management
    "ssh",            # Events related to SSH access.  Check for diirect access to resources via SSH (which mostly shouldn't be needed)
    "webTerminal",    # Events related to the web terminal feature.
  ]
  security_logs_high = [
    "clusters",          # Events related to clusters. Check for misconfiguration
    "globalInitScripts", # Events related to global init scripts.  Check for misconfiguration
    "instancePools",     # Events related to pools. Check for misconfiguration
    "jobs",              # Events related to jobs. Check for misconfiguration
    "notebook",          # Events related to notebooks. Check for the code that is being executed
    "repos",             # Events related to Databricks Git folders. Check for changes to version-controlled code
    "workspace",         # Events related to workspaces.
  ]
  security_logs_med = [
    "dashboards",                  # Events related to AI/BI dashboard use.
    "databrickssql",               # Events related to Databricks SQL use.
    "dataMonitoring",              # Events related to Lakehouse Monitoring.
    "deltaPipelines",              # Events related to Delta Live Table pipelines.
    "featureStore",                # Events related to the Databricks Feature Store.
    "genie",                       # Events related to workspace access by support personnel.
    "ingestion",                   # Events related to file uploads.
    "marketplaceConsumer",         # Events related to consumer actions in Databricks Marketplace.
    "mlflowAcledArtifact",         # Events related to ML Flow artifacts with ACLs.
    "mlflowExperiment",            # Events related to ML Flow experiments.
    "modelRegistry",               # Events related to the workspace model registry. For activity logs for models in Unity Catalog, see Unity Catalog events.
    "predictiveOptimization",      # Events related to predictive optimization.
    "remoteHistoryService",        # Events related to adding a removing GitHub Credentials.
    "serverlessRealTimeInference", # Events related to model serving.
    "sqlPermissions",              # Events related to the legacy Hive metastore table access control.
  ]
  not_supported = [
    # "clusterpolicies",   # Events related to cluster policies.  Check for policy changes
    # "filesystem",                  # Events related to the Files API.
    # "groups",                      # Events related to account and workspace groups.
    # "marketplaceProvider",         # Events related to provider actions in Databricks Marketplace.
    # "partnerConnect",              # Events related to Partner Connect.
    # "vectorSearch",                # Events related to Mosaic AI Vector Search.  
    # "accountBillableUsage",        # Actions related to billable usage access in the account console.
  ]
}

resource "azurerm_databricks_workspace" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.databricks_sku

  public_network_access_enabled         = !var.boolean_adb_private_link
  network_security_group_rules_required = var.boolean_adb_private_link ? "NoAzureDatabricksRules" : "AllRules"

  custom_parameters {
    no_public_ip                                         = var.boolean_adb_private_link
    virtual_network_id                                   = data.azurerm_virtual_network.spoke_vnet.id
    public_subnet_name                                   = data.azurerm_subnet.public.name
    private_subnet_name                                  = data.azurerm_subnet.private.name
    private_subnet_network_security_group_association_id = data.azurerm_network_security_group.private_subnet_nsg.id
    public_subnet_network_security_group_association_id  = data.azurerm_network_security_group.public_subnet_nsg.id
  }

  depends_on = [
    data.azurerm_subnet.public,
    data.azurerm_subnet.private,
    data.azurerm_virtual_network.spoke_vnet
  ]

  lifecycle {
    ignore_changes = [
      custom_parameters
    ]
  }
}

resource "databricks_metastore_assignment" "this" {
  metastore_id = var.metastore_id
  workspace_id = azurerm_databricks_workspace.this.workspace_id
  depends_on   = [azurerm_databricks_workspace.this]
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  count = var.boolean_enable_logging ? 1 : 0

  name                       = "${var.name}-diag"
  target_resource_id         = azurerm_databricks_workspace.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = toset(concat(local.security_logs_critial, local.security_logs_high, local.security_logs_med))
    content {
      category = enabled_log.value
    }
  }
}
