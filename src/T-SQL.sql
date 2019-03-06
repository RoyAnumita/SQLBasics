USE tempdb
GO

select * from Persons;

BEGIN TRANSACTION TR1;
	update Persons set Address = 'Age-12' where Age = 12;
SAVE TRAN TR1;

BEGIN TRANSACTION TR2;
	update Persons set Address = 'Age-32' where Age = 32;
SAVE TRAN TR2;

ROLLBACK TRAN TR2;

-- With Try and Catch;
BEGIN TRY
	BEGIN TRANSACTION TR1;
		DELETE FROM Persons where Age = 12;
		update Persons set Address = 'ABX' where Age = 32;
END TRY
BEGIN CATCH
	ROLLBACK;
END CATCH

select * from Persons;
ROLLBACK TRAN TR1;
