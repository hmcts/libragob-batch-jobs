#!/usr/bin/env bash
############################################################### This is the AMD AzureDB HealthCheck script, and the associated documentation is in Ensemble under the "Libra System Admin Documents" area:
############################################################### "GoB Phase 1 - Oracle_Postgres DB Checks_v11.9_MAP.docx" is the latest version as of 27/02/2025
echo "Script Version 26.7 Check #3 Tier5 #6 128 Tier5"
echo "Designed by Mark A. Porter"

if [[ `echo $KV_NAME | grep "test"` ]];then
op_env=test
else
op_env=prod
fi

OPDIR="/tmp/ams-reporting/"
mkdir $OPDIR
OUTFILE="${OPDIR}ThemisAZ_hc.csv"
OUTFILE_STATS="${OPDIR}ThemisAZ_stats.csv"
OUTFILE_LOG="${OPDIR}ThemisAZ.log"
#echo $(date "+%d/%m/%Y %T") > $OUTFILE
#echo $(date "+%d/%m/%Y %T") > $OUTFILE_STATS
##### BST Fix
echo $(date "+%d/%m/%Y %T" -d "+1 hours")  > $OUTFILE
echo $(date "+%d/%m/%Y %T" -d "+1 hours")  > $OUTFILE_STATS
############################################################### Set-up DB connection variables, extracted from KeyVault
# EventDB connection variables
event_username=$(cat /mnt/secrets/$KV_NAME/amd-event-username)
event_password=$(cat /mnt/secrets/$KV_NAME/amd-event-password)
event_url=$(cat /mnt/secrets/$KV_NAME/amd-event-datasource-url)
event_host=`echo $event_url | awk -F"\/\/" {'print $2'} | awk -F":" {'print $1'}`
event_port=`echo $event_url | awk -F":" {'print $4'} | awk -F"\/" {'print $1'}`
event_db=`echo $event_url | awk -F":" {'print $4'} | awk -F"\/" {'print $2'}`

# PostgresDB connection variables
postgres_username=`cat /mnt/secrets/$KV_NAME/amd-postgres-username`
postgres_password=`cat /mnt/secrets/$KV_NAME/amd-postgres-password`
postgres_url=`cat /mnt/secrets/$KV_NAME/amd-postgres-datasource-url`
postgres_host=`echo $postgres_url | awk -F"\/\/" {'print $2'} | awk -F":" {'print $1'}`
postgres_port=`echo $postgres_url | awk -F":" {'print $4'} | awk -F"\/" {'print $1'}`
postgres_db=`echo $postgres_url | awk -F":" {'print $4'} | awk -F"\/" {'print $2'}`

# ConfiscationDB connection variables
confiscation_username=$(cat /mnt/secrets/$KV_NAME/amd-confiscation-username)
confiscation_password=$(cat /mnt/secrets/$KV_NAME/amd-confiscation-password)
confiscation_url=$(cat /mnt/secrets/$KV_NAME/amd-confiscation-datasource-url)
confiscation_host=`echo $confiscation_url | awk -F"\/\/" {'print $2'} | awk -F":" {'print $1'}`
confiscation_port=`echo $confiscation_url | awk -F":" {'print $4'} | awk -F"\/" {'print $1'}`
confiscation_db=`echo $confiscation_url | awk -F":" {'print $4'} | awk -F"\/" {'print $2'}`

# FinesDB connection variables
fines_username=$(cat /mnt/secrets/$KV_NAME/amd-fines-username)
fines_password=$(cat /mnt/secrets/$KV_NAME/amd-fines-password)
fines_url=$(cat /mnt/secrets/$KV_NAME/amd-fines-datasource-url)
fines_host=`echo $fines_url | awk -F"\/\/" {'print $2'} | awk -F":" {'print $1'}`
fines_port=`echo $fines_url | awk -F":" {'print $4'} | awk -F"\/" {'print $1'}`
fines_db=`echo $fines_url | awk -F":" {'print $4'} | awk -F"\/" {'print $2'}`

# MaintenanceDB connection variables
maintenance_username=$(cat /mnt/secrets/$KV_NAME/amd-maintenance-username)
maintenance_password=$(cat /mnt/secrets/$KV_NAME/amd-maintenance-password)
maintenance_url=$(cat /mnt/secrets/$KV_NAME/amd-maintenance-datasource-url)
maintenance_host=`echo $maintenance_url | awk -F"\/\/" {'print $2'} | awk -F":" {'print $1'}`
maintenance_port=`echo $maintenance_url | awk -F":" {'print $4'} | awk -F"\/" {'print $1'}`
maintenance_db=`echo $maintenance_url | awk -F":" {'print $4'} | awk -F"\/" {'print $2'}`
####################################################### CHECK 1
echo "[Check #1: Locked Schemas]" >> $OUTFILE
echo "DateTime,CheckName,Status,Result" >> $OUTFILE
echo "$(date "+%d/%m/%Y %T") Starting Check #1" > $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/1AZUREDB_AMD_locked_schemas.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #1 has been run" >> $OUTFILE_LOG

if [[ `cat ${OPDIR}1AZUREDB_AMD_locked_schemas.csv | wc -l` -gt 0 ]];then
  while read -r line;do
    schema_lock=`echo $line | awk '{print $1}'`
    echo "$(date "+%d/%m/%Y %T"),AZDB_schema_lock,SchemaId $schema_lock is locked,warn" >> $OUTFILE
  done < ${OPDIR}1AZUREDB_AMD_locked_schemas.csv
fi

echo "$(date "+%d/%m/%Y %T") Check #1 complete" >> $OUTFILE_LOG

kubectl config use-context ss-prod-00-aks
kubectl get pods -n met > ${OPDIR}pod_list00
kubectl config use-context ss-prod-01-aks
kubectl get pods -n met > ${OPDIR}pod_list01

cnt=0
#day_today=$(date "+%a")

#for loop in 1 2;do

#echo "POD Status Cluster0${cnt},,," >> $OUTFILE

#while read -r line;do
#  name_hash=`echo $line | awk -F" " '{print $1}'`
#  ready=`echo $line | awk -F" " '{print $2}'`
#  status=`echo $line | awk -F" " '{print $3}'`
#  restarts=`echo $line | awk -F" " '{print $4}'`
#  age=`echo $line | awk -F" " '{print $5}'`
#  echo "$(date "+%d/%m/%Y %T"),AZDB_pod_status_cluster0${cnt},${name_hash} ${ready} ${status} ${restarts} ${age},ok" >> $OUTFILE
#done < ${OPDIR}pod_list0${cnt}

#if [[ $cnt == 0 ]];then
  hk_hash=`grep -P "housekeeping.*0/1.*Completed" ${OPDIR}pod_list0${cnt} | tail -1 | awk '{print $1}'`
  kubectl -n met logs ${hk_hash} --prefix=true --timestamps=true > ${OPDIR}hk_log
#  echo "pod/libragob-batch-housekeeping-job-29116500-ct994/libragob-batch-housekeeping-job] 2025-05-11T19:20:17.641998692Z DELETE 33280" > ${OPDIR}hk_log
  echo "cat of hk_log:"
  cat ${OPDIR}hk_log

  if [[ `cat ${OPDIR}hk_log | wc -l` -gt 0 ]];then
    if [[ `grep -Pi "(error|warn|exception|severe|fatal|crit|fail|ORA-|time.*out|out.*of.*memory)" ${OPDIR}hk_log` ]];then
      echo "$(date "+%d/%m/%Y %T"),AZDB_housekeeping_completed_logs_error_check_cluster0${cnt},Completed Housekeeping logfile errors found so check POD logs and then report it to the DBAs,warn" >> $OUTFILE
#    else
#    echo "$(date "+%d/%m/%Y %T"),AZDB_housekeeping_completed_logs_error_check_cluster0${cnt},No Completed Housekeeping logfile errors found,ok" >> $OUTFILE
    fi
#  else
#    echo "$(date "+%d/%m/%Y %T"),AZDB_housekeeping_completed_logs_error_check_cluster0${cnt},No Completed Housekeeping logfile found so pls confirm this and if so reopen JIRA ticket DTSPO-25927 and get HMCTS PlatOps to take a look,warn" >> $OUTFILE
  fi
  
#  cnt_hk_logs=`grep -P "housekeeping.*0/1.*Completed" ${OPDIR}pod_list0${cnt} | wc -l`

#  if [[ $op_env == prod ]];then
#    hk_logs_threshold=3
#  else
#    hk_logs_threshold=0
#  fi

#  if [[ $cnt_hk_logs == $hk_logs_threshold ]] || [[ $day_today == Mon ]] || [[ $day_today == Tue ]];then
#    echo "$(date "+%d/%m/%Y %T"),AZDB_housekeeping_completed_logs_count_cluster0${cnt},${cnt_hk_logs}/${hk_logs_threshold} Housekeeping Completed logs found,ok" >> $OUTFILE
#  else
#    echo "$(date "+%d/%m/%Y %T"),AZDB_housekeeping_completed_logs_count_cluster0${cnt},${cnt_hk_logs}/${hk_logs_threshold} Unexpected number of Housekeeping Completed logs found so reopen JIRA ticket DTSPO-25927 and get HMCTS PlatOps to take a look,warn" >> $OUTFILE
#  fi

#  cnt_amd_logs_completed=`grep -P "ams-reporting.*0/1.*Completed" ${OPDIR}pod_list0${cnt} | wc -l`
#  cnt_amd_logs_running=`grep -P "ams-reporting.*1/1.*Running" ${OPDIR}pod_list0${cnt} | wc -l`
#  cnt_amd_logs_completed_threshold=3
#  cnt_amd_logs_running_threshold=1

#  if [[ $cnt_amd_logs_completed == $cnt_amd_logs_completed_threshold ]];then
#    echo "$(date "+%d/%m/%Y %T"),AZDB_amd_completed_logs_count_cluster0${cnt},${cnt_amd_logs_completed}/${cnt_amd_logs_completed_threshold} AMD Completed logs found,ok" >> $OUTFILE
#  else
#    echo "$(date "+%d/%m/%Y %T"),AZDB_amd_completed_logs_count_cluster0${cnt},${cnt_amd_logs_completed}/${cnt_amd_logs_completed_threshold} Unexpected number of AMD Completed logs found so reopen JIRA ticket DTSPO-25927 and get HMCTS PlatOps to take a look,warn" >> $OUTFILE
#  fi

#  if [[ $cnt_amd_logs_running -le $cnt_amd_logs_running_threshold ]];then
#    echo "$(date "+%d/%m/%Y %T"),AZDB_amd_running_logs_count_cluster0${cnt},${cnt_amd_logs_running}/${cnt_amd_logs_running_threshold} AMD Running logs found,ok" >> $OUTFILE
#  else
#    echo "$(date "+%d/%m/%Y %T"),AZDB_amd_running_logs_count_cluster0${cnt},${cnt_amd_logs_running}/${cnt_amd_logs_running_threshold} Unexpected number of AMD Running logs found so reopen JIRA ticket DTSPO-25927 and get HMCTS PlatOps to take a look,warn" >> $OUTFILE
#  fi
#fi

#cnt_pod_bounce=`grep -P "pod-delete.*0/1.*Completed" ${OPDIR}pod_list0${cnt} | wc -l`
#cnt_pod_bounce_threshold=3

#if [[ $cnt_pod_bounce == $cnt_pod_bounce_threshold ]] || [[ $day_today == Mon ]] || [[ $day_today == Tue ]];then
#  echo "$(date "+%d/%m/%Y %T"),AZDB_pod_bounce_completed_logs_count_cluster0${cnt},${cnt_pod_bounce}/${cnt_pod_bounce_threshold} Completed POD bounce logs found,ok" >> $OUTFILE
#else
#  echo "$(date "+%d/%m/%Y %T"),AZDB_pod_bounce_completed_logs_count_cluster0${cnt},${cnt_pod_bounce}/${cnt_pod_bounce_threshold} Unexpected number of Completed POD bounce logs found so reopen JIRA ticket DTSPO-25927 and get HMCTS PlatOps to take a look,warn" >> $OUTFILE
#fi

