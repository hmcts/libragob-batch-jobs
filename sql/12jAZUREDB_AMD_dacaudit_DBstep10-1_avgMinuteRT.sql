\copy (SELECT date_trunc('minute',updated_date) as "Date",round(avg(TOTAL_SEC)*1000) as "AVG(Total Roundtrip in Millisecs)",round(sum(TOTAL_SEC)::numeric,1) as "TotalWorkload in Secs",count(*) as "RecordCount" FROM (SELECT a.updated_date,a.message_uuid as uuid,EXTRACT(EPOCH from (b.updated_date-a.updated_date)) as TOTAL_SEC FROM (select updated_date,message_status_id,message_uuid from themis_dac.message_audit where message_status_id = 1 and action_type='getUpdateRequest' and updated_date > current_timestamp - INTERVAL '2 hour') a,(select updated_date,message_status_id,message_uuid from themis_dac.message_audit where message_status_id = 10 and action_type='getUpdateRequestResponse' and updated_date > current_timestamp - INTERVAL '2 hour') b WHERE a.message_uuid = b.message_uuid) x GROUP BY date_trunc('minute',updated_date)
order by 1 desc) To '/scripts/12jAZUREDB_AMD_dacaudit_DBstep10-1_avgMinuteRT.csv' With CSV DELIMITER ','