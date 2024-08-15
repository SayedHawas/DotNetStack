--Task1 (Order By)
-------------------
--Table :- Orders
------------------
--Show Columns 
---------------
--- CustomerID  
--- EmployeeID
--- OrderYear = Year of OrderDate

--Order OrderYear (Z-A)
---------------------------------------
--Result = 3 Columns , 653 Rows
----------------------------------------
--========================================

--Task2 (Top) 
-------------

--At The Task1 Result Show Only :- First 3 Rows

--===============================================

--Task3 (OFFSET FETCH) 
-------------

--At The Task1 Result Skip First 10 Rows Then Show The Next 5 Rows 

--===============================================

--Ans
-- Task 1 (Order By)
----------------------

SELECT DISTINCT
       CustomerID ,
       EmployeeID,
	   YEAR(OrderDate) AS OrderYear
FROM   Orders
ORDER BY OrderYear DESC
GO

-------------------------------------

-- Task 2
------------

SELECT DISTINCT
       TOP 5
       CustomerID ,
       EmployeeID,
	   YEAR(OrderDate) AS OrderYear
FROM   Orders
ORDER BY OrderYear DESC
GO

--------------------------------------

SELECT DISTINCT
       CustomerID ,
       EmployeeID,
	   YEAR(OrderDate) AS OrderYear
FROM   Orders
ORDER BY OrderYear DESC
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY
GO

