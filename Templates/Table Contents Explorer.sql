
declare @ID varchar(50) = '1234'
declare @ColumnName varchar(50) = 'objectId'
declare @tablecommands table (command nvarchar(max), done bit)
declare @command nvarchar(max)


insert into @tablecommands

select
'
if (select count(*) from '+[s].[name]+'.'+[t].[name]+' where '+[c].[name]+' = '+@ID+') > 0  
begin
select top 5 '''+[s].[name]+'.'+[t].[name]+''' as TableName , * from '+[s].[name]+'.'+[t].[name]+' where '+[c].[name]+' = '+@ID+'
end',
0
from sys.schemas as s
join sys.tables as t
     on s.schema_id = t.schema_id
join sys.columns as c
     on t.object_id = c.object_id
where [c].[name] = @ColumnName
 order by
          [s].[name],
          [t].[name];





while (select count(*) from @tablecommands where done = 0) > 0
begin   
    select top 1 @command = command from @tablecommands where done = 0
    print @command
    exec sp_executesql @command
    update @tablecommands set done = 1 where command = @command
end