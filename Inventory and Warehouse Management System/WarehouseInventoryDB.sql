CREATE DATABASE WarehouseInventoryDB;
USE WarehouseInventoryDB;
#Suppliers table
CREATE TABLE Suppliers(Suppliers_id INT AUTO_INCREMENT PRIMARY KEY,Supplier_Name VARCHAR(200) NOT NULL,Contact_info varchar(500));
#Product Table
CREATE TABLE Products(product_ID INT PRIMARY KEY AUTO_INCREMENT,product_Name VARCHAR(200) NOT NULL,supplier_ID INT,
Unit_Price DECIMAL(10,2) NOT NULL,Reorder_level INT NOT NULL,FOREIGN KEY (supplier_ID) REFERENCES Suppliers(Suppliers_id));
#Warehouse Table
CREATE TABLE Warehouse(warehouse_id INT PRIMARY KEY AUTO_INCREMENT,warehouse_name VARCHAR(200),Location VARCHAR(100) NOT NULL);
#Stock Table
CREATE TABLE Stock(stock_id INT PRIMARY KEY AUTO_INCREMENT,product_ID INT,warehouse_id INT,Quantity INT NOT NULL,
FOREIGN KEY (product_ID) REFERENCES Products(product_ID),FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id));

#Insert Suppliers
INSERT INTO Suppliers (Supplier_Name,Contact_info) VALUES('Supplier A', 'contact@supplierA.com'),('Supplier B', 'contact@supplierB.com');
#Insert Products
INSERT INTO Products (product_name, supplier_id, unit_price, reorder_level) VALUES('Product 1', 1, 10.00, 5),('Product 2', 1, 15.00, 10),('Product 3', 2, 20.00, 3);
#Insert Warehouses
INSERT INTO Warehouse (warehouse_name, location) VALUES('Warehouse 1', 'Location A'),('Warehouse 2', 'Location B');
#Insert Stock
INSERT INTO Stock (product_id, warehouse_id, quantity) VALUES(1, 1, 10),(2, 1, 5),(3, 2, 2);

#Queries to check stock levels 
SELECT p.product_Name ,w.warehouse_name,s.Quantity FROM Stock s
JOIN Products p ON s.product_ID=p.product_ID
JOIN Warehouse w ON s.warehouse_id = w.warehouse_id;

#Reorder alerts
SELECT p.product_Name ,s.Quantity,p.Reorder_level FROM Stock s
JOIN Products p ON s.Product_ID = P.product_ID WHERE s.Quantity < p.Reorder_level;

#Triggers for low-stock notification.
DELIMITER //
CREATE trigger 	low_stock_notification
AFTER UPDATE ON Stock FOR EACH ROW BEGIN 
IF NEW.quantity < (SELECT reorder_level FROM Products WHERE product_id = NEW.product_id) THEN
INSERT INTO Notifications (message) VALUES (CONCAT('Low stock alert for ', (SELECT product_name FROM Products WHERE product_id = NEW.product_id)));
    END IF;
END;
//
#stored procedure to transfer stock
DELIMITER //

CREATE PROCEDURE TransferStock(IN p_product_id INT,IN p_from_warehouse_id INT,IN p_to_warehouse_id INT,IN p_quantity INT)
BEGIN DECLARE current_quantity INT;
#Check current stock in the from warehouse
SELECT quantity INTO current_quantity FROM Stock WHERE product_id = p_product_id AND warehouse_id = p_from_warehouse_id;
IF current_quantity >= p_quantity THEN
#Deduct from the from warehouse
UPDATE Stock SET quantity = quantity - p_quantity WHERE product_id = p_product_id AND warehouse_id = p_from_warehouse_id;
#Add to the to warehouse
INSERT INTO Stock (product_id, warehouse_id, quantity)VALUES (p_product_id, p_to_warehouse_id, p_quantity)ON DUPLICATE KEY UPDATE quantity = quantity + p_quantity;
ELSE SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock for transfer';
END IF;
END;
//

DELIMITER ;
#Notification Table for trigger
CREATE TABLE Notifications (notification_id INT PRIMARY KEY AUTO_INCREMENT,message VARCHAR(500),created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
#Test Trigger
UPDATE Stock SET quantity = 2 WHERE product_id = 1 AND warehouse_id = 1;
SELECT * FROM Notifications;

#total stock of a product across all warehouses
SELECT p.product_name, SUM(s.quantity) AS total_quantity FROM Stock s JOIN Products p ON s.product_id = p.product_id GROUP BY p.product_name;

#Products below reorder level across all warehouses
SELECT p.product_name, SUM(s.quantity) AS total_quantity, p.reorder_level FROM Stock s JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_name, p.reorder_level HAVING total_quantity < p.reorder_level;