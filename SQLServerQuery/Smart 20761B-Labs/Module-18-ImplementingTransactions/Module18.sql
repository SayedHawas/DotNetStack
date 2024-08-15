/*
Module 18
Implementing Transactions
-----------------------------
-- lessons :-
--------------
	   1- Transactions and the Database Engine.
	   2- Controlling Transactions.
--------------------------------------------------------------------------------------------
-- Lesson 1) Transactions and the Database Engine  :-
-------------------------------------------------------
       - A transaction is a group of tasks defining a unit of work.
	   - The entire unit must succeed or fail together – no partial completion is permitted.
       - Individual data modification statements are automatically treated as standalone transactions.
       - User transactions can be managed with T-SQL commands: BEGIN/ COMMIT/ROLLBACK TRANSACTION.
	   - SQL Server uses locking mechanisms and the transaction log to support transactions.
	   - Transaction commands identify blocks of code that must succeed or fail together,
	         and provide points where database engine can roll back, or undo, operations.
---------------------------------------------------------------------------------------------
-- Lesson 2) Controlling Transactions  :-
-------------------------------------------
    - BEGIN TRANSACTION :-
	----------------------
	        - BEGIN TRANSACTION marks the starting point of an explicit, user-defined transaction.
			- Transactions last until :-
			               A) COMMIT statement is issued.
			               B) ROLLBACK is manually issued. 
						   C) The connection is broken and the system issues a ROLLBACK.
			- In your T-SQL code: Mark the start of the transaction's work.
	- COMMIT TRANSACTION :-
	-----------------------
	        - COMMIT ensures all of the transaction's modifications are made a permanent part of the database.
			- COMMIT frees resources, such as locks, used by the transaction
			- In your T-SQL code: If a transaction is successful, commit it.
	- ROLLBACK TRANSACTION :-
	-------------------------
	        - A ROLLBACK statement undoes all modifications made in the transaction ,
			  by reverting the data to the state it was in at the beginning of the transaction .
			- ROLLBACK frees resources, such as locks, held by the transaction.
			- Before rolling back, you can test the state of the transaction with the XACT_STATE function.
			- In your T-SQL code: If an error occurs, ROLLBACK to the point of the BEGIN TRANSACTION statement.
	- Using XACT_ABORT :- 
	-----------------------
	        - SQL Server does not automatically roll back transactions when errors occur.
			- To roll back, either use ROLLBACK statements in error-handling logic or enable XACT_ABORT.
			- XACT_ABORT specifies whether SQL Server automatically rolls back the current transaction when a runtime error occurs.
			- SET XACT_ABORT OFF is the default setting.
			- Change XACT_ABORT value with the SET command :- " SET XACT_ABORT ON "
----------------------------------------------------------------------------------------------------------------------------------
-- Understanding of Transactions and Locks
-- ---------------------------------------
-- Review On Transactions:
-- ----------------------
-1- Transactions allow you to define a unit of activity that will be considered 
    atomic :all or nothing.
-2- Transactions are known as ACID (Atomicity, Consistency, Isolation, and Durability).
    * Atomicity ( One Failed All Failed )
    * Consistency ( Data must be in a good form )
    * Isolation (Transaction must be isolated from others ) 
    * Durability (Transaction must be permanent in DB )
-3- Note : Whenever you submit a change to the database, SQL Server first checks 
           whether the pages that need to be affected already reside in cache.
           If they do, the pages are modified in cache. 
           If they don't, they're first loaded from disk into the cache and modified
           there. 
     -SQL Server records the changes in the database's transaction log. 
     Once in a while, a process called checkpoint flushes changed pages 
     ("dirty pages") from cache to the data portion of the database on disk.
-- Every transaction is recorded on DB log to  later recovery (Demonstration)
   Committed   --Rollforward ,written to DB
   Uncommitted --Rollback
-- Locking is used to prevent users from reading data  
   that is in the process of being modified
-- Locking is automatic.
-- Without locking, the database may become logically  incorrect, 
   updates may be lost, and queries against the data may produce 
   unexpected results.
-- SQL server automatically manages locking on the database or its objects OR -
   You Can use locking hints, 
   you use special statements to configure the rules for setting and    
   releasing locks. However, using locking hints is not recommended. 
-- Two main types of lock:
		Read locks – Allow others to read but not write
		Write locks – Stop others from reading or writing
-- Locks prevent update conflicts
*/
-- Managing Transactions:
-- Types of transactions
-- ---------------------
-- Autocommit Transactions (Default)
-- ---------------------------------
-- Every statement is committed or rolled back 
   --when it has completed
