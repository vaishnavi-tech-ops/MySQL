-- ============================================================
-- HR EMPLOYEE MANAGEMENT SYSTEM - MYSQL PROJECT
-- Covers: DDL (tables, constraints, indexes, views)
--         DML (insert, update, delete, select/query examples)
-- Target: MySQL 8.0+ (MySQL Workbench)
-- ============================================================

CREATE DATABASE IF NOT EXISTS HR_System;
USE HR_System;

-- ============================================================
-- 1. DDL - DROP EXISTING OBJECTS (for re-runnability)
-- ============================================================
DROP VIEW IF EXISTS vw_EmployeeSummary;
DROP VIEW IF EXISTS vw_DepartmentHeadcount;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;

-- ============================================================
-- 2. DDL - PARENT TABLE: DEPARTMENTS
-- ============================================================
CREATE TABLE Departments (
    DepartmentID    INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName  VARCHAR(100) NOT NULL UNIQUE,
    DepartmentHead  VARCHAR(100) NULL,
    Location        VARCHAR(100) NULL
);

-- ============================================================
-- 3. DDL - MAIN TABLE: EMPLOYEES (50 columns)
-- ============================================================
CREATE TABLE Employees (
    -- Identity / basic info (1-9)
    EmployeeID               INT AUTO_INCREMENT PRIMARY KEY,           -- 1
    EmployeeCode              VARCHAR(20)   NOT NULL UNIQUE,            -- 2
    FirstName                VARCHAR(50)   NOT NULL,                   -- 3
    MiddleName                VARCHAR(50)   NULL,                       -- 4
    LastName                 VARCHAR(50)   NOT NULL,                   -- 5
    Gender                   CHAR(1)       NULL,                       -- 6
    DateOfBirth               DATE          NULL,                       -- 7
    Email                    VARCHAR(100)  NOT NULL UNIQUE,             -- 8
    PersonalEmail              VARCHAR(100)  NULL,                       -- 9

    -- Contact / address (10-17)
    Phone                    VARCHAR(20)   NULL,                       -- 10
    AlternatePhone             VARCHAR(20)   NULL,                       -- 11
    Address1                  VARCHAR(150)  NULL,                       -- 12
    Address2                  VARCHAR(150)  NULL,                       -- 13
    City                     VARCHAR(50)   NULL,                       -- 14
    State                    VARCHAR(50)   NULL,                       -- 15
    Country                  VARCHAR(50)   NULL,                       -- 16
    PostalCode                 VARCHAR(20)   NULL,                       -- 17

    -- Employment lifecycle (18-24)
    HireDate                  DATE          NOT NULL,                   -- 18
    TerminationDate             DATE          NULL,                       -- 19
    EmploymentStatus            VARCHAR(20)   NOT NULL DEFAULT 'Active',   -- 20
    EmploymentType             VARCHAR(20)   NOT NULL DEFAULT 'Full-time', -- 21
    JobTitle                  VARCHAR(100)  NOT NULL,                   -- 22
    DepartmentID               INT           NOT NULL,                   -- 23
    ManagerID                 INT           NULL,                       -- 24

    -- Compensation (25-31)
    Salary                    DECIMAL(12,2) NOT NULL,                   -- 25
    Currency                  CHAR(3)       NOT NULL DEFAULT 'INR',     -- 26
    PayFrequency               VARCHAR(20)   NOT NULL DEFAULT 'Monthly',  -- 27
    BankAccountNumber            VARCHAR(30)   NULL,                       -- 28
    BankName                  VARCHAR(100)  NULL,                       -- 29
    BankRoutingCode              VARCHAR(20)   NULL,                       -- 30
    TaxIdentificationNumber        VARCHAR(30)   NULL,                       -- 31

    -- Personal / demographic (32-37)
    MaritalStatus               VARCHAR(20)   NULL,                       -- 32
    Nationality                 VARCHAR(50)   NULL,                       -- 33
    BloodGroup                  VARCHAR(5)    NULL,                       -- 34
    EmergencyContactName           VARCHAR(100)  NULL,                       -- 35
    EmergencyContactPhone          VARCHAR(20)   NULL,                       -- 36
    EmergencyContactRelation        VARCHAR(30)   NULL,                       -- 37

    -- Education (38-40)
    HighestEducation             VARCHAR(50)   NULL,                       -- 38
    University                  VARCHAR(100)  NULL,                       -- 39
    GraduationYear               SMALLINT      NULL,                       -- 40

    -- Work details (41-48)
    WorkLocation                VARCHAR(50)   NULL,                       -- 41
    OfficeBranch                 VARCHAR(50)   NULL,                       -- 42
    ShiftType                  VARCHAR(20)   NULL DEFAULT 'General',      -- 43
    ProbationEndDate              DATE          NULL,                       -- 44
    ConfirmationDate              DATE          NULL,                       -- 45
    PerformanceRating             DECIMAL(3,2)  NULL,                       -- 46
    LeaveBalance                 DECIMAL(5,1)  NOT NULL DEFAULT 0,          -- 47
    RemoteWorkEligible             TINYINT(1)    NOT NULL DEFAULT 0,          -- 48

    -- Audit (49-50)
    CreatedAt                  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,                       -- 49
    UpdatedAt                  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 50

    CONSTRAINT chk_Gender CHECK (Gender IN ('M','F','O')),
    CONSTRAINT chk_EmploymentStatus CHECK (EmploymentStatus IN ('Active','Terminated','On Leave','Suspended')),
    CONSTRAINT chk_EmploymentType CHECK (EmploymentType IN ('Full-time','Part-time','Contract','Intern')),
    CONSTRAINT chk_PayFrequency CHECK (PayFrequency IN ('Weekly','Biweekly','Monthly')),
    CONSTRAINT chk_MaritalStatus CHECK (MaritalStatus IN ('Single','Married','Divorced','Widowed')),
    CONSTRAINT chk_Salary CHECK (Salary >= 0),
    CONSTRAINT chk_PerformanceRating CHECK (PerformanceRating BETWEEN 0 AND 5),

    CONSTRAINT FK_Employees_Department FOREIGN KEY (DepartmentID)
        REFERENCES Departments(DepartmentID),
    CONSTRAINT FK_Employees_Manager FOREIGN KEY (ManagerID)
        REFERENCES Employees(EmployeeID)
);

