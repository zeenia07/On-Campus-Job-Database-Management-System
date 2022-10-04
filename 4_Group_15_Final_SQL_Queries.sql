-- CREATE DATABASE DMDD_FINAL_PROJECT
-- GO


/* CREATE TABLES */

USE DMDD_FINAL_PROJECT
GO

/*
Create Address table and reference it to the various other entities in order to achieve the ATOMICITY.
This is master table and contains the list of the Addresses
*/

CREATE TABLE dbo.Address (
    ADDressID int NOT NULL IDENTITY(1,1),
    ADDressLineOne VARCHAR(250) NOT NULL,
    ADDressLineTwo VARCHAR(250),
    city VARCHAR(20) NOT NULL,
    state VARCHAR(20) NOT NULL,
    country VARCHAR(20) NOT NULL,
    zipcode int NOT NULL,
    PRIMARY KEY (ADDressID)
);

/*
Create University table and reference it to the various other entities.
It contains the list of Universities its details including the Address.
*/

CREATE TABLE dbo.University (
    universityID int NOT NULL IDENTITY(1,1),
    universityName VARCHAR (50) NOT NULL,
    ADDressID int,
    PRIMARY KEY (universityID),
    FOREIGN KEY (ADDressID) REFERENCES Address (ADDressID)
);

/*
Create College table and reference it to the various other entities.
It contains the list of Colleges belongs to the particular university and Address where it is located.
*/

CREATE TABLE dbo.College (
    collegeID int NOT NULL IDENTITY(1,1),
    collegeName VARCHAR (15) NOT NULL,
    universityID int,
    ADDressID int,
    PRIMARY KEY (collegeID),
    FOREIGN KEY (universityID) REFERENCES University(universityID),
    FOREIGN KEY (ADDressID) REFERENCES Address (ADDressID)
);

/*
Create Department table and reference it to the various other entities.
It contains the list of Departments belongs to the college and Address where it is located.
*/

CREATE TABLE dbo.Department (
    departmentID int NOT NULL IDENTITY(1,1),
    deaprtmentName VARCHAR (15) NOT NULL ,
    collegeID int,
    ADDressID int,
    PRIMARY KEY (departmentID),
    FOREIGN KEY (collegeID) REFERENCES College(collegeID),
    FOREIGN KEY (ADDressID) REFERENCES Address (ADDressID)
);

/*
Create Users table and reference it to the various other entities.
It contains the list of Users belongs to particular University.
Entered password will be ENCRYPTED.
*/

CREATE TABLE dbo.Users(
    userID int NOT NULL IDENTITY(1,1),
    userName VARCHAR(15) NOT NULL ,
    userPassword VARBINARY(250) NOT NULL,
    universityID INT,
    PRIMARY KEY (userID),
    FOREIGN KEY (universityID) REFERENCES University (universityID)
);

/*
Create Users Details table and reference it to the various other entities.
It contains detail information about particular User from Users table.
*/

CREATE TABLE dbo.UserDetails(
    userID int NOT NULL,
    userEmail VARCHAR(100) NOT NULL,
    userMobile BIGINT NOT NULL,
    ADDressID int,
    CONSTRAINT PK_Userss
        PRIMARY KEY(userID),
    FOREIGN KEY (userID) REFERENCES Users (userID),
    FOREIGN KEY (ADDressID) REFERENCES Address (ADDressID)
)

/*
Create Student Employee table 
This is main table which contains the LIST OF STUDENTS who are EMPLOYED. 
Details about the Hours Per Week being assigned, Wages Per Hour.
biWeeklyPayroll is COMPUTATIONAL CALCULATION column that displayes the Bi-Weekly Payment 
based on 2 week payroll given (hoursPerWeek * (2)) * wagesPerHour.
*/

CREATE TABLE dbo.StudentEmployee(
    employeeID int NOT NULL IDENTITY (1,1),
    userID int,
    hoursPerWeek int NOT NULL,
	wagesPerHour int NULL,
	biweeklyPayroll AS ((hoursPerWeek*(2)) * wagesPerHour),
    PRIMARY KEY (employeeID),
    FOREIGN KEY (userID) REFERENCES Users (userID)
)


/*
Create Employer table and reference it to the various other entities.
It contains the list of Employers. Employer is also a User who belongs 
to the particular Department which belongs to particular College and University.
*/

CREATE TABLE dbo.Employer(
    employerID int NOT NULL IDENTITY(1,1),
    empPosition VARCHAR(25) NOT NULL ,
    departmentID int,
    userID int,
    PRIMARY KEY (employerID),
    FOREIGN KEY (departmentID) REFERENCES Department (departmentID),
    FOREIGN KEY (userID) REFERENCES Users (userID)
);

