# Databricks notebook source

# Get parameters
dbutils.widgets.text("source_catalog", "dev_databricksstu_sandbox")
dbutils.widgets.text("target_catalog", "dev_databricksstu_sandbox_new")
source_catalog = dbutils.widgets.get("source_catalog")
target_catalog = dbutils.widgets.get("target_catalog")

# Rename
spark.sql(f"ALTER CATALOG {source_catalog} RENAME TO {source_catalog}_REMOVE")
spark.sql(f"ALTER CATALOG {target_catalog} RENAME TO {source_catalog}")

# Drop
spark.sql(f"DROP CATALOG {source_catalog}_REMOVE")
