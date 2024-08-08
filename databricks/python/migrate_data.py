# Databricks notebook source

# Install Pip
%pip install dbl-discoverx==0.0.8
dbutils.library.restartPython()

# Get parameters
dbutils.widgets.text("source_catalog", "dev_databricksstu_sandbox")
dbutils.widgets.text("target_catalog", "dev_databricksstu_sandbox_new")
source_catalog = dbutils.widgets.get("source_catalog")
target_catalog = dbutils.widgets.get("target_catalog")

# Import databrickslabs / discoverx 
from discoverx import DX
dx = DX()

# Catalog should already exist but if not create
#spark.sql(f"CREATE CATALOG IF NOT EXISTS {destination_catalog}")

# Use DEEP clone to recreate the table
def clone_tables(table_info):
    spark.sql(f"CREATE SCHEMA IF NOT EXISTS {target_catalog}.{table_info.schema}")
    try:
        spark.sql(
            f"""CREATE OR REPLACE TABLE 
    {target_catalog}.{table_info.schema}.{table_info.table} 
    DEEP CLONE {table_info.catalog}.{table_info.schema}.{table_info.table}
    """
        )
        result = {
            "source": f"{table_info.catalog}.{table_info.schema}.{table_info.table}",
            "destination": f"{target_catalog}.{table_info.schema}.{table_info.table}",
            "success": True,
            "info": None,
        }
    # Cloning Views is not supported
    except Exception as error:
        result = {
            "source": f"{table_info.catalog}.{table_info.schema}.{table_info.table}",
            "destination": f"{target_catalog}.{table_info.schema}.{table_info.table}",
            "success": False,
            "info": error,
        }
    return result

# Process the tables
res = dx.from_tables(f"{source_catalog}.*.*").map(clone_tables)
