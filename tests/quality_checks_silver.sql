/*
===============================================================================
Silver Layer Data Quality Validation
===============================================================================
Objective:
    This script runs validation queries to assess data completeness, integrity, 
    and consistency across Silver Layer source tables. These checks aim to:
    - Detect anomalies like nulls, duplicates, or incorrect formats.
    - Validate business logic such as date and sales calculations.
    - Support clean and reliable transformation into the Gold Layer.

Note:
    - Review any returned results as they likely indicate data quality issues.
===============================================================================
*/

-- ====================================================================
-- Validate 'silver.crm_cust_info'
-- ====================================================================

-- Detect duplicate or missing customer IDs (Primary Key)
-- Expected: Each cst_id should be unique and non-null
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Identify extra spaces in customer key fields
-- Expected: All keys should be trimmed
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Review values in marital status for format and consistency
-- Expected: Limited, standardized values (e.g., 'Married', 'Single')
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

-- ====================================================================
-- Validate 'silver.crm_prd_info'
-- ====================================================================

-- Detect duplicate or null product IDs (Primary Key)
-- Expected: Unique and complete prd_id values
SELECT 
    prd_id,
    COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Identify product names with unwanted whitespace
-- Expected: Names should be properly trimmed
SELECT 
    prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for null or negative product cost values
-- Expected: prd_cost must be positive and not null
SELECT 
    prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Review product line values for consistency
-- Expected: Clean, standardized list of product lines
SELECT DISTINCT 
    prd_line 
FROM silver.crm_prd_info;

-- Verify logical consistency between product start and end dates
-- Expected: prd_start_dt should not be later than prd_end_dt
SELECT 
    * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Validate 'silver.crm_sales_details'
-- ====================================================================

-- Identify improperly formatted or invalid sales due dates
-- Expected: Valid 8-digit date within acceptable range
SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
    OR LEN(sls_due_dt) != 8 
    OR sls_due_dt > 20500101 
    OR sls_due_dt < 19000101;

-- Ensure sales order dates do not exceed shipping or due dates
-- Expected: sls_order_dt should be earlier than or equal to both
SELECT 
    * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Validate sales computation: sales = quantity * price
-- Expected: Values should align and be positive and complete
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- Validate 'silver.erp_cust_az12'
-- ====================================================================

-- Check for birthdates outside expected human lifespan range
-- Expected: bdate should be between 1924-01-01 and today
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > GETDATE();

-- Review gender data for consistency
-- Expected: Limited distinct values (e.g., 'M', 'F', 'Other')
SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;

-- ====================================================================
-- Validate 'silver.erp_loc_a101'
-- ====================================================================

-- Review country field values for standardization
-- Expected: Clean, consistent country codes or names
SELECT DISTINCT 
    cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Validate 'silver.erp_px_cat_g1v2'
-- ====================================================================

-- Identify leading/trailing spaces in categorical fields
-- Expected: All text values should be trimmed
SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Review maintenance values for consistency
-- Expected: Distinct values should be valid and standardized
SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;
