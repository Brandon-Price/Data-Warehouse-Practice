#!/bin/bash
source 'C:\Users\Brand\Documents\Engineering\Projects\Data Engineering\Data-Warehouse-Practice\.env'
export PGPASSWORD=$DB_PASSWORD

psql -U $DB_USER -d $DB_NAME -f "C:\Users\Brand\Documents\Engineering\Projects\Data Engineering\Data-Warehouse-Practice\scripts\silver\silver_data_load.sql" 

if [ $? -ne 0 ]; then
    echo "Error: psql command failed."
    exit 1
else
    echo "success"
fi