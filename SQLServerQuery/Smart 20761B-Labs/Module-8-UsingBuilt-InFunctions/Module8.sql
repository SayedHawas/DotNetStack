/*
-- Module 8) Using Built-In Functions :- 
 -----------------------------------------
   -- Lessons :-
   -------------
          - Writing Queries with Built-In Functions.
		  - Using Conversion Functions.
		  - Using Logical Functions.
		  - Using Functions to Work with NULL.
-----------------------------------------------
-- What is Functions in T-SQL ?
--------------------------------
 - A T-SQL routine that accepts parameters, performs an action, such as a complex calculation,
     and returns the result of that action as a value.
 - Functions hide the steps and the complexity from other code.
 - Function Operate  
                      A)- (Deterministic = return same result)
                      B)- (Non-Deterministic = may return different result each time) 
					  
-- Why We use Functions ? 
--------------------------
   - Functions can Use & Run almost anywhere .
   - To replace a stored procedure . 
   
   -- Functions Types :-
-------------------------
 1)- User-defined Functions :-       "Developing Course"

                             A) Scalar        :- Return a single value.
							 B) Table-Valued  :- Return a table.

 
 2)- Built-in Function :-   
                             A) Scalar    :- Working on a single row To return a single Value.             " Module Focus "
							 B) Aggregate :- Take one or more input To return a single summarizing value.  " Next Module "
							 C) Window    :- Working on sets of rows.                                      " In This Course"
							 D) Rowset    :- Return a virtual table can be used in a T-SQL statement.      "Admin Course"
*/
----------------------------------------------------------------------------------------------------------------------------------
-- Simple Examples For The Types of Built-in Functions That we will use :-
-- 1) Scalar Simple Example 
SELECT orderid,orderdate,YEAR(orderdate) AS orderyear   -- Scalar
FROM   Orders

-- 2) Aggregate Simple Example 
SELECT COUNT(Quantity) AS RowsCount, AVG(Quantity) AS QuantityAverage
FROM  [Order Details]

-- 3) Window Simple Example 
SELECT TOP(10) productid, productname,unitprice,
	   RANK() OVER(ORDER BY unitprice DESC) AS 'Rank By Price' 
FROM   Products 
ORDER BY 'Rank By Price' 
-------------------------------------------------------------------------------------------------------------------------------------
/*
-- Using Conversion Functions :-
--------------------------------
  - Implicit conversion occurs automatically :- Follows data type precedence rules.
  - Use explicit conversion :-
                                A) When implicit would fail or is not permitted.
                                B) To override data type precedence.
 - Conversion Functions :- 
                           A) CAST    :-  To convert a value from one data type to another . " ANSI-Standard "
						   B) CONVERT :-  To convert a value from one data type to another . " SQL SERVER ONLY "
						   C) PARSE  :-  Converts strings to date, time, number types.     " SQL SERVER ONLY "  
						   D) TRY_PARS & TRY_CONVERT :-  like PARSE and CONVERT, But when failed conversions return NULL. 
*/

-- 1) CAST Syntax 
----------------
-- CAST(<Expression> AS DataType)
---------------------------------
-- CAST Example 1)   -- from DateTime to date
SELECT orderid,orderdate AS OrderDateTime,
	   CAST(orderdate AS DATE) AS OrderDateOnly  
FROM   Orders 

-- CAST Example 2)    -- from Int to String
SELECT CAST(1 AS Varchar(1))    AS RESULT 

-- CAST Example 2)    -- from String to Decimal
SELECT CAST('20.33' AS decimal(4,2))    AS RESULT 

---------------------------------------------------
-- 2) Convert Syntax 
------------------
-- 1) Normal             CONVERT(DataType , <Expression> ), "Optional Format")
-- 2) With Format        CONVERT(DataType , <Expression> , "Optional Format Number")
--------------------------------------------------------
-- CONVERT Example 1)   -- from DateTime to date
SELECT orderid,orderdate AS OrderDateTime,CONVERT(DATE , orderdate , 110) AS OrderDateOnly  
FROM Orders 

-- CONVERT Example 2)    -- from Int to String
SELECT CONVERT(Varchar(1) , 1)  AS RESULT 