#cnt_pod_nodejs=`grep -P "nodejs.*1/1.*Running" ${OPDIR}pod_list0${cnt} | wc -l`
#cnt_pod_nodejs_threshold=10

#if [[ $cnt_pod_nodejs == $cnt_pod_nodejs_threshold ]];then
#  echo "$(date "+%d/%m/%Y %T"),AZDB_nodejs_running_logs_count_cluster0${cnt},${cnt_pod_nodejs}/${cnt_pod_nodejs_threshold} Running NodeJS POD logs found,ok" >> $OUTFILE
#else
#  echo "$(date "+%d/%m/%Y %T"),AZDB_nodejs_running_logs_count_cluster0${cnt},${cnt_pod_nodejs}/${cnt_pod_nodejs_threshold} Unexpected number of Running NodeJS POD bounce logs found so reopen JIRA ticket DTSPO-25927 and get HMCTS PlatOps to take a look,warn" >> $OUTFILE
#fi

#cnt=$((cnt+1))

#done
####################################################### CHECK 2
echo "[Check #2: Locked Instance Keys]" >> $OUTFILE
echo "DateTime,CheckName,Status,Result" >> $OUTFILE
echo "$(date "+%d/%m/%Y %T") Starting Check #2" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/2AZUREDB_AMD_locked_keys.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #2 has been run" >> $OUTFILE_LOG

if [[ `cat ${OPDIR}2AZUREDB_AMD_locked_keys.csv | wc -l` -gt 0 ]];then
  while read -r line;do
    key_lock=`echo $line | awk '{print $1}'`
    echo "$(date "+%d/%m/%Y %T"),AZDB_key_lock,Instance Key $key_lock is locked,warn" >> $OUTFILE
  done < ${OPDIR}2AZUREDB_AMD_locked_keys.csv
fi

echo "$(date "+%d/%m/%Y %T") Check #2 complete" >> $OUTFILE_LOG
### Calc the 3 roundtrip ETAs from dac & gw audit tables for purpose of determining the DeliveryTime of each Schema backlog in Check #3
####################################################### CHECK 12a
echo "[Check #12a: Today's Latest 10 DACAudit DB Roundtrip Deltas Step 13-12]" >> $OUTFILE_STATS
echo "DateTime,CheckName,updated_date,uuid,Roundtrip in Millisecs,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12a" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/12aAZUREDB_AMD_dacaudit_DBstep13-12_latest10_processing_rates.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12a has been run" >> $OUTFILE_LOG

while read -r line;do

updated_date=`echo $line | awk -F"," '{print $1}'`
uuid=`echo $line | awk -F"," '{print $2}'`
roundtrip=`echo $line | awk -F"," '{print $3}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_dacaudit_db_10_proc_rates,$updated_date,$uuid,$roundtrip,ok" >> $OUTFILE_STATS

done < ${OPDIR}12aAZUREDB_AMD_dacaudit_DBstep13-12_latest10_processing_rates.csv
####################################################### CHECK 12b
echo "[Check #12b: Today's Latest 10 DACAudit Full Roundtrip Deltas Step 10-1]" >> $OUTFILE_STATS
echo "DateTime,CheckName,updated_date,uuid,Roundtrip in Millisecs,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12b" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/12bAZUREDB_AMD_dacaudit_step10-1_latest10_processing_rates.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12b has been run" >> $OUTFILE_LOG

while read -r line;do

updated_date=`echo $line | awk -F"," '{print $1}'`
uuid=`echo $line | awk -F"," '{print $2}'`
roundtrip=`echo $line | awk -F"," '{print $3}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_dacaudit_10_proc_rates,$updated_date,$uuid,$roundtrip,ok" >> $OUTFILE_STATS

done < ${OPDIR}12bAZUREDB_AMD_dacaudit_DBstep10-1_latest10_processing_rates.csv
####################################################### CHECK 12c
echo "[Check #12c: Today's Latest 10 GatewayAudit Full Roundtrip Deltas Step 10-1]" >> $OUTFILE_STATS
echo "DateTime,CheckName,updated_date,uuid,Roundtrip in Millisecs,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12c" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/12cAZUREDB_AMD_gwaudit_step10-1_latest10_processing_rates.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12c has been run" >> $OUTFILE_LOG

while read -r line;do

