--Module 12
--Using Set Operators 
-----------------------------
-- Combining Result Sets by Using the UNION Operator
-- --------------------------------------------------
/*
Each Query Must Have:
--------------------
* Similar data types
* Same number of columns 
* Same column order in select list
* By default, the UNION operator removes duplicate rows 
  from the result set. 
  If you use ALL, all rows are included in the results and 
  duplicates are not removed.
* Any number of UNION operators can appear in a Transact-SQL statement
*/

Create table TBL1(id  int);
Create table TBL2(id2 int);

Insert into TBL1 values(1),(2),(10),(20),(NULL);
Insert into TBL2 values(10),(10),(20),(30),(NULL);



Select * From tbl1
UNION                    -- All
Select * From tbl2;
--=======================================================================================================
-- Limiting Result Sets by Using the EXCEPT and INTERSECT Operators
-- ---------------------------------------------------------------- 
/*
-- EXCEPT returns any distinct values from the left query that are not 
   also found on the right query
-- INTERSECT returns any distinct values that are returned by both 
   the query on the left and right sides of the INTERSECT operand
   -- Conditions :
     --1.The number and the order of the columns must be the same in all queries.
     --2.The data types must be compatible.
     --3.The column names of the result set that are returned by EXCEPT or 
         INTERSECT are the same names as those returned by the 
         query on the left side of the operand.
 */
Select * From tbl1
EXCEPT
Select * From tbl2;

Select * From tbl1
INTERSECT 
Select * From tbl2;
--------------------------------------------------------------------------------
--union Like AND
-- only ---  = distinct
SELECT City FROM Customers
UNION
SELECT City FROM Suppliers
ORDER BY City;
---------------------------------------
--- only ---- all 
SELECT City FROM Customers
UNION all 
SELECT City FROM Suppliers
ORDER BY City;
---------------------------------------
select firstname+' '+lastname as [Full Name]
from employees
where title='Sales Representative'
union all
select contactname 
from customers
where contacttitle='Sales Representative'
------------------------------------------------------------
select firstname+' '+lastname as [Full Name]
from employees
union all
select contactname 
from customers
---------------------------------------------------------------------------------------------------
/* Lesson 2) Using EXCEPT and INTERSECT :-
------------------------------------- 
    - INTERSECT :- 
	              - Returns only distinct rows that appear in both result sets.
				  - Order in which sets are not matters.
	- EXCEPT  :-
	              - Returns only distinct rows that appear in the left set but not the right.
				  - Order in which sets are specified matters.
-- INTERSECT Syntax :-
-- <query_1> INTERSECT <query_2>
----------------------------------
-- EXCEPT Syntax :-
-- <query_1> EXCEPT <query_2>
----------------------------------
*/
-- INTERSECT Example :- 
-- Get Distinct Country in both Employees & Customers
SELECT Country FROM Employees 
INTERSECT
SELECT Country FROM Customers  
GO   


-- EXCEPT Example :- 
-- Get Distinct Country in Customers and Not in Employees
SELECT Country FROM Customers
EXCEPT
SELECT Country FROM Employees  
GO   

/*
 -- The Difference Between Set Operators and Joins:-
 -----------------------------------------------------
  UNION combines rows. In comparison, JOIN combines columns from different sources. 

        -------------------------------------------------------------------
		|		  ( Joins )              |        ( Set operators )       |
		|		 ===========             |       ===================      |
		-------------------------------------------------------------------
	    | A) Combine multiple tables     |  A) Combine multiple SELECTs   |
		-------------------------------------------------------------------
		| B) Performs a horizontal join  |  B) Performs avertical  join   |                       
		-------------------------------------------------------------------
*/
--================================================================================================================
/*
Lesson 3: Using APPLY
-----------------------
								Using the APPLY Operator
								The CROSS APPLY Operator
								The OUTER APPLY Operator
								CROSS APPLY and OUTER APPLY Features

APPLY is a table operator used in the FROM clause
Two forms—CROSS APPLY and OUTER APPLY
Operates on two input tables, referred to as left and right
Right table may be any table expression including 
a derived table or a table-valued function


											1-CROSS APPLY
											2-OUTER APPLY


SELECT <column_list>
FROM <left_table_source> AS <alias>
[CROSS]|[OUTER] APPLY 
    <right_table_source> AS <alias>;
*/
-----------------------------------------------------------------------
--Lab
Create DataBase CrossApplyDB
go 
use CrossApplyDB
go
Create table Departments (
Id int Primary key identity ,
Name nvarchar(50))
go
insert into Departments values ('IT' ),('Sales'),('HR');
go

Create table Employees (ID int Primary Key identity,
                        Name nvarchar(50),
						Gender Nvarchar(10),
						Salary decimal(9,2),
						DepartementID int Constraint FK_Depart foreign key References Departments (ID));  
go
insert into Employees values ('Ahmed','Male',3000,1),
                             ('retaj','Female',5000,3),
							 ('Mariam','Female',6000,1);
go
select * from Departments
select * from Employees
		  
select e.Name ,e.Salary ,e.Gender ,d.Name
from Departments as d inner join employees as e  
on d.Id = e.DepartementID;

select e.Name ,e.Salary ,e.Gender ,d.Name
from Departments as d left outer join employees as e  
on d.Id = e.DepartementID;

--Cross Apply , Outer Apply 
go
-- TVF 
Create function Fn_show (@id int) 
returns Table
as 
return (select * from employees where DepartementID = @id) 
go
select * from fn_show (1)
go
-------------------------
--Join between Function And table 
--Join
select e.Name ,e.Salary ,e.Gender ,d.Name
from Departments as d inner join fn_show(d.ID) as e  
on d.Id = e.DepartementID;

--Cross Apply  = Inner Join
select e.Name ,e.Salary ,e.Gender ,d.Name
from Departments as d Cross apply fn_show(d.ID) as e 
--on d.Id = e.DepartementID; 

--Outer Apply = Left outer join 
select e.Name ,e.Salary ,e.Gender ,d.Name
from Departments as d left outer join employees as e  
on d.Id = e.DepartementID;


select e.Name ,e.Salary ,e.Gender ,d.Name
from Departments as d outer apply fn_show(d.ID) as e 
-------------------------------------------------------------------------
--The CROSS APPLY Operator
SELECT o.orderid, o.orderdate,od.productid, od.unitprice, od.Quantity 
FROM  Orders AS o CROSS APPLY (SELECT ProductID, unitprice, Quantity 
FROM [Order Details] AS so 
WHERE so.orderid = o.orderid) AS od;


go
Create function funtest(@ID int)
returns table 
as 
return (SELECT ProductID, unitprice, Quantity 
FROM [Order Details] AS so 
WHERE so.orderid = @ID)
go


SELECT o.orderid, o.orderdate,od.productid, od.unitprice, od.Quantity 
FROM  Orders AS o Outer APPLY (select * from funtest(10284)) AS od;


--OUTER APPLY applies the right table source to each row in the left table source
--All rows from the left table source are returned—values from the right table source are returned where they exist, 
   -- otherwise NULL is returned
--Most LEFT OUTER JOIN statements can be rewritten as OUTER APPLY statements

SELECT DISTINCT s.country AS supplier_country, c.country as customer_country
FROM Suppliers AS s OUTER APPLY (SELECT country FROM Customers AS cu WHERE cu.country = s.country) AS c
ORDER BY supplier_country;
--===============================================================================================================================
