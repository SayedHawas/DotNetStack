--================================================================				    
					--Module 11
					--Using Table Expressions

/*
					Using Views
					Using Inline TVFs
					Using Derived Tables
					Using CTEs


--Lesson 1: Using Views
		Writing Queries That Return Results from Views
		Creating Simple Views
		Demonstration: Using Views

Views may be referenced in a SELECT statement just like a table
Views are named table expressions with definitions stored in a database
Like derived tables and CTEs, queries that use views can provide encapsulation and simplification
From an administrative perspective, views can provide a security layer to a database


*/
--=================================================================
--Creating Simple Views
-------------------------
--Views are saved queries created in a database by administrators and developers
--Views are defined with a single SELECT statement
--ORDER BY is not permitted in a view definition without the use of TOP, OFFSET/FETCH, or FOR XML
--To sort the output, use ORDER BY in the outer query
--View creation supports additional options beyond the scope of this class

go
Create view VW_ShowEmployees
as
select EmployeeId , Firstname , Lastname ,Country  
from employees
where EmployeeId >5
go

--Now You Can call view 
select * from VW_ShowEmployees
--With Where 
select * from VW_ShowEmployees where country='UK'
--With Order By
select * from VW_ShowEmployees where country='UK' order by Firstname
--============================================================================
--Lesson 2: Using Inline TVFs
--------------------------------
--Writing Queries That Use Inline TVFs
--Creating Simple Inline TVFs
--Retrieving from Inline TVFs
--Demonstration: Inline TVFs

--Writing Queries That Use Inline TVFs
---------------------------------------
--TVFs are named table expressions with definitions stored in a database
--TVFs return a virtual table to the calling query
--SQL Server provides two types of TVFs:
--Inline, based on a single SELECT statement
--Multi-statement, which creates and loads a table variable
--Unlike views, TVFs support input parameters
--Inline TVFs may be thought of as parameterized views


--Creating Simple Inline TVFs:-
--------------------------------
--TVFs are created by administrators and developers
--Create and name function and optional parameters with CREATE FUNCTION
--Declare return type as TABLE
--Define inline SELECT statement following RETURN

go
Create function Fn_test(@OID int)
returns table 
as 
return select orderId ,Quantity ,UnitPrice,cast(quantity * unitprice as decimal(9,2)) as Total
       from [Order Details]
	   where OrderID = @OID;
go
select * from fn_test(10248) 


-----------------  ----Demo on Function ----------------------------------
-- string Function
  go 
  create function Fun_MyStringFun(@x nvarchar(100))
  returns nvarchar(100)
  begin 
   return (Concat(Upper( substring(ltrim(@x),1,1)) ,lower(substring (ltrim(@x),2,len(@x)))))
  end 
go
Select firstname ,[dbo].[Fun_MyStringFun](firstname + lastname)from Employees 
--=================================================================================================
--Lesson 3: Using Derived Tables
---------------------------------
--Writing Queries with Derived Tables
--Guidelines for Derived Tables
--Using Aliases for Column Names in Derived Tables
--Passing Arguments to Derived Tables
--Nesting and Reusing Derived Tables
--Demonstration: Using Derived Tables

--Writing Queries with Derived Tables
--------------------------------------
--Derived tables are named query expressions created within an outer SELECT statement
--Not stored in database—represents a virtual relational table
--When processed, unpacked into query against underlying referenced objects
--Allow you to write more modular queries

--SELECT <column_list>
--FROM	(
--	<derived_table_definition>
--	) AS <derived_table_alias>;

--Scope of a derived table is the query in which it is defined
/*
--Notes 
-------
--Derived Tables Must:-
------------------------
1-Have an alias
2-Have names for all columns
3-Have unique names for all columns
4-Not use an ORDER BY clause (without TOP or OFFSET/FETCH)
5-Not be referred to multiple times in the same query

Derived Tables May:-
---------------------
1-Use internal or external aliases for columns
2-Refer to parameters and/or variables
3-Be nested within other derived tables

*/
--Column aliases may be defined inline:
SELECT orderyear, COUNT(DISTINCT customerID) AS cust_count
FROM (SELECT YEAR(orderdate) AS orderyear, CustomerID FROM Orders) AS derived_year
GROUP BY orderyear;

--Column aliases may be defined externally:
SELECT orderyear, COUNT(DISTINCT custid) AS cust_count
FROM (SELECT YEAR(orderdate), CustomerID FROM Orders) AS derived_year(orderyear, custid)
GROUP BY orderyear;
----------------------------------------------------------------------------------------------
--Passing Arguments to Derived Tables
--Derived tables may refer to arguments
--Arguments might be:
--Variables declared in the same batch as the SELECT statement
--Parameters passed into a table-valued function or stored procedure

DECLARE @empid INT = 9;
SELECT orderyear, COUNT(DISTINCT CustomerID) AS cust_count
FROM (SELECT YEAR(orderdate) AS orderyear, customerID FROM Orders WHERE EmployeeID=@empid) AS derived_year
GROUP BY orderyear;
--==============================================================================================================
--Lesson 4: Using CTEs :-
--=========================
							/*
							Writing Queries with CTEs
							Creating Queries with Common Table Expressions
							*/
--
/*
CTE Common Table Exprssion 
Writing Queries with CTEs
CTEs are named table expressions defined in a query
CTEs are similar to derived tables in scope and naming requirements
Unlike derived tables, CTEs support multiple definitions, multiple references, and recursion

Syntax-
-------------------------------------
WITH <CTE_name> 
AS (
	<CTE_definition>
)
<outer query referencing CTE>;
--------------------------------------
To create a CTE:-
-----------------
Define the table expression in a WITH clause
Assign column aliases (inline or external)
Pass arguments if desired
Reference the CTE in the outer query

*/
select * from orders
go 
with Ctp_year
as
(
select year(orderDate) as OrderYear ,customerID from orders
)
select orderyear,count(distinct customerid)as CustCount
from Ctp_year 
Group By orderyear

--=======================================================================