--If it completes successfully : it is committed
--If it fails : it is rolled back
-------------------------------------------------------------------
CREATE TABLE NewTable (Id INT PRIMARY KEY, Info CHAR(3))   --fail
INSERT INTO NewTable VALUES (3, 'aaa')
INSERT INTO NewTable VALUES (1, 'bbb')
INSERT INTO NewTable VALUSE (3, 'ccc') -- Syntax Error
GO
SELECT * FROM NewTable -- Returns no rows.
GO
-------------------------------------------------------------------
--try
CREATE TABLE NewTable (Id INT PRIMARY KEY, Info CHAR(3))   --done
go
INSERT INTO NewTable VALUES (3, 'aaa')
INSERT INTO NewTable VALUES (1, 'bbb')
INSERT INTO NewTable VALUSE (3, 'ccc') -- Syntax Error
GO
SELECT * FROM NewTable -- Returns no rows.
GO
------------------------------------------------------------------- 
/*
- Committing inner transactions is ignored by the SQL Server Database Engine
- If the outer transaction is committed,the inner nested  transactions are also committed.
- If the outer transaction  is rolled back, then all inner transactions are also 
  rolled back
*/
-------------------------vip ex for Transaction ------------------------------
go
create database TranstestDB
go 
use TranstestDB
go 
create table names (ID int identity (1,1), name nvarchar(50),
                    city nvarchar(20),job nvarchar(20));
go 
create table Salary (SalaryID int identity(1,1),nameID int ,
                      Salary decimal (18,2), Bouns decimal (18,2),
					   dis decimal (18,2),net decimal (18,2))
------------------------------------------------
-- procerdue to insert into two Tables 
go
create proc SP_insert_With_Identity
--- table name
@name nvarchar (50),
@City nvarchar (20),
@job nvarchar (20),
---table salary 
@salary decimal (18,2)
as 
declare @nameID int
declare @bouns decimal (18,2) = @salary * 0.10
declare @dis decimal (18,2)   = @salary * 0.05
declare @net decimal (18,2)   = @salary +@bouns - @dis

insert into names values (@name , @city , @job)
set @nameId = (select SCOPE_IDENTITY())
insert into salary values (@nameID,@salary,@bouns,@dis,@net)

go 
exec SP_insert_With_Identity 'yasser','Cairo','Deve',2000

select * from names
select * from salary 
-----------------------------------------------------------
--With Transaction 
-- Do All Or Not All 
--error
------------------------------------------------------------
go
create proc SP_Make_Erro
--- table name
@name nvarchar (50),
@City nvarchar (20),
@job nvarchar (20),
@salary decimal (18,2)
as 
insert into names values (@name , @city , @job)
---table salary 
declare @nameID int
declare @bouns decimal (18,2) = @salary * 'yah'
declare @dis decimal (18,2)   = @salary * 0.05
declare @net decimal (18,2)   = @salary +@bouns - @dis
set @nameId = (select SCOPE_IDENTITY())
insert into salary values (@nameID,@salary,@bouns,@dis,@net)
go 

exec SP_Make_Erro 'yasser','Cairo','Deve',2000
select * from names
select * from salary 
-----------------------------------------------
-- To Soliving this problem 
go
create proc SP_Make_Tranc
--- table name
@name nvarchar (50),
@City nvarchar (20),
@job nvarchar (20),
@salary decimal (18,2)
as 
begin try 
	begin transaction --|tarnsaction
		insert into names values (@name , @city , @job)
		---table salary 
		declare @nameID int
		declare @bouns decimal (18,2) = @salary * 'yah'
		declare @dis decimal (18,2)   = @salary * 0.05
		declare @net decimal (18,2)   = @salary +@bouns - @dis
		set @nameId = (select SCOPE_IDENTITY())
		insert into salary values (@nameID,@salary,@bouns,@dis,@net)
	commit transaction
end try
begin catch 
	rollback transaction 
	print error_message()
end catch 
go 
exec SP_Make_Tranc 'Mohamed','Cairo','Deve',2000
select * from names
select * from salary 
-------------------------------------------------------------------------------------------------

-- Managing Transactions:
-- Types of transactions
-- ---------------------
/*
XACT_ABORT setting ON ensures the entire batch will rollback upon any runtime error; 
compile errors not affected by XACT_ABORT 
SET XACT_ABORT on 

*/

-- Implicit Transaction : (Auto:Begin ,Explicit:Rollback or Committ)
-- ------------------------------------------------------------------
--SET IMPLICIT_TRANSACTIONS {ON | OFF }
/*
-- When ON, SET IMPLICIT_TRANSACTIONS sets the connection into implicit transaction mode. 
-- When OFF, it returns the connection to autocommit transaction mode
-- Server Database Engine automatically starts a new transaction after the 
   current transaction is committed or rolled back. 
-- You do nothing to delineate the start of a transaction; 
   you only commit or rollback each transaction ,OR
   the transaction and all of the data changes it 
   contains are rolled back when the user disconnects
*/

