--======================================================================================
									--Module 10
									--Using Subqueries
--======================================================================================
--using Sub Query 
--simple subquery
-- 1.Writing Basic Subqueries
-- --------------------------
/*
-- each query that you have written has been a single self-contained statement. SQL Server also provides the 
ability to nest one query within another—in other words, to form subqueries. In a subquery, the results of 
the inner query (subquery) are returned to the outer query. 
-- A subquery is a query that is nested inside a SELECT, INSERT, UPDATE, 
   or DELETE statement, or inside another subquery that can be used 
   anywhere an expression is allowed.
  
-- Why to Use Subqueries?
   - To break down a complex query into a series of logical steps
   - To answer a query that relies on the results of another query

-- Why to Use Joins Rather Than Subqueries?
   - SQL Server executes joins faster than subqueries


 -- Subqueries can be self-contained or correlated
       1-Self-contained subqueries have no dependency on outer query
       2-Correlated subqueries depend on values from outer query
*/

-- Using Subquery as Expression
-- ----------------------------
------------------------------------------------------------
SELECT custid, orderid
FROM Sales.orders
WHERE custid IN (SELECT custid FROM Sales.Customers WHERE country ='Mexico')
-------------- same ex; by inner join-------------------
SELECT c.custid, o.orderid
FROM Sales.Customers AS c JOIN Sales.Orders AS o
ON c.custid = o.custid
WHERE c.country = 'Mexico'
-------------------------------------------------------------
/*
- A subquery is also called an inner query or inner select, 
  while the statement containing a subquery is also called an 
  outer query or outer select.

-- Many Transact-SQL statements that include subqueries can be  formulated as joins
-- Joins better performance than subquery but generate the same result

*/
-- Scalar & Tabular Subqueries (Single Row subQ , Multiple Row SubQ)
-- ---------------------------  ----------------------------------
-- A scalar subquery is a subquery that returns a single row of data,
-- while a tabular subquery is one that returns multiple rows
-- If inner query returns an empty set, result is converted to NULL
------------------------------------------------------------------------------
-- scalar
select top 1 * from orders order by OrderID desc

-- tabular
Use Northwind
select  c.CustomerID
from Customers c
where CustomerID IN (select CustomerID from orders)

-- SELECT statement built using a subquery:
-- ----------------------------------------
SELECT  e.EmployeeID
FROM    Employees e
WHERE   e.EmployeeID IN(SELECT o.EmployeeID FROM   Orders o)

-- SELECT statement built using a join that returns the same result set:
-- --------------------------------------------------------------------
SELECT  distinct e.EmployeeID
FROM    Employees e join Orders o
ON e.EmployeeID = o.EmployeeID
/*
-- Notes :
-----------
- The SELECT query of a subquery is always enclosed in parentheses. 
- It cannot include a COMPUTE , and may only include an ORDER BY clause when a TOP clause is also specified.
- It can include An optional GROUP BY clause,An optional WHERE clause  
*/
--==================================================================================
-- Using the ANY, ALL, and SOME Operators
-- --------------------------------------
SELECT  c.CustomerID
FROM    Customers c
WHERE   c.CustomerID in(SELECT o.CustomerID FROM   Orders o)
/*
-- WHERE expression comparison_operator [ANY | ALL] (subquery)
  -- Using the > comparison operator, 
  --   >ALL means greater than every value (greater than the maximum value):EX: >ALL (1, 2, 3) means greater than 3.
  --   <ALL Means less than the minimum.
  --   >ANY means greater than at least one of the values in the list of values returned by the subquery :
  --   >ANY (1, 2, 3) means greater than 1 (minimum).
  --   <ANY means less than the maximum.
  --   =ANY operator is equivalent to IN.
  --   <>ANY operator means not = a, or not = b, or not = c.
  --   NOT IN means not = a, and not = b, and not = c.
  --   <>ALL means the same as NOT IN     .          
*/
-----------------------------------------------------------------------------------------------------
use Northwind
select *from [Order Details] where ProductID = 23 ;

