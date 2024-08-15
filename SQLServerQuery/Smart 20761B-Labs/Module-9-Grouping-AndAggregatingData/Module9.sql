/*
-- Module 9) Grouping and Aggregating Data :-
---------------------------------------------
   -- Lessons :-
      ----------         1)- Aggregation Functions. 
	                     2)- Group By Clause.
						 3)- Having Clause.
----------------------------------------------------------------------------------------------------------------------
-- Lesson 1) Aggregation Functions :-
--------------------------------------
		       - Take one or more input To return a single summarizing value.
			   - Examples :- AVG(), MAX(), MIN(), SUM(), COUNT().
		       - Can be used in ( SELECT, HAVING, and ORDER BY ) clauses .
			   - Frequently  used with GROUP BY clause. 
*/
-- AVG :- Averages all non-NULL numeric values in a column.
-- AVG(<Expression>)

SELECT AVG(Quantity) AS Quantity_Average
FROM   [Order Details]
GO

-- SUM :- Totals all the non-NULL numeric values in a column.
-- SUM(<Expression>)
SELECT SUM(Quantity) AS Quantity_Total_Sum
FROM   [Order Details]
GO	   

-- COUNT(<Expression>) 
-- COUNT(*)  "Include NULLS"
SELECT COUNT(*) AS Count_All_Rows_With_NULL,
       COUNT(region) AS Count_Region_No_NULL
FROM   Customers
GO

-- MIN :-Returns the smallest number.
-- MIN(<Expression>)
SELECT MIN(Quantity) AS Quantity_Minimum
FROM   [Order Details]
GO

-- MAX :- Returns the largest number.
-- MAX(<Expression>)
SELECT MAX(Quantity) AS Quantity_Maximum
FROM   [Order Details]
GO	   

-- Note :-
-- MAX() & MIN() Works with Date & String
SELECT MIN(CustomerID) AS First_Customer_A_Z,
       MAX(CustomerID) AS Last_Customer_Z_A,
	   MIN(YEAR(OrderDate)) AS earliest_Date,
	   MAX(YEAR(OrderDate)) AS Latest_Date
FROM   Orders
GO
/*			   
			   - Use DISTINCT with aggregate functions to summarize only unique values.
			   - DISTINCT aggregates eliminate duplicate values, not rows (unlike SELECT DISTINCT).
*/

SELECT COUNT(ProductID) AS ProductID_Rows,
       COUNT(DISTINCT ProductID) AS Unique_ProductID_Rows
FROM   [Order Details]

/*
			   - Ignore NULLs except in COUNT(*).
			   - NULL may produce incorrect results
			   - Use ISNULL or COALESCE to replace NULLs before aggregating.
*/
-- Create table for example
CREATE TABLE Temp1
(
  ID INT, Score INT
)
-- Insert Data
INSERT Temp1
VALUES (1,20),(2,40),(3,60),(4,NULL)
GO
-- Show table
SELECT *
FROM Temp1

-- See Null not count
SELECT Min(Score) AS Score_Min
FROM   Temp1

-- Using isnull or coalesce To make it count
SELECT Min(ISNULL(Score,0)) AS Score_Min
FROM   Temp1
GO
----------------------------------------------------------------------------------------------------------------------
/*
-- Lesson 2) Group By Clause :-
--------------------------------------
       - GROUP BY creates groups for output rows, according to unique combination of values specified in the GROUP BY clause.
	   - GROUP BY calculates a summary value for aggregate functions in subsequent phases.
	   - All columns in SELECT, HAVING, and ORDER BY must appear in GROUP BY clause or be inputs to aggregate expressions.
	   - Aggregate functions are commonly used in SELECT clause, summarize per group.
	   - Aggregate functions may refer to any columns, not just those in GROUP BY clause.
*/
-- GROUP BY Example 1)
-- Show every Employee with how many rows he have.
SELECT EmployeeID, COUNT(*) AS Rows_For_Employee
FROM   Orders
GROUP BY EmployeeID
GO

-- GROUP BY Example 2)
-- Error Will Show Because :-
-- All columns in SELECT, HAVING, and ORDER BY must appear in GROUP BY clause or be inputs to aggregate expressions.
SELECT EmployeeID,YEAR(OrderDate) AS OrderYear, COUNT(*) AS Rows_For_Employee
FROM   Orders
GROUP BY EmployeeID
GO

-- To make it work add date to group by
SELECT EmployeeID,YEAR(OrderDate) AS OrderYear, COUNT(*) AS Rows_For_Employee
FROM   Orders
GROUP BY EmployeeID , YEAR(OrderDate)
GO

