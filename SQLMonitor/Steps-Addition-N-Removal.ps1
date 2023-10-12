[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [ValidateSet("AddStep", "RemoveStep")]
    [String]$Action = "AddStep",

    [Parameter(Mandatory=$false)]
    [String]$StepName = "89__DropTable_TempdbSpaceUsageAllServersStaging",
    
    [Parameter(Mandatory=$false)]
    [String[]]$AllSteps = @( "1__RemoveJob_CheckSQLAgentJobs", "2__RemoveJob_CollectAgHealthState", "3__RemoveJob_CollectDiskSpace",
                "4__RemoveJob_CollectOSProcesses", "5__RemoveJob_CollectPerfmonData", "6__RemoveJob_CollectPrivilegedInfo",
                "7__RemoveJob_CollectWaitStats", "8__RemoveJob_CollectXEvents", "9__RemoveJob_PartitionsMaintenance",
                "10__RemoveJob_PurgeTables", "11__RemoveJob_RemoveXEventFiles", "12__RemoveJob_RunWhoIsActive",
                "13__RemoveJob_CollectFileIOStats", "14__RemoveJob_CollectMemoryClerks", "15__RemoveJob_RunBlitzIndex",
                "16__RemoveJob_RunLogSaver", "17__RemoveJob_RunTempDbSaver", "18__RemoveJob_UpdateSqlServerVersions",
                "19__RemoveJob_CheckInstanceAvailability", "20__RemoveJob_GetAllServerInfo", "21__RemoveJob_GetAllServerCollectedData",
                "22__DropProc_UspExtendedResults", "23__DropProc_UspCollectWaitStats", "24__DropProc_UspRunWhoIsActive",
                "25__DropProc_UspCollectXEventsXEventMetrics", "26__DropProc_UspPartitionMaintenance", "27__DropProc_UspPurgeTables",
                "28__DropProc_SpWhatIsRunning", "29__DropProc_UspActiveRequestsCount", "30__DropProc_UspCollectFileIOStats",
                "31__DropProc_UspEnablePageCompression", "32__DropProc_UspWaitsPerCorePerMinute", "33__DropProc_UspCollectMemoryClerks",
                "34__DropProc_UspWrapperGetAllServerInfo", "35__DropProc_UspPopulateAllServerVolatileInfoHistory", "36__DropProc_UspGetAllServerInfo",
                "37__DropView_VwPerformanceCounters", "38__DropView_VwOsTaskList", "39__DropView_VwWaitStatsDeltas",
                "40__DropView_vw_file_io_stats_deltas", "41__DropView_vw_xevent_metrics", "42__DropView_vw_disk_space",
                "43__DropView_vw_all_server_info", "44__DropXEvent_XEventMetrics", "45__DropLinkedServer",
                "46__DropLogin_Grafana", "47__DropTable_XEventMetrics", "48__DropTable_xevent_metrics_queries",
                "49__DropTable_XEventMetricsProcessedXELFiles", "50__DropTable_WhoIsActive_Staging", "51__DropTable_WhoIsActive",
                "52__DropTable_PerformanceCounters", "53__DropTable_PurgeTable", "54__DropTable_PerfmonFiles",
                "55__DropTable_InstanceDetails", "56__DropTable_InstanceHosts", "57__DropTable_OsTaskList",
                "58__DropTable_BlitzWho", "59__DropTable_BlitzCache", "60__DropTable_ConnectionHistory",
                "61__DropTable_BlitzFirst", "62__DropTable_BlitzFirstFileStats", "63__DropTable_DiskSpace",
                "64__DropTable_BlitzFirstPerfmonStats", "65__DropTable_BlitzFirstWaitStats", "66__DropTable_BlitzFirstWaitStatsCategories",
                "67__DropTable_WaitStats", "68__DropTable_BlitzIndex", "69__DropTable_FileIOStats",
                "70__DropTable_MemoryClerks", "71__DropTable_AgHealthState", "72__DropTable_LogSpaceConsumers",
                "73__DropTable_PrivilegedInfo", "74__DropTable_SqlAgentJobStats", "75__DropTable_SqlAgentJobThresholds",
                "76__DropTable_TempdbSpaceConsumers", "77__DropTable_TempdbSpaceUsage", "78__DropTable_AllServerCollectionLatencyInfo",
                "79__DropTable_AllServerVolatileInfoHistory", "80__DropTable_AllServerVolatileInfo", "81__DropTable_AllServerStableInfo",
                "82__DropTable_DiskSpaceAllServersStaging", "83__DropTable_DiskSpaceAllServers", "84__DropTable_LogSpaceConsumersAllServers",
                "85__DropTable_LogSpaceConsumersAllServersStaging", "86__DropTable_SqlAgentJobsAllServers", "87__DropTable_SqlAgentJobsAllServersStaging",
                "88__DropTable_TempdbSpaceUsageAllServers", "89__DropTable_TempdbSpaceUsageAllServersStaging", "90__RemovePerfmonFilesFromDisk",
                "91__RemoveXEventFilesFromDisk", "92__DropProxy", "93__DropCredential",
                "94__RemoveInstanceFromInventory"
                ),

    [Parameter(Mandatory=$false)]
    [Bool]$PrintUserFriendlyFormat = $true,

    [Parameter(Mandatory=$false)]
    [String]$ScriptFile = 'D:\GitHub-Personal\SQLMonitor\SQLMonitor\Remove-SQLMonitor.ps1'
                          #'D:\GitHub-Personal\SQLMonitor\SQLMonitor\Install-SQLMonitor.ps1'
)

