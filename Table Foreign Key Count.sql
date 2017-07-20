

select
    [s].[name]+'.'+[t].[Name] as [ObjectName],
    count(distinct [fkin].object_id) as [FkIn],
    count(distinct [fkOut].object_id) as [FkOut],
    (count(distinct [fkin].object_id) + 1.0)
    / (count(distinct [fkOut].object_id) + 1.0) as [FkBogoRatio]
from sys.tables as t
    join sys.schemas as s
    on t.schema_id = s.schema_id
    left join sys.foreign_keys as fkIn
    on t.object_id = fkIn.referenced_object_id
    left join sys.foreign_keys as fkOut
    on t.object_id = fkOut.Parent_object_Id
group by
         [t].[Name],
         [s].[name]
order by
          [FkBogoRatio] desc;