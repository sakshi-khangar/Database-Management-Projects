# Crime Record & Investigation Database

## Project Overview
The Crime Record & Investigation Database is designed to efficiently manage criminal investigation data.
It helps law enforcement agencies track cases, suspects, officers, and evidence while supporting queries and reports to analyze solved and unsolved cases.

## Objective
- Store and manage investigation records.
- Track cases, suspects, officers, and evidence.
- Generate reports and analyze officer workloads.
- Automate updates for evidence tracking using triggers.

## Tools Used
- Database: MySQL Workbench
- Query Language: SQL

## Database Schema
- Cases: Stores case details (title, description, status, open/close dates).
- Suspects: Stores suspect information linked to cases.
- Officers: Stores police officer details.
- Case Assignments: Tracks which officers are assigned to which cases.
- Evidence: Tracks evidence items for each case and automatically updates timestamps.

## Key Features
- Indexes: Speed up search on key fields like case_id and suspect name.
- Queries: Retrieve open/closed cases, count solved vs unsolved cases, and generate officer workload reports.
- Views: Summarize officer assignments without repeating complex queries.
- Triggers: Automatically update evidence timestamps when records are modified.
- Reports: Investigation summaries combining cases, suspects, officers, and evidence.

## Conclusion
The Crime Record & Investigation Database provides a structured and efficient system to manage investigation data. By using relational tables, indexes, views, and triggers, the system supports easy tracking, analysis, and reporting of cases, suspects, officers, and evidence.
It can be extended for advanced features like notifications, case prioritization, or analytics.