/*
Create Job Listing table and reference it to the various other entities.
It contains the list of Jobs offered byEmployer Employer. 
*/

CREATE TABLE dbo.JobListing(
    jobID int NOT NULL IDENTITY(1,1),
    jobName VARCHAR (25) NOT NULL ,
    departmentID int,
    employerID int,
    PRIMARY KEY (jobID),
    FOREIGN KEY (departmentID) REFERENCES Department (departmentID),
    FOREIGN KEY (employerID) REFERENCES Employer (employerID)
);

/*
Create Job Description table and reference it to the various other entities.
It contains the information about the Jobs mentioned in the Job Listing table. 
Details include Number of Job Openings, Job Category, Wages Per hour and Description.
*/

CREATE TABLE dbo.JobDescription(
    jobDescriptionID int NOT NULL IDENTITY(1,1),
    jobOpenings int DEFAULT 0,
    jobCategory VARCHAR (50) NOT NULL,
    wagesPerHour MONEY NOT NULL,
    description VARCHAR (250),
    jobID int,
    PRIMARY KEY (jobDescriptionID),
    FOREIGN KEY (jobID) REFERENCES JobListing (jobID)
);

/*
Create Roles table and reference it to the various other entities.
It contains the list of the Roles which can be assigned to the Users.
*/

CREATE TABLE dbo.Roles (
    roleID int NOT NULL IDENTITY(1,1),
    roleName VARCHAR (50) NOT NULL,
    roleDescription VARCHAR (250),
    userID int,
    PRIMARY KEY (roleID),
    FOREIGN KEY (userID) REFERENCES Users (userID)
);

/*
Create Permission table and reference it to the various other entities.
It contains the Permission assigned to the User based on the Role being assigned.
*/

CREATE TABLE dbo.Permission(
    userID int NOT NULL,
    roleID int NOT NULL,
    permissionName VARCHAR(50) NOT NULL,
    CONSTRAINT PK_UserRoles
        PRIMARY KEY (userID, roleID),
    CONSTRAINT PK_Users
        FOREIGN KEY (userID) REFERENCES Users (userID),
    CONSTRAINT PK_Roles
        FOREIGN KEY (roleID) REFERENCES Roles(roleID)
);

/*
Create payroll table.
It contains the Payroll information about the Published Job on the Job Portal.
*/

CREATE TABLE dbo.Payroll(
    payrollID int NOT NULL IDENTITY(1,1),
    employeeID int,
    jobID int,
    PRIMARY KEY(payrollID),
    FOREIGN KEY (employeeID) REFERENCES StudentEmployee (employeeID),
    FOREIGN KEY (jobID) REFERENCES JobListing (jobID)
)

/*
Create Job Application table and reference it to the various other entities.
It is the MAIN TABLE which contains the information about LIST OF APPLICATIONS (Job Applied by Students). 
It includes information about the STUDENT WHO DOES NOT HAVE ANY JOB AND APPLIED FOR THE FIRST TIME.
Also, Student who has more than one job and applied for the new job too.
*/


CREATE TABLE dbo.JobApplication(
    applicationID int NOT NULL IDENTITY(1,1),
    jobID int,
    employeeID int,
    applicationName VARCHAR(50) NOT NULL,
	userID int NULL,
    PRIMARY KEY(applicationID),
    FOREIGN KEY (jobID) REFERENCES JobListing (jobID),
    FOREIGN KEY (employeeID) REFERENCES StudentEmployee (employeeID),
)

/*
Create Priority table.
The main purpose of the this table to make sure that STUDENT WITH NO JOBS IS GIVEN MORE PRIORITY 
THAN THE STUDENTS WHO HAVE ATLEAST ONE JOB.
*/

CREATE TABLE dbo.Priority(
    priorityQueueID int NOT NULL IDENTITY(1,1),
    employeeID int,
    applicationID int,
    PRIMARY KEY(priorityQueueID),
    FOREIGN KEY (employeeID) REFERENCES StudentEmployee (employeeID),
    FOREIGN KEY (applicationID) REFERENCES JobApplication (applicationID)
)

/*
Create User Job Status table.
It shows information about the Job Status of the Students who applied for the JOBS.
This information will help ADMINISTRATOR to GIVE PRIORITY TO THE STUDENT 
WITH NO JOBS follwed by STUDENTS WHO HAVE ATLEAST ONE JOB.
*/

