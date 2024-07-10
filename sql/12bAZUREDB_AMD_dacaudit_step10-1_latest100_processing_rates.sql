\copy (SELECT * FROM (SELECT b.updated_date,b.message_uuid as uuid,round((EXTRACT(EPOCH from (b.updated_date-a.updated_date))*1000)::numeric,1) as "Roundtrip in Millsecs" FROM (select updated_date,message_status_id,message_uuid from themis_dac.message_audit where message_status_id = 1 and action_type='getUpdateRequest') a,(select updated_date,message_status_id,message_uuid from themis_dac.message_audit where message_status_id = 10 and action_type='getUpdateRequestResponse' order by 1 desc limit 100) b WHERE a.message_uuid = b.message_uuid) x order by 1 desc) To '/scripts/12bAZUREDB_AMD_dacaudit_step10-1_latest100_processing_rates.csv' With CSV DELIMITER ','