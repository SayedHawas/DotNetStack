--======================================================================================
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
/*
- A subquery is also called an inner query or inner select, 
  while the statement containing a subquery is also called an 
  outer query or outer select.

-- Many Transact-SQL statements that include subqueries can be  formulated as joins
-- Joins better performance than subquery but generate the same result

*/
--1-Self-contained subqueries
-- Scalar & Tabular Subqueries (Single Row subQ , Multiple Row SubQ)
-- Using Subquery 
-- ---------------
--Scalar
use Northwind
go
select * from Orders
select employeeId from Employees where firstName = 'Nancy'

select * from Orders 
where employeeId = (select employeeId 
                    from Employees 
					where firstName = 'Nancy')

 
-- scalar
select top(1)* from orders  
---------------------------------------------------------
--Muilt Values 
select * from customers 

select * from customers where country = 'Mexico'

select * from orders where customerId in(
select customerID from customers where country = 'Mexico' )
-------------------------------------------------------------------------------------------------------------
/*
-- Notes :
-----------
- The SELECT query of a subquery is always enclosed in parentheses. 
- It cannot include a COMPUTE , and may only include an ORDER BY clause when a TOP clause is also specified.
- It can include An optional GROUP BY clause,An optional WHERE clause  
*/
--==============================================================================================================
--2-Correlated subqueries
select orderId, orderdate , employeeId 
from orders as o1
where orderdate = (select max (orderdate)from orders as o2
                   where o2.EmployeeID = o1.EmployeeID)
order by employeeId



--With Group By 
select count (orderId) , orderdate , employeeId 
from orders as o1
where orderdate = (select max (orderdate)from orders as o2
                   where o2.EmployeeID = o1.EmployeeID)
Group by orderdate , employeeId 
order by employeeId

--========================================================================================================================
-- EXISTS

select customerId , companyname 
from customers as c 
where exists (select * from orders as o where o.customerId = c.customerID)  

select customerId , companyname 
from customers as c 
where not exists (select * from orders as o where o.customerId = c.customerID)  










