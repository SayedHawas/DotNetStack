--===================================================================================
--Module 3:  
--Writing SELECT Queries

	--1- Writing Simple SELECT Statements.
	--2- Eliminating Duplicates with DISTINCT. 
	--3- Using Column and Table Aliases.
	--4- Writing Simple CASE Expressions. 
--===================================================================================
--Expressions :- 
------------------ 
 -- Combination of identifiers, values, and operators evaluated to obtain a single result.
 -- Can be used in SELECT statements , WHERE clause. */

-- Example For Expressions
--identifiers
--============
/*       1- -- OR /* */
         2- [ ]
         3- ""
         4- #
         5- @
*/
--EX:-
------
--Using Calculations in the SELECT Clause

Select 10 -- Select 10 = Print 10
 
select 10+4

select 10%3 

select 'Ahmed '+'Ali'

-- Basic Select statement
-- ----------------------
-- A basic SELECT statement only requires two parts: 
-- A select list of columns to show  
-- A FROM clause indicating the table that holds the data.

--Display all columns
use northwind
select *
from Employees
GO


--Ex:-
use northwind
select FirstName ,LastName
from Employees
Go;
--OR
-- Before Expressions FirstName and LastName not in the same Column
USE northwind
SELECT  EmployeeID,FirstName,LastName,City 
FROM Employees
GO

-- After Expressions FirstName and LastName in the same Column using Alias FullName
USE northwind
SELECT EmployeeID,FirstName + ' ' + LastName AS FullName,City 
FROM Employees
GO


use northwind
select Products.ProductID , Products.ProductName ,Products.UnitPrice , products.UnitsInStock
from Products
Go

--To use a built-in T-SQL function on a column in the SELECT list, you pass the name of the column to the
--function as an input:
--Ex:-
select * from employees 

select employeeId , lastname , Hiredate 
from employees 

SELECT EmployeeID, lastname, hiredate, YEAR(hiredate) as [Hire Year]
FROM Employees
Go;
-----------------------------------------------------------------------------
/*Remember :-
----------
-- Logical Query Processing :- 
-------------------------------

5 SELECT    <select list>       Defines which columns to return
1 FROM      <table source>      Defines table(s) to query
2 WHERE     <search condition>  Filters rows using a predicate or Operators
3 GROUP BY  <group by list>     Arranges rows by groups
4 HAVING    <search condition>  Filters groups using a predicate or Operators
6 ORDER BY  <order by list>     Sorts the Result Set

Writing Simple SELECT Statements:-
-----------------------------------------------
    - The SELECT and FROM clauses are the primary focus of this module.
	- You Should End all statements with a semicolon (;) character.
	   A) In the current version of SQL Server 2012, semicolons are an optional terminator for most statements.
	   B) Future versions will require semicolon (;) character.
	- If the table name contains irregular characters such as spaces,  you will need to delimit, or enclose, the name.
	   A) T-SQL supports the use of the ANSI standard double quotes "Sales Order Details".
	   B) SQL Server-specific square brackets [Sales Order Details].
*/
-----------------------------------------------------------------------------
--Example for using brackets :-
USE    Northwind
SELECT * FROM  [Sales by Category]
GO
--Example for using double quotes :-
USE    Northwind
SELECT * FROM   "Sales by Category"     -- ANSI Standard
GO
--============================================================================================
/*
    - T-SQL supports the use of the asterisk, or “star” character (*) to substitute for an explicit column list. 
	   A) This will retrieve all columns from the source table.
	   B) Avoid using the * in production work, because it will retrieve all columns in the table’s, This could cause bug.
--Eliminating Duplicates with DISTINCT :- 
----------------------------------------------------
  - The rows retrieved by a query are not guaranteed to be unique, or in order .
  - DISTINCT   to eliminate duplicates. 
  - ORDER BY  to Order the result set.
*/
-- Example for Duplicated values 
USE    Northwind
go
SELECT Country FROM   Customers
GO
-- Using SELECT ALL "The same Result" :-
USE    Northwind
SELECT ALL Country    -- ALL values in Country 
FROM   Customers
GO

--  SELECT DISTINCT Replace SELECT ALL :-
USE    Northwind
go
SELECT DISTINCT Country    -- Unique values in Country 
FROM   Customers
GO
select  title from employees 
--- use Distinct 
-- select Without Duplication  
select distinct title
from Employees

select  distinct city 
from employees 

-- Two columns
select distinct title,city 
from employees 

select distinct city , title
from employees

--===================================
--Using Aliases to Refer to Columns
--===================================
-- with As 
select (city +' '+ country ) as address  ,firstName 
from employees 
-- WithOut as 
select (city +' '+ country )  address  ,firstName 
from employees
 -- = 
select   address = (city +' '+ country ) ,firstName 
from employees

-- ========================================
--Using Aliases to Refer to Table 

