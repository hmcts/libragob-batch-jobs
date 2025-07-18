#!/bin/bash
echo "Running housekeeping tasks against the LibraGoB database..."

runSQL() {
  DB_USER=$1
  PGPASSWORD=$2
  url=$3
  filepath=$4
  DB_HOST=$(echo "$url" | sed 's/jdbc:postgresql:\/\///' | sed 's/:5432//' | sed 's/\/.*//')
  DB_NAME=$(echo "$url" | sed 's/jdbc:postgresql:\/\///' | sed 's/:5432//' | sed 's/.*\///')

  echo "Connecting to $DB_NAME database at $DB_HOST"

  echo $filepath

  psql "sslmode=require host=${DB_HOST} dbname=${DB_NAME} user=${DB_USER} port=5432 password=${PGPASSWORD}" --file=$filepath
}

event_username=$(cat /mnt/secrets/$KV_NAME/event-datasource-username)
event_password=$(cat /mnt/secrets/$KV_NAME/event-datasource-password)
event_url=$(cat /mnt/secrets/$KV_NAME/event-datasource-url)

runSQL $event_username $event_password $event_url ./sql/public_update_tables_housekeeping.sql

themis_gateway_username=$(cat /mnt/secrets/$KV_NAME/themis-gateway-dbusername)
themis_gateway_password=$(cat /mnt/secrets/$KV_NAME/themis-gateway-dbpassword)
themis_gateway_url=$(cat /mnt/secrets/$KV_NAME/themis-gateway-datasourceurl)

runSQL $themis_gateway_username $themis_gateway_password $themis_gateway_url ./sql/gateway_audit_messages_housekeeping.sql

themis_dac_username=$(cat /mnt/secrets/$KV_NAME/dac-datasource-username)
themis_dac_password=$(cat /mnt/secrets/$KV_NAME/dac-datasource-password)
themis_dac_url=$(cat /mnt/secrets/$KV_NAME/dac-datasource-url)

runSQL $themis_dac_username $themis_dac_password $themis_dac_url ./sql/dac_audit_messages_housekeeping.sql