select orderid,customerid from orders as or1
where 20<(select quantity from [order details] as od
where or1.OrderID=od.OrderID and od.ProductID=23)
---------------------------------------------------------
select ProductName,UnitPrice,SupplierID
from Products 
where UnitPrice > (select AVG(unitprice) from Products)
-----------------------------------------------------------
use Northwind
select ProductName,UnitPrice,SupplierID
from Products 
where SupplierID in (select SupplierID from Products where ProductID>50)
------------------------------------------------------------
select ProductName,UnitPrice
from Products 
where CategoryID in (select CategoryID from Categories where CategoryName='Dairy Products')
------------------------------------------------------------
select ProductName,UnitPrice,(select max(UnitPrice) from Products) as maximum,UnitPrice-(select min(UnitPrice) from Products) as Diff
from Products 
where productID=1
------------------------------------------------------------
select  sum(unitprice),OrderID 
from [Order Details]  
group by OrderID 
------------------------------------------------------------
select productname,UnitPrice
from Products
where UnitPrice !=all(select  sum(unitprice) from [Order Details]  group by OrderID )
------------------------------------------------------------
select productname,UnitPrice
from Products
where UnitPrice >=all(select  sum(unitprice) from [Order Details] where OrderID=10923  group by OrderID )
------------------------------------------------------------
select productname,UnitPrice
from Products
where UnitPrice <=any(select  sum(unitprice) from [Order Details] where OrderID=10923  group by OrderID )
------------------------------------------------------------
--Key words All Any 
 -- Lets create two tables and inser values
CREATE TABLE Table1 (Id int)
GO
INSERT INTO Table1 VALUES (1), (2), (3), (4), (5)

CREATE TABLE Table2 (Id int)
GO
INSERT INTO Table2  VALUES (1), (3), (5)

SELECT Id FROM Table1 
WHERE Id =ANY (SELECT Id FROM Table2)

SELECT Id FROM Table1 
WHERE Id =ALL (SELECT Id FROM Table2)
 
 SELECT Id FROM Table1 
 WHERE Id >=ANY (SELECT Id FROM Table2)

 SELECT Id FROM Table1 
 WHERE Id >=ALL (SELECT Id FROM Table2)

SELECT Id FROM Table1 
 WHERE Id !=ALL (SELECT Id FROM Table2)
--------------------------------------------------------------------------------
 select id from table2 where exists(select Id from table1)
--=====================  exists  ===========================
select ProductName
from Products
where exists (select * from Categories where Categories.CategoryID=Products.CategoryID and CategoryName='Dairy Products')

------------------------------------------------------------
-- Using Subquery as Expression
-- ----------------------------

USE Pubs
SELECT title, price
FROM titles
WHERE price = (SELECT MAX(price) FROM titles)


USE Pubs
SELECT title, price,type
     ,( SELECT AVG(price) FROM titles) AS average
     ,price-(SELECT AVG(price) FROM titles) AS difference
 FROM titles
 WHERE type='popular_comp'

GO





-- scalar
USE Pubs
SELECT title, price
FROM titles
WHERE price = (SELECT MAX(price) FROM titles)


-- tabular
Use Northwind
select  c.CustomerID
from Customers c
where CustomerID IN (select CustomerID from orders)



SELECT  e.EmployeeID
FROM    Employees e
WHERE   e.EmployeeID IN
             (SELECT o.EmployeeID
              FROM   Orders o)



SELECT  distinct e.EmployeeID
FROM    Employees e join Orders o
ON e.EmployeeID = o.EmployeeID




-- Using the ANY, ALL, and SOME Operators
-- --------------------------------------
SELECT  c.CustomerID
FROM    Customers c
WHERE   c.CustomerID in               -- the same result with =Any ,=Some
             (SELECT o.CustomerID
              FROM   Orders o)

/*
-- WHERE expression comparison_operator [ANY | ALL] (subquery)
  -- Using the > comparison operator, 
  --   >ALL means greater than every value (greater than the maximum value):
       EX: >ALL (1, 2, 3) means greater than 3.
  --   <ALL Means less than the minimum.
  
  --   >ANY means greater than at least one of the values in the list
        of values returned by the subquery :
  --   >ANY (1, 2, 3) means greater than 1 (minimum).
  --   <ANY means less than the maximum.
  
  --   =ANY operator is equivalent to IN.
  
  --   <>ANY operator means not = a, or not = b, or not = c.
  --   NOT IN means not = a, and not = b, and not = c.
  --   <>ALL means the same as NOT IN     .          

*/


