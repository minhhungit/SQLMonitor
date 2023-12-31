IF DB_NAME() = 'master'
	raiserror ('Kindly execute all queries in [DBA] database', 20, -1) with log;
go

SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET ANSI_WARNINGS ON;
SET NUMERIC_ROUNDABORT OFF;
SET ARITHABORT ON;
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'usp_GetAllServerDashboardMail')
    EXEC ('CREATE PROC dbo.usp_GetAllServerDashboardMail AS SELECT ''stub version, to be replaced''')
GO

ALTER PROCEDURE dbo.usp_GetAllServerDashboardMail
(	@recipients varchar(500) = 'some_dba_mail_id@gmail.com', /* Folks who receive the failure mail */
	@mail_subject varchar(500) = 'Monitoring - Live - All Servers', /* Subject of Failure Mail */
	@job_name varchar(255) = '(dba) Get-AllServerDashboardMail',
	@dashboard_link varchar(200) = 'https://ajaydwivedi.ddns.net:3000/d/distributed_live_dashboard_all_servers',
	@os_cpu_threshold decimal(20,2) = 70,
	@sql_cpu_threshold decimal(20,2) = 65,
	@blocked_counts_threshold int = 1,
	@blocked_duration_max_seconds_threshold bigint = 60,
	@available_physical_memory_mb_threshold bigint = 4096,
	@system_high_memory_signal_state_threshold varchar(20) = 'Low',
	@memory_grants_pending_threshold int = 1,
	@connection_count_threshold int = 1000,
	@waits_per_core_per_minute_threshold decimal(20,2) = 180,
	@verbose tinyint = 0 /* 0 - no messages, 1 - debug messages, 2 = debug messages + table results */
)
AS 
BEGIN
	/*
		Version:		0.0.0
		Update:			2022-12-31 - #24 - Daily Mailer containing similar content of 'Monitoring - Live - All Servers' dashboard

		EXEC dbo.usp_GetAllServerDashboardMail @recipients = 'ajay.dwivedi2007@gmail.com', @verbose = 2
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 60000; -- 60 seconds

	/* Derived Parameters */
	IF (@recipients IS NULL OR @recipients = 'some_dba_mail_id@gmail.com') AND @verbose = 0
		raiserror ('@recipients is mandatory parameter', 20, -1) with log;

	-- Local Variables
	DECLARE @_sql nvarchar(MAX);
	declare @_params nvarchar(max);
	DECLARE @_collection_time datetime = GETDATE();
	DECLARE @_mail_body_html  nvarchar(MAX); 
	declare @_title nvarchar(2000);
	declare @_style_css nvarchar(max);
	declare @_html_core_health nvarchar(MAX);
	declare @_html_tempdb_health nvarchar(MAX);
	declare @_html_log_space_health nvarchar(MAX);
	declare @_html_ag_health nvarchar(MAX);
	declare @_html_disk_health nvarchar(MAX);
	declare @_html_offline_servers nvarchar(MAX);
	declare @_html_sqlmonitor_jobs nvarchar(max);
	declare @_table_headline nvarchar(500);
	declare @_table_header nvarchar(max);
	declare @_table_data nvarchar(max);	
	declare @_line nvarchar(500);
	declare @_tab nchar(2) = nchar(9);
	declare @_crlf nchar(2) = nchar(13);

	if @verbose > 0
		print 'Set local variables..';
	set @_title = 'Monitoring - Live - All Servers';
	set @_line = '-----------------------------------------------------------------';

	--set quoted_identifier off;	
	-- https://htmlcolorcodes.com/
	set @_style_css = '<style>
		th {
			background-color: black;
			color: white;
		}
		td {
			text-align: center;
		}
		/*
		table ,tr td{
			border: 1px solid red
		}
		*/
		tbody {
			display: block;
			/* height: 50px; */
			overflow: auto;
		}
		thead, tbody tr {
			display: table;
			width: 100%;
			table-layout: fixed;
		}
		thead {
			width: calc( 100% - 1em )
		}
		/*
		table {
			width:400px;
		}
		*/

		.bg_desert {
		  background-color: #FAD5A5;
		}
		.bg_green {
		  background-color: green;
		}
		.bg_key {
			background-color: #7fd1f2;
		}
		.bg_metric_neutral {
			background-color: #C663AD;
		}
		.bg_pistachio {
		  background-color: #93C572;
		}
		.bg_orange {
		  background-color: orange;
		}
		.bg_red {
			background-color: red;
		}		
		.bg_yellow {
		  background-color: #FFFF00;
		}
		.bg_yellow_dark {
		  background-color: #FFBF00;
		}
		.bg_yellow_medium {
		  background-color: #FFEA00;
		}
		.bg_yellow_light {
		  background-color: #FAFA33;
		}
		.bg_yellow_canary {
		  background-color: #FFFF8F;
		}
		.bg_yellow_gold {
		  background-color: #FFD700;
		}
		.scrollit {
			overflow: auto;
		}
	  </style>';
	if @verbose > 0
	begin
		print @_line;
		print '@_style_css => '+@_crlf+@_style_css;
		print @_line;
	end

	if('Core Health Metrics' = 'Core Health Metrics')
	begin
		if @verbose > 0
			print 'Set @_html_core_health variable..';

		set @_table_headline = N'<h3>All Servers - Health Metrics - Require ATTENTION</h3>';
		set @_table_header = N'<tr><th>Server</th> <th>OS CPU %</th> <th>SQL CPU %</th>'
						+N'<th>Blocked Over '+convert(varchar,@blocked_duration_max_seconds_threshold)+' seconds</th>'
						+N'<th>Longest Blocking</th> <th>Available Memory</th> <th>OS Memory State</th>'
						+N'<th>Used SQL Memory</th> <th>Memory Grants Pending</th> <th>SQL Connections</th>'
						+N'<th>Waits Per Core Per Minute</th>';
		set @_table_data = NULL;

		if not exists (select * from dbo.vw_all_server_info)
			raiserror ('Data does not exist in dbo.vw_all_server_info', 17, -1) with log;
		;with asi as (
			select	srv_name, os_cpu, sql_cpu, blocked_counts, blocked_duration_max_seconds, available_physical_memory_kb, system_high_memory_signal_state, physical_memory_in_use_kb, memory_grants_pending, connection_count, waits_per_core_per_minute
			from dbo.vw_all_server_info
		)
		,t_cte as (
			select	'<tr>'
					+'<td class="bg_key">'+srv_name+'</td>'
					+'<td class="'+(case when os_cpu >= 90 then 'bg_red'
									when os_cpu >= 80 then 'bg_orange'
									when os_cpu >= 70 then 'bg_yellow_medium'
									else 'bg_none'
									end)+'">'+convert(varchar,os_cpu)+'</td>'
					+'<td class="'+(case when sql_cpu >= 90 then 'bg_red'
									when sql_cpu >= 80 then 'bg_orange'
									when sql_cpu >= 70 then 'bg_yellow_medium'
									else 'bg_none'
									end)+'">'+convert(varchar,sql_cpu)+'</td>'
					+'<td class="'+(case when blocked_counts >= 10 then 'bg_red'
									when blocked_counts >= 5 then 'bg_orange'
									when blocked_counts >= 1 then 'bg_yellow_medium'
									else 'bg_none'
									end)+'">'+convert(varchar,isnull(blocked_counts,0))+'</td>'
					+'<td class="'+(case when blocked_duration_max_seconds >= 1800 then 'bg_red'
									when blocked_duration_max_seconds >= 600 then 'bg_orange'
									when blocked_duration_max_seconds >= 300 then 'bg_yellow_dark'
									when blocked_duration_max_seconds >= 120 then 'bg_yellow_medium'
									when blocked_duration_max_seconds >= 60 then 'bg_yellow_light'
									else 'bg_none'
									end)+'">'+isnull((case when blocked_duration_max_seconds < 60 then convert(varchar,floor(blocked_duration_max_seconds))+' sec'
							when blocked_duration_max_seconds < 3600 then convert(varchar,floor(blocked_duration_max_seconds/60))+' min'
							when blocked_duration_max_seconds < 86400 then convert(varchar,floor(blocked_duration_max_seconds/3600))+' hrs'
							when blocked_duration_max_seconds >= 86400 then convert(varchar,floor(blocked_duration_max_seconds/86400))+' days'
							else 'xx' end),0)+'</td>'
					+'<td class="'+(case when available_physical_memory_kb > 4194304 then 'bg_none'
									when available_physical_memory_kb > 2097152 then 'bg_yellow'
									when available_physical_memory_kb > 512000 then 'bg_orange'
									else 'bg_red'
									end)+'">'+(case when available_physical_memory_kb < 1024 then convert(varchar,available_physical_memory_kb)+' kb'
							when available_physical_memory_kb < 1024*1024 then convert(varchar,floor(available_physical_memory_kb/1024))+' mb'
							when available_physical_memory_kb < 1024*1024*1024 then convert(varchar,floor(available_physical_memory_kb/(1024*1024)))+' gb'
							when available_physical_memory_kb >= 1024*1024*1024 then convert(varchar,floor(available_physical_memory_kb/(1024*1024*1024)))+' tb'
							else 'xx' end)+'</td>'
					+'<td>'+system_high_memory_signal_state+'</td>'
					+'<td>'+(case when physical_memory_in_use_kb < 1024 then convert(varchar,physical_memory_in_use_kb)+' kb'
							when physical_memory_in_use_kb < 1024*1024 then convert(varchar,floor(physical_memory_in_use_kb/1024))+' mb'
							when physical_memory_in_use_kb < 1024*1024*1024 then convert(varchar,floor(physical_memory_in_use_kb/(1024*1024)))+' gb'
							when physical_memory_in_use_kb >= 1024*1024*1024 then convert(varchar,floor(physical_memory_in_use_kb/(1024*1024*1024)))+' tb'
							else 'xx' end)+'</td>'
					+'<td class="'+(case when memory_grants_pending > 0 then 'bg_red'
									else 'bg_none'
									end)+'">'+convert(varchar,isnull(memory_grants_pending,0))+'</td>'
					+'<td class="'+(case when connection_count >= 1200 then 'bg_red'
									when connection_count >= 1000 then 'bg_orange'
									when connection_count >= 800 then 'bg_yellow'
									else 'bg_none'
									end)+'">'+convert(varchar,connection_count)+'</td>'
					+'<td class="'+(case when waits_per_core_per_minute >= 300 then 'bg_red'
									when waits_per_core_per_minute >= 240 then 'bg_orange'
									when waits_per_core_per_minute >= 180 then 'bg_yellow'
									else 'bg_none'
									end)+'">'+isnull((case when waits_per_core_per_minute < 60 then convert(varchar,floor(waits_per_core_per_minute))+' sec'
							when waits_per_core_per_minute < 3600 then convert(varchar,floor(waits_per_core_per_minute/60))+' min'
							when waits_per_core_per_minute < 86400 then convert(varchar,floor(waits_per_core_per_minute/3600))+' hrs'
							when waits_per_core_per_minute >= 86400 then convert(varchar,floor(waits_per_core_per_minute/86400))+' days'
							else 'xx' end),'-1')+'</td>'
					+'</tr>' as [table_row]
			from asi cte
			where 1=1
			and (   os_cpu >= @os_cpu_threshold
				or  sql_cpu >= @sql_cpu_threshold 
				or  blocked_counts >= @blocked_counts_threshold
				or  blocked_duration_max_seconds >= @blocked_duration_max_seconds_threshold
				or  ( available_physical_memory_kb < (@available_physical_memory_mb_threshold*1024) 
					and system_high_memory_signal_state = @system_high_memory_signal_state_threshold 
					)
				or  memory_grants_pending > @memory_grants_pending_threshold
				or  connection_count >= @connection_count_threshold
				or  waits_per_core_per_minute > @waits_per_core_per_minute_threshold
				)
		)
		select @_table_data = coalesce(@_table_data+' '+[table_row],[table_row])
		from t_cte;

		set @_html_core_health = @_table_headline+'<table border="1">'
						+'<thead>'+@_table_header+'</thead><tbody>'+@_table_data+'</tbody></table>';

		if @verbose > 0
		begin
			print '@_table_header => '+@_crlf+@_table_header;
			print @_line;
			print '@_table_data => '+@_crlf+ISNULL(@_table_data,'');
			print @_line;
			print '@_html_core_health => '+@_crlf+ISNULL(@_html_core_health,'');
		end
	end -- 'Core Health Metrics'

	if('Tempdb Health' = 'Core Health Metrics')
	begin
		if @verbose > 0
			print 'Set @_html_tempdb_health variable..';

		set @_table_headline = N'<h3>All Servers - Tempdb Utilization - Require ATTENTION</h3>';
		set @_table_header = N'<tr><th>Collection Time</th> <th>Server</th> <th>Data Size</th>'
						+N'<th>Data Used</th>'
						+N'<th>Data Used %</th> <th>Log Size</th> <th>Log Used %</th>'
						+N'<th>Version Store</th> <th>Version Store %</th>';
		set @_table_data = NULL;

		if not exists (select * from dbo.vw_all_server_info)
			raiserror ('Data does not exist in dbo.vw_all_server_info', 17, -1) with log;
		;with asi as (
			select	srv_name, os_cpu, sql_cpu, blocked_counts, blocked_duration_max_seconds, available_physical_memory_kb, system_high_memory_signal_state, physical_memory_in_use_kb, memory_grants_pending, connection_count, waits_per_core_per_minute
			from dbo.vw_all_server_info
		)
		,t_cte as (
			select	'<tr>'
					+'<td class="bg_key">'+srv_name+'</td>'
					+'<td class="'+(case when os_cpu >= 90 then 'bg_red'
									when os_cpu >= 80 then 'bg_orange'
									when os_cpu >= 70 then 'bg_yellow_medium'
									else 'bg_none'
									end)+'">'+convert(varchar,os_cpu)+'</td>'
					+'<td class="'+(case when sql_cpu >= 90 then 'bg_red'
									when sql_cpu >= 80 then 'bg_orange'
									when sql_cpu >= 70 then 'bg_yellow_medium'
									else 'bg_none'
									end)+'">'+convert(varchar,sql_cpu)+'</td>'
					+'<td class="'+(case when blocked_counts >= 10 then 'bg_red'
									when blocked_counts >= 5 then 'bg_orange'
									when blocked_counts >= 1 then 'bg_yellow_medium'
									else 'bg_none'
									end)+'">'+convert(varchar,isnull(blocked_counts,0))+'</td>'
					+'<td class="'+(case when blocked_duration_max_seconds >= 1800 then 'bg_red'
									when blocked_duration_max_seconds >= 600 then 'bg_orange'
									when blocked_duration_max_seconds >= 300 then 'bg_yellow_dark'
									when blocked_duration_max_seconds >= 120 then 'bg_yellow_medium'
									when blocked_duration_max_seconds >= 60 then 'bg_yellow_light'
									else 'bg_none'
									end)+'">'+isnull((case when blocked_duration_max_seconds < 60 then convert(varchar,floor(blocked_duration_max_seconds))+' sec'
							when blocked_duration_max_seconds < 3600 then convert(varchar,floor(blocked_duration_max_seconds/60))+' min'
							when blocked_duration_max_seconds < 86400 then convert(varchar,floor(blocked_duration_max_seconds/3600))+' hrs'
							when blocked_duration_max_seconds >= 86400 then convert(varchar,floor(blocked_duration_max_seconds/86400))+' days'
							else 'xx' end),0)+'</td>'
					+'<td class="'+(case when available_physical_memory_kb > 4194304 then 'bg_none'
									when available_physical_memory_kb > 2097152 then 'bg_yellow'
									when available_physical_memory_kb > 512000 then 'bg_orange'
									else 'bg_red'
									end)+'">'+(case when available_physical_memory_kb < 1024 then convert(varchar,available_physical_memory_kb)+' kb'
							when available_physical_memory_kb < 1024*1024 then convert(varchar,floor(available_physical_memory_kb/1024))+' mb'
							when available_physical_memory_kb < 1024*1024*1024 then convert(varchar,floor(available_physical_memory_kb/(1024*1024)))+' gb'
							when available_physical_memory_kb >= 1024*1024*1024 then convert(varchar,floor(available_physical_memory_kb/(1024*1024*1024)))+' tb'
							else 'xx' end)+'</td>'
					+'<td>'+system_high_memory_signal_state+'</td>'
					+'<td>'+(case when physical_memory_in_use_kb < 1024 then convert(varchar,physical_memory_in_use_kb)+' kb'
							when physical_memory_in_use_kb < 1024*1024 then convert(varchar,floor(physical_memory_in_use_kb/1024))+' mb'
							when physical_memory_in_use_kb < 1024*1024*1024 then convert(varchar,floor(physical_memory_in_use_kb/(1024*1024)))+' gb'
							when physical_memory_in_use_kb >= 1024*1024*1024 then convert(varchar,floor(physical_memory_in_use_kb/(1024*1024*1024)))+' tb'
							else 'xx' end)+'</td>'
					+'<td class="'+(case when memory_grants_pending > 0 then 'bg_red'
									else 'bg_none'
									end)+'">'+convert(varchar,isnull(memory_grants_pending,0))+'</td>'
					+'<td class="'+(case when connection_count >= 1200 then 'bg_red'
									when connection_count >= 1000 then 'bg_orange'
									when connection_count >= 800 then 'bg_yellow'
									else 'bg_none'
									end)+'">'+convert(varchar,connection_count)+'</td>'
					+'<td class="'+(case when waits_per_core_per_minute >= 300 then 'bg_red'
									when waits_per_core_per_minute >= 240 then 'bg_orange'
									when waits_per_core_per_minute >= 180 then 'bg_yellow'
									else 'bg_none'
									end)+'">'+isnull((case when waits_per_core_per_minute < 60 then convert(varchar,floor(waits_per_core_per_minute))+' sec'
							when waits_per_core_per_minute < 3600 then convert(varchar,floor(waits_per_core_per_minute/60))+' min'
							when waits_per_core_per_minute < 86400 then convert(varchar,floor(waits_per_core_per_minute/3600))+' hrs'
							when waits_per_core_per_minute >= 86400 then convert(varchar,floor(waits_per_core_per_minute/86400))+' days'
							else 'xx' end),'-1')+'</td>'
					+'</tr>' as [table_row]
			from asi cte
			where 1=1
			and (   os_cpu >= @os_cpu_threshold
				or  sql_cpu >= @sql_cpu_threshold 
				or  blocked_counts >= @blocked_counts_threshold
				or  blocked_duration_max_seconds >= @blocked_duration_max_seconds_threshold
				or  ( available_physical_memory_kb < (@available_physical_memory_mb_threshold*1024) 
					and system_high_memory_signal_state = @system_high_memory_signal_state_threshold 
					)
				or  memory_grants_pending > @memory_grants_pending_threshold
				or  connection_count >= @connection_count_threshold
				or  waits_per_core_per_minute > @waits_per_core_per_minute_threshold
				)
		)
		select @_table_data = coalesce(@_table_data+' '+[table_row],[table_row])
		from t_cte;

		set @_html_tempdb_health = @_table_headline+'<table border="1">'
						+'<thead>'+@_table_header+'</thead><tbody>'+@_table_data+'</tbody></table>';

		if @verbose > 0
		begin
			print '@_table_header => '+@_crlf+@_table_header;
			print @_line;
			print '@_table_data => '+@_crlf+ISNULL(@_table_data,'');
			print @_line;
			print '@_html_tempdb_health => '+@_crlf+ISNULL(@_html_tempdb_health,'');
		end
	end -- 'Tempdb Health'

	set @mail_subject = @mail_subject+' - '+convert(varchar,@_collection_time,120);

	set @_mail_body_html = '<html>'
						+N'<head>'
						+N'<title>'+@_title+'</title>'
						+@_style_css
						+N'</head>'
						+N'<body>'
						+N'<h1><a href="'+@dashboard_link+'" target="_blank">'+@_title+' - '+convert(varchar,@_collection_time,120)+'</a></h1>'
						+N'<p>'+@_html_core_health+'</p>'
						+N'<br><br><br><p>Regards,<br>Job ['+@job_name+']</p>'
						+N'</body>';	

	EXEC msdb.dbo.sp_send_dbmail @recipients = @recipients,
		@subject = @mail_subject,
		@body = @_mail_body_html,
		@body_format = 'HTML';

	
END
GO

EXEC dbo.usp_GetAllServerDashboardMail @recipients = 'ajay.dwivedi2007@gmail.com', @verbose = 2
go