updated_date=`echo $line | awk -F"," '{print $1}'`
uuid=`echo $line | awk -F"," '{print $2}'`
roundtrip=`echo $line | awk -F"," '{print $3}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_gwaudit_10_proc_rates,$updated_date,$uuid,$roundtrip,ok" >> $OUTFILE_STATS

done < ${OPDIR}12cAZUREDB_AMD_gwaudit_step10-1_latest10_processing_rates.csv
####################################################### CHECK 3
echo "[Check #3: Update Backlogs]" >> $OUTFILE
echo "DateTime,CheckNameSchemaID,Status,COUNTupdates,MAXupdates,SUMupdates,BacklogThreshold,ResultBacklog,RoundtripMS,RoundtripThreshold,ETA,ResultRoundtrip" >> $OUTFILE
echo "$(date "+%d/%m/%Y %T") Starting Check #3" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/3AZUREDB_AMD_message_backlogs.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #3 has been run" >> $OUTFILE_LOG

backlog_threshold=850000 # 50K allowable backlog at 17:xx, but all hourly thresholds have now been doubled-up for MET77 as biggest hitter
roundtrip_threshold=2000
dt_hr=$(date "+%H")
dt_hr1=`echo $dt_hr | cut -b 1`
dt_hr2=`echo $dt_hr | cut -b 2`

while read -r line;do

if [[ $dt_hr == 00 ]];then
backlog_adaptive_threshold=$backlog_threshold
elif [[ $dt_hr1 == 0 ]];then
backlog_adaptive_threshold=$(($backlog_threshold/$dt_hr2))
else
backlog_adaptive_threshold=$(($backlog_threshold/$dt_hr))
fi

schema_id=`echo $line | awk -F"," '{print $1}'`
status=`echo $line | awk -F"," '{print $2}'`
count_updates=`echo $line | awk -F"," '{print $3}'`
sum_number_of_table_updates=`echo $line | awk -F"," '{print $4}'`
max_number_of_table_updates=`echo $line | awk -F"," '{print $5}'`

db_dacRT=`head -1 ${OPDIR}12aAZUREDB_AMD_dacaudit_DBstep13-12_latest10_processing_rates.csv | awk -F"," '{print $3}' | awk -F"." '{print $1}'`
total_dacRT=`head -1 ${OPDIR}12bAZUREDB_AMD_dacaudit_DBstep10-1_latest10_processing_rates.csv  | awk -F"," '{print $3}' | awk -F"." '{print $1}'`
total_gwRT=`head -1 ${OPDIR}12cAZUREDB_AMD_gwaudit_step10-1_latest10_processing_rates.csv  | awk -F"," '{print $3}' | awk -F"." '{print $1}'`

if [ -z $db_dacRT ];then
db_dacRT=0
fi

if [ -z $total_dacRT ];then
total_dacRT=0
fi

if [ -z $total_gwRT ];then
total_gwRT=0
fi

total_roundtrip=$(($db_dacRT+$total_dacRT+$total_gwRT))
total_roundtrip_secs=`echo "scale=1;$total_roundtrip/1000" | bc`
delivery_rate_secs=`echo "scale=1;$sum_number_of_table_updates*$total_roundtrip_secs" | bc`
delivery_rate_secs_tmp=$delivery_rate_secs

if [[ `echo $delivery_rate_secs_tmp | cut -b 1` == "." ]];then
delivery_rate_secs="0$delivery_rate_secs_tmp"
else
delivery_rate_secs=$delivery_rate_secs_tmp
fi

if [ $(echo "$delivery_rate_secs < 60" | bc -l) = 1 ];then
adj_delivery_rate=$delivery_rate_secs
eta_units=secs
elif [ $(echo "$delivery_rate_secs < 3600" | bc -l) = 1 ];then
adj_delivery_rate=`echo "scale=1;$delivery_rate_secs/60" | bc`
eta_units=mins
elif [ $(echo "$delivery_rate_secs < 86400" | bc -l) = 1 ];then
adj_delivery_rate=`echo "scale=1;$delivery_rate_secs/3600" | bc`
eta_units=hrs
else
adj_delivery_rate=`echo "scale=1;$delivery_rate_secs/86400" | bc`
eta_units=days
fi

adj_delivery_rate_tmp=$adj_delivery_rate

if [[ `echo $adj_delivery_rate_tmp | cut -b 1` == "." ]];then
adj_delivery_rate="0$adj_delivery_rate_tmp"
else
adj_delivery_rate=$adj_delivery_rate_tmp
fi

if [[ $schema_id == 77 ]];then
  backlog_adaptive_threshold=$(($backlog_adaptive_threshold*8))
elif [[ $schema_id == 99 ]];then
  backlog_adaptive_threshold=$(($backlog_adaptive_threshold*5))
elif [[ $schema_id == 38 ]] || [[ $schema_id == 135 ]];then
  backlog_adaptive_threshold=$(($backlog_adaptive_threshold*4))
elif [[ $schema_id == 105 ]] || [[ $schema_id == 129 ]] || [[ $schema_id == 82 ]] || [[ $schema_id == 124 ]] || [[ $schema_id == 31 ]];then
  backlog_adaptive_threshold=$(($backlog_adaptive_threshold*3))
elif [[ $schema_id == 130 ]] || [[ $schema_id == 126 ]] || [[ $schema_id == 112 ]] || [[ $schema_id == 47 ]] || [[ $schema_id == 36 ]] || [[ $schema_id == 103 ]] || [[ $schema_id == 106 ]] || [[ $schema_id == 61 ]];then
  backlog_adaptive_threshold=$(($backlog_adaptive_threshold*2))
fi

if [[ $status != ERROR ]];then

if [[ $sum_number_of_table_updates -gt $backlog_adaptive_threshold ]];then
result_backlog=warn
else
result_backlog=ok
fi

if [[ $(date "+%H") != 19 ]] && [[ $(date "+%H") != 20 ]];then
  if [[ $total_roundtrip -gt $roundtrip_threshold ]];then
    result_roundtrip=warn
  else
    result_roundtrip=ok
  fi
else
  result_roundtrip=ok
fi

echo "$(date "+%d/%m/%Y %T"),AZDB_msg_backlog${schema_id},$status,$count_updates,$max_number_of_table_updates,$sum_number_of_table_updates,$backlog_adaptive_threshold,$result_backlog,$total_roundtrip,$roundtrip_threshold,${adj_delivery_rate}${eta_units},$result_roundtrip" >> $OUTFILE

fi

done < ${OPDIR}3AZUREDB_AMD_message_backlogs.csv

echo "$(date "+%d/%m/%Y %T") Check #3 complete" >> $OUTFILE_LOG
####################################################### CHECK 4
echo "[Check #4: Thread Status Counts]" >> $OUTFILE
echo "DateTime,CheckName,State,Threshold,Count,Result" >> $OUTFILE
echo "$(date "+%d/%m/%Y %T") Starting Check #4" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/4AZUREDB_AMD_thread_status_counts.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #4 has been run" >> $OUTFILE_LOG

#idle_threshold=485 # tuned from 465 to 485 as uptick ~350 zombied idles: select * from pg_stat_activity where state='idle' and backend_start > '2025-04-22 23:50:37' and backend_start < '2025-04-23 00:21:00'. POD bounce the next day cleared them so reverted
#same thing 25/04 after reboots, 485 seen so upped from 465 to 495
idle_threshold=495
idle_in_trans_threshold=15
active_threshold=30 # 28 seen when 372K batch running on 25/07/2025 so tuned from 25 to 30. 23 seen at 12:40 19/12/2024 when two big bundled updates on 105 & 112 were playing in so tuned from 18 to 25.
null_threshold=15

while read -r line;do

if [[ `echo $line | grep "^,"` ]];then
state=null # null in the sql result
else
state=`echo $line | awk -F"," '{print $1}'`
fi

count=`echo $line | awk -F"," '{print $2}'`

if [[ $state == "idle" ]];then
  if [[ $count -gt $idle_threshold ]] && [[ $(date "+%H") != 19 ]] && [[ $(date "+%H") != 20 ]];then
    echo "$(date "+%d/%m/%Y %T"),AZDB_db_threads,$state,$idle_threshold,$count,warn" >> $OUTFILE
  else
    echo "$(date "+%d/%m/%Y %T"),AZDB_db_threads,$state,$idle_threshold,$count,ok" >> $OUTFILE
  fi
elif [[ $state == "idle in transaction" ]];then
  if [[ $count -gt $idle_in_trans_threshold ]] && [[ $(date "+%H") != 19 ]] && [[ $(date "+%H") != 20 ]];then
    echo "$(date "+%d/%m/%Y %T"),AZDB_db_threads,$state,$idle_in_trans_threshold,$count,warn" >> $OUTFILE
  else
    echo "$(date "+%d/%m/%Y %T"),AZDB_db_threads,$state,$idle_in_trans_threshold,$count,ok" >> $OUTFILE
  fi
elif [[ $state == "active" ]];then
  if [[ $count -gt $active_threshold ]] && [[ $(date "+%H") != 19 ]] && [[ $(date "+%H") != 20 ]];then
    echo "$(date "+%d/%m/%Y %T"),AZDB_db_threads,$state,$active_threshold,$count,warn" >> $OUTFILE
  else
    echo "$(date "+%d/%m/%Y %T"),AZDB_db_threads,$state,$active_threshold,$count,ok" >> $OUTFILE
  fi
elif [[ $state == "null" ]];then
  if [[ $count -gt $null_threshold ]] && [[ $(date "+%H") != 19 ]] && [[ $(date "+%H") != 20 ]];then
    echo "$(date "+%d/%m/%Y %T"),AZDB_db_threads,$state,$null_threshold,$count,warn" >> $OUTFILE
  else
    echo "$(date "+%d/%m/%Y %T"),AZDB_db_threads,$state,$null_threshold,$count,ok" >> $OUTFILE
  fi
else
  echo "$(date "+%d/%m/%Y %T"),AZDB_db_threads,${state}NEVERseenBEFORE,N/A,$count,warn" >> $OUTFILE
fi

done < ${OPDIR}4AZUREDB_AMD_thread_status_counts.csv

echo "$(date "+%d/%m/%Y %T") Check #4 complete" >> $OUTFILE_LOG
####################################################### CHECK 5
echo "[Check #5: MESSAGE_LOG Errors]" >> $OUTFILE
echo "DateTime,CheckNameSchemaID,error_message,Result" >> $OUTFILE
echo "$(date "+%d/%m/%Y %T") Starting Check #5" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/5AZUREDB_AMD_message_log_errors.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #5 has been run" >> $OUTFILE_LOG

echo "cat of locked schemas"
cat ${OPDIR}1AZUREDB_AMD_locked_schemas.csv
echo "cat of msg backlogs"
cat ${OPDIR}3AZUREDB_AMD_message_backlogs.csv
echo "cat of errors"
cat ${OPDIR}5AZUREDB_AMD_message_log_errors.csv

while read -r line;do
  schema_id=`echo $line | awk -F"," '{print $1}'`
  error_message=`echo $line | awk -F"," '{print $2}'`
echo "schema_id=$schema_id"
echo "error_message=$error_message"
  if [[ `cat ${OPDIR}1AZUREDB_AMD_locked_schemas.csv | grep "$schema_id"` ]];then
    echo "$(date "+%d/%m/%Y %T"),AZDB_db_message_log_error${schema_id},$error_message,warn" >> $OUTFILE
  else
    aesd_depth=`cat ${OPDIR}3AZUREDB_AMD_message_backlogs.csv | grep -P "^${schema_id}," | grep "UNPROCESSED" | awk -F"," '{print $4}' | xargs`
echo "aesd_depth=$aesd_depth"
echo "the error=$error_message"
echo "the depth conditional"
if [[ $aesd_depth -lt 10000 ]];then echo "true";else echo "false";fi
echo "the 0003 conditional"
if [[ `echo $error_message | grep "AESD-0003"` ]];then echo "true";else echo "false";fi
echo "the 0004 conditional"
if [[ `echo $error_message | grep "AESD-0004"` ]];then echo "true";else echo "false";fi
echo "the 23505 dupe key conditional"
if [[ `echo $error_message | grep -P "23505.*duplicate key value"` ]];then echo "true";else echo "false";fi
    if [[ ( $aesd_depth -lt 10000 && `echo $error_message | grep "AESD-0003"` ) || ( $aesd_depth -lt 10000 && `echo $error_message | grep "AESD-0004"` ) || ( $aesd_depth -lt 10000 && `echo $error_message | grep -P "23505.*duplicate key value"` ) ]];then
      echo "$(date "+%d/%m/%Y %T"),AZDB_db_message_log_error${schema_id},$error_message,ok" >> $OUTFILE
    else
      echo "$(date "+%d/%m/%Y %T"),AZDB_db_message_log_error${schema_id},$error_message,warn" >> $OUTFILE
    fi
  fi
done < ${OPDIR}5AZUREDB_AMD_message_log_errors.csv

echo "$(date "+%d/%m/%Y %T") Check #5 complete" >> $OUTFILE_LOG
####################################################### CHECK 6
echo "[Check #6: Unprocessed, Complete & Processing Checks]" >> $OUTFILE
echo "DateTime,CheckNameSchemaID,Threshold,earliest_unprocessed,latest_complete,latest_processing,Result" >> $OUTFILE
echo "$(date "+%d/%m/%Y %T") Starting Check #6" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/6AZUREDB_AMD_update_processing_backlog.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #6 has been run" >> $OUTFILE_LOG

while read -r line;do

schema_id=`echo $line | awk -F"," '{print $1}'`
earliest_unprocessed=`echo $line | awk -F"," '{print $2}'`
dt_earliest_unprocessed=`echo $earliest_unprocessed | awk -F"." '{print $1}'`
latest_complete=`echo $line | awk -F"," '{print $3}'`
latest_processing=`echo $line | awk -F"," '{print $4}'`
dt_latest_processing=`echo $latest_processing | awk -F"." '{print $1}'`
dt_now=$(date "+%Y-%m-%d %T")

if [[ `echo $earliest_unprocessed` ]];then

t_out_1900_unprocessed=$(date '+%s' -d "$dt_now")
t_in_1900_unprocessed=$(date '+%s' -d "$dt_earliest_unprocessed")
t_delta_secs_unprocessed=`expr $t_out_1900_unprocessed - $t_in_1900_unprocessed`

else

t_delta_secs_unprocessed=0

fi

if [[ `echo $latest_processing` ]];then

t_out_1900_processing=$(date '+%s' -d "$dt_now")
t_in_1900_processing=$(date '+%s' -d "$dt_latest_processing")
t_delta_secs_processing=`expr $t_out_1900_processing - $t_in_1900_processing`

else

t_delta_secs_processing=0

fi

t_delta_threshold_mins=90

if [[ $schema_id == 38 ]] || [[ $schema_id == 129 ]] || [[ $schema_id == 128 ]];then
  t_delta_threshold_mins=$((90*7))
elif [[ $schema_id == 77 ]] || [[ $schema_id == 11 ]];then
  t_delta_threshold_mins=$((90*6))
elif [[ $schema_id == 44 ]] || [[ $schema_id == 31 ]] || [[ $schema_id == 82 ]] || [[ $schema_id == 105 ]] || [[ $schema_id == 135 ]] || [[ $schema_id == 89 ]] || [[ $schema_id == 92 ]] || [[ $schema_id == 99 ]];then
  t_delta_threshold_mins=$((90*5))
elif [[ $schema_id == 112 ]] || [[ $schema_id == 61 ]] || [[ $schema_id == 130 ]] || [[ $schema_id == 124 ]] || [[ $schema_id == 47 ]] || [[ $schema_id == 36 ]] || [[ $schema_id == 106 ]] || [[ $schema_id == 126 ]];then
  t_delta_threshold_mins=$((90*4))
elif [[ $schema_id == 57 ]] || [[ $schema_id == 103 ]] || [[ $schema_id == 26 ]] || [[ $schema_id == 119 ]] || [[ $schema_id == 28 ]] || [[ $schema_id == 60 ]] || [[ $schema_id == 139 ]] || [[ $schema_id == 24 ]];then
  t_delta_threshold_mins=$((90*3))
elif [[ $schema_id == 8 ]] || [[ $schema_id == 138 ]] || [[ $schema_id == 96 ]] || [[ $schema_id == 30 ]] || [[ $schema_id == 21 ]] || [[ $schema_id == 10 ]] || [[ $schema_id == 22 ]] || [[ $schema_id == 5 ]] || [[ $schema_id == 12 ]] || [[ $schema_id == 14 ]];then
  t_delta_threshold_mins=$((90*2))
fi

t_delta_threshold_secs=$(($t_delta_threshold_mins*60)) # 90mins is 5400secs

if [[ `echo $earliest_unprocessed` ]] || [[ `echo $latest_processing` ]];then

if [[ $t_delta_secs_unprocessed -gt $t_delta_threshold_secs ]] || [[ $t_delta_secs_processing -gt $t_delta_threshold_secs ]];then
echo "$(date "+%d/%m/%Y %T"),AZDB_update_processing_backlog${schema_id},${t_delta_threshold_mins}minsStaleness,$earliest_unprocessed,$latest_complete,$latest_processing,warn" >> $OUTFILE
else
echo "$(date "+%d/%m/%Y %T"),AZDB_update_processing_backlog${schema_id},${t_delta_threshold_mins}minsStaleness,$earliest_unprocessed,$latest_complete,$latest_processing,ok" >> $OUTFILE
fi

fi

done < ${OPDIR}6AZUREDB_AMD_update_processing_backlog.csv

echo "$(date "+%d/%m/%Y %T") Check #6 complete" >> $OUTFILE_LOG
####################################################### CHECK 7
echo "[Check #7: Max Daily Update Counts by SchemaId]" >> $OUTFILE
echo "DateTime,CheckNameSchemaID,count_updates,sum_number_of_table_updates,max_number_of_table_updates,BundledPrintThreshold,Result" >> $OUTFILE
echo "$(date "+%d/%m/%Y %T") Starting Check #7" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/7AZUREDB_AMD_max_daily_update_counts_by_schemaid.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #7 has been run" >> $OUTFILE_LOG
bundled_print_threshold=98000 # 92513 seen 12:00 24/10/2024 || 97648 seen 11:13 10/04/2025

head -10 ${OPDIR}7AZUREDB_AMD_max_daily_update_counts_by_schemaid.csv > ${OPDIR}7AZUREDB_AMD_max_daily_update_counts_by_schemaid.tmp

while read -r line;do

schema_id=`echo $line | awk -F"," '{print $1}'`
count_updates=`echo $line | awk -F"," '{print $2}'`
sum_number_of_table_updates=`echo $line | awk -F"," '{print $3}'`
max_number_of_table_updates=`echo $line | awk -F"," '{print $4}'`

if [[ $max_number_of_table_updates -gt $bundled_print_threshold ]];then
echo "$(date "+%d/%m/%Y %T"),AZDB_max_updates${schema_id},$count_updates,$sum_number_of_table_updates,$max_number_of_table_updates,$bundled_print_threshold,warn" >> $OUTFILE
else
echo "$(date "+%d/%m/%Y %T"),AZDB_max_updates${schema_id},$count_updates,$sum_number_of_table_updates,$max_number_of_table_updates,$bundled_print_threshold,ok" >> $OUTFILE
fi

done < ${OPDIR}7AZUREDB_AMD_max_daily_update_counts_by_schemaid.tmp

echo "$(date "+%d/%m/%Y %T") Check #7 complete" >> $OUTFILE_LOG
####################################################### CHECK 8
echo "[Check #8: Today's Hourly Update Counts]" >> $OUTFILE
echo "DateTime,CheckName,TimeBucket,count_updates,sum_number_of_table_updates,max_number_of_table_updates,Result" >> $OUTFILE
echo "$(date "+%d/%m/%Y %T") Starting Check #8" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/8AZUREDB_AMD_todays_hourly_update_counts.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #8 has been run" >> $OUTFILE_LOG

while read -r line;do

schema_id=`echo $line | awk -F"," '{print $1}'`
count_updates=`echo $line | awk -F"," '{print $2}'`
sum_number_of_table_updates=`echo $line | awk -F"," '{print $3}'`
max_number_of_table_updates=`echo $line | awk -F"," '{print $4}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_hourly_updates,$schema_id,$count_updates,$sum_number_of_table_updates,$max_number_of_table_updates,ok" >> $OUTFILE

