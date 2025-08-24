# Data Warehouse Practice
Data Warehouse practice in Postgres.
  - Bash scripting for running DDL jobs and transformations
  - Tiered database schema using layers
      - Bronze Layer: Raw Data no transformations only cleaned data following business rules and requirements. Data Engineers are the only ones who should be using this layer.
      - Silver Layer: Transformed data this is where data is changed and cleaned further for data analysts and data engineers.
      - Gold Layer: Will be consisted of views for business purposes. Star Schema is being used.
  - Next Objective is to use a scheduler to automate the process and to import the final results into a dashboard tool such as PowerBI or Tableau.
