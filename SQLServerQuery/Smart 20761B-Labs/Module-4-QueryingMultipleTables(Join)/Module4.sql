--==================================================================================================
--Module 4
--Querying Multiple Tables
---------------------------
--================================================
--Types of Relationships
--a. One-One Relationship    (1-1 Relationship)
--b. One-Many Relationship   (1-M Relationship)
--c. Many-Many Relationship  (M-M Relationship)
--================================================
/*
Querying Multiple Tables :-
-----------------------------------------

    -- Lessons :- 
	----------------
	 
	        1- Understanding Joins .
			2- Querying with Inner Joins.
			3- Querying with Outer Joins.
			4- Querying with Cross Joins and Self-Joins.

Querying Multiple Tables
 Inner Join 
 Outer Join
   - Left Out Join
   - Right Out Join 
   - Full Out Join  
Cross Join 
Self - Join 
*/
-- Join 
--inner join 
-- create dataBase DB 
-- create table department 
-- Create table Employees 
------------------------------
--EX Join 
------------------------------------------
--Code To Create 2 table
Create database Moduel4DB
go
USE Moduel4DB
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departments](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
 CONSTRAINT [PK_Departments] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[salary] [decimal](9, 2) NULL,
	[Job] [nvarchar](50) NULL,
	[departmentID] [int] NULL,
 CONSTRAINT [PK_Emps] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Departments] ON 

GO
INSERT [dbo].[Departments] ([ID], [Name]) VALUES (1, N'sales')
GO
INSERT [dbo].[Departments] ([ID], [Name]) VALUES (2, N'IT')
GO
INSERT [dbo].[Departments] ([ID], [Name]) VALUES (3, N'HR')
GO
INSERT [dbo].[Departments] ([ID], [Name]) VALUES (4, N'Training')
GO
SET IDENTITY_INSERT [dbo].[Departments] OFF
GO
SET IDENTITY_INSERT [dbo].[Emps] ON 

GO
INSERT employees ([ID], [Name], [salary], [Job], [departmentID]) VALUES (1, N'ahmed Ali', CAST(4000.00 AS Decimal(9, 2)), N'DBA', 2)
GO	   
INSERT employees ([ID], [Name], [salary], [Job], [departmentID]) VALUES (2, N'retaj', CAST(5000.00 AS Decimal(9, 2)), N'Developer', 4)
GO	   
INSERT employees ([ID], [Name], [salary], [Job], [departmentID]) VALUES (3, N'Mohammed', CAST(6000.00 AS Decimal(9, 2)), N'HR', 3)
GO	   
INSERT employees ([ID], [Name], [salary], [Job], [departmentID]) VALUES (4, N'Maraim', CAST(1000.00 AS Decimal(9, 2)), N'developer', NULL)
GO
SET IDENTITY_INSERT [dbo].[Emps] OFF
GO
----------------------------------------------------------------------------- 
select * from departments
select * from emps

select e.*,d.Name
from Departments as d  join Employees as e  
on d.ID =e.departmentID

select e.*,d.Name
from Departments as d right join Employees as e  
on d.ID =e.departmentID


select e.*,d.Name
from Departments as d left join Employees as e  
on d.ID =e.departmentID

