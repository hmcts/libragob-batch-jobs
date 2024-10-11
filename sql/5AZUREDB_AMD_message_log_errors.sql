\copy (SELECT uq.schema_id,ml.message_log_id,ml.created_date,ml.error_message from message_log ml left join update_requests uq on ml.update_request_id = uq.update_request_id where uq.status != 'COMPLETE' order by ml.created_date desc) To '/tmp/ams-reporting/5AZUREDB_AMD_message_log_errors.csv' With CSV DELIMITER ','
