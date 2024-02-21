/*
	Version -> 2024-Feb-21
	-----------------
	2024-02-21 - Enhancement#30 - Add flag for choice of MemoryOptimized Tables 
	2023-10-16 - Enhancement#5 - Dashboard for AlwaysOn Latency
	2023-07-14 - Enhancement#268 - Add tables sql_agent_job_stats & memory_clerks in Collection Latency Dashboard
	2023-06-16 - Enhancement#262 - Add is_enabled on Inventory.DBA.dbo.instance_details
	2022-03-31 - Enhancement#227 - Add CollectionTime of Each Table Data
*/

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

DECLARE @MemoryOptimizedObjectUsage bit = 1;
IF @MemoryOptimizedObjectUsage = 1
	EXEC ('ALTER DATABASE CURRENT SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = ON');
go

DECLARE @MemoryOptimizedObjectUsage bit = 1;
if not exists (select * from sys.filegroups where name = 'MemoryOptimized') and (@MemoryOptimizedObjectUsage = 1)
	EXEC ('ALTER DATABASE CURRENT ADD FILEGROUP MemoryOptimized CONTAINS MEMORY_OPTIMIZED_DATA');
go

DECLARE @MemoryOptimizedObjectUsage bit = 1;
if not exists (select * from sys.database_files where name = 'MemoryOptimized') and (@MemoryOptimizedObjectUsage = 1)
	EXEC ('ALTER DATABASE CURRENT ADD FILE (name=''MemoryOptimized'', filename=''E:\Data\MemoryOptimized.ndf'') TO FILEGROUP MemoryOptimized');
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[all_server_stable_info]') AND type in (N'U'))
	DROP TABLE [dbo].[all_server_stable_info]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[all_server_volatile_info]') AND type in (N'U'))
	DROP TABLE [dbo].[all_server_volatile_info]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[all_server_volatile_info_history]') AND type in (N'U'))
	DROP TABLE [dbo].[all_server_volatile_info_history]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[all_server_collection_latency_info]') AND type in (N'U'))
	DROP TABLE [dbo].[all_server_collection_latency_info]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sql_agent_jobs_all_servers]') AND type in (N'U'))
	DROP TABLE [dbo].[sql_agent_jobs_all_servers]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sql_agent_jobs_all_servers__staging]') AND type in (N'U'))
	DROP TABLE [dbo].[sql_agent_jobs_all_servers__staging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[disk_space_all_servers__staging]') AND type in (N'U'))
	DROP TABLE [dbo].[disk_space_all_servers__staging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[disk_space_all_servers]') AND type in (N'U'))
	DROP TABLE [dbo].[disk_space_all_servers]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[log_space_consumers_all_servers__staging]') AND type in (N'U'))
	DROP TABLE [dbo].[log_space_consumers_all_servers__staging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[log_space_consumers_all_servers]') AND type in (N'U'))
	DROP TABLE [dbo].[log_space_consumers_all_servers]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tempdb_space_usage_all_servers__staging]') AND type in (N'U'))
	DROP TABLE [dbo].[tempdb_space_usage_all_servers__staging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tempdb_space_usage_all_servers]') AND type in (N'U'))
	DROP TABLE [dbo].[tempdb_space_usage_all_servers]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ag_health_state_all_servers]') AND type in (N'U'))
	DROP TABLE [dbo].[ag_health_state_all_servers]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ag_health_state_all_servers__staging]') AND type in (N'U'))
	DROP TABLE [dbo].[ag_health_state_all_servers__staging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[backups_all_servers]') AND type in (N'U'))
	DROP TABLE [dbo].[backups_all_servers]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[backups_all_servers__staging]') AND type in (N'U'))
	DROP TABLE [dbo].[backups_all_servers__staging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[services_all_servers]') AND type in (N'U'))
	DROP TABLE [dbo].[services_all_servers]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[services_all_servers__staging]') AND type in (N'U'))
	DROP TABLE [dbo].[services_all_servers__staging]
GO

DECLARE @_sql NVARCHAR(MAX);
DECLARE @MemoryOptimizedObjectUsage bit = 1;

SET @_sql = '
CREATE TABLE [dbo].[all_server_stable_info]
(
	[srv_name] [varchar](125) NOT NULL,
	[at_server_name] [varchar](125) NULL,
	[machine_name] [varchar](125) NULL,
	[server_name] [varchar](125) NULL,
	[ip] [varchar](30) NULL,
	[domain] [varchar](125) NULL,
	[host_name] [varchar](125) NULL,
	[fqdn] [varchar](225) NULL,
	[host_distribution] [varchar](200),  
	[processor_name] [varchar](200),
	[product_version] [varchar](30) NULL,
	[edition] [varchar](50) NULL,
	[sqlserver_start_time_utc] [datetime2](7) NULL,
	[total_physical_memory_kb] [bigint] NULL,
	[os_start_time_utc] [datetime2](7) NULL,
	[cpu_count] [smallint] NULL,
	[scheduler_count] [smallint] NULL,
	[major_version_number] [smallint] NULL,
	[minor_version_number] [smallint] NULL,
	[collection_time] [datetime2] NULL default sysdatetime(),

	'+(case when @MemoryOptimizedObjectUsage = 1 then '' else '--' end)+'CONSTRAINT pk_all_server_stable_info primary key nonclustered ([srv_name])
	'+(case when @MemoryOptimizedObjectUsage = 0 then '' else '--' end)+'CONSTRAINT pk_all_server_stable_info primary key clustered ([srv_name])
)
'+(case when @MemoryOptimizedObjectUsage = 1 then '' else '--' end)+'WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);';

EXEC (@_sql);
GO

DECLARE @_sql NVARCHAR(MAX);
DECLARE @MemoryOptimizedObjectUsage bit = 1;

SET @_sql = '
CREATE TABLE [dbo].[all_server_volatile_info]
(
	[srv_name] [varchar](125) NOT NULL,
	[os_cpu] [decimal](20, 2) NULL,
	[sql_cpu] [decimal](20, 2) NULL,
	[pcnt_kernel_mode] [decimal](20, 2) NULL,
	[page_faults_kb] [decimal](20, 2) NULL,
	[blocked_counts] [int] NULL DEFAULT 0,
	[blocked_duration_max_seconds] [bigint] NULL DEFAULT 0,
	[available_physical_memory_kb] [bigint] NULL,
	[system_high_memory_signal_state] [varchar](20) NULL,
	[physical_memory_in_use_kb] [decimal](20, 2) NULL,
	[memory_grants_pending] [int] NULL,
	[connection_count] [int] NULL DEFAULT 0,
	[active_requests_count] [int] NULL DEFAULT 0,
	[waits_per_core_per_minute] [decimal](20, 2) NULL DEFAULT 0,
	[collection_time] [datetime2] NULL default sysdatetime(),

	'+(case when @MemoryOptimizedObjectUsage = 1 then '' else '--' end)+'CONSTRAINT pk_all_server_volatile_info primary key nonclustered ([srv_name])
	'+(case when @MemoryOptimizedObjectUsage = 0 then '' else '--' end)+'CONSTRAINT pk_all_server_volatile_info primary key clustered ([srv_name])
)
'+(case when @MemoryOptimizedObjectUsage = 1 then '' else '--' end)+'WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);';