select e.*,d.Name
from Departments as d full join Employees as e  
on d.ID =e.departmentID
--------------------------------------------------------------------------
--====================================================================================================================
/*
-- 1) Understanding Joins :-
----------------------------
   - T-SQL joins are used to combine rows from two or more tables.
   A) The FROM Clause and Virtual Tables :- 
   -------------------------------------
    - Virtual table will hold the output of the FROM clause and,
	   will be used subsequently by other phases of the SELECT statement, such as the WHERE clause.
	- The virtual table created by a FROM clause is a logical entity only. In SQL Server 2016, no physical table is created.
	- Table aliases improves the readability of the query, without affecting the performance.
	- It is strongly recommended that you use table aliases in your multi-table queries. 
  B) Join Terminology: Cartesian Product :- 
  ---------------------------------------
   - Cartesian product is the product of two sets. The product of a set of 2 items and a set of 6 items is a set of 12 items.
   - The product of a table with 10 rows and a table with 100 rows is a result set with 1,000 rows.  
   - Cartesian product occurs when two input tables are joined without considering any logical relationships.  
  C) Overview of Join Types :- 
  ------------------------------
   - (CROSS JOIN) adds all possible combinations of the two input tables' rows to the virtual table. Any filtering of the                      rows will happen in a WHERE clause. this operator is to be avoided. 
   -  (INNER JOIN) creates a Cartesian product, then filters the results using the predicate supplied in the ON clause,                         removing any rows from the virtual table that do not satisfy the predicate.
                   inner join is a very common type of join for retrieving rows with attributes that match across tables,
	               such as matching Customers to Orders by a common custid.  
   - (OUTER JOIN) creates a Cartesian product, then filters the results to find rows that match in each table. However,
                  all rows from one table are preserved, added back to the virtual table after the initial filter is applied.                  NULLs are placed on attributes where no matching values are found.

  D) T-SQL Syntax Choices :- 
  ---------------------------
   
           - Through the history of versions of SQL Server, 
		     the product has changed to keep pace with changes in the ANSI standards for the SQL language.
		   - In ANSI SQL-89, no (ON) operator was defined. 

		   - This syntax of ANSI SQL-89 is still supported by SQL Server 2016.
		   - ANSI SQL-89-style joins can easily become Cartesian products and cause performance problems. 
		   - The ANSI SQL-92 standard, support for the ON clause was added.
		   - The logical relationship between the tables is represented with the ON clause.
		   - As performance of query optimizer in SQL Server does not favor one syntax over the other.
*/

--JOIN using ANSI SQL-89
USE Northwind
SELECT * 
FROM Products AS P  ,  [Order Details] AS OD
WHERE P.ProductID = OD.ProductID
GO
--JOIN using ANSI SQL-92    -- recommended
USE Northwind
SELECT * 
FROM   Products AS P JOIN   [Order Details] AS OD
ON  P.ProductID = OD.ProductID
GO
/*
---------------------------------------------------------------------------------------------------------------------
-- Lesson 2) Querying with Inner Joins :- 
------------------------------------------
     A) Understanding Inner Joins :-
	 -------------------------------
	    - selects all rows from both tables as long as there is a match between the columns in both tables.
		- INNER JOIN are the most common types of queries to solve many business problems,
		  especially in highly normalized database environments.
		-  By expressing a logical relationship between the tables, 
		   you will retrieve only those rows with matching attributes present in both tables.
     B) Inner Join Syntax :- 
	 ------------------------
	   - Table aliases are preferred not only for the SELECT list, but also for expressing the ON clause.  
	   - INNER JOIN may be performed on a single matching attribute, or on multiple matching attributes.
	     Joins that match multiple attributes are called composite joins
	   - The order in which tables are listed and joined in the FROM clause does not matter to the SQL Server optimizer.
	   - Use the JOIN keyword once for each two tables in the FROM list. For a two-table query, specify one join.
	   - In Syntax both working :-  
		      A) With INNER     ( INNER JOIN )
			  B) Without INNER  ( JOIN )              -- Default Join is Inner in SQL .

	C) Inner Join Examples :- 
	-------------------------
*/

-- JOIN on a single matching attribute :-
USE Northwind
SELECT P.ProductID,P.ProductName,OD.Quantity,OD.Quantity
FROM   Products AS P JOIN   [Order Details] AS OD
ON  P.ProductID = OD.ProductID
GO

-- JOIN on two matching attributes :-
USE Northwind
SELECT DISTINCT C.City, C.Country
FROM   Employees AS E JOIN   Customers AS C
ON     E.Country = C.Country AND    E.City    = C.City        -- Result show Unique cities & countries in matches in both tables.
GO

