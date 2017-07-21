select
    s.name + '.' + ta.name as TableName,
    c.name,
    tr.name as TriggerName,
    m.definition,
    'create trigger [trg_audit_'+s.name+'_'+ta.name+'] ON ['+s.name+'].['+ta.name+']
    for insert, update, delete
    as
    begin
      declare @i xml, @d xml, @personid varchar(80)
        set @i = (select * from inserted for xml auto)
        set @d = (select * from deleted for xml auto)
          insert into [audit].[log] getutcdate(), '''+ta.name+''', @d, @i
    end' as NewDefinition

from sys.schemas s
    join sys.tables ta
    on ta.schema_id = s.schema_id
    join sys.columns c
    on ta.object_id = c.object_id
        and c.name = 'LastUpdatedBy'
    left join sys.triggers tr
    join sys.sql_modules m
    on tr.object_id = m.object_id
    on tr.parent_id = ta.object_id
        and tr.name like 'trg_audit%' collate Latin1_General_CI_AI

order by ta.create_date