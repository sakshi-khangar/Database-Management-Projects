# SQL ETL Pipeline Simulation
## Project Overview
This project demonstrates a simple ETL (Extract, Transform, Load) pipeline built entirely in MySQL Workbench.
- Extract: Import raw sales data (CSV) into a staging table.
- Transform: Clean and remove duplicates/nulls.
- Load: Insert transformed data into a production table.
- Audit: Track insert operations in an audit log.
- Automation: Use triggers for automatic cleanup and logging.

## Tools Used
- Database: MySQL Workbench
- Language: SQL

## Deliverables
- SQL Script: etl_pipeline.sql
- Audit Logs: etl_audit.csv
- Project Report: Project_Report.pdf
  
## Conclusion
This project successfully simulates a basic ETL pipeline in SQL, ensuring data is extracted, cleaned, transformed, loaded into a production system, and logged for auditing. 
It provides a foundation for understanding ETL workflows without external ETL tools.
