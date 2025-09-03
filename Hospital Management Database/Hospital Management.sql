CREATE DATABASE HospitalDB;
USE HospitalDB;
#Patients Table
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    dob DATE,
    contact_no VARCHAR(15),
    address VARCHAR(255),
    status ENUM('Admitted', 'Discharged') DEFAULT 'Admitted'
);
#Doctors Table
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50),
    contact_no VARCHAR(15)
);
#Visits Table
CREATE TABLE Visits (
    visit_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    visit_date DATE,
    diagnosis VARCHAR(255),
    treatment VARCHAR(255),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);
#Bills Table
CREATE TABLE Bills (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    visit_id INT,
    amount DECIMAL(10,2),
    paid ENUM('Yes', 'No') DEFAULT 'No',
    bill_date DATE,
    FOREIGN KEY (visit_id) REFERENCES Visits(visit_id)
);
# Patients Data
INSERT INTO Patients (name, gender, dob, contact_no, address)VALUES ('Sakshi Khangar', 'Female', '2000-05-12', '9876543210', 'Nagpur'),
('Rahul Sharma', 'Male', '1995-08-23', '9123456780', 'Mumbai');
# Doctors Data
INSERT INTO Doctors (name, specialization, contact_no) VALUES('Dr. A. Kumar', 'Cardiologist', '9988776655'),('Dr. S. Patel', 'Neurologist', '9977553322');
# Visits Data
INSERT INTO Visits (patient_id, doctor_id, visit_date, diagnosis, treatment)VALUES(1, 1, '2025-09-01', 'Heart Pain', 'Medication'),
(2, 2, '2025-09-02', 'Migraine', 'Therapy');
# Bills Data
INSERT INTO Bills (visit_id, amount, paid, bill_date) VALUES (1, 5000.00, 'No', '2025-09-01'),(2, 2000.00, 'Yes', '2025-09-02');

# Appointments of a doctor
SELECT v.visit_id, p.name AS patient_name, v.visit_date, v.diagnosis FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id WHERE v.doctor_id = 1;
# Pending Bills
SELECT b.bill_id, p.name AS patient_name, b.amount, b.bill_date FROM Bills b JOIN Visits v ON b.visit_id = v.visit_id
JOIN Patients p ON v.patient_id = p.patient_id WHERE b.paid = 'No';
# Stored Procedure for Billing Calculation
DELIMITER //
CREATE PROCEDURE GenerateBill(IN visitID INT, IN amount DECIMAL(10,2))
BEGIN
    INSERT INTO Bills (visit_id, amount, bill_date, paid)
    VALUES (visitID, amount, CURDATE(), 'No');
END //
DELIMITER ;
CALL GenerateBill(1, 5000.00);

#Triggers - Update Patient Status on Bill Paid
DELIMITER //
CREATE TRIGGER update_patient_status
AFTER UPDATE ON Bills
FOR EACH ROW
BEGIN
    IF NEW.paid = 'Yes' THEN
        UPDATE Patients
        SET status = 'Discharged'
        WHERE patient_id = (SELECT patient_id FROM Visits WHERE visit_id = NEW.visit_id);
    END IF;
END //
DELIMITER ;

#Visit Report
SELECT p.name AS patient_name, d.name AS doctor_name, v.visit_date, v.diagnosis, b.amount, b.paid FROM Visits v
JOIN Patients p ON v.patient_id = p.patient_id
JOIN Doctors d ON v.doctor_id = d.doctor_id
JOIN Bills b ON v.visit_id = b.visit_id;
