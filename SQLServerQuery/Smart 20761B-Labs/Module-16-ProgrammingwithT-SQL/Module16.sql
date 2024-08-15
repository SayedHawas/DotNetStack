--========================
--Module 16
--Programming with T-SQL
--======================== 
/*
T-SQL Programming Elements
Controlling Program Flow

Lesson 1: T-SQL Programming Elements :-
---------------------------------------
				Introducing T-SQL Batches
				Working with Batches
				Introducing T-SQL Variables
				Working with Variables
				Working with Synonyms

--Introducing T-SQL Batches
---------------------------
 1) T-SQL batches are collections of one or more T-SQL statements 
     sent to SQL Server as a unit for parsing, optimization, and execution
 2) Batches are terminated with GO by default
 3) Batches are boundaries for variable scope
 4) Some statements (for example, CREATE FUNCTION, CREATE PROCEDURE, CREATE VIEW) 
	may not be combined with others in the same batch


CREATE VIEW <view_name>
AS ...;
GO
CREATE PROCEDURE <procedure_name>
AS ...;
GO

-----------------------
--Working with Batches

     *) Batches are parsed for syntax as a unit
     *) Syntax errors cause the entire batch to be rejected
     *) Runtime errors may allow the batch to continue after failure, by default
Batches can contain error-handling code
*/
-- in SQL server 2012 Code Error

use Northwind
go
Create table t1(Id int , code int , name nvarchar(50))
go
insert into t1 VALUES(1,2,N'abc');

--InValid batch
INSERT INTO dbo.t1 VALUES(1,2,N'abc');
INSERT INTO dbo.t1 VALUES(2,3,N'def');
INSERT INTO dbo.t1 VALUE(1,2,N'abc');
INSERT INTO dbo.t1 VALUES(2,3,N'def');
GO


--Valid batch
INSERT INTO dbo.t1 VALUES(1,2,N'abc');
INSERT INTO dbo.t1 VALUES(2,3,N'def');
GO
--invalid batch
INSERT INTO dbo.t1 VALUE(1,2,N'abc');
INSERT INTO dbo.t1 VALUES(2,3,N'def');
GO
--Batches can contain error-handling code
--------------------------------------------------------------------------------------
--Introducing T-SQL Variables
------------------------------
/*
       - Variables are objects that allow storage of a value for use later in the same batch
       - Variables are defined with the DECLARE keyword
	        - In SQL Server 2008 and later, variables can be declared and initialized in the same statement
       - Variables are always local to the batch in which they're declared and go out of scope when the batch ends
*/
go
Create proc Sp_getAllProduct  @ID int
as 
begin 
   select * from Products where categoryID = @ID; 
end 
go
--Declare and initialize variables
DECLARE @catid INT = 2;
--Use variables to pass parameters to procedure
EXEC Sp_getAllProduct @catid
GO

------------------------------------------------------------
-- Working with Variables
--------------------------

--Initialize a variable using the DECLARE statement
DECLARE @i INT = 0;
--Assign a single (scalar) value using the SET statement
SET @i = 1;
--Assign a value to a variable using a SELECT statement
--Be sure that the SELECT statement returns exactly one row
SELECT @i = COUNT(*) FROM Orders;
select @i
----------------------------------------------------------------
-- Working with Synonyms
-------------------------
/*
 - A synonym is an alias or link to an object stored either on the same SQL Server instance or on a linked server
           *) Synonyms can point to tables, views, procedures, and functions
 - Synonyms can be used for referencing remote objects as though they were located locally,
    or for providing alternative names to other local objects
 - Use the CREATE and DROP commands to manage synonyms
*/

USE Northwind 
Go
Create Function Fn_ShowAllEmployeeInTheOrders()
returns table 
as 
return select EmployeeID from orders
GO

select * from Fn_ShowAllEmployeeInTheOrders()

