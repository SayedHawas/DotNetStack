/*
Module 17
Implementing Error Handling
------------------------------------
--Error handling :-
--batch Error Handling 
Errors and Error Messages
@@ERROR returns last error code
*/
Create database Module17DB 
go
use Module17DB
go
Create table Users (ID int );
go
insert into Users values (1),(2),(3);
select * from Users

------------------------ Try Catch  T-SQl Programming 

insert into Users values ('s'); -- Error
---handle

begin try 
	insert into Users values ('s');
end try 
begin catch 
 select ERROR_LINE() as Line,
        ERROR_MESSAGE () as Messages,
        ERROR_NUMBER () as Number,
		ERROR_PROCEDURE () as Procedures,
		ERROR_SEVERITY () Serverity
end catch
--------------------
begin try 
 select 5/0;
 end try 
 begin catch 
    print 'Can Not Div by Zero'
	--raisError('Can Not Div by Zero',16,1);
	--throw 50000,'Can not Div By Zero ',1;
 end catch 
 
 Select message_id,severity,text from sys.messages   where language_id = 1033 ;

 exec sp_addmessage 50001,16,N'·« Ì„ﬂ‰ «·ﬁ”„Â ⁄·Ì «·’›—';
 begin try 
 select 5/0;
 end try 
 begin catch 
  raiserror(50001,16,1);
 end catch 
 -------------------------------------------------
 create table ProductsTb 
 (
    id int primary Key identity,
	Name nvarchar(50),
	unitPrice int,
	QtyProduct int 
 )
 go
 insert into ProductsTb values ('Mobile',2000,10),('Laptop',3000,20),('SmartTv',2500,25)
 go

 Create table Orders
 (
     id int primary Key identity,
	 ProductId int ,
	 QuantityOrder int 
 )
 go

 go 
 Create proc SpOrders
 @productID int ,
 @QtyOrder int 
 as 
 begin
    --check 
	declare @unitinStock int 
	select @unitinStock = QtyProduct 
	from ProductsTb 
	where id = @productID;
	 if(@unitinStock <@QtyOrder)
		 begin 
			raisError ('Not Enaugh in Stock ',16,1)
		 end 
	 else
		 begin 
		    begin tran 
			--Update 
			  update ProductsTb set QtyProduct = (QtyProduct-@QtyOrder)
			  where id =@productID;
			  --insert 
			  insert into Orders values (@productID,@QtyOrder);
		 end 
		 if(@@ERROR <> 0)
			 begin
				   rollback tran
				   print 'Fail in Insert ';
			 end 
		 else 
			 begin 
				   commit tran
				   print 'Done ... ';
			 end 
 end 
 go

 exec SpOrders 1,5
 select * from productsTb 
 select * from Orders


 exec SpOrders 3,45

 -----------------------------------------------------------------------------------------