-- ============================================================
-- 4. DDL - INDEXES
-- ============================================================
CREATE INDEX IX_Employees_DepartmentID ON Employees(DepartmentID);
CREATE INDEX IX_Employees_ManagerID    ON Employees(ManagerID);
CREATE INDEX IX_Employees_LastName     ON Employees(LastName, FirstName);
CREATE INDEX IX_Employees_Status        ON Employees(EmploymentStatus);

-- ============================================================
-- 5. DML - INSERT: DEPARTMENTS
-- ============================================================
INSERT INTO Departments (DepartmentName, DepartmentHead, Location) VALUES
('Human Resources', 'Anita Sharma', 'Delhi'),
('Engineering',      'Rohan Verma', 'Bangalore'),
('Finance',          'Kavita Rao',  'Mumbai'),
('Sales',            'Vikram Singh','Delhi'),
('IT Support',       'Neha Gupta',  'Pune');

-- ============================================================
-- 6. DML - INSERT: EMPLOYEES (sample data)
-- ============================================================
INSERT INTO Employees
(EmployeeCode, FirstName, MiddleName, LastName, Gender, DateOfBirth, Email, PersonalEmail,
 Phone, AlternatePhone, Address1, Address2, City, State, Country, PostalCode,
 HireDate, TerminationDate, EmploymentStatus, EmploymentType, JobTitle, DepartmentID, ManagerID,
 Salary, Currency, PayFrequency, BankAccountNumber, BankName, BankRoutingCode, TaxIdentificationNumber,
 MaritalStatus, Nationality, BloodGroup, EmergencyContactName, EmergencyContactPhone, EmergencyContactRelation,
 HighestEducation, University, GraduationYear,
 WorkLocation, OfficeBranch, ShiftType, ProbationEndDate, ConfirmationDate, PerformanceRating,
 LeaveBalance, RemoteWorkEligible)
VALUES
('EMP001','Anita',NULL,'Sharma','F','1985-04-12','anita.sharma@company.com','anita85@gmail.com',
 '9810000001',NULL,'12 MG Road',NULL,'Delhi','Delhi','India','110001',
 '2015-01-10',NULL,'Active','Full-time','HR Manager',1,NULL,
 95000.00,'INR','Monthly','1234567890','HDFC Bank','HDFC0001','PAN1234A',
 'Married','Indian','O+','Raj Sharma','9810000002','Spouse',
 'MBA','Delhi University',2008,
 'Delhi','HQ','General','2015-04-10','2015-07-10',4.5,
 18.0,0),