-- CONVERT Example 2)    -- from String to Decimal
SELECT CONVERT(Decimal(4,2) , '20.33' )   AS RESULT 
------------------------------------------------------------
-- 3) Parse Syntax 
-----------------
-- 1) Normal          PARS (<String> AS DataType)
-- 2) With Culture    PARS (<String> AS DataType USING 'Culture Name') 
-----------------------------------------------------
-- Parse Example Normal
SELECT PARSE('02/12/2012' AS datetime2) AS Result

-- Parse Example Using Culture
SELECT PARSE('02/12/2012' AS datetime2 USING 'ar-EG') AS Result
-------------------------------------------------------------------------
/*
-- Why Try_Parse & Try_Convert ? 
---------------------------------
   - Some Conversion Never works 
   - If the data types are incompatible, 
   - such as attempting to convert a date to a numeric value,
   - (CAST,CONVERT,Parse)  will return an error.
   - So Try_Parse & Try_Convert Will Act Like (CONVERT,Parse) ,
   - AND When Conversion Failed Return NULL instead of Error.
   - Try_Parse Syntax = Parse Syntax
   - Try_Convert Syntax = Convert Syntax
*/
-- Conversion Failed with error like :-
-- CAST Error
SELECT CAST ( '12/12/2012' AS INT )

-- CONVERT Error
SELECT CONVERT ( INT , '12/12/2012' )
-- Parse Error
SELECT Parse ( '12/12/2012' AS INT )
-- USING Try_Parse    -- No Error
SELECT Try_Parse ( '12/12/2012' AS INT ) AS Result
-- USING Try_Convert  -- No Error
SELECT Try_Convert ( INT , '12/12/2012' ) AS Result
-----------------------------------------------------------------------------------------
/* 
  -- Logical Functions :- 
  -------------------------
    - Logical functions that evaluate an expression and return a scalar result.
	- Logical functions :- 
	                      A) ISNUMERIC() :- 
						               - Tests whether an input expression is a valid numeric data type.
						               - Returns a 1 when the input evaluates to any valid numeric type.
									   - Returns 0 otherwise
  
						  B) IIF()  :- 
						               - IIF returns one of two values, depending on a logical test.
									   - Like two-outcome CASE expression.
									   - You may nest a IIF function within another IIF, a maximum level 10.
									   - IIF give error if values NULL.

						  C) CHOOSE() :-
						               - returns an item from a list as specified by an index value.
									   - if the index value not a value in the list, will return a NULL.
*/

-- ISNUMERIC Syntax :-
-- ISNUMERIC ( <Expression> )
------------------------------
-- ISNUMERIC() Example 1)
SELECT ISNUMERIC('SQL') AS Result  -- 'SQL' Not numeric so result = 0
-- ISNUMERIC() Example 2)
SELECT ISNUMERIC('12') AS Result  -- '12' INT so result = 1
-- ISNUMERIC() Example 3)
SELECT ISNUMERIC('100.50') AS Result  -- '100.50' Decimal so result = 1

-- Logical Tests functions 
SELECT ISNUMERIC('SQL') AS isnmumeric_result;
select Isdate(getdate())  --return 1 because its a date
select Isdate('kkk')   -- return 0   because its not a date
select isnumeric ('dfd')  --returns 0 casue its not numeric value
select isnumeric (5)  --returns 1 casue its numeric value

-------------------------------------------------------------------------
-- IIF() Syntax
-- IIF (<Boolean_Expression> , 'Value if true' , 'value if false or unknown')
----------------------------------------------------------------------------
--IIF() Example 1)  -- Like Case Statement
SELECT productid,unitprice, IIF(unitprice > 50,'high','low') AS pricepoint
FROM   Products

--IIF() Example 2) 
SELECT IIF(1 > 10, 'TRUE', 'FALSE' ) AS Result

--IIF() Example 3)  -- Error because NULL Values
SELECT IIF ( 45 > 30, NULL, NULL ) AS Result