EXEC (@_sql);
GO

CREATE TABLE [dbo].[all_server_collection_latency_info]
(
	[srv_name] [varchar](125) NOT NULL,
	[host_name] [varchar](125) NULL,
	[performance_counters__latency_minutes] int null,
	[xevent_metrics__latency_minutes] int null,
	[WhoIsActive__latency_minutes] int null,
	[os_task_list__latency_minutes] int null,
	[disk_space__latency_minutes] int null,
	[file_io_stats__latency_minutes] int null,
	[sql_agent_job_stats__latency_minutes] int null,
	[memory_clerks__latency_minutes] int null,
	[wait_stats__latency_minutes] int null,
	[BlitzIndex__latency_days] int null,
	[BlitzIndex_Mode0__latency_days] int null,
	[BlitzIndex_Mode1__latency_days] int null,
	[BlitzIndex_Mode4__latency_days] int null,
	[collection_time] [datetime2] NULL default sysdatetime(),
	INDEX ci_all_server_collection_latency_info unique nonclustered ([srv_name],[host_name])
)
GO

CREATE TABLE [dbo].[all_server_volatile_info_history]
(
	[collection_time] [datetime2] NULL default sysdatetime(),
	[srv_name] [varchar](125) NOT NULL,
	[os_cpu] [decimal](20, 2) NULL,
	[sql_cpu] [decimal](20, 2) NULL,
	[pcnt_kernel_mode] [decimal](20, 2) NULL,
	[page_faults_kb] [decimal](20, 2) NULL,
	[blocked_counts] [int] NULL DEFAULT 0,
	[blocked_duration_max_seconds] [bigint] NULL DEFAULT 0,
	[available_physical_memory_kb] [bigint] NULL,
	[system_high_memory_signal_state] [varchar](20) NULL,
	[physical_memory_in_use_kb] [decimal](20, 2) NULL,
	[memory_grants_pending] [int] NULL,
	[connection_count] [int] NULL DEFAULT 0,
	[active_requests_count] [int] NULL DEFAULT 0,
	[waits_per_core_per_minute] [decimal](20, 2) NULL DEFAULT 0,	
	INDEX ci_all_server_volatile_info_history clustered ([collection_time],[srv_name])
)
GO