done < ${OPDIR}8AZUREDB_AMD_todays_hourly_update_counts.csv

echo "$(date "+%d/%m/%Y %T") Check #8 complete" >> $OUTFILE_LOG
####################################################### CHECK 9
echo "[Check #9: Azure Recon (ORA Recon check is on AMD Database INFO tab)]" >> $OUTFILE
#echo "[Check #9b: Themis Azure Reconciliation" >> $OUTFILE
echo "DateTime,CheckName,Status,Result" >> $OUTFILE
echo -e "45\n66\n97\n107\n109\n110\n113\n116" > ${OPDIR}confiscation_mets
echo -e "5\n8\n9\n10\n11\n12\n14\n21\n22\n24\n26\n28\n29\n30\n31\n36\n38\n47\n52\n57\n60\n61\n65\n73\n77\n78\n80\n82\n89\n92\n96\n99\n103\n105\n106\n112\n119\n124\n125\n126\n128\n129\n130\n135\n138\n139" > ${OPDIR}fines_mets
echo -e "67\n44\n111" > ${OPDIR}maintenance_mets
echo "$(date "+%d/%m/%Y %T") Starting Check #9b" >> $OUTFILE_LOG

for cnt in 1 2 3;do
  if [[ $cnt == 1 ]];then
    dbname_str=confiscation

    if [[ $op_env == test ]];then
      rec_rows=1
    else
      rec_rows=8
    fi

    echo "$(date "+%d/%m/%Y %T") Connecting to ${dbname_str} database" >> $OUTFILE_LOG
    psql "sslmode=require host=${confiscation_host} dbname=${confiscation_db} port=${confiscation_port} user=${confiscation_username} password=${confiscation_password}" --file=/sql/9AZUREDB_AMD_${dbname_str}_recon_result.sql
    psql "sslmode=require host=${confiscation_host} dbname=${confiscation_db} port=${confiscation_port} user=${confiscation_username} password=${confiscation_password}" --file=/sql/9AZUREDB_AMD_${dbname_str}_recon_errors.sql
    psql "sslmode=require host=${confiscation_host} dbname=${confiscation_db} port=${confiscation_port} user=${confiscation_username} password=${confiscation_password}" --file=/sql/9AZUREDB_AMD_${dbname_str}_recon_result_by_met.sql
    echo "$(date "+%d/%m/%Y %T") SQL for Check #9b ${dbname_str} rec has been run" >> $OUTFILE_LOG
  elif [[ $cnt == 2 ]];then
    dbname_str=fines

    if [[ $op_env == test ]];then
      rec_rows=2
    else
      rec_rows=46
    fi

    echo "$(date "+%d/%m/%Y %T") Connecting to ${dbname_str} database" >> $OUTFILE_LOG
    psql "sslmode=require host=${fines_host} dbname=${fines_db} port=${fines_port} user=${fines_username} password=${fines_password}" --file=/sql/9AZUREDB_AMD_${dbname_str}_recon_result.sql
    psql "sslmode=require host=${fines_host} dbname=${fines_db} port=${fines_port} user=${fines_username} password=${fines_password}" --file=/sql/9AZUREDB_AMD_${dbname_str}_recon_errors.sql
    psql "sslmode=require host=${fines_host} dbname=${fines_db} port=${fines_port} user=${fines_username} password=${fines_password}" --file=/sql/9AZUREDB_AMD_${dbname_str}_recon_result_by_met.sql
    echo "$(date "+%d/%m/%Y %T") SQL for Check #9b ${dbname_str} rec has been run" >> $OUTFILE_LOG
  else
    dbname_str=maintenance

    if [[ $op_env == test ]];then
      rec_rows=1
    else
      rec_rows=3
    fi

    echo "$(date "+%d/%m/%Y %T") Connecting to ${dbname_str} database" >> $OUTFILE_LOG
    psql "sslmode=require host=${maintenance_host} dbname=${maintenance_db} port=${maintenance_port} user=${maintenance_username} password=${maintenance_password}" --file=/sql/9AZUREDB_AMD_${dbname_str}_recon_result.sql
    psql "sslmode=require host=${maintenance_host} dbname=${maintenance_db} port=${maintenance_port} user=${maintenance_username} password=${maintenance_password}" --file=/sql/9AZUREDB_AMD_${dbname_str}_recon_errors.sql
    psql "sslmode=require host=${maintenance_host} dbname=${maintenance_db} port=${maintenance_port} user=${maintenance_username} password=${maintenance_password}" --file=/sql/9AZUREDB_AMD_${dbname_str}_recon_result_by_met.sql
    echo "$(date "+%d/%m/%Y %T") SQL for Check #9b ${dbname_str} rec has been run" >> $OUTFILE_LOG
  fi

  # sort the data desc on date ("k"olumn 2) which necessarily sorts by RR_ID column 1 desc, so that head -1 doesn't cut out any RR_ID as a result
  cat ${OPDIR}9AZUREDB_AMD_${dbname_str}_recon_result.csv | sort -r -k 2 -t "," > ${OPDIR}9AZUREDB_AMD_${dbname_str}_recon_result.csvSORTED
  mv ${OPDIR}9AZUREDB_AMD_${dbname_str}_recon_result.csvSORTED ${OPDIR}9AZUREDB_AMD_${dbname_str}_recon_result.csv
  rec_debug=0

  if [[ $rec_debug == 1 ]];then
    for loopc in 0 1 2 3 4 5 6 7 8 9;do
      op_date=`date "+%Y-%m-%d" -d "-${loopc} days"`
      rec_line=`grep -P "$dbname_str.*$op_date" ${OPDIR}9AZUREDB_AMD_${dbname_str}_recon_result.csv | head -1`

      if [[ $rec_line ]];then
        rr_id=`echo $rec_line | awk -F"," '{print $1}' | awk -F"_" '{print $2}'`
        rr_cnt=`echo $rec_line | awk -F"," '{print $3}'`

        if [[ `echo $rec_line | grep -P ",${rec_rows}$"` ]];then
          echo "$(date "+%d/%m/%Y %T"),$dbname_str RR_ID=$rr_id ROWS=$rr_cnt/$rec_rows,DATE=$op_date,ok" >> $OUTFILE
        else
          echo "$(date "+%d/%m/%Y %T"),$dbname_str RR_ID=$rr_id ROWS=$rr_cnt/$rec_rows has missing rec(s),DATE=$op_date,ok" >> $OUTFILE
        fi
      else
        echo "$(date "+%d/%m/%Y %T"),$dbname_str RR_ID=missing ROWS=missing,DATE=missing,ok" >> $OUTFILE
      fi
    done
echo "$(date "+%d/%m/%Y %T") Check #9b DEBUG for database $dbname_str complete" >> $OUTFILE_LOG

fi

done

op_date=`date "+%Y-%m-%d"`
op_date1=`date "+%Y-%m-%d" -d "-1 days"`
op_date2=`date "+%Y-%m-%d" -d "-2 days"`
op_date3=`date "+%Y-%m-%d" -d "-3 days"`

met_recon_errors_list=''
met_no_good_result_list=''

while read -r met;do
  if [[ ! `cat ${OPDIR}9AZUREDB_AMD_confiscation_recon_result_by_met.csv | grep ",$met,$op_date"` ]] && [[ ! `cat ${OPDIR}9AZUREDB_AMD_confiscation_recon_result_by_met.csv | grep ",$met,$op_date1"` ]] && [[ ! `cat ${OPDIR}9AZUREDB_AMD_confiscation_recon_result_by_met.csv | grep ",$met,$op_date2"` ]] && [[ ! `cat ${OPDIR}9AZUREDB_AMD_confiscation_recon_result_by_met.csv | grep ",$met,$op_date3"` ]];then
    new_met_no_good_result_list=`echo "$met_no_good_result_list $met"`
    met_no_good_result_list=$new_met_no_good_result_list
  elif [[ `cat ${OPDIR}9AZUREDB_AMD_confiscation_recon_errors.csv | grep ",$met,$op_date"` ]] && [[ `cat ${OPDIR}9AZUREDB_AMD_confiscation_recon_errors.csv | grep ",$met,$op_date1"` ]] && [[ `cat ${OPDIR}9AZUREDB_AMD_confiscation_recon_errors.csv | grep ",$met,$op_date2"` ]] && [[ `cat ${OPDIR}9AZUREDB_AMD_confiscation_recon_errors.csv | grep ",$met,$op_date3"` ]];then
    new_met_recon_errors_list=`echo "$met_recon_errors_list $met"`
    met_recon_errors_list=$new_met_recon_errors_list
  fi
done < ${OPDIR}confiscation_mets

if [[ `echo $met_no_good_result_list` ]];then
  echo "$(date "+%d/%m/%Y %T"),AZDB_confiscation_recon_status,Check rec history by means of the last query of Check #9 on JBOX in C:\Libra\MarkP\sql.txt: $met_no_good_result_list,warn" >> $OUTFILE
elif [[ `echo $met_recon_errors_list` ]];then
  echo "$(date "+%d/%m/%Y %T"),AZDB_confiscation_recon_status,Check rec history by means of the last query of Check #9 on JBOX in C:\Libra\MarkP\sql.txt: $met_recon_errors_list,warn" >> $OUTFILE
else
  echo "$(date "+%d/%m/%Y %T"),AZDB_confiscation_recon_status,All METs have seen a successful rec in the last 4 days,ok" >> $OUTFILE
fi

met_recon_errors_list=''
met_no_good_result_list=''

if [[ $rec_debug == 1 ]];then
  echo "cat of 9AZUREDB_AMD_fines_recon_result_by_met.csv:"
  head -1000 ${OPDIR}9AZUREDB_AMD_fines_recon_result_by_met.csv
  echo "cat of 9AZUREDB_AMD_fines_recon_errors.csv:"
  cat ${OPDIR}9AZUREDB_AMD_fines_recon_errors.csv
fi

