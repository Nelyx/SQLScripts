
go
with
    fs
    as
    (
        select
            database_id,
            type,
            size * 8.0 / 1024 as size
        from sys.master_files
    )
select
    name,
    (select sum(size)
    from fs
    where type = 0 and fs.database_id = db.database_id) DataFileSizeMB,
    (select sum(size)
    from fs
    where type = 1 and fs.database_id = db.database_id) LogFileSizeMB
from sys.databases db


select
    max(db.name) as DatabaseName,
    sum(iif(type = 0, size * 8.0 / 1024, null)) as DataSizeMB,
    sum(iif(type = 1, size * 8.0 / 1024, null)) as LogSizeMB

from sys.master_files fs
    join sys.databases db
    on fs.database_id = db.database_id
group by fs.database_id
order by DatabaseName