CREATE TABLE [dbo].[sql_agent_jobs_all_servers]
(
	[sql_instance] [varchar](255) NOT NULL,
	[JobName] [varchar](255) NOT NULL,
	[JobCategory] [varchar](255) NOT NULL,
	[IsDisabled] [bit] NOT NULL,
	[Last_RunTime] [datetime2](7) NULL,
	[Last_Run_Duration_Seconds] [int] NULL,
	[Last_Run_Outcome] [varchar](50) NULL,
	[Expected_Max_Duration_Minutes] [int] NULL,
	[Successfull_Execution_ClockTime_Threshold_Minutes] [int] NULL,
	[Last_Successful_ExecutionTime] [datetime2](7) NULL,
	[Last_Successful_Execution_Hours] [int] NULL,
	[Running_Since] [datetime2](7) NULL,
	[Running_StepName] [varchar](250) NULL,
	[Running_Since_Min] [bigint] NULL,
	[Session_Id] [int] NULL,
	[Blocking_Session_Id] [int] NULL,
	[Next_RunTime] [datetime2](7) NULL,
	[Total_Executions] [bigint] NULL,
	[Total_Success_Count] [bigint] NULL,
	[Total_Stopped_Count] [bigint] NULL,
	[Total_Failed_Count] [bigint] NULL,
	[Success_Pcnt] [bigint] NULL,
	[Continous_Failures] [int] NULL,
	[<10-Min] [bigint] NULL,
	[10-Min] [bigint] NULL,
	[30-Min] [bigint] NULL,
	[1-Hrs] [bigint] NULL,
	[2-Hrs] [bigint] NULL,
	[3-Hrs] [bigint] NULL,
	[6-Hrs] [bigint] NULL,
	[9-Hrs] [bigint] NULL,
	[12-Hrs] [bigint] NULL,
	[18-Hrs] [bigint] NULL,
	[24-Hrs] [bigint] NULL,
	[36-Hrs] [bigint] NULL,
	[48-Hrs] [bigint] NULL,
	[Is_Running] [int] NOT NULL,

	[UpdatedDateUTC] datetime2 NOT NULL,
	[CollectionTimeUTC] datetime2 NOT NULL DEFAULT GETUTCDATE() 

	,CONSTRAINT pk_sql_agent_jobs_all_servers PRIMARY KEY CLUSTERED ([sql_instance], [JobName])
	,INDEX [JobName] NONCLUSTERED ([JobName])
)
GO

