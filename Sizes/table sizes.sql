select
	s.name +'.' +t.Name as ObjectName,	  		
	p.rows as RowCounts,
	sum(a.total_pages) * 8 / 1024 as TotalMB,
	sum(a.used_pages) * 8 / 1024 as UsedMB,
	sum(a.total_pages) * 8.0 / nullif(p.rows, 0) as SizePerRowKB
from sys.tables as t
	 join sys.schemas s 
	 on t.schema_id = s.schema_id
	 join sys.indexes as i
     on t.object_id = i.object_id
     join sys.partitions as p
     on i.object_id = p.OBJECT_ID
        and i.index_id = p.index_id
     join sys.allocation_units as a
     on p.partition_id = a.container_id

group by
         t.Name,
		 s.name,
         p.Rows
order by
         totalmb asc;