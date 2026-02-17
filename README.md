# University HR Management System

## Overview
This project is a relational database implementation for a University Human Resources Management System. It is designed to automate and manage core HR functionalities including employee records, payroll processing, leave requests, and attendance monitoring.

## Features
* **Database Construction:** Scripts to create the `University_HR_ManagementSystem` database and all necessary tables (Department, Employee, Role, Attendance, etc.).
* **Role Management:** Handles various university roles (e.g., Lecturer, HR Manager, Medical Doctor) with specific hierarchy ranks.
* **Payroll System:** Includes a stored function `HRSalary_calculation` to automatically compute salaries based on base pay, role, and years of experience.
* **Leave Management:** Comprehensive handling of different leave types:
    * Annual Leave (with replacement logic)
    * Accidental Leave
    * Compensation Leave
    * Medical and Unpaid Leave
* **Attendance Tracking:** Manages check-in/check-out logs and calculates absences.
* **Data Integrity:** Extensive use of Primary Keys, Foreign Keys, and Identity columns to ensure data consistency.

## File Structure
* **schema.sql**: Contains the DDL (Data Definition Language) commands. It creates the database, tables, stored procedures, and functions.
* **seed_data.sql**: Contains the DML (Data Manipulation Language) commands to populate the database with test data for departments, roles, and employees.

## How to Run
1.  Open SQL Server Management Studio (SSMS).
2.  Open and execute `schema.sql` to build the database structure and stored procedures.
3.  Open and execute `seed_data.sql` to populate the tables with initial test data.
4.  Execute specific stored procedures (e.g., `Replace_employee`) to test functionality.

## Technologies
* SQL Server (T-SQL)

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
