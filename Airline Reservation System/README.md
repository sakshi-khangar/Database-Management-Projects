## Airline Reservation System
# Abstract
This project is about creating a simple **Airline Reservation System** using SQL. The system manages **flights, customers, bookings, and seats**.
It allows users to **search flights, check available seats, make bookings, and cancel bookings**. 
The project also includes **triggers** to automatically update seat status and a **view** to show available seats.

# Introduction
Airline Reservation Systems are used by airlines to manage flight schedules, customer details, seat bookings, and cancellations.  
This project demonstrates a **database-driven system** using MySQL. It provides an easy way to **track flights, customers, and bookings** in a structured manner.

# Tools Used
- **MySQL Workbench** – To create database, tables, queries, triggers, and views  
- **SQL** – For writing queries and managing data

# Database Schema
**Tables:**
1. **Flights** – FlightID, FlightNo, Source, Destination, DepartTime, ArriveTime, Fare  
2. **Customers** – CustomerID, FirstName, LastName, Email  
3. **Bookings** – BookingID, CustomerID, FlightID, BookingDate, Status  
4. **Seats** – SeatID, FlightID, SeatNo, Status  

# Steps Involved
1. **Design Database Schema**  
   - Created tables and defined primary and foreign keys  

2. **Insert Sample Data**  
   - Added flights, customers, and seats  

3. **Write Queries**  
   - Search flights by source/destination  
   - Check available seats  
   - Make bookings  
   - Cancel bookings  
   - Generate booking summary report  

4. **Create Views**  
   - Created `AvailableSeats` view to show all available seats  

5. **Add Triggers**  
   - Trigger to automatically mark seats as BOOKED when booking is made  
   - Trigger to automatically mark seats as AVAILABLE when booking is cancelled  

# Conclusion
The project successfully demonstrates a complete Airline Reservation System using MySQL.
It covers flight management, customer management, seat management, bookings, cancellations, triggers, and views.
The system is simple, easy to use, and can be extended for more features like dynamic seat selection, multiple flights, and advanced reports.
