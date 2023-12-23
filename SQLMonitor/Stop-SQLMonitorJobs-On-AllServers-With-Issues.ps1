[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [String]$InventoryServer = 'localhost',
    [Parameter(Mandatory=$false)]
    [String]$InventoryDatabase = 'DBA',
    [Parameter(Mandatory=$false)]
    [String]$CredentialManagerDatabase = 'DBA',
    [Parameter(Mandatory=$false)]
    [Bool]$StopJob = $true,
    [Parameter(Mandatory=$false)]
    [Bool]$StartJob = $true,
    [Parameter(Mandatory=$false)]
    [PSCredential]$SqlCredential
)

"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "[Connect-DbaInstance] Create connection for InventoryServer '$InventoryServer'.."
$conInventoryServer = Connect-DbaInstance -SqlInstance $InventoryServer -Database $InventoryDatabase -ClientName "Stop-SQLMonitorJobs-On-AllServers-With-Issues.ps1" `
                                                    -TrustServerCertificate -EncryptConnection -ErrorAction Stop -SqlCredential $SqlCredential

"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Fetch [LinkAdmin] password from Credential Manager [$InventoryServer].[$CredentialManagerDatabase].."
$getCredential = @"
/* Fetch Credentials */
declare @password varchar(256);
exec dbo.usp_get_credential 
		@server_ip = '*',
		@user_name = 'LinkAdmin',
		@password = @password output;
select @password as [password];
"@
[string]$linkAdminPassword = $conInventoryServer | Invoke-DbaQuery -Database $CredentialManagerDatabase -Query $getCredential | 
                                    Select-Object -ExpandProperty password -First 1

"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Create LinkAdmin credential from fetched password.."
[string]$linkAdminUser = 'LinkAdmin'
[securestring]$secStringPassword = ConvertTo-SecureString $linkAdminPassword -AsPlainText -Force
[pscredential]$linkAdminCredential = New-Object System.Management.Automation.PSCredential $linkAdminUser, $secStringPassword

$sqlGetAllStuckJobs = @"
declare @_buffer_time_minutes int = 30;
declare @_sql nvarchar(max);
declare @_params nvarchar(max);

set @_params = N'@_buffer_time_minutes int';
set quoted_identifier off;
set @_sql = "
select	/* [Tsql-Stop-Job] = 'exec msdb.dbo.sp_stop_job @job_name = '''+sj.JobName+'''' ,
		[Tsql-Start-Job] = 'exec msdb.dbo.sp_start_job @job_name = '''+sj.JobName+'''' , 
		*/
		[CollectionTimeUTC] = [UpdatedDateUTC],
		[sql_instance], [JobName],
		[Job-Delay-Minutes] = case when sj.Last_Successful_ExecutionTime is null then 10080 else datediff(minute, sj.Last_Successful_ExecutionTime, dateadd(minute,-(sj.Successfull_Execution_ClockTime_Threshold_Minutes+@_buffer_time_minutes),getutcdate())) end,
		 [Last_RunTime], [Last_Run_Duration_Seconds], [Last_Run_Outcome], 
		 [Successfull_Execution_ClockTime_Threshold_Minutes], 
		 [Expected_Max_Duration_Minutes],
		 [Last_Successful_ExecutionTime], [Last_Successful_Execution_Hours], 
		 [Running_Since], [Running_StepName], [Running_Since_Min] 
from dbo.sql_agent_jobs_all_servers sj
where 1=1
and sj.JobCategory = '(dba) SQLMonitor'
and sj.JobName like '(dba) %'
and sj.IsDisabled = 0
and sj.Successfull_Execution_ClockTime_Threshold_Minutes <> -1
and (	sj.Last_Run_Outcome is null 
	or	sj.Last_Run_Outcome in ('Succeeded','Canceled')
	or	sj.Running_Since_Min >= (sj.Successfull_Execution_ClockTime_Threshold_Minutes * 4)
	)
and (	dateadd(minute,-(sj.Successfull_Execution_ClockTime_Threshold_Minutes+@_buffer_time_minutes),getutcdate()) > sj.Last_Successful_ExecutionTime
			or sj.Last_Successful_ExecutionTime is null
		)
--order by Last_Run_Outcome
"
set quoted_identifier off;

exec sp_executesql @_sql, @_params, @_buffer_time_minutes = @_buffer_time_minutes;
"@

$resultGetAllStuckJobs = $conInventoryServer | Invoke-DbaQuery -Database $InventoryDatabase -Query $sqlGetAllStuckJobs -SqlCredential $linkAdminCredential;

# Execute SQL files & SQL Query
$failedJobs = @()
$successJobs = @()
$resultGetAllStuckJobsFiltered = @()
$resultGetAllStuckJobsFiltered += $resultGetAllStuckJobs

if ($resultGetAllStuckJobsFiltered.Count -eq 0) {
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "No action required to be taken."
}

foreach($job in $resultGetAllStuckJobsFiltered)
{
    $sqlInstance = $job.sql_instance
    $jobName = $job.JobName
    
    try {
        if($StopJob) 
        {
            "`n`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Stop job [$jobName] on [$sqlInstance].."
            $sqlInstance | Invoke-DbaQuery -CommandType StoredProcedure -EnableException -SqlCredential $linkAdminCredential `
                            -Database msdb -Query sp_stop_job -SqlParameter @{ job_name = $jobName }

            Start-Sleep -Seconds 5
        }

        if($StartJob)
        {
            "`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Stop job [$jobName] on [$sqlInstance].."
            $sqlInstance | Invoke-DbaQuery -CommandType StoredProcedure -EnableException -SqlCredential $linkAdminCredential `
                            -Database msdb -Query sp_start_job -SqlParameter @{ job_name = $jobName }
        }
        
        $successJobs += "$sqlInstance => $jobName"
    }
    catch {
        $errMessage = $_
        $failedJobs += "$sqlInstance => $jobName"
        $errMessage.Exception | Write-Host -ForegroundColor Red
        "`n"
    }
}


if($failedJobs.Count -gt 0) {
    #$failedJobs | ogv -Title "Failed"
    "`nAction on following jobs failed:`n" | Write-Output
    "`n`t$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Action on following jobs failed:`n"
    $failedJobs | Format-Table -AutoSize
}
#$successJobs | ogv -Title "Successful"
