# Terraform Azure Databricks Environment

This project provides Terraform configurations to deploy an example Databricks environment to Azure. It uses Docker containers to manage tooling such as Terraform itself. The project also includes a Makefile to streamline common operations.
Note: Since creating this repo I've found this repo (https://github.com/databricks/terraform-databricks-sra) which is an excellent resource.

## Project Structure

- **`main.tf`**: Terraform configuration for deploying Databricks resources on Azure.
- **`variables.tf`**: Definitions for Terraform input variables.
- **`Dockerfile`**: Docker configuration for setting up the environment with necessary tools.
- **`Makefile`**: A file containing commands to manage the Terraform environment and tooling.
- **`README.md`**: This file.

## Getting Started

### Prerequisites

- Docker installed on your machine.
- Make installed on your machine.

### SAT Tool
To use the SAT tool the service principal 'SP for Security Analysis Tool' which is generated by this needs to be given Account Admin rights.  It is not possible to automated this so to use the SAT tool the process is:
1. Make the SP for Security Analysis Tool an Account Admin
2. Run the 'SAT Initializer Notebook (one-time)' job

### Docker Setup

The Docker container is configured to run Terraform and other tooling required for this project. It will map a volume to bring in the credentials for Azure and Databricks but you will either need to configure these prior to running or update the use the appropriate secrets.

### Repo Setup

- **`core`**: Install this first as this creates a VNet and Bastion that can be used to deploy databricks
- **`databricks`**: If you enable full PrivateLink then you need to deploy from within your Azure VNet or it will fail.  

### References

Databricks SAT tool: https://github.com/databricks-industry-solutions/security-analysis-tool
Databricks Dashboards: https://github.com/databricks/tmm/tree/main/System-Tables-Demo

### Commands

The project includes a Makefile with several commands to help manage your Terraform configurations. Here’s a brief overview of each command:

- **`make apply`**: Deploys the resources defined in your Terraform configuration to Azure.

  ```bash
  make apply
  ```

- **`make check-security`**: Performs static analysis on your Terraform templates to identify potential security issues.

  ```bash
  make check-security
  ```

- **`make destroy`**: Destroys all the resources created by the Terraform configuration.

  ```bash
  make destroy
  ```

- **`make documentation`**: Generates the `README.md` file for your project.

  ```bash
  make documentation
  ```

- **`make format`**: Rewrites all Terraform configuration files to a canonical format.

  ```bash
  make format
  ```

- **`make lint`**: Checks for possible errors and best practices in your Terraform configuration.

  ```bash
  make lint
  ```

- **`make plan`**: Shows the deployment plan for your Terraform configuration, outlining what changes will be made.

  ```bash
  make plan
  ```

## Terraform Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.1 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | ~> 1.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.113.0 |
| <a name="provider_databricks.workspace"></a> [databricks.workspace](#provider\_databricks.workspace) | 1.49.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_databricks_access_connector.external](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_access_connector) | resource |
| [azurerm_databricks_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace) | resource |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_network_security_group.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.external](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_subnet.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [databricks_catalog.sandbox](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/catalog) | resource |
| [databricks_catalog.sandbox_new](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/catalog) | resource |
| [databricks_cluster.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster) | resource |
| [databricks_external_location.external](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/external_location) | resource |
| [databricks_job.catalog_migration](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/job) | resource |
| [databricks_metastore_assignment.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/metastore_assignment) | resource |
| [databricks_notebook.create_sample_data](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/notebook) | resource |
| [databricks_notebook.migrate_data](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/notebook) | resource |
| [databricks_notebook.run_tests](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/notebook) | resource |
| [databricks_storage_credential.external](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/storage_credential) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [databricks_node_type.smallest](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/node_type) | data source |
| [databricks_spark_version.latest_lts](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/spark_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | The ID of the Azure subscription | `string` | n/a | yes |
| <a name="input_databricks_account_id"></a> [databricks\_account\_id](#input\_databricks\_account\_id) | (Required) The ID of the Databricks | `string` | n/a | yes |
| <a name="input_databricks_sku"></a> [databricks\_sku](#input\_databricks\_sku) | (Optional) The SKU to use for the databricks instance | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) Three character environment name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Optional) The location for resource deployment | `string` | `"australiaeast"` | no |
| <a name="input_metastore_id"></a> [metastore\_id](#input\_metastore\_id) | (Required) The ID of the Metastore | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | (Required) The project name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->