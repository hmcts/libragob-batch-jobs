***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***_STATS
***REMOVED***
***REMOVED***
***REMOVED***_STATS
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

# Con***REMOVED***scationDB connection variables
con***REMOVED***scation_username=$(cat /mnt/secrets/$KV_NAME/amd-con***REMOVED***scation-username)
con***REMOVED***scation_password=$(cat /mnt/secrets/$KV_NAME/amd-con***REMOVED***scation-password)
con***REMOVED***scation_url=$(cat /mnt/secrets/$KV_NAME/amd-con***REMOVED***scation-datasource-url)
con***REMOVED***scation_host=`echo $con***REMOVED***scation_url | awk -F"\/\/" {'print $2'} | awk -F":" {'print $1'}`
con***REMOVED***scation_port=`echo $con***REMOVED***scation_url | awk -F":" {'print $4'} | awk -F"\/" {'print $1'}`
con***REMOVED***scation_db=`echo $con***REMOVED***scation_url | awk -F":" {'print $4'} | awk -F"\/" {'print $2'}`

***REMOVED***
***REMOVED***nes_username=$(cat /mnt/secrets/$KV_NAME/amd-***REMOVED***nes-username)
***REMOVED***nes_password=$(cat /mnt/secrets/$KV_NAME/amd-***REMOVED***nes-password)
***REMOVED***nes_url=$(cat /mnt/secrets/$KV_NAME/amd-***REMOVED***nes-datasource-url)
***REMOVED***nes_host=`echo $***REMOVED***nes_url | awk -F"\/\/" {'print $2'} | awk -F":" {'print $1'}`
***REMOVED***nes_port=`echo $***REMOVED***nes_url | awk -F":" {'print $4'} | awk -F"\/" {'print $1'}`
***REMOVED***nes_db=`echo $***REMOVED***nes_url | awk -F":" {'print $4'} | awk -F"\/" {'print $2'}`

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/1AZUREDB_AMD_locked_schemas.sql
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

kubectl con***REMOVED***g use-context ss-prod-00-aks
***REMOVED***
kubectl con***REMOVED***g use-context ss-prod-01-aks
***REMOVED***

***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
  kubectl -n met logs ${hk_hash} --pre***REMOVED***x=true --timestamps=true > ${OPDIR}hk_log
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
      echo "$(date "+%d/%m/%Y %T"),AZDB_housekeeping_completed_logs_error_check_cluster0${cnt},Completed Housekeeping log***REMOVED***le errors found so check POD logs and then report it to the DBAs,warn" >> $OUTFILE
#    ***REMOVED***
#    echo "$(date "+%d/%m/%Y %T"),AZDB_housekeeping_completed_logs_error_check_cluster0${cnt},No Completed Housekeeping log***REMOVED***le errors found,ok" >> $OUTFILE
    ***REMOVED***
  ***REMOVED***
    echo "$(date "+%d/%m/%Y %T"),AZDB_housekeeping_completed_logs_error_check_cluster0${cnt},No Completed Housekeeping log***REMOVED***le found so pls con***REMOVED***rm this and if so reopen JIRA ticket DTSPO-25927 and get HMCTS PlatOps to take a look,warn" >> $OUTFILE
  ***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
#  ***REMOVED***
***REMOVED***
#  ***REMOVED***

***REMOVED***
***REMOVED***
#  ***REMOVED***
***REMOVED***
#  ***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
#  ***REMOVED***
***REMOVED***
#  ***REMOVED***

***REMOVED***
***REMOVED***
#  ***REMOVED***
***REMOVED***
#  ***REMOVED***
#***REMOVED***

***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
#***REMOVED***
***REMOVED***
#***REMOVED***

***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
#***REMOVED***
***REMOVED***
#***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/2AZUREDB_AMD_locked_keys.sql
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***2a
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/12aAZUREDB_AMD_dacaudit_DBstep13-12_latest10_processing_rates.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***2b
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/12bAZUREDB_AMD_dacaudit_step10-1_latest10_processing_rates.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***2c
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/12cAZUREDB_AMD_gwaudit_step10-1_latest10_processing_rates.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/3AZUREDB_AMD_message_backlogs.sql
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/4AZUREDB_AMD_thread_status_counts.sql
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
  ***REMOVED***
