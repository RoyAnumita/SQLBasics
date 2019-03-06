USE tempdb
GO

 DROP TABLE IF EXISTS dbo.Persons; 

CREATE TABLE Persons (
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255),
	Age int 
);

BULK INSERT Persons FROM 'E:\Sandipan\ReadingMaterials\sql\data\Dataset1.csv'
   WITH (
      FIELDTERMINATOR = ',',
      ROWTERMINATOR = '\n'
);
GO

select TOP 2 * from Persons;

DROP TABLE IF EXISTS STUDENT

CREATE TABLE STUDENT (
    ID int NOT NULL UNIQUE,
    City varchar(255) NOT NULL,
	Age int , /* DEFAULT 9999 CHECK (AGE > 15)*/
	PRIMARY KEY (ID),
	CHECK (Age > 15)
);

BULK INSERT STUDENT FROM 'E:\Sandipan\ReadingMaterials\sql\data\StudentData.csv'
   WITH (
      FIELDTERMINATOR = ',',
      ROWTERMINATOR = '\n'
);
GO

alter table STUDENT add constraint CHECK_CONST check (AGE > 15);

select * from STUDENT
select sum(Age) from STUDENT
select sum(Age) from STUDENT where Age is NOT NULL

-- Create Index
CREATE INDEX index_Student on STUDENT (ID,CITY);
DROP INDEX STUDENT.index_Student;

SELECT * 
	FROM INFORMATION_SCHEMA.COLUMNS
		WHERE table_name = 'STUDENT'

SELECT TOP 3 age FROM STUDENT
ORDER BY NEWID()