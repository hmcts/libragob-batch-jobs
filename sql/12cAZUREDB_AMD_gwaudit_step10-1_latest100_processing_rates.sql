\copy (SELECT * FROM (SELECT b.updated_date,b.message_uuid as uuid,round((EXTRACT(EPOCH from (b.updated_date-a.updated_date))*1000)::numeric,1) as "Roundtrip in Millisecs" FROM (select updated_date,message_status_id,message_uuid from themis_gateway.message_audit where message_status_id = 1) a,(select updated_date,message_status_id,message_uuid from themis_gateway.message_audit where message_status_id = 10 order by 1 desc limit 10) b WHERE a.message_uuid = b.message_uuid) x order by 1 desc) To '/tmp/ams-reporting/12cAZUREDB_AMD_gwaudit_step10-1_latest100_processing_rates.csv' With CSV DELIMITER ','
