select
       ps.name+'.'+p.name as ProcedureName,
       ts.name+'.'+t.name+'.'+c.name as TableColumnName,
       d.*
from sys.sql_dependencies as d
join sys.procedures as p
     on d.object_id = p.object_id
join sys.schemas as ps
     on ps.schema_id = p.schema_id
join sys.tables as t
     on d.referenced_major_id = t.object_id
join sys.schemas as ts
     on ts.schema_id = t.schema_id
join sys.columns as c
     on d.referenced_major_id = c.object_id
        and d.referenced_minor_id = c.column_id