[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [ValidateSet("AddStep", "RemoveStep")]
    [String]$Action = "AddStep",

    [Parameter(Mandatory=$false)]
    [String]$StepName = "21__RemoveJob_GetAllServerCollectedData",
    
    [Parameter(Mandatory=$false)]
    [String[]]$AllSteps = @( "1__RemoveJob_CheckSQLAgentJobs", "2__RemoveJob_CollectAgHealthState", "3__RemoveJob_CollectDiskSpace",
                "4__RemoveJob_CollectOSProcesses", "5__RemoveJob_CollectPerfmonData", "6__RemoveJob_CollectPrivilegedInfo",
                "7__RemoveJob_CollectWaitStats", "8__RemoveJob_CollectXEvents", "9__RemoveJob_PartitionsMaintenance",
                "10__RemoveJob_PurgeTables", "11__RemoveJob_RemoveXEventFiles", "12__RemoveJob_RunWhoIsActive",
                "13__RemoveJob_CollectFileIOStats", "14__RemoveJob_CollectMemoryClerks", "15__RemoveJob_RunBlitzIndex",
                "16__RemoveJob_RunLogSaver", "17__RemoveJob_RunTempDbSaver", "18__RemoveJob_UpdateSqlServerVersions",
                "19__RemoveJob_CheckInstanceAvailability", "20__RemoveJob_GetAllServerInfo", "21__DropProc_UspExtendedResults",
                "22__DropProc_UspCollectWaitStats", "23__DropProc_UspRunWhoIsActive", "24__DropProc_UspCollectXEventsResourceConsumption",
                "25__DropProc_UspPartitionMaintenance", "26__DropProc_UspPurgeTables", "27__DropProc_SpWhatIsRunning",
                "28__DropProc_UspActiveRequestsCount", "29__DropProc_UspCollectFileIOStats", "30__DropProc_UspEnablePageCompression",
                "31__DropProc_UspWaitsPerCorePerMinute", "32__DropProc_UspCollectMemoryClerks", "33__DropProc_UspWrapperGetAllServerInfo",
                "34__DropProc_UspPopulateAllServerVolatileInfoHistory", "35__DropProc_UspGetAllServerInfo", "36__DropView_VwPerformanceCounters",
                "37__DropView_VwOsTaskList", "38__DropView_VwWaitStatsDeltas", "39__DropView_vw_file_io_stats_deltas",
                "40__DropView_vw_xevent_metrics", "41__DropView_vw_disk_space", "42__DropView_vw_all_server_info",
                "43__DropXEvent_ResourceConsumption", "44__DropLinkedServer", "45__DropLogin_Grafana",
                "46__DropTable_ResourceConsumption", "47__DropTable_xevent_metrics_queries", "48__DropTable_ResourceConsumptionProcessedXELFiles",
                "49__DropTable_WhoIsActive_Staging", "50__DropTable_WhoIsActive", "51__DropTable_PerformanceCounters",
                "52__DropTable_PurgeTable", "53__DropTable_PerfmonFiles", "54__DropTable_InstanceDetails",
                "55__DropTable_InstanceHosts", "56__DropTable_OsTaskList", "57__DropTable_BlitzWho",
                "58__DropTable_BlitzCache", "59__DropTable_ConnectionHistory", "60__DropTable_BlitzFirst",
                "61__DropTable_BlitzFirstFileStats", "62__DropTable_DiskSpace", "63__DropTable_BlitzFirstPerfmonStats",
                "64__DropTable_BlitzFirstWaitStats", "65__DropTable_BlitzFirstWaitStatsCategories", "66__DropTable_WaitStats",
                "67__DropTable_BlitzIndex", "68__DropTable_FileIOStats", "69__DropTable_MemoryClerks",
                "70__DropTable_AllServerCollectionLatencyInfo", "71__DropTable_AllServerVolatileInfoHistory", "72__DropTable_AllServerVolatileInfo",
                "73__DropTable_AllServerStableInfo", "74__RemovePerfmonFilesFromDisk", "75__RemoveXEventFilesFromDisk",
                "76__DropProxy", "77__DropCredential", "78__RemoveInstanceFromInventory"
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