cls

# Placeholders
$finalSteps = @()

# Calculations
[int]$paramStepNo = $StepName -replace "__\w+", ''
$preStep = $paramStepNo-2;
if($Action -eq "AddStep") { # Add New Step
    $postStep = $paramStepNo-1;
    $lastStep = $AllSteps.Count-1;
}
else { # Remove Existing Step
    $postStep = $paramStepNo;
    $lastStep = $AllSteps.Count-1;
}

Write-Debug "Step here for debugging"

#"Pre-Steps" | Write-Host -ForegroundColor Green
$preNewSteps = @()
if( ($Action -eq "AddStep") -and ($preStep -ne -1) ) {
    $preNewSteps += $AllSteps[0..$preStep]
}

#"`nAdd step '$StepName' here`n" | Write-Host -ForegroundColor Cyan

#"Post-Steps" | Write-Host -ForegroundColor Green
$postNewSteps = @()
if($Action -eq "AddStep") { # Add New Step
    $postNewSteps += $AllSteps[$postStep..$lastStep] | 
        ForEach-Object {[int]$stepNo = $_ -replace "__\w+", ''; $_.Replace("$stepNo", "$($stepNo+1)")}
    $finalSteps = $preNewSteps + @($StepName) + $postNewSteps
}
else { # Remove Existing Step
    $postNewSteps += $AllSteps[$postStep..$lastStep] | 
        ForEach-Object {[int]$stepNo = $_ -replace "__\w+", ''; $_.Replace("$stepNo", "$($stepNo-1)")}
    $finalSteps = $preNewSteps + $postNewSteps
}



"All New Steps => `n`n " | Write-Host -ForegroundColor Green
if($PrintUserFriendlyFormat) {
    foreach($num in $(0..$([Math]::Floor($finalSteps.Count/3)))) {
        $numStart = ($num*3)
        $numEnd = ($num*3)+2
        #"`$num = $num, `$numStart = $numStart, `$numEnd = $numEnd"        
        
        "                " + $(($finalSteps[$numStart..$numEnd] | ForEach-Object {'"'+$_+'"'}) -join ', ') + $(if($num -ne $([Math]::Floor($finalSteps.Count/3))){","})
        
    }
}
else {
    $finalSteps
}

if([String]::IsNullOrEmpty($ScriptFile)) {
    "`n`nNo file provided to replace the content."
} else {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Read file content.."
    $fileContent = [System.IO.File]::ReadAllText($ScriptFile)
    foreach($index in $($postStep..$($AllSteps.Count-1))) 
    {
        if($Action -eq "AddStep") { # Add New Step
            $fileContent = $fileContent.Replace($AllSteps[$index],$finalSteps[$index+1]);
        }
        else { # Remove Existing Step
            $fileContent = $fileContent.Replace($AllSteps[$index],$finalSteps[$index-1]);
        }
    }
    $newScriptFile = $ScriptFile.Replace('.ps1',' __bak.ps1')
    $fileContent | Out-File -FilePath $newScriptFile
    notepad $newScriptFile
    "Updated data saved into file '$newScriptFile'." | Write-Host -ForegroundColor Green
    "Opening saved file '$newScriptFile'." | Write-Host -ForegroundColor Green
}

