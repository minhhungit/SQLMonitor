IF APP_NAME() = 'Microsoft SQL Server Management Studio - Query'
BEGIN
	SET QUOTED_IDENTIFIER OFF;
	SET ANSI_PADDING ON;
	SET CONCAT_NULL_YIELDS_NULL ON;
	SET ANSI_WARNINGS ON;
	SET NUMERIC_ROUNDABORT OFF;
	SET ARITHABORT ON;
END
GO

IF DB_NAME() = 'master'
	raiserror ('Kindly execute all queries in [DBA] database', 20, -1) with log;
go

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'usp_GetAllServerCollectedData')
    EXEC ('CREATE PROC dbo.usp_GetAllServerCollectedData AS SELECT ''stub version, to be replaced''')
GO

-- DROP PROCEDURE dbo.usp_GetAllServerCollectedData
go

ALTER PROCEDURE dbo.usp_GetAllServerCollectedData
(	@servers varchar(max) = null, /* comma separated list of servers to query */
	@result_to_table nvarchar(125), /* table that need to be populated */
	@verbose tinyint = 0, /* display debugging messages. 0 = No messages. 1 = Only print messages. 2 = Print & Table Results */
	@truncate_table bit = 1, /* when enabled, table would be truncated */
	@has_staging_table bit = 1 /* when enabled, assume there is no staging table */
)
	--WITH EXECUTE AS OWNER --,RECOMPILE
