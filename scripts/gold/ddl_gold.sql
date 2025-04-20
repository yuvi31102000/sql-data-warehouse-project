USE DataWarehouse;

-----------------------------------------------------------------------------------

IF OBJECT_ID('gold.dim_customer', 'V') IS NOT NULL
    DROP VIEW gold.dim_customer ;
GO

CREATE OR ALTER VIEW gold.dim_customer AS
SELECT
    ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key,          -- surrogate key
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	ci.cst_marital_status AS marital_status,
	lo.cntry AS country,
	CASE
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	ca.bdate AS birth_date,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS lo ON ci.cst_key = lo.cid;


-- Note: After joining the table, check if any duplicates were introduced by the join logic


------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('gold.dim_product', 'V') IS NOT NULL
    DROP VIEW gold.dim_product ;
GO

CREATE VIEW gold.dim_product AS
SELECT 
    ROW_NUMBER() OVER(ORDER BY cp.prd_id, cp.prd_start_dt) AS product_key,  -- surrogate key
	cp.prd_id AS product_id,
	cp.prd_key AS product_number,
	cp.prd_nm AS product_name,
	cp.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	cp.prd_cost AS cost,
	pc.maintenance AS maintenance,
	cp.prd_start_dt AS start_date
FROM silver.crm_prd_info AS cp
LEFT JOIN silver.erp_px_cat_g1v2 AS pc ON cp.cat_id = pc.id
WHERE prd_end_dt IS NULL  -- Get only the current products and exclude the historical data



------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales ;
GO

CREATE OR ALTER VIEW gold.fact_sales AS
SELECT 
	sls_ord_num AS order_number,
	dp.product_key,    -- surrogate key from dim_product
	dc.customer_key,   -- surrogate key from dim_customer
	sls_order_dt AS order_date,
	sls_ship_dt AS shipping_date,
	sls_due_dt AS due_date,
	sls_sales AS sales_amount,
	sls_quantity AS qunatity,
	sls_price AS price
FROM silver.crm_sales_details s
LEFT JOIN gold.dim_customer AS dc ON s.sls_cust_id = dc.customer_id
LEFT JOIN gold.dim_product AS dp ON s.sls_prd_key = dp.product_number


-----------------------------------------------------------------------------------------

-- Foreign key integrity (Dimensions)
/*
SELECT 
	*
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customer dc ON fs.customer_key = dc.customer_key
WHERE dc.customer_key IS NULL;

SELECT 
	*
FROM gold.fact_sales fs
LEFT JOIN gold.dim_product dp ON fs.product_key = dp.product_key
WHERE dp.product_key IS NULL;
*/

