# Employee Management and Attendance Tracker
## Description
A database-driven system to manage employee records and track attendance efficiently.
Features include adding employees, tracking attendance, calculating work hours, and generating reports.

## Features
- Manage employee details (Add, Update, Delete)
- Track daily attendance: Present, Absent, Leave, Late
- Monthly attendance reports
- Late arrivals tracking
- Department-wise employee count
- Calculate total work hours using SQL functions

## Database Schema
- Departments: DepartmentID, Name
- Roles: RoleID, Title, Salary
- Employees: EmployeeID, Name, Email, DepartmentID, RoleID, JoinDate
- Attendance: AttendanceID, EmployeeID, Date, Status, CheckIn, CheckOut

## Sample Queries
- Monthly Attendance Report
- Late Arrivals
- Department-Wise Employee Count
- Total Work Hours Calculation
- Employees on Leave

## Triggers & Functions
Trigger: Auto mark employee as Late if check-in after 09:15
Function: TotalWorkHours(emp_id, month_no)

## Conclusion
This project provides an efficient and organized way to manage employee information and attendance. 
It helps HR and management save time, reduce errors, and generate accurate reports for decision-making and payroll processing.
