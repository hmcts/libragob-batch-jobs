\copy (SELECT date_trunc('hour',CREATED_DATE) as "Day",count(*) as "COUNTupdates",sum(number_of_table_updates) as "SUMnumber_of_table_updates",max(number_of_table_updates) as "MAXnumber_of_table_updates" from public.update_requests where created_date > current_date group by date_trunc('hour',CREATED_DATE) order by 1 desc) To '/scripts/8AZUREDB_AMD_todays_hourly_update_counts.csv' With CSV DELIMITER ','