CREATE TABLE [dbo].[sql_agent_jobs_all_servers__staging]
(
	[sql_instance] [varchar](255) NOT NULL,
	[JobName] [varchar](255) NOT NULL,
	[JobCategory] [varchar](255) NOT NULL,
	[IsDisabled] [bit] NOT NULL,
	[Last_RunTime] [datetime2](7) NULL,
	[Last_Run_Duration_Seconds] [int] NULL,
	[Last_Run_Outcome] [varchar](50) NULL,
	[Expected_Max_Duration_Minutes] [int] NULL,
	[Successfull_Execution_ClockTime_Threshold_Minutes] [int] NULL,
	[Last_Successful_ExecutionTime] [datetime2](7) NULL,
	[Last_Successful_Execution_Hours] [int] NULL,
	[Running_Since] [datetime2](7) NULL,
	[Running_StepName] [varchar](250) NULL,
	[Running_Since_Min] [bigint] NULL,
	[Session_Id] [int] NULL,
	[Blocking_Session_Id] [int] NULL,
	[Next_RunTime] [datetime2](7) NULL,
	[Total_Executions] [bigint] NULL,
	[Total_Success_Count] [bigint] NULL,
	[Total_Stopped_Count] [bigint] NULL,
	[Total_Failed_Count] [bigint] NULL,
	[Success_Pcnt] [bigint] NULL,
	[Continous_Failures] [int] NULL,
	[<10-Min] [bigint] NULL,
	[10-Min] [bigint] NULL,
	[30-Min] [bigint] NULL,
	[1-Hrs] [bigint] NULL,
	[2-Hrs] [bigint] NULL,
	[3-Hrs] [bigint] NULL,
	[6-Hrs] [bigint] NULL,
	[9-Hrs] [bigint] NULL,
	[12-Hrs] [bigint] NULL,
	[18-Hrs] [bigint] NULL,
	[24-Hrs] [bigint] NULL,
	[36-Hrs] [bigint] NULL,
	[48-Hrs] [bigint] NULL,
	[Is_Running] [int] NOT NULL,

	[UpdatedDateUTC] datetime2 NOT NULL,
	[CollectionTimeUTC] datetime2 NOT NULL DEFAULT GETUTCDATE() 

	,CONSTRAINT pk_sql_agent_jobs_all_servers__staging PRIMARY KEY CLUSTERED ([sql_instance], [JobName])
	,INDEX [JobName] NONCLUSTERED ([JobName])
)
GO

CREATE TABLE [dbo].[disk_space_all_servers]
(
	[sql_instance] [varchar](255) NOT NULL,	
	[host_name] [varchar](125) NOT NULL,
	[disk_volume] [varchar](255) NOT NULL,
	[label] [varchar](125) NULL,
	[capacity_mb] [decimal](20,2) NOT NULL,
	[free_mb] [decimal](20,2) NOT NULL,
	[block_size] [int] NULL,
	[filesystem] [varchar](125) NULL,

	[updated_date_utc] datetime2 NOT NULL,
	[collection_time_utc] datetime2 NOT NULL DEFAULT GETUTCDATE(),

	INDEX ci_disk_space_all_servers CLUSTERED ([sql_instance])
)
go

CREATE TABLE [dbo].[disk_space_all_servers__staging]
(
	[sql_instance] [varchar](255) NOT NULL,	
	[host_name] [varchar](125) NOT NULL,
	[disk_volume] [varchar](255) NOT NULL,
	[label] [varchar](125) NULL,
	[capacity_mb] [decimal](20,2) NOT NULL,
	[free_mb] [decimal](20,2) NOT NULL,
	[block_size] [int] NULL,
	[filesystem] [varchar](125) NULL,

	[updated_date_utc] datetime2 NOT NULL,
	[collection_time_utc] datetime2 NOT NULL DEFAULT GETUTCDATE(),

	INDEX ci_disk_space_all_servers__staging CLUSTERED ([sql_instance])
)
go