select Products.ProductID , Products.ProductName ,Products.UnitPrice , products.UnitsInStock
from Products

select Products.ProductID , Products.ProductName ,Products.UnitPrice , products.UnitsInStock  --error Must Use Alias
from Products as p 

select p.ProductID , p.ProductName ,p.UnitPrice , p.UnitsInStock
from Products as p
-----------------------------
/* Writing Simple CASE Expressions :- 
-----------------------------------------------
  - The CASE expression has two formats:-
     A) "The simple" CASE expression compares an expression to a set of simple expressions to determine the result.
     B) "The searched" CASE expression evaluates a set of Boolean expressions to determine the result.

  - Both formats support an optional ELSE argument.
  - In T-SQL CASE expressions return a single, or scalar, value. Unlike in some other programming languages.
  - In T-SQL CASE expressions are not statements, nor do they specify the control of programmatic flow.
  - CASE expressions can be used include in the SELECT, WHERE, HAVING, IN, DELETE, UPDATE, and inside of built-in functions.
---------------------------------------------------------------------------------------------------------------------
 1) Simple CASE expressions 
 --------------------------
    - A simple CASE expression checks one expression against multiple values.
	- Within a SELECT statement, a simple CASE expression allows only an equality check; no other comparisons are made.
	- Working by comparing the first expression to the expression in each WHEN clause for equivalency.
	- If these expressions are equivalent, the expression in the THEN clause will be returned.

-- Simple Case Syntax :- 
-------------------------
     CASE expression
     WHEN expression1 THEN expression1
    [[WHEN expression2 THEN expression2] [...]]
    [ELSE expressionN]
	  END
*/
use Northwind

select firstname, lastname ,city,country ,
CASE country 
when 'usa'  then 'America' 
when 'UK'   then  'British'
else  ' anthor language'
end as 'language'
from employees
go

SELECT productid, productname, categoryid,
CASE categoryid
WHEN 1 THEN 'Beverages'
WHEN 2 THEN 'Condiments'
WHEN 2 THEN 'Confections'
ELSE 'Unknown Category'
END AS categoryname
FROM Products

--Lab 
use Northwind 
go 
Create table EmployeesCase
(
ID int identity Primary Key ,
Name nvarchar(50),
Salary decimal(9,2),
Attend bit 
)
go 
insert into EmployeesCase values 
('Ahmed',2000,Null),
('Ali',3000,0),
('Retaj',4000,1),
('Mariam',5000,1),
('sayed',6000,0)

select * from EmployeesCase
-----------------------------
--Two Forms of CASE Expressions:
--1-Simple CASE
--EX:

select ID, Name , attend , salary
from EmployeesCase

select ID, Name , case  attend 
when 1 then 'attend'
when 0 then 'No attend'
else 'Not Yet'
end as [status Attend]
from EmployeesCase

---------------------------------------------------------------------------
/*
 2) Searched CASE expressions :-
 -------------------------------
 - Allows comparison operators, and the use of AND and/or OR between each Boolean expression. 
-- Searched Case Syntax :- 
-------------------------
     CASE
	 WHEN Boolean_expression1 THEN expression1
     [[WHEN Boolean_expression2 THEN expression2] [...]] 
     [ELSE expressionN] 
	 END
*/
--2-Searched CASE (with conditions or predicates)
--EX:
select ID , Name ,Salary from EmployeesCase 

select ID , Name , Salary , 
"salary range" = case 
when salary >1000 and salary <=2000 then 'Low'
when salary >2000 and salary <=3000 then 'medium'
else 'high'
end 
from EmployeesCase

--2-Searched CASE (with conditions or predicates)
--EX:
use MyDB
select Name , salary , 
"salary range" = case 
when salary >500 and salary <=1000 then 'Low'
when salary >1000 and salary <=2000 then 'medium'
else 'high'
end 
from Employees

SELECT   Productid, ProductName, "Price Range" = 
      CASE 
         WHEN unitPrice =  0 THEN 'item - not for resale'
         WHEN unitPrice < 50 THEN 'Under $50'
         WHEN unitPrice >= 50 and unitPrice < 250 THEN 'Under $250'
         WHEN unitPrice >= 250 and unitPrice < 1000 THEN 'Under $1000'
         ELSE 'Over $1000'
      END
FROM Products

-------------------------------------------------------------------------------
--2-Searched CASE (with conditions or predicates)
--EX:     
SELECT   Employeeid , firstname,lastname ,ReportsTo, "number of leader" = 
      CASE 
         WHEN ReportsTo  = 1                      THEN 'this is General Manager'
         WHEN ReportsTo  = 2   or ReportsTo = 3   THEN 'head of department'
         WHEN ReportsTo  = 4                      THEN 'High Employee'
         WHEN ReportsTo  = 5                      THEN  'this is Developer'
         ELSE 'Office Boy'
      END
FROM Employees
----------------------------------------------------------------------------------------------------
