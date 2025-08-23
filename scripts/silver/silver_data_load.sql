-- CUSTOMER INFO TABLE --
\echo '======================================'
\echo 'Inserting Table Data to Silver Layer'
\echo '======================================'

\timing
\echo '--------------------------------------'
\echo 'Inserting into CRM CUST INFO TABLE'
\echo '--------------------------------------'
TRUNCATE TABLE silver.crm_cust_info;
INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_material_status,
	cst_gender,
	cst_create_date )

SELECT
	cst_id,
	cst_key,
	TRIM(cst_firstname) as cst_firstname,
	TRIM(cst_lastname) as cst_lastname,
	CASE WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
		 WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
		 ELSE 'n/a'
	END cst_material_status,
	CASE WHEN UPPER(TRIM(cst_gender)) = 'F' THEN 'Female'
		 WHEN UPPER(TRIM(cst_gender)) = 'M' THEN 'Male'
		 ELSE 'n/a'
	END cst_gender,
	cst_create_date
FROM (SELECT *,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_count
FROM bronze.crm_cust_info) t WHERE flag_count = 1;
\timing

\echo '--------------------------------------'
\echo 'Inserting into CRM PRD INFO TABLE'
\echo '--------------------------------------'
\timing
TRUNCATE silver.crm_prd_info;
INSERT INTO silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)

SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
	prd_nm,
	COALESCE(prd_cost, 0) as prd_cost,
	CASE UPPER(TRIM(prd_line))
		 WHEN 'M' THEN 'Mountain'
		 WHEN 'R' THEN 'Road'
		 WHEN 'S' THEN 'Other Sales'
		 WHEN 'T' THEN 'Touring'
		 ELSE 'n/a'
	END prd_line,
	CAST(prd_start_dt AS DATE),
	CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 day' AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info;
\timing

\echo '--------------------------------------'
\echo 'Inserting into CRM SALES DETAILS TABLE'
\echo '--------------------------------------'
\timing
TRUNCATE silver.crm_sales_details;
INSERT INTO silver.crm_sales_details (
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt::TEXT) != 8 THEN NULL
		 ELSE DATE(sls_order_dt::TEXT)
	END sls_order_dt,
	CASE WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt::TEXT) != 8 THEN NULL
		 ELSE DATE(sls_ship_dt::TEXT)
	END sls_ship_dt,
	CASE WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt::TEXT) != 8 THEN NULL
		 ELSE DATE(sls_due_dt::TEXT)
	END sls_due_dt,
	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
		 THEN sls_quantity * ABS(sls_price)
		 ELSE sls_sales
	END sls_sales,
	sls_quantity,
	CASE WHEN sls_price IS NULL OR sls_price <= 0
		 THEN sls_sales / NULLIF(sls_quantity, 0)
		 ELSE sls_price
	END sls_price
FROM bronze.crm_sales_details;
\timing

\echo '--------------------------------------'
\echo 'Inserting into ERP CUST AZ12'
\echo '--------------------------------------'
\timing
TRUNCATE silver.erp_cust_az12;
INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)

SELECT
	CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
		 ELSE cid
	END cid,
	CASE WHEN bdate > NOW() THEN NULL
		 ELSE bdate
	END bdate,
	CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		 ELSE 'n/a'
	END gen
FROM bronze.erp_cust_az12;
\timing

\echo '--------------------------------------'
\echo 'Inserting into ERP LOC A101'
\echo '--------------------------------------'
\timing
TRUNCATE silver.erp_loc_a101;
INSERT INTO silver.erp_loc_a101 (cid, cntry)

SELECT
	REPLACE(cid, '-', '') cid,
	CASE WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
		 WHEN UPPER(TRIM(cntry)) IN ('US', 'USA') THEN 'United States'
		 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		 ELSE TRIM(cntry)
	END cntry
FROM bronze.erp_loc_a101;
\timing

\echo '--------------------------------------'
\echo 'Inserting into ERP PX CAT G1V2'
\echo '--------------------------------------'
\timing
TRUNCATE silver.erp_px_cat_g1v2;
INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)

SELECT
	id,
	cat,
	subcat,
	maintenance
FROM bronze.erp_px_cat_g1v2;