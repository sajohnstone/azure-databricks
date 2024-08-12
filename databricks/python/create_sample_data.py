# Get parameters
dbutils.widgets.text("catalog_name", "")
catalog_name = dbutils.widgets.get("catalog_name")

# Import libs
import random
from pyspark.sql.types import (
    StructType,
    StructField,
    IntegerType,
    StringType,
    FloatType,
)

# Function to create and populate a table in a specified catalog
def create_and_populate_table(catalog_name):
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

    # Define schema
    schema = StructType(
        [
            StructField("id", IntegerType(), nullable=False),
            StructField("name", StringType(), nullable=False),
            StructField("value", FloatType(), nullable=True),
        ]
    )

    # Generate sample data
    data = [(i, f"Name_{i}", random.uniform(0.0, 100.0)) for i in range(1, 101)]

    # Create DataFrame
    df = spark.createDataFrame(data, schema)

    # Write DataFrame to table
    df.write.mode("append").saveAsTable("example_schema.example_table")

# Call the function with the desired catalog name
create_and_populate_table(catalog_name)