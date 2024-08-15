--Using DML to Modify Data
-------------------------
--==================================================
--Generating Automatic Column Values
--==================================================
--1)Using IDENTITY
-------------------
/*
--The IDENTITY property generates column values automatically
*)Optional seed and increment values can be provided
*)Only one column in a table may have IDENTITY defined 
*)IDENTITY column must be omitted in a normal INSERT statement
*)Functions are provided to return last generated values
    SELECT @@IDENTITY: default scope is session
    SELECT SCOPE_IDENTITY(): scope is object containing the call in function and procedure 
    SELECT IDENT_CURRENT(' tablename'): in this case, scope is defined by tablename
There is a setting to allow identity columns to be changed manually ON or automatic OFF
SET IDENTITY_INSERT <Tablename> [ON|OFF]
*/
use tempdb
go
CREATE TABLE Books(PID int IDENTITY(1,1) NOT NULL, Name VARCHAR(15))
go
INSERT INTO Books (Name) VALUES ('MOC 2072 Manual')  
select * from Books

set identity_insert books on;
 
INSERT INTO Books(PID,Name)  VALUES (2,'MOC SQL Query ')

select * from books

set identity_insert books off;

INSERT INTO Books(Name)  VALUES ('MOC SQL Query 2017 ')

select * from Books

-----------------------------------------------------------
SELECT IDENT_CURRENT('books');
select ident_seed('books');
select IDENT_INCR('books');

select @@IDENTITY
SELECT SCOPE_IDENTITY()

----------------------------------------------------------------------------------------
--2)Using Sequences
--------------------
/*
Sequence objects were first added in SQL Server 2012
Independent objects in database

More flexible than the IDENTITY property
Can be used as default value for a column
Manage with CREATE/ALTER/DROP statements
Retrieve value with the NEXT VALUE FOR clause
*/

-- Define a sequence
CREATE SEQUENCE dbo.InvoiceSeq AS INT START WITH 1 INCREMENT BY 1;


-- Retrieve next available value from sequence
SELECT NEXT VALUE FOR dbo.InvoiceSeq;




/*
ALTER SEQUENCE [schema_name. ] sequence_name  
    [ RESTART [ WITH <constant> ] ]  
    [ INCREMENT BY <constant> ]  
    [ { MINVALUE <constant> } | { NO MINVALUE } ]  
    [ { MAXVALUE <constant> } | { NO MAXVALUE } ]  
    [ CYCLE | { NO CYCLE } ]  
    [ { CACHE [ <constant> ] } | { NO CACHE } ]  
    [ ; ]  
*/
alter sequence dbo.InvoiceSeq RESTART with 20 INCREMENT BY 2 MINVALUE 2   MAXVALUE 50 CYCLE  ;
------------------------------------------------------------------
 Drop sequence dbo.InvoiceSeq 

 --Best
if object_Id('dbo.InvoiceSeq') is Not Null
begin
 Drop sequence dbo.InvoiceSeq 
end
   
go
CREATE SEQUENCE dbo.InvoiceSeq AS INT START WITH 1 INCREMENT BY 1;
go
Create table subjects (ID int primary key , SuubjectName nvarchar(50))
go 
insert into subjects values (NEXT VALUE FOR dbo.InvoiceSeq,'SQl Query ') 
select * from subjects 


insert into subjects values (100,'SQl Query ')
insert into subjects values (NEXT VALUE FOR dbo.InvoiceSeq,'SQl Query ')
select * from subjects 
-----------------------------------------------------------------------------
--------------------------
--Advanced 
/* GUIDS
---------
- Data Integrity Rule Number 1 is All rows must be unique.
- Real Life Have Multiple rows are identical and correct.
- GUID Randomly generated values.
- Use GUID to switch Identical data to uniquely values.
- Use GUID by :- 1) Column Datatype Uniqueidentifier.
                 2) Functions NEWID(), NEWSEQUENTIALID().
-----------------------------------------------------------
* NEWID(), NEWSEQUENTIALID()
-------------------------------
- Generate a values based on :- CPU clock, NetworkCard
- NEWID() un order random GUID.
- NEWSEQUENTIALID() generate sequentialy values.
- NEWID() make issues for Indexing.
- NEWSEQUENTIALID() good for Indexing bad for security.
------------------------------------------------------------- */
-- Select NEW() 
SELECT NEWID()

-- CREATE NEWID() COLUMN
CREATE TABLE NEWID_TABLE
(
       ID UNIQUEIDENTIFIER DEFAULT NEWID() ,
	   NAME NVARCHAR(100) ,
	   TITLE  NVARCHAR(100)
)
GO
-- PUT DATA 
INSERT INTO NEWID_TABLE(NAME,TITLE)
VALUES ( 'Osama', 'Maneger'),
       ( 'Sayed', 'Employee'),
	   ( 'Retaj','Developer')
GO
-- SEE RESULT
SELECT * FROM NEWID_TABLE
GO
--Clean
DROP TABLE NEWID_TABLE
GO
----------------------------------------------------

-- Create Column With SequentialID()
CREATE TABLE SEQUENTIALEDID_TABLE
(
       ID UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
	   NAME NVARCHAR(100) ,
	   TITLE  NVARCHAR(100)
)
GO
-- PUT DATA 
INSERT INTO SEQUENTIALEDID_TABLE(NAME,TITLE)
VALUES ( 'Osama', 'Maneger'),
       ( 'Sayed', 'Employee'),
	   ( 'Retaj','Developer')
GO
-- SEE RESULT
SELECT * FROM SEQUENTIALEDID_TABLE
GO
--Clean
DROP TABLE SEQUENTIALEDID_TABLE
----------------------------------
-- NEWID Tricks
---------------
-- 1) Generate A random decimal number
SELECT RAND( CHECKSUM( NEWID()));
GO
--OR 
SELECT RAND() 
GO

-- 2) Random Float Number between 
SELECT 20*RAND()                     -- Float From 0-20
SELECT 10 + (30-10)*RAND()           -- Float FROM 10-30
SELECT round(10 + (30-10)*RAND(),0)  -- int FROM 10-30

-- 3) Generate A random number
SELECT ABS(CHECKSUM(NEWID()))
GO

-- 4) Generate Random Numbers between Rang
SELECT CONVERT(INT, (100+1)*RAND()) -- FROM 0-100
GO

--OR 
DECLARE @Random INT;
DECLARE @Upper INT;
DECLARE @Lower INT
---- This will create a random number between 1 and 999
SET @Lower = 1 ---- The lowest random number
SET @Upper = 999 ---- The highest random number
SELECT @Random = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
SELECT @Random


-- 5) Retrieving Random Rows from Table 
select * from employees order by (NewID())
select top(3)* from employees order by (NewID())