CREATE TABLE [dbo].[log_space_consumers_all_servers]
(
	[sql_instance] [varchar](255) NOT NULL,
	[database_name] sysname not null,
	[recovery_model] varchar(20) not null,
	[log_reuse_wait_desc] varchar(125) not null,
	[log_size_mb] decimal(20, 2) not null,
	[log_used_mb] decimal(20, 2) not null,
	[exists_valid_autogrowing_file] bit null,
	[log_used_pct] decimal(10, 2) default 0.0 not null,
	[log_used_pct_threshold] decimal(10,2) not null,
	[log_used_gb_threshold] decimal(20,2) null,
	[spid] int null,
	[transaction_start_time] datetime null,
	[login_name] sysname null,
	[program_name] sysname null,
	[host_name] sysname null,
	[host_process_id] int null,
	[command] varchar(16) null,
	[additional_info] varchar(255) null,
	[action_taken] varchar(100) null,
	[sql_text] varchar(max) null,	
	[is_pct_threshold_valid] bit default 0 not null,
	[is_gb_threshold_valid] bit default 0 not null,
	[threshold_condition] varchar(5) not null,
	[thresholds_validated] bit default 0 not null,

	[updated_date_utc] datetime2 NOT NULL,
	[collection_time_utc] datetime2 NOT NULL DEFAULT GETUTCDATE(),

	INDEX ci_log_space_consumers_all_servers CLUSTERED ([sql_instance])
);
go

CREATE TABLE [dbo].[log_space_consumers_all_servers__staging]
(
	[sql_instance] [varchar](255) NOT NULL,
	[database_name] sysname not null,
	[recovery_model] varchar(20) not null,
	[log_reuse_wait_desc] varchar(125) not null,
	[log_size_mb] decimal(20, 2) not null,
	[log_used_mb] decimal(20, 2) not null,
	[exists_valid_autogrowing_file] bit null,
	[log_used_pct] decimal(10, 2) default 0.0 not null,
	[log_used_pct_threshold] decimal(10,2) not null,
	[log_used_gb_threshold] decimal(20,2) null,
	[spid] int null,
	[transaction_start_time] datetime null,
	[login_name] sysname null,
	[program_name] sysname null,
	[host_name] sysname null,
	[host_process_id] int null,
	[command] varchar(16) null,
	[additional_info] varchar(255) null,
	[action_taken] varchar(100) null,
	[sql_text] varchar(max) null,	
	[is_pct_threshold_valid] bit default 0 not null,
	[is_gb_threshold_valid] bit default 0 not null,
	[threshold_condition] varchar(5) not null,
	[thresholds_validated] bit default 0 not null,

	[updated_date_utc] datetime2 NOT NULL,
	[collection_time_utc] datetime2 NOT NULL DEFAULT GETUTCDATE(),

	INDEX ci_log_space_consumers_all_servers__staging CLUSTERED ([sql_instance])
);
go

CREATE TABLE dbo.tempdb_space_usage_all_servers
(	
	[sql_instance] [varchar](255) NOT NULL,
	[data_size_mb] decimal(20,2) not null,
	[data_used_mb] decimal(20,2) not null, 
	[data_used_pct] decimal(5,2) not null, 
	[log_size_mb] decimal(20,2) not null,
	[log_used_mb] decimal(20,2) null,
	[log_used_pct] decimal(5,2) null,
	[version_store_mb] decimal(20,2) null,
	[version_store_pct] decimal(20,2) null,

	[updated_date_utc] datetime2 NOT NULL,
	[collection_time_utc] datetime2 NOT NULL DEFAULT GETUTCDATE(),

	INDEX [CI_tempdb_space_usage_all_servers] clustered ([sql_instance])
);
go

CREATE TABLE dbo.tempdb_space_usage_all_servers__staging
(	
	[sql_instance] [varchar](255) NOT NULL,
	[data_size_mb] decimal(20,2) not null,
	[data_used_mb] decimal(20,2) not null, 
	[data_used_pct] decimal(5,2) not null, 
	[log_size_mb] decimal(20,2) not null,
	[log_used_mb] decimal(20,2) null,
	[log_used_pct] decimal(5,2) null,
	[version_store_mb] decimal(20,2) null,
	[version_store_pct] decimal(20,2) null,

	[updated_date_utc] datetime2 NOT NULL,
	[collection_time_utc] datetime2 NOT NULL DEFAULT GETUTCDATE(),

	INDEX [CI_tempdb_space_usage_all_servers__staging] clustered ([sql_instance])
);
go

