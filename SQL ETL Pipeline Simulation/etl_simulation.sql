CREATE DATABASE etl_simulation;
USE etl_simulation;

CREATE TABLE staging_sales (sale_id INT,customer_name VARCHAR(100),product VARCHAR(100),quantity INT,price DECIMAL(10,2),sale_date DATE);
#Data Cleaning
CREATE TABLE clean_sales AS SELECT DISTINCT * FROM staging_sales;
DELETE FROM clean_sales WHERE sale_id IS NULL OR customer_name IS NULL OR product IS NULL OR quantity IS NULL OR price IS NULL OR sale_date IS NULL;
SET SQL_SAFE_UPDATES = 1;

#production tables
CREATE TABLE production_sales (sale_id INT PRIMARY KEY,customer_name VARCHAR(100),product VARCHAR(100),quantity INT,
price DECIMAL(10,2),sale_date DATE);
INSERT INTO production_sales (sale_id, customer_name, product, quantity, price, sale_date) SELECT sale_id, customer_name, product, quantity, price, sale_date
FROM clean_sales AS src ON DUPLICATE KEY UPDATE customer_name = src.customer_name,product = src.product,quantity = src.quantity,price = src.price,
sale_date = src.sale_date;

#audit table
CREATE TABLE IF NOT EXISTS etl_audit (audit_id INT AUTO_INCREMENT PRIMARY KEY,table_name VARCHAR(100),rows_inserted INT,etl_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
INSERT INTO etl_audit (table_name, rows_inserted) SELECT 'production_sales', COUNT(*) FROM production_sales;

#Automate Cleanup with Trigger
DELIMITER $$

CREATE TRIGGER trg_remove_duplicate AFTER INSERT ON staging_sales FOR EACH ROW
BEGIN
    DELETE s1 FROM staging_sales s1
    INNER JOIN staging_sales s2 
    WHERE 
        s1.sale_id = s2.sale_id 
        AND s1.id > s2.id;
END$$

DELIMITER ;
SHOW TRIGGERS from etl_simulation;