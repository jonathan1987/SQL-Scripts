-- Bulk adding users in MS SQL Server
-- Assumes you have a csv file of ID and list of usernames to add
-- and that the users exist in your windows domain controller/machine
-- CSV file should be similar to the following

-- id   username
-- 1    usr1
-- 2    usr2
-- ...  ...
-- n    usrn

-- Author: Jonathan Hernandez jayhernandez1987@gmail.com

USE master
GO
CREATE TABLE #temptable
(id INT, username VARCHAR(20));
go
BULK INSERT #temptable from "<location of where you put the csv file of list of users to add in bulk>"
WITH
(FIELDTERMINATOR = ',', ROWTERMINATOR - '/n')
GO

-- create the logins with the newlu create temp table

DECLARE @ctr INT, @total INT, @usr VARCHAR(20), @cmd VARCHAR(200)
SET @ctr = 1;
SET @total = (SELECT COUNT(*) FROM @temptable)
WHILE (@ctr <= @total)
BEGIN
    SELECT @usr = username FROM #temptable WHERE id = @ctr
    SET @cmd = 'CREATE LOGIN [<whatever the name of your windows domain controller or machine name>' + @usr + '] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]'
    EXEC (@cmd)
    SET @ctr = @ctr + 1
END
