CREATE DATABASE LibraryDB;
USE LibraryDB;
#Authors Table
CREATE TABLE Authors (AuthorID INT AUTO_INCREMENT PRIMARY KEY,FullName VARCHAR(200) NOT NULL,Bio TEXT);
#Books Table
CREATE TABLE Books (BookID INT AUTO_INCREMENT PRIMARY KEY,Title VARCHAR(300) NOT NULL,ISBN VARCHAR(20) UNIQUE NOT NULL,PublishedYear INT,
Genre VARCHAR(80),TotalCopies INT NOT NULL CHECK (TotalCopies >= 0),AvailableCopies INT NOT NULL CHECK (AvailableCopies >= 0));
#Members Table
CREATE TABLE Members (MemberID INT AUTO_INCREMENT PRIMARY KEY,FullName VARCHAR(200) NOT NULL,Email VARCHAR(200) UNIQUE NOT NULL,
Phone VARCHAR(20),JoinedAt DATETIME DEFAULT CURRENT_TIMESTAMP,Status ENUM('active','inactive','banned') DEFAULT 'active');
#Loans Table
CREATE TABLE Loans (LoanID INT AUTO_INCREMENT PRIMARY KEY,BookID INT NOT NULL,MemberID INT NOT NULL,LoanDate DATE DEFAULT (CURRENT_DATE),
DueDate DATE NOT NULL,ReturnedAt DATETIME,CONSTRAINT fk_book FOREIGN KEY (BookID) REFERENCES Books(BookID),
CONSTRAINT fk_member FOREIGN KEY (MemberID) REFERENCES Members(MemberID));
#Bridge Table (Many-to-Many between Books and Authors)
CREATE TABLE BookAuthors (BookID INT,AuthorID INT,PRIMARY KEY(BookID, AuthorID),FOREIGN KEY (BookID) REFERENCES Books(BookID),
FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID));
#Notification Table
CREATE TABLE Notifications (NotificationID INT AUTO_INCREMENT PRIMARY KEY,MemberID INT NOT NULL,LoanID INT NOT NULL,Message VARCHAR(255),
CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,Status ENUM('pending','sent') DEFAULT 'pending',
FOREIGN KEY (MemberID) REFERENCES Members(MemberID),FOREIGN KEY (LoanID) REFERENCES Loans(LoanID));


#Authors Data
INSERT INTO Authors (FullName, Bio) VALUES('J.K. Rowling', 'Author of Harry Potter series'),('George Orwell', 'Author of 1984 and Animal Farm');
#Books Data
INSERT INTO Books (Title, ISBN, PublishedYear, Genre, TotalCopies, AvailableCopies) VALUES
('Harry Potter and the Philosopher''s Stone', '9780747532699', 1997, 'Fantasy', 5, 5),
('1984', '9780451524935', 1949, 'Dystopian', 3, 3);
#Members Data
INSERT INTO Members (FullName, Email, Phone) VALUES('Alice Johnson', 'alice@mail.com', '9876543210'),('Bob Smith', 'bob@mail.com', '9123456780');
#BookAuthors Data
INSERT INTO BookAuthors VALUES(1, 1), (2, 2); 
#Loan Data
INSERT INTO Loans (BookID, MemberID, LoanDate, DueDate) VALUES(1, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY)),
(2, 2, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY));

#Views for borrowed books
CREATE VIEW BorrowedBooks AS
SELECT l.LoanID,b.Title,m.FullName,l.LoanDate,l.DueDate,l.ReturnedAt FROM Loans l
JOIN Books b ON l.BookID = b.BookID
JOIN Members m ON l.MemberID = m.MemberID;
SELECT * FROM BorrowedBooks;
#Views for overdue books
CREATE VIEW overduebooks AS 
SELECT l.LoanID,b.Title,m.FullName,l.DueDate FROM Loans l
JOIN Books b ON l.BookID = b.BookID
JOIN Members m ON l.MemberID =m.MemberID
WHERE l.ReturnedAt IS NULL AND l.DueDate < CURDATE();

#triggers 
DELIMITER $$
CREATE TRIGGER after_loan_insert 
AFTER INSERT ON Loans
FOR EACH ROW
BEGIN UPDATE Books SET Avaliablecopies = Avaliablecopies - 1 WHERE BookID = NewBookID;
END $$
#Trigger for Overdue Notifications
DELIMITER $$

CREATE TRIGGER after_loan_update
AFTER UPDATE ON Loans
FOR EACH ROW
BEGIN
IF NEW.ReturnedAt IS NULL AND NEW.DueDate < CURDATE() THEN INSERT INTO Notifications (MemberID, LoanID, Message, Status)
VALUES (NEW.MemberID, NEW.LoanID, CONCAT('Book is overdue! Please return it. Due on ', NEW.DueDate), 'pending');
END IF;
END$$
INSERT INTO Loans (BookID, MemberID, LoanDate, DueDate)
VALUES (1, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY));

DELIMITER ;
#to Check Notifications
UPDATE Loans 
SET DueDate = DATE_SUB(CURDATE(), INTERVAL 2 DAY)
WHERE LoanID = 1;
SELECT * FROM Notifications;

#Count of Borrowed Books per member
SELECT  m.FullName, COUNT(l.LoanID) AS BorrowedCount FROM Members m
LEFT JOIN Loans l ON m.MemberID = l.MemberID 
GROUP BY m.MemberID;
#Most Borrowed Books
SELECT b.Title,COUNT(l.LoanID) AS TimesBorrowed FROM Books b
JOIN Loans l ON b.BookID = l.BookID 
GROUP BY b.Title
ORDER BY TimesBorrowed DESC;