***REMOVED***
  ***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
  ***REMOVED***
***REMOVED***
  ***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
  ***REMOVED***
***REMOVED***
  ***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
  ***REMOVED***
***REMOVED***
  ***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/5AZUREDB_AMD_message_log_errors.sql
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
  ***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
  if [[ `***REMOVED*** | grep "$schema_id"` ]];then
***REMOVED***
  ***REMOVED***
    aesd_depth=`***REMOVED*** | grep -P "^${schema_id}," | grep "UNPROCESSED" | awk -F"," '{print $4}' | xargs`
***REMOVED***
***REMOVED***
***REMOVED***
if [[ $aesd_depth -lt 10000 ]];then echo "true";***REMOVED*** echo "false";***REMOVED***
***REMOVED***
if [[ `echo $error_message | grep "AESD-0003"` ]];then echo "true";***REMOVED*** echo "false";***REMOVED***
***REMOVED***
if [[ `echo $error_message | grep "AESD-0004"` ]];then echo "true";***REMOVED*** echo "false";***REMOVED***
***REMOVED***
if [[ `echo $error_message | grep -P "23505.*duplicate key value"` ]];then echo "true";***REMOVED*** echo "false";***REMOVED***
***REMOVED***
***REMOVED***
    ***REMOVED***
  ***REMOVED***
    ***REMOVED***
  ***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/6AZUREDB_AMD_update_processing_backlog.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/7AZUREDB_AMD_max_daily_update_counts_by_schemaid.sql
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/8AZUREDB_AMD_todays_hourly_update_counts.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
echo -e "45\n66\n97\n107\n109\n110\n113\n116" > ${OPDIR}con***REMOVED***scation_mets
echo -e "5\n8\n9\n10\n11\n12\n14\n21\n22\n24\n26\n28\n29\n30\n31\n36\n38\n47\n52\n57\n60\n61\n65\n73\n77\n78\n80\n82\n89\n92\n96\n99\n103\n105\n106\n112\n119\n124\n125\n126\n128\n129\n130\n135\n138\n139" > ${OPDIR}***REMOVED***nes_mets
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
    dbname_str=con***REMOVED***scation

***REMOVED***
***REMOVED***
    ***REMOVED***
***REMOVED***
    ***REMOVED***

***REMOVED***
    psql "sslmode=require host=${con***REMOVED***scation_host} dbname=${con***REMOVED***scation_db} port=${con***REMOVED***scation_port} user=${con***REMOVED***scation_username} password=${con***REMOVED***scation_password}" --***REMOVED***le=/sql/9AZUREDB_AMD_${dbname_str}_recon_result.sql
    psql "sslmode=require host=${con***REMOVED***scation_host} dbname=${con***REMOVED***scation_db} port=${con***REMOVED***scation_port} user=${con***REMOVED***scation_username} password=${con***REMOVED***scation_password}" --***REMOVED***le=/sql/9AZUREDB_AMD_${dbname_str}_recon_errors.sql
    psql "sslmode=require host=${con***REMOVED***scation_host} dbname=${con***REMOVED***scation_db} port=${con***REMOVED***scation_port} user=${con***REMOVED***scation_username} password=${con***REMOVED***scation_password}" --***REMOVED***le=/sql/9AZUREDB_AMD_${dbname_str}_recon_result_by_met.sql
***REMOVED***
***REMOVED***
    dbname_str=***REMOVED***nes

***REMOVED***
***REMOVED***
    ***REMOVED***
***REMOVED***
    ***REMOVED***

