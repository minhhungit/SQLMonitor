use msdb
go

IF EXISTS (SELECT * FROM msdb.dbo.sysjobs_view WHERE name = N'(dba) Capture-AlertMessages')
	EXEC msdb.dbo.sp_delete_job @job_name='(dba) Capture-AlertMessages', @delete_unused_schedule=1
GO

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'(dba) SQLMonitor' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'(dba) SQLMonitor'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'(dba) Capture-AlertMessages', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Job is trigged through SQL Agent Alerts.

Purpose: Collect Alert Messages in table [dbo].[alert_history].

https://ajaydwivedi.com/github/sqlmonitor', 
		@category_name=N'(dba) SQLMonitor', 
		--@owner_login_name=N'sa', 
		@job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'dbo.usp_capture_alert_messages', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=1, 
		@os_run_priority=0, 
		@subsystem=N'TSQL', 
		@command=N'EXEC dbo.usp_capture_alert_messages
				@server_name = ''$(ESCAPE_SQUOTE(A-SVR))'',
				@database_name = ''$(ESCAPE_SQUOTE(A-DBN))'', 
				@error_number = $(ESCAPE_NONE(A-ERR)), 
				@error_severity = $(ESCAPE_NONE(A-SEV)), 
				@error_message = ''$(ESCAPE_SQUOTE(A-MSG))'', 
				@host_instance = ''$(ESCAPE_SQUOTE(SRVR))'',
				@recipients = ''some_dba_mail_id@gmail.com'';', 
		@database_name=N'DBA', 
		@flags=40
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO
