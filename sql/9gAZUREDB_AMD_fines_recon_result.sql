\copy (select error_count from RECONCILIATION_RUNS where RR_ID = &1 and error_count = 1) To '/tmp/ams-reporting/9gAZUREDB_AMD_***REMOVED***nes_recon_result.csv' With CSV DELIMITER ','