***REMOVED***
    psql "sslmode=require host=${***REMOVED***nes_host} dbname=${***REMOVED***nes_db} port=${***REMOVED***nes_port} user=${***REMOVED***nes_username} password=${***REMOVED***nes_password}" --***REMOVED***le=/sql/9AZUREDB_AMD_${dbname_str}_recon_result.sql
    psql "sslmode=require host=${***REMOVED***nes_host} dbname=${***REMOVED***nes_db} port=${***REMOVED***nes_port} user=${***REMOVED***nes_username} password=${***REMOVED***nes_password}" --***REMOVED***le=/sql/9AZUREDB_AMD_${dbname_str}_recon_errors.sql
    psql "sslmode=require host=${***REMOVED***nes_host} dbname=${***REMOVED***nes_db} port=${***REMOVED***nes_port} user=${***REMOVED***nes_username} password=${***REMOVED***nes_password}" --***REMOVED***le=/sql/9AZUREDB_AMD_${dbname_str}_recon_result_by_met.sql
***REMOVED***
  ***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
    ***REMOVED***
***REMOVED***
    ***REMOVED***

***REMOVED***
    psql "sslmode=require host=${maintenance_host} dbname=${maintenance_db} port=${maintenance_port} user=${maintenance_username} password=${maintenance_password}" --***REMOVED***le=/sql/9AZUREDB_AMD_${dbname_str}_recon_result.sql
    psql "sslmode=require host=${maintenance_host} dbname=${maintenance_db} port=${maintenance_port} user=${maintenance_username} password=${maintenance_password}" --***REMOVED***le=/sql/9AZUREDB_AMD_${dbname_str}_recon_errors.sql
    psql "sslmode=require host=${maintenance_host} dbname=${maintenance_db} port=${maintenance_port} user=${maintenance_username} password=${maintenance_password}" --***REMOVED***le=/sql/9AZUREDB_AMD_${dbname_str}_recon_result_by_met.sql
***REMOVED***
  ***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
        ***REMOVED***
***REMOVED***
        ***REMOVED***
      ***REMOVED***
***REMOVED***
      ***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***

***REMOVED***
  if [[ ! `cat ${OPDIR}9AZUREDB_AMD_con***REMOVED***scation_recon_result_by_met.csv | grep ",$met,$op_date"` ]] && [[ ! `cat ${OPDIR}9AZUREDB_AMD_con***REMOVED***scation_recon_result_by_met.csv | grep ",$met,$op_date1"` ]] && [[ ! `cat ${OPDIR}9AZUREDB_AMD_con***REMOVED***scation_recon_result_by_met.csv | grep ",$met,$op_date2"` ]] && [[ ! `cat ${OPDIR}9AZUREDB_AMD_con***REMOVED***scation_recon_result_by_met.csv | grep ",$met,$op_date3"` ]];then
***REMOVED***
***REMOVED***
  elif [[ `cat ${OPDIR}9AZUREDB_AMD_con***REMOVED***scation_recon_errors.csv | grep ",$met,$op_date"` ]] && [[ `cat ${OPDIR}9AZUREDB_AMD_con***REMOVED***scation_recon_errors.csv | grep ",$met,$op_date1"` ]] && [[ `cat ${OPDIR}9AZUREDB_AMD_con***REMOVED***scation_recon_errors.csv | grep ",$met,$op_date2"` ]] && [[ `cat ${OPDIR}9AZUREDB_AMD_con***REMOVED***scation_recon_errors.csv | grep ",$met,$op_date3"` ]];then
***REMOVED***
***REMOVED***
  ***REMOVED***
***REMOVED*** < ${OPDIR}con***REMOVED***scation_mets

***REMOVED***
  echo "$(date "+%d/%m/%Y %T"),AZDB_con***REMOVED***scation_recon_status,Check rec history by means of the last query of Check #9 on JBOX in C:\Libra\MarkP\sql.txt: $met_no_good_result_list,warn" >> $OUTFILE
***REMOVED***
  echo "$(date "+%d/%m/%Y %T"),AZDB_con***REMOVED***scation_recon_status,Check rec history by means of the last query of Check #9 on JBOX in C:\Libra\MarkP\sql.txt: $met_recon_errors_list,warn" >> $OUTFILE
