# sql-data-warehouse-project

Background Overview
This project demonstrates the development of a modern data warehouse using SQL Server, following the Medallion Architecture (Bronze, Silver, Gold layers).
 It encompasses the entire data pipeline, from raw data ingestion to the creation of business-ready datasets, ensuring data integrity and facilitating insightful analytics.

Data Structure Overview
The data warehouse is structured into three layers:

Bronze Layer: Raw data ingested from source systems (e.g., CRM and ERP) in CSV format, stored without transformations to preserve original records.

Silver Layer: Cleansed and standardized data, addressing issues like null values, duplicates, and inconsistent formatting to prepare for analytical processing.

Gold Layer: Business-ready data modeled into a star schema, comprising fact and dimension views optimized for reporting and decision-making.

Executive Summary
Key components of the project include:

Data Ingestion: Loading raw CSV files into the Bronze layer tables.

Data Transformation: Applying SQL scripts to cleanse and standardize data in the Silver layer, including handling nulls, trimming spaces, and validating data types.

Data Modeling: Creating views in the Gold layer that join and aggregate data into a star schema, facilitating efficient analytical queries.

Quality Checks: Implementing scripts to ensure data integrity, such as checking for duplicate keys and validating referential integrity between tables.
