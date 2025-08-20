CREATE DATABASE AirlineDB;
USE AirlineDB;

#Flights Table
CREATE TABLE Flights (FlightID INT AUTO_INCREMENT PRIMARY KEY,FlightNo VARCHAR(10),Source VARCHAR(50),Destination VARCHAR(50),
DepartTime DATETIME,ArriveTime DATETIME,Fare DECIMAL(10,2));
#Customers Table
CREATE TABLE Customers (CustomerID INT AUTO_INCREMENT PRIMARY KEY,FirstName VARCHAR(50),LastName VARCHAR(50),Email VARCHAR(100));
#Bookings Table
CREATE TABLE Bookings (BookingID INT AUTO_INCREMENT PRIMARY KEY,CustomerID INT,FlightID INT,BookingDate DATETIME DEFAULT NOW(),
Status VARCHAR(20) DEFAULT 'CONFIRMED',FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
FOREIGN KEY (FlightID) REFERENCES Flights(FlightID));
#Seats Table
CREATE TABLE Seats (SeatID INT AUTO_INCREMENT PRIMARY KEY,FlightID INT,SeatNo VARCHAR(5),Status VARCHAR(20) DEFAULT 'AVAILABLE',
FOREIGN KEY (FlightID) REFERENCES Flights(FlightID));

#Flights Data
INSERT INTO Flights (FlightNo, Source, Destination, DepartTime, ArriveTime, Fare)
VALUES ('AI101', 'Nagpur', 'Delhi', '2025-08-22 10:00:00', '2025-08-22 12:00:00', 4500.00),
('AI102', 'Delhi', 'Mumbai', '2025-08-22 14:00:00', '2025-08-22 16:00:00', 5000.00);
#Customers Data
INSERT INTO Customers (FirstName, LastName, Email) VALUES ('Sakshi', 'Khangar', 'sakshi@mail.com'),('Rohit', 'Sharma', 'rohit@mail.com');
#Seats Data
INSERT INTO Seats (FlightID, SeatNo) VALUES (1,'1A'),(1,'1B'),(1,'2A'),(1,'2B'), (2,'1A'),(2,'1B'),(2,'2A'),(2,'2B');

#Show all flights & Seats
SELECT * FROM Flights;
SELECT * FROM Seats;
#Search Flight ( Nagpur -> Delhi)
SELECT * FROM Flights WHERE Source = 'Nagpur' AND Destination = 'Delhi';
#Show avaliable seats on Flight 1
SELECT SeatNo FROM Seats WHERE FlightID = 1 AND Status = 'AVAILABLE';
# Make a booking (customer 1 books seat 1A of flight 1)
INSERT INTO Bookings(CustomerID,FlightID, Status) VALUES (1,1,'CONFIRMED');
UPDATE Seats SET STATUS = 'BOOKED' WHERE FlightID=1 AND SeatNo = '1A';
#cancel a bookings
UPDATE Bookings SET STATUS = 'CANCELLED' WHERE BookingID = 1;
UPDATE Seats SET STATUS = 'AVALIABLE' WHERE FlightID=1 AND SeatNo = '1A';

#VIEW
CREATE VIEW AvailableSeats AS 
SELECT f.FlightNo, f.Source, f.Destination,s.SeatNo FROM Flights f
JOIN  Seats s ON f.FlightID = s.FlightID
WHERE s.STATUS = 'AVALIABLE';
SELECT * FROM AvailableSeats;

#Triggers (When a booking is cancelled, make the seat available again)
DELIMITER //
CREATE TRIGGER cancel_trigger_booking 
AFTER UPDATE ON Bookings 
FOR EACH ROW
BEGIN IF NEW.STATUS = 'CANCELLED' THEN UPDATE Seats SET STATUS = 'AVALIABLE' WHERE FlightID=NEW.FlightID AND SeatID IN (SELECT SeatID FROM Seats WHERE FlightID=NEW.FlightID);
  END IF;
END;
//
DELIMITER ;
#Triggers (When a new booking is created, mark the seat as BOOKED)
DELIMITER //
CREATE TRIGGER confirm_booking_trigger
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
UPDATE Seats 
SET Status='BOOKED'
WHERE FlightID=NEW.FlightID 
AND SeatNo='1A';
END;
//
DELIMITER ;
