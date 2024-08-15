--===================================================================================
--Module 5 
--Sorting and Filtering Data
------------------------------
/*
 -- Operators & Predicates :- 
 -----------------------------
1) Comparison :  
----------------  
=  (equals)
>  (Greater Than)
<  (Less Than)
>= (Greater Than or Equal To)
<= (Less Than or Equal To)
<> (Not Equal)
!= (Not Equal To)       -- Not ANSI
!< (Not Less Than)      -- Not ANSI
!> (Not Greater Than)   -- Not ANSI		
------------------------------------------------------------------------------------
2) Arithmetic :
----------------
+  Addition
-  Subtraction
*  Multiplication
/  Division
%  Modulo
-------------------------------------------------------------------------------------
3) Concatenation :
------------------
+  Combines two strings or more into one string 
------------------------------------------------------------------------------------
4) String Comparison :
-----------------------
=    operator :-  tests to see if both strings are exact matches.
LIKE operator :-  uses wildcards to search for near matches.

LIKE WildCards :- 
------------------ 
%           A substitute for zero or more characters.
_           A substitute for a single character.
[charlist]	Sets and ranges of characters to match.
[^charlist] Matches only a character NOT specified within the brackets.

WildCards Examples :-
----------------------
-- 'sm%'    = word beginning with the letters sm .
-- '%sm'    = word ending with the letters sm .
-- 'sm_'    = word beginning with the letters sm and one more letter .
-- '%sm%'   = word containing the letters sm .
-- '[gs]%'  = word beginning with the letters g  or  s .
-- '[g-s]%' = word beginning with the letters in the range between g to s .
-- 's[^m]%' = word beginning with the letter s but the second letter is not m .

Using Wildcard Characters As Literals
---------------------------------------
-You can use the wildcard pattern matching characters as literal characters. 
-To use a wildcard character as a literal character, enclose the wildcard character in brackets. 
-The following table shows several examples of using the LIKE keyword and the [ ] wildcard characters.

Wildcard Characters As Literals Examples
----------------------------------------
--LIKE '5[%]'   --->  5%
--LIKE '[_]n'   --->  _n
--LIKE '[a-cdf]' ---> a, b, c, d, or f
--LIKE '[-acdf]' ---> -, a, c, d, or f
--LIKE '[ [ ]'   ---> [
--LIKE ']'       ---> ]
--LIKE 'abc[_]d%' ---> abc_d and abc_de
--LIKE 'abc[def]' ---> abcd, abce, and abcf
-------------------------------------------------------------------------------------------------------------------------
5) Logical Operator :-
----------------------
- used to combine condition arguments or to reverse the TRUE/FALSE result of an argument.
AND  ) combines arguments so that results are only returned if both arguments are TRUE.
OR   ) returns TRUE if either of the conditions met.
NOT  ) negates or reverses the result of the expression.
ALL, ANY, EXISTS, and SOME ) are other logical operators that are not as common.

- When combining logical operators be aware of the order that they are processed.
All NOT  expressions are processed first,
AND      is processed next  
OR       being the last operator evaluated. 

Note :-
-------
- In a very large table why would do you think the NOT operator might be the least efficient one to use?
- The NOT operator must first determine if the comparison is TRUE or FALSE and then perform 
  additional processing to change the result to the opposite one. On queries with large row sets 
  this can extra processing can affect performance.
- The logical operators are only evaluated after all arithmetic operators have been evaluated.
Retrieving a Range of values
----------------------------
- BETWEEN is used to test a range of expressions in the same way that >= AND <= does. 
- It takes a low and a high value and tests to see if the expression falls within the range.
- Note : Using BETWEEN assumes that the low and high values are included in the range.
--------------------------------------------------------------------------------------------------------------------
*/
use Northwind;
go
select EmployeeID as ID , FirstName as [First Name], Employees.LastName as [Last Name],HireDate
from Employees
where EmployeeID=3
--------------------------------------------------------------
select EmployeeID as ID , FirstName as [First Name], Employees.LastName as [Last Name],HireDate
from Employees
where HireDate>'5/3/1993'
--------------------------------------------------------------
select EmployeeID as ID , FirstName as [First Name], Employees.LastName as [Last Name],HireDate
from Employees
where HireDate<'5/3/1993'
--------------------------------------------------------------
select EmployeeID as ID , FirstName as [First Name], Employees.LastName as [Last Name],HireDate
from Employees
where HireDate='5/3/1993'
--------------------------------------------------------------
select EmployeeID as ID , FirstName as [First Name], Employees.LastName as [Last Name],HireDate
from Employees
where HireDate!='5/3/1993'
--------------------------------------------------------------
select OrderID as [Order ID],ProductID as [Product ID],(UnitPrice*Quantity)as [Total Price]
from [order details]
where (UnitPrice*Quantity)>500
--------------------------------------------------------------
select firstname as [First Name],lastname as [LastName],title
from Employees
where Title='Sales Representative'
--------------------------------------------------------------
select firstname as [First Name],lastname as [LastName],title,Country
from Employees
where Country='USA'
----------------------------------------------------------------
select customerid as[Customer Id],companyname,contacttitle,phone
from customers
where CustomerID='PICCO'
----------------------------------------------------------------
select customerid as[Customer Id],companyname,contacttitle,phone
from customers
where CustomerID like  'P%'
---------------------------------------------------------------
select customerid as[Customer Id],companyname,contacttitle,phone
from customers
where CustomerID like  '%s'
--------------------------------------------------------------
select customerid as[Customer Id],companyname,contacttitle,phone
from customers
where CustomerID like  'P_ri_'
----------------------------------------------------------------
select customerid as[Customer Id],companyname,contacttitle,phone
from customers
where CustomerID like  '__r%'
----------------------------------------------------------------
select *
from Employees
where FirstName like 's%n'
----------------------------------------------------------------
select *
from Employees
where FirstName like '_____'
----------------------------------------------------------------
select *
from Employees
where FirstName like '______%'
----------------------------------------------------------------
select firstname as [First Name],lastname as [LastName],title
from Employees
where FirstName='nancy' or LastName='king'
---------------------------------------------------------------
select firstname as [First Name],lastname as [LastName],title
from Employees
where FirstName='andrew' and LastName='king'
-----------------------------------------------------------------
select firstname as [First Name],lastname as [LastName],title
from Employees
where   LastName='king' and Not FirstName='andrew'
-----------------------------------------------------------------
select *
from Employees
where Title='Sales Representative' and HireDate>'5/3/1993'
----------------------------------------------------------------
select firstname as [First Name],lastname as [LastName],title,HireDate
from Employees
where HireDate between '5/3/1993' and '12/31/1993'
----------------------------------------------------------------
select firstname as [First Name],lastname as [LastName],title,HireDate
from Employees
where HireDate Not between '5/3/1993' and '12/31/1993'
-----------------------------------------------------------------
select categoryid as [Category ID],categoryname as[Category Name]
from Categories
where CategoryID in (3,4,5,6)
-----------------------------------------------------------------
select categoryid as [Category ID],categoryname as[Category Name]
from Categories
where CategoryID not in (3,4,5,6)
-------------------------------------------------------------------
select customerid,companyname,contactname,region
from customers
where Region is null 
------------------------------------------------------------------
select customerid,companyname,contactname,region
from customers
where Region is not null 
------------------------------------------------------------------
select customerid,companyname,contactname,ISNULL(region,'') as region
from customers
-------------------------------------------------------------------
select * from employees where firstname like 'a[d,n]%'    --and 
select * from employees where firstname like 'an[d-n]%'   -- to 
select * from employees where firstname like 'an[^d]%'
select * from employees where firstname like 'a[^d-n]%'
Select * from Employees where LastName like 'd%o'             
select CompanyName from customers where CompanyName not like 'A_[f,a,t]%'
--==================================================================================
--Advanced 
-- CompanyName have no spaces
SELECT * FROM   Customers
where  CompanyName NOT like '% %'
GO
-- CompanyName have ( ' )
SELECT * FROM   Customers
WHERE CompanyName Like '%['']%'

-- Where Collate
SELECT * FROM   Customers
WHERE CompanyName COLLATE Latin1_General_CS_AI Like '%A%'


-- Where not Collate
SELECT * FROM   Customers
WHERE CompanyName COLLATE Latin1_General_CS_AI Like '%A%'

-- Like With INT 
SELECT * FROM   [Order Details]
WHERE OrderID LIKE '105%'

--==================================================================================
-- Sorting 
--======================
------------------------------------------
--Sorting Data   -- Order By    Asc | Desc 
------------------------------------------
-- with order By 
select * from employees order By HireDate
select * from employees where Region is null order by FirstName 
select * from employees where Region is not null  order by LastName

select firstname as [First Name],lastname as [LastName],title,HireDate
from Employees
order by LastName
--------------------------------------------------------------------
select firstname as [First Name],lastname as [LastName],title,HireDate
from Employees
order by LastName,[First Name]
--------------------------------------------------------------------
select employeeid, firstname as [First Name],lastname as [LastName],title,HireDate
from Employees
order by EmployeeID 
---------------------------------------------------------------------
select FirstName,LastName
from Employees
order by 1
----------------------------------------------------------------
select employeeid, firstname as [First Name],lastname as [LastName],title,HireDate
from Employees
order by EmployeeID desc

--------------------------------------------------------------------------------------
--Filtering in the ORDER BY Clause Using Top(N)
-- --------------------------------------------
/*
PERCENT 
Indicates that the query returns only the first expression percent of rows from the result set.
 Fractional values are rounded up to the next integer value. 

WITH TIES 
Specifies that the query result set includes any additional rows that match the values in 
the ORDER BY column or columns in the last row returned. This may cause more rows to be returned than 
the value specified in expression. For example, if expression is set to 5 but 2 additional rows match the 
values of the ORDER BY columns in row 5, the result set will contain 7 rows. 

TOP...WITH TIES can be specified only in SELECT statements, and only if an ORDER BY clause is specified. 
The returned order of tying records is arbitrary. ORDER BY does not affect this rule.
*/
---------------------------------------------------------------------
-- top (N)
select top(4)* from employees 

-- top With Order By 
select top(4)* from employees 
order by EmployeeID  desc

select top (10)OrderID,CustomerID,OrderDate 
from orders
order by OrderDate desc

--top(n)
USE northwind
SELECT TOP 5 orderid,productid ,quantity
FROM [order details]
ORDER BY quantity desc
GO

-- TOP(n) with ties
USE northwind
SELECT TOP 5 WITH TIES orderid, productid, quantity
FROM [order details]
ORDER BY quantity DESC
GO

--PERCENT
SELECT TOP (10) PERCENT orderid, CustomerID, orderdate
FROM Orders
ORDER BY orderdate DESC;
-----------------------------------------------------------------------------------------------------
--Filtering in the ORDER BY Clause Using OFFSET-FETCH [New SQL 2012]
/*
-OFFSET { integer_constant | offset_row_count_expression } { ROW | ROWS } 
Specifies the number of rows to skip before it starts to return rows from the query expression. 
The value can be an integer constant or expression that is greater than or equal to zero. 

ROW and ROWS are synonyms and are provided for ANSI compatibility.

-FETCH { FIRST | NEXT } { integer_constant | fetch_row_count_expression } { ROW | ROWS } ONLY 
Specifies the number of rows to return after the OFFSET clause has been processed. 
The value can be an integer constant or expression that is greater than or equal to one. 

FIRST and NEXT are synonyms and are provided for ANSI compatibility.
-------------------------------------------------------------------
Notes :-
--------
Natural Language approach to code:
*) ROW and ROWS interchangeable
*) FIRST and NEXT interchangeable
ONLY optional—makes meaning clearer to human reader
OFFSET value and FETCH value may be constants or expressions, including variables and parameters
*/
Select Employees.EmployeeID , Employees.FirstName , Employees.LastName
from Employees
Order by Employees.EmployeeID
OFFSET 0 ROWS;   --Skip 0 rows

Select Employees.EmployeeID , Employees.FirstName , Employees.LastName
from Employees
Order by Employees.EmployeeID
OFFSET 6 ROWS;    --Skip 6 rows

Select Employees.EmployeeID , Employees.FirstName , Employees.LastName
from Employees
Order by Employees.EmployeeID
OFFSET 0 ROWS FETCH first 2 ROWS only;   

SELECT orderid, CustomerID, orderdate
FROM Orders
ORDER BY orderdate, orderid 
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;
--------------------------------------------------
/*
-- Logical Query Processing :- 
-------------------------------
5 SELECT    <select list>       Defines which columns to return
1 FROM      <table source>      Defines table(s) to query
2 WHERE     <search condition>  Filters rows using a predicate or Operators
3 GROUP BY  <group by list>     Arranges rows by groups
4 HAVING    <search condition>  Filters groups using a predicate or Operators
6 ORDER BY  <order by list>     Sorts the Result Set

 --1-From
 --2-On
 --3-Where 
 --4-Group by 
 --5-having 
 --6- select 
 --7-Order by 
 --8-Top


-- What is SQL statemts Processing ?
--1- parsing        Syntax 
--2- Resolving      Object 
--3- Optmizing      assing and select the Algorism 
--4- compiling      T_SQL
--5- Executing      Show result 
*/