GO
CREATE SYNONYM MyFun FOR 	Northwind.dbo.Fn_ShowAllEmployeeInTheOrders;
GO
select * from MyFun();

 --=======================================================================================================
 --Lesson 2: Controlling Program Flow
 --=================================

								--Understanding T-SQL Control-of-Flow Language
								--Working with IF…ELSE
								--Working with WHILE
/*
--Understanding T-SQL Control-of-Flow Language
-----------------------------------------------
   SQL Server provides additional language elements that control the flow of execution of T-SQL statements
        - Used in batches, stored procedures, and multistatement functions

   Control-of-flow elements allow statements to be performed in a specified order or not at all
       - The default is for statements to execute sequentially

   Includes IF…ELSE, BEGIN…END, WHILE, RETURN, and others
*/
--=====
-- IF
--===== 
--True
--------
if 1=1
begin 
    print 'welcome in SQL'
end 
--False 
--------
if 1=2
begin 
    print 'Hello in SQL'
end 
else
begin 
    print 'Finish  SQL Course'
end 
--------------------------------------------
 if 1=1
 begin 
    select * from Employees
 end
 --------------------------------
 Declare @x int = 2;
 if @x = 1
 begin 
   select * from Employees
 end 
 ----------------------------------------------------------------
 declare @ID int ;
 select @ID=orderID from Orders where orderID = 10248
 
 if 1=1 
 begin 
 select * from [Order Details] 
 where OrderID = @ID
 end
 -----------------------------------------------------------------
IF OBJECT_ID('dbo.t1') IS NOT NULL
	select * from t1;
GO
-------------------------------------------------------------------
/*
IF…ELSE uses a predicate to determine the flow of the code
The code in the IF block is executed if the predicate evaluates to TRUE 
The code in the ELSE block is executed if the predicate evaluates to FALSE or UNKNOWN
Very useful when combined with the EXISTS operator
*/
--IF ... Else
if 1=2
begin 
    print 'Hello in SQL'
end 
else
begin 
    print 'Finish  SQL Course'
end
 
----------------------------------
 IF OBJECT_ID('dbo.t1') IS NULL
	PRINT 'Object does not exist';
ELSE
	select * from t1;
GO

--Meta Data Query 
select * from sys.dm_os_sys_info 
-- IF..Else Example :-
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES  WHERE TABLE_NAME = 'Employees')
   BEGIN 
         PRINT 'There is a Table'
		 select * from employees
   END 
ELSE
   BEGIN  
         PRINT 'Not Found' 
   END
GO
----------------------------------------------------------
--Working with WHILE
----------------------
-- WHILE enables code to execute in a loop
-- Statements in the WHILE block repeat as the predicate evaluates to TRUE
-- The loop ends when the predicate evaluates to FALSE or UNKNOWN
-- Execution can be altered by BREAK or CONTINUE
 -----------------------------
 --Loop While 
 Declare @x int = 1
 While (@X<=10)
 begin 
    Print concat('Welcome in SQL ',@x )
	set @x= @x+1 
 end 
 ----------------------------------------
 --break
 -------
 Declare @Number int = 1
 While (@Number<=10)
 begin 
    Print concat('Welcome in SQL ',@Number )
	set @Number= @Number+1 

	if(@number >5)
	  begin
	    break;
	  end
 end 
 -----------------------------------------------------
 --CONTINUE
 ------------
 Declare @Number int = 1
 While (@Number<=10)
 begin 
    Print concat('Welcome in SQL ',@Number )
	set @Number= @Number+1 

	if(@number <5)
	  begin
	    CONTINUE;
	  end
 end
 
 --------------------------------------------------------
 -- WHILE Example :-
DECLARE @empid AS INT = 1,
        @lname AS NVARCHAR(20)
WHILE  @empid <=5    
       BEGIN  
	        SELECT @lname = lastname 
			FROM Employees   
			WHERE EmployeeID = @empid  
			PRINT @lname  
			SET @empid += 1    
		END
GO 
/*
--===================================================================================================