Use Northwind
update Employees
set firstname ='ahmed'
where lastname ='Davolio'

select * from Employees

Rollback tran Tran1


-- Count transaction( Nested Transactions)
select @@TRANCOUNT       --determine Nesting level
/*
- Committing inner transactions is ignored by the SQL Server Database Engine
- If the outer transaction is committed,the inner nested  transactions are also committed.
- If the outer transaction  is rolled back, then all inner transactions are also 
  rolled back
*/
-- Special Option
-- --------------
--XACT_ABORT ==> Determine whether sql automatic  rollback the current transaction  when an error occur  (on --off)
--When SET XACT_ABORT is ON, if a Transact-SQL statement raises a run-time error, the entire transaction is terminated and rolled back
--When SET XACT_ABORT is OFF, in some cases only the Transact-SQL statement that raised the error is rolled back and the transaction continues processing. Depending upon the severity of the error

--Compile errors, such as syntax errors, are not affected by SET XACT_ABORT.

USE AdventureWorks2012 
CREATE TABLE t1 (a INT NOT NULL PRIMARY KEY);
CREATE TABLE t2 (a INT NOT NULL REFERENCES t1(a));
GO
INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (3);
INSERT INTO t1 VALUES (4);
INSERT INTO t1 VALUES (6);
GO
SET XACT_ABORT OFF;
GO

BEGIN TRANSACTION;
INSERT INTO t2 VALUES (1);
INSERT INTO t2 VALUES (2); -- Foreign key error.
INSERT INTO t2 VALUES (3);
COMMIT TRANSACTION;
GO

Select * from t1
select * from t2


SET XACT_ABORT ON;
GO
BEGIN TRANSACTION;
INSERT INTO t2 VALUES (4);
INSERT INTO t2 VALUES (5); -- Foreign key error.
INSERT INTO t2 VALUES (6);
COMMIT TRANSACTION;
GO
-- SELECT shows only keys 1 and 3 added. 
-- Key 2 insert failed and was rolled back, but
-- XACT_ABORT was OFF and rest of transaction
-- succeeded.
-- Key 5 insert error with XACT_ABORT ON caused
-- all of the second transaction to roll back.
SELECT *
    FROM t2;
GO
--===============================================================================================
-------------------------------------------------------------------------------------------------
/*
                 --Thank you Every One    ... :)   Keep Coding    Sayed Hawas
*/
-------------------------------------------------------------------------------------------------
--************************************************************************************************
-- Displaying Query Statistics
/*
In addition to execution plan internals, SQL Server can return details about the execution of T-SQL
statements by the use of the SET STATISTICS group
of commands:

? SET STATISTICS TIME ON|OFF controls the display of metrics about the time taken to
prepare and compile (pre-execution phases), as well as the totals elapsed when the query has
completed.
? SET STATISTICS IO ON|OFF controls the display
of information about the amount of disk (and data cache) activity generated by a query.
Results are displayed in units of 8kb data pages, which store table rows.

*/
-- STATISTICS TIME
SET STATISTICS TIME ON;
GO
SELECT orderid, customerID, employeeID, orderdate FROM Orders;
GO
SET STATISTICS TIME OFF;
GO

-- STATISTICS IO
SET STATISTICS IO ON;
GO
SELECT orderid, customerID, employeeID, orderdate FROM Orders;
GO
SET STATISTICS IO OFF;
GO
--=========================================================================================================================
/*
When writing queries, it is sometimes necessary 
to learn which columns are in a particular table, what their data types are, or what collation is used by a 
string column. You may not have convenient access to a graphical tool such as SQL Server Management 
Studio (SSMS); however, if you can send queries to SQL Server, you can retrieve the same information that 
SSMS displays. After all, SSMS is simply issuing metadata queries on your behalf in order to display its view 
of a server or a database. 

SQL Server provides access to structured metadata through a variety of mechanisms, such as :
1- system catalog views, 
2- system functions, 
3- dynamic management objects, 
4- system stored procedures.

*/

-- System Catalog Views (code & wizard)
-- ------------------------------------

--Pre-filtered to exclude system objects
use Northwind    -- try to change DB
SELECT  name, object_id, schema_id, type, type_desc
FROM sys.tables

USE northwind;
GO
SELECT name, object_id, principal_id, schema_id,parent_object_id, type, type_desc
FROM sys.tables;