AS
BEGIN

	/*
		Version:		1.6.0
		Date:			2023-07-27 - Add truncate table feature
						2023-08-13 - Add dbo.disk_space_all_servers

		exec dbo.usp_GetAllServerCollectedData 
					@servers = 'Workstation,SqlPractice,SqlMonitor', 
					@result_to_table = 'dbo.sql_agent_jobs_all_servers',
					@truncate_table = 1,
					@has_staging_table = 1,
					@verbose = 2;
		https://stackoverflow.com/questions/10191193/how-to-test-linkedservers-connectivity-in-tsql
	*/
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET LOCK_TIMEOUT 60000; -- 60 seconds

	IF @result_to_table NOT IN ('dbo.sql_agent_jobs_all_servers','dbo.disk_space_all_servers','dbo.log_space_consumers_all_servers','dbo.tempdb_space_usage_all_servers')
		THROW 50001, '''result_to_table'' Parameter value is invalid.', 1;		

	DECLARE @_tbl_servers table (srv_name varchar(125));
	DECLARE @_linked_server_failed bit = 0;
	DECLARE @_sql NVARCHAR(max);
	DECLARE @_params NVARCHAR(max);
	DECLARE @_crlf NCHAR(2);
	DECLARE @_isLocalHost bit = 0;
	DECLARE @_int_variable int = 0;

	DECLARE @_srv_name	nvarchar (125);
	DECLARE @_at_server_name varchar (125);
	DECLARE @_staging_table nvarchar(125);

	SET @_staging_table = @result_to_table + (case when @has_staging_table = 1 then '__staging' else '' end);
	SET @_crlf = NCHAR(10)+NCHAR(13);

	IF @verbose >= 1
		PRINT 'Extracting server names from @servers ('+@servers+') parameter value..';
	;WITH t1(srv_name, [Servers]) AS 
	(
		SELECT	CAST(LEFT(@servers, CHARINDEX(',',@servers+',')-1) AS VARCHAR(500)) as srv_name,
				STUFF(@servers, 1, CHARINDEX(',',@servers+','), '') as [Servers]
		--
		UNION ALL
		--
		SELECT	CAST(LEFT([Servers], CHARINDEX(',',[Servers]+',')-1) AS VARChAR(500)) AS srv_name,
				STUFF([Servers], 1, CHARINDEX(',',[Servers]+','), '')  as [Servers]
		FROM t1
		WHERE [Servers] > ''	
	)
	INSERT @_tbl_servers (srv_name)
	SELECT ltrim(rtrim(srv_name))
	FROM t1
	OPTION (MAXRECURSION 32000);

	IF @verbose >= 2
	BEGIN
		SELECT @_int_variable = COUNT(1) FROM @_tbl_servers;
		PRINT 'No of servers to process => '+CONVERT(varchar,@_int_variable)+'';
		SELECT [RunningQuery] = 'select * from @_tbl_servers', *
		FROM @_tbl_servers;
	END

	IF @verbose >= 2
	BEGIN
		select distinct [RunningQuery] = 'Cursor-Servers', [srvname] = sql_instance
		from dbo.instance_details
		where is_available = 1 and is_enabled = 1
		and	(	(	@servers is null
				and	is_alias = 0
				)
			or	(	@servers is not null
				and	(	sql_instance in (select srv_name from @_tbl_servers) 
					--or	source_sql_instance in (select srv_name from @_tbl_servers)
					)
				)
			);
	END

	IF @truncate_table = 1
	BEGIN
		SET @_sql = 'truncate table '+@_staging_table+';';
		IF @verbose >= 1
			PRINT @_sql;
		EXEC (@_sql);
	END

	DECLARE cur_servers CURSOR LOCAL FORWARD_ONLY FOR
		select distinct [srvname] = sql_instance
		from dbo.instance_details
		where is_available = 1 and is_enabled = 1
		and	(	(	@servers is null
				and	is_alias = 0
				)
			or	(	@servers is not null
				and	(	sql_instance in (select srv_name from @_tbl_servers) 
					--or	source_sql_instance in (select srv_name from @_tbl_servers)
					)
				)
			);

	OPEN cur_servers;
	FETCH NEXT FROM cur_servers INTO @_srv_name;
	
	--set quoted_identifier off;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		if @verbose = 1
			print char(10)+'***** Looping through '+quotename(@_srv_name)+' *******';
		set @_linked_server_failed = 0;
		set @_at_server_name = NULL;

		-- If not local server
		if ( (CONVERT(varchar,SERVERPROPERTY('MachineName')) = @_srv_name) 
			or (CONVERT(varchar,SERVERPROPERTY('ServerName')) = @_srv_name)
			)
			set @_isLocalHost = 1
		else
		begin
			set @_isLocalHost = 0
			begin try
				--set @_sql = "SELECT	@@servername as srv_name;";
				--set @_sql = 'select * from openquery(' + QUOTENAME(@_srv_name) + ', "'+ @_sql + '")';
				exec sys.sp_testlinkedserver @_srv_name;
			end try
			begin catch
				print '	ERROR => Linked Server '+quotename(@_srv_name)+' not connecting.';

				set @_linked_server_failed = 1;
				--fetch next from cur_servers into @_srv_name;
				--continue;
			end catch;
		end


		-- dbo.sql_agent_jobs_all_servers
		if @_linked_server_failed = 0 and @result_to_table = 'dbo.sql_agent_jobs_all_servers'
		begin
			set @_sql =  "
SET QUOTED_IDENTIFIER ON;
select  [sql_instance] = '"+@_srv_name+"',
		jt.[JobName], jt.[JobCategory], jt.IsDisabled,
        [Last_RunTime] = DATEADD(mi, DATEDIFF(mi, getdate(), getutcdate()), js.[Last_RunTime] ),
		js.[Last_Run_Duration_Seconds],
        js.[Last_Run_Outcome], 
		[Expected_Max_Duration_Minutes] = jt.[Expected-Max-Duration(Min)],
		jt.Successfull_Execution_ClockTime_Threshold_Minutes,
        [Last_Successful_ExecutionTime] = DATEADD(mi, DATEDIFF(mi, getdate(), getutcdate()), js.[Last_Successful_ExecutionTime] ), 
        [Last_Successful_Execution_Hours] = datediff(hour,js.[Last_Successful_ExecutionTime],js.[Last_RunTime]),
        [Running_Since] = DATEADD(mi, DATEDIFF(mi, getdate(), getutcdate()), js.[Running_Since] ) , 
        js.[Running_StepName], js.[Running_Since_Min], js.[Session_Id], js.[Blocking_Session_Id], 
        [Next_RunTime] = DATEADD(mi, DATEDIFF(mi, getdate(), getutcdate()), js.[Next_RunTime] ), 
        js.[Total_Executions], js.[Total_Success_Count], js.[Total_Stopped_Count], js.[Total_Failed_Count], 
        [Success_Pcnt] = case when js.[Total_Executions] = 0 then 100 else (js.[Total_Success_Count]*100)/js.[Total_Executions] end,
        js.[Continous_Failures], js.[<10-Min], js.[10-Min], js.[30-Min], js.[1-Hrs], js.[2-Hrs], js.[3-Hrs], 
        js.[6-Hrs], js.[9-Hrs], js.[12-Hrs], js.[18-Hrs], js.[24-Hrs], js.[36-Hrs], js.[48-Hrs],
        [Is_Running] = case when Running_Since is not null then 1 else 0 end
		,[UpdatedDateUTC] = COALESCE(	MAX(js.UpdatedDateUTC) OVER (),
									MAX(js.CollectionTimeUTC) OVER (),
									MAX(jt.CollectionTimeUTC) OVER ()
								  )
from [dbo].[sql_agent_job_thresholds] jt
left join [dbo].[sql_agent_job_stats] js
	on jt.JobName = js.JobName
where 1=1
"
			-- Decorate for remote query if LinkedServer
			if @_isLocalHost = 0
				set @_sql = 'select * from openquery(' + QUOTENAME(@_srv_name) + ', "'+ @_sql + '")';
			if @verbose >= 1
				print @_crlf+@_sql+@_crlf;
		
			begin try
				insert into [dbo].[sql_agent_jobs_all_servers__staging]
				(	[sql_instance], [JobName], [JobCategory], [IsDisabled], [Last_RunTime], [Last_Run_Duration_Seconds], [Last_Run_Outcome], 
					[Expected_Max_Duration_Minutes], [Successfull_Execution_ClockTime_Threshold_Minutes],
					[Last_Successful_ExecutionTime], [Last_Successful_Execution_Hours], [Running_Since], 
					[Running_StepName], [Running_Since_Min], [Session_Id], [Blocking_Session_Id], 
					[Next_RunTime], [Total_Executions], [Total_Success_Count], [Total_Stopped_Count], 
					[Total_Failed_Count], [Success_Pcnt], [Continous_Failures], [<10-Min], [10-Min], 
					[30-Min], [1-Hrs], [2-Hrs], [3-Hrs], [6-Hrs], [9-Hrs], [12-Hrs], [18-Hrs], 
					[24-Hrs], [36-Hrs], [48-Hrs], [Is_Running], [UpdatedDateUTC]
				)
				exec (@_sql);
			end try
			begin catch
				-- print @_sql;
				print char(10)+char(13)+'Error occurred while executing below query on '+quotename(@_srv_name)+char(10)+'     '+@_sql;
				print  '	ErrorNumber => '+convert(varchar,ERROR_NUMBER());
				print  '	ErrorSeverity => '+convert(varchar,ERROR_SEVERITY());
				print  '	ErrorState => '+convert(varchar,ERROR_STATE());
				--print  '	ErrorProcedure => '+ERROR_PROCEDURE();
				print  '	ErrorLine => '+convert(varchar,ERROR_LINE());
				print  '	ErrorMessage => '+ERROR_MESSAGE();
			end catch
		end


		-- dbo.disk_space_all_servers
		if @_linked_server_failed = 0 and @result_to_table = 'dbo.disk_space_all_servers'
		begin
			set @_sql =  "
SET QUOTED_IDENTIFIER ON;
select  [sql_instance] = '"+@_srv_name+"',
		[host_name], [disk_volume], [label], [capacity_mb], [free_mb], [block_size], [filesystem], 
		[updated_date_utc] = [collection_time_utc]
from [dbo].[disk_space] ds
where 1=1
and ds.collection_time_utc = (select top 1 l.collection_time_utc from dbo.disk_space l order by l.collection_time_utc desc);
"
			-- Decorate for remote query if LinkedServer
			if @_isLocalHost = 0
				set @_sql = 'select * from openquery(' + QUOTENAME(@_srv_name) + ', "'+ @_sql + '")';
			if @verbose >= 1
				print @_crlf+@_sql+@_crlf;
		
			begin try
				insert into [dbo].[disk_space_all_servers__staging]
				(	[sql_instance], [host_name], [disk_volume], [label], [capacity_mb], [free_mb], [block_size], [filesystem], [updated_date_utc] )
				exec (@_sql);
			end try
			begin catch
				-- print @_sql;
				print char(10)+char(13)+'Error occurred while executing below query on '+quotename(@_srv_name)+char(10)+'     '+@_sql;
				print  '	ErrorNumber => '+convert(varchar,ERROR_NUMBER());
				print  '	ErrorSeverity => '+convert(varchar,ERROR_SEVERITY());
				print  '	ErrorState => '+convert(varchar,ERROR_STATE());
				--print  '	ErrorProcedure => '+ERROR_PROCEDURE();
				print  '	ErrorLine => '+convert(varchar,ERROR_LINE());
				print  '	ErrorMessage => '+ERROR_MESSAGE();
			end catch
		end


		-- dbo.log_space_consumers_all_servers
		if @_linked_server_failed = 0 and @result_to_table = 'dbo.log_space_consumers_all_servers'
		begin
			set @_sql =  "
SET QUOTED_IDENTIFIER ON;
select  [sql_instance] = '"+@_srv_name+"',
		[database_name], [recovery_model], [log_reuse_wait_desc], [log_size_mb], [log_used_mb], [exists_valid_autogrowing_file],
		[log_used_pct], [log_used_pct_threshold], [log_used_gb_threshold], [spid], [transaction_start_time], [login_name], 
		[program_name], [host_name], [host_process_id], [command], [additional_info], [action_taken], [sql_text],
		[is_pct_threshold_valid], [is_gb_threshold_valid], [threshold_condition], [thresholds_validated],
		[updated_date_utc] = DATEADD(mi, DATEDIFF(mi, getdate(), getutcdate()), [collection_time])
from [dbo].[log_space_consumers] lsc
where lsc.collection_time = (select top 1 l.collection_time from dbo.log_space_consumers l order by l.collection_time desc);
"
			-- Decorate for remote query if LinkedServer
			if @_isLocalHost = 0
				set @_sql = 'select * from openquery(' + QUOTENAME(@_srv_name) + ', "'+ @_sql + '")';
			if @verbose >= 1
				print @_crlf+@_sql+@_crlf;
		
			begin try
				insert into [dbo].[log_space_consumers_all_servers__staging]
				(	[sql_instance], [database_name], [recovery_model], [log_reuse_wait_desc], [log_size_mb], [log_used_mb], [exists_valid_autogrowing_file],
					[log_used_pct], [log_used_pct_threshold], [log_used_gb_threshold], [spid], [transaction_start_time], [login_name], [program_name], 
					[host_name], [host_process_id], [command], [additional_info], [action_taken], [sql_text], 
					[is_pct_threshold_valid], [is_gb_threshold_valid], [threshold_condition], [thresholds_validated], [updated_date_utc] 
				)
				exec (@_sql);
			end try
			begin catch
				-- print @_sql;
				print char(10)+char(13)+'Error occurred while executing below query on '+quotename(@_srv_name)+char(10)+'     '+@_sql;
				print  '	ErrorNumber => '+convert(varchar,ERROR_NUMBER());
				print  '	ErrorSeverity => '+convert(varchar,ERROR_SEVERITY());
				print  '	ErrorState => '+convert(varchar,ERROR_STATE());
				--print  '	ErrorProcedure => '+ERROR_PROCEDURE();
				print  '	ErrorLine => '+convert(varchar,ERROR_LINE());
				print  '	ErrorMessage => '+ERROR_MESSAGE();
			end catch
		end

		-- dbo.tempdb_space_usage_all_servers
		if @_linked_server_failed = 0 and @result_to_table = 'dbo.tempdb_space_usage_all_servers'
		begin
			set @_sql =  "
SET QUOTED_IDENTIFIER ON;
select  [sql_instance] = '"+@_srv_name+"',
		[data_size_mb], [data_used_mb], [data_used_pct], [log_size_mb], [log_used_mb], [log_used_pct], [version_store_mb], [version_store_pct],
		[updated_date_utc] = DATEADD(mi, DATEDIFF(mi, getdate(), getutcdate()), [collection_time])
from dbo.tempdb_space_usage tsu
where tsu.collection_time = (select top 1 l.collection_time from dbo.tempdb_space_usage l order by l.collection_time desc);
"
			-- Decorate for remote query if LinkedServer
			if @_isLocalHost = 0
				set @_sql = 'select * from openquery(' + QUOTENAME(@_srv_name) + ', "'+ @_sql + '")';
			if @verbose >= 1
				print @_crlf+@_sql+@_crlf;
		
			begin try
				insert into [dbo].[tempdb_space_usage_all_servers__staging]
				(	[sql_instance], [data_size_mb], [data_used_mb], [data_used_pct], [log_size_mb], [log_used_mb], 
					[log_used_pct], [version_store_mb], [version_store_pct], [updated_date_utc]
				)
				exec (@_sql);
			end try
			begin catch
				-- print @_sql;
				print char(10)+char(13)+'Error occurred while executing below query on '+quotename(@_srv_name)+char(10)+'     '+@_sql;
				print  '	ErrorNumber => '+convert(varchar,ERROR_NUMBER());
				print  '	ErrorSeverity => '+convert(varchar,ERROR_SEVERITY());
				print  '	ErrorState => '+convert(varchar,ERROR_STATE());
				--print  '	ErrorProcedure => '+ERROR_PROCEDURE();
				print  '	ErrorLine => '+convert(varchar,ERROR_LINE());
				print  '	ErrorMessage => '+ERROR_MESSAGE();
			end catch
		end


		-- All the logic should be within the Cursor Loop block
		FETCH NEXT FROM cur_servers INTO @_srv_name;
	END
	
	
	CLOSE cur_servers;  
	DEALLOCATE cur_servers;

	IF @has_staging_table = 1
	BEGIN
		SET @_sql =
		'BEGIN TRAN
			TRUNCATE TABLE '+@result_to_table+';
			ALTER TABLE '+@result_to_table+'__staging SWITCH TO '+@result_to_table+';
		COMMIT TRAN';
		IF @verbose >= 1
			print @_crlf+@_sql+@_crlf;
		EXEC (@_sql);
	END

	PRINT 'Transaction Counts => '+convert(varchar,@@trancount);
END
set quoted_identifier on;
GO