-- Example For extended JOIN OR Multiple Join Or Nested Join :-
USE Northwind
SELECT E.EmployeeID,E.FirstName + ' ' + E.LastName AS 'Employee Name',C.CustomerID,C.CompanyName AS  'Customer Name',
	   O.OrderID,O.OrderDate
FROM   Customers AS C JOIN   Orders AS O
ON     C.CustomerID = O.CustomerID JOIN   Employees AS E
ON     O.EmployeeID = E.EmployeeID
GO                                     -- Result Show Data from 3 tables .
/*
---------------------------------------------------------------------------------------------------------------------
 -- Lesson 3) Querying with Outer Joins :-
 ------------------------------------------
   A) Understanding Outer Joins :-
   -------------------------------
        - Will retrieve not only rows with matching attributes,
		  but all rows present in one of the tables, whether or not there is a match in the other table.
		- Outer Joins :- 
		        LEFT OUTER :-  returns all rows from the left table with the matching rows in the right table. 
				               The result is NULL in the right side when there is no match.
				RIGHT OUTER :- returns all rows from the right table with the matching rows in the left table.
				               The result is NULL in the left side when there is no match.
				FULL OUTER :-  returns all rows from the left table and All from the right table. 
				               FULL OUTER JOIN combines the result of both LEFT and RIGHT joins.
	B) Outer Join Syntax :- 
	------------------------
	    - Outer joins are expressed using the keywords LEFT, RIGHT, or FULL preceding OUTER JOIN. 
		- As with inner joins, may be performed on a single matching attribute or on multiple matching attributes.
		- Unlike inner joins, the order in which tables are listed and joined in the FROM clause does matter,
		  because it will determine whether you choose LEFT or RIGHT for your join. 
        - To display only rows where no match exists,
		  add a test for NULL in a WHERE clause following an OUTER JOIN predicate. 
		- In Syntax both working :-
		      A) With OUTER ( LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN  )
			  B) Without OUTER  ( LEFT JOIN, RIGHT JOIN, FULL JOIN  
   C) Outer Join Examples :- 
   -------------------------
*/
-- Example for displays all customers and provides information about each customer's orders if any exist :-
USE Northwind
SELECT  C.CompanyName,C.Country,O.OrderDate
FROM    Customers AS C LEFT JOIN Orders AS O
ON   C.CustomerID = O.CustomerID
GO
-- Example displays only customers that have never placed an order:-
USE Northwind
SELECT  C.CompanyName,C.Country,O.OrderDate
FROM    Customers AS C LEFT JOIN Orders AS O
ON   C.CustomerID = O.CustomerID
WHERE O.CustomerID IS NULL
GO
--------------------------------------------------------------------------------------------------------------------------
/*
-- Lesson 4) Querying with Cross Joins and Self-Joins :-
---------------------------------------------------------
  A) Understanding Cross Join :-  also called " Cartesian products " .
  -----------------------------
      - return all rows from the left table,
        Each row from the left table is combined with all rows from the right table.
	  - Combine each row from first table with each row from second table.
  B) Cross Join Syntax :-
  ------------------------
     - There is no matching of rows performed, and therefore no ON clause is required.
*/
-- CROSS JOIN ANSI-89
USE northwind
SELECT su.companyname,sh.companyname
FROM suppliers AS su , shippers AS sh
GO

-- CROSS JOIN ANSI-92
USE northwind
SELECT su.companyname, sh.companyname
FROM   suppliers AS su CROSS JOIN shippers AS sh
GO
/*
    C) Understanding Self-Joins :-
	--------------------------------
        - Compare rows in same table to each other.
		- At least one alias required.
        - Return all employees and the name of the employee’s manager.
*/
-- Example for Employee with  manager when a manager exists (inner join):
USE Northwind
SELECT E.EmployeeID,
       E.firstname + ' ' + E.LastName AS 'Employee Name',
       M.firstname + ' ' + M.LastName AS 'Manager Name'
FROM   Employees E JOIN Employees M 
ON     E.ReportsTo = M.employeeID       -- Result show no EmployeeID 2 because there is no manager
GO

