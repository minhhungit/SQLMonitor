use DBA
go

select table_name = coalesce(pt.table_name, 'dbo.'+bi.table_name), bi.index_name, pt.retention_days, 
		bi.index_size_summary, bi.data_compression_desc
from dbo.BlitzIndex bi left join dbo.purge_table pt 
	on pt.table_name = 'dbo.'+bi.table_name
where bi.run_datetime = (select max(run_datetime) from dbo.BlitzIndex i)
and bi.database_name = DB_NAME()
and (pt.table_name is not null or bi.table_name = 'WhoIsActive')

--update dbo.purge_table
--set retention_days = 365
--where table_name in ('dbo.wait_stats','dbo.file_io_stats')