CREATE TABLE dbo.ag_health_state_all_servers
(	
	[sql_instance] [varchar](255) not null,
	[replica_server_name] [varchar](255) NULL,
	[is_primary_replica] [bit] not null,
	[database_name] [varchar](255) not null,
	[ag_name] [sysname] not null,
	[ag_listener] [varchar](114) null,
	[is_local] [bit] not null,
	[is_distributed] [bit] not null,
	[synchronization_state_desc] [varchar](60) NULL,
	[synchronization_health_desc] [varchar](60) NULL,
	[latency_seconds] [bigint] NULL,
	[redo_queue_size] [bigint] NULL,
	[log_send_queue_size] [bigint] NULL,
	[last_redone_time] [datetime] NULL,
	[log_send_rate] [bigint] NULL,
	[redo_rate] [bigint] NULL,
	[estimated_redo_completion_time_min] [numeric](26, 6) NULL,
	[last_commit_time] [datetime] NULL,
	[is_suspended] [bit] NULL,
	[suspend_reason_desc] [varchar](125) NULL,

	[updated_date_utc] datetime2 NOT NULL,
	[collection_time_utc] datetime2 NOT NULL DEFAULT GETUTCDATE(),

	index [CI_ag_health_state_all_servers] clustered ([sql_instance], [replica_server_name]),
	index [replica_server_name__database_name] nonclustered ([replica_server_name], [database_name])
);
go

CREATE TABLE dbo.ag_health_state_all_servers__staging
(	
	[sql_instance] [varchar](255) not null,
	[replica_server_name] [varchar](255) NULL,
	[is_primary_replica] [bit] not null,
	[database_name] [varchar](255) not null,
	[ag_name] [sysname] not null,
	[ag_listener] [varchar](114) null,
	[is_local] [bit] not null,
	[is_distributed] [bit] not null,
	[synchronization_state_desc] [varchar](60) NULL,
	[synchronization_health_desc] [varchar](60) NULL,
	[latency_seconds] [bigint] NULL,
	[redo_queue_size] [bigint] NULL,
	[log_send_queue_size] [bigint] NULL,
	[last_redone_time] [datetime] NULL,
	[log_send_rate] [bigint] NULL,
	[redo_rate] [bigint] NULL,
	[estimated_redo_completion_time_min] [numeric](26, 6) NULL,
	[last_commit_time] [datetime] NULL,
	[is_suspended] [bit] NULL,
	[suspend_reason_desc] [varchar](125) NULL,

	[updated_date_utc] datetime2 NOT NULL,
	[collection_time_utc] datetime2 NOT NULL DEFAULT GETUTCDATE(),

	index [CI_ag_health_state_all_servers__staging] clustered ([sql_instance], [replica_server_name]),
	index [replica_server_name__database_name] nonclustered ([replica_server_name], [database_name])
);
go

if not exists (select 1 from dbo.purge_table where table_name = 'dbo.all_server_volatile_info_history')
begin
	insert dbo.purge_table
	(table_name, date_key, retention_days, purge_row_size, reference)
	select	table_name = 'dbo.all_server_volatile_info_history', 
			date_key = 'collection_time', 
			retention_days = 1, 
			purge_row_size = 1000,
			reference = 'SQLMonitor Data Collection'
end
go

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'usp_populate__all_server_volatile_info_history')
    EXEC ('CREATE PROC dbo.usp_populate__all_server_volatile_info_history AS SELECT ''stub version, to be replaced''')
GO

ALTER PROCEDURE dbo.usp_populate__all_server_volatile_info_history
AS
BEGIN
	SET NOCOUNT ON;
	INSERT dbo.all_server_volatile_info_history
	(	[collection_time], [srv_name], [os_cpu], [sql_cpu], [pcnt_kernel_mode], [page_faults_kb], [blocked_counts], 
		[blocked_duration_max_seconds], [available_physical_memory_kb], [system_high_memory_signal_state], 
		[physical_memory_in_use_kb], [memory_grants_pending], [connection_count], [active_requests_count], 
		[waits_per_core_per_minute] )
	select [collection_time], [srv_name], [os_cpu], [sql_cpu], [pcnt_kernel_mode], [page_faults_kb], [blocked_counts], 
		[blocked_duration_max_seconds], [available_physical_memory_kb], [system_high_memory_signal_state], 
		[physical_memory_in_use_kb], [memory_grants_pending], [connection_count], [active_requests_count], 
		[waits_per_core_per_minute]
	from dbo.all_server_volatile_info vi
