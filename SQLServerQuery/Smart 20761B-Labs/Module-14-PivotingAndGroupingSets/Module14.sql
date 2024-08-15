/*
Module 14 
Pivoting and Grouping Sets
---------------------------
-- lessons :-
--------------
	      -1 Writing Queries with PIVOT and UNPIVOT. 
          -2 Working with Grouping Sets.
---------------------------------------------------------------------------------------------
-- Lesson 1) PIVOT & UNPIVOT :- 
---------------------------------
  -- PIVOT :-
  ------------
           - Pivoting data is rotating data from a rows-based orientation to a columns-based orientation.
		   - Pivoting includes three phases :-
                       1) Grouping    :- Determines from FROM clause which element gets a row in the result set 
                       2) Spreading   :- Provides the distinct values to be pivoted across
                       3) Aggregation :- Performs an aggregation function (such as SUM,Count,etc..)
  -- UNPIVOT :-
  -------------
			- Unpivoting data is the logical reverse of pivoting data
			- Instead of turning rows into columns, unpivot turns columns into rows.
			- This is a technique useful in taking data that has already been pivoted.
			- Unpivoting includes three elements :-
                          1) Source columns to be unpivoted
                          2) Name to be assigned to new values column
                          3) Name to be assigned to names columns
			- Unpivoting does not restore the original data. 
			- Detail-level data was lost during the aggregation process in the original pivot.
			- UNPIVOT has no ability to allocate values to return to original detail values. 
*/
-- Example1 
-------------
use tempdb

create table t1 (CustomerName Nvarchar(10),
                 ProductName nvarchar(10),
				 Price decimal(9,2));

insert into t1 values ('Ahmed','TShirt',200),
('yasser','TShirt',100),('Ahmed','Shoes',300),
('yasser','Latop',4000),('Ahmed','PC',3200),
('aya','TShirt',300),('aya','latop',5200)

select * from t1

select customerName ,Tshirt , Latop
from (select customerName,ProductName,price from t1) as d
pivot
(
sum(price) for productname in(Tshirt , Latop) 
)as piv

-----------------------------------------------------------------------------------
-- Example2
---------------
Use Northwind 
select * from orders
select c.CategoryName,od.Quantity,year(o.OrderDate) as OrderYear into p1
from [Order Details] as od inner join Products as p 
on od.ProductID = p.ProductID inner join Categories as c 
on p.CategoryID = c.CategoryID inner join Orders as o 
on od.OrderID =o.OrderID

select * from p1

select Categoryname ,[1996],[1997],[1998] into p2
from (select Categoryname,quantity ,orderYear from p1)as d
pivot (sum(quantity) for orderYear in ([1996],[1997],[1998]) ) as pvt
order by Categoryname

select * from p2

select Categoryname,qty,orderyear
from p2
unpivot (qty for orderyear in ([1996],[1997],[1998])) as u

--------------------------------------------------------------------------------------------------------
-- Example 2) Pivot
-- For Each Employee ( Count Orders For Each Year )
WITH CTE
AS (SELECT EmployeeID,OrderID,YEAR(OrderDate) AS OrderYear FROM Orders) 
SELECT EmployeeID , [1996], [1997],[1998]
FROM   CTE
PIVOT(Count(OrderID) FOR OrderYear IN ([1996], [1997],[1998]) )AS PIVOTT
ORDER BY EmployeeID
GO

-- Example 2) Pivot
-- For Each Year ( Count Orders For Each Employee)
WITH CTE
AS 
(SELECT OrderID,EmployeeID,YEAR(OrderDate) AS OrderYear FROM  Orders)
SELECT OrderYear ,[1],[2],[3],[4],[5],[6],[7],[8],[9] FROM CTE
PIVOT ( COUNT(OrderID) FOR EmployeeID IN ([1],[2],[3],[4],[5],[6],[7],[8],[9]) ) AS PIV
GO

-- Example 3) UNPIVOT
-- Lets Make Result From Example 1 Physical Table
-- Using SELECT xx xx xx Into 
WITH CTE
AS (SELECT EmployeeID,OrderID,YEAR(OrderDate) AS OrderYear FROM Orders) 
SELECT EmployeeID , [1996], [1997],[1998] INTO TBL1001
FROM   CTE
PIVOT(Count(OrderID) FOR OrderYear IN ([1996], [1997],[1998]) )AS PIVOTT
ORDER BY EmployeeID
GO

