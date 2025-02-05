
/*
 Exam part02
 */
 --1
 select Fname+ ' '+Lname
 from Employee
 where  Fname like '____%'

 --2
 select  count (b.Id)[NO OF PROGRAMMING BOOKS]
 from Book b join Category c
 on b.Cat_id =c.Id
 where c.Cat_name ='Programming '

 --3

 select  count (b.Id)[NO_OF_BOOKS]
 from Book b join Publisher p
 on p.Id= b.Publisher_id
 where p.Name ='HarperCollins '

 --4

 select u.SSN, u.User_Name,b.Borrow_date,b.Due_date
 from Users u join Borrowing b
 on b.User_ssn =u.SSN
 where b.Due_date<'July 2022'

 --5

 select concat (b.Title ,'is written by ',a.Name)
 from Book b join Book_Author ba
 on ba.Book_id=b.Id
 join Author a
 on a.Id=ba.Author_id

 --6
 select u.User_Name
 from Users u
 where u.User_Name like '%a%'


 --7
 select top (1) User_ssn 
 from  Borrowing 
 group by User_ssn
 order by   count (Book_id)desc


 --8
 select b.User_ssn , sum(b.Amount)sumAmount
 from Users u join Borrowing b
 on b.User_ssn =u.SSN
 group by b.User_ssn  
 

 --9
 select c.Cat_name , bo.Amount
 from Book b join Category c
 on b.Cat_id =c.Id join Borrowing bo
 on b.Id=bo.Book_id
 where bo.Amount =(select  min (Amount )
 from Borrowing)

--10
select coalesce (Email ,address,convert(varchar,e.DOB) ) INF
from Employee e

--11
select c.Cat_name , count(b.Id) [Count Of Books]
from Book b
join Category c
on  c.Id=b.Cat_id
group by c.Cat_name 

--12

select b.Id
from Book b 
where b.Shelf_code not in(select s.Code
from Shelf s join Floor f
on f.Number =s.Floor_num
where f.Number=1 and s.Code='A1' )

 
 --13
 select f.Number,f.Num_blocks, count (e.Id)
 from Employee e join Floor f
 on e.Floor_no =f.Number
 group by f.Number,f.Num_blocks

 --14
 select b.Title,u.User_Name ,bo.Borrow_date
 from Book b join Borrowing bo 
 on bo.Book_id =b.Id
 join Users u on bo.User_ssn =u.SSN
 where bo.Borrow_date between '3/1/2022' and'10/1/2022'

 --15
 select e.Fname +' '+e.Lname[Full Name] ,esuper .Fname
 from Employee e join Employee esuper
 on e.Super_id =esuper.Id

 --16
 select Fname,coalesce(Salary,bouns)
 from Employee

 --17
 select max( Salary) maxsalary,min( Salary)minsalary

 from Employee

 --18
 go
 create or alter function evenOrOdd (@num int )
 returns varchar (20)
 as
 begin
 if @num =0
 return 'odd'
  else if @num %2=0
 return 'even'
 else if @num %2=1
 return 'odd'
 return'error'
 end

 go
 select dbo.evenOrOdd (0)
  select dbo.evenOrOdd (29)
  select dbo.evenOrOdd (30)

 --19 
 go
 create or alter function takeCategoryNameAndDisplayTitleBooks(@nameCat varchar (50))
 RETURNS table 
 as
 return(
 select b.Title
 from Book b join Category c
 on c.Id =b.Cat_id
 where c.Cat_name=@nameCat)
 go
 select * from takeCategoryNameAndDisplayTitleBooks('Mathematics')

 --20
 go
 create or alter function infUser (@phone bigint )
 returns  @newtable table (
 BookTitle varchar (50),
 userName varchar (20),
 amount int,
 due_date date 
 )
 as
 begin 
 insert into @newtable
 select b.Title,u.User_Name,bo.Amount,bo.Due_date
 from User_phones uph join Users u
 on u.SSN =uph.User_ssn
 join Borrowing bo
 on bo.User_ssn=u.SSN join Book b
 on b.Id= bo.Book_id
 where uph.Phone_num =@phone
 return
 end
 go
 select * from dbo.infUser(0265511122)

 --21
go
 create or alter function  takeUserNameCheckIfDuplicated(@userName varchar(20))
