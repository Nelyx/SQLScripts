select
       dm_mid.database_id as DatabaseID,
	   dm_migs.avg_user_impact Impact ,
	   (dm_migs.user_seeks + dm_migs.user_scans) as ExecutionsEver,
       dm_migs.avg_user_impact 
		  * (dm_migs.user_seeks + dm_migs.user_scans) 
		  as Avg_Estimated_Impact,
       dm_migs.last_user_seek as Last_User_Seek,
       object_name(dm_mid.OBJECT_ID, dm_mid.database_id) as TableName,
       'create index [IX_'
	  +object_name(dm_mid.OBJECT_ID, dm_mid.database_id)
	  +'_'
	  +replace(
		  replace(
			 replace(
				isnull(dm_mid.equality_columns, '')
			    , ', ', '_'
			    )
			, '[', ''
			)
		, ']', ''
		)
	   +case
            when dm_mid.equality_columns is not null
                and dm_mid.inequality_columns is not null
                then '_'
            else ''
            end
	   +replace(
		  replace(
			 replace(
			 	isnull(dm_mid.inequality_columns, '')
				, ', ', '_'
				)
			, '[', ''
			)
		, ']', ''
		)
		+']'+' on '+dm_mid.statement+' ('
			+isnull(dm_mid.equality_columns, '')
				+case
                        when dm_mid.equality_columns is not null
                                and dm_mid.inequality_columns is not null
                            then ','
                        else ''
                        end
			+isnull(dm_mid.inequality_columns, '')
			+')'
			+isnull(' include ('+dm_mid.included_columns+')', '') 
			as Create_Statement
from sys.dm_db_missing_index_groups as dm_mig
inner join sys.dm_db_missing_index_group_stats as dm_migs
     on dm_migs.group_handle = dm_mig.index_group_handle
inner join sys.dm_db_missing_index_details as dm_mid
     on dm_mig.index_handle = dm_mid.index_handle
where dm_mid.database_ID = DB_ID()
order by
         Avg_Estimated_Impact desc;
