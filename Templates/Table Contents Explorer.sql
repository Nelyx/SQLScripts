
declare @ID varchar(50) = '1234'
declare @ColumnName varchar(50) = 'objectId'
declare @tablecommands table (command nvarchar(max), done bit)
declare @command nvarchar(max)


insert into @tablecommands

select 
'select top 10 '''+ t.name +''' as TableName , * from ' + t.name + ' were ' + c.name + ' = ' + @ID

 from 
sys.tables t 
join 
sys.columns c
on t.object_id = c.object_id
where c.name = @ColumnName





while (select count(*) from @tablecommands where done = 0) > 0
begin   
    select top 1 @command = command from @tablecommands where done = 0
    print @command
    exec sp_executesql @command
    update @tablecommands set done = 1 where command = @command
end