\copy (select rr_id,schema_id,date(completed_date) from RECONCILIATION_RUNS where error_count != 0 group by rr_id,schema_id,date(completed_date) order by date(completed_date) desc) To '/tmp/ams-reporting/9AZUREDB_AMD_fines_recon_errors.csv' With CSV DELIMITER ','
