declare @tablecommands table (command nvarchar(max), done bit)
declare @command nvarchar(max)


insert into @tablecommands

select 
'
drop trigger [tr_donothing_'+ OBJECT_SCHEMA_NAME(object_id) +'_'+ OBJECT_NAME(object_id) + '] go

create trigger [tr_donothing_'+ OBJECT_SCHEMA_NAME(object_id) + '_'+ OBJECT_NAME(object_id) + '] on ['+ OBJECT_SCHEMA_NAME(object_id) +'].['+ OBJECT_NAME(object_id) + ']
instead of insert, update, delete
as
begin
waitfor delay ''00:00:00''
end' 
,0 
from sys.tables

while (select count(*) from @tablecommands where done = 0) > 0
begin   
    select top 1 @command = command from @tablecommands where done = 0
    print @command
    exec sp_executesql @command
    update @tablecommands set done = 1 where command = @command
end