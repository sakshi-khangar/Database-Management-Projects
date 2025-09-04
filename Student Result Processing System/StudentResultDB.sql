CREATE DATABASE StudentResultDB;
USE StudentResultDB; 
# Students Table
CREATE TABLE Students (student_id INT PRIMARY KEY,name VARCHAR(50),dob DATE,department VARCHAR(50));
# Courses Table
CREATE TABLE Courses (course_id INT PRIMARY KEY,course_name VARCHAR(50),credits INT);
#Semesters Table 
CREATE TABLE Semesters (semester_id INT PRIMARY KEY,semester_name VARCHAR(20));
# Grades Table
CREATE TABLE Grades (grade_id INT PRIMARY KEY,student_id INT,course_id INT,semester_id INT,marks INT,grade CHAR(2),gpa FLOAT,
FOREIGN KEY (student_id) REFERENCES Students(student_id),
FOREIGN KEY (course_id) REFERENCES Courses(course_id),
FOREIGN KEY (semester_id) REFERENCES Semesters(semester_id));

#Students Data
INSERT INTO Students (student_id, name, dob, department) VALUES (1, 'Sakshi Khangar', '2003-05-12', 'Computer Technology'),
(2, 'Rohan Patil', '2003-08-20', 'Computer Technology'),(3, 'Priya Sharma', '2003-02-15', 'Electronics'),
(4, 'Amit Deshmukh', '2003-11-05', 'Mechanical'),(5, 'Sneha Kulkarni', '2003-03-30', 'Civil');
#Courses Data
INSERT INTO Courses (course_id, course_name, credits) VALUES (101, 'Mathematics', 4),(102, 'Physics', 3),(103, 'Computer Programming', 4),
(104, 'Electronics Basics', 3),(105, 'Mechanics', 3);
#Semesters Data
INSERT INTO Semesters (semester_id, semester_name) VALUES(1, 'Semester 1'),(2, 'Semester 2');
#Grades Data
INSERT INTO Grades (grade_id, student_id, course_id, semester_id, marks, grade, gpa) VALUES(1, 1, 101, 1, 85, 'A', 10),
(2, 1, 102, 1, 78, 'B', 8),(3, 1, 103, 1, 92, 'A', 10),(4, 2, 101, 1, 65, 'C', 6),(5, 2, 102, 1, 70, 'B', 8),
(6, 2, 103, 1, 88, 'A', 10),(7, 3, 104, 1, 75, 'B', 8),(8, 3, 102, 1, 68, 'C', 6),(9, 4, 105, 1, 55, 'D', 5),(10, 5, 101, 1, 90, 'A', 10);

#Semester GPA for Each Student
SELECT s.student_id,s.name,sem.semester_name,ROUND(SUM(c.credits * g.gpa)/SUM(c.credits), 2) AS semester_gpa FROM Grades g
JOIN Students s ON g.student_id = s.student_id JOIN Courses c ON g.course_id = c.course_id 
JOIN Semesters sem ON g.semester_id = sem.semester_id GROUP BY s.student_id, sem.semester_name;

#Pass/Fail Status per Student
SELECT  s.student_id,s.name,sem.semester_name,CASE WHEN MIN(g.marks) >= 40 THEN 'Pass' ELSE 'Fail' END AS result FROM Grades g
JOIN Students s ON g.student_id = s.student_id JOIN Semesters sem ON g.semester_id = sem.semester_id GROUP BY s.student_id, sem.semester_name;

#Rank List per Semester
SELECT student_id,name,semester_name,semester_gpa,RANK() OVER(PARTITION BY semester_name ORDER BY semester_gpa DESC) AS `rank` FROM (
SELECT s.student_id,s.name,sem.semester_name,SUM(c.credits * g.gpa)/SUM(c.credits) AS semester_gpa FROM Grades g
JOIN Students s ON g.student_id = s.student_id JOIN Courses c ON g.course_id = c.course_id 
JOIN Semesters sem ON g.semester_id = sem.semester_id GROUP BY s.student_id, sem.semester_name) AS gpa_table;

#Individual Student Report
SELECT s.student_id,s.name,c.course_name,g.marks,g.grade,c.credits,g.gpa FROM Grades g
JOIN Students s ON g.student_id = s.student_id JOIN Courses c ON g.course_id = c.course_id WHERE s.student_id = 1;

#Semester-wise Summary Export
SELECT sem.semester_name,s.student_id,s.name,ROUND(SUM(c.credits*g.gpa)/SUM(c.credits), 2) AS GPA,CASE WHEN MIN(g.marks) >= 40 THEN 'Pass'
ELSE 'Fail' END AS Result FROM Grades g
JOIN Students s ON g.student_id = s.student_id JOIN Courses c ON g.course_id = c.course_id
JOIN Semesters sem ON g.semester_id = sem.semester_id GROUP BY sem.semester_name, s.student_id;

#Trigger to Auto-Update GPA
DELIMITER $$

CREATE TRIGGER trg_calculate_gpa
AFTER INSERT ON Grades
FOR EACH ROW
BEGIN
    UPDATE Grades g
    JOIN (
        SELECT student_id, semester_id, SUM(c.credits * gpa)/SUM(c.credits) AS semester_gpa
        FROM Grades
        JOIN Courses c ON Grades.course_id = c.course_id
        WHERE student_id = NEW.student_id AND semester_id = NEW.semester_id
        GROUP BY student_id, semester_id
    ) t
    ON g.student_id = t.student_id AND g.semester_id = t.semester_id
    SET g.gpa = t.semester_gpa;
END$$

DELIMITER ;
SHOW triggers FROM StudentResultDB;

#Top 3 Students per Semester
SELECT * FROM (SELECT student_id,name,semester_name,semester_gpa,RANK() OVER(PARTITION BY semester_name ORDER BY semester_gpa DESC) AS `rank`
FROM (SELECT s.student_id,s.name,sem.semester_name,SUM(c.credits*g.gpa)/SUM(c.credits) AS semester_gpa FROM Grades g
JOIN Students s ON g.student_id = s.student_id JOIN Courses c ON g.course_id = c.course_id JOIN Semesters sem ON g.semester_id = sem.semester_id
GROUP BY s.student_id, sem.semester_name) AS gpa_table) AS ranked WHERE `rank` <= 3;
