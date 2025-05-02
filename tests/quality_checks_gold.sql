/*
===============================================================================
Gold Layer Data Validation Checks
===============================================================================
Objective:
    This script conducts essential quality checks on the Gold Layer to confirm:
    - Surrogate key uniqueness in dimension tables.
    - Proper linkage between fact and dimension tables.
    - Integrity of relationships that support accurate analytics.

Note:
    - Any unexpected output from these queries indicates potential data quality issues 
      that should be reviewed and addressed promptly.
===============================================================================
*/

-- ====================================================================
-- Validate 'gold.dim_customer'
-- ====================================================================

-- Ensure customer_key is not duplicated in the customer dimension
-- Expected: Each key appears only once
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customer
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Validate 'gold.dim_product'
-- ====================================================================

-- Confirm product_key is unique within the product dimension table
-- Expected: No repeated keys
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_product
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Check Referential Integrity in 'gold.fact_sales'
-- ====================================================================

-- Identify sales records with customer_keys that don't exist in dim_customer
-- Expected: No unmatched customer_keys
SELECT 
    *
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customer dc 
    ON fs.customer_key = dc.customer_key
WHERE dc.customer_key IS NULL;

-- Identify sales records with product_keys that don't exist in dim_product
-- Expected: No unmatched product_keys
SELECT 
    *
FROM gold.fact_sales fs
LEFT JOIN gold.dim_product dp 
    ON fs.product_key = dp.product_key
WHERE dp.product_key IS NULL;
