# Define the catalog to use
catalog_name = "dev_stutest_sandbox"

# Use the specified catalog
spark.sql(f"USE CATALOG {catalog_name}")

# Create schema
spark.sql("CREATE SCHEMA IF NOT EXISTS example_schema")

# Create example table
spark.sql("""
CREATE TABLE IF NOT EXISTS example_schema.example_table (
  id INT,
  name STRING,
  value FLOAT
)
""")