***REMOVED***
  echo "$(date "+%d/%m/%Y %T"),AZDB_con***REMOVED***scation_recon_status,All METs have seen a successful rec in the last 4 days,ok" >> $OUTFILE
***REMOVED***

***REMOVED***
***REMOVED***

***REMOVED***
  echo "cat of 9AZUREDB_AMD_***REMOVED***nes_recon_result_by_met.csv:"
  head -1000 ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_result_by_met.csv
  echo "cat of 9AZUREDB_AMD_***REMOVED***nes_recon_errors.csv:"
  cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_errors.csv
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
      cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_result_by_met.csv | grep ",$met,$op_date"
***REMOVED***
      cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_result_by_met.csv | grep ",$met,$op_date1"
***REMOVED***
      cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_result_by_met.csv | grep ",$met,$op_date2"
***REMOVED***
      cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_result_by_met.csv | grep ",$met,$op_date3"
***REMOVED***
      cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_errors.csv | grep ",$met,$op_date"
***REMOVED***
      cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_errors.csv | grep ",$met,$op_date1"
***REMOVED***
      cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_errors.csv | grep ",$met,$op_date2"
***REMOVED***
      cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_errors.csv | grep ",$met,$op_date3"
    ***REMOVED***
  ***REMOVED***

  if [[ ! `cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_result_by_met.csv | grep ",$met,$op_date"` ]] && [[ ! `cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_result_by_met.csv | grep ",$met,$op_date1"` ]] && [[ ! `cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_result_by_met.csv | grep ",$met,$op_date2"` ]] && [[ ! `cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_result_by_met.csv | grep ",$met,$op_date3"` ]];then
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
    ***REMOVED***
  elif [[ `cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_errors.csv | grep ",$met,$op_date"` ]] && [[ `cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_errors.csv | grep ",$met,$op_date1"` ]] && [[ `cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_errors.csv | grep ",$met,$op_date2"` ]] && [[ `cat ${OPDIR}9AZUREDB_AMD_***REMOVED***nes_recon_errors.csv | grep ",$met,$op_date3"` ]];then
***REMOVED***
***REMOVED***
  ***REMOVED***
***REMOVED*** < ${OPDIR}***REMOVED***nes_mets

***REMOVED***
  echo "$(date "+%d/%m/%Y %T"),AZDB_***REMOVED***nes_recon_status,Check rec history by means of the last query of Check #9 on JBOX in C:\Libra\MarkP\sql.txt: $met_no_good_result_list,warn" >> $OUTFILE
***REMOVED***
  echo "$(date "+%d/%m/%Y %T"),AZDB_***REMOVED***nes_recon_status,Check rec history by means of the last query of Check #9 on JBOX in C:\Libra\MarkP\sql.txt: $met_recon_errors_list,warn" >> $OUTFILE
***REMOVED***
  echo "$(date "+%d/%m/%Y %T"),AZDB_***REMOVED***nes_recon_status,All METs have seen a successful rec in the last 4 days,ok" >> $OUTFILE
***REMOVED***

***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
  ***REMOVED***
