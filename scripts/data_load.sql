\echo "====================================="
\echo "Loading Bronze Layer"
\echo "====================================="

\timing
\echo ">> Truncating All Tables"
TRUNCATE TABLE bronze.crm_cust_info, bronze.crm_prd_info, bronze.crm_sales_details, bronze.erp_cust_az12, bronze.erp_loc_a101, bronze.erp_px_cat_g1v2;
\timing
\echo "====================================="
\timing
\echo "-------------------------------------"
\echo "Loading CRM Tables"
\echo "-------------------------------------"
\COPY bronze.crm_cust_info FROM 'C:\Users\Brand\Documents\Engineering\Projects\Data Engineering\Data-Warehouse-Practice\datasets\source_crm\cust_info.csv' DELIMITER ',' CSV HEADER;

\COPY bronze.crm_prd_info FROM 'C:\Users\Brand\Documents\Engineering\Projects\Data Engineering\Data-Warehouse-Practice\datasets\source_crm\prd_info.csv' DELIMITER ',' CSV HEADER; 

\COPY bronze.crm_sales_details FROM 'C:\Users\Brand\Documents\Engineering\Projects\Data Engineering\Data-Warehouse-Practice\datasets\source_crm\sales_details.csv' DELIMITER ',' CSV HEADER; 
\timing
\echo "====================================="
\timing
\echo "-------------------------------------"
\echo "Loading ERP Tables"
\echo "-------------------------------------"
\COPY bronze.erp_cust_az12 FROM 'C:\Users\Brand\Documents\Engineering\Projects\Data Engineering\Data-Warehouse-Practice\datasets\source_erp\CUST_AZ12.csv' DELIMITER ',' CSV HEADER;

\COPY bronze.erp_loc_a101 FROM 'C:\Users\Brand\Documents\Engineering\Projects\Data Engineering\Data-Warehouse-Practice\datasets\source_erp\LOC_A101.csv' DELIMITER ',' CSV HEADER;

\COPY bronze.erp_px_cat_g1v2 FROM 'C:\Users\Brand\Documents\Engineering\Projects\Data Engineering\Data-Warehouse-Practice\datasets\source_erp\PX_CAT_G1V2.csv' DELIMITER ',' CSV HEADER;
\timing