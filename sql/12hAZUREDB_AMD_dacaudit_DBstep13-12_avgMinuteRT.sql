\copy (SELECT date_trunc('minute',updated_date) as "Date",round(avg(TOTAL_SEC)*1000) as "AVG(DAC_DB_Roundtrip in Millisecs)",round(sum(TOTAL_SEC)) as "TotalWorkload in Secs",count(*) as "RecordCount" FROM (SELECT a.updated_date,a.message_uuid as uuid,EXTRACT(EPOCH from (b.updated_date-a.updated_date)) as TOTAL_SEC FROM (select updated_date,message_status_id,message_uuid from themis_dac.message_audit where message_status_id = 12 and message_content like 'public.get_next_update_request%' and action_type = 'GetNextUpdateRequest' and updated_date > current_timestamp - INTERVAL '2 hour') a,(select updated_date,message_status_id,message_uuid from themis_dac.message_audit where message_status_id = 13 and message_content like 'DB_RESPONSE%' and action_type = 'GetNextUpdateRequestResponse' and updated_date > current_timestamp - INTERVAL '2 hour') b WHERE a.message_uuid = b.message_uuid) x GROUP BY date_trunc('minute',updated_date) order by 1 desc) To '/scripts/12hAZUREDB_AMD_dacaudit_DBstep13-12_avgMinuteRT.csv' With CSV DELIMITER ','