***REMOVED*** < ${OPDIR}maintenance_mets

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***0
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***1
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***00
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/11aAZUREDB_AMD_row_counts_update_requests.sql
***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/11bAZUREDB_AMD_row_counts_table_updates.sql
***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/11cAZUREDB_AMD_row_counts_message_log.sql
***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/11dAZUREDB_AMD_row_counts_DAC_message_audit.sql
***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/11eAZUREDB_AMD_row_counts_GW_message_audit.sql
***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***2d - 12r, remaining stats
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/12dAZUREDB_AMD_dacaudit_DBstep13-12_avgDailyRT.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}12dAZUREDB_AMD_dacaudit_DBstep13-12_avgDailyRT.csv
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/12eAZUREDB_AMD_dacaudit_step10-1_avgDailyRT.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}12eAZUREDB_AMD_dacaudit_step10-1_avgDailyRT.csv
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/12fAZUREDB_AMD_gwaudit_step10-1_avgDailyRT.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}12fAZUREDB_AMD_gwaudit_step10-1_avgDailyRT.csv
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/12gAZUREDB_AMD_dacaudit_DBstep13-12_avgHourlyRT.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}12gAZUREDB_AMD_dacaudit_DBstep13-12_avgHourlyRT.csv
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/12hAZUREDB_AMD_dacaudit_DBstep13-12_avgMinuteRT.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}12hAZUREDB_AMD_dacaudit_DBstep13-12_avgMinuteRT.csv
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/12iAZUREDB_AMD_dacaudit_DBstep10-1_avgHourlyRT.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}12iAZUREDB_AMD_dacaudit_DBstep10-1_avgHourlyRT.csv
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/12jAZUREDB_AMD_dacaudit_DBstep10-1_avgMinuteRT.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}12jAZUREDB_AMD_dacaudit_DBstep10-1_avgMinuteRT.csv
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/12kAZUREDB_AMD_gwaudit_step10-1_avgHourlyRT.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}12kAZUREDB_AMD_gwaudit_step10-1_avgHourlyRT.csv
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/12lAZUREDB_AMD_gwaudit_step10-1_avgMinuteRT.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}12lAZUREDB_AMD_gwaudit_step10-1_avgMinuteRT.csv
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/12mAZUREDB_AMD_daily_completed_update_request_counts.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}12mAZUREDB_AMD_daily_completed_update_request_counts.csv
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/12nAZUREDB_AMD_daily_completed_table_updates_counts.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}12nAZUREDB_AMD_daily_completed_table_updates_counts.csv
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/12oAZUREDB_AMD_hourly_completed_update_request_counts.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}12oAZUREDB_AMD_hourly_completed_update_request_counts.csv
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/12pAZUREDB_AMD_hourly_completed_table_updates_counts.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}12pAZUREDB_AMD_hourly_completed_table_updates_counts.csv
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/12qAZUREDB_AMD_minute_completed_update_request_counts.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}12qAZUREDB_AMD_minute_completed_update_request_counts.csv
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/12rAZUREDB_AMD_minute_completed_table_updates_counts.sql
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}12rAZUREDB_AMD_minute_completed_table_updates_counts.csv

***REMOVED***
***REMOVED***2
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/12AZUREDB_AMD_ora_rowscn_bug_seq_nums.sql
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
  echo "$(date "+%d/%m/%Y %T") SQL for Check #12 for duplicate sequence number ***REMOVED***x is about to be run: call ***REMOVED***x_duplicate_seq_nos()" >> $OUTFILE_LOG
#  psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/12AZUREDB_AMD_ora_rowscn_bug_seq_nums_***REMOVED***x.sql --echo-queries
  psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" -c 'call ***REMOVED***x_duplicate_seq_nos()' -e
***REMOVED***
#ls -altr ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums_***REMOVED***x.csv
***REMOVED***
***REMOVED***
#echo "cat of 12AZUREDB_AMD_ora_rowscn_bug_seq_nums_***REMOVED***x.csv:" >> $OUTFILE_LOG
#cat ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums_***REMOVED***x.csv >> $OUTFILE_LOG
***REMOVED***
    echo "$(date "+%d/%m/%Y %T") SQL for Check #12 for duplicate sequence number ***REMOVED***x has been run without errors: call ***REMOVED***x_duplicate_seq_nos()" >> $OUTFILE_LOG
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
      echo "$(date "+%d/%m/%Y %T"),AZDB_call_***REMOVED***x_duplicate_seq_nos(),RowsCleared=${dupe_seq_nums_linecount},linecount_threshold=GT${linecount_threshold},Runtime=${check12_sp_runtime_secs}secs,runtime_threshold=GT${runtime_threshold},,warn" >> $OUTFILE
