if not exists
    (
        select
               *
        from sys.procedures
        where schema_name(schema_id) = 'dbo'
              and object_name(object_id) = 'somename'
    )
    begin
        print 'creating the proc';
        exec sp_executesql
             N'create procedure somename as begin select 1 end;';
    end;
go

print 'altering the proc'
go
alter procedure somename
as
     begin
       select
                'do some real work';
     end;