CREATE DATABASE finance_tracker;
USE finance_tracker;

#Users Table
CREATE TABLE Users (user_id INT PRIMARY KEY AUTO_INCREMENT,name VARCHAR(100),email VARCHAR(100) UNIQUE);
#Categories Table
CREATE TABLE Categories (category_id INT PRIMARY KEY AUTO_INCREMENT,category_name VARCHAR(100));
#Income Table
CREATE TABLE Income (income_id INT PRIMARY KEY AUTO_INCREMENT,user_id INT,amount DECIMAL(10,2),source VARCHAR(100),income_date DATE,
FOREIGN KEY (user_id) REFERENCES Users(user_id));
#Expenses Table
CREATE TABLE Expenses (expense_id INT PRIMARY KEY AUTO_INCREMENT,user_id INT,category_id INT,amount DECIMAL(10,2),expense_date DATE,
FOREIGN KEY (user_id) REFERENCES Users(user_id),FOREIGN KEY (category_id) REFERENCES Categories(category_id));

#Users Data
INSERT INTO Users (name, email) VALUES ('Sakshi', 'sakshi@example.com'),('Rohan', 'rohan@example.com');
#Categories Data
INSERT INTO Categories (category_name) VALUES ('Food'), ('Rent'), ('Travel'), ('Shopping');
#Income Data
INSERT INTO Income (user_id, amount, source, income_date) VALUES(1, 25000, 'Salary', '2025-08-01'),(2, 30000, 'Salary', '2025-08-01');
#Expenses Data
INSERT INTO Expenses (user_id, category_id, amount, expense_date) VALUES(1, 1, 3000, '2025-08-02'),(1, 2, 8000, '2025-08-05'),
(1, 3, 2000, '2025-08-10'),(2, 1, 4000, '2025-08-03'),(2, 4, 7000, '2025-08-07');

#summarize expenses monthly
SELECT user_id,DATE_FORMAT(expense_date, '%Y-%m') AS month, SUM(amount) AS total_expenses FROM Expenses GROUP BY user_id, month;

#GROUP BY for category-wise spending
SELECT u.name, c.category_name, SUM(e.amount) AS total_spent FROM Expenses e JOIN Users u ON e.user_id = u.user_id
JOIN Categories c ON e.category_id = c.category_id GROUP BY u.name, c.category_name;

#views for balance tracking
CREATE VIEW Balance_Tracking AS SELECT u.name,(SELECT SUM(amount) FROM Income i WHERE i.user_id = u.user_id) -
(SELECT SUM(amount) FROM Expenses e WHERE e.user_id = u.user_id) AS balance FROM Users u;
SELECT * FROM Balance_Tracking;