END
go

if OBJECT_ID('dbo.vw_all_server_info') is null
	exec ('create view dbo.vw_all_server_info as select 1 as dummy;');
go

alter view dbo.vw_all_server_info
--with schemabinding
as
	select	si.srv_name, 
			/* stable info */
			at_server_name, machine_name, server_name, ip, domain, host_name, host_distribution, processor_name, product_version, edition, sqlserver_start_time_utc, total_physical_memory_kb, os_start_time_utc, cpu_count, scheduler_count, major_version_number, minor_version_number,
			/* volatile info */
			os_cpu, sql_cpu, pcnt_kernel_mode, page_faults_kb, blocked_counts, blocked_duration_max_seconds, available_physical_memory_kb, system_high_memory_signal_state, physical_memory_in_use_kb, memory_grants_pending, connection_count, active_requests_count, waits_per_core_per_minute
	from dbo.all_server_stable_info as si
	left join dbo.all_server_volatile_info as vi
	on si.srv_name = vi.srv_name;
go


IF APP_NAME() = 'Microsoft SQL Server Management Studio - Query'
BEGIN
	SET NOCOUNT ON;

	-- Stable Info
	if	( (select count(1) from dbo.all_server_stable_info) <> (select count(distinct sql_instance) from dbo.instance_details) )
		or ( (select max(collection_time) from  dbo.all_server_stable_info) < dateadd(MINUTE, -30, SYSDATETIME()) )
	begin
		exec dbo.usp_GetAllServerInfo @result_to_table = 'dbo.all_server_stable_info',
					@output = 'srv_name, at_server_name, machine_name, server_name, ip, domain, host_name, product_version, edition, sqlserver_start_time_utc, total_physical_memory_kb, os_start_time_utc, cpu_count, scheduler_count, major_version_number, minor_version_number';
	end
	--select * from dbo.all_server_stable_info;

	-- Volatile Info
	exec dbo.usp_GetAllServerInfo @result_to_table = 'dbo.all_server_volatile_info',
				@output = 'srv_name, os_cpu, sql_cpu, pcnt_kernel_mode, page_faults_kb, blocked_counts, blocked_duration_max_seconds, available_physical_memory_kb, system_high_memory_signal_state, physical_memory_in_use_kb, memory_grants_pending, connection_count, active_requests_count, waits_per_core_per_minute';
	--select * from dbo.all_server_volatile_info;

	select * 
	from dbo.vw_all_server_info si
	--where si.srv_name = convert(varchar,SERVERPROPERTY('ServerName'))
END
GO

if not exists (select * from sys.columns c where c.object_id = OBJECT_ID('dbo.instance_details') and c.name = 'is_available')
    alter table dbo.instance_details add [is_available] bit NOT NULL default 1;
go
if not exists (select * from sys.columns c where c.object_id = OBJECT_ID('dbo.instance_details') and c.name = 'created_date_utc')
    alter table dbo.instance_details add [created_date_utc] datetime2 NOT NULL default SYSUTCDATETIME();
go
if not exists (select * from sys.columns c where c.object_id = OBJECT_ID('dbo.instance_details') and c.name = 'last_unavailability_time_utc')
    alter table dbo.instance_details add [last_unavailability_time_utc] datetime2 null;
go
if not exists (select * from sys.columns c where c.object_id = OBJECT_ID('dbo.instance_details') and c.name = 'more_info')
    alter table dbo.instance_details add [more_info] varchar(2000) null;
go
if not exists (select * from sys.columns c where c.object_id = OBJECT_ID('dbo.instance_details') and c.name = 'is_enabled')
    alter table dbo.instance_details add [is_enabled] bit NOT NULL default 0;
go
if not exists (select * from sys.columns c where c.object_id = OBJECT_ID('dbo.instance_details') and c.name = 'is_linked_server_working')
    alter table dbo.instance_details add [is_linked_server_working] bit NOT NULL default 1;
go

