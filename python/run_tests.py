# Databricks notebook source

# Install Pip
%pip install dbl-discoverx==0.0.8
dbutils.library.restartPython()

# Get parameters
dbutils.widgets.text("source_catalog", "dev_stutest_sandbox")
dbutils.widgets.text("target_catalog", "dev_stutest_sandbox_new")
source_catalog = dbutils.widgets.get("source_catalog")
target_catalog = dbutils.widgets.get("target_catalog")

# Import databrickslabs / discoverx 
from discoverx import DX
dx = DX()

# Compare the source and raget tables
def compare_dataframes(table_info):
    # Load data from source and target tables into DataFrames
    source_df = spark.table(f"{table_info.catalog}.{table_info.schema}.{table_info.table}")
    target_df = spark.table(f"{target_catalog}.{table_info.schema}.{table_info.table}")

    # Count rows in each DataFrame
    count_source = source_df.count()
    count_target = target_df.count()
    
    # Check if row counts are the same
    if count_source != count_target:
        return False, f"Row counts differ: Source={count_source}, Target={count_target}"
    
    # Check if data matches exactly
    diff_df = source_df.exceptAll(target_df).union(target_df.exceptAll(source_df))
    if diff_df.count() > 0:
        return False, "Data differs between source and target"
    
    return True, "Source and target data match"

# Process the tables
res = dx.from_tables(f"{source_catalog}.*.*").map(compare_dataframes)

# Print the result
print(res)