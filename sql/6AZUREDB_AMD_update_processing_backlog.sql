\copy (SELECT schema_id,  MIN(CASE WHEN status = 'UNPROCESSED' THEN created_date END) AS earliest_unprocessed,  MAX(CASE WHEN status = 'COMPLETE' THEN processed_date END) AS latest_complete,  MAX(CASE WHEN status = 'PROCESSING' THEN created_date END) AS latest_processing FROM update_requests GROUP BY  schema_id ORDER by 2 asc) To '/scripts/6AZUREDB_AMD_update_processing_backlog.csv' With CSV DELIMITER ','