SELECT  c.CustomerID
FROM    Customers c
WHERE   c.CustomerID <> ALL            -- = Not In
             (SELECT o.CustomerID
              FROM   Orders o)
                            
                
Create  Table Depts
(empid int,jobid varchar(50),salary int)

insert Depts values
                                              
        (103, 'IT_PROG',          9000),                                              
        (104, 'IT_PROG',          6000),                                              
        (105, 'IT_PROG',          4800),                                               
        (106, 'IT_PROG',          4800),                                              
        (107, 'IT_PROG',          4200),                                               
        (108, 'FI_MGR' ,         12000),                                              
        (109, 'FI_ACCOUNT',       9000),                                              
        (110, 'FI_ACCOUNT',      8200),                                                                                                                                  
        (122, 'ST_MAN'    ,       7900),                                                                                           
        (123, 'ST_MAN'    ,      6500),                                              
        (124, 'ST_MAN'    ,       5800),                                              
        (143, 'ST_CLERK'  ,      2600),                                             
        (144, 'ST_CLERK'   ,      2500),                                                                                            
        (145, 'SA_MAN'     ,     14000),                                              
        (146, 'SA_MAN'     ,    13500),                                             
        (147, 'SA_MAN'     ,     12000),                                             
        (148, 'SA_MAN'     ,     11000),                                              
        (159, 'SA_REP'      ,     8000),                                              
        (160, 'SA_REP'      ,     7500),                                              
        (161, 'SA_REP'      ,     7000),                                               
        (162, 'SA_REP'       ,   10500),                                               
        (163, 'SA_REP'      ,     9500),                                               
        (171, 'SA_REP'      ,     7400),                                               
        (187, 'SH_CLERK'    ,     3000),                                               
        (188, 'SH_CLERK'    ,     3800),                                                                                             
        (189, 'SH_CLERK'    ,     3600)                                               
       


SELECT empid, JOBID, SALARY
FROM   Depts
WHERE  SALARY < ANY
                    (SELECT SALARY
                     FROM Depts
                     WHERE JOBID = 'IT_PROG')          -- 9000, 6000,4800,4200

AND JOBID <> 'IT_PROG'                               -- 9000(IT_PROG is the max)
                     


SELECT empid, JOBID, SALARY
FROM   Depts
WHERE  SALARY < ALL
                    (SELECT SALARY
                     FROM   Depts
                     WHERE  JOBID = 'IT_PROG')    -- 9000, 6000,4800,4200

AND JOBID <> 'IT_PROG'




--======================================================================================================

-- 2.Writing Correlated Subqueries
-- -------------------------------
/*
-- Many queries can be evaluated by executing the subquery once and 
   substituting the resulting value or values into the WHERE clause of 
   the outer query, turning the subquery into a correlated, or repeating, 
   subquery.
-- This means that the subquery is executed repeatedly, 
   once for each row that might be selected by the outer query.
-- correlated subquery cannot stand alone, as it depends on the outer query
-- A correlated subquery is an inner subquery whose information is referenced by the  main,outerquery
-- RETURNS A MORE THAN ONE ROW
-- use a multiple-row operator (IN,not in,ALL,ANY,between)    IN ---> =ANY
-- Behaves as if inner query is executed once per outer row

          
*/


--EX:
----
SELECT  e.employeeid
FROM    employees e
WHERE   e.employeeid IN
  (SELECT    o.employeeid
             FROM   orders o
   WHERE     o.employeeid =  e.employeeid)



--EX:
-----
USE northwind
SELECT orderid, customerid 
FROM orders AS o 
WHERE 20 < (SELECT quantity
		     FROM [order details] AS od
             WHERE o.orderid = od.orderid
             AND  od.productid = 23)
GO


--test
select quantity from  [order details]
where quantity >20 and productid=23

--===========================================================================================
                    