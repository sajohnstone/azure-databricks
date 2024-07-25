
source_catalog = "dev_stutest_sandbox"
target_catalog = "dev_stutest_sandbox_new"

# Get all schemas in the source catalog, excluding 'information_schema'
schemas = [schema['databaseName'] for schema in spark.sql(f"SHOW SCHEMAS IN {source_catalog}").collect() if schema['databaseName'] != 'information_schema']

# Iterate through each schema
for schema_name in schemas:
    # Create schema in target catalog
    spark.sql(f"CREATE SCHEMA IF NOT EXISTS {target_catalog}.{schema_name}")

    # Get all tables in the current schema
    tables = spark.sql(f"SHOW TABLES IN {source_catalog}.{schema_name}").collect()
    for table in tables:
        table_name = table['tableName']
        # Get the DDL for the current table
        ddl = spark.sql(f"SHOW CREATE TABLE {source_catalog}.{schema_name}.{table_name}").collect()[0][0]
        # Replace the source catalog with the target catalog in the DDL
        target_ddl = ddl.replace(source_catalog, target_catalog)
        # Execute the DDL to create the table in the target catalog
        spark.sql(target_ddl)