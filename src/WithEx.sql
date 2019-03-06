USE tempdb
GO

DROP TABLE IF EXISTS dbo.EMPLOYE; 

CREATE TABLE EMPLOYE (
    EmployeeID int,
    Name varchar(255),
    Salary INT
);

BULK INSERT EMPLOYE FROM 'E:\Sandipan\ReadingMaterials\sql\data\EmployeeData.csv'
   WITH (
      FIELDTERMINATOR = ',',
      ROWTERMINATOR = '\n'
);
GO

select * from EMPLOYE

WITH TEMPTABLE(AVG_SALARY) AS
	(SELECT AVG(SALARY) FROM EMPLOYE)
		SELECT EMPLOYEEID, NAME, SALARY FROM EMPLOYE,TEMPTABLE
			WHERE EMPLOYE.Salary > TEMPTABLE.AVG_SALARY;

/*
	Find all the airlines where the total salary of all pilots in 
	that airline is more than the average of total salary of all pilots in the database.
*/

