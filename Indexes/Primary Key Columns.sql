

select
  schema_name([t].schema_id) as [SchemaName],
  [t].[name] as [TableName],
  [ind].[name],
  [indcol].[key_ordinal] as [Ord],
  [col].[name] as [ColumnName],
  [ind].[type_desc],
  [ind].[fill_factor]
from sys.tables as t
  inner join sys.indexes as ind
  on ind.object_id = t.object_id
  inner join sys.index_columns as indcol
  on indcol.object_id = t.object_id
    and indcol.index_id = ind.index_id
  inner join sys.columns as col
  on col.object_id = t.object_id
    and col.column_id = indcol.column_id
where [ind].[is_primary_key] = 1
order by
          [t].[name],
          [indcol].[key_ordinal];