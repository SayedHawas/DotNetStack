/*
 Module 13
 Using Window Ranking, Offset, and Aggregate Functions
--------------------------------------------------------
 Lessons :-
--------------
               1) Creating Windows with OVER.
			   2) Exploring Window Functions.
---------------------------------------------------------------------------------------------------
-- Lesson 1) Creating Windows with OVER :-
------------------------------------------
A) SQL Windowing
-----------------
	            - Windows extend T-SQL's set-based approach.
				- Windows allow you to specify an order as part of a calculation, 
				          without regard to order of input or final output order
			    - Windows allow partitioning and framing of rows to support functions.
				- Window functions can simplify queries that need to find running totals, moving averages, or gaps in data.
--------------------------------------------------------------------------------------
B) Using OVER () 
-----------------
	           - OVER defines a window, or set, of rows to be used by a window function, including any ordering.
			   - With a partition clause, OVER clause restricts the set of rows to those with the same values in the partitioning elements
			   - By itself, OVER() is unrestricted and includes all rows.
			   - Multiple OVER clauses can be used in a single query, each with its own partitioning and ordering, if needed.
	Syntax :-
	----------
	OVER ( [ <PARTITION BY clause> ] 
	       [ <ORDER BY clause> ] 
	       [ <ROWS or RANGE clause> ] 
	     ) 
------------------------------------------------------------------------------------
C) Partitioning Windows
-------------------------
		       - Partitioning limits a set to rows with same value in the partitioning column.
			   - Use PARTITION BY in the OVER() clause
               - Without a PARTITION BY clause defined, OVER() creates a single partition of all rows
*/
-- PARTITION BY Example :-
SELECT ProductID,OrderID ,Quantity, SUM(Quantity) OVER ( PARTITION BY ProductID ) AS Total_Quantity_For_Product
FROM  [Order Details]
GO
/*----------------------------------------------------------------------------------
D) Ordering and Framing :-
-----------------------------
    - Window framing allows you to set start and end boundaries within a window partition.
	- UNBOUNDED means go all the way to boundary in direction specified by PRECEDING or FOLLOWING (start or end).
	- CURRENT ROW indicates start or end at current row in partition.
	- ROWS BETWEEN allows you to define a range of rows between two points.
	- Window ordering provides a context to the frame :- 
	        A) Sorting by an attribute enables meaningful position of a boundary
            B) Without ordering, "start at first row" is not useful because a set has no order
*/

SELECT ProductID,OrderID,Quantity,
       SUM(Quantity) OVER (PARTITION BY ProductID ORDER BY Quantity ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningQty 
FROM [Order Details]
GO
---------------------------------------------------------------------------------------------------
/*
-- Lesson 2) Exploring Window Functions :-
-------------------------------------------
           - A window function is a function applied to a window, or set, of rows.
		   - Window functions include aggregate, ranking, distribution, and offset functions
		   - Window functions depend on set created by OVER()
*/

-- Window Aggregate Functions
SELECT   ProductID,Quantity,
		 SUM(Quantity) OVER (PARTITION BY ProductID) AS "Total Quantity For Product",
         AVG(Quantity) OVER (PARTITION BY ProductID) AS "Average Quantity For Product"   
FROM   [Order Details]

-- Window Ranking Function
-- With Over 
SELECT   ProductID,UnitPrice,
         ROW_NUMBER() OVER (ORDER BY UnitPrice) AS "Row Number",
	     RANK() OVER (ORDER BY UnitPrice) AS Rank,
	     DENSE_RANK() OVER (ORDER BY UnitPrice) AS "Dense Rank"
FROM   Products

-- Window Ranking Functions
-- With OVER AND Partition BY
SELECT   ProductID, UnitPrice,
		 ROW_NUMBER() OVER (ORDER BY ProductID) AS "Row Number",
         ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY ProductID) AS "Row Number Partition"   
FROM   [Order Details]

