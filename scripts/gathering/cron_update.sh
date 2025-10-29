#!/bin/bash
cd /home/usuario/BI_infrastructure/scripts/gathering
LOG_FILE="/home/usuario/BI_infrastructure/logs/erp_db_logs/gather.log"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting data update..." >> "$LOG_FILE"
/usr/bin/python3 ./script.py >> "$LOG_FILE" 2>&1
if [ $? -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Update completed successfully." >> "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR during update execution." >> "$LOG_FILE"
fi
echo -e "\e[31m------------------------------------------------------------\e[0m"
echo "------------------------------------------------------------" >> "$LOG_FILE"