while read -r met;do
  if [[ $rec_debug == 1 ]];then
    if [[ $met == 77 ]];then
      echo "op_date=$op_date"
      echo "op_date=$op_date1"
      echo "op_date=$op_date2"
      echo "op_date=$op_date3"
      echo "grep0result:"
      cat ${OPDIR}9AZUREDB_AMD_fines_recon_result_by_met.csv | grep ",$met,$op_date"
      echo "grep1result:"
      cat ${OPDIR}9AZUREDB_AMD_fines_recon_result_by_met.csv | grep ",$met,$op_date1"
      echo "grep2result:"
      cat ${OPDIR}9AZUREDB_AMD_fines_recon_result_by_met.csv | grep ",$met,$op_date2"
      echo "grep3result:"
      cat ${OPDIR}9AZUREDB_AMD_fines_recon_result_by_met.csv | grep ",$met,$op_date3"
      echo "grep0errors:"
      cat ${OPDIR}9AZUREDB_AMD_fines_recon_errors.csv | grep ",$met,$op_date"
      echo "grep1errors:"
      cat ${OPDIR}9AZUREDB_AMD_fines_recon_errors.csv | grep ",$met,$op_date1"
      echo "grep2errors:"
      cat ${OPDIR}9AZUREDB_AMD_fines_recon_errors.csv | grep ",$met,$op_date2"
      echo "grep3errors:"
      cat ${OPDIR}9AZUREDB_AMD_fines_recon_errors.csv | grep ",$met,$op_date3"
    fi
  fi

  if [[ ! `cat ${OPDIR}9AZUREDB_AMD_fines_recon_result_by_met.csv | grep ",$met,$op_date"` ]] && [[ ! `cat ${OPDIR}9AZUREDB_AMD_fines_recon_result_by_met.csv | grep ",$met,$op_date1"` ]] && [[ ! `cat ${OPDIR}9AZUREDB_AMD_fines_recon_result_by_met.csv | grep ",$met,$op_date2"` ]] && [[ ! `cat ${OPDIR}9AZUREDB_AMD_fines_recon_result_by_met.csv | grep ",$met,$op_date3"` ]];then
    new_met_no_good_result_list=`echo "$met_no_good_result_list $met"`
    met_no_good_result_list=$new_met_no_good_result_list
    if [[ $met == 77 ]];then
    echo "new_met_no_good_result_list=$new_met_no_good_result_list"
    echo "met_no_good_result_list=$met_no_good_result_list"
    fi
  elif [[ `cat ${OPDIR}9AZUREDB_AMD_fines_recon_errors.csv | grep ",$met,$op_date"` ]] && [[ `cat ${OPDIR}9AZUREDB_AMD_fines_recon_errors.csv | grep ",$met,$op_date1"` ]] && [[ `cat ${OPDIR}9AZUREDB_AMD_fines_recon_errors.csv | grep ",$met,$op_date2"` ]] && [[ `cat ${OPDIR}9AZUREDB_AMD_fines_recon_errors.csv | grep ",$met,$op_date3"` ]];then
    new_met_recon_errors_list=`echo "$met_recon_errors_list $met"`
    met_recon_errors_list=$new_met_recon_errors_list
  fi
done < ${OPDIR}fines_mets

if [[ `echo $met_no_good_result_list` ]];then
  echo "$(date "+%d/%m/%Y %T"),AZDB_fines_recon_status,Check rec history by means of the last query of Check #9 on JBOX in C:\Libra\MarkP\sql.txt: $met_no_good_result_list,warn" >> $OUTFILE
elif [[ `echo $met_recon_errors_list` ]];then
  echo "$(date "+%d/%m/%Y %T"),AZDB_fines_recon_status,Check rec history by means of the last query of Check #9 on JBOX in C:\Libra\MarkP\sql.txt: $met_recon_errors_list,warn" >> $OUTFILE
else
  echo "$(date "+%d/%m/%Y %T"),AZDB_fines_recon_status,All METs have seen a successful rec in the last 4 days,ok" >> $OUTFILE
fi

met_recon_errors_list=''
met_no_good_result_list=''

while read -r met;do
  if [[ ! `cat ${OPDIR}9AZUREDB_AMD_maintenance_recon_result_by_met.csv | grep ",$met,$op_date"` ]] && [[ ! `cat ${OPDIR}9AZUREDB_AMD_maintenance_recon_result_by_met.csv | grep ",$met,$op_date1"` ]] && [[ ! `cat ${OPDIR}9AZUREDB_AMD_maintenance_recon_result_by_met.csv | grep ",$met,$op_date2"` ]] && [[ ! `cat ${OPDIR}9AZUREDB_AMD_maintenance_recon_result_by_met.csv | grep ",$met,$op_date3"` ]];then
    new_met_no_good_result_list=`echo "$met_no_good_result_list $met"`
    met_no_good_result_list=$new_met_no_good_result_list
  elif [[ `cat ${OPDIR}9AZUREDB_AMD_maintenance_recon_errors.csv | grep ",$met,$op_date"` ]] && [[ `cat ${OPDIR}9AZUREDB_AMD_maintenance_recon_errors.csv | grep ",$met,$op_date1"` ]] && [[ `cat ${OPDIR}9AZUREDB_AMD_maintenance_recon_errors.csv | grep ",$met,$op_date2"` ]] && [[ `cat ${OPDIR}9AZUREDB_AMD_maintenance_recon_errors.csv | grep ",$met,$op_date3"` ]];then
    new_met_recon_errors_list=`echo "$met_recon_errors_list $met"`
    met_recon_errors_list=$new_met_recon_errors_list
  fi
done < ${OPDIR}maintenance_mets

if [[ `echo $met_no_good_result_list` ]];then
  echo "$(date "+%d/%m/%Y %T"),AZDB_maintenance_recon_status,Check rec history by means of the last query of Check #9 on JBOX in C:\Libra\MarkP\sql.txt: $met_no_good_result_list,warn" >> $OUTFILE
elif [[ `echo $met_recon_errors_list` ]];then
  echo "$(date "+%d/%m/%Y %T"),AZDB_maintenance_recon_status,Check rec history by means of the last query of Check #9 on JBOX in C:\Libra\MarkP\sql.txt: $met_recon_errors_list,warn" >> $OUTFILE
else
  echo "$(date "+%d/%m/%Y %T"),AZDB_maintenance_recon_status,All METs have seen a successful rec in the last 4 days,ok" >> $OUTFILE
fi

echo "$(date "+%d/%m/%Y %T") Check #9b complete" >> $OUTFILE_LOG
####################################################### CHECK 10
#echo "[Check #10: Themis WebLogic]" >> $OUTFILE
#echo "$(date "+%d/%m/%Y %T") Starting Check #10" >> $OUTFILE_LOG
#echo "ReminderMessage" >> $OUTFILE
#echo "Remember to check Themis Process States & WL Backlogs on AMD LIBRA Web App ADMIN-1 server" >> $OUTFILE
#echo "$(date "+%d/%m/%Y %T") Check #10 has been run" >> $OUTFILE_LOG
####################################################### CHECK 11
echo "[Check #11: Table Row Counts]" >> $OUTFILE
echo "DateTime,CheckName,RowCount,Threshold,Result" >> $OUTFILE

if [[ $op_env == test ]];then
threshold_count_update_requests=100000
threshold_count_table_updates=500000
threshold_count_message_log=200000
threshold_count_dac_audit=120000000
threshold_count_gateway_audit=100000
else
threshold_count_update_requests=5000000
threshold_count_table_updates=9000000
threshold_count_message_log=20000000
threshold_count_dac_audit=70000000
threshold_count_gateway_audit=1500000
fi

echo "$(date "+%d/%m/%Y %T") Starting Check #11a" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/11aAZUREDB_AMD_row_counts_update_requests.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #11a has been run" >> $OUTFILE_LOG

rowcount_update_requests=`cat ${OPDIR}11aAZUREDB_AMD_row_counts_update_requests.csv`

if [[ $rowcount_update_requests -gt $threshold_count_update_requests ]];then

echo "$(date "+%d/%m/%Y %T"),AZDB_update_requests_row_count,$rowcount_update_requests,$threshold_count_update_requests,warn" >> $OUTFILE

else

echo "$(date "+%d/%m/%Y %T"),AZDB_update_requests_row_count,$rowcount_update_requests,$threshold_count_update_requests,ok" >> $OUTFILE

fi

echo "$(date "+%d/%m/%Y %T") Starting Check #11b" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/11bAZUREDB_AMD_row_counts_table_updates.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #11b has been run" >> $OUTFILE_LOG

rowcount_table_updates=`cat ${OPDIR}11bAZUREDB_AMD_row_counts_table_updates.csv`

if [[ $rowcount_table_updates -gt $threshold_count_table_updates ]];then

echo "$(date "+%d/%m/%Y %T"),AZDB_table_updates_row_count,$rowcount_table_updates,$threshold_count_table_updates,warn" >> $OUTFILE

else

echo "$(date "+%d/%m/%Y %T"),AZDB_table_updates_row_count,$rowcount_table_updates,$threshold_count_table_updates,ok" >> $OUTFILE

fi

echo "$(date "+%d/%m/%Y %T") Starting Check #11c" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/11cAZUREDB_AMD_row_counts_message_log.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #11c has been run" >> $OUTFILE_LOG

rowcount_message_log=`cat ${OPDIR}11cAZUREDB_AMD_row_counts_message_log.csv`

if [[ $rowcount_message_log -gt $threshold_count_message_log ]];then

echo "$(date "+%d/%m/%Y %T"),AZDB_message_log_row_count,$rowcount_message_log,$threshold_count_message_log,warn" >> $OUTFILE

else

echo "$(date "+%d/%m/%Y %T"),AZDB_message_log_row_count,$rowcount_message_log,$threshold_count_message_log,ok" >> $OUTFILE

fi

echo "$(date "+%d/%m/%Y %T") Starting Check #11d" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/11dAZUREDB_AMD_row_counts_DAC_message_audit.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #11d has been run" >> $OUTFILE_LOG

rowcount_dac_audit=`cat ${OPDIR}11dAZUREDB_AMD_row_counts_DAC_message_audit.csv`

if [[ $rowcount_dac_audit -gt $threshold_count_dac_audit ]];then

echo "$(date "+%d/%m/%Y %T"),AZDB_dac_audit_row_count,$rowcount_dac_audit,$threshold_count_dac_audit,warn" >> $OUTFILE

else

echo "$(date "+%d/%m/%Y %T"),AZDB_dac_audit_row_count,$rowcount_dac_audit,$threshold_count_dac_audit,ok" >> $OUTFILE

fi

echo "$(date "+%d/%m/%Y %T") Starting Check #11e" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/11eAZUREDB_AMD_row_counts_GW_message_audit.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #11e has been run" >> $OUTFILE_LOG

rowcount_gateway_audit=`cat ${OPDIR}11eAZUREDB_AMD_row_counts_GW_message_audit.csv`

if [[ $rowcount_gateway_audit -gt $threshold_count_gateway_audit ]];then

echo "$(date "+%d/%m/%Y %T"),AZDB_gateway_audit_row_count,$rowcount_gateway_audit,$threshold_count_gateway_audit,warn" >> $OUTFILE

else

echo "$(date "+%d/%m/%Y %T"),AZDB_gateway_audit_row_count,$rowcount_gateway_audit,$threshold_count_gateway_audit,ok" >> $OUTFILE

fi

echo "$(date "+%d/%m/%Y %T") Check #11 complete" >> $OUTFILE_LOG
####################################################### CHECK 12d - 12r, remaining stats
echo "[Check #12d: Daily AVG DACAudit DB Roundtrip Deltas Step 13-12]" >> $OUTFILE_STATS
echo "DateTime,CheckName,DTbucket,avgDailyRT in Millisecs,TotalWorkload in Hours,RecordCount,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12d" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/12dAZUREDB_AMD_dacaudit_DBstep13-12_avgDailyRT.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12d has been run" >> $OUTFILE_LOG