CREATE TABLE dbo.UserJobStatus(
    employeeID int NULL,
    userID int NOT NULL,
    applicationID int NOT NULL,
    priorityQueueID int NOT NULL,
    jobStatus VARCHAR(50) NOT NULL,
    FOREIGN KEY (employeeID) REFERENCES StudentEmployee (employeeID),
    FOREIGN KEY (userID) REFERENCES Users (userID),
    FOREIGN KEY (applicationID) REFERENCES JobApplication (applicationID),
    FOREIGN KEY (priorityQueueID) REFERENCES Priority  (priorityQueueID)
)

-----------------------------------------------------------------------------------------------------------------------

/* INSERT SCRIPTS */

USE DMDD_FINAL_PROJECT
GO


/* INSERTing data in Address Table */

INSERT INTO dbo.Address 
VALUES('Huntington Ave', 'Roxbury', 'Boston', 'MA', 'USA', '02116')
INSERT INTO dbo.Address 
VALUES('Cambridge', 'Massachusetts Ave', 'Boston', 'MA', 'USA', '02138')
INSERT INTO dbo.Address 
VALUES('77 Massachusetts Ave', 'Cambridge', 'Boston', 'MA', 'USA', '02139')
INSERT INTO dbo.Address 
VALUES('450', 'Serra Mall', 'Stanford', 'MA', 'USA', '94305')
INSERT INTO dbo.Address 
VALUES('Providence', '', 'Providence', 'Rhode Island', 'USA', '02912')
INSERT INTO dbo.Address 
VALUES('Forest Ave', '', 'Tempe', 'Arizona', 'USA', '853281')
INSERT INTO dbo.Address 
VALUES('3551', 'Trousdale Pkwy', 'LA', 'California', 'USA', '02130')
INSERT INTO dbo.Address 
VALUES('5000', 'Forbes Ave', 'Pittsburg', 'Penselvenia', 'USA', '06130')
INSERT INTO dbo.Address 
VALUES('1130', 'Amstermdam Ave', 'Manhattan', 'New York', 'USA', '10027')
INSERT INTO dbo.Address 
VALUES('110', 'Sproul Hall', 'Berkeley', 'California', 'USA', '94720')
INSERT INTO dbo.Address
VALUES('360','Campus centerway','Amherst','Massachussets','USA','54890')

-- SELECT * FROM  dbo.Address

/* INSERTing data in University Table */

INSERT INTO dbo.University VALUES('Northeastern University', 1)
INSERT INTO dbo.University VALUES('Harvard University', 2)
INSERT INTO dbo.University VALUES('Massachusetts Institute of Technology', 3)
INSERT INTO dbo.University VALUES('Stanford University', 4)
INSERT INTO dbo.University VALUES('Brown University', 5)
INSERT INTO dbo.University VALUES('Arizona State University', 6)
INSERT INTO dbo.University VALUES('University of Southern California', 7)
INSERT INTO dbo.University VALUES('Carnegie Mellon University',8)
INSERT INTO dbo.University VALUES('Columbia University',9)
INSERT INTO dbo.University VALUES('University of California',10)
INSERT INTO dbo.University VALUES('University of Massachusetts',11)


-- SELECT * FROM dbo.University

/* IMPLEMENT LOGIC FOR THE PASSWORD ENCRYPTION FOR userPassword column in USERS table */

/* Password Encryption */
 
CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'Test_P@sswOrd';

CREATE CERTIFICATE TestCertificate
WITH SUBJECT = 'OnCampus Job Portal Test Certificate',
EXPIRY_DATE = '2026-10-31'

CREATE SYMMETRIC KEY TestSymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE TestCertificate;

OPEN SYMMETRIC KEY TestSymmetricKey
DECRYPTION BY CERTIFICATE TestCertificate;

/* INSERTing data INTO Users Table */