--Includes system and user objects
SELECT name, object_id, schema_id, type, type_desc
FROM sys.objects

/*
-- some examples of system views:
[sys].[all_columns]
[sys].[all_sql_modules]
[sys].[all_views]
[sys].[check_constraints]
[sys].[column_type_usages]
[sys].[columns]
[sys].[computed_columns]
[sys].[data_spaces]
[sys].[database_files]
[sys].[databases]
[sys].[foreign_keys]
[sys].[synonyms]
[sys].[types]

Select name,column_id,is_identity,increment_value,last_value
From sys.identity_columns

*/


SELECT SCHEMA_NAME(schema_id) AS SchemaName,name AS TableName
FROM sys.tables
ORDER BY SchemaName, TableName;
GO


-- Information Schema Views
-- ------------------------
/*
-They are stored in their own schema, INFORMATION_SCHEMA. 
 SQL Server system views appear in the sys schema. 
-They typically use standard terminology instead of SQL Server terms. 
 For example, they use “catalog” instead of “database” and “domain” instead of “user-defined data type.” So,
 you need to adjust your queries accordingly. 
-They may not expose all the metadata available to SQL Server's own catalog views. 
 For example, sys.columns includes attributes for the identity property and computed column property, while 
 INFORMATION_SCHEMA.columns does not. 
  
-Return system metadata per ISO standard, used by third-party tools
-information schema views may be queried to return system metadata. 
 Provided to conform with standards, information schema views are useful to third-party tools that may not be 
written specifically for use with SQL Server.
*/

SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE 
FROM INFORMATION_SCHEMA.TABLES



-- System Metadata Functions
-- -------------------------
/*
-Return information about settings, values, and objects in SQL Server
-Come in a variety of formats:
--Some marked with a @@ prefix, sometimes incorrectly referred to as global variables: @@VERSION
--Some marked with a () suffix, similar to arithmetic or string functions: ERROR_NUMBER()
--Some special functions marked with a $ prefix: $PARTITION

-Marked with an sp_ prefix
-Stored in a hidden resource database 
Best practices for execution include: 
  -Always use EXEC or EXECUTE rather than just calling by name
  -Include the sys schema name when executing
  -Name each parameter and specify its appropriate data type

*/

SELECT @@VERSION AS SQL_Version
SELECT SERVERPROPERTY('ProductVersion') AS version
SELECT SERVERPROPERTY('Collation') AS collation

select user_name(2)
select SUSER_SNAME()
select COL_LENGTH('employees','lastname') as length


select getdate()
select DB_name ( ) 'db'
select db_id('master')
select suser_sname() as 'UserName'

SELECT SERVERPROPERTY('ResourceVersion')
select HOST_NAME()    --gives server name


select * from ::fn_helpcollations()

SELECT  SERVERPROPERTY('productversion'), 
SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition')


                                         


-- Executing Stored Procedures
-- ---------------------------
/*
-Use the EXECUTE or EXEC command before the name of the stored procedure
-Pass parameters by name or position, separated by commas when applicable
*/

--no parameters
EXEC sys.sp_databases;

--single parameter
EXEC sys.sp_help 'Sales.Customers'

--multiple named parameters
EXEC sys.sp_tables 
	@table_name = '%', 	  -- c%
	@table_owner = 'Sales'


EXEC sys.sp_databases

-- sp_help objectName
Exec sp_help employees
     sp_help Invoices

exec sp_columns MyTable
exec sp_columns employees, @column_name = 'employeeid'
exec sp_columns MyTable, @column_name = 'a%'

-- sp_helpdb dbName
sp_helpdb Northwind
sp_dbcmptlevel



-- DMV (Dynamic Managment Views)  
-- ------------------------------

/*
-Dynamic management views and functions (DMVs) return server state information
-Nearly 200 DMVs in SQL Server 2012
-DMVs include catalog information as well as administrative status information, such as object dependencies
-DMVs are server-scoped (instance-level) or database-scoped
-Schema name required to invoke
-Requires VIEW SERVER STATE or VIEW DATABASE STATE permission to query DMVs
-Underlying structures change over time, so avoid writing SELECT * queries against DMVs
 
*/

Select * From sys.sysdatabases

SELECT SCHEMA_NAME(schema_id) AS SchemaName,name AS TableName
FROM sys.tables
ORDER BY SchemaName, TableName;
GO

SELECT name, type_desc FROM sys.tables

SELECT name,id,xtype,crdate FROM sys.sysobjects
--where xtype= 'u'     -- u:user table

SELECT session_id, login_time,
program_name
FROM sys.dm_exec_sessions
WHERE is_user_process =1;
--===================================================================================================================