while read -r line;do

dateddmmyyyy=`echo $line | awk -F"," '{print $1}'`
avgDailyRT=`echo $line | awk -F"," '{print $2}'`
total_workload=`echo $line | awk -F"," '{print $3}'`
records=`echo $line | awk -F"," '{print $4}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_dacaudit_db_avgDailyRT,$dateddmmyyyy,$avgDailyRT,$total_workload,$records,ok" >> $OUTFILE_STATS

done < ${OPDIR}12dAZUREDB_AMD_dacaudit_DBstep13-12_avgDailyRT.csv
######################################################################################################################################################################################################
echo "[Check #12e: Daily AVG DACAudit Full Roundtrip Deltas Step 10-1]" >> $OUTFILE_STATS
echo "DateTime,CheckName,DTbucket,avgDailyRT in Millisecs,TotalWorkload in Hours,RecordCount,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12e" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/12eAZUREDB_AMD_dacaudit_step10-1_avgDailyRT.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12e has been run" >> $OUTFILE_LOG

while read -r line;do

dateddmmyyyy=`echo $line | awk -F"," '{print $1}'`
avgDailyRT=`echo $line | awk -F"," '{print $2}'`
total_workload=`echo $line | awk -F"," '{print $3}'`
records=`echo $line | awk -F"," '{print $4}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_dacaudit_avgDailyRT,$dateddmmyyyy,$avgDailyRT,$total_workload,$records,ok" >> $OUTFILE_STATS

done < ${OPDIR}12eAZUREDB_AMD_dacaudit_step10-1_avgDailyRT.csv
######################################################################################################################################################################################################
echo "[Check #12f: Daily AVG GatewayAudit Full Roundtrip Deltas Step 10-1]" >> $OUTFILE_STATS
echo "DateTime,CheckName,DTbucket,avgDailyRT in Millisecs,TotalWorkload in Hours,RecordCount,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12f" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/12fAZUREDB_AMD_gwaudit_step10-1_avgDailyRT.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12f has been run" >> $OUTFILE_LOG

while read -r line;do

dateddmmyyyy=`echo $line | awk -F"," '{print $1}'`
avgDailyRT=`echo $line | awk -F"," '{print $2}'`
total_workload=`echo $line | awk -F"," '{print $3}'`
records=`echo $line | awk -F"," '{print $4}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_gwaudit_avgDailyRT,$dateddmmyyyy,$avgDailyRT,$total_workload,$records,ok" >> $OUTFILE_STATS

done < ${OPDIR}12fAZUREDB_AMD_gwaudit_step10-1_avgDailyRT.csv
######################################################################################################################################################################################################
echo "[Check #12g: 48 Hourly AVG DACAudit DB Roundtrip Deltas Step 13-12]" >> $OUTFILE_STATS
echo "DateTime,CheckName,DTbucket,avgHourlyRT in Millisecs,TotalWorkload in Mins,RecordCount,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12g" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/12gAZUREDB_AMD_dacaudit_DBstep13-12_avgHourlyRT.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12g has been run" >> $OUTFILE_LOG

while read -r line;do

dateddmmyyyy=`echo $line | awk -F"," '{print $1}'`
avgHourlyRT=`echo $line | awk -F"," '{print $2}'`
total_workload=`echo $line | awk -F"," '{print $3}'`
records=`echo $line | awk -F"," '{print $4}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_dacaudit_db_avgHourlyRT,$dateddmmyyyy,$avgHourlyRT,$total_workload,$records,ok" >> $OUTFILE_STATS

done < ${OPDIR}12gAZUREDB_AMD_dacaudit_DBstep13-12_avgHourlyRT.csv
######################################################################################################################################################################################################
echo "[Check #12h: 60 Minute AVG DACAudit DB Roundtrip Deltas Step 13-12]" >> $OUTFILE_STATS
echo "DateTime,CheckName,DTbucket,avgMinuteRT in Millisecs,TotalWorkload in Secs,RecordCount,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12h" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/12hAZUREDB_AMD_dacaudit_DBstep13-12_avgMinuteRT.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12h has been run" >> $OUTFILE_LOG

while read -r line;do

dateddmmyyyy=`echo $line | awk -F"," '{print $1}'`
avgMinuteRT=`echo $line | awk -F"," '{print $2}'`
total_workload=`echo $line | awk -F"," '{print $3}'`
records=`echo $line | awk -F"," '{print $4}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_dacaudit_db_avgMinuteRT,$dateddmmyyyy,$avgMinuteRT,$total_workload,$records,ok" >> $OUTFILE_STATS

done < ${OPDIR}12hAZUREDB_AMD_dacaudit_DBstep13-12_avgMinuteRT.csv
######################################################################################################################################################################################################
echo "[Check #12i: 48 Hourly AVG DACAudit DB Roundtrip Deltas Step 10-1]" >> $OUTFILE_STATS
echo "DateTime,CheckName,DTbucket,avgHourlyRT in Millisecs,TotalWorkload in Mins,RecordCount,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12i" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/12iAZUREDB_AMD_dacaudit_DBstep10-1_avgHourlyRT.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12i has been run" >> $OUTFILE_LOG

while read -r line;do

dateddmmyyyy=`echo $line | awk -F"," '{print $1}'`
avgHourlyRT=`echo $line | awk -F"," '{print $2}'`
total_workload=`echo $line | awk -F"," '{print $3}'`
records=`echo $line | awk -F"," '{print $4}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_dacaudit_db_avgHourlyRT,$dateddmmyyyy,$avgHourlyRT,$total_workload,$records,ok" >> $OUTFILE_STATS

done < ${OPDIR}12iAZUREDB_AMD_dacaudit_DBstep10-1_avgHourlyRT.csv
######################################################################################################################################################################################################
echo "[Check #12j: 60 Minute AVG DACAudit DB Roundtrip Deltas Step 10-1]" >> $OUTFILE_STATS
echo "DateTime,CheckName,DTbucket,avgMinuteRT in Millisecs,TotalWorkload in Secs,RecordCount,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12j" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/12jAZUREDB_AMD_dacaudit_DBstep10-1_avgMinuteRT.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12j has been run" >> $OUTFILE_LOG

while read -r line;do

dateddmmyyyy=`echo $line | awk -F"," '{print $1}'`
avgMinuteRT=`echo $line | awk -F"," '{print $2}'`
total_workload=`echo $line | awk -F"," '{print $3}'`
records=`echo $line | awk -F"," '{print $4}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_dacaudit_db_avgMinuteRT,$dateddmmyyyy,$avgMinuteRT,$total_workload,$records,ok" >> $OUTFILE_STATS

done < ${OPDIR}12jAZUREDB_AMD_dacaudit_DBstep10-1_avgMinuteRT.csv
######################################################################################################################################################################################################
echo "[Check #12k: 48 Hourly AVG GatewayAudit Full Roundtrip Deltas Step 10-1]" >> $OUTFILE_STATS
echo "DateTime,CheckName,DTbucket,avgHourlyRT in Millisecs,TotalWorkload in Mins,RecordCount,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12k" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/12kAZUREDB_AMD_gwaudit_step10-1_avgHourlyRT.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12k has been run" >> $OUTFILE_LOG

while read -r line;do

dateddmmyyyy=`echo $line | awk -F"," '{print $1}'`
avgHourlyRT=`echo $line | awk -F"," '{print $2}'`
total_workload=`echo $line | awk -F"," '{print $3}'`
records=`echo $line | awk -F"," '{print $4}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_gwaudit_avgHourlyRT,$dateddmmyyyy,$avgHourlyRT,$total_workload,$records,ok" >> $OUTFILE_STATS

done < ${OPDIR}12kAZUREDB_AMD_gwaudit_step10-1_avgHourlyRT.csv
######################################################################################################################################################################################################
echo "[Check #12l: 60 Minute AVG GatewayAudit Full Roundtrip Deltas Step 10-1]" >> $OUTFILE_STATS
echo "DateTime,CheckName,DTbucket,avgMinuteRT in Millisecs,TotalWorkload in Mins,RecordCount,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12l" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/12lAZUREDB_AMD_gwaudit_step10-1_avgMinuteRT.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12l has been run" >> $OUTFILE_LOG

while read -r line;do

dateddmmyyyy=`echo $line | awk -F"," '{print $1}'`
avgMinuteRT=`echo $line | awk -F"," '{print $2}'`
total_workload=`echo $line | awk -F"," '{print $3}'`
records=`echo $line | awk -F"," '{print $4}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_gwaudit_avgMinuteRT,$dateddmmyyyy,$avgMinuteRT,$total_workload,$records,ok" >> $OUTFILE_STATS

done < ${OPDIR}12lAZUREDB_AMD_gwaudit_step10-1_avgMinuteRT.csv
######################################################################################################################################################################################################
echo "[Check #12m: Daily Completed UPDATE_REQUESTS Counts]" >> $OUTFILE_STATS
echo "DateTime,CheckName,DTbucket,RecordCount,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12m" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/12mAZUREDB_AMD_daily_completed_update_request_counts.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12m has been run" >> $OUTFILE_LOG

while read -r line;do

dateddmmyyyy=`echo $line | awk -F"," '{print $1}'`
records=`echo $line | awk -F"," '{print $2}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_daily_completed_update_requests,$dateddmmyyyy,$records,ok" >> $OUTFILE_STATS

done < ${OPDIR}12mAZUREDB_AMD_daily_completed_update_request_counts.csv
######################################################################################################################################################################################################
echo "[Check #12n: Daily Completed TABLE_UPDATES Counts]" >> $OUTFILE_STATS
echo "DateTime,CheckName,DTbucket,RecordCount,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12n" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/12nAZUREDB_AMD_daily_completed_table_updates_counts.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12n has been run" >> $OUTFILE_LOG

while read -r line;do

dateddmmyyyy=`echo $line | awk -F"," '{print $1}'`
records=`echo $line | awk -F"," '{print $2}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_daily_completed_table_updates,$dateddmmyyyy,$records,ok" >> $OUTFILE_STATS

done < ${OPDIR}12nAZUREDB_AMD_daily_completed_table_updates_counts.csv
######################################################################################################################################################################################################
echo "[Check #12o: Hourly Completed UPDATE_REQUESTS Counts]" >> $OUTFILE_STATS
echo "DateTime,CheckName,DTbucket,RecordCount,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12o" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/12oAZUREDB_AMD_hourly_completed_update_request_counts.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12o has been run" >> $OUTFILE_LOG

while read -r line;do

dateddmmyyyy=`echo $line | awk -F"," '{print $1}'`
records=`echo $line | awk -F"," '{print $2}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_hourly_completed_update_requests,$dateddmmyyyy,$records,ok" >> $OUTFILE_STATS

done < ${OPDIR}12oAZUREDB_AMD_hourly_completed_update_request_counts.csv
######################################################################################################################################################################################################
echo "[Check #12p: Hourly Completed TABLE_UPDATES Counts]" >> $OUTFILE_STATS
echo "DateTime,CheckName,DTbucket,RecordCount,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12p" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/12pAZUREDB_AMD_hourly_completed_table_updates_counts.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12p has been run" >> $OUTFILE_LOG

while read -r line;do

dateddmmyyyy=`echo $line | awk -F"," '{print $1}'`
records=`echo $line | awk -F"," '{print $2}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_hourly_completed_table_updates,$dateddmmyyyy,$records,ok" >> $OUTFILE_STATS

done < ${OPDIR}12pAZUREDB_AMD_hourly_completed_table_updates_counts.csv
######################################################################################################################################################################################################
echo "[Check #12q: Minute Completed UPDATE_REQUESTS Counts]" >> $OUTFILE_STATS
echo "DateTime,CheckName,DTbucket,RecordCount,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12q" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/12qAZUREDB_AMD_minute_completed_update_request_counts.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12q has been run" >> $OUTFILE_LOG

while read -r line;do

dateddmmyyyy=`echo $line | awk -F"," '{print $1}'`
records=`echo $line | awk -F"," '{print $2}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_minute_completed_update_requests,$dateddmmyyyy,$records,ok" >> $OUTFILE_STATS

