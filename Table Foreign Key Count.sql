

select
    [s].[name]+'.'+[t].[Name] as [ObjectName],
    count(distinct [fkin].object_id) as [FkIn],
    count(distinct [fkOut].object_id) as [FkOut]
from sys.tables as t
    join sys.schemas as s
    on t.schema_id = s.schema_id
    join sys.foreign_keys as fkIn
    on t.object_id = fkIn.referenced_object_id
    join sys.foreign_keys as fkOut
    on t.object_id = fkOut.Parent_object_Id
group by
         [t].[Name],
         [s].[name]

order by fkin desc