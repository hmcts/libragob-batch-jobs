\copy (select error_count from RECONCILIATION_RUNS where RR_ID = &1 and error_count = 1) To '/tmp/ams-reporting/9cAZUREDB_AMD_confiscation_recon_result.csv' With CSV DELIMITER ','
