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

# Function to clone tables from a source catalog to a destination catalog
def clone_tables_to_catalog(source_catalog, destination_catalog):
    def clone_tables(table_info):
        spark.sql(f"CREATE SCHEMA IF NOT EXISTS {destination_catalog}.{table_info.schema}")
        try:
            spark.sql(
                f"""CREATE OR REPLACE TABLE 
        {destination_catalog}.{table_info.schema}.{table_info.table} 
        DEEP CLONE {table_info.catalog}.{table_info.schema}.{table_info.table}
        """
            )
            result = {
                "source": f"{table_info.catalog}.{table_info.schema}.{table_info.table}",
                "destination": f"{destination_catalog}.{table_info.schema}.{table_info.table}",
                "success": True,
                "info": None,
            }
        # Cloning Views is not supported
        except Exception as error:
            result = {
                "source": f"{table_info.catalog}.{table_info.schema}.{table_info.table}",
                "destination": f"{destination_catalog}.{table_info.schema}.{table_info.table}",
                "success": False,
                "info": error,
            }
        return result
    
    # Process the tables from the source catalog
    return dx.from_tables(f"{source_catalog}.*.*").map(clone_tables)

# Call the function with the source and target catalogs
res = clone_tables_to_catalog(source_catalog, target_catalog)

# Print out the result
for result in res:
    print(f"Source: {result['source']}")
    print(f"Destination: {result['destination']}")
    print(f"Success: {result['success']}")
    if result['info']:
        print(f"Info: {result['info']}")
    print("-" * 50)