-- IIF() Example 4)  -- Nested IIF
SELECT IIF ( 45 = 30, 'True', IIF(1>2,'Yes','No') ) AS Result
------------------------------------------------------------------------
-- CHOOSE() Syntax
-- CHOOSE (<Index_number>,Value_list)
--------------------------------------
-- CHOOSE() Example 1)  -- Simple Example
SELECT CHOOSE(1,'Spring','Summer','Autumn','Winter') AS Result
-- CHOOSE() Example 2)  -- Null because index number not in values list
SELECT CHOOSE(5,'Spring','Summer','Autumn','Winter') AS Result
-- CHOOSE() Example 3)  -- error if index Char.
SELECT CHOOSE('One','Spring','Summer','Autumn','Winter') AS Result
-- CHOOSE() Example 4)  --  string implicitly converted to INT
SELECT CHOOSE('2','Spring','Summer','Autumn','Winter') AS Result 
-- CHOOSE() Example 5)  -- If index value is numeric, it will be implicitly converted to INT.
SELECT CHOOSE(3.1,'Spring','Summer','Autumn','Winter') AS Result
------------------------------------------------------------------------------------------------------
/*
  --  Functions to Work with NULL :-
  ------------------------------------
      A)- ISNULL()   :-
	               - ISNULL replaces NULL with a specified value.
				   - ISNULL Not ANSI standard.


	  B)- COALESCE() :-
	               - COALESCE is ANSI standard.
				   - returns the first non-NULL value in a list.
				   - If all arguments are NULL, COALESCE returns NULL.

	  C)- NULLIF()  :-
	              - NULLIF is ANSI standard.
	              - NULLIF compares two expressions.
				  - Returns NULL if both are equal.
				  - Returns the first expressions if both not equal.
*/

-- ISNULL() Syntax
-- ISNULL(<expression_to_check> , 'replacement_value')
---------------------------------------------------
-- ISNULL() Example 1)
SELECT EmployeeID,city,Region,ISNULL(region, 'N/A') AS New_Region,country 
FROM Employees 
GO
-- ISNULL() Example 2)  -- ISNULL inside another function
SELECT AVG(ISNULL(quantity, 50)) AS Average
FROM [Order Details]
GO
--------------------------------------------------
-- COALESCE() Syntax
-- COALESCE(<expression_to_check> , 'replacement_value')
-------------------------------------------------------
-- COALESCE() Example 1)  -- Working Like ISNULL()
SELECT country,region,city, country + ',' + COALESCE(region, ' ') + ', ' + city as location
FROM   Employees

-- COALESCE() Example 2)   -- Get First not null value
CREATE TABLE COAL( ID INT, FirstName varchar(20),MiddleName varchar(20), LastName Varchar(20))
 
INSERT INTO COAL VALUES (1,'Ahmed',NULL,'Ali'),
                        (1,NULL,'Mohamed',NULL),
		                (1,NULL,NULL,'Walid')
GO
SELECT * FROM COAL
GO
SELECT ID,COALESCE(FirstName,MiddleName,LastName) AS Name
FROM COAL
GO
-------------------------------------------------------------------------
-- NULLIF() Syntax
-- NULLIF ( <expression1> , <expression2> )
-------------------------------------------
-- NULLIF() Example 1)
SELECT NULLIF(1,1) AS RESULT

-- NULLIF() Example 2)
SELECT NULLIF(1,2) AS RESULT

-- NULLIF() Example 3)
SELECT NULLIF(2,1) AS RESULT

---------------------------------------------------
--Date Format (Lab HOL)
--------------
create database Module8
go
use Module8
go
Create table Employees(ID int primary key identity, Name nvarchar(50),DOB Date ,attendTime Time);
insert into Employees values('Ahmed',getdate(),getdate());
select * from Employees
select * ,FORMAT(DOB,'dd/MM/yyyy') as [Date] ,Format(attendTime,'hh:mm:ss') as [Time] from Employees -- 
select * ,FORMAT(DOB,'dd/MM/yyyy') as [Date] ,left(attendTime,5) as [Time] from Employees
select format (getdate(),'hh:mm:ss');
select 'this is My DOB '+ convert(varchar(25),format(getdate(),'dddd-MMMM-dd-yyyy')) ;
-----------------------------------------------------------------------------------------------
--format(value,format,culture)
DECLARE @date DATETIME = GETDATE()
SELECT @date AS 'GETDATE()',
       FORMAT( @date, 'd', 'en-US') AS 'DATE IN US Culture',
       FORMAT( @date, 'd', 'en-IN') AS 'DATE IN INDIAN Culture',
       FORMAT( @date, 'd', 'de-DE') AS 'DATE IN GERMAN Culture'

