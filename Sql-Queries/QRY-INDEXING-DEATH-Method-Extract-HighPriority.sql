use DBA
go
/* Script to get Top Tables that should be Analyzed for Indexing */
set nocount on;
declare @sql nvarchar(max);
declare @params nvarchar(2000);
declare @more_info_filter varchar(2000);
declare @run_datetime_mode0 datetime = '2023-07-07 20:15:00.000';
declare @run_datetime_mode2 datetime = '2023-07-13 19:12:00.000';
declare @heap_size_mb_threshold numeric(20,2) = '200';
declare @heap_reads_mimimum int = 100;

set @params = '@more_info_filter varchar(2000), @run_datetime_mode0 datetime, @run_datetime_mode2 datetime, @heap_size_mb_threshold numeric(20,2), @heap_reads_mimimum int';

-- Get Findings that should be evaluated further before analysis to decide if Should be Ignored or not
if object_id('tempdb..#BlitzIndex_Mode0_Filtered') is not null
	drop table #BlitzIndex_Mode0_Filtered;
select distinct finding, bi.database_name, more_info
into #BlitzIndex_Mode0_Filtered
from dbo.BlitzIndex_Mode0 bi
where 1=1
--and bi.priority = -1 -- Use it to find out stats for max UpTime Days
and bi.run_datetime = @run_datetime_mode0
and bi.finding in ('Self Loathing Indexes: Small Active heap','Self Loathing Indexes: Medium Active heap','Self Loathing Indexes: Large Active Heap');

if object_id('tempdb..#BlitzIndex_Mode0_Filtered_Final') is not null
	drop table #BlitzIndex_Mode0_Filtered_Final;
select *
into #BlitzIndex_Mode0_Filtered_Final
from #BlitzIndex_Mode0_Filtered
where 1=0;

declare @db_name varchar(255);
declare @db_db_name varchar(255) = db_name();
declare cur_index_dbs cursor local fast_forward for
	select distinct [database_name] from #BlitzIndex_Mode0_Filtered;

open cur_index_dbs;
fetch next from cur_index_dbs into @db_name;
while @@FETCH_STATUS = 0
begin
	set quoted_identifier off;
	set @sql = "
use ["+@db_name+"];
insert #BlitzIndex_Mode0_Filtered_Final (finding, database_name, more_info)
select fi.finding, fi.database_name, fi.more_info
from #BlitzIndex_Mode0_Filtered fi
join ["+(@db_db_name  collate SQL_Latin1_General_CP1_CI_AS)+"].dbo.BlitzIndex bi 
	on bi.more_info collate SQL_Latin1_General_CP1_CI_AS = fi.more_info collate SQL_Latin1_General_CP1_CI_AS
	and bi.run_datetime = @run_datetime_mode2
	and bi.index_id <= 1
where exists (	select 1/0 
				/* There is identity column present */
				from sys.tables t
				join sys.identity_columns c
					on c.object_id = t.object_id
				join sys.schemas s
					on s.schema_id = t.schema_id
				where s.name collate SQL_Latin1_General_CP1_CI_AS = bi.schema_name collate SQL_Latin1_General_CP1_CI_AS 
				and t.name collate SQL_Latin1_General_CP1_CI_AS = bi.table_name collate SQL_Latin1_General_CP1_CI_AS
		)
	or ( (bi.total_reserved_MB >= @heap_size_mb_threshold) and (bi.reads_per_write > 1.0) and (bi.total_reads >= @heap_reads_mimimum) )
	or ( (bi.total_reserved_MB >= (@heap_size_mb_threshold*2)) and (bi.total_reads > @heap_reads_mimimum/2) )
";
	set quoted_identifier on;
	--print @sql;

	/*	Heap table with either -
			- Identity column
			- Forwarded records
			- Size over @heap_size_mb_threshold & there are more reads than writes on table
			- Size over (@heap_size_mb_threshold * 2) & there are reads on table
	*/
	exec sp_executesql @sql, @params, @more_info_filter, @run_datetime_mode0, @run_datetime_mode2, @heap_size_mb_threshold, @heap_reads_mimimum;

	fetch next from cur_index_dbs into @db_name;
end
close cur_index_dbs;
deallocate cur_index_dbs;


select bi.more_info, sum(bi.priority) as priority_total, min(bi.priority) as priority_min
from dbo.BlitzIndex_Mode0 bi
where 1=1
and bi.priority <> -1 -- Use it to find out stats for max UpTime Days
and bi.run_datetime = @run_datetime_mode0
--and bi.database_name not in ('DBA','Facebook')
and (	bi.finding not in ('Self Loathing Indexes: Small Active heap','Self Loathing Indexes: Medium Active heap','Self Loathing Indexes: Large Active Heap')
		or
		(	bi.finding in ('Self Loathing Indexes: Small Active heap','Self Loathing Indexes: Medium Active heap','Self Loathing Indexes: Large Active Heap')
			and exists (	select 1/0
							from #BlitzIndex_Mode0_Filtered_Final ff
							where ff.more_info = bi.more_info
					)
		)
	)
--and bi.finding = 'Self Loathing Indexes: Heaps with Forwarded Fetches'
group by bi.more_info
order by priority_min, priority_total DESC, bi.more_info

--select * from dbo.BlitzIndex_Mode0 where run_datetime = '2023-02-24 20:20:00.000'
--select top 1000 * from dbo.BlitzIndex_Mode0 where run_datetime = '2022-12-30 20:10:00.000'
--select top 200 * from dbo.BlitzIndex where index_id = 0 and reads_per_write > 1.0
go

-- SELECT distinct run_datetime from dbo.BlitzIndex_Mode0 where run_datetime >= dateadd(day,-7,getdate())
-- SELECT distinct run_datetime from dbo.BlitzIndex where run_datetime >= dateadd(day,-7,getdate())
-- SELECT distinct run_datetime from dbo.BlitzIndex_Mode4 where run_datetime >= dateadd(day,-7,getdate())