#    ***REMOVED***
#      echo "$(date "+%d/%m/%Y %T"),AZDB_call_***REMOVED***x_duplicate_seq_nos(),RowsCleared=${dupe_seq_nums_linecount},linecount_threshold=GT${linecount_threshold},Runtime=${check12_sp_runtime_secs}secs,runtime_threshold=GT${runtime_threshold},,ok" >> $OUTFILE
    ***REMOVED***

***REMOVED***
#    psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --***REMOVED***le=/sql/12AZUREDB_AMD_ora_rowscn_bug_seq_nums.sql --echo-queries
    psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" -c 'call ***REMOVED***x_duplicate_seq_nos()' -e
***REMOVED***
    echo "cat of 12AZUREDB_AMD_ora_rowscn_bug_seq_nums_***REMOVED***x.csv:" >> $OUTFILE_LOG
    cat ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums_***REMOVED***x.csv >> $OUTFILE_LOG
    ***REMOVED***
    echo "$(date "+%d/%m/%Y %T"),AZDB_call_***REMOVED***x_duplicate_seq_nos(),NewRowsAfterCleardown=${dupe_seq_nums_linecount},,,,,ok" >> $OUTFILE
***REMOVED***
#ls -altr ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums_***REMOVED***x.csv
#  ***REMOVED***
#    echo "cat of 12AZUREDB_AMD_ora_rowscn_bug_seq_nums_***REMOVED***x.csv:" >> $OUTFILE_LOG
#    cat ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums_***REMOVED***x.csv >> $OUTFILE_LOG
***REMOVED***
#ls -altr ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums_***REMOVED***x.csv
#    echo "$(date "+%d/%m/%Y %T"),AZDB_call_***REMOVED***x_duplicate_seq_nos(),SQL for Check #12 for duplicate sequence number ***REMOVED***x has been run with errors so check the log***REMOVED***le,RowsToClear=${dupe_seq_nums_linecount},,,,warn" >> $OUTFILE
#  ***REMOVED***
***REMOVED***
  echo "$(date "+%d/%m/%Y %T") No duplicate sequence numbers have been found in Check #12 so the ***REMOVED***x SP hasn't been run" >> $OUTFILE_LOG
#  echo "$(date "+%d/%m/%Y %T"),AZDB_call_***REMOVED***x_duplicate_seq_nos(),No duplicate sequence numbers found so the ***REMOVED***x SP hasn't been run,dupe_seq_nums_linecount=${dupe_seq_nums_linecount},,,,ok" >> $OUTFILE
***REMOVED***
#***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED*** < ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums.csv

***REMOVED***
***REMOVED***3
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --***REMOVED***le=/sql/13AZUREDB_AMD_message_audit_id_INT_out_of_range.sql
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED*** < ${OPDIR}13AZUREDB_AMD_message_audit_id_INT_out_of_range.csv

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
cp $OUTFILE $OUTFILE.orig ### creates a copy of the current output ***REMOVED***le
override_***REMOVED***le=${OPDIR}ams-reporting_overrides_list.dat

***REMOVED***

***REMOVED***

***REMOVED***

echo "03/01/2025.*AZDB_db_message_log_error77.*duplicate" >> $override_***REMOVED***le

echo "06/01/2025.*AZDB_update_processing_backlog77" >> $override_***REMOVED***le
echo "06/01/2025.*AZDB_db_message_log_error77.*23505.*duplicate key value violates unique constraint" >> $override_***REMOVED***le

echo "07/01/2025.*AZDB_update_processing_backlog77" >> $override_***REMOVED***le

echo "16/01/2025.*AZDB_db_message_log_error(105|106).*23505.*duplicate key value violates unique constraint.*update_requests_pk" >> $override_***REMOVED***le

echo "17/01/2025.*AZDB_update_processing_backlog38" >> $override_***REMOVED***le

echo "31/01/2025.*AZDB_update_processing_backlog77" >> $override_***REMOVED***le
echo "31/01/2025.*AZDB_update_processing_backlog82" >> $override_***REMOVED***le