INSERT INTO dbo.Users (userName, userPassword, universityID) 
VALUES ('Jack01', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Jack@01')), 1);
INSERT INTO dbo.Users (userName, userPassword, universityID) 
VALUES ('Jill01', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Jill@01')), 2);
INSERT INTO dbo.Users (userName, userPassword, universityID)
VALUES ('Lisa', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Lisa@01')), 3)
INSERT INTO dbo.Users (userName, userPassword, universityID) VALUES
('Hetmyer', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Hetmyer@01')), 4),
('Mike', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Mike@01')), 5),
('Kyle', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Kyle@01')), 6),
('Anderson', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Anderson@01')), 7);
INSERT INTO dbo.Users (userName, userPassword, universityID) VALUES
('Warner', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Warner@01')), 8);
INSERT INTO dbo.Users (userName, userPassword, universityID) VALUES
('James', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'James@01')), 9),
('Gayle', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Gayle@01')), 10),
('Sachin', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Sachin@01')), 11),
('Virat', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Virat@01')), 12);
INSERT INTO dbo.Users (userName, userPassword, universityID) 
VALUES ('Zee', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Zee@01')), 1);
INSERT INTO dbo.Users (userName, userPassword, universityID)
VALUES 
('Jinal', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Jinal@01')), 1),
('Zeenia', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Zeenia@01')), 1),
('Tarun', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Tarun@01')), 1),
('Kiran', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Kiran@01')), 1),
('Dinesh', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Dinesh@01')), 1);
INSERT INTO dbo.Users (userName, userPassword, universityID) VALUES
('Akhil', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Akhil@01')), 2),
('Hasrha', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Hasrha@01')), 2),
('Priya', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Priya@01')), 3),
('Kashyap', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Kashyap@01')), 3),
('Divya', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Divya@01')), 4);

INSERT INTO dbo.Users (userName, userPassword, universityID) VALUES
('Jithendra', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Jithendra@01')), 4),
('Zack', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Zack@01')), 5),
('Tanmayi', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Tanmayi@01')), 5),
('Kieron', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Kieron@01')), 6),
('Rutvi', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Rutvi@01')), 6),
('Rajesh', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Rajesh@01')), 7),
('Anusha', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Anusha@01')), 7),
('Dilshan', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Dilshan@01')), 8),
('uday', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'uday@01')), 8),
('Kumar', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Kumar@01')), 9),
('Mounika', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Mounika@01')), 9),
('Viggy', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Viggy@01')), 10),
('Sudha', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Sudha@01')), 10),
('Bharat', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Bharat@01')), 11),
('Deekshit', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Deekshit@01')), 11),
('Sai', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Sai@01')), 12),
('Kumari', ENCRYPTBYKEY(KEY_GUID(N'TestSymmetricKey'), CONVERT(VARBINARY, 'Kumari@01')), 12);


--SELECT * FROM dbo.Users

/* INSERTing data INTO College Table */

INSERT INTO dbo.College VALUES ('College of Engineering', 1, 1)
INSERT INTO dbo.College VALUES ('College of Arts', 2, 1)
INSERT INTO dbo.College VALUES ('College of Science', 3, 2)
INSERT INTO dbo.College VALUES ('College of Biology', 4, 3)
INSERT INTO dbo.College VALUES ('College of Physics', 5, 4)
INSERT INTO dbo.College VALUES ('Anderson College', 6, 5)
INSERT INTO dbo.College VALUES ('Beaver College', 7, 6)
INSERT INTO dbo.College VALUES ('Gateway Technical College', 8, 7)
INSERT INTO dbo.College VALUES ('Denver Automotive and Diesel College', 9, 8)
INSERT INTO dbo.College VALUES ('Bellevue Community College', 10, 9)
INSERT INTO dbo.College VALUES ('Michiana College', 11, 10)
INSERT INTO dbo.College VALUES ('Cabrini College', 12, 11)


--SELECT * FROM dbo.College

/* INSERTing data in Department Table */

INSERT INTO dbo.Department VALUES ('Department of Engineering', 1, 1)
INSERT INTO dbo.Department VALUES ('Department of Arts', 2, 1)
INSERT INTO dbo.Department VALUES 
('Department of Science', 3, 2),
('Department of Biology', 4, 3),
('Department of Physics', 5, 4),
('Department of Chemistry', 6, 5),
('Department of Computer Science', 7, 6),
('Department of Electrical Engineering', 8, 7),
('Department of Architecture', 9, 8),
('Department of Literature', 10, 9),
('Department of Psychology', 11, 10),
('Department of Languages', 12, 11);

-- SELECT * FROM dbo.Department

/* INSERTing details in UserDetails Table */

INSERT INTO dbo.UserDetails 
VALUES
(1, 'jack@gmail.com', 9876543210, 1),
(2, 'jill@gmail.com', 9876543211, 1),
(3, 'lisa@gmail.com', 9876543220, 1),
(4, 'hetmyer@gmail.com', 9876542210, 1),
(5, 'mike@gmail.com', 9876243210, 1),
(6, 'kyle@gmail.com', 3876543210, 1),
(7, 'anderson@gmail.com', 6876553210, 7),
(8, 'warner@gmail.com', 2876543210, 8),
(9, 'james@gmail.com', 9276543210, 9),
(10, 'gayle@gmail.com', 7376543210, 10),
(11, 'sachin@gmail.com', 6876543210, 11),
(12, 'virat@gmail.com', 9176543210, 11),
(13, 'mamaniya.j@northeastern.edu', 8876543210, 1),
(14, 'singla.z@northeastern.edu', 7876543210, 1),
(15, 'balwani.t@northeastern.edu', 9846543210, 1),
(16, 'konda.saik@northeastern.edu', 9816543210, 1),
(17, 'potlapati.d@northeastern.edu', 5876543210, 1),
(18, 'jithendra@gmail.com', 5676543210, 4),
(19, 'zack@gmail.com', 9876543216, 5),
(20, 'tanmayi@gmail.com', 6576543210, 5),
(21, 'kieron@gmail.com', 2876543211, 6),
(22, 'rutvi@gmail.com', 4876543210, 6),
(23, 'rajesh@gmail.com', 3876543211, 7),
(24, 'anusha@gmail.com', 2876543212, 7),
(25, 'dilshan@gmail.com', 3876543220, 8),
(26, 'uday@gmail.com', 4876543214, 8),
(27, 'kumar@gmail.com', 9876543223, 9),
(28, 'mounika@gmail.com', 9876543222, 9),
(29, 'viggy@gmail.com', 9876543216, 10),
(30, 'sudha@gmail.com', 9876243210, 10),
(31, 'bharat@gmail.com', 9876543200, 11),
(32, 'deekshit@gmail.com', 987654322, 11),
(33, 'sai@gmail.com', 987654345, 11),
(34, 'kumari@gmail.com', 987654334, 11),
(35, 'akhil@gmail.com', 9876543223, 2),
(36, 'harsha@gmail.com', 9876523210, 2),
(37, 'priya@gmail.com', 9876513210, 3),
(38, 'kashyap@gmail.com', 9876543215, 3),
(39, 'divya@gmail.com', 9876542210, 4);


-- SELECT * FROM dbo.UserDetails

/* INSERTing details in UserJobStatus Table */

INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (1, 1, 1, 1, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (2, 2, 2, 2, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (3, 3, 3, 3, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (4, 4, 4, 4, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (5, 5, 5, 5, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (6, 6, 6, 6, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (7, 13, 7, 7, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (8, 14, 8, 8, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (9, 15, 9, 9, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (10, 16, 10, 10, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (11, 17, 11, 11, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (12, 35, 12, 12, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (13, 36, 13, 13, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (14, 38, 14, 14, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (15, 39, 15, 15, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (16, 29, 16, 16, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (17, 30, 17, 17, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (18, 10, 18, 18, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (18, 10, 1, 9, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (17, 30, 1, 9, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (13, 36, 1, 9, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (18, 10, 1, 1, N'EMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (NULL, 7, 1, 1, N'UNEMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (NULL, 8, 1, 1, N'UNEMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (NULL, 9, 1, 1, N'UNEMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (NULL, 10, 1, 1, N'UNEMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (NULL, 11, 2, 1, N'UNEMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (NULL, 12, 2, 1, N'UNEMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (NULL, 18, 2, 1, N'UNEMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (NULL, 19, 3, 1, N'UNEMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (NULL, 20, 3, 1, N'UNEMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (NULL, 21, 3, 1, N'UNEMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (NULL, 22, 4, 1, N'UNEMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (NULL, 23, 4, 1, N'UNEMPLOYED')
INSERT dbo.UserJobStatus (employeeID, userID, applicationID, priorityQueueID, jobStatus) VALUES (NULL, 24, 4, 1, N'UNEMPLOYED')

--SELECT * FROM dbo.UserJobStatus


/* INSERTing details in Employer Table */

INSERT INTO dbo.Employer VALUES ('Dean', 1, 1)
INSERT INTO dbo.Employer VALUES ('Professor', 2, 2)
INSERT INTO dbo.Employer VALUES ('Director', 3, 3)
INSERT INTO dbo.Employer VALUES ('Asst Director', 4, 4)
INSERT INTO dbo.Employer VALUES ('Supervisor', 5, 5)
INSERT INTO dbo.Employer VALUES ('Asst Supervisor', 6, 6)
INSERT INTO dbo.Employer VALUES ('Head of the Department', 7, 7)
INSERT INTO dbo.Employer VALUES ('Asst Director', 8, 8)
INSERT INTO dbo.Employer VALUES ('Asst Professor', 9, 9)
INSERT INTO dbo.Employer VALUES ('Sports Cheif ', 10, 10)
INSERT INTO dbo.Employer VALUES ('Admissions Head', 11, 11)
INSERT INTO dbo.Employer VALUES ('Library Head', 12, 12)

-- SELECT  * FROM dbo.Employer 


/* INSERTing data INTO JobListing */

INSERT INTO dbo.JobListing VALUES ('Accountant', 1, 1)
INSERT INTO dbo.JobListing VALUES ('Teaching Assistant', 2, 2)
INSERT INTO dbo.JobListing VALUES ('Personal Assistant', 3, 3)
INSERT INTO dbo.JobListing VALUES ('Charted Accountant', 4, 4)
INSERT INTO dbo.JobListing VALUES ('Proctor', 5, 5)
INSERT INTO dbo.JobListing VALUES ('Research Assistant', 6, 6)
INSERT INTO dbo.JobListing VALUES ('Student Success Guide', 7, 7)
INSERT INTO dbo.JobListing VALUES ('Grading Assistant', 8, 8)
INSERT INTO dbo.JobListing VALUES ('College Ambassdor', 9, 9)
INSERT INTO dbo.JobListing VALUES ('Sports Cordinator', 10, 10)
INSERT INTO dbo.JobListing VALUES ('IT Assistant', 11, 11)
INSERT INTO dbo.JobListing VALUES ('Medical Assistant ', 12, 12)

--SELECT * FROM dbo.JobListing


/* INSERTing Data INTO JobDescription */

INSERT INTO dbo.JobDescription 
VALUES ('2', 'On-Campus-Non-Work-Study', 22, 'To inancial decisions by collecting, tracking, and correcting the companys finances.' , 1);
INSERT INTO dbo.JobDescription 
VALUES ('3', 'On-Campus-Work-Study', 12, 'To provides support and assistance to individual students or small groups.',2);
INSERT INTO dbo.JobDescription 
VALUES ('4', 'On-Campus-Non-Work-Study', 32, 'To complete clerical tasks for senior-level staff members. ',3);
INSERT INTO dbo.JobDescription 
VALUES ('6', 'Off-Campus-Work-Study', 42, ' To use their accounting expertise to guide their clients financial plans ',4);
INSERT INTO dbo.JobDescription 
VALUES ('5', 'On-Campus-Work-Study', 12, 'To oversee and participates in the administration of written tests, performance tests',5);
INSERT INTO dbo.JobDescription 
VALUES ('8', 'On-Campus-Work-Study', 22, 'To conduct literature searches, data management, recruiting participants',6);
INSERT INTO dbo.JobDescription 
VALUES ('9', 'Off-Campus-Work-Study', 32, 'To assist students in online programs in their growth and development ',7);
INSERT INTO dbo.JobDescription 
VALUES ('3', 'On-Campus-Non-Work-Study', 12, 'To grad homework, papers, laboratory reports, or examinations ',8);
INSERT INTO dbo.JobDescription 
VALUES ('2', 'On-Campus-Work-Study', 42, 'To call or email candidates, assisting with campus tours',9);
INSERT INTO dbo.JobDescription 
VALUES ('4', 'Off-Campus-Work-Study', 32, 'To coordinate team video operation, production ',10);
INSERT INTO dbo.JobDescription 
VALUES ('1', 'On-Campus-Work-Study', 42, 'To support and maintain in-house computer systems, desktops',11);
INSERT INTO dbo.JobDescription 
VALUES ('6', 'Off-Campus-Work-Study', 12, 'To manage provider flow, rooming patients, collecting vital signs ',12);

-- SELECT * FROM dbo.JobDescription


/* INSERTing Data INTO JobApplication */

INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(1,1,'Application for Accountant',1)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(2,2,'Application for Teaching Assistant',2)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(3,3,'Personal Assistant Application',3)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(4,4,'Charted Accountant Application',4)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(5,5,'Application for Proctor',5)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(6,6,'Research Assistant Application',6)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(7,7,'Application Form for Student Success Guide',13)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(8,8,'Grading Assistant Application',14)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(9,9,'College Ambassdor',15)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(10,10,'Sports Cordinator',16)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(11,11,'IT Assistant Application form',17)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(1,12,'Medical Assistant',35)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(2,13,'Application for Accountant',36)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(3,14,'Application for Teaching Assistant',38)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(5,15,'Personal Assistant Application',39)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(5,16,'Charted Accountant Application',29)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(5,17,'Application for Proctor',30)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(7,18,'IT Assistant Application form',10)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(20, 2, 2, N'Application for Teaching Assistant', 30)
INSERT INTO dbo.JobApplication(jobID,employeeID,applicationName) VALUES(31, 12, 13, N'Application for Teaching Assistant', 19)

-- SELECT * FROM dbo.JobApplication


/* INSERTing Data INTO StudentEmployee */

INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (1, 20, 22)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (2, 15, 12)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (3, 10, 22)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (4, 10, 15)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (5, 15, 16)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (6, 12, 18)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (13, 20, 22)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (14, 20, 19)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (15, 20, 15)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (16, 20, 15)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (17, 20, 15)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (35, 12, 22)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (36, 8, 20)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (38, 12, 20)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (39, 12, 14)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (29, 20, 14)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (30, 8, 12)
INSERT dbo.StudentEmployee(userID, hoursPerWeek, wagesPerHour) VALUES (10, 8, 15)

-- SELECT * FROM StudentEmployee


/* INSERTing Data INTO Payroll */

INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(1,1)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(2,2)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(3,3)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(4,4)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(5,5)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(6,6)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(7,7)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(8,8)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(9,9)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(10,10)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(11,11)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(12,1)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(13,2)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(14,3)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(15,5)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(16,5)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(17,5)
INSERT INTO dbo.Payroll(employeeID,jobID) VALUES(18,7)

-- SELECT * FROM dbo.Payroll


/* INSERTing Data INTO Priority */

INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(1,1)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(2,2)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(3,3)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(4,4)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(5,5)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(6,6)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(7,7)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(8,8)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(9,9)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(10,10)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(11,11)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(12,12)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(13,13)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(14,14)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(15,15)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(16,16)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(17,17)
INSERT INTO dbo.Priority(employeeID,applicationID) VALUES(18,18)

-- SELECT * FROM dbo.Priority

/* INSERTing Data INTO Roles */

INSERT INTO dbo.Roles 
(roleName,roleDescription,userID) VALUES 
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',1),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',2),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',3),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',4),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',5),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',6),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',7),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',8),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',9),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',10),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',11),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',12),
('ADMIN','AN ADMIN CAN ADD/REMOVE/VIEW JOBS',13),
('ADMIN','AN ADMIN CAN ADD/REMOVE/VIEW JOBS',14),
('ADMIN','AN ADMIN CAN ADD/REMOVE/VIEW JOBS',15),
('ADMIN','AN ADMIN CAN ADD/REMOVE/VIEW JOBS',16),
('ADMIN','AN ADMIN CAN ADD/REMOVE/VIEW JOBS',17),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',18),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',19),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',20),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',21),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',22),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',23),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',24),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',25),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',26),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',27),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',28),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',29),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',30),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',31),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',32),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',33),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',34),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',35),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',36),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',37),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',38),
('STUDENT','STUDENT CAN VIEW AND APPLY TO JOBS',39)

-- SELECT * FROM dbo.Roles


/* INSERTing Data INTO Permission *
VA: View and Apply, AVUD: Add, View, Update and Delete */

INSERT INTO dbo.Permission  
(userID ,roleID ,permissionName) VALUES 
(1,1,'VA'),
(2,2,'VA'),
(3,3,'VA'),
(4,4,'VA'),
(5,5,'VA'),
(6,6,'VA'),
(7,7,'VA'),
(8,8,'VA'),
(9,9,'VA'),
(10,10,'VA'),
(11,11,'VA'),
(12,12,'VA'),
(13,13,'AVUD'),
(14,14,'AVUD'),
(15,15,'AVUD'),
(16,16,'AVUD'),
(17,17,'AVUD'),
(18,18,'VA'),
(19,19,'VA'),
(20,20,'VA'),
(21,21,'VA'),
(22,22,'VA'),
(23,23,'VA'),
(24,24,'VA'),
(25,25,'VA'),
(26,26,'VA'),
(27,27,'VA'),
(28,28,'VA'),
(29,29,'VA'),
(30,30,'VA'),
(31,31,'VA'),
(32,32,'VA'),
(33,33,'VA'),
(34,34,'VA'),
(35,35,'VA'),
(36,36,'VA'),
(37,37,'VA'),
(38,38,'VA'),
(39,39,'VA')

-- SELECT * FROM dbo.Permission

-----------------------------------------------------------------------------------------------------------------------------------------------------

/* COMPUTATIONAL COLUMN CALCULATION */

/* biWeeklyPayroll is COMPUTATIONAL CALCULATION displayes the Bi-Weekly Payment based on 2 week payroll given (hoursPerWeek * (2)) * wagesPerHour*/

ALTER TABLE dbo.StudentEmployee 
ADD biweeklyPayroll AS (hoursPerWeek * 2 * wagesPerHour)

-----------------------------------------------------------------------------------------------------------------------------------------------------

/* Function and  TABLE-LEVEL CHECK Constarint 1 */

USE DMDD_FINAL_PROJECT
GO


/*
Created function and added  TABLE-LEVEL CHECK constraint for the 
business rule: Student cannot apply for the same job again.
*/

CREATE FUNCTION chk_same_job_application(@jobID int, @userID int)
RETURNS BIT
AS 
BEGIN
	IF(SELECT COUNT(*) FROM dbo.JobApplication WHERE jobID = @jobID AND userID = @userID) > 1
	BEGIN 
		RETURN 1
	END
		RETURN 0
END


ALTER TABLE dbo.JobApplication
WITH NOCHECK ADD CONSTRAINT chk_duplicate_job_application CHECK (dbo.chk_same_job_application(JobApplication.jobID,JobApplication.userID) = 0);



/* Function and TABLE-LEVEL CHECK Constarint 2 */

/*
Created function and added table-level check constraint for the business rule: User Name should be UNIQUE
*/

CREATE FUNCTION chk_duplication_username (@user_name VARCHAR(50))
RETURNS bit
AS

BEGIN

    IF (SELECT count(*) FROM   dbo.users WHERE  users.username = @user_name) > 1

    BEGIN

        RETURN 1

    END
    
    RETURN 0

END

--
-- Adding Check Constraint
ALTER TABLE dbo.Users WITH NOCHECK add CONSTRAINT chk_duplicate1 CHECK (dbo.chk_duplication_username(Users.userName) = 0);


/* CHECK Constarint 3 */

/*
Created function and added check constraint for the business rule: Student cannot work more than 20 hours per week for any on-campus job/jobs.
*/

ALTER TABLE dbo.StudentEmployee ADD CONSTRAINT chk_wages CHECK(hoursPerWeek<=20)

------------------------------------------------------------------------------------------------------------------------------------------

/* TRIGGER AFTER INSERT AND UPDATE */

USE DMDD_FINAL_PROJECT
GO

/* Trigger is created for the business rule: Student belongs to particular college/department can apply for the job in same university and college else
   Error will be raised.
 */

CREATE TRIGGER tr_jobApplication
ON JobApplication 
AFTER INSERT,UPDATE
AS BEGIN
	DECLARE @user_uni_id int;
	DECLARE @employer_uni_id int;
	SELECT @user_uni_id = u.universityID from Users u
						  INNER JOIN INSERTED i on i.userID = u.userID 
						  

SELECT  @employer_uni_id =  u.universityID FROM INSERTED i 
								inner join JobListing jl on i.jobID = jl.jobID 
								inner join Employer e on jl.employerID = e.employerID 
								inner join Users u on e.userID = u.userID 
		
								IF @user_uni_id <> @employer_uni_id 
RAISERROR('You Cannot Apply to this Job',16,1)
	
	
END 

------------------------------------------------------------------------------------------------------------------------------

/* VIEWS */

USE DMDD_FINAL_PROJECT
GO

/* VIEW 1 : Below view will display the Students details who are EMPLOYED. 
Details are combined from the various tables.
*/

CREATE VIEW  dbo.[Employeed Students]
AS
	SELECT u.userName [Student Name], uds.userEmail [Email Address], uds.userMobile [User Mobile],
	jl.jobName [Job Name], ja.applicationName [Application Name], semp.hoursPerWeek [Hours Per Week], 
	semp.wagesPerHour [Wages Per Hour],semp.biWeeklyPayroll [Bi-Weekly Payment Amount]
	FROM UserJobStatus ujs
	INNER JOIN UserDetails uds ON uds.userID = ujs.userID
	INNER JOIN Users u ON u.userID = ujs.userID
	INNER JOIN StudentEmployee semp ON semp.employeeID = ujs.employeeID
	INNER JOIN JobApplication ja ON ja.applicationID = ujs.applicationID
	INNER JOIN JobListing jl ON jl.jobID = ja.jobID
	WHERE ujs.jobStatus = 'EMPLOYED'

SELECT * FROM dbo.[Employeed Students]


/* VIEW 2  : Below view will display the Students details who are UNEMPLOYED. 
Details are combined from the various tables.
*/

CREATE VIEW  dbo.[UnEmployeed Students]
AS
	SELECT u.userName [Student Name], uds.userEmail [Email Address], uds.userMobile [User Mobile],
	jl.jobName [Applied Job Name], ja.applicationName [Applied Application Name]
	FROM UserJobStatus ujs
	INNER JOIN UserDetails uds ON uds.userID = ujs.userID
	INNER JOIN Users u ON u.userID = ujs.userID
	INNER JOIN JobApplication ja ON ja.applicationID = ujs.applicationID
	INNER JOIN JobListing jl ON jl.jobID = ja.jobID
	WHERE ujs.jobStatus = 'UNEMPLOYED'

SELECT * FROM dbo.[UnEmployeed Students]


/* VIEW 3 : Below view will display the number of application received against the published 
job on the portal.
*/

USE DMDD_FINAL_PROJECT
GO

CREATE VIEW [Total Number of Applied Jobs] AS
	SELECT jl.jobName [List of Jobs], COUNT(*) [Total number of Application Applied]
	FROM dbo.JobApplication ja
	INNER JOIN JobListing jl ON jl.jobID = ja.jobID
	GROUP BY ja.jobid, jl.jobName
	

SELECT * FROM [Total Number of Applied Jobs] ORDER BY [Total number of Application Applied] DESC