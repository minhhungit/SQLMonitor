[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [ValidateSet("AddStep", "RemoveStep")]
    [String]$Action = "AddStep",

    [Parameter(Mandatory=$false)]
    [String]$StepName = "95__DropTable_DiskSpaceAllServersStaging",
    
    [Parameter(Mandatory=$false)]
    [String[]]$AllSteps = @( "1__RemoveJob_CheckSQLAgentJobs", "2__RemoveJob_CollectAgHealthState", "3__RemoveJob_CollectDiskSpace",
                "4__RemoveJob_CollectOSProcesses", "5__RemoveJob_CollectPerfmonData", "6__RemoveJob_CollectPrivilegedInfo",
                "7__RemoveJob_CollectWaitStats", "8__RemoveJob_CollectXEvents", "9__RemoveJob_PartitionsMaintenance",
                "10__RemoveJob_PurgeTables", "11__RemoveJob_RemoveXEventFiles", "12__RemoveJob_RunWhoIsActive",
                "13__RemoveJob_CollectFileIOStats", "14__RemoveJob_CollectMemoryClerks", "15__RemoveJob_RunBlitzIndex",
                "16__RemoveJob_RunBlitz", "17__RemoveJob_RunLogSaver", "18__RemoveJob_RunTempDbSaver",
                "19__RemoveJob_UpdateSqlServerVersions", "20__RemoveJob_CheckInstanceAvailability", "21__RemoveJob_GetAllServerInfo",
                "22__RemoveJob_GetAllServerCollectedData", "23__DropProc_UspExtendedResults", "24__DropProc_UspCollectWaitStats",
                "25__DropProc_UspRunWhoIsActive", "26__DropProc_UspCollectXEventsXEventMetrics", "27__DropProc_UspPartitionMaintenance",
                "28__DropProc_UspPurgeTables", "29__DropProc_SpWhatIsRunning", "30__DropProc_UspActiveRequestsCount",
                "31__DropProc_UspCollectFileIOStats", "32__DropProc_UspEnablePageCompression", "33__DropProc_UspWaitsPerCorePerMinute",
                "34__DropProc_UspCollectMemoryClerks", "35__DropProc_UspWrapperGetAllServerInfo", "36__DropProc_UspPopulateAllServerVolatileInfoHistory",
                "37__DropProc_UspGetAllServerInfo", "38__DropView_VwPerformanceCounters", "39__DropView_VwOsTaskList",
                "40__DropView_VwWaitStatsDeltas", "41__DropView_vw_file_io_stats_deltas", "42__DropView_vw_xevent_metrics",
                "43__DropView_vw_disk_space", "44__DropView_vw_all_server_info", "45__DropXEvent_XEventMetrics",
                "46__DropLinkedServer", "47__DropLogin_Grafana", "48__DropTable_XEventMetrics",
                "49__DropTable_xevent_metrics_queries", "50__DropTable_XEventMetricsProcessedXELFiles", "51__DropTable_WhoIsActive_Staging",
                "52__DropTable_WhoIsActive", "53__DropTable_PerformanceCounters", "54__DropTable_PurgeTable",
                "55__DropTable_PerfmonFiles", "56__DropTable_InstanceDetails", "57__DropTable_InstanceHosts",
                "58__DropTable_OsTaskList", "59__DropTable_BlitzWho", "60__DropTable_BlitzCache",
                "61__DropTable_ConnectionHistory", "62__DropTable_BlitzFirst", "63__DropTable_BlitzFirstFileStats",
                "64__DropTable_DiskSpace", "65__DropTable_BlitzFirstPerfmonStats", "66__DropTable_BlitzFirstWaitStats",
                "67__DropTable_BlitzFirstWaitStatsCategories", "68__DropTable_WaitStats", "69__DropTable_BlitzIndex",
                "70__DropTable_Blitz", "71__DropTable_FileIOStats", "72__DropTable_MemoryClerks",
                "73__DropTable_AgHealthState", "74__DropTable_LogSpaceConsumers", "75__DropTable_PrivilegedInfo",
                "76__DropTable_SqlAgentJobStats", "77__DropTable_SqlAgentJobThresholds", "78__DropTable_TempdbSpaceConsumers",
                "79__DropTable_TempdbSpaceUsage", "80__DropTable_AllServerCollectionLatencyInfo", "81__DropTable_AllServerVolatileInfoHistory",
                "82__DropTable_AllServerVolatileInfo", "83__DropTable_AllServerStableInfo", "84__DropTable_DiskSpaceAllServersStaging",
                "85__DropTable_DiskSpaceAllServers", "86__DropTable_LogSpaceConsumersAllServers", "87__DropTable_LogSpaceConsumersAllServersStaging",
                "88__DropTable_SqlAgentJobsAllServers", "89__DropTable_SqlAgentJobsAllServersStaging", "90__DropTable_TempdbSpaceUsageAllServers",
                "91__DropTable_TempdbSpaceUsageAllServersStaging", "92__DropTable_AgHealthStateAllServers", "93__DropTable_AgHealthStateAllServersStaging",
                "94__DropTable_AllServerVolatileInfoHistory", "95__DropTable_DiskSpaceAllServersStaging", "96__RemovePerfmonFilesFromDisk",
                "97__RemoveXEventFilesFromDisk", "98__DropProxy", "99__DropCredential",
                "100__RemoveInstanceFromInventory"
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