('EMP002','Rohan',NULL,'Verma','M','1988-07-22','rohan.verma@company.com','rohan88@gmail.com',
 '9810000003',NULL,'45 Residency Rd',NULL,'Bangalore','Karnataka','India','560001',
 '2016-03-01',NULL,'Active','Full-time','Engineering Manager',2,NULL,
 150000.00,'INR','Monthly','2234567890','ICICI Bank','ICIC0002','PAN2234B',
 'Married','Indian','B+','Priya Verma','9810000004','Spouse',
 'M.Tech','IIT Bombay',2010,
 'Bangalore','Tech Park','General','2016-06-01','2016-09-01',4.8,
 20.0,1),

('EMP003','Kavita',NULL,'Rao','F','1990-11-05','kavita.rao@company.com','kavita90@gmail.com',
 '9810000005',NULL,'78 Marine Drive',NULL,'Mumbai','Maharashtra','India','400001',
 '2017-05-15',NULL,'Active','Full-time','Finance Manager',3,NULL,
 130000.00,'INR','Monthly','3234567890','SBI','SBIN0003','PAN3234C',
 'Single','Indian','A+','Suresh Rao','9810000006','Father',
 'CA','ICAI',2012,
 'Mumbai','HQ','General','2017-08-15','2017-11-15',4.6,
 15.5,0),

('EMP004','Vikram',NULL,'Singh','M','1987-02-18','vikram.singh@company.com','vikram87@gmail.com',
 '9810000007',NULL,'23 Connaught Place',NULL,'Delhi','Delhi','India','110001',
 '2016-09-01',NULL,'Active','Full-time','Sales Manager',4,NULL,
 120000.00,'INR','Monthly','4234567890','Axis Bank','UTIB0004','PAN4234D',
 'Married','Indian','AB+','Meena Singh','9810000008','Spouse',
 'MBA','Symbiosis',2011,
 'Delhi','HQ','General','2016-12-01','2017-03-01',4.2,
 12.0,1),

('EMP005','Neha',NULL,'Gupta','F','1992-09-30','neha.gupta@company.com','neha92@gmail.com',
 '9810000009',NULL,'56 FC Road',NULL,'Pune','Maharashtra','India','411001',
 '2018-01-20',NULL,'Active','Full-time','IT Support Lead',5,NULL,
 90000.00,'INR','Monthly','5234567890','Kotak Bank','KKBK0005','PAN5234E',
 'Single','Indian','O-','Ramesh Gupta','9810000010','Father',
 'B.Tech','Pune University',2014,
 'Pune','Branch Office','General','2018-04-20','2018-07-20',4.3,
 22.0,1),

('EMP006','Arjun','Kumar','Nair','M','1995-06-14','arjun.nair@company.com','arjun95@gmail.com',
 '9810000011',NULL,'89 Indiranagar',NULL,'Bangalore','Karnataka','India','560038',
 '2020-06-01',NULL,'Active','Full-time','Software Engineer',2,2,
 85000.00,'INR','Monthly','6234567890','HDFC Bank','HDFC0006','PAN6234F',
 'Single','Indian','B-','Lakshmi Nair','9810000012','Mother',
 'B.Tech','NIT Trichy',2017,
 'Bangalore','Tech Park','General','2020-09-01','2020-12-01',4.0,
 10.0,1),

('EMP007','Priya',NULL,'Menon','F','1993-03-25','priya.menon@company.com','priya93@gmail.com',
 '9810000013',NULL,'34 Koramangala',NULL,'Bangalore','Karnataka','India','560034',
 '2019-11-10',NULL,'Active','Full-time','Software Engineer',2,2,
 88000.00,'INR','Monthly','7234567890','ICICI Bank','ICIC0007','PAN7234G',
 'Married','Indian','A-','Karthik Menon','9810000014','Spouse',
 'M.Tech','IISc Bangalore',2016,
 'Bangalore','Tech Park','General','2020-02-10','2020-05-10',4.4,
 16.0,1),

('EMP008','Sanjay',NULL,'Patel','M','1984-12-01','sanjay.patel@company.com','sanjay84@gmail.com',
 '9810000015',NULL,'12 Satellite Road',NULL,'Ahmedabad','Gujarat','India','380001',
 '2014-07-01','2023-05-31','Terminated','Full-time','Sales Executive',4,4,
 60000.00,'INR','Monthly','8234567890','SBI','SBIN0008','PAN8234H',
 'Married','Indian','O+','Ritu Patel','9810000016','Spouse',
 'B.Com','Gujarat University',2006,
 'Delhi','HQ','General','2014-10-01','2015-01-01',3.5,
 0.0,0),

