# Databricks notebook source

source_catalog = "dev_stutest_sandbox"
target_catalog = "dev_stutest_sandbox_new"

# Get all schemas in the source catalog, excluding 'information_schema'
schemas = [schema['namespace'] for schema in spark.sql(f"SHOW SCHEMAS IN {source_catalog}").collect() if schema['namespace'] != 'information_schema']

# Iterate through each schema
for schema_name in schemas:
    # Get all tables in the current schema
    tables = spark.sql(f"SHOW TABLES IN {source_catalog}.{schema_name}").collect()
    for table in tables:
        table_name = table['tableName']
        # Insert data from source table to target table
        spark.sql(f"INSERT INTO {target_catalog}.{schema_name}.{table_name} SELECT * FROM {source_catalog}.{schema_name}.{table_name}")
