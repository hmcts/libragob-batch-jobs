\copy (select min(started_date) from RECONCILIATION_RUNS where RR_ID = &1) To '/scripts/9fAZUREDB_AMD_fines_recon_rundate.csv' With CSV DELIMITER ','