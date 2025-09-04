# Student Result Processing System
## Objective
Automate the management of student grades, GPA, and rank lists. 
The system stores student records, calculates semester-wise GPA/CGPA, determines pass/fail status, and generates rank lists and performance reports.
## Tools Used 
- Database: MySQL Workbench
- Query Language: SQL 
- Export Format: CSV for query results
## Database Structure
1. **Students**: `student_id`, `name`, `dob`, `department`  
2. **Courses**: `course_id`, `course_name`, `credits`  
3. **Semesters**: `semester_id`, `semester_name`  
4. **Grades**: `grade_id`, `student_id`, `course_id`, `semester_id`, `marks`, `grade`, `gpa`  

## Features
- Calculate semester GPA for each student
- Determine pass/fail status
- Generate semester-wise rank lists
- Provide detailed individual student reports
- Trigger to automatically update GPA on new grade insertion
- Export semester-wise performance summaries

## Conclusion 
The Student Result Processing System successfully automates the management of 
student academic records. It reduces manual workload, improves accuracy, and 
provides quick insights into student performance. This system can be expanded to 
include CGPA calculation across semesters, automated notifications, and detailed 
analytics for teachers and administrators.
