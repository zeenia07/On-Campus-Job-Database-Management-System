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