-- Example all employees with ID of manager (outer join). This will return NULL for the CEO:
USE Northwind
SELECT E.EmployeeID,
       E.firstname + ' ' + E.LastName AS 'Employee Name',
       M.firstname + ' ' + M.LastName AS 'Manager Name'
FROM   Employees E LEFT JOIN Employees M 
ON     E.ReportsTo = M.employeeID       -- Result show  EmployeeID 2 is no manager AS NULL
GO
--=======================================================================================================
--Ex2
-- Create Table As Souq Customers :-
CREATE TABLE SouqCustomers
(
       CustomerID INT,
	   FirstName NVARCHAR(50),
	   LirstName NVARCHAR(50),
	   Mail VARCHAR(100),
	   City VARCHAR(50)
)
GO

-- Insert Data in Table Souq Customers :-
INSERT INTO SouqCustomers
VALUES ( 1, 'Ahmed', 'Ali', 'Ahmed.Ali.Mohamed@live.com', 'Alexandria' ),
       ( 2, 'Sara', 'Mohamed', 'Sara.Mohamed@live.com', 'Alexandria' ),
	   ( 3, 'Walid', 'Ahmed', 'Walid.Ahmed@live.com', 'Cairo' ),
	   ( 4, 'Ghada', 'Ali', 'Ghada.Ali@live.com', 'Giza' )
GO

-- Create Table As Souq Orders :-
CREATE TABLE SouqOrders
(
       OrderID INT,
	   CustomerID INT,
	   OrderDate Datetime,
	   TotalPrice Money
)
GO

-- Insert Data in Table Souq Orders :-
INSERT INTO SouqOrders
VALUES ( 1, 1, GETDATE(), 500),
       ( 2, 1, GETDATE(), 100),
	   ( 3, 2, GETDATE(), 400)
GO

-- Show Both tables :-
SELECT * FROM   SouqCustomers
GO
SELECT * FROM   SouqOrders
GO

-- INNER JOIN to Show customers with orders :-
SELECT      DISTINCT SC.FirstName + ' ' + SC.LirstName AS FullName,	SC.Mail
FROM        SouqCustomers AS SC JOIN        SouqOrders    AS SO
ON          SC.CustomerID = SO.CustomerID
GO

-- OUTER JOIN to Show Customers Never make any order :- 
SELECT      DISTINCT SC.FirstName + ' ' + SC.LirstName AS FullName,SC.Mail
FROM        SouqCustomers AS SC LEFT JOIN   SouqOrders    AS SO
ON          SC.CustomerID = SO.CustomerID
WHERE SO.CustomerID IS NULL
GO
--====================================== Extra --------------------------
-------------------------------------------
-- Join more than one table (Nested Join)
-- --------------------------------------
select * from Products
select * from Orders
select * from [Order Details]

USE northwind
SELECT orderdate, productname
FROM orders AS O INNER JOIN [order details] AS OD
ON O.orderid = OD.orderid INNER JOIN products AS P
ON OD.productid = P.productid
WHERE orderdate = '7/8/96'

--================ MOC Demo ================================
use Northwind
select * from products
select * from [order details]

select OrderID,od.productid,od.UnitPrice,ProductName
from [Order Details] as od,Products as p
where od.ProductID=p.ProductID

select OrderID,od.productid,od.UnitPrice,ProductName
from [Order Details] as od inner join  Products as p
on od.ProductID=p.ProductID

select OrderID,od.productid,od.UnitPrice,ProductName
from [Order Details] as od  right outer join  Products as p
on od.ProductID=p.ProductID

select OrderID,od.productid,od.UnitPrice,ProductName
from Products as p  left outer join [Order Details] as od  
on od.ProductID=p.ProductID

