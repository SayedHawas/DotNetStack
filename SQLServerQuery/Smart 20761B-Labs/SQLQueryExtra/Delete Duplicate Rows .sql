--How To Delete Duplication Values From table in SQL
 
 select * from productstb
 go
 With CTE_ClearDuplicate
 as
 (
   select * , ROW_NUMBER() over(Partition By Name , Unitprice order by ID ) Result 
   from ProductsTb
 )
 select * from cte_clearduplicate
 ----------------------------------------
 --To Delete > 1
 go
  With CTE_ClearDuplicate
 as
 (
   select * , ROW_NUMBER() over(Partition By Name , Unitprice order by ID ) Result 
   from ProductsTb
 )
 delete  from cte_clearduplicate
 where Result >1

 select * from ProductsTb
