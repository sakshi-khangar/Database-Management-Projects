## Library Management System

# Introduction
The **Library Management System** is a database project designed to digitize and automate the management of books, authors, members, and loans.  
It helps track borrowed books, overdue items, and provides automatic updates using triggers and notifications.

#  Objective
- Build a digital library database with loan tracking.  
- Manage relationships between books, authors, and members.  
- Automate book availability and overdue notifications using triggers.  
- Generate meaningful reports using aggregation and joins.

# Tools Used
- **MySQL Workbench** – Schema design & query execution.  
- **MySQL Server** – Database management and storage.

# Database Schema
**Entities:**
- `Authors(AuthorID, FullName, Bio)`
- `Books(BookID, Title, ISBN, PublishedYear, Genre, TotalCopies, AvailableCopies)`
- `Members(MemberID, FullName, Email, Phone, JoinedAt, Status)`
- `Loans(LoanID, BookID, MemberID, LoanDate, DueDate, ReturnedAt)`
- `BookAuthors(BookID, AuthorID)` → Bridge table (Many-to-Many)
- `Notifications(NotificationID, MemberID, LoanID, Message, CreatedAt, Status)`

#  Relationships
- Books ↔ Authors: Many-to-Many (via `BookAuthors`)  
- Members ↔ Loans: One-to-Many  
- Books ↔ Loans: One-to-Many  
- Members ↔ Notifications: One-to-Many  

# Features
- Insert and manage books, authors, and members.  
- Borrow and return books with loan records.  
- Auto-update available copies when a book is borrowed.  
- Overdue notifications stored in a separate table.  
- Generate reports on borrowing patterns.

# Views
- **BorrowedBooks** → shows who borrowed which book and due date.  
- **OverdueBooks** → shows books not returned beyond their due date.  

# Triggers
- **after_loan_insert** → decreases AvailableCopies when a new loan is added.  
- **after_loan_update** → inserts a notification when a book becomes overdue.

# Reports
- Books borrowed count per member.  
- Most borrowed books report.  

# Conclusion
This project demonstrates the practical application of **database concepts** including schema design, relationships, views, triggers, and aggregation.  
The system is efficient, scalable, and can be directly applied to real-world library operations.
