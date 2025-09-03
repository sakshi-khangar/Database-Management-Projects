# Hospital Management Database

## Project Overview
The Hospital Management Database is designed to efficiently manage patients’ records, doctor appointments, and billing information. 
It provides a structured way to store and retrieve hospital data, automates billing calculations, and generates visit and billing reports.

## Objective
- Manage patient records, doctor information, and visits.
- Track appointments and treatments.
- Automate billing with stored procedures.
- Generate visit and billing reports for hospital management.

## Tools Used 
- Database: MySQL  
- Management Tool: MySQL Workbench  
- CSV/Excel: To store exported visit and billing reports for documentation.

## Database Schema
The database consists of four main tables:
- Patients : Stores patient details and status (Admitted/Discharged).
- Doctors : Stores doctor details and specialization.
- Visits : Tracks each patient’s visit, diagnosis, and treatment.
- Bills : Stores billing details, amount, payment status, and date.

## Features
- Add, update, and track patients, doctors, visits, and bills.
- Stored procedures to automate billing.
- Triggers to update patient status upon bill payment.
- Queries to generate reports:
-- Doctor appointments
-- Pending bills
-- Complete visit report

## Conclusion
This project demonstrates a simple and effective hospital management system. 
It reduces manual errors, organizes hospital data efficiently, and provides a foundation for further enhancements like online appointment scheduling or analytics.
