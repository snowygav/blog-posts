CREATE EXTERNAL SCHEMA poc_spectrum FROM DATA CATALOG 
DATABASE 'trusted_redshift' 
IAM_ROLE 'arn:aws:iam::ACCOUNT_ID:role/lakehouse-spectrum-poc-redshift-role'