-- Group By Example 3)
SELECT ProductID, MAX(Quantity) AS largest_order 
FROM   [Order Details]
GROUP BY productid
ORDER BY largest_order DESC
GO
----------------------------------------------------------------------------------------------------------------------
/*
-- Lesson 3) Having Clause :-
-------------------------------------
      - HAVING clause provides a search condition that each group must satisfy.
	  - HAVING clause is processed after GROUP BY.
	  - WHERE  :- filters rows before groups created
      - HAVING :- filters groups Controls which groups are passed to next logical phase.
*/
-- Having Example 1)
-- Customers make more than 10 orders
SELECT CustomerID,COUNT(*) AS Count_Orders 
FROM   Orders 
GROUP BY CustomerID
HAVING COUNT(*) > 10
GO

-- Having Example 2)
-- Employees done more than 50 order 
-- and employeeID > 4
SELECT EmployeeID, COUNT(*) AS OrderCount
FROM   Orders
WHERE  EmployeeID > 4
GROUP BY EmployeeID
HAVING COUNT(*) > 50
GO
-------------------------------------------------------------------------------------------
--Lab (HOL)
------------
select COUNT(*)
from Employees
----------------------------------------------------------------
select COUNT(FirstName)
from Employees
----------------------------------------------------------------
--Testing Nulls
select count( Country)
from Employees
----------------------------------------------------------------
select count(ISNULL( Country,' '))
from Employees
----------------------------------------------------------------
select SUM(quantity) as [Product Qty],ProductID
from [Order Details]
where ProductID!=23
group by ProductID
order by ProductID
----------------------------------------------------------------
select SUM(quantity) as total ,max(quantity) as MAX ,min(quantity) as MIN ,avg(quantity) as AVG ,ProductID
from [Order Details]
where ProductID!=23
group by ProductID
order by ProductID
----------------------------------------------------------------
select SUM(quantity) as total ,ProductID
from [Order Details]
where ProductID!=23
group by ProductID
having SUM(quantity)>1000
order by ProductID
-----------------------------------------------------------------
--test this 
select quantity 
from [Order Details]
having Quantity >100 
-------------------------------------------------------------
select SUM(quantity)
from [Order Details]
having SUM(quantity)>1000
--================================================================================================
 --************************************************************************************************
 --                                 Using Aggregate Functions
 --************************************************************************************************
-------------------------------------------------------------------------------------------------------------
-- The CUBE and ROLLUP operators are useful in generating reports that contain subtotals and totals. 
-- There are extensions of the GROUP BY clause.
-------------------------------------------------------------------------------------------------------------
--– CUBE generates a result set that shows aggregates for all combinations of values in the selected columns.
--– ROLLUP generates a result set that shows aggregates for a hierarchy of values in the selected columns.
-------------------------------------------------------------------------------------------------------------
--Rollup
select SUM(quantity),ProductID,OrderID
from [Order Details]
group by ProductID,OrderID

select SUM(quantity),ProductID,OrderID
from [Order Details]
group by rollup( ProductID,OrderID)

-- test this 
select SUM(quantity),ProductID,OrderID
from [Order Details]
group by rollup( ProductID,OrderID)
having OrderID is null 
-------------------------------------------------------------
--Cube
select SUM(quantity),ProductID,OrderID
from [Order Details]
group by cube( ProductID,OrderID)
 

select SUM(quantity),ProductID,OrderID
from [Order Details]
group by cube( ProductID,OrderID)
having ProductID is null 
-------------------------------------------------------------
--Window Functions
select Categoryid ,productname,unitprice
from Products

select Max (unitprice) from products
---????
select *, Max (unitprice) from products  ---??
--select *,Max (unitprice) from products order by * --Error

select * ,rank()over(order by unitprice desc) from products 
------------------------------------------------------------------------------------------------------
select categoryid,productname,unitprice,RANK()over(partition by categoryid order by unitprice)
from Products
------------------------------------------------------------------------------------------------------
select categoryid,productname,unitprice,dense_RANK()over(partition by categoryid order by unitprice)
from Products
-------------------------------------------------------------------------------------------------------
select categoryid,productname,unitprice,row_number()over(partition by categoryid order by unitprice)
from Products
-------------------------------------------------------------------------------------------------------
select categoryid,productname,unitprice,ntile(4)over(partition by categoryid order by unitprice)
from Products
-------------------------------------------------------------------------------------------------------
---- Join with Grouping 
------------------------------------------------------------------------------------
select mgr.FirstName as manager , emp.FirstName as employee
from Employees as emp left outer join Employees as mgr
on emp.ReportsTo=mgr.EmployeeID
-------------------------------------------------------------------------------------
select mgr.FirstName as manager,COUNT(emp.firstname) [number of employees]
from Employees as emp left outer join Employees as mgr
on emp.ReportsTo=mgr.EmployeeID
group by mgr.FirstName
------------------------------------------------------------
select mgr.FirstName as manager,COUNT(emp.firstname)
from Employees as emp left outer join Employees as mgr
on emp.ReportsTo=mgr.EmployeeID
group by mgr.FirstName
-----------------------------------------------------------------------------------------


