DELETE FROM themis_gateway.message_audit
WHERE updated_date < CURRENT_TIMESTAMP - interval '2 days';