done < ${OPDIR}12qAZUREDB_AMD_minute_completed_update_request_counts.csv
######################################################################################################################################################################################################
echo "[Check #12r: Minute Completed TABLE_UPDATES Counts]" >> $OUTFILE_STATS
echo "DateTime,CheckName,DTbucket,RecordCount,Result" >> $OUTFILE_STATS
echo "$(date "+%d/%m/%Y %T") Starting Check #12r" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/12rAZUREDB_AMD_minute_completed_table_updates_counts.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12r has been run" >> $OUTFILE_LOG

while read -r line;do

dateddmmyyyy=`echo $line | awk -F"," '{print $1}'`
records=`echo $line | awk -F"," '{print $2}'`

echo "$(date "+%d/%m/%Y %T"),AZDB_minute_completed_table_updates,$dateddmmyyyy,$records,ok" >> $OUTFILE_STATS

done < ${OPDIR}12rAZUREDB_AMD_minute_completed_table_updates_counts.csv

echo "$(date "+%d/%m/%Y %T") Check #12 complete" >> $OUTFILE_LOG
####################################################### CHECK 12
echo "[Check #12: ora_rowscn SequenceNumber Bug]" >> $OUTFILE
echo "DateTime,CheckNameSchemaID,update_request_id,update_type,created_date,sequence_number,previous_sequence_number,Result" >> $OUTFILE
echo "$(date "+%d/%m/%Y %T") Starting Check #12" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/12AZUREDB_AMD_ora_rowscn_bug_seq_nums.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #12 has been run" >> $OUTFILE_LOG
echo "cat of 12AZUREDB_AMD_ora_rowscn_bug_seq_nums.csv BEFORE SP:" >> $OUTFILE_LOG
cat ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums.csv >> $OUTFILE_LOG

#if [[ 0 == 1 ]];then
dupe_seq_nums_linecount=`cat ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums.csv | wc -l`

if [[ `cat ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums.csv | wc -l` -gt 0 ]];then
  check12_sp_start_time=$(date "+%H:%M:%S %a %b %e %Y")
  epoch_secs_check12_sp_start_time=$(date '+%s' -d "$check12_sp_start_time")
  echo "$(date "+%d/%m/%Y %T") SQL for Check #12 for duplicate sequence number fix is about to be run: call fix_duplicate_seq_nos()" >> $OUTFILE_LOG
#  psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/12AZUREDB_AMD_ora_rowscn_bug_seq_nums_fix.sql --echo-queries
  psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" -c 'call fix_duplicate_seq_nos()' -e
#ls -altr ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums.csv
#ls -altr ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums_fix.csv
echo "cat of 12AZUREDB_AMD_ora_rowscn_bug_seq_nums.csv AFTER SP:" >> $OUTFILE_LOG
cat ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums.csv >> $OUTFILE_LOG
#echo "cat of 12AZUREDB_AMD_ora_rowscn_bug_seq_nums_fix.csv:" >> $OUTFILE_LOG
#cat ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums_fix.csv >> $OUTFILE_LOG
#  if [ $? -eq 0 ];then
    echo "$(date "+%d/%m/%Y %T") SQL for Check #12 for duplicate sequence number fix has been run without errors: call fix_duplicate_seq_nos()" >> $OUTFILE_LOG
    check12_sp_end_time=$(date "+%H:%M:%S %a %b %e %Y")
    epoch_secs_check12_sp_end_time=$(date '+%s' -d "$check12_sp_end_time")
    check12_sp_runtime_secs=`expr $epoch_secs_check12_sp_end_time - $epoch_secs_check12_sp_start_time`
    runtime_threshold=50
    linecount_threshold=500

    if [[ $check12_sp_runtime_secs -gt $runtime_threshold ]] || [[ $dupe_seq_nums_linecount -gt $linecount_threshold ]];then
      echo "$(date "+%d/%m/%Y %T"),AZDB_call_fix_duplicate_seq_nos(),RowsCleared=${dupe_seq_nums_linecount},linecount_threshold=GT${linecount_threshold},Runtime=${check12_sp_runtime_secs}secs,runtime_threshold=GT${runtime_threshold},,warn" >> $OUTFILE
#    else
#      echo "$(date "+%d/%m/%Y %T"),AZDB_call_fix_duplicate_seq_nos(),RowsCleared=${dupe_seq_nums_linecount},linecount_threshold=GT${linecount_threshold},Runtime=${check12_sp_runtime_secs}secs,runtime_threshold=GT${runtime_threshold},,ok" >> $OUTFILE
    fi

    echo "$(date "+%d/%m/%Y %T") Connecting to $event_db database to perform 2nd round check of duplicate sequence numbers" >> $OUTFILE_LOG
#    psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" --file=/sql/12AZUREDB_AMD_ora_rowscn_bug_seq_nums.sql --echo-queries
    psql "sslmode=require host=${event_host} dbname=${event_db} port=${event_port} user=${event_username} password=${event_password}" -c 'call fix_duplicate_seq_nos()' -e
    echo "$(date "+%d/%m/%Y %T") 2nd round of duplicate sequence numbers completed ok" >> $OUTFILE_LOG
    echo "cat of 12AZUREDB_AMD_ora_rowscn_bug_seq_nums_fix.csv:" >> $OUTFILE_LOG
    cat ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums_fix.csv >> $OUTFILE_LOG
    dupe_seq_nums_linecount=`cat ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums.csv | wc -l`
    echo "$(date "+%d/%m/%Y %T"),AZDB_call_fix_duplicate_seq_nos(),NewRowsAfterCleardown=${dupe_seq_nums_linecount},,,,,ok" >> $OUTFILE
#ls -altr ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums.csv
#ls -altr ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums_fix.csv
#  else
#    echo "cat of 12AZUREDB_AMD_ora_rowscn_bug_seq_nums_fix.csv:" >> $OUTFILE_LOG
#    cat ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums_fix.csv >> $OUTFILE_LOG
#ls -altr ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums.csv
#ls -altr ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums_fix.csv
#    echo "$(date "+%d/%m/%Y %T"),AZDB_call_fix_duplicate_seq_nos(),SQL for Check #12 for duplicate sequence number fix has been run with errors so check the logfile,RowsToClear=${dupe_seq_nums_linecount},,,,warn" >> $OUTFILE
#  fi
else
  echo "$(date "+%d/%m/%Y %T") No duplicate sequence numbers have been found in Check #12 so the fix SP hasn't been run" >> $OUTFILE_LOG
#  echo "$(date "+%d/%m/%Y %T"),AZDB_call_fix_duplicate_seq_nos(),No duplicate sequence numbers found so the fix SP hasn't been run,dupe_seq_nums_linecount=${dupe_seq_nums_linecount},,,,ok" >> $OUTFILE
fi
#fi

while read -r line;do

schema_id=`echo $line | awk -F"," '{print $1}'`
update_request_id=`echo $line | awk -F"," '{print $2}'`
update_type=`echo $line | awk -F"," '{print $3}'`
created_date=`echo $line | awk -F"," '{print $4}'`
sequence_number=`echo $line | awk -F"," '{print $5}'`
previous_sequence_number=`echo $line | awk -F"," '{print $6}'`

#if [[ $sequence_number -eq $previous_sequence_number ]] && [[ $insert_type = I ]];then
if [[ $sequence_number -eq $previous_sequence_number ]];then
#echo "$(date "+%d/%m/%Y %T"),AZDB_ora_rowscn_bug$schema_id,$update_request_id,$update_type,$created_date,$sequence_number,$previous_sequence_number,warn" >> $OUTFILE
echo "$(date "+%d/%m/%Y %T"),AZDB_ora_rowscn_bug$schema_id,$update_request_id,$update_type,$created_date,$sequence_number,$previous_sequence_number,ok" >> $OUTFILE
else
echo "$(date "+%d/%m/%Y %T"),AZDB_ora_rowscn_bug$schema_id,$update_request_id,$update_type,$created_date,$sequence_number,$previous_sequence_number,ok" >> $OUTFILE
fi

done < ${OPDIR}12AZUREDB_AMD_ora_rowscn_bug_seq_nums.csv

echo "$(date "+%d/%m/%Y %T") Check #12 complete" >> $OUTFILE_LOG
####################################################### CHECK 13
echo "[Check #13: DAC & Gateway message_audit_id INT out of range]" >> $OUTFILE
echo "DateTime,CheckName,Tablename,max(message_audit_id),Threshold,Result" >> $OUTFILE
echo "$(date "+%d/%m/%Y %T") Starting Check #13" >> $OUTFILE_LOG
echo "$(date "+%d/%m/%Y %T") Connecting to $postgres_db database" >> $OUTFILE_LOG
psql "sslmode=require host=${postgres_host} dbname=${postgres_db} port=${postgres_port} user=${postgres_username} password=${postgres_password}" --file=/sql/13AZUREDB_AMD_message_audit_id_INT_out_of_range.sql
echo "$(date "+%d/%m/%Y %T") SQL for Check #13 has been run" >> $OUTFILE_LOG
count=1

while read -r line;do

if [[ $count == 1 ]];then
tablename=DAC
else
tablename=Gateway
fi

max_message_audit_id=`echo $line | awk -F"," '{print $1}'`
threshold_max_int=2000000000 #2147483647 is max allowable

if [[ $max_message_audit_id -gt $threshold_max_int ]];then
echo "$(date "+%d/%m/%Y %T"),AZDB_message_audit_id_INT_out_of_range,$tablename,$max_message_audit_id,$threshold_max_int,warn" >> $OUTFILE
else
echo "$(date "+%d/%m/%Y %T"),AZDB_message_audit_id_INT_out_of_range,$tablename,$max_message_audit_id,$threshold_max_int,ok" >> $OUTFILE
fi

count=$((count+1))

done < ${OPDIR}13AZUREDB_AMD_message_audit_id_INT_out_of_range.csv

echo "$(date "+%d/%m/%Y %T") Check #13 complete" >> $OUTFILE_LOG
####################
### AMD Override ###
####################
cp $OUTFILE $OUTFILE.orig ### creates a copy of the current output file
override_file=${OPDIR}ams-reporting_overrides_list.dat

if [[ $op_env == test ]];then

dummy=0

else

echo "03/01/2025.*AZDB_db_message_log_error77.*duplicate" >> $override_file

echo "06/01/2025.*AZDB_update_processing_backlog77" >> $override_file
echo "06/01/2025.*AZDB_db_message_log_error77.*23505.*duplicate key value violates unique constraint" >> $override_file

echo "07/01/2025.*AZDB_update_processing_backlog77" >> $override_file

echo "16/01/2025.*AZDB_db_message_log_error(105|106).*23505.*duplicate key value violates unique constraint.*update_requests_pk" >> $override_file

echo "17/01/2025.*AZDB_update_processing_backlog38" >> $override_file

echo "31/01/2025.*AZDB_update_processing_backlog77" >> $override_file
echo "31/01/2025.*AZDB_update_processing_backlog82" >> $override_file

echo "19/02/2025.*AZDB_update_processing_backlog82" >> $override_file

echo "19/02/2025.*AZDB_db_message_log_error82.*AESD-0003 : The previous update request id for which the next available update request id should follow has not finished processing" >> $override_file

echo "20/02/2025.*AZDB_update_processing_backlog82" >> $override_file

echo "26/02/2025.*AZDB_update_processing_backlog82" >> $override_file

