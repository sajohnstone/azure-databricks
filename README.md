# Deploying Azure Databricks

An example Terraform Databricks deployment.
NOTE: I've noticed that with some Databricks resources that there is a dependacy / timing issue with catalogs
For this example I just run apply twice to fix, but adding the correct [Depends_on] may fix the problem.

'''bash
make plan
'''

'''bash
make apply
'''