echo "19/02/2025.*AZDB_update_processing_backlog82" >> $override_***REMOVED***le

echo "19/02/2025.*AZDB_db_message_log_error82.*AESD-0003 : The previous update request id for which the next available update request id should follow has not ***REMOVED***nished processing" >> $override_***REMOVED***le

echo "20/02/2025.*AZDB_update_processing_backlog82" >> $override_***REMOVED***le

echo "26/02/2025.*AZDB_update_processing_backlog82" >> $override_***REMOVED***le

echo "12/03/2025.*AZDB_update_processing_backlog135" >> $override_***REMOVED***le

echo "13/03/2025.*AZDB_update_processing_backlog105" >> $override_***REMOVED***le

echo "13/03/2025.*AZDB_update_processing_backlog10" >> $override_***REMOVED***le

echo "13/03/2025.*AZDB_update_processing_backlog52" >> $override_***REMOVED***le

echo "13/03/2025.*AZDB_db_message_log_error5.*AESD-0003 : The previous update request id for which the next available update request id should follow has not ***REMOVED***nished processing" >> $override_***REMOVED***le

echo "13/03/2025.*AZDB_db_message_log_error47.*AESD-0003 : The previous update request id for which the next available update request id should follow has not ***REMOVED***nished processing" >> $override_***REMOVED***le

echo "13/03/2025.*AZDB_db_message_log_error52.*AESD-0003 : The previous update request id for which the next available update request id should follow has not ***REMOVED***nished processing" >> $override_***REMOVED***le

echo "14/03/2025.*AZDB_update_processing_backlog5" >> $override_***REMOVED***le

echo "14/03/2025.*AZDB_update_processing_backlog47" >> $override_***REMOVED***le

echo "14/03/2025.*AZDB_update_processing_backlog52" >> $override_***REMOVED***le

***REMOVED***
echo "27/03/2025.*AZDB_update_processing_backlog77" >> $override_***REMOVED***le
echo "27/03/2025.*AZDB_msg_backlog77" >> $override_***REMOVED***le

echo "28/03/2025.*AZDB_update_processing_backlog77" >> $override_***REMOVED***le

echo "31/03/2025.*AZDB_update_processing_backlog77" >> $override_***REMOVED***le
echo "31/03/2025.*AZDB_msg_backlog77" >> $override_***REMOVED***le
echo "31/03/2025.*AZDB_msg_backlog103" >> $override_***REMOVED***le
echo "31/03/2025.*AZDB_msg_backlog12" >> $override_***REMOVED***le
echo "31/03/2025.*AZDB_update_processing_backlog44" >> $override_***REMOVED***le
echo "31/03/2025.*AZDB_update_processing_backlog103" >> $override_***REMOVED***le
echo "31/03/2025.*AZDB_update_processing_backlog12" >> $override_***REMOVED***le
echo "31/03/2025.*AZDB_update_processing_backlog99" >> $override_***REMOVED***le
echo "31/03/2025.*AZDB_update_processing_backlog105" >> $override_***REMOVED***le

echo "01/04/2025.*AZDB_update_processing_backlog130" >> $override_***REMOVED***le

echo "08/04/2025.*AZDB_update_processing_backlog126" >> $override_***REMOVED***le

echo "09/04/2025.*AZDB_update_processing_backlog96" >> $override_***REMOVED***le
echo "09/04/2025.*AZDB_update_processing_backlog135" >> $override_***REMOVED***le
echo "09/04/2025.*AZDB_update_processing_backlog103" >> $override_***REMOVED***le

echo "10/04/2025.*AZDB_update_processing_backlog135" >> $override_***REMOVED***le

echo "11/04/2025.*AZDB_***REMOVED***nes_recon_status" >> $override_***REMOVED***le

