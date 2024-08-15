--Task
------------------
--Tables :- Employees , Order Details , Orders   'Inner Join'
--------------------------------------------------------------
--Show :-
----------
--Columns Names
---------------
--1) EmployeeID.
--2) EmployeeFullName = FirstName , LastName
--3) EmployeeContact  = HomePhone.
--4) EmployeeFullAddress = Address , City , Region (if null replace with 'NA') ,Country .
--5) AllOrders = Aggregation
--6) OrderYear = OrderDate
--7) Total_Gained_Money = ( Quantity * Unitprice * (1-Discound) ) 


---- EmployeeID not = 1 or 2 or 3 or 6 or 9

---- Group By EmployeeID , OrderYear   ( Remember Any Column in Select Must be in Group BY unless Aggregation Function )

---- Order with column Number 7 = All_Gained_Money  (Z-A)
---- Show Top 1 Row .


--Result :- 
--           1 Row ,
--           7 Columns

--Thanks :)
-------------------------------------------------------------------------------------------------
-- Task Answer
----------------
use Northwind
go
SELECT 
       E.EmployeeID, 
	   CONCAT (E.FirstName , ' ' , E.Lastname) AS EmployeeName,
	   E.HomePhone AS EmployeeContact,
	   CONCAT (E.Address , ' / ' ,E.City, ' / ', COALESCE(E.Region,'NA'), ' / ' ,E.Country ) AS CompanyFullAddress,
       COUNT(O.OrderID) AS AllOrders,
       YEAR(O.OrderDate) AS OrderYear,
	   SUM(OD.Quantity * OD.UnitPrice * (1-OD.Discount)) AS All_Gained_Money
FROM   [Order Details] AS OD 
JOIN   Orders AS O
ON     OD.OrderID = O.OrderID
JOIN   Employees AS E
ON     E.EmployeeID = O.EmployeeID
WHERE  O.EmployeeID NOT IN (1,2,3,6,9)
GROUP  BY YEAR(O.OrderDate),
          E.EmployeeID,
		  CONCAT (E.FirstName , ' ' , E.Lastname) ,
		  E.HomePhone,
		  CONCAT (E.Address , ' / ' ,E.City, ' / ', COALESCE(E.Region,'NA'), ' / ' ,E.Country ) 
ORDER BY All_Gained_Money DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY
GO