-- Show New TABLE
SELECT * FROM TBL1001

-- Using UNPIVOT
SELECT EmployeeID,OrderYear,TotalOrders
FROM   TBL1001
UNPIVOT ( TotalOrders FOR OrderYear IN ([1996], [1997],[1998])) AS UP
Order BY OrderYear,EmployeeID
GO
---------------------------------------------------------------------------------------------
/*
-- Lesson 2) Grouping Sets :-
------------------------------
   - Grouping Sets :-
   -------------------
     - GROUPING SETS subclause builds on T-SQL GROUP BY clause.
	 - Allows multiple groupings to be defined in same query.
	 - Alternative to use of UNION ALL to combine multiple outputs (each with different GROUP BY) into one result set.
-- Syntax
----------
SELECT <column list with aggregate(s)>
FROM <source>
GROUP BY 
GROUPING SETS(
	(<column_name>),--one or more columns
	(<column_name>),--one or more columns
	() -- empty parentheses if aggregating all rows
)
*/-- Examples
---------------
use tempdb
go
-- Creating Sample Table
CREATE TABLE A101(ID INT,Name  VARCHAR(50),Country VARCHAR(50),Gender VARCHAR(50),Salary SmallMoney)
GO
-- Inserting Data
INSERT A101 VALUES (1,'Ali','Egypt','Male','1200'),
                   (2,'Jon','USA','Male','4500'),
	               (3,'Sara','Egypt','Female','1200'),
	               (4,'Lara','USA','Female','4000'),
	               (5,'Mohamed','UK','Male','5000'),
	               (6,'Katy','UK','Female','2000'),
	               (7,'Samy','Egypt','Male','80000')
GO
-- Display Table
SELECT * FROM A101
GO
-- 1) Grouping by Country & Gender
SELECT Country,Gender,SUM(Salary) AS TotalSalary 
FROM A101
GROUP BY Country , Gender
GO
-- 2) Grouping by Country 
SELECT Country,SUM(Salary) AS TotalSalary 
FROM A101
GROUP BY Country 
GO
-- 3) Grouping by Gender
SELECT Gender,SUM(Salary) AS TotalSalary 
FROM A101
GROUP BY  Gender
GO
-- 4)  Total Salary
SELECT SUM(Salary) AS TotalSalary 
FROM A101
GO
---------------------------------------
-- All 4 Result in 1 Report
-- Using UNION ALL
SELECT Country,Gender,SUM(Salary) AS TotalSalary 
FROM A101
GROUP BY Country , Gender
UNION ALL
SELECT Country,NULL,SUM(Salary) AS TotalSalary 
FROM A101
GROUP BY Country
UNION ALL
SELECT NULL,Gender,SUM(Salary) AS TotalSalary 
FROM A101
GROUP BY Gender
UNION ALL
SELECT NULL,NULL,SUM(Salary) AS TotalSalary 
FROM A101
GO

-- Same Result With GROUPING SETS
-- better Performance and Readability
SELECT Country,Gender,SUM(Salary) AS TotalSalary 
FROM A101
GROUP BY GROUPING SETS ((Country,Gender),  (Country),(Gender),())
GO

SELECT Country,Gender,SUM(Salary) AS TotalSalary 
FROM A101
GROUP BY cube(Country,Gender)
GO

--Grouping_ID

select Grouping_ID(Country) as C_Group,Grouping_ID(Gender) as G_Group,SUM(Salary) AS TotalSalary ,Country ,Gender
from A101
group by cube(Country,Gender)


select Grouping_ID(Country) as C_Group,Grouping_ID(Gender) as G_Group,SUM(Salary) AS TotalSalary ,Country ,Gender
from A101
group by cube(Country,Gender)
--having Grouping_ID(Gender) =1 
--having Grouping_ID(Country) =1
having Grouping_ID(Gender) =1  and Grouping_ID(Country) =1
--===========================================================================================================