echo "14/04/2025.*AZDB_***REMOVED***nes_recon_status" >> $override_***REMOVED***le
echo "14/04/2025.*AZDB_msg_backlog31" >> $override_***REMOVED***le
echo "15/04/2025.*AZDB_***REMOVED***nes_recon_status" >> $override_***REMOVED***le
echo "16/04/2025.*AZDB_***REMOVED***nes_recon_status" >> $override_***REMOVED***le
echo "22/04/2025.*AZDB_***REMOVED***nes_recon_status" >> $override_***REMOVED***le
echo "04/06/2025.*AZDB_***REMOVED***nes_recon_status" >> $override_***REMOVED***le
echo "05/06/2025.*AZDB_***REMOVED***nes_recon_status" >> $override_***REMOVED***le
echo "06/06/2025.*AZDB_***REMOVED***nes_recon_status" >> $override_***REMOVED***le
echo "09/06/2025.*AZDB_***REMOVED***nes_recon_status" >> $override_***REMOVED***le


echo "17/04/2025.*AZDB_update_processing_backlog77" >> $override_***REMOVED***le

echo "22/04/2025.*AZDB_update_processing_backlog77" >> $override_***REMOVED***le

echo "25/04/2025.*AZDB_db_message_log_error77.*23505.*duplicate key value violates unique constraint." >> $override_***REMOVED***le
echo "25/04/2025.*AZDB_update_processing_backlog77" >> $override_***REMOVED***le

echo "29/04/2025.*AZDB_update_processing_backlog30" >> $override_***REMOVED***le
echo "29/04/2025.*AZDB_db_message_log_error77.*23505.*duplicate key value violates unique constraint" >> $override_***REMOVED***le

echo "30/04/2025.*AZDB_update_processing_backlog77" >> $override_***REMOVED***le

echo "02/05/2025.*AZDB_***REMOVED***nes_recon_status" >> $override_***REMOVED***le
echo "06/05/2025.*AZDB_***REMOVED***nes_recon_status" >> $override_***REMOVED***le
echo "07/05/2025.*AZDB_***REMOVED***nes_recon_status" >> $override_***REMOVED***le

echo "09/05/2025.*AZDB_housekeeping_completed_logs_error_check_cluster00" >> $override_***REMOVED***le

echo "12/05/2025.*AZDB_db_threads.*active" >> $override_***REMOVED***le

echo "AZDB_housekeeping_completed_logs_error_check_cluster00" >> $override_***REMOVED***le

echo "23/05/2025.*AZDB_update_processing_backlog77" >> $override_***REMOVED***le

echo "03/06/2025.*AZDB_***REMOVED***nes_recon_status" >> $override_***REMOVED***le

***REMOVED***

testit=`cat $override_***REMOVED***le | wc -l | xargs`

***REMOVED***

***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
      ***REMOVED***
    ***REMOVED***
  ***REMOVED*** < $override_***REMOVED***le

***REMOVED***
***REMOVED***
  ***REMOVED***
***REMOVED*** < $OUTFILE.orig

***REMOVED***

***REMOVED***
***REMOVED******REMOVED******REMOVED***################
### Push CSV ***REMOVED***le to BAIS so it can be ingested and displayed in the AMD ###
***REMOVED******REMOVED******REMOVED***################
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED*** | sed 's/ /\n/g' > /tmp/ams-reporting/sftp-pvt-key.tmp
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED*** | sed 's/[\t ]//g;/^$/d' > /tmp/ams-reporting/sftp-pvt-key
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
echo "con***REMOVED***scation_username: $con***REMOVED***scation_username" >> $OUTFILE_LOG
echo "***REMOVED***nes_username: $***REMOVED***nes_username" >> $OUTFILE_LOG
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***_STATS
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***

***REMOVED***

***REMOVED***

***REMOVED***
***REMOVED***4
echo "[Check #14: Critical Log***REMOVED***le Errors]" >> $OUTFILE
***REMOVED***
***REMOVED***

***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED******REMOVED******REMOVED***### Script END ***REMOVED******REMOVED******REMOVED***###
***REMOVED***
***REMOVED***
***REMOVED***
***REMOVED***_STATS
***REMOVED***
***REMOVED***_LOG