-------------------------------------------------------------
select orderid,od.productid,productname,od.unitprice,unitsinstock
from Products as p inner join [Order Details] as od
on p.ProductID=od.ProductID
where od.UnitPrice>100
-------------------------------------------------------------
select orderid,od.productid,productname,od.unitprice,unitsinstock
from Products as p inner join [Order Details] as od
on p.ProductID=od.ProductID
where od.UnitPrice between 50 and 100
-------------------------------------------------------------
select orderid,od.productid,productname,od.unitprice,unitsinstock
from Products as p inner join [Order Details] as od
on p.ProductID=od.ProductID
where od.UnitPrice between 50 and 100 and OrderID in (10420,10516,10535)
--------------------------------------------------------------
select orderid,od.productid,productname,od.unitprice,unitsinstock,companyname
from [Order Details] as od   inner join Products as p 
on p.ProductID=od.ProductID inner join Suppliers as s
on p.SupplierID=s.SupplierID
where od.UnitPrice between 50 and 100 and OrderID in (10420,10516,10535)
---------------------------------------------------------------
SELECT c.CUSTOMERID,CompanyName,OrderDate
FROM CUSTOMERS as c INNER JOIN ORDERS as o
ON c.CUSTOMERID=o.CUSTOMERID
ORDER BY c.CUSTOMERID
---------------------------------------------------------------
--left outer join
SELECT c.CUSTOMERID,c.CompanyName,o.CustomerID,o.OrderDate
FROM CUSTOMERS as c left outer join ORDERS as o
ON c.CUSTOMERID=o.CUSTOMERID
ORDER BY c.CUSTOMERID
---------------------------------------------------------------
SELECT c.CUSTOMERID,c.CompanyName,o.CustomerID,o.OrderDate
FROM CUSTOMERS as c left outer join ORDERS as o
ON c.CUSTOMERID=o.CUSTOMERID
where o.customerid is null
ORDER BY c.CUSTOMERID
---------------------------------------------------------------
--right outer join
SELECT  PRODUCTS.PRODUCTID, PRODUCTS.PRODUCTNAME, CATEGORIES.CATEGORYID, CATEGORIES.CATEGORYNAME
FROM PRODUCTS RIGHT OUTER JOIN CATEGORIES 
ON PRODUCTS.CATEGORYID = CATEGORIES.CATEGORYID
---------------------------------------------------------------
SELECT  PRODUCTS.PRODUCTID, PRODUCTS.PRODUCTNAME, CATEGORIES.CATEGORYID, CATEGORIES.CATEGORYNAME
FROM PRODUCTS RIGHT OUTER JOIN CATEGORIES 
ON PRODUCTS.CATEGORYID = CATEGORIES.CATEGORYID
WHERE PRODUCTS.CATEGORYID IS NULL
--------------------------------------------------------------
--full outer join
SELECT c.CustomerID ,c.city  ,c.country,e.firstname,e.lastname 
FROM employees e  FULL OUTER JOIN customers c
ON e.city = c.city 
--===============================================================================
select orderid,od.productid,productname,od.unitprice,unitsinstock,companyname
from [Order Details] as od   inner join Products as p 
on p.ProductID=od.ProductID  inner join Suppliers as s
on p.SupplierID=s.SupplierID
where od.UnitPrice between 50 and 100 and OrderID in (10420,10516,10535)
-------------------------------------------------------------
--acting as inner join 
select *
from Products cross join Categories
where Products.CategoryID=Categories.CategoryID
-------------------------------------------------------------
--self join
select emp.FirstName as employee,mgr.FirstName as manager
from Employees as emp inner join Employees as mgr
on emp.ReportsTo=mgr.EmployeeID
------------------------------------------------------------
select emp.FirstName as employee,mgr.FirstName as manager
from Employees as emp left outer join Employees as mgr
on emp.ReportsTo=mgr.EmployeeID
------------------------------------------------------------
--non-equi join
select emp1.FirstName,emp1.HireDate
from Employees as emp1 inner join Employees as emp2
on emp1.EmployeeID!=emp2.EmployeeID 
and emp1.HireDate=emp2.HireDate
------------------------------------------------------------



