# Get parameters
dbutils.widgets.text("catalog_name", "")
catalog_name = dbutils.widgets.get("catalog_name")

# Create catalog
def create_catalog(catalog_name):
    create_catalog_sql = f"CREATE CATALOG IF NOT EXISTS {catalog_name};"
    spark.sql(create_catalog_sql)

# Call the function to create the catalog
create_catalog(catalog_name)