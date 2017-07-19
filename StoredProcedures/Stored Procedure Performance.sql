select
db_name(s.database_id) as DatabaseName, 
object_name(object_id, database_id) as StoredProcedure, 

s.cached_time as CreatedDateTime, 
s.last_execution_time as LastRunDateTime, 
datediff(second, s.cached_time, s.last_execution_time) as Age, 
s.execution_count as RunCount,

s.total_elapsed_time/s.execution_count/1000000.0 as RuntimeAvg,
s.min_elapsed_time/1000000.0 as RuntimeMin,
s.max_elapsed_time/1000000.0 as RuntimeMax,
s.last_elapsed_time/1000000.0 as RuntimeLast,
s.total_elapsed_time/1000000.0 as RuntimeTotal

,(s.total_elapsed_time/1000000.0) / nullif(datediff(second, s.cached_time, s.last_execution_time),0)*100 as ActivePercent


from sys.dm_exec_procedure_stats as s
order by  RuntimeAvg desc
