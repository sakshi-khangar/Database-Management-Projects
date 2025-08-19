CREATE DATABASE OnlineRetailDB;
USE OnlineRetailDB;

#Customer Table
CREATE TABLE Customer(CustomerID INT PRIMARY KEY AUTO_INCREMENT,Name VARCHAR(50),Email VARCHAR(100) UNIQUE NOT NULL,Phone VARCHAR(15),Address TEXT);
#Product Table
CREATE TABLE Products(ProductID INT PRIMARY KEY AUTO_INCREMENT,Name VARCHAR(100) NOT NULL,Category VARCHAR(50),Price DECIMAL (10,2) NOT NULL,StockQty INT DEFAULT 0);
#Order Table
CREATE TABLE Orders (OrderID INT PRIMARY KEY AUTO_INCREMENT,CustomerID INT ,OrderDate DATE NOT NULL,Status VARCHAR(20) DEFAULT 'Pending',FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)); 
#Order Details Table 
CREATE TABLE OrderDetails (OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,OrderID INT,ProductID INT,Quantity INT NOT NULL,TotalPrice DECIMAL(10,2) NOT NULL,FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),FOREIGN KEY (ProductID) REFERENCES Products(ProductID));
#Payments Table
CREATE TABLE Payments (PaymentID INT PRIMARY KEY AUTO_INCREMENT,OrderID INT,PaymentDate DATE NOT NULL,Amount DECIMAL(10,2) NOT NULL,Method VARCHAR(20),FOREIGN KEY (OrderID) REFERENCES Orders(OrderID));

##INSERT SAMPLE DATA
#Customers Data
INSERT INTO Customer (Name, Email, Phone, Address) VALUES('Rahul Sharma', 'rahul@gmail.com', '9876543210', 'Nagpur'),('Priya Singh', 'priya@gmail.com', '9876501234', 'Pune'),('Amit Verma', 'amit@gmail.com', '9876005678', 'Mumbai');
#Products Data
INSERT INTO Products (Name, Category, Price, StockQty) VALUES('Laptop', 'Electronics', 55000, 20),('Smartphone', 'Electronics', 20000, 50),('Headphones', 'Accessories', 2000, 100),('Shoes', 'Fashion', 3000, 70);
#Orders Data
INSERT INTO Orders (CustomerID, OrderDate, Status) VALUES(1, '2025-08-01', 'Completed'),(2, '2025-08-02', 'Completed'),(3, '2025-08-03', 'Pending');
#OrderDetails Data
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, TotalPrice) VALUES(1, 1, 1, 55000),(1, 3, 2, 4000),(2, 2, 1, 20000),(2, 4, 1, 3000),(3, 1, 1, 55000);
#Payments Data
INSERT INTO Payments (OrderID, PaymentDate, Amount, Method) VALUES(1, '2025-08-01', 59000, 'UPI'),(2, '2025-08-02', 23000, 'Credit Card');

#Total sales per customer
SELECT C.Name, SUM(P.Amount) AS TotalSpent FROM Customer C JOIN Orders O ON C.CustomerID = O.CustomerID JOIN Payments P ON O.OrderID = P.OrderID GROUP BY C.Name;
#Best Selling Product
SELECT P.Name, SUM(OD.Quantity) AS TotalSold FROM Products P JOIN OrderDetails OD ON P.ProductID = OD.ProductID GROUP BY P.Name ORDER BY TotalSold DESC;
#Monthly Sales Report
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS Month, SUM(OD.TotalPrice) AS Sales FROM Orders O JOIN OrderDetails OD ON O.OrderID = OD.OrderID GROUP BY Month;
#Pending Orders
#payment Summary by Method
SELECT Method, SUM(Amount) AS Total FROM Payments GROUP BY Method;
#Customer Order Summary
CREATE VIEW CustomerOrderSummary AS SELECT C.Name, O.OrderID, SUM(OD.TotalPrice) AS OrderTotal, O.Status FROM Customer C JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN OrderDetails OD ON O.OrderID = OD.OrderID GROUP BY C.Name, O.OrderID, O.Status;