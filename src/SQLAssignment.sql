USE tempdb
GO

/*
	===========================
	| START: DATA PREPARATION |
	===========================

Create a Random table containing the following information:
●	timestamp (e.g., “2018-01-05 13:20:10”)
●	user_id (e.g., “10000133”,“50600182”)
●	action_type (e.g., “purchase”,”visit”,”view”)
The table contains 3 columns for the variables, 800 rows, 50 distinct user_ids and 5 distinct action_types. 

--->>>>NO COMMENTS have been provided at data preparation part.
*/
 DROP TABLE IF EXISTS dbo.Auto1Question3; 

CREATE TABLE Auto1Question3 (
    UserId int,
    Date_Time_stamp varchar(255),
    Actiontype  varchar(255)     
);

INSERT INTO Auto1Question3(Date_Time_stamp) VALUES('2018-12-13 09:41:53d');

BULK INSERT Auto1Question3 FROM 'D:\Sandipan\Auto1\Inputs\SQLExerciseInputData.csv'
   WITH (
      FIELDTERMINATOR = ',',
      ROWTERMINATOR = '\n'
);
GO


UPDATE Auto1Question3
SET Date_Time_stamp = LEFT(Date_Time_stamp, LEN(Date_Time_stamp) - 1);  

DROP TABLE IF EXISTS dbo.FinalAuto1Question3;

SELECT	UserId,
		convert(datetime,Date_Time_stamp ) as DateTimeStamp,
		Actiontype
INTO FinalAuto1Question3
FROM Auto1Question3
	WHERE UserId IS NOT NULL;

DROP TABLE IF EXISTS dbo.Auto1Question3;
DBCC FREESYSTEMCACHE ('ALL') 
DBCC FREESESSIONCACHE
DBCC FREEPROCCACHE

/*
	===========================
	| FINISH: DATA PREPARATION |
	===========================
	Additionaly 
	1. Droping Raw Table.
	2. Free the memory after dropping.

==================================================================================================
==================================================================================================

 QUESTION - 3A :
 Write a SQL query that allows you to find the row with the first (oldest) action in the dataset
*/

SELECT 
	TOP 1 *
FROM FinalAuto1Question3 
WHERE DateTimeStamp = (SELECT min(DateTimeStamp) FROM FinalAuto1Question3)

/*
 QUESTION 3B:
 Write a SQL query that allows you to find, for each user, the first action and the associated timestamp. 

  APPROACH:
 1. Get First Action Date-Time by users.
 2. Verifying which Date-Time is the First Action by the specific user.
 3. Return the record if Date-Time and First Action is same.
 */

SELECT UserId, 
       DateTimeStamp,
       Actiontype
FROM (
		SELECT	UserId, 
				DateTimeStamp,
				min(DateTimeStamp) OVER (PARTITION BY UserId) AS FirstActiondate,
				Actiontype
		FROM FinalAuto1Question3
	) AS temp
WHERE DateTimeStamp = FirstActiondate
ORDER BY UserId;

/*
 QUESTION 3C:
 Write a SQL query that allows you to compute the two day retention KPI, i.e. 
 find the share of users that performed an action the day after their respective first action.

 APPROACH:
 1. Get First Action Date-Time by users.
 2. Get Second Action Date-Time by users.
 3. Check if Second Action Date is 2 days after First Action Date.
 4. Return those Users list.

*/

SELECT a.UserId
FROM (
		SELECT	UserId, 
				min(DateTimeStamp)  AS FirstActiondate
		FROM FinalAuto1Question3
		GROUP BY UserId) AS a 
	INNER JOIN
		(SELECT	UserId,
				min(DateTimeStamp) AS SECONDHIGHEST 
		FROM FinalAuto1Question3 AS a
			WHERE DateTimeStamp > (SELECT min(DateTimeStamp) FROM FinalAuto1Question3 AS b	WHERE a.Userid = b.Userid) 
			GROUP BY Userid) AS b 
		ON a.UserId = b.UserId
WHERE DATEDIFF(DAY,a.FirstActiondate,b.SECONDHIGHEST)  > 2