# Get parameters
dbutils.widgets.text("catalog_name", "")
catalog_name = dbutils.widgets.get("catalog_name")

def drop_catalog(catalog_name):
    try:
        # Drop the catalog if it exists
        spark.sql(f"DROP CATALOG IF EXISTS {catalog_name} CASCADE")
        print(f"Catalog '{catalog_name}' has been dropped successfully.")
    except Exception as e:
        print(f"Failed to drop catalog '{catalog_name}': {e}")

# Example usage:
drop_catalog(catalog_name)
