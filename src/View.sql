USE tempdb
GO

CREATE VIEW View_Person as
	SELECT PersonID, Age FROM Persons
		WHERE AGE >= 15;