# COVID-19 Data Analytics
## Objective
Analyze COVID-19 statistics using SQL queries to gain insights into global and country-wise trends.

## Tools Used 
- Database: MySQL  
- Interface: MySQL Workbench

## Database Schema
- covid_data → Stores daily records (date, country, confirmed, deaths, recovered, active)
- country_summary → Stores aggregated totals per country
- weekly_summary (VIEW) → Weekly aggregation

## Steps to Run
- Create database covid19_analytics.
- Run the SQL schema to create tables.
- Insert COVID-19 dataset into covid_data.
- Run cleaning queries to handle nulls.
- Execute analytical queries for insights.
- Use views for weekly summaries.

## Sample Queries
- Top 10 countries by confirmed cases
- Daily global trend of confirmed cases
- Weekly summary per country
- Recovery and death rates

## Conclusion 
The project demonstrates how SQL can be effectively used for real-world data analytics. By 
leveraging queries and views, the system provides insights into the global COVID-19 trends, 
country-wise comparisons, and recovery rates. This project highlights the importance of 
database systems in health data monitoring and decision-making.