('EMP009','Fatima',NULL,'Khan','F','1991-08-19','fatima.khan@company.com','fatima91@gmail.com',
 '9810000017',NULL,'67 Banjara Hills',NULL,'Hyderabad','Telangana','India','500034',
 '2019-04-05',NULL,'On Leave','Full-time','HR Executive',1,1,
 55000.00,'INR','Monthly','9234567890','Axis Bank','UTIB0009','PAN9234I',
 'Married','Indian','B+','Imran Khan','9810000018','Spouse',
 'MBA','Osmania University',2015,
 'Delhi','HQ','General','2019-07-05','2019-10-05',3.9,
 5.0,0),

('EMP010','Karan',NULL,'Malhotra','M','1996-01-27','karan.malhotra@company.com','karan96@gmail.com',
 '9810000019',NULL,'21 Sector 18',NULL,'Gurgaon','Haryana','India','122001',
 '2021-08-16',NULL,'Active','Contract','Finance Analyst',3,3,
 45000.00,'INR','Monthly','1034567890','Kotak Bank','KKBK0010','PAN1034J',
 'Single','Indian','AB-','Meera Malhotra','9810000020','Mother',
 'B.Com','Delhi University',2018,
 'Mumbai','HQ','General','2021-11-16','2022-02-16',3.7,
 8.0,0);

-- ============================================================
-- 7. DML - UPDATE examples
-- ============================================================

-- Give the Engineering department a 10% raise
UPDATE Employees
SET Salary = Salary * 1.10
WHERE DepartmentID = (SELECT DepartmentID FROM (SELECT DepartmentID FROM Departments WHERE DepartmentName = 'Engineering') AS d);

-- Promote an employee and update job title / rating
UPDATE Employees
SET JobTitle = 'Senior Software Engineer',
    PerformanceRating = 4.7
WHERE EmployeeCode = 'EMP006';

-- Mark an employee as terminated
UPDATE Employees
SET EmploymentStatus = 'Terminated',
    TerminationDate = '2026-08-01'
WHERE EmployeeCode = 'EMP009';

-- ============================================================
-- 8. DML - DELETE example
-- ============================================================

-- Remove a specific employee record (e.g., data entered in error)
-- (Commented out by default to protect sample data; uncomment to run)
-- DELETE FROM Employees WHERE EmployeeCode = 'EMP010';

-- ============================================================
-- 9. DML - SELECT / QUERY examples
-- ============================================================

-- All active employees with department name
SELECT e.EmployeeCode, e.FirstName, e.LastName, e.JobTitle, d.DepartmentName, e.Salary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.EmploymentStatus = 'Active'
ORDER BY d.DepartmentName, e.LastName;

-- Average salary per department
SELECT d.DepartmentName, COUNT(*) AS HeadCount, AVG(e.Salary) AS AvgSalary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY AvgSalary DESC;

-- Employees reporting to a given manager
SELECT CONCAT(m.FirstName, ' ', m.LastName) AS Manager,
       CONCAT(e.FirstName, ' ', e.LastName) AS DirectReport,
       e.JobTitle
FROM Employees e
JOIN Employees m ON e.ManagerID = m.EmployeeID
ORDER BY Manager;

-- Employees eligible for remote work, high performers
SELECT EmployeeCode, FirstName, LastName, JobTitle, PerformanceRating
FROM Employees
WHERE RemoteWorkEligible = 1 AND PerformanceRating >= 4.0
ORDER BY PerformanceRating DESC;

-- ============================================================
-- 10. DDL - VIEWS
-- ============================================================

CREATE VIEW vw_EmployeeSummary AS
SELECT
    e.EmployeeID,
    e.EmployeeCode,
    CONCAT(e.FirstName, ' ', e.LastName) AS FullName,
    e.JobTitle,
    d.DepartmentName,
    e.EmploymentStatus,
    e.EmploymentType,
    e.HireDate,
    e.Salary,
    e.PerformanceRating
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

CREATE VIEW vw_DepartmentHeadcount AS
SELECT
    d.DepartmentName,
    COUNT(e.EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN e.EmploymentStatus = 'Active' THEN 1 ELSE 0 END) AS ActiveEmployees,
    AVG(e.Salary) AS AvgSalary
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;

-- Example usage:
-- SELECT * FROM vw_EmployeeSummary ORDER BY DepartmentName;
-- SELECT * FROM vw_DepartmentHeadcount;
