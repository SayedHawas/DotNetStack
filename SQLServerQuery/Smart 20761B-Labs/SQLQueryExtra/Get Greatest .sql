--How to get Greatest unitPrice Of Products 
------------------------------------------ 
 CREATE TABLE ProductsTb(
	id int primary key IDENTITY(1,1) NOT NULL,
	Name nvarchar(50) NULL,
	unitPrice int NULL,
	QtyProduct int NULL)

	insert into Productstb values ('Smart Phone',3000,30),
	                              ('laptop',6000,40),
								  ('Printer',1000,130),
								  ('Scanner',1400,90),
								  ('SmartTV',5000,20)
select * from productstb
--SubQuery 
--First
select max(unitprice) from productstb
--Next
select max(unitprice) from productstb
where unitprice <(select max(unitprice) from productstb)

--------------------------------------------
select top 3 unitprice 
from (
  select distinct top 3 unitprice 
  from productstb
  order by unitprice desc
) result 
order by unitprice


--in Function 
go
alter function GetGreatest(@N int)
returns table 
as
return (select top (@N) unitprice 
from (select distinct top (@N) unitprice 
  from productstb
  order by unitprice desc
  )Result 
order by unitprice desc)

go
select * from GetGreatest(3)
-------------------------------------------------------------
--dense_rank()
select unitprice ,dense_rank()Over(order by unitprice desc) as result 
from ProductsTb

go
--CTE with dense_rank()
with CTE_Price
as
(
  select unitprice ,dense_rank()Over(order by unitprice desc) as result 
  from ProductsTb
)
select top 1 unitprice from cte_price where result = 1
------------------------------------------------------------------------------
--============================================================================================
