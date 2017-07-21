set nocount on
declare @tablecommands table (command nvarchar(max), done bit) --list of commands
declare @command nvarchar(max) --current command to execute

--specifying the databases explicitly so that no "use" statement needs to be added
declare @SrcDB varchar(50) = 'source' --Source database to select data from (can be on same server or on linked server)
declare @DestDB varchar(50) = 'destination' --destination database. 
declare @tableprefix varchar(50) = @SrcDB


insert into @tablecommands

select 
'if not exists (select * from ['+@DestDB+'].sys.tables where [name] = '''+@tableprefix+'_'+t.name+''')
begin
    --create empty table based on source table
    select top 1 * 
    into ['+@DestDB+'].[dbo].['+@tableprefix+'_'+t.name+']
    from ['+@SrcDB+'].['+ s.name +'].['+ t.name + ']
end;
--truncate the data in the table. Even if its just been created.
truncate table ['+@DestDB+'].[dbo].['+@tableprefix+'_'+t.name+']

--set identity_insert ['+@DestDB+'].[dbo].['+@tableprefix+'_'+t.name+'] on
insert into ['+@DestDB+'].[dbo].['+@tableprefix+'_'+t.name+']
select top 10 * from ['+@SrcDB +'].['+ s.name +'].['+ t.name + ']
--set identity_insert ['+@DestDB+'].[dbo].['+@tableprefix+'_'+t.name+'] off
' as command
,0 as done
from sys.tables t
join sys.schemas s
on t.schema_id = s.schema_id

while (select count(*) from @tablecommands where done = 0) > 0
begin   
    select top 1 @command = command from @tablecommands where done = 0
    print @command
    exec sp_executesql @command
    update @tablecommands set done = 1 where command = @command
end