CREATE DATABASE RealEstateAnalytics;
USE RealEstateAnalytics;

#Agents Table
CREATE TABLE Agents (agent_id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(100),contact VARCHAR(50));
#Buyers Table
CREATE TABLE Buyers (buyer_id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(100),contact VARCHAR(50));
#Properties Table
CREATE TABLE Properties (property_id INT AUTO_INCREMENT PRIMARY KEY,address VARCHAR(200),city VARCHAR(50),state VARCHAR(50),
zip_code VARCHAR(10),price DECIMAL(12,2),listed_date DATE,agent_id INT,FOREIGN KEY (agent_id) REFERENCES Agents(agent_id));
#Transactions Table
CREATE TABLE Transactions (transaction_id INT AUTO_INCREMENT PRIMARY KEY,property_id INT,buyer_id INT,sale_price DECIMAL(12,2),
sale_date DATE,FOREIGN KEY (property_id) REFERENCES Properties(property_id),FOREIGN KEY (buyer_id) REFERENCES Buyers(buyer_id));

#Agents Data
INSERT INTO Agents (name, contact) VALUES('Rajesh Sharma', '9876543210'),('Anita Deshmukh', '9123456780'),('Vikram Singh', '9988776655');
#Buyers Data
INSERT INTO Buyers (name, contact) VALUES('Rahul Patil', '9000000001'),('Sonia Gupta', '9000000002'),('Amit Joshi', '9000000003');
#Properties Data
INSERT INTO Properties (address, city, state, zip_code, price, listed_date, agent_id) VALUES
('123 Maple Street', 'Nagpur', 'MH', '440001', 4500000, '2025-08-01', 1),
('456 Pine Avenue', 'Nagpur', 'MH', '440002', 5200000, '2025-08-05', 2),
('789 Oak Road', 'Pune', 'MH', '411001', 7500000, '2025-08-10', 3),
('321 Cedar Lane', 'Nagpur', 'MH', '440003', 4800000, '2025-08-12', 1),
('654 Birch Blvd', 'Pune', 'MH', '411002', 7000000, '2025-08-15', 2);
#Transactions Data
INSERT INTO Transactions (property_id, buyer_id, sale_price, sale_date) VALUES(1, 1, 4550000, '2025-08-07'),(2, 2, 5250000, '2025-08-10'),
(3, 3, 7550000, '2025-08-20'),(4, 1, 4850000, '2025-08-18');
	
#Average Price by City
SELECT city ,AVG(price) AS avg_price FROM Properties GROUP BY city ORDER BY avg_price DESC;

#views for high-demand areas
CREATE VIEW HighDemandArea AS SELECT p.city ,COUNT(*) AS sold_count FROM Transactions t
JOIN Properties p ON t.property_id = p.property_id GROUP BY p.city HAVING COUNT(*) > 1;
SELECT * FROM HighDemandArea;

#Price Trend reports
SELECT city, listed_date, price,AVG(price) OVER (PARTITION BY city ORDER BY listed_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) 
AS moving_avg_price FROM Properties ORDER BY city, listed_date;