CREATE TABLE [dbo].[backups_all_servers]
(
	[sql_instance] [varchar](255) not null,
	[database_name] [varchar](128) not null,
	[backup_type] [varchar](35) null,
	[log_backups_count] [int] NULL,
	[backup_start_date_utc] [datetime] NULL,
	[backup_finish_date_utc] [datetime] NULL,
	[latest_backup_location] [varchar](260) NULL,
	[backup_size_mb] [decimal](20, 2) NULL,
	[compressed_backup_size_mb] [decimal](20, 2) NULL,
	[first_lsn] [numeric](25, 0) NULL,
	[last_lsn] [numeric](25, 0) NULL,
	[checkpoint_lsn] [numeric](25, 0) NULL,
	[database_backup_lsn] [numeric](25, 0) NULL,
	[database_creation_date_utc] [datetime] NULL,
	[backup_software] [varchar](128) NULL,
	[recovery_model] [varchar](60) NULL,
	[compatibility_level] [tinyint] NULL,
	[device_type] [varchar](25) NULL,
	[description] [varchar](255) NULL,

	[collection_time_utc] datetime2 NOT NULL DEFAULT GETUTCDATE(),

	index [CI_backups_all_servers] clustered ([sql_instance], [database_name], [backup_start_date_utc])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[backups_all_servers__staging]
(
	[sql_instance] [varchar](255) not null,
	[database_name] [varchar](128) not null,
	[backup_type] [varchar](35) NULL,
	[log_backups_count] [int] NULL,
	[backup_start_date_utc] [datetime] NULL,
	[backup_finish_date_utc] [datetime] NULL,
	[latest_backup_location] [varchar](260) NULL,
	[backup_size_mb] [decimal](20, 2) NULL,
	[compressed_backup_size_mb] [decimal](20, 2) NULL,
	[first_lsn] [numeric](25, 0) NULL,
	[last_lsn] [numeric](25, 0) NULL,
	[checkpoint_lsn] [numeric](25, 0) NULL,
	[database_backup_lsn] [numeric](25, 0) NULL,
	[database_creation_date_utc] [datetime] NULL,
	[backup_software] [varchar](128) NULL,
	[recovery_model] [varchar](60) NULL,
	[compatibility_level] [tinyint] NULL,
	[device_type] [varchar](25) NULL,
	[description] [varchar](255) NULL,

	[collection_time_utc] datetime2 NOT NULL DEFAULT GETUTCDATE(),

	index [CI_backups_all_servers__staging] clustered ([sql_instance], [database_name], [backup_start_date_utc])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[services_all_servers]
(
	[sql_instance] [varchar](255) NOT NULL,
	[at_server_name] [varchar](125) NULL,
	[service_type] [varchar](20) NOT NULL,
	[servicename] [varchar](255) NOT NULL,
	[startup_type_desc] [varchar](50) NOT NULL,
	[status_desc] [varchar](125) NOT NULL,
	[process_id] [int] NULL,
	[service_account] [varchar](255) NOT NULL,
	[sql_ports] [varchar](500) NULL,
	[last_startup_time_utc] [datetime2] NULL,
	[instant_file_initialization_enabled] [varchar](1) NULL,

	[collection_time_utc] [datetime2] NOT NULL DEFAULT GETUTCDATE(),

	index [CI_services_all_servers] clustered ([sql_instance])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[services_all_servers__staging]
(
	[sql_instance] [varchar](255) NOT NULL,
	[at_server_name] [varchar](125) NULL,
	[service_type] [varchar](20) NOT NULL,
	[servicename] [varchar](255) NOT NULL,
	[startup_type_desc] [varchar](50) NOT NULL,
	[status_desc] [varchar](125) NOT NULL,
	[process_id] [int] NULL,
	[service_account] [varchar](255) NOT NULL,
	[sql_ports] [varchar](500) NULL,
	[last_startup_time_utc] [datetime2] NULL,
	[instant_file_initialization_enabled] [varchar](1) NULL,
	[collection_time_utc] [datetime2] NOT NULL DEFAULT GETUTCDATE(),

	index [CI_services_all_servers__staging] clustered ([sql_instance])
) ON [PRIMARY]
GO