returns varchar (50)
as
begin
declare @Repeated  varchar(50)
declare @notRepeated  varchar(50)
declare @num int 
declare @uname  varchar(50)
select @num =count (u.User_Name),@uname =u.User_Name
from Users u
where u.User_Name=@userName
group by  User_Name


if @num>1
return concat (@uname,' is Repeated ',@num )
else  if @num =1
return concat (@uname,' is not Repeated ',@num )
return concat (@userName ,' is Not Found')
end
go
select dbo.takeUserNameCheckIfDuplicated ('Amr Ahmed')
select dbo.takeUserNameCheckIfDuplicated (' Salem')

--22
go
create or alter function FormatDate(@date date, @num int)
returns varchar (20)
as
begin 
return convert(varchar (20),@date,@num )
end
go
select dbo.FormatDate('2022-03-24',107)
go
--23
go
create or alter proc showTheNumberOfBooksPerCategory 

AS
select count (b.Id),c.Cat_name
from Book b join Category c
on c.Id= b.Cat_id
group by c.Cat_name
go
showTheNumberOfBooksPerCategory

--24
go
create or alter proc oldManagerReplacementNewManager @oldEmp int ,@newEmp int ,@floor_number int
as
update Floor
set MG_ID =@newEmp 
where MG_ID  =@oldEmp  and Number =@floor_number 
go

 oldManagerReplacementNewManager 3,8,1

 go
 --25

 create or alter view AlexAndCairoEmp
 as
 select  *
 from Employee
 where Address=' alex'  or  Address= 'Cairo'
 go
 select * from AlexAndCairoEmp
 go
 --26

 create or alter view V2
 as
 select s.Code ,count (b.Id) nuBooks
 from Book b join Shelf s
 on b.Shelf_code = s.Code
 group by s.Code
  go
 select * from V2

 --27
 GO
  create or alter view V3
  as
  select  TOP 1 Code 
  from v2
 ORDER BY nuBooks DESC

   go
 select * from V3
 go
 --28
 create table ReturnedBooks (
    UserSSN int ,         
    BookId int,               
    DueDate date,            
    ReturnDate date,          
    Fees decimal
)

go
create or alter trigger tReturnedBooks
on Borrowing
 instead of insert 
 as
 declare @checkdate date 
 select  @checkdate = Due_date
 from inserted
  if  (@checkdate  <= getdate())

 insert into ReturnedBooks
 select u.SSN,bo.Book_id,bo.Due_date,getdate(),bo.Amount*(1+0.2) calufeed
 from Borrowing bo join  Users u
 on u.SSN= User_ssn join inserted 
 on bo.Book_id =inserted.Book_id and bo.Borrow_date= inserted.Borrow_date

 



 insert Borrowing (Borrow_date,Book_id)
 values('2021-02-25',3)

 --29
 insert Floor( Number,Num_blocks,MG_ID,Hiring_Date)
 values(7,2,20,getdate())

 update Floor
set MG_ID = 5, Hiring_Date = getdate()
WHERE Number= 7

--30
go
create view v_2006_check
as 
select MG_ID, Number,Num_blocks,Hiring_Date
from Floor
where Hiring_Date between '2022-03-01' AND '2022-05-31'
WITH CHECK OPTION

insert  v_2006_check (MG_ID, Number,Num_blocks, Hiring_Date)
VALUES (2, 6, 2, '7-8-2023')

/* number 'PK_Floor'  The duplicate key value is (6).
*/
insert into v_2006_check (MG_ID, Number,Num_blocks, Hiring_Date)
values (4, 7, 1, '4-8-2022')


--31
go
create trigger preventanyonefromModifyingorDeleteorInsert
on Employee
 instead of insert , update ,delete
 as

 select 'can’t take any action with this Table'

 disable trigger preventanyonefromModifyingorDeleteorInsert ON employee
 
 --32
 insert into User_Phones (user_ssn, phone_num)
values (50, '3456789')

/* foreign key and SSN 50 doesn’t exist in the Users table
*/
update  Employee
set id = 21
where id = 20
/*
Cannot update identity column 'Id'.*/
delete from Employee
where id = 1
/*"FK_Borrowing_Employee" in database "Library", table "dbo.Borrowing", column 'Emp_id'*/


delete from Employee
where id = 12
/*"FK_Borrowing_Employee" in database "Library", table "dbo.Borrowing", column 'Emp_id'*/

create clustered index idxsalary ON Employee (salary)
/*Cannot create more than one clustered index on table 'Employee'*/


