CREATE DATABASE AttendanceDB;
USE AttendanceDB;

#Department Table
CREATE TABLE Departments (DepartmentID INT PRIMARY KEY AUTO_INCREMENT,Name VARCHAR(50) NOT NULL);
#Roles Table
CREATE TABLE Roles (RoleID INT PRIMARY KEY AUTO_INCREMENT,Title VARCHAR(50) NOT NULL,Salary DECIMAL(10,2) NOT NULL);
#Employees Table
CREATE TABLE Employees (EmployeeID INT PRIMARY KEY AUTO_INCREMENT,Name VARCHAR(100) NOT NULL,Email VARCHAR(100) UNIQUE,DepartmentID INT,
RoleID INT,JoinDate DATE,FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),FOREIGN KEY (RoleID) REFERENCES Roles(RoleID));
#Attendance Table
CREATE TABLE Attendance (AttendanceID INT PRIMARY KEY AUTO_INCREMENT,EmployeeID INT,Date DATE NOT NULL,Status VARCHAR(20) 
CHECK (Status IN ('Present', 'Absent', 'Leave')),CheckIn TIME,CheckOut TIME,FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID));

DROP Table Attendance;

#Departments Data 
INSERT INTO Departments (Name) VALUES
('HR'), ('IT'), ('Finance');
#Roles Data
INSERT INTO Roles (Title, Salary) VALUES('HR Manager', 60000),('Software Engineer', 50000),('Accountant', 45000);

DELIMITER $$

CREATE PROCEDURE InsertDummyData()
BEGIN
  DECLARE i INT DEFAULT 1;
  
#200 Employees Insert
  WHILE i <= 200 DO
    INSERT INTO Employees (Name, Email, DepartmentID, RoleID, JoinDate)
    VALUES (
      CONCAT('Employee_', i),
      CONCAT('employee', i, '@company.com'),
      (i % 3) + 1,
      (i % 3) + 1,
      DATE_SUB(CURDATE(), INTERVAL i DAY)
    );
    SET i = i + 1;
  END WHILE;
  
  SET i = 1;
  
#200 Attendance Insert
  WHILE i <= 200 DO
    INSERT INTO Attendance (EmployeeID, Date, Status, CheckIn, CheckOut)
    VALUES (
      (i % 200) + 1,
      DATE_SUB(CURDATE(), INTERVAL i DAY),
      'Present',
      MAKETIME(9, FLOOR(RAND()*59), 0),
      MAKETIME(17, FLOOR(RAND()*59), 0)
    );
    SET i = i + 1;
  END WHILE;

END$$

DELIMITER ;

#Call the procedure
CALL InsertDummyData();

SELECT COUNT(*) FROM Employees;
SELECT * FROM Employees LIMIT 10;


#Monthly Attendance Report
SELECT E.Name, COUNT(A.Status) AS DaysPresent FROM Employees E JOIN Attendance A ON E.EmployeeID = A.EmployeeID
WHERE A.Status = 'Present' AND MONTH(A.Date) = 8 GROUP BY E.Name;
#Late Arrivals (After 9:00 AM)
SELECT E.Name, A.Date, A.CheckIn FROM Employees E JOIN Attendance A ON E.EmployeeID = A.EmployeeID WHERE A.CheckIn > '09:00:00';
#Department-Wise Employee Count
SELECT D.Name AS Department, COUNT(E.EmployeeID) AS TotalEmployees FROM Departments D LEFT JOIN Employees E ON D.DepartmentID = E.DepartmentID GROUP BY D.Name;
#Calculate Total Work Hours
SELECT E.Name, A.Date, TIMESTAMPDIFF(HOUR, A.CheckIn, A.CheckOut) AS HoursWorked FROM Employees E
JOIN Attendance A ON E.EmployeeID = A.EmployeeID WHERE A.Status = 'Present';
#Employees on Leave
SELECT E.Name, A.Date FROM Employees E JOIN Attendance A ON E.EmployeeID = A.EmployeeID WHERE A.Status = 'Leave';

#Trigger: Auto Mark Late if CheckIn after 09:15
DELIMITER //
CREATE TRIGGER mark_late BEFORE INSERT ON Attendance
FOR EACH ROW
BEGIN
  IF NEW.CheckIn > '09:15:00' THEN
    SET NEW.Status = 'Late';
  END IF;
END;
//
DELIMITER ;

#Function: Calculate Total Work Hours in a Month
DELIMITER //
CREATE FUNCTION TotalWorkHours(emp_id INT, month_no INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total_hours INT;
  SELECT SUM(TIMESTAMPDIFF(HOUR, CheckIn, CheckOut))
  INTO total_hours
  FROM Attendance
  WHERE EmployeeID = emp_id
    AND MONTH(Date) = month_no
    AND Status = 'Present';
  RETURN total_hours;
END;
//
DELIMITER ;

SELECT * FROM Attendance WHERE Date = '2025-08-19' AND EmployeeID = 1;
SELECT TotalWorkHours(1, 8);
SHOW TRIGGERS;
SHOW FUNCTION STATUS WHERE Db = 'attendanceDB';