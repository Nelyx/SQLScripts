declare @tables table (tablename nvarchar(max), done bit)
declare @tablename nvarchar(max)

insert into @tables
  select OBJECT_NAME(object_id), 0
  from sys.tables

while (select count(*) from @tables where done = 0) > 0
begin   
    select top 1 @tablename = tablename from @tables where done = 0
    print '// ' + @tablename

	declare @Result varchar(max) = 'public class ' + @TableName + char(13) +'{'

	select @Result = @Result + '
		public ' + ColumnType + NullableSign + ' ' + ColumnName + ' { get; set; }'
	from
	(
			select 
				replace(col.name, ' ', '_') ColumnName,
				column_id ColumnId,
				case typ.name 
					when 'bigint' then 'long'
					when 'binary' then 'byte[]'
					when 'bit' then 'bool'
					when 'char' then 'string'
					when 'date' then 'DateTime'
					when 'datetime' then 'DateTime'
					when 'datetime2' then 'DateTime'
					when 'datetimeoffset' then 'DateTimeOffset'
					when 'decimal' then 'decimal'
					when 'float' then 'double'
					when 'image' then 'byte[]'
					when 'int' then 'int'
					when 'money' then 'decimal'
					when 'nchar' then 'string'
					when 'ntext' then 'string'
					when 'numeric' then 'decimal'
					when 'nvarchar' then 'string'
					when 'real' then 'float'
					when 'smalldatetime' then 'DateTime'
					when 'smallint' then 'short'
					when 'smallmoney' then 'decimal'
					when 'text' then 'string'
					when 'time' then 'TimeSpan'
					when 'timestamp' then 'long'
					when 'tinyint' then 'byte'
					when 'uniqueidentifier' then 'Guid'
					when 'varbinary' then 'byte[]'
					when 'varchar' then 'string'
					else 'UNKNOWN_' + typ.name
				end ColumnType,
				case 
					when col.is_nullable = 1 and typ.name in ('bigint', 'bit', 'date', 'datetime', 'datetime2', 'datetimeoffset', 'decimal', 'float', 'int', 'money', 'numeric', 'real', 'smalldatetime', 'smallint', 'smallmoney', 'time', 'tinyint', 'uniqueidentifier') 
					then '?' 
					else '' 
				end NullableSign
			from sys.columns col
				join sys.types typ 
					on col.system_type_id = typ.system_type_id 
					and col.user_type_id = typ.user_type_id

			where object_id = object_id(@TableName)
		) t
		order by ColumnId

		set @Result = @Result + char(13)+ '}'
		print @Result



    update @tables set done = 1 where tablename = @tablename
end