--==================================================================================================
/*
*) Window offset functions allow comparisons between rows in a set without the need for a self-join
*) Offset functions operate on a position relative to the current row, or to the start or end of the window frame

LAG:-
-----
Returns an expression from a previous row that is a defined offset from the current row. 
Returns NULL if no row at specified position.


LEAD:-
------
Returns an expression from a later row that is a defined offset from the current row. 
Returns NULL if no row at specified position.



FIRST_VALUE:-
-------------
Returns the first value in the current window frame. 
Requires window ordering to be meaningful.
Introduced in SQL Server 2012 
Order By         Required
Partition By     Optional

LAST_VALUE:-
------------
Returns the last value in the current window frame. 
Requires window ordering to be meaningful.


*/
--First_Value 
select * from Products
select ProductId , ProductName , Unitprice from Products  

select ProductId , ProductName , Unitprice,
FIRST_VALUE(unitprice) over(order by unitprice) as FValue 
from Products  

--using Script SmartDay13DB
--using Script SmartDay13DB
----------------------------------------------------

Create database WindowOffsetFunctionsDB
go
USE WindowOffsetFunctionsDB
GO


CREATE TABLE SmartOrders(
	OrderID  int primary Key  identity,
	OrderDate Date NOT NULL,
	productId int NOT NULL,
	UnitPrice decimal(9,2) NOT NULL
	
) 
INSERT SmartOrders (OrderDate , productId, UnitPrice) VALUES ('1-1-2018',1,100),
                                                             ('1-2-2018',1,100),
															 ('1-3-2018',1,100),
															 ('1-4-2018',1,100),
															 ('1-5-2018',1,100),
															 ('1-6-2018',1,110),
															 ('1-7-2018',1,110),
															 ('1-8-2018',1,110),
															 ('1-9-2018',1,110),
															 ('1-10-2018',1,110),
															 ('1-11-2018',1,115),
															 ('1-12-2018',1,115),
															 ('1-13-2018',1,115),
															 ('1-14-2018',1,115),
															 ('1-15-2018',1,115),
															 ('1-16-2018',2,200),
															 ('1-16-2018',2,200),
															 ('1-17-2018',2,200),
															 ('1-18-2018',2,220),
															 ('1-19-2018',2,220),
															 ('1-20-2018',2,230),
															 ('1-21-2018',2,230)

select * from smartOrders

select * from smartOrders where productId = 1

 
select OrderID ,orderdate, ProductID , Unitprice,
FIRST_VALUE(unitprice) over(order by unitprice) as FValue 
from smartOrders
where productID =1



select OrderID ,orderdate, ProductID , Unitprice,
last_value(unitprice) over(order by unitprice) as LValue 
from smartOrders
where productID =1

--Rate Unitprice in INCR
select count (OrderID), ProductID , Unitprice,
last_value(unitprice) over( order by unitprice ) as LValue 
from smartOrders
where productID =1
group by  ProductID , Unitprice

--previous 
SELECT OrderID ,orderdate, ProductID , Unitprice,
   LAG (Unitprice, 1,0) OVER (PARTITION BY productID  ORDER BY orderID) AS ProviousPrice
from smartOrders
where productID=1;



---Next 
SELECT OrderID ,orderdate, ProductID , Unitprice,
   LEAD (Unitprice, 1,0) OVER (PARTITION BY productID ORDER BY orderID) AS nextPrice
from smartOrders
where productID=1;



SELECT  orderdate,Nxt_Price, Prv_Price 
FROM
(
SELECT OrderID ,orderdate, ProductID , Unitprice,
   LAG (Unitprice, 1,0) OVER (PARTITION BY productID  ORDER BY orderID) as Prv_Price,
   LEAD (Unitprice, 1,0) OVER (PARTITION BY productID ORDER BY orderID) as Nxt_Price
 from smartOrders where productID=1)as src
 where Nxt_Price <> Unitprice

--=================================================================================================