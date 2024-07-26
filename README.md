# Terraform Azure Databricks Environment

This project provides Terraform configurations to deploy an example Databricks environment to Azure. It uses Docker containers to manage tooling such as Terraform itself. The project also includes a Makefile to streamline common operations.

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

### Docker Setup

The Docker container is configured to run Terraform and other tooling required for this project. It will map a volume to bring in the credentials for Azure and Databricks but you will either need to configure these prior to running or update the use the appropriate secrets. 

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

<!-- BEGINNING OF AUTO-GENERATED CONTENT -->
<!-- terraform-docs start -->
<!-- terraform-docs end -->
<!-- END OF AUTO-GENERATED CONTENT -->