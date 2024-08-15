/*
1) Task :-
----------
   - Using Northwind Sample Database.
   - Using Table "Order Details".

-----------------------------------------------------------------------------------------

   - Display Unique OrderID and Make it Display with Name "ID".
   - Display Column "TotalUnitsPrice" and Make it Computed from UnitPrice and Quantity.
   - Display Table Name From "Order Details" to "OD".


Result
-------
Number of Shown Columns Should be ( 2 )   =  ID , TotalUnitPrice 
Number of Shown Rows Should be ( 2150 )
-----------------------------------------------------------------------

2)  -- select Without Duplication country & City From Employees table   

3)  use case to:- 
    Create column  "Price Range" to Show the data 
	unitPrice =  0 THEN 'item - not for resale'
	unitPrice < 50 THEN 'Under $50'
	unitPrice >= 50 and unitPrice < 250 THEN 'Under $250'
	unitPrice >= 250 and unitPrice < 1000 THEN 'Under $1000'
	'Over $1000'


4)Show :-
---------
Columns
--------
1) CustomerID
2) CompanyName
3) ContactName
4) New Column Name 'Location' = Address + City + Region + Country)
*/