echo "12/03/2025.*AZDB_update_processing_backlog135" >> $override_file

echo "13/03/2025.*AZDB_update_processing_backlog105" >> $override_file

echo "13/03/2025.*AZDB_update_processing_backlog10" >> $override_file

echo "13/03/2025.*AZDB_update_processing_backlog52" >> $override_file

echo "13/03/2025.*AZDB_db_message_log_error5.*AESD-0003 : The previous update request id for which the next available update request id should follow has not finished processing" >> $override_file

echo "13/03/2025.*AZDB_db_message_log_error47.*AESD-0003 : The previous update request id for which the next available update request id should follow has not finished processing" >> $override_file

echo "13/03/2025.*AZDB_db_message_log_error52.*AESD-0003 : The previous update request id for which the next available update request id should follow has not finished processing" >> $override_file

echo "14/03/2025.*AZDB_update_processing_backlog5" >> $override_file

echo "14/03/2025.*AZDB_update_processing_backlog47" >> $override_file

echo "14/03/2025.*AZDB_update_processing_backlog52" >> $override_file

# 490K updates 26/03 on 77 but remained locked overnight due to dupe seq num out-of-hours
echo "27/03/2025.*AZDB_update_processing_backlog77" >> $override_file
echo "27/03/2025.*AZDB_msg_backlog77" >> $override_file

echo "28/03/2025.*AZDB_update_processing_backlog77" >> $override_file

echo "31/03/2025.*AZDB_update_processing_backlog77" >> $override_file
echo "31/03/2025.*AZDB_msg_backlog77" >> $override_file
echo "31/03/2025.*AZDB_msg_backlog103" >> $override_file
echo "31/03/2025.*AZDB_msg_backlog12" >> $override_file
echo "31/03/2025.*AZDB_update_processing_backlog44" >> $override_file
echo "31/03/2025.*AZDB_update_processing_backlog103" >> $override_file
echo "31/03/2025.*AZDB_update_processing_backlog12" >> $override_file
echo "31/03/2025.*AZDB_update_processing_backlog99" >> $override_file
echo "31/03/2025.*AZDB_update_processing_backlog105" >> $override_file

echo "01/04/2025.*AZDB_update_processing_backlog130" >> $override_file

echo "08/04/2025.*AZDB_update_processing_backlog126" >> $override_file

echo "09/04/2025.*AZDB_update_processing_backlog96" >> $override_file
echo "09/04/2025.*AZDB_update_processing_backlog135" >> $override_file
echo "09/04/2025.*AZDB_update_processing_backlog103" >> $override_file

echo "10/04/2025.*AZDB_update_processing_backlog135" >> $override_file

echo "11/04/2025.*AZDB_fines_recon_status" >> $override_file

echo "14/04/2025.*AZDB_fines_recon_status" >> $override_file
echo "14/04/2025.*AZDB_msg_backlog31" >> $override_file
echo "15/04/2025.*AZDB_fines_recon_status" >> $override_file
echo "16/04/2025.*AZDB_fines_recon_status" >> $override_file
echo "22/04/2025.*AZDB_fines_recon_status" >> $override_file
echo "04/06/2025.*AZDB_fines_recon_status" >> $override_file
echo "05/06/2025.*AZDB_fines_recon_status" >> $override_file
echo "06/06/2025.*AZDB_fines_recon_status" >> $override_file
echo "09/06/2025.*AZDB_fines_recon_status" >> $override_file
echo "10/06/2025.*AZDB_fines_recon_status" >> $override_file

echo "17/04/2025.*AZDB_update_processing_backlog77" >> $override_file

echo "22/04/2025.*AZDB_update_processing_backlog77" >> $override_file

echo "25/04/2025.*AZDB_db_message_log_error77.*23505.*duplicate key value violates unique constraint." >> $override_file
echo "25/04/2025.*AZDB_update_processing_backlog77" >> $override_file

echo "29/04/2025.*AZDB_update_processing_backlog30" >> $override_file
echo "29/04/2025.*AZDB_db_message_log_error77.*23505.*duplicate key value violates unique constraint" >> $override_file

echo "30/04/2025.*AZDB_update_processing_backlog77" >> $override_file

echo "02/05/2025.*AZDB_fines_recon_status" >> $override_file
echo "06/05/2025.*AZDB_fines_recon_status" >> $override_file
echo "07/05/2025.*AZDB_fines_recon_status" >> $override_file

echo "12/05/2025.*AZDB_db_threads.*active" >> $override_file

echo "23/05/2025.*AZDB_update_processing_backlog77" >> $override_file

echo "03/06/2025.*AZDB_fines_recon_status" >> $override_file

echo "17/06/2025.*AZDB_update_processing_backlog82" >> $override_file

echo "02/07/2025.*AZDB_update_processing_backlog77" >> $override_file

echo "AZDB_msg_backlog99" >> $override_file
echo "AZDB_update_processing_backlog99" >> $override_file
echo "AZDB_db_message_log_error99" >> $override_file

fi

testit=`cat $override_file | wc -l | xargs`

if [[ $testit -gt 0 ]];then

while read -r line;do
  line_overidden=0

  while read -r override;do
    if [[ `echo $line | grep -P "$override" | grep -Pi "(\,warn|\,not ok)"` ]];then
      if [[ $line_overidden == 0 ]];then
        echo $line | sed 's/,warn/OverRide,ok/g' | sed 's/,not ok/OverRide,ok/g' >> $OUTFILE.temp
        line_overidden=1
      fi
    fi
  done < $override_file

  if [[ $line_overidden == 0 ]];then
    echo $line >> $OUTFILE.temp
  fi
done < $OUTFILE.orig

mv $OUTFILE.temp $OUTFILE

fi
############################################################################
### Push CSV file to BAIS so it can be ingested and displayed in the AMD ###
############################################################################
if [[ 0 == 1 ]];then
if [[ $op_env == prod ]];then
echo "cat of /mnt/secrets/$KV_NAME/amd-sftp-pvt-key KV:"
cat /mnt/secrets/$KV_NAME/amd-sftp-pvt-key
fi
fi

cat /mnt/secrets/$KV_NAME/amd-sftp-pvt-key | sed 's/ /\n/g' > /tmp/ams-reporting/sftp-pvt-key.tmp
echo "-----BEGIN OPENSSH PRIVATE KEY-----" > /tmp/ams-reporting/sftp-pvt-key
grep -Pv "(BEGIN|OPENSSH|PRIVATE|KEY|END)" /tmp/ams-reporting/sftp-pvt-key.tmp >> /tmp/ams-reporting/sftp-pvt-key
echo  "-----END OPENSSH PRIVATE KEY-----" >> /tmp/ams-reporting/sftp-pvt-key
chmod 600 /tmp/ams-reporting/sftp-pvt-key

if [[ 0 == 1 ]];then
if [[ $op_env == prod ]];then
echo "cat of /tmp/ams-reporting/sftp-pvt-key REBUILT:"
cat /tmp/ams-reporting/sftp-pvt-key
cat /tmp/ams-reporting/sftp-pvt-key | sed 's/[\t ]//g;/^$/d' > /tmp/ams-reporting/sftp-pvt-key
echo "cat of /tmp/ams-reporting/sftp-pvt-key CLEANED:"
cat /tmp/ams-reporting/sftp-pvt-key
printf "\n"
ls -altr /mnt/secrets/$KV_NAME/
ls -altr /tmp/ams-reporting/
fi
fi

if [ -e /mnt/secrets/$KV_NAME/amd-sftp-endpoint ] && [ -e /mnt/secrets/$KV_NAME/amd-sftp-username ];then

sftp_username=`cat /mnt/secrets/$KV_NAME/amd-sftp-username`
sftp_endpoint=`cat /mnt/secrets/$KV_NAME/amd-sftp-endpoint | awk -F":" '{print $1}'`
sftp_port=`cat /mnt/secrets/$KV_NAME/amd-sftp-endpoint | awk -F":" '{print $2}'`

echo "event_username: $event_username" >> $OUTFILE_LOG
echo "postgres_username: $postgres_username" >> $OUTFILE_LOG
echo "confiscation_username: $confiscation_username" >> $OUTFILE_LOG
echo "fines_username: $fines_username" >> $OUTFILE_LOG
echo "maintenance_username: $maintenance_username" >> $OUTFILE_LOG
echo "sftp_username: $sftp_username" >> $OUTFILE_LOG
echo "sftp_endpoint: $sftp_endpoint" >> $OUTFILE_LOG
echo "sftp_port: $sftp_port" >> $OUTFILE_LOG

if [[ 0 == 1 ]];then
if [[ $op_env == prod ]];then
#ssh-keygen -vvv -t rsa -b 4096 -f /tmp/ams-reporting/ams-reporting -N ""
ssh-keygen -t rsa -b 4096 -f /tmp/ams-reporting/ams-reporting -N ""
mv /tmp/ams-reporting/ams-reporting.pub /tmp/ams-reporting/ams-reporting.pub.key
mv /tmp/ams-reporting/ams-reporting /tmp/ams-reporting/ams-reporting.pvt.key
echo "cat of ams-reporting.pub.key:"
cat /tmp/ams-reporting/ams-reporting.pub.key
echo "cat of ams-reporting.pvt.key:"
cat /tmp/ams-reporting/ams-reporting.pvt.key
fi
fi

echo "$(date "+%d/%m/%Y %T") Uploading the CSVs to BAIS" >> $OUTFILE_LOG
#tracert $sftp_endpoint >> $OUTFILE_LOG
#traceroute $sftp_endpoint >> $OUTFILE_LOG
#tracepath $sftp_endpoint >> $OUTFILE_LOG
echo "Firing off the sftp connection to BAIS..."
#sftp -vvv -P ${sftp_port} -oStrictHostKeyChecking=no -oHostKeyAlgorithms=+ssh-rsa -i /tmp/ams-reporting/sftp-pvt-key ${sftp_username}@${sftp_endpoint} << EOF
sftp -P ${sftp_port} -oStrictHostKeyChecking=no -oHostKeyAlgorithms=+ssh-rsa -i /tmp/ams-reporting/sftp-pvt-key ${sftp_username}@${sftp_endpoint} << EOF
put $OUTFILE
put $OUTFILE_STATS
quit
EOF

if [ $? -eq 0 ];then
bais_upload_errors=0
echo "$(date "+%d/%m/%Y %T") The CSVs have been successfully uploaded to BAIS" >> $OUTFILE_LOG
else
bais_upload_errors=1
echo "$(date "+%d/%m/%Y %T") Connection to BAIS has most probably timed out, turn on -vvv debug to diagnose further as necessary" >> $OUTFILE_LOG
fi

else

echo "$(date "+%d/%m/%Y %T") Cannot access BAIS KeyVault connection variables" >> $OUTFILE_LOG

fi
####################################################### CHECK 14
echo "[Check #14: Critical Logfile Errors]" >> $OUTFILE
echo "DateTime,CheckName,Status,Result" >> $OUTFILE
echo "$(date "+%d/%m/%Y %T") Starting Check #14" >> $OUTFILE_LOG

if [[ $bais_upload_errors == 1 ]];then
echo "$(date "+%d/%m/%Y %T"),AZDB_bais_upload,$bais_upload_errors,warn" >> $OUTFILE
else
echo "$(date "+%d/%m/%Y %T"),AZDB_bais_upload,$bais_upload_errors,ok" >> $OUTFILE
fi
echo "$(date "+%d/%m/%Y %T") Check #14 complete" >> $OUTFILE_LOG
############################################################### Script END ###############################################################
echo "cat of $OUTFILE:"
cat $OUTFILE
echo "cat of $OUTFILE_STATS:"
cat $OUTFILE_STATS
echo "cat of $OUTFILE_LOG:"
cat $OUTFILE_LOG
