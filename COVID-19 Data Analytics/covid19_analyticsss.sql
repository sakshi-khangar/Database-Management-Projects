CREATE DATABASE covid19_analytics;
USE covid19_analytics;

#covid_data Table
CREATE TABLE covid_data (id INTEGER PRIMARY KEY AUTO_INCREMENT,report_date DATE NOT NULL,country TEXT NOT NULL,confirmed INTEGER DEFAULT 0,
deaths INTEGER DEFAULT 0,recovered INTEGER DEFAULT 0,active INTEGER DEFAULT 0);
#country_summary Table
CREATE TABLE country_summary (country VARCHAR(100) PRIMARY KEY,total_confirmed INTEGER DEFAULT 0,total_deaths INTEGER DEFAULT 0,
total_recovered INTEGER DEFAULT 0,total_active INTEGER DEFAULT 0);

#covid_data Data
INSERT INTO covid_data (report_date, country, confirmed, deaths, recovered, active) VALUES('2020-03-01', 'India', 3, 0, 0, 3),
('2020-03-02', 'India', 5, 0, 0, 5),('2020-03-03', 'India', 28, 0, 3, 25),('2020-03-01', 'USA', 74, 1, 0, 73),
('2020-03-02', 'USA', 98, 6, 0, 92),('2020-03-03', 'USA', 125, 9, 2, 114),('2020-03-01', 'Italy', 1700, 41, 83, 1576),
('2020-03-02', 'Italy', 2036, 52, 149, 1835),('2020-03-03', 'Italy', 2502, 79, 160, 2263);
#country_summary Data
INSERT INTO country_summary (country, total_confirmed, total_deaths, total_recovered, total_active) VALUES('India', 28, 0, 3, 25),
('USA', 125, 9, 2, 114),('Italy', 2502, 79, 160, 2263);
SELECT * FROM covid_data;
SELECT * FROM country_summary;

-- Clean and transform data
#Remove rows with null country or date
DELETE FROM covid_data
WHERE country IS NULL OR report_date IS NULL;
#Update null numeric values to 0
UPDATE covid_data
SET confirmed = 0 WHERE confirmed IS NULL;
UPDATE covid_data
SET deaths = 0 WHERE deaths IS NULL;
UPDATE covid_data
SET recovered = 0 WHERE recovered IS NULL;
UPDATE covid_data
SET active = 0 WHERE active IS NULL;

SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;

-- analytical queries
#Top 10 countries by total confirmed cases
SELECT country, SUM(confirmed) AS total_confirmed FROM covid_data GROUP BY country ORDER BY total_confirmed DESC LIMIT 10;
#Top 10 countries by total deaths
SELECT country, SUM(deaths) AS total_deaths FROM covid_data GROUP BY country ORDER BY total_deaths DESC LIMIT 10;
#Daily global trend of confirmed cases
SELECT report_date, SUM(confirmed) AS daily_confirmed FROM covid_data GROUP BY report_date ORDER BY report_date;
#Daily new confirmed cases per country
SELECT country,report_date,confirmed,confirmed - LAG(confirmed, 1, 0) OVER (PARTITION BY country ORDER BY report_date) AS new_cases
FROM covid_data ORDER BY country, report_date;
#Country-wise recovery and death rates
SELECT country,SUM(confirmed) AS total_confirmed,SUM(deaths) AS total_deaths,SUM(recovered) AS total_recovered,
ROUND(100.0 * SUM(recovered) / SUM(confirmed), 2) AS recovery_rate_percent,ROUND(100.0 * SUM(deaths) / SUM(confirmed), 2) AS death_rate_percent
FROM covid_data GROUP BY country ORDER BY total_confirmed DESC;
#Export view for weekly summary
CREATE VIEW weekly_summary AS SELECT country,DATE_FORMAT(report_date, '%Y-%u') AS week,   
SUM(confirmed) AS weekly_confirmed,SUM(deaths) AS weekly_deaths,SUM(recovered) AS weekly_recovered FROM covid_data
GROUP BY country, week ORDER BY country, week;
SELECT * FROM weekly_summary;

#Updating country_summary Table
TRUNCATE TABLE country_summary;
INSERT INTO country_summary (country, total_confirmed, total_deaths, total_recovered, total_active)
SELECT country, SUM(confirmed), SUM(deaths), SUM(recovered), SUM(active) FROM covid_data GROUP BY country;
SELECT * FROM country_summary;

