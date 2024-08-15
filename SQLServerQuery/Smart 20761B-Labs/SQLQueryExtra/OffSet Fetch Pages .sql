-------------------------------------------------------------------
--Pages By Offest .... fetch

select * from [Order Details]
  order by orderID
  offset 30 Rows 
  fetch next 10 Rows only 
go
Create proc sp_GetPagesOrdersDetails
@PageNumber int ,
@PageSize int
as
begin 
  select * from [Order Details]
  order by orderID
  offset (@pagenumber -1)* @pagesize Rows 
  fetch next @Pagesize Rows only 
end

exec sp_GetPagesOrdersDetails 50,10
exec sp_GetPagesOrdersDetails 215,10

-----------------------------------------------------------------------------------------------------