DECLARE @Price INT = 40
SELECT FORMAT(@Price,'c','en-US') AS 'CURRENCY IN US Culture', 
       FORMAT(@Price,'c','de-DE') AS 'CURRENCY IN GERMAN Culture'
        

DECLARE @Price DECIMAL(5,3) = 40.356
SELECT FORMAT( @Price, 'C') AS 'Default',
       FORMAT( @Price, 'C0') AS 'With 0 Decimal',
       FORMAT( @Price, 'C1') AS 'With 1 Decimal',
       FORMAT( @Price, 'C2') AS 'With 2 Decimal',
       FORMAT( @Price, 'C3') AS 'With 3 Decimal'

DECLARE @Percentage float = 0.35674
SELECT FORMAT( @Percentage, 'P') AS '% Default',
       FORMAT( @Percentage, 'P0') AS '% With 0 Decimal',
       FORMAT( @Percentage, 'P1') AS '% with 1 Decimal',
       FORMAT( @Percentage, 'P2') AS '% with 2 Decimal',
       FORMAT( @Percentage, 'P3') AS '% with 3 Decimal'

----------------------------------------------------------------------------------
--String Function
-- Use string functions in a query
SELECT SUBSTRING('Microsoft SQL Server',11,3) AS Result;
SELECT LEFT('Microsoft SQL Server',9)  AS Result;
SELECT RIGHT('Microsoft SQL Server',6);
SELECT LEN('Microsoft SQL Server     ') AS [LEN];
SELECT DATALENGTH('Microsoft SQL Server     ');
SELECT CHARINDEX('SQL','Microsoft SQL Server');
SELECT REPLACE('Microsoft SQL Server 2008','2008','2012');
SELECT UPPER('Microsoft SQL Server');
SELECT LOWER('Microsoft SQL Server');
select firstname , reverse(firstname) as rever from Employees

--Demo On Nested function 
declare @x varchar(200) = '   mIcroSoft sQL SerVER 2016    '
select Concat(Upper( substring(ltrim(@x),1,1)) ,lower(substring (ltrim(@x),2,len(@x))))
--------------------------------------------------------------------------------------------
--Date & Time Functions
select GETDATE()
select GETUTCDATE()
select CURRENT_TIMESTAMP
select SYSDATETIME()
select SYSUTCDATETIME()
select SYSDATETIMEOFFSET()
select DATEPART(day,'1/29/2014')
select DATEPART(MONTH,'1/29/2014')
select DATEPART(YEAR,'1/29/2014')
select DATEFROMPARTS ( 2014, 1, 29 )
select TIMEFROMPARTS(13,26,44,0,0) -- 5 argu


DECLARE @date DATETIME = '12/1/2011';
SELECT EOMONTH ( @date ) AS Result;
GO
DECLARE @date DATETIME = GETDATE();
SELECT EOMONTH ( @date ) AS 'This Month';
SELECT EOMONTH ( @date, 1 ) AS 'Next Month';
SELECT EOMONTH ( @date, -1 ) AS 'Last Month';
GO
SELECT DAY('20120212') AS [Day], MONTH('20120212') AS [Month],YEAR('20120212') AS [Year];


-- Use ISDATE to check validity of inputs:
SELECT ISDATE('20120212'); --is valid
SELECT ISDATE('20120230'); --February doesn't have 30 day
------------------------------ new 
select datepart (q,'1/1/2015') --quarter in Year 
select DATEPART(q,getdate());
select datepart(DW,'8/1/2015') --Day in Week
select Datepart(dw,getdate());
Select datepart(DY,'8/1/2015') --Day in year 
select datepart(dy,getdate()); 
select datepart(WW,getdate());  --Week in Year
-----------------------------------------
-- Using Built-In Functions
-- Scalar Functions
---------------------------------
SELECT ABS(-1.0), ABS(0.0), ABS(1.0);
--Metadata Function
SELECT DB_NAME() AS current_database;
--global variable
select @@VERSION as Edition 

 