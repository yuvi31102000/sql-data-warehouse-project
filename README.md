# sql-data-warehouse-project

## Project Overview:
This project showcases the development of a scalable SQL-based data warehouse that transforms raw operational data into a clean, business-ready analytical model. It leverages the Medallion Architecture (Bronze → Silver → Gold) to handle data ingestion, transformation, and modeling.

## Objective:
To improve business decision-making through accurate, consistent, and insightful data by implementing a robust ETL pipeline, backed by rigorous data quality checks.


## Data Architecture:
The data warehouse is structured into three layers:
![data_architecture](https://github.com/user-attachments/assets/4176d433-8e32-4817-b00b-bb9afc4f9910)

**Bronze Layer:** 
Raw data ingested from source systems (e.g., CRM and ERP) in CSV format, stored without transformations to preserve original records.

**Silver Layer:** 
Cleansed and standardized data, addressing issues like null values, duplicates, and inconsistent formatting to prepare for analytical processing.

**Gold Layer:**
Business-ready data modeled into a star schema, comprising fact and dimension views optimized for reporting and decision-making.


## Executive Summary
**Data Ingestion:** 
Loading raw CSV files into the Bronze layer tables.

**Data Transformation:** Applying SQL scripts to cleanse and standardize data in the Silver layer, including handling nulls, trimming spaces, and validating data types.Transformed and validated ~98% of Silver layer data using 25+ quality rules.

**Data Modeling:**
Creating views in the Gold layer that join and aggregate data into a star schema, facilitating efficient analytical queries.Ensured 100% referential integrity between dimension and fact views.

**Quality Checks:**
Implementing scripts to ensure data integrity, such as checking for duplicate keys and validating referential integrity between tables. Identified data quality issues (e.g., 12.6% null gender, 1.4% invalid dates) and resolved them during Silver-layer processing.


## Recommendation
**Implement Scheduled ETL Pipelines:**
Automate data ingestion and transformation workflows using orchestration tools like Apache Airflow, dbt, or SQL Server Agent.

**Add Incremental Load Support:**
Optimize ETL scripts to support incremental data updates instead of full reloads to reduce processing time and resource usage.

**Introduce Data Lineage Tracking:**
Add metadata logging to track data flow across Bronze → Silver → Gold layers, aiding in auditability and debugging.
