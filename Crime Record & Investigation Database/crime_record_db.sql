CREATE DATABASE crime_record_db;
USE crime_record_db;
# Cases Table
CREATE TABLE Cases (case_id INT AUTO_INCREMENT PRIMARY KEY,title VARCHAR(200) NOT NULL,description TEXT,status ENUM('Open','Closed','Under Investigation'),
opened_date DATE NOT NULL,closed_date DATE);
#Suspects Table
CREATE TABLE Suspects (suspect_id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(100) NOT NULL,age INT,address TEXT,
case_id INT,FOREIGN KEY (case_id) REFERENCES Cases(case_id) ON DELETE CASCADE);
# Officers Table
CREATE TABLE Officers (officer_id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(100) NOT NULL,`rank` VARCHAR(50),department VARCHAR(100));
# Case Assignments Table
CREATE TABLE Case_Assignments (assignment_id INT AUTO_INCREMENT PRIMARY KEY,case_id INT,officer_id INT,assigned_date DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (case_id) REFERENCES Cases(case_id) ON DELETE CASCADE,
FOREIGN KEY (officer_id) REFERENCES Officers(officer_id) ON DELETE CASCADE
);
# Evidence Table
CREATE TABLE Evidence (evidence_id INT AUTO_INCREMENT PRIMARY KEY,case_id INT,description TEXT NOT NULL,
collected_date DATE DEFAULT (CURRENT_DATE),last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
FOREIGN KEY (case_id) REFERENCES Cases(case_id) ON DELETE CASCADE);

#Cases Data
INSERT INTO Cases (title, description, status, opened_date, closed_date) VALUES
('Bank Robbery', 'Armed robbery at central bank', 'Closed', '2023-01-10', '2023-02-15'),
('Cyber Fraud', 'Online phishing scam targeting citizens', 'Open', '2023-03-20', NULL),
('Hit and Run', 'Car accident, suspect fled scene', 'Under Investigation', '2023-04-05', NULL);
#Officers Data
INSERT INTO Officers (name, `rank`, department) VALUES ('John Smith', 'Inspector', 'Crime Branch'),
('Alice Johnson', 'Sergeant', 'Cyber Cell'),('Raj Patel', 'Constable', 'Traffic Control');
#Case_Assignments Data
INSERT INTO Case_Assignments (case_id, officer_id) VALUES
((SELECT case_id FROM Cases WHERE title='Bank Robbery'),
 (SELECT officer_id FROM Officers WHERE name='John Smith')),
((SELECT case_id FROM Cases WHERE title='Cyber Fraud'),
 (SELECT officer_id FROM Officers WHERE name='Alice Johnson')),
((SELECT case_id FROM Cases WHERE title='Hit and Run'),
 (SELECT officer_id FROM Officers WHERE name='Raj Patel')),
((SELECT case_id FROM Cases WHERE title='Hit and Run'),
 (SELECT officer_id FROM Officers WHERE name='John Smith'));
 # Suspects Data
INSERT INTO Suspects (name, age, address, case_id) VALUES('Michael Brown', 32, 'Downtown Street',(SELECT case_id FROM Cases WHERE title='Bank Robbery')),
('David Lee', 28, 'Riverside Road',(SELECT case_id FROM Cases WHERE title='Cyber Fraud')),
('Suresh Kumar', 40, 'MG Road',(SELECT case_id FROM Cases WHERE title='Hit and Run')),
('Unknown', NULL, 'Not identified yet',(SELECT case_id FROM Cases WHERE title='Hit and Run'));
# Evidence Data
INSERT INTO Evidence (case_id, description, collected_date) VALUES
((SELECT case_id FROM Cases WHERE title='Bank Robbery'),'CCTV footage from bank', '2023-01-10'),
((SELECT case_id FROM Cases WHERE title='Bank Robbery'),'Abandoned vehicle near crime scene', '2023-01-11'),
((SELECT case_id FROM Cases WHERE title='Cyber Fraud'),'Phishing email samples', '2023-03-21'),
((SELECT case_id FROM Cases WHERE title='Hit and Run'),'Broken car parts from accident site', '2023-04-05');


#Faster search on case_id and suspect name
CREATE INDEX idx_case_id ON Cases(case_id);
CREATE INDEX idx_suspect_name ON Suspects(name);

#Get all open cases
SELECT case_id, title, opened_date
FROM Cases
WHERE status = 'Open';

# Get all closed cases
SELECT case_id, title, closed_date
FROM Cases
WHERE status = 'Closed';

# Count of solved vs unsolved cases
SELECT status, COUNT(*) AS total
FROM Cases
GROUP BY status;

CREATE OR REPLACE VIEW Officer_Workload AS
SELECT o.officer_id, o.name, COUNT(ca.case_id) AS total_cases
FROM Officers o
LEFT JOIN Case_Assignments ca ON o.officer_id = ca.officer_id
GROUP BY o.officer_id, o.name;
SELECT * FROM Officer_Workload;

#Trigger for Evidence Updates
DELIMITER $$
CREATE TRIGGER trg_update_evidence
BEFORE UPDATE ON Evidence
FOR EACH ROW
BEGIN
    SET NEW.last_updated = CURRENT_TIMESTAMP;
END$$

DELIMITER ;
SHOW TRIGGERS FROM crime_record_db;