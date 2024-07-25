# Databricks notebook source
dbutils.widgets.text("source_catalog", "")
dbutils.widgets.text("target_catalog", "")
source_catalog = dbutils.widgets.get("source_catalog")
target_catalog = dbutils.widgets.get("target_catalog")

# Get all schemas in the source catalog, excluding 'information_schema'
schemas = [schema['databaseName'] for schema in spark.sql(f"SHOW SCHEMAS IN {source_catalog}").collect() if schema['databaseName'] != 'information_schema']

# Iterate through each schema
for schema_name in schemas:
    # Get all tables in the current schema
    tables = spark.sql(f"SHOW TABLES IN {source_catalog}.{schema_name}").collect()
    for table in tables:
        table_name = table['tableName']
        # Insert data from source table to target table
        spark.sql(f"INSERT INTO {target_catalog}.{schema_name}.{table_name} SELECT * FROM {source_catalog}.{schema_name}.{table_name}")
