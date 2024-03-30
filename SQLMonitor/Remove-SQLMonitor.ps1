[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [String]$SqlInstanceToBaseline,

    [Parameter(Mandatory=$false)]
    [String]$DbaDatabase,

    [Parameter(Mandatory=$false)]
    [String]$SqlInstanceAsDataDestination,

    [Parameter(Mandatory=$false)]
    [String]$SqlInstanceForTsqlJobs,

    [Parameter(Mandatory=$false)]
    [String]$SqlInstanceForPowershellJobs,

    [Parameter(Mandatory=$false)]
    [String]$InventoryServer,

    [Parameter(Mandatory=$false)]
    [String]$InventoryDatabase = 'DBA',

    [Parameter(Mandatory=$false)]
    [String]$HostName,

    [Parameter(Mandatory=$false)]
    [String]$RemoteSQLMonitorPath = 'C:\SQLMonitor',

    [Parameter(Mandatory=$false)]
    [String]$DataCollectorSetName = 'DBA',

    [Parameter(Mandatory=$false)]
    [ValidateSet("1__RemoveJob_CheckSQLAgentJobs", "2__RemoveJob_CollectAgHealthState", "3__RemoveJob_CollectDiskSpace",
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
                "100__RemoveInstanceFromInventory")]
    [String[]]$OnlySteps,

    [Parameter(Mandatory=$false)]
    [ValidateSet("1__RemoveJob_CheckSQLAgentJobs", "2__RemoveJob_CollectAgHealthState", "3__RemoveJob_CollectDiskSpace",
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
                "100__RemoveInstanceFromInventory")]
    [String]$StartAtStep = "1__RemoveJob_CheckSQLAgentJobs",

    [Parameter(Mandatory=$false)]
    [ValidateSet("1__RemoveJob_CheckSQLAgentJobs", "2__RemoveJob_CollectAgHealthState", "3__RemoveJob_CollectDiskSpace",
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
                "100__RemoveInstanceFromInventory")]
    [String[]]$SkipSteps,

    [Parameter(Mandatory=$false)]
    [ValidateSet("1__RemoveJob_CheckSQLAgentJobs", "2__RemoveJob_CollectAgHealthState", "3__RemoveJob_CollectDiskSpace",
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
                "100__RemoveInstanceFromInventory")]
    [String]$StopAtStep,

    [Parameter(Mandatory=$false)]
    [bool]$SkipDropTable = $false,

    [Parameter(Mandatory=$false)]
    [bool]$SkipRemoveTsqlJobs = $false,

    [Parameter(Mandatory=$false)]
    [bool]$SkipRemovePowerShellJobs = $false,    

    [Parameter(Mandatory=$false)]
    [bool]$SkipDropProcedure = $false,

    [Parameter(Mandatory=$false)]
    [bool]$SkipDropView = $false,

    [Parameter(Mandatory=$false)]
    [bool]$SkipRDPSessionSteps = $false,

    [Parameter(Mandatory=$false)]
    [ValidateSet("Delete","Update")]
    [String]$ActionType = "Delete",

    [Parameter(Mandatory=$false)]
    [PSCredential]$SqlCredential,

    [Parameter(Mandatory=$false)]
    [PSCredential]$WindowsCredential,

    [Parameter(Mandatory=$false)]
    [bool]$ConfirmValidationOfMultiInstance = $false,

    [Parameter(Mandatory=$false)]
    [bool]$DryRun = $true,

    [Parameter(Mandatory=$false)]
    [String]$PreQuery,

    [Parameter(Mandatory=$false)]
    [String]$PostQuery
)

$startTime = Get-Date
$ErrorActionPreference = "Stop"
$sqlmonitorVersion = '2024-03-31'
$sqlmonitorVersionDate = '2024-Mar-31'
$releaseDiscussionURL = "https://ajaydwivedi.com/sqlmonitor/common-errors"
<#
    v1.6.0 - 2023-Dec-31
        -> Issue#13 - Capture sp_Blitz & Create Dashboard
        -> Issue#12 - Compatibility with new dbatools version
        -> Issue#3 - Remove-SQLMonitor - Save InstanceDetails are until the Instance is Removed Full
    v1.5.0 - 2023-June-30
        -> Issue#255 - Support of SQLExpress for Inventory Setup
    v1.4.0 - 2023-Mar-31
        -> https://github.com/imajaydwivedi/SQLMonitor/releases/tag/v1.4.0

#>


# All Steps
$AllSteps = @(  "1__RemoveJob_CheckSQLAgentJobs", "2__RemoveJob_CollectAgHealthState", "3__RemoveJob_CollectDiskSpace",
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
                )

# TSQL Jobs
$TsqlJobSteps = @(
                "1__RemoveJob_CheckSQLAgentJobs", "2__RemoveJob_CollectAgHealthState", "6__RemoveJob_CollectPrivilegedInfo",
                "7__RemoveJob_CollectWaitStats", "8__RemoveJob_CollectXEvents", "9__RemoveJob_PartitionsMaintenance",
                "10__RemoveJob_PurgeTables", "11__RemoveJob_RemoveXEventFiles", "12__RemoveJob_RunWhoIsActive",
                "13__RemoveJob_CollectFileIOStats", "14__RemoveJob_CollectMemoryClerks", "15__RemoveJob_RunBlitzIndex",
                "16__RemoveJob_RunBlitz", "17__RemoveJob_RunLogSaver", "18__RemoveJob_RunTempDbSaver", 
                "21__RemoveJob_GetAllServerInfo", "22__RemoveJob_GetAllServerCollectedData" )

# PowerShell Jobs
$PowerShellJobSteps = @(
                "3__RemoveJob_CollectDiskSpace", "4__RemoveJob_CollectOSProcesses", "5__RemoveJob_CollectPerfmonData",
                "19__RemoveJob_UpdateSqlServerVersions", "20__RemoveJob_CheckInstanceAvailability")

# RDPSessionSteps
$RDPSessionSteps = @("96__RemovePerfmonFilesFromDisk", "97__RemoveXEventFilesFromDisk")

# For "Update" operation, Parameter OnlySteps is mandatory
if ($ActionType -eq 'Update' -and $OnlySteps.Count -eq 0) {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "For `"Update`" operation, Parameter `"OnlySteps`" is mandatory." | Write-Host -ForegroundColor Red
    Write-Error "Stop here. Fix above issue."
}

# "Delete" operation is not compatible with "OnlySteps" Parameter
if ($ActionType -eq 'Delete' -and $OnlySteps.Count -gt 0) {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "`"Delete`" operation is not compatible with `"OnlySteps`" Parameter." | Write-Host -ForegroundColor Red
    Write-Error "Stop here. Fix above issue."
}


# Add $PowerShellJobSteps to Skip Jobs
if($SkipRemovePowerShellJobs) {
    $SkipSteps = $SkipSteps + $($PowerShellJobSteps | % {if($_ -notin $SkipSteps){$_}});
}

# Add $RDPSessionSteps to Skip Jobs
if($SkipRDPSessionSteps) {
    $SkipSteps = $SkipSteps + $($RDPSessionSteps | % {if($_ -notin $SkipSteps){$_}});
}

# Add $TsqlJobSteps to Skip Jobs
if($SkipRemoveTsqlJobs) {
    $SkipSteps = $SkipSteps + $($TsqlJobSteps | % {if($_ -notin $SkipSteps){$_}});
}

# For backward compatability
$SkipAllJobs = $false
if($SkipRemoveTsqlJobs -and $SkipRemovePowerShellJobs) {
    $SkipAllJobs = $true
}


if($SqlInstanceToBaseline -eq '.' -or $SqlInstanceToBaseline -eq 'localhost') {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "'localhost' or '.' are not validate SQLInstance names." | Write-Host -ForegroundColor Red
    Write-Error "Stop here. Fix above issue."
}

if([String]::IsNullOrEmpty($DbaDatabase)) {
    "`n`n`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'START:', "Working on server [$SqlInstanceToBaseline].." | Write-Host -ForegroundColor Yellow
}
else {
    "`n`n`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'START:', "Working on server [$SqlInstanceToBaseline] with [$DbaDatabase] database." | Write-Host -ForegroundColor Yellow
}

"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'START:', "Removing SQLMonitor.." | Write-Host -ForegroundColor Yellow
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'START:', "Using SQLMonitor v$sqlmonitorVersion released on $sqlmonitorVersionDate.." | Write-Host -ForegroundColor Yellow
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'START:', "For issues, kindly visit $releaseDiscussionURL" | Write-Host -ForegroundColor Yellow
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'START:', "For help, kindly reach out to 'Ajay Dwivedi <ajay.dwivedi2007@gmail.com>'`n" | Write-Host -ForegroundColor Yellow


# Set windows credential if valid AD credential is provided as SqlCredential
if( [String]::IsNullOrEmpty($WindowsCredential) -and (-not [String]::IsNullOrEmpty($SqlCredential)) -and $SqlCredential.UserName -like "*\*" ) {
    $WindowsCredential = $SqlCredential
}

"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$SqlInstanceToBaseline = [$SqlInstanceToBaseline]"
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$DryRun = $DryRun" | Write-Host -ForegroundColor Cyan

"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$SqlCredential => "
$SqlCredential | ft -AutoSize
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$WindowsCredential => "
$WindowsCredential | ft -AutoSize

"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Import dbatools module.."
Import-Module dbatools
#Import-Module SqlServer

# Compute steps to execute
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Compute Steps to execute.."
$StartAtStepNumber = 1
$StopAtStepNumber = $AllSteps.Count+1

if(-not [String]::IsNullOrEmpty($StartAtStep)) {
    [int]$StartAtStepNumber = $StartAtStep -replace "__\w+", ''
}
if(-not [String]::IsNullOrEmpty($StopAtStep)) {
    [int]$StopAtStepNumber = $StopAtStep -replace "__\w+", ''
}


$Steps2Execute = @()
$Steps2ExecuteRaw = @()
if(-not [String]::IsNullOrEmpty($SkipSteps)) {
    $Steps2ExecuteRaw += Compare-Object -ReferenceObject $AllSteps -DifferenceObject $SkipSteps | Where-Object {$_.SideIndicator -eq '<='} | Select-Object -ExpandProperty InputObject
}
else {
    $Steps2ExecuteRaw += $AllSteps
}

$Steps2Execute += $Steps2ExecuteRaw | ForEach-Object { 
                            $currentStepNumber = [int]$($_ -replace "__\w+", '');
                            $passThrough = $true;
                            if( -not ($currentStepNumber -ge $StartAtStepNumber -and $currentStepNumber -le $StopAtStepNumber) ) {
                                $passThrough = $false
                            }
                            if( $passThrough -and ($SkipDropTable -and $_ -like '*__DropTable_*') ) {
                                $passThrough = $false
                            }
                            if( $passThrough -and ($SkipRemoveJob -and $_ -like '*__RemoveJob_*') ) {
                                $passThrough = $false
                            }
                            if( $passThrough -and ($SkipDropProcedure -and $_ -like '*__DropProc_*') ) {
                                $passThrough = $false
                            }
                            if( $passThrough -and ($SkipDropView -and $_ -like '*__DropView_*') ) {
                                $passThrough = $false
                            } 
                            if($passThrough) {$_}
                        }

# Filter for "OnlySteps" parameter
if($OnlySteps.Count -gt 0) {
    $Steps2Execute = $Steps2Execute | % {if($_ -in $OnlySteps){$_}}
}

"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$StartAtStep -> $StartAtStep.."
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$StopAtStep -> $StopAtStep.."
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Total steps to execute -> $($Steps2Execute.Count)."

<#
if($DryRun) {
    "`n`n" | Write-Host
    $Steps2Execute
    "`n`n" | Write-Host
}
#>

# Setup SQL Connection for Inventory
try {
    if($InventoryServer -ne $SqlInstanceToBaseline) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "[Connect-DbaInstance] Create connection for '$InventoryServer'.."
        $conInventoryServer = Connect-DbaInstance -SqlInstance $InventoryServer -Database master -ClientName "Wrapper-RemoveSQLMonitor.ps1" `
                                                    -SqlCredential $SqlCredential -TrustServerCertificate -EncryptConnection
    } else {
        $conInventoryServer = $conSqlInstanceToBaseline
    }
}
catch {
    $errMessage = $_
    
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "SQL Connection to [$InventoryServer] failed." | Write-Host -ForegroundColor Red
    if([String]::IsNullOrEmpty($SqlCredential)) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Kindly provide SqlCredentials." | Write-Host -ForegroundColor Red
    } else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Provided SqlCredentials seems to be NOT working." | Write-Host -ForegroundColor Red
    }
    Write-Error "Stop here. Fix above issue."
}

# Check if PortNo is specified
$Port4SqlInstanceToBaseline = $null
$SqlInstanceToBaselineWithOutPort = $SqlInstanceToBaseline
if($SqlInstanceToBaseline -match "(?'SqlInstance'.+),(?'PortNo'\d+)") {
    $Port4SqlInstanceToBaseline = $Matches['PortNo']
    $SqlInstanceToBaselineWithOutPort = $Matches['SqlInstance']
}

# Get dbo.instance_details info
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Fetching info from [$InventoryServer].[$InventoryDatabase].[dbo].[instance_details].."
$instanceDetails = @()
if([String]::IsNullOrEmpty($HostName)) {
    $sqlInstanceDetails = "select * from dbo.instance_details where sql_instance = '$SqlInstanceToBaselineWithOutPort'"
}
else {
    $sqlInstanceDetails = "select * from dbo.instance_details where sql_instance = '$SqlInstanceToBaselineWithOutPort' and [host_name] = '$HostName'"
}
try {
    $instanceDetails += $conInventoryServer | Invoke-DbaQuery -Database $InventoryDatabase -Query $sqlInstanceDetails

    if($instanceDetails.Count -eq 1) 
    {
        # If SQL Port is not provided, but should be present
        if ([String]::IsNullOrEmpty($Port4SqlInstanceToBaseline)) 
        {
            if (-not [String]::IsNullOrEmpty($instanceDetails.sql_instance_port)) 
            {
                $Port4SqlInstanceToBaseline = $instanceDetails.sql_instance_port
                $SqlInstanceToBaseline = "$SqlInstanceToBaseline,$Port4SqlInstanceToBaseline"
                $SqlInstanceToBaselineWithOutPort = $instanceDetails.sql_instance
            }
        }
    }
}
catch {
    $errMessage = $_

    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Could not fetch details from [$InventoryServer].[$InventoryDatabase].[dbo].[instance_details] info."
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "So assuming fresh installation of SQLMonitor."
}

# Setup SQL Connections
$conSqlInstanceToBaseline = Connect-DbaInstance -SqlInstance $SqlInstanceToBaseline -Database master -ClientName "Wrapper-RemoveSQLMonitor.ps1" `
                                                -SqlCredential $SqlCredential -TrustServerCertificate -EncryptConnection
if($InventoryServer -ne $SqlInstanceToBaseline) {
    $conInventoryServer = Connect-DbaInstance -SqlInstance $InventoryServer -Database master -ClientName "Wrapper-InstallSQLMonitor.ps1" `
                                                -SqlCredential $SqlCredential -TrustServerCertificate -EncryptConnection
} else {
    $conInventoryServer = $conSqlInstanceToBaseline
}


# Get Server Info
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Fetching basic server info.."
$sqlServerInfo = @"
DECLARE @Domain NVARCHAR(255);
begin try
	EXEC master.dbo.xp_regread 'HKEY_LOCAL_MACHINE', 'SYSTEM\CurrentControlSet\services\Tcpip\Parameters', N'Domain',@Domain OUTPUT;
end try
begin catch
	print 'some erorr accessing registry'
end catch

select	[domain] = default_domain(),
		[domain_reg] = @Domain,
		--[ip] = CONNECTIONPROPERTY('local_net_address'),
		[@@SERVERNAME] = @@SERVERNAME,
		[MachineName] = serverproperty('MachineName'),
		[ServerName] = serverproperty('ServerName'),
		[host_name] = SERVERPROPERTY('ComputerNamePhysicalNetBIOS'),
		SERVERPROPERTY('ProductVersion') AS ProductVersion,
		[service_name_str] = servicename,
		[service_name] = case	when @@servicename = 'MSSQLSERVER' and servicename like 'SQL Server (%)' then 'MSSQLSERVER'
								when @@servicename = 'MSSQLSERVER' and servicename like 'SQL Server Agent (%)' then 'SQLSERVERAGENT'
								when @@servicename <> 'MSSQLSERVER' and servicename like 'SQL Server (%)' then 'MSSQL$'+@@servicename
								when @@servicename <> 'MSSQLSERVER' and servicename like 'SQL Server Agent (%)' then 'SQLAgent'+@@servicename
								else 'MSSQL$'+@@servicename end,
        service_account,
		SERVERPROPERTY('Edition') AS Edition,
        [is_clustered] = case when exists (select 1 from sys.dm_os_cluster_nodes) then 1 else 0 end
from sys.dm_server_services 
where servicename like 'SQL Server (%)'
or servicename like 'SQL Server Agent (%)'
"@
try {
    $resultServerInfo = $conSqlInstanceToBaseline | Invoke-DbaQuery -Query $sqlServerInfo -EnableException
    $dbServiceInfo = $resultServerInfo | Where-Object {$_.service_name_str -like "SQL Server (*)"}
    $agentServiceInfo = $resultServerInfo | Where-Object {$_.service_name_str -like "SQL Server Agent (*)"}
    $resultServerInfo | Format-Table -AutoSize
}
catch {
    $errMessage = $_
    
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "SQL Connection to [$SqlInstanceToBaseline] failed."
    if([String]::IsNullOrEmpty($SqlCredential)) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Kindly provide SqlCredentials." | Write-Host -ForegroundColor Red
    } else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Provided SqlCredentials seems to be NOT working." | Write-Host -ForegroundColor Red
    }
    Write-Error "Stop here. Fix above issue."
}

# Extract domain & isClustered property
[bool]$isClustered = $dbServiceInfo.is_clustered
[string]$domain = $dbServiceInfo.domain_reg
if([String]::IsNullOrEmpty($domain)) {
    $domain = $dbServiceInfo.domain+'.com'
}

# Get dbo.instance_details info
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Fetching info from [dbo].[instance_details].."

$instanceDetailsFilePath = "$($env:TEMP)\$SqlInstanceToBaselineWithOutPort"
if([String]::IsNullOrEmpty($HostName)) {
    $sqlInstanceDetails = "select * from dbo.instance_details where sql_instance = '$SqlInstanceToBaselineWithOutPort'"
}
else {
    $instanceDetailsFilePath = $instanceDetailsFilePath + "__$HostName"
    $sqlInstanceDetails = "select * from dbo.instance_details where sql_instance = '$SqlInstanceToBaselineWithOutPort' and [host_name] = '$HostName'"
}

$instanceDetailsFilePath = "$instanceDetailsFilePath.xml"
try {
    $instanceDetails = @()
    $instanceDetails += $conInventoryServer | Invoke-DbaQuery -Database $InventoryDatabase -Query $sqlInstanceDetails
    if($instanceDetails.Count -eq 0) {
        $instanceDetails += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlInstanceDetails -EnableException
    }

    # If Instance Details file does not exists
    if( -not (Test-Path $instanceDetailsFilePath) ) {
        $instanceDetails | Export-Clixml -Path $instanceDetailsFilePath
    }
    else {
        # If Instance Details file exists
        $creationTime = Get-ChildItem -Path $instanceDetailsFilePath | select -ExpandProperty CreationTime
        if((Get-Date).AddDays(-2) -gt $creationTime) {
            Remove-Item $instanceDetailsFilePath | Out-Null
        }
    }
}
catch {
    $errMessage = $_

    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Could not fetch details from dbo.instance_details info." | Write-Host -ForegroundColor Red
    $($errMessage.Exception.Message -Split [Environment]::NewLine) | % {"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "$_"} | Write-Host -ForegroundColor Red

    # If Instance Details file does not exists
    if(Test-Path $instanceDetailsFilePath) {
        $instanceDetails += Import-Clixml -Path $instanceDetailsFilePath
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Using details from file '$instanceDetailsFilePath'.." | Write-Host -ForegroundColor DarkYellow
    }
    elseif ([String]::IsNullOrEmpty($SqlInstanceForTsqlJobs) -or [String]::IsNullOrEmpty($SqlInstanceForPowershellJobs) -or [String]::IsNullOrEmpty($SqlInstanceAsDataDestination)) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Even file '$instanceDetailsFilePath' was not found." | Write-Host -ForegroundColor Red
        Write-Error "Stop here. Fix above issue."
    }
}

# If no instance details found, then throw error
if ( $instanceDetails.Count -eq 0 ) {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Instance details could not be found in [dbo].[instance_details] on either [$InventoryServer] or [$SqlInstanceToBaseline].`n`t`tThis information is required to get HostName & Collector Instance details." | Write-Host -ForegroundColor Red
    if([String]::IsNullOrEmpty($SqlInstanceForTsqlJobs) -or [String]::IsNullOrEmpty($SqlInstanceForPowershellJobs) -or [String]::IsNullOrEmpty($SqlInstanceAsDataDestination)) {
        "STOP here, and fix above issue." | Write-Error
    }
}
else {
    $instanceDetails | ft -AutoSize
}

# If more than 1 host is found, then confirm from user
if ( $instanceDetails.Count -gt 1 ) 
{
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Multiple Hosts detected for SqlInstance [$SqlInstanceToBaseline]." | Write-Host -ForegroundColor DarkRed
    $instanceDetails | ft -AutoSize

    if($ConfirmValidationOfMultiInstance = $false) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Kindly either specify specific HostName or set ConfirmValidationOfMultiInstance to True.
                                        When executed with ConfirmValidationOfMultiInstance = `$True, then this infra removes SQLMonitor for 1st HostName from above resultset.
                                        So this function should be completed enough times to remove SQLMonitor for all Hosts of [$SqlInstanceToBaseline]." | Write-Host -ForegroundColor Red
        "STOP here, and fix above issue." | Write-Error
    }
}

# Assign top instance~host
$instanceDetailsForRemoval = $instanceDetails[0]

# Fetch HostName from SqlInstance if NULL
if([String]::IsNullOrEmpty($HostName)) {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Extract HostName from dbo.instance_details.."
    $HostName = $instanceDetailsForRemoval.host_name;
}

# Fetch DbaDatabase from SqlInstance if NULL
if([String]::IsNullOrEmpty($DbaDatabase)) {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Extract DbaDatabase from dbo.instance_details.."
    $DbaDatabase = $instanceDetailsForRemoval.database;
}

# If parameter values are not provided, then auto-fill them
if([String]::IsNullOrEmpty($SqlInstanceAsDataDestination)) { $SqlInstanceAsDataDestination = $instanceDetailsForRemoval.data_destination_sql_instance }
if([String]::IsNullOrEmpty($SqlInstanceForTsqlJobs)) { $SqlInstanceForTsqlJobs = $instanceDetailsForRemoval.collector_tsql_jobs_server }
if([String]::IsNullOrEmpty($SqlInstanceForTsqlJobs)) { $SqlInstanceForTsqlJobs = $SqlInstanceToBaseline }
if([String]::IsNullOrEmpty($SqlInstanceForPowershellJobs)) { $SqlInstanceForPowershellJobs = $instanceDetailsForRemoval.collector_powershell_jobs_server }
if([String]::IsNullOrEmpty($SqlInstanceForPowershellJobs)) { $SqlInstanceForPowershellJobs = $SqlInstanceToBaseline }
$hasTaskSchedulerJobs = $false
if (-not [String]::IsNullOrEmpty($instanceDetailsForRemoval.more_info)) {
    $moreInfoJSON = $instanceDetailsForRemoval.more_info
    $moreInfo = $moreInfoJSON | ConvertFrom-Json

    if( ($moreInfo.ForceSetupOfTaskSchedulerJobs -eq $true) -and ($hasTaskSchedulerJobs -eq $false) ) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Task Scheduler jobs are being used."
        $hasTaskSchedulerJobs = $true
    }
}


if( ($RemoteSQLMonitorPath -ne $instanceDetailsForRemoval.sqlmonitor_script_path) -and $RemoteSQLMonitorPath -ne 'C:\SQLMonitor' ) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "RemoteSQLMonitorPath parameter value does not match with dbo.instance_details." | Write-Host -ForegroundColor Red
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Consider updating details of dbo.instance_details on Inventory & Local Instance both." | Write-Host -ForegroundColor Red
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Or simply don't pass value for parameter RemoteSQLMonitorPath." | Write-Host -ForegroundColor Red
        
        "STOP here, and fix above issue." | Write-Error
    }else {
        if( ($RemoteSQLMonitorPath -ne $instanceDetailsForRemoval.sqlmonitor_script_path) -and $RemoteSQLMonitorPath -eq 'C:\SQLMonitor' ) {
            $RemoteSQLMonitorPath = $instanceDetailsForRemoval.sqlmonitor_script_path
        }
    }

"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$HostName = [$HostName]"
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$SqlInstanceAsDataDestination = [$SqlInstanceAsDataDestination]"
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$SqlInstanceForTsqlJobs = [$SqlInstanceForTsqlJobs]"
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$SqlInstanceForPowershellJobs = [$SqlInstanceForPowershellJobs]"
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$RemoteSQLMonitorPath = [$RemoteSQLMonitorPath]"

# Get SQL Connections
if([String]::IsNullOrEmpty($SqlInstanceAsDataDestination)) {
    $conSqlInstanceAsDataDestination = $conSqlInstanceToBaseline
} else {
    $conSqlInstanceAsDataDestination = Connect-DbaInstance -SqlInstance $SqlInstanceAsDataDestination -Database master -ClientName "Wrapper-InstallSQLMonitor.ps1" `
                                                -SqlCredential $SqlCredential -TrustServerCertificate -EncryptConnection
}
if([String]::IsNullOrEmpty($SqlInstanceForTsqlJobs)) {
    $conSqlInstanceForTsqlJobs = $conSqlInstanceToBaseline
} else {
    $conSqlInstanceForTsqlJobs = Connect-DbaInstance -SqlInstance $SqlInstanceForTsqlJobs -Database master -ClientName "Wrapper-InstallSQLMonitor.ps1" `
                                                -SqlCredential $SqlCredential -TrustServerCertificate -EncryptConnection
}
if([String]::IsNullOrEmpty($SqlInstanceForPowershellJobs)) {
    $conSqlInstanceForPowershellJobs = $conSqlInstanceToBaseline
} else {
    $conSqlInstanceForPowershellJobs = Connect-DbaInstance -SqlInstance $SqlInstanceForPowershellJobs -Database master -ClientName "Wrapper-InstallSQLMonitor.ps1" `
                                                -SqlCredential $SqlCredential -TrustServerCertificate -EncryptConnection
}


# Setup PSSession on HostName having Perfmon Data Collector. $ssn4PerfmonSetup
if( (-not $SkipRDPSessionSteps) ) #-and ($HostName -ne $env:COMPUTERNAME)
{
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Create PSSession for host [$HostName].."
    $ssnHostName = $HostName

    # Try reaching server using HostName provided/detected, if fails, then use FQDN
    if (-not (Test-Connection -ComputerName $ssnHostName -Quiet -Count 1)) {
        $ssnHostName = "$HostName.$domain"
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Host [$HostName] not pingable. So trying FQDN form [$ssnHostName].."
    }

    # Try reaching using FQDN, if fails & not a clustered instance, then use SqlInstanceToBaseline itself
    if ( (-not (Test-Connection -ComputerName $ssnHostName -Quiet -Count 1)) -and (-not $isClustered) ) {
        $ssnHostName = $SqlInstanceToBaseline
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Host [$ssnHostName] not pingable. Since its not clustered instance, So trying `$SqlInstanceToBaseline parameter value itself.."
    }

    # If not reachable after all attempts, raise error
    if ( -not (Test-Connection -ComputerName $ssnHostName -Quiet -Count 1) ) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Host [$ssnHostName] not pingable." | Write-Host -ForegroundColor Red
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Kindly provide HostName either in FQDN or ipv4 format." | Write-Host -ForegroundColor Red
        "STOP and check above error message" | Write-Error
    }

    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$ssnHostName => '$ssnHostName'"
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Domain of SqlInstance being baselined => [$domain]"
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Domain of current host => [$($env:USERDOMAIN)]"

    $ssn4PerfmonSetup = $null
    $errVariables = @()

    # First Attempt without Any credentials
    try {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Trying for PSSession on [$ssnHostName] normally.."
            $ssn4PerfmonSetup = New-PSSession -ComputerName $ssnHostName 
        }
    catch { $errVariables += $_ }

    # Second Attempt for Trusted Cross Domains
    if( [String]::IsNullOrEmpty($ssn4PerfmonSetup) ) {
        try { 
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Trying for PSSession on [$ssnHostName] assuming cross domain.."
            $ssn4PerfmonSetup = New-PSSession -ComputerName $ssnHostName -Authentication Negotiate 
        }
        catch { $errVariables += $_ }
    }

    # 3rd Attempt with Credentials
    if( [String]::IsNullOrEmpty($ssn) -and (-not [String]::IsNullOrEmpty($WindowsCredential)) ) {
        try {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Attemping PSSession for [$ssnHostName] using provided WindowsCredentials.."
            $ssn4PerfmonSetup = New-PSSession -ComputerName $ssnHostName -Credential $WindowsCredential    
        }
        catch { $errVariables += $_ }

        if( [String]::IsNullOrEmpty($ssn) ) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Attemping PSSession for [$ssnHostName] using provided WindowsCredentials with Negotiate attribute.."
            $ssn4PerfmonSetup = New-PSSession -ComputerName $ssnHostName -Credential $WindowsCredential -Authentication Negotiate
        }
    }

    if ( [String]::IsNullOrEmpty($ssn4PerfmonSetup) ) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Provide WindowsCredential for accessing server [$ssnHostName] of domain '$domain'." | Write-Host -ForegroundColor Red
        "STOP here, and fix above issue." | Write-Error
    }

    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$ssn4PerfmonSetup PSSession for [$HostName].."
    $ssn4PerfmonSetup | Format-Table -AutoSize
    "`n"
}


# Check No of SQL Services on HostName
if( (($SkipRemovePowerShellJobs -eq $false) -or ('11__RemoveJob_RemoveXEventFiles' -in $Steps2Execute)) -and ($SkipRDPSessionSteps -eq $false) )
{
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Check for number of SQLServices on [$HostName].."

    $sqlServicesOnHost = @()
    # Localhost system
    if( $HostName -eq $env:COMPUTERNAME ) {
        $sqlServicesOnHost += Get-Service MSSQL* | Where-Object {$_.DisplayName -like 'SQL Server (*)' -and $_.StartType -ne 'Disabled'}
    }
    else {
        $sqlServicesOnHost += Invoke-Command -Session $ssn4PerfmonSetup -ScriptBlock { 
                                    Get-Service MSSQL* | Where-Object {$_.DisplayName -like 'SQL Server (*)' -and $_.StartType -ne 'Disabled'} 
                            }
    }

    # If more than one sql services found, then ensure appropriate parameters are provided
    if($sqlServicesOnHost.Count -gt 1) 
    {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$($sqlServicesOnHost.Count) database engine Services found on [$HostName].."

        # If Destination instance is not provided, throw error
        if([String]::IsNullOrEmpty($SqlInstanceAsDataDestination) -or (-not $ConfirmValidationOfMultiInstance)) 
        {
            if([String]::IsNullOrEmpty($SqlInstanceAsDataDestination)) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Kindly provide value for parameter SqlInstanceAsDataDestination as host has multiple database engine services.`n`t`t`t`t`t`t This should be SqlInstance with Perfmon data." | Write-Host -ForegroundColor Red
            }
            if(-not $ConfirmValidationOfMultiInstance) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Kindly set ConfirmValidationOfMultiInstance parameter to true as host has multiple database engine services." | Write-Host -ForegroundColor Red
            }

            "STOP here, and fix above issue." | Write-Error
        }
        # If destination is provided, then validate if perfmon is not already get collected
        else {
            
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Validate if Perfmon data is not being collected already on [$SqlInstanceAsDataDestination] for same host.."
            $sqlPerfmonRecord = @"
select top 1 'dbo.performance_counters' as QueryData, getutcdate() as current_time_utc, collection_time_utc, pc.host_name
from dbo.performance_counters pc with (nolock)
where pc.collection_time_utc >= DATEADD(minute,-20,GETUTCDATE()) and host_name = '$HostName'
order by pc.collection_time_utc desc
"@
            $resultPerfmonRecord = @()
            try {
                $resultPerfmonRecord += $conSqlInstanceAsDataDestination | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlPerfmonRecord -EnableException
            }
            catch {
                $errMessage = $_.Exception.Message
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Error in retrieving details from dbo.performance_counters table of server [$SqlInstanceAsDataDestination]."
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$errMessage"
            }
            if($resultPerfmonRecord.Count -eq 0) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "No Perfmon data record found for last 20 minutes for host [$HostName] on [$SqlInstanceAsDataDestination]."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Perfmon data records of latest 20 minutes for host [$HostName] are present on [$SqlInstanceAsDataDestination]."
            }
        }
    }
}


# Get HostName for $SqlInstanceForPowershellJobs
if($SqlInstanceToBaseline -ne $SqlInstanceForPowershellJobs) 
{
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Fetching basic info for `$SqlInstanceForPowershellJobs => [$SqlInstanceForPowershellJobs].."
    try {
        $jobServerServicesInfo = @()
        $jobServerServicesInfo += $conSqlInstanceForPowershellJobs | Invoke-DbaQuery -Query $sqlServerInfo -EnableException

        $jobServerDbServiceInfo = $jobServerServicesInfo | Where-Object {$_.service_name_str -like "SQL Server (*)"}
        $jobServerAgentServiceInfo = $jobServerServicesInfo | Where-Object {$_.service_name_str -like "SQL Server Agent (*)"}
        $jobServerServicesInfo | Format-Table -AutoSize
    }
    catch {
        $errMessage = $_
    
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "SQL Connection to [$SqlInstanceToBaseline] failed."
        if([String]::IsNullOrEmpty($SqlCredential)) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Kindly provide SqlCredentials." | Write-Host -ForegroundColor Red
        } else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Provided SqlCredentials seems to be NOT working." | Write-Host -ForegroundColor Red
        }
        Write-Error "Stop here. Fix above issue."
    }
}
else {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$SqlInstanceToBaseline ~ `$SqlInstanceForPowershellJobs.."
    $jobServerServicesInfo = $resultServerInfo
    $jobServerDbServiceInfo = $dbServiceInfo
    $jobServerAgentServiceInfo = $agentServiceInfo
}


# Setup PSSession on $SqlInstanceForPowershellJobs
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Validating if PSSession is needed on `$SqlInstanceForPowershellJobs.."
if( (-not $SkipRDPSessionSteps) -and ($HostName -ne $jobServerDbServiceInfo.host_name) )
{
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Create PSSession for host [$($jobServerDbServiceInfo.host_name)].."
    $ssnHostName = $jobServerDbServiceInfo.host_name #+'.'+$jobServerDbServiceInfo.domain_reg

    # Try reaching server using HostName provided/detected, if fails, then use FQDN
    if (-not (Test-Connection -ComputerName $ssnHostName -Quiet -Count 1)) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Host [$ssnHostName] not pingable. So trying FQDN form.."
        $ssnHostName = $ssnHostName+'.'+$jobServerDbServiceInfo.domain_reg
    }

    # Try reaching using FQDN, if fails & not a clustered instance, then use SqlInstanceToBaseline itself
    if (-not (Test-Connection -ComputerName $ssnHostName -Quiet -Count 1)) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Host [$ssnHostName] not pingable. So trying `$SqlInstanceForPowershellJobs parameter value itself.."
        $ssnHostName = $SqlInstanceForPowershellJobs
    }

    # Try reaching using FQDN, if fails & not a clustered instance, then use SqlInstanceToBaseline itself
    if ( -not (Test-Connection -ComputerName $ssnHostName -Quiet -Count 1) ) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Host [$ssnHostName] not pingable." | Write-Host -ForegroundColor Red
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Kindly ensure pssession is working for `$SqlInstanceForPowershellJobs [$SqlInstanceForPowershellJobs]." | Write-Host -ForegroundColor Red
        "STOP and check above error message" | Write-Error
    }

    $ssnJobServer = $null
    $errVariables = @()

    # First Attempt without Any credentials
    try {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Trying for PSSession on [$ssnHostName] normally.."
            $ssnJobServer = New-PSSession -ComputerName $ssnHostName 
        }
    catch { $errVariables += $_ }

    # Second Attempt for Trusted Cross Domains
    if( [String]::IsNullOrEmpty($ssnJobServer) ) {
        try { 
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Trying for PSSession on [$ssnHostName] assuming cross domain.."
            $ssnJobServer = New-PSSession -ComputerName $ssnHostName -Authentication Negotiate 
        }
        catch { $errVariables += $_ }
    }

    # 3rd Attempt with Credentials
    if( [String]::IsNullOrEmpty($ssnJobServer) -and (-not [String]::IsNullOrEmpty($WindowsCredential)) ) {
        try {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Attemping PSSession for [$ssnHostName] using provided WindowsCredentials.."
            $ssnJobServer = New-PSSession -ComputerName $ssnHostName -Credential $WindowsCredential    
        }
        catch { $errVariables += $_ }

        if( [String]::IsNullOrEmpty($ssn) ) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Attemping PSSession for [$ssnHostName] using provided WindowsCredentials with Negotiate attribute.."
            $ssnJobServer = New-PSSession -ComputerName $ssnHostName -Credential $WindowsCredential -Authentication Negotiate
        }
    }

    if ( [String]::IsNullOrEmpty($ssnJobServer) ) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "Provide WindowsCredential for accessing server [$ssnHostName] of domain '$($sqlServerInfo.domain)'." | Write-Host -ForegroundColor Red
        "STOP here, and fix above issue." | Write-Error
    }

    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "PSSession for [$($jobServerDbServiceInfo.host_name)].."
    $ssnJobServer
}
else {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$ssnJobServer is same as `$ssn4PerfmonSetup."
    $ssnJobServer = $ssn4PerfmonSetup
}


# Validate if IPv4 is provided instead of DNS name for HostName
$pattern = "^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$"
if($HostName  -match $pattern) {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "IP address has been provided for `$HostName parameter."
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Fetching DNS name for [$HostName].."
    $HostName = Invoke-Command -Session $ssn4PerfmonSetup -ScriptBlock { $env:COMPUTERNAME }
}

# Validate if FQDN is provided instead of single part HostName
$pattern = "(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)"
if($HostName  -match $pattern) {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "FQDN has been provided for `$HostName parameter."
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Fetching DNS name for [$HostName].."
    $HostName = Invoke-Command -Session $ssn4PerfmonSetup -ScriptBlock { $env:COMPUTERNAME }
}


# Execute PreQuery
if(-not [String]::IsNullOrEmpty($PreQuery)) {
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Executing PreQuery on [$SqlInstanceToBaseline].." | Write-Host -ForegroundColor Cyan
    $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $PreQuery -EnableException
}


# 1__RemoveJob_CheckSQLAgentJobs
$stepName = '1__RemoveJob_CheckSQLAgentJobs'
if ($stepName -in $Steps2Execute) {
  $objName = '(dba) Check-SQLAgentJobs'
  $objType = 'job'
  $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

  "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
  if ($DryRun) {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
  }
  else {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
  }

  # Append HostName if Job Server is different    
  $objNameNew = $objName
  if ( ($SqlInstanceToBaseline -ne $SqlInstanceForPowershellJobs) -and ($HostName -ne $jobServerDbServiceInfo.host_name) ) {
    $objNameNew = "$objName - $HostName"
  }

  if ( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) {
    # If Job Server is Express edition
        
    $taskPath = '\DBA\'
    $parameters = @{
      Session      = $ssn4PerfmonSetup
      ScriptBlock  = {
        Param ($jobName, $taskPath)

        $taskObj = @()
        try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
        catch { "Some Error" | Out-Null }

        if ($taskObj.Count -gt 0) {                    
          $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
          "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
        }
        else {
          "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
        }
      }
      ArgumentList = $objNameNew, $taskPath
    }

    Invoke-Command @parameters -ErrorAction Stop
  }
  else { # If non-Express edition
    $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceForPowershellJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
    if ($resultRemoveObject.Count -gt 0) {
      $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
      if ($result -eq 1) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
      }
      else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
      }
    }
  }    
}


# 2__RemoveJob_CollectAgHealthState
$stepName = '2__RemoveJob_CollectAgHealthState'
if ($stepName -in $Steps2Execute) {
  $objName = '(dba) Collect-AgHealthState'
  $objType = 'job'
  $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

  "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
  if ($DryRun) {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
  }
  else {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
  }

  # Append HostName if Job Server is different    
  $objNameNew = $objName
  if ( ($SqlInstanceToBaseline -ne $SqlInstanceForPowershellJobs) -and ($HostName -ne $jobServerDbServiceInfo.host_name) ) {
    $objNameNew = "$objName - $HostName"
  }

  if ( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) {
    # If Job Server is Express edition
        
    $taskPath = '\DBA\'
    $parameters = @{
      Session      = $ssn4PerfmonSetup
      ScriptBlock  = {
        Param ($jobName, $taskPath)

        $taskObj = @()
        try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
        catch { "Some Error" | Out-Null }

        if ($taskObj.Count -gt 0) {                    
          $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
          "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
        }
        else {
          "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
        }
      }
      ArgumentList = $objNameNew, $taskPath
    }

    Invoke-Command @parameters -ErrorAction Stop
  }
  else { # If non-Express edition
    $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceForPowershellJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
    if ($resultRemoveObject.Count -gt 0) {
      $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
      if ($result -eq 1) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
      }
      else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
      }
    }
  }    
}


# 3__RemoveJob_CollectDiskSpace
$stepName = '3__RemoveJob_CollectDiskSpace'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Collect-DiskSpace'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append HostName if Job Server is different    
    $objNameNew = $objName
    if( ($SqlInstanceToBaseline -ne $SqlInstanceForPowershellJobs) -and ($HostName -ne $jobServerDbServiceInfo.host_name) ) {
        $objNameNew = "$objName - $HostName"
    }

    if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForPowershellJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }    
}


# 4__RemoveJob_CollectOSProcesses
$stepName = '4__RemoveJob_CollectOSProcesses'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Collect-OSProcesses'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append HostName if Job Server is different    
    $objNameNew = $objName
    if( ($SqlInstanceToBaseline -ne $SqlInstanceForPowershellJobs) -and ($HostName -ne $jobServerDbServiceInfo.host_name) ) {
        $objNameNew = "$objName - $HostName"
    }
        
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForPowershellJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 5__RemoveJob_CollectPerfmonData
$stepName = '5__RemoveJob_CollectPerfmonData'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Collect-PerfmonData'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append HostName if Job Server is different    
    $objNameNew = $objName
    if( ($SqlInstanceToBaseline -ne $SqlInstanceForPowershellJobs) -and ($HostName -ne $jobServerDbServiceInfo.host_name) ) {
        $objNameNew = "$objName - $HostName"
    }
        
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForPowershellJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 6__RemoveJob_CollectPrivilegedInfo
$stepName = '6__RemoveJob_CollectPrivilegedInfo'
if ($stepName -in $Steps2Execute) {
  $objName = '(dba) Collect-PrivilegedInfo'
  $objType = 'job'
  $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

  "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
  if ($DryRun) {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
  }
  else {
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
  }

  # Append HostName if Job Server is different    
  $objNameNew = $objName
  if ( ($SqlInstanceToBaseline -ne $SqlInstanceForPowershellJobs) -and ($HostName -ne $jobServerDbServiceInfo.host_name) ) {
    $objNameNew = "$objName - $HostName"
  }
        
  if ( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) {
    # If Job Server is Express edition
        
    $taskPath = '\DBA\'
    $parameters = @{
      Session      = $ssn4PerfmonSetup
      ScriptBlock  = {
        Param ($jobName, $taskPath)

        $taskObj = @()
        try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
        catch { "Some Error" | Out-Null }

        if ($taskObj.Count -gt 0) {                    
          $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
          "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
        }
        else {
          "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
        }
      }
      ArgumentList = $objNameNew, $taskPath
    }

    Invoke-Command @parameters -ErrorAction Stop
  }
  else { # If non-Express edition
    $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceForPowershellJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
    if ($resultRemoveObject.Count -gt 0) {
      $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
      if ($result -eq 1) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
      }
      else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
      }
    }
  }
}


# 7__RemoveJob_CollectWaitStats
$stepName = '7__RemoveJob_CollectWaitStats'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Collect-WaitStats'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append SQLInstance if Job Server is different    
    $objNameNew = $objName
    if($SqlInstanceToBaseline -ne $SqlInstanceForTsqlJobs) {
        $objNameNew = "$objName - $SqlInstanceToBaseline"
    }
        
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForTsqlJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 8__RemoveJob_CollectXEvents
$stepName = '8__RemoveJob_CollectXEvents'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Collect-XEvents'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append SQLInstance if Job Server is different    
    $objNameNew = $objName
    if($SqlInstanceToBaseline -ne $SqlInstanceForTsqlJobs) {
        $objNameNew = "$objName - $SqlInstanceToBaseline"
    }
        
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    #if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForTsqlJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 9__RemoveJob_PartitionsMaintenance
$stepName = '9__RemoveJob_PartitionsMaintenance'
if( $stepName -in $Steps2Execute ) {
    $objName = '(dba) Partitions-Maintenance'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append SQLInstance if Job Server is different    
    $objNameNew = $objName
    if($SqlInstanceToBaseline -ne $SqlInstanceForTsqlJobs) {
        $objNameNew = "$objName - $SqlInstanceToBaseline"
    }
        
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    #if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForTsqlJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 10__RemoveJob_PurgeTables
$stepName = '10__RemoveJob_PurgeTables'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Purge-Tables'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append SQLInstance if Job Server is different    
    $objNameNew = $objName
    if($SqlInstanceToBaseline -ne $SqlInstanceForTsqlJobs) {
        $objNameNew = "$objName - $SqlInstanceToBaseline"
    }
        
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    #if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForTsqlJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 11__RemoveJob_RemoveXEventFiles
$stepName = '11__RemoveJob_RemoveXEventFiles'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Remove-XEventFiles'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append SQLInstance if Job Server is different    
    $objNameNew = $objName
    if( ($SqlInstanceToBaseline -ne $SqlInstanceForPowershellJobs) ) {
        $objNameNew = "$objName - $SqlInstanceToBaseline"
    }
        
    #if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForPowershellJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 12__RemoveJob_RunWhoIsActive
$stepName = '12__RemoveJob_RunWhoIsActive'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Run-WhoIsActive'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append SQLInstance if Job Server is different    
    $objNameNew = $objName
    if($SqlInstanceToBaseline -ne $SqlInstanceForTsqlJobs) {
        $objNameNew = "$objName - $SqlInstanceToBaseline"
    }
        
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    #if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForTsqlJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 13__RemoveJob_CollectFileIOStats
$stepName = '13__RemoveJob_CollectFileIOStats'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Collect-FileIOStats'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append SQLInstance if Job Server is different    
    $objNameNew = $objName
    if($SqlInstanceToBaseline -ne $SqlInstanceForTsqlJobs) {
        $objNameNew = "$objName - $SqlInstanceToBaseline"
    }
        
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    #if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForTsqlJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 14__RemoveJob_CollectMemoryClerks
$stepName = '14__RemoveJob_CollectMemoryClerks'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Collect-MemoryClerks'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append SQLInstance if Job Server is different    
    $objNameNew = $objName
    if($SqlInstanceToBaseline -ne $SqlInstanceForTsqlJobs) {
        $objNameNew = "$objName - $SqlInstanceToBaseline"
    }
        
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    #if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForTsqlJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 15__RemoveJob_RunBlitzIndex
$stepName = '15__RemoveJob_RunBlitzIndex'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Run-BlitzIndex'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append SQLInstance if Job Server is different    
    $objNameNew = $objName
    if($SqlInstanceToBaseline -ne $SqlInstanceForTsqlJobs) {
        $objNameNew = "$objName - $SqlInstanceToBaseline"
    }

    if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    #if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName,"$jobName - Weekly" -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name like '$objNameNew%')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
  $(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew - Weekly', @delete_unused_schedule=1;
    select 1 as object_exists;

end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForTsqlJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 16__RemoveJob_RunBlitz
$stepName = '16__RemoveJob_RunBlitz'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Run-Blitz'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append SQLInstance if Job Server is different    
    $objNameNew = $objName
    if($SqlInstanceToBaseline -ne $SqlInstanceForTsqlJobs) {
        $objNameNew = "$objName - $SqlInstanceToBaseline"
    }
        
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    #if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForTsqlJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 17__RemoveJob_RunLogSaver
$stepName = '17__RemoveJob_RunLogSaver'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Run-LogSaver'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append SQLInstance if Job Server is different    
    $objNameNew = $objName
    if($SqlInstanceToBaseline -ne $SqlInstanceForTsqlJobs) {
        $objNameNew = "$objName - $SqlInstanceToBaseline"
    }
        
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    #if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForTsqlJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 18__RemoveJob_RunTempDbSaver
$stepName = '18__RemoveJob_RunTempDbSaver'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Run-TempDbSaver'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append SQLInstance if Job Server is different    
    $objNameNew = $objName
    if($SqlInstanceToBaseline -ne $SqlInstanceForTsqlJobs) {
        $objNameNew = "$objName - $SqlInstanceToBaseline"
    }
        
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    #if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForTsqlJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}



# 19__RemoveJob_UpdateSqlServerVersions
$stepName = '19__RemoveJob_UpdateSqlServerVersions'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Update-SqlServerVersions'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append HostName if Job Server is different    
    $objNameNew = $objName
    if( ($SqlInstanceToBaseline -ne $SqlInstanceForPowershellJobs) -and ($HostName -ne $jobServerDbServiceInfo.host_name) ) {
        $objNameNew = "$objName - $HostName"
    }
        
    #if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForPowershellJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 20__RemoveJob_CheckInstanceAvailability
$stepName = '20__RemoveJob_CheckInstanceAvailability'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Check-InstanceAvailability'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append HostName if Job Server is different    
    $objNameNew = $objName
    if( ($SqlInstanceToBaseline -ne $SqlInstanceForPowershellJobs) -and ($HostName -ne $jobServerDbServiceInfo.host_name) ) {
        $objNameNew = "$objName - $HostName"
    }
        
    #if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForPowershellJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 21__RemoveJob_GetAllServerInfo
$stepName = '21__RemoveJob_GetAllServerInfo'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Get-AllServerInfo'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append SQLInstance if Job Server is different    
    $objNameNew = $objName
    if($SqlInstanceToBaseline -ne $SqlInstanceForTsqlJobs) {
        $objNameNew = "$objName - $SqlInstanceToBaseline"
    }
        
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    #if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForTsqlJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 22__RemoveJob_GetAllServerCollectedData
$stepName = '22__RemoveJob_GetAllServerCollectedData'
if($stepName -in $Steps2Execute) {
    $objName = '(dba) Get-AllServerCollectedData'
    $objType = 'job'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase($objType)

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }

    # Append SQLInstance if Job Server is different    
    $objNameNew = $objName
    if($SqlInstanceToBaseline -ne $SqlInstanceForTsqlJobs) {
        $objNameNew = "$objName - $SqlInstanceToBaseline"
    }
        
    if( ($SqlInstanceToBaseline -eq $SqlInstanceForTsqlJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    #if( ($SqlInstanceToBaseline -eq $SqlInstanceForPowershellJobs) -and ($jobServerDbServiceInfo.Edition -like 'Express*' -or $hasTaskSchedulerJobs) -and ($DryRun -eq $false) ) 
    { # If Job Server is Express edition
        
        $taskPath = '\DBA\'
        $parameters = @{
            Session = $ssn4PerfmonSetup
            ScriptBlock = {
                Param ($jobName, $taskPath)

                $taskObj = @()
                try { $taskObj += Get-ScheduledTask -TaskName $jobName -TaskPath $taskPath -ErrorAction SilentlyContinue }
                catch { "Some Error" | Out-Null }

                if($taskObj.Count -gt 0) {                    
                    $taskObj | Unregister-ScheduledTask -Confirm:$false | Out-Null
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Job '$($taskPath)$($jobName)' found and removed."
                }
                else {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Job '$($taskPath)$($jobName)' could not be found."
                }
            }
            ArgumentList = $objNameNew, $taskPath
        }

        Invoke-Command @parameters -ErrorAction Stop
    }
    else # If non-Express edition
    {
        $sqlRemoveObject = @"
if exists (select * from msdb.dbo.sysjobs_view where name = N'$objNameNew')
begin
	$(if($DryRun){'--'})EXEC msdb.dbo.sp_delete_job @job_name=N'$objNameNew', @delete_unused_schedule=1;
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceForTsqlJobs | Invoke-DbaQuery -Database msdb -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objNameNew' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objNameNew' not found."
            }
        }
    }
}


# 23__DropProc_UspExtendedResults
$stepName = '23__DropProc_UspExtendedResults'
if($stepName -in $Steps2Execute) {
    $objName = 'usp_extended_results'
    $objType = 'procedure'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP PROCEDURE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 24__DropProc_UspCollectWaitStats
$stepName = '24__DropProc_UspCollectWaitStats'
if($stepName -in $Steps2Execute) {
    $objName = 'usp_collect_wait_stats'
    $objType = 'procedure'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP PROCEDURE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 25__DropProc_UspRunWhoIsActive
$stepName = '25__DropProc_UspRunWhoIsActive'
if($stepName -in $Steps2Execute) {
    $objName = 'usp_run_WhoIsActive'
    $objType = 'procedure'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP PROCEDURE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 26__DropProc_UspCollectXEventsXEventMetrics
$stepName = '26__DropProc_UspCollectXEventsXEventMetrics'
if($stepName -in $Steps2Execute) {
    $objName = 'usp_collect_xevents_xevent_metrics'
    $objType = 'procedure'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP PROCEDURE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 27__DropProc_UspPartitionMaintenance
$stepName = '27__DropProc_UspPartitionMaintenance'
if($stepName -in $Steps2Execute) {
    $objName = 'usp_partition_maintenance'
    $objType = 'procedure'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP PROCEDURE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 28__DropProc_UspPurgeTables
$stepName = '28__DropProc_UspPurgeTables'
if($stepName -in $Steps2Execute) {
    $objName = 'usp_purge_tables'
    $objType = 'procedure'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP PROCEDURE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 29__DropProc_SpWhatIsRunning
$stepName = '29__DropProc_SpWhatIsRunning'
if($stepName -in $Steps2Execute) {
    $objName = 'sp_WhatIsRunning'
    $objType = 'procedure'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP PROCEDURE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 30__DropProc_UspActiveRequestsCount
$stepName = '30__DropProc_UspActiveRequestsCount'
if($stepName -in $Steps2Execute) {
    $objName = 'usp_active_requests_count'
    $objType = 'procedure'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP PROCEDURE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 31__DropProc_UspCollectFileIOStats
$stepName = '31__DropProc_UspCollectFileIOStats'
if($stepName -in $Steps2Execute) {
    $objName = 'usp_collect_file_io_stats'
    $objType = 'procedure'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP PROCEDURE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 32__DropProc_UspEnablePageCompression
$stepName = '32__DropProc_UspEnablePageCompression'
if($stepName -in $Steps2Execute) {
    $objName = 'usp_enable_page_compression'
    $objType = 'procedure'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP PROCEDURE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 33__DropProc_UspWaitsPerCorePerMinute
$stepName = '33__DropProc_UspWaitsPerCorePerMinute'
if($stepName -in $Steps2Execute) {
    $objName = 'usp_waits_per_core_per_minute'
    $objType = 'procedure'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP PROCEDURE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 34__DropProc_UspCollectMemoryClerks
$stepName = '34__DropProc_UspCollectMemoryClerks'
if($stepName -in $Steps2Execute) {
    $objName = 'usp_collect_memory_clerks'
    $objType = 'procedure'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP PROCEDURE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 35__DropProc_UspWrapperGetAllServerInfo
$stepName = '35__DropProc_UspWrapperGetAllServerInfo'
if($stepName -in $Steps2Execute) {
    $objName = 'usp_wrapper_GetAllServerInfo'
    $objType = 'procedure'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP PROCEDURE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 36__DropProc_UspPopulateAllServerVolatileInfoHistory
$stepName = '36__DropProc_UspPopulateAllServerVolatileInfoHistory'
if($stepName -in $Steps2Execute) {
    $objName = 'usp_populate__all_server_volatile_info_history'
    $objType = 'procedure'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP PROCEDURE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 37__DropProc_UspGetAllServerInfo
$stepName = '37__DropProc_UspGetAllServerInfo'
if($stepName -in $Steps2Execute) {
    $objName = 'usp_GetAllServerInfo'
    $objType = 'procedure'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP PROCEDURE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 38__DropView_VwPerformanceCounters
$stepName = '38__DropView_VwPerformanceCounters'
if($stepName -in $Steps2Execute) {
    $objName = 'vw_performance_counters'
    $objType = 'view'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP VIEW [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 39__DropView_VwOsTaskList
$stepName = '39__DropView_VwOsTaskList'
if($stepName -in $Steps2Execute) {
    $objName = 'vw_os_task_list'
    $objType = 'view'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP VIEW [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 40__DropView_VwWaitStatsDeltas
$stepName = '40__DropView_VwWaitStatsDeltas'
if($stepName -in $Steps2Execute) {
    $objName = 'vw_wait_stats_deltas'
    $objType = 'view'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP VIEW [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 41__DropView_vw_file_io_stats_deltas
$stepName = '41__DropView_vw_file_io_stats_deltas'
if($stepName -in $Steps2Execute) {
    $objName = 'vw_file_io_stats_deltas'
    $objType = 'view'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP VIEW [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 42__DropView_vw_xevent_metrics
$stepName = '42__DropView_vw_xevent_metrics'
if($stepName -in $Steps2Execute) {
    $objName = 'vw_xevent_metrics'
    $objType = 'view'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP VIEW [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 43__DropView_vw_disk_space
$stepName = '43__DropView_vw_disk_space'
if($stepName -in $Steps2Execute) {
    $objName = 'vw_disk_space'
    $objType = 'view'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP VIEW [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 44__DropView_vw_all_server_info
$stepName = '44__DropView_vw_all_server_info'
if($stepName -in $Steps2Execute) {
    $objName = 'vw_all_server_info'
    $objType = 'view'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP VIEW [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 45__DropXEvent_XEventMetrics
$stepName = '45__DropXEvent_XEventMetrics'
if($stepName -in $Steps2Execute) {
    $objName = 'xevent_metrics'
    $objType = 'xevent'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (SELECT * FROM sys.server_event_sessions WHERE name = N'$objName')
begin
    -- Get XEvent files directory
    ;with targets_xml as (
	    select	target_data_xml = CONVERT(XML, target_data)
	    from sys.dm_xe_sessions xs
	    join sys.dm_xe_session_targets xt on xt.event_session_address = xs.address
	    where xs.name = '$objName'
	    and xt.target_name = 'event_file'
    )
    ,targets_current as (
	    select file_path = t.target_data_xml.value('(/EventFileTarget/File/@name)[1]','varchar(2000)')
	    from targets_xml t
    )
    select [xe_directory] = (case when CHARINDEX('\',reverse(t.file_path)) <> 0 then SUBSTRING(t.file_path,1,LEN(t.file_path)-CHARINDEX('\',reverse(t.file_path))+1)
							    when CHARINDEX('/',reverse(t.file_path)) <> 0 then SUBSTRING(t.file_path,1,LEN(t.file_path)-CHARINDEX('/',reverse(t.file_path))+1)
							    end),
		    [object_exists] = case when t.file_path is not null then 1 else 0 end
    from targets_current t full outer join (values (0)) existence(object_exists) on 1=1

	$(if($DryRun){'--'})DROP EVENT SESSION [$objName] ON SERVER;
end
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database master -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $XEventFilesDirectory = $resultRemoveObject | Select-Object -ExpandProperty xe_directory;
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "XEvent Directory => '$XEventFilesDirectory'."
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 46__DropLinkedServer
$stepName = '46__DropLinkedServer'
if($stepName -in $Steps2Execute) 
{    
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."

    # Remove linked server on Inventory
    $objName = $SqlInstanceToBaseline
    $objType = 'linked server'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")    

    if($SqlInstanceToBaseline -ne $InventoryServer) 
    {
        if($DryRun) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
        }
        
        $sqlRemoveObject = @"
    if exists (select 1 from sys.servers s where s.provider = 'SQLNCLI' and name = '$objName')
    begin
	    $(if($DryRun){'--'})EXEC master.dbo.sp_dropserver @server=N'$objName', @droplogins='droplogins'
        select 1 as object_exists;
    end
    else
        select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conInventoryServer | Invoke-DbaQuery -Database master -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
            }
        }
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Current instance is inventory instance. Can't remove system created Linked Server."
    }


    # Remove linked server on [$SqlInstanceToBaseline] for [$SqlInstanceAsDataDestination]
    $objName = $SqlInstanceAsDataDestination
    $objType = 'linked server'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")    

    if( ($SqlInstanceToBaseline -ne $SqlInstanceAsDataDestination) -and ($SqlInstanceToBaseline -ne $InventoryServer) )
    {
        if($DryRun) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
        }
        
        $sqlRemoveObject = @"
    if exists (select 1 from sys.servers s where s.provider = 'SQLNCLI' and name = '$objName')
    begin
	    $(if($DryRun){'--'})EXEC master.dbo.sp_dropserver @server=N'$objName', @droplogins='droplogins'
        select 1 as object_exists;
    end
    else
        select 0 as object_exists;
"@
        $resultRemoveObject = @()
        $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database master -Query $sqlRemoveObject -EnableException
        if($resultRemoveObject.Count -gt 0) 
        {
            $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
            if($result -eq 1) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
            }
        }
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Current instance is inventory instance. Can't remove system created Linked Server."
    }
}


# 47__DropLogin_Grafana
$stepName = '47__DropLogin_Grafana'
if($stepName -in $Steps2Execute) {
    $objName = 'grafana'
    $objType = 'login'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select 1 from sys.server_principals where name = '$objName')
begin
	$(if($DryRun){'--'})DROP LOGIN [$objName];
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database master -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 48__DropTable_XEventMetrics
$stepName = '48__DropTable_XEventMetrics'
if($stepName -in $Steps2Execute) {
    $objName = 'xevent_metrics'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 49__DropTable_xevent_metrics_queries
$stepName = '49__DropTable_xevent_metrics_queries'
if($stepName -in $Steps2Execute) {
    $objName = 'xevent_metrics_queries'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 50__DropTable_XEventMetricsProcessedXELFiles
$stepName = '50__DropTable_XEventMetricsProcessedXELFiles'
if($stepName -in $Steps2Execute) {
    $objName = 'xevent_metrics_Processed_XEL_Files'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 52__DropTable_WhoIsActive_Staging
$stepName = '52__DropTable_WhoIsActive_Staging'
if($stepName -in $Steps2Execute) {
    $objName = 'WhoIsActive_Staging'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 52__DropTable_WhoIsActive
$stepName = '52__DropTable_WhoIsActive'
if($stepName -in $Steps2Execute) {
    $objName = 'WhoIsActive'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 53__DropTable_PerformanceCounters
$stepName = '53__DropTable_PerformanceCounters'
if($stepName -in $Steps2Execute) {
    $objName = 'performance_counters'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 54__DropTable_PurgeTable
$stepName = '54__DropTable_PurgeTable'
if($stepName -in $Steps2Execute) {
    $objName = 'purge_table'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 55__DropTable_PerfmonFiles
$stepName = '55__DropTable_PerfmonFiles'
if($stepName -in $Steps2Execute) {
    $objName = 'perfmon_files'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 56__DropTable_InstanceDetails
$stepName = '56__DropTable_InstanceDetails'
if( ($stepName -in $Steps2Execute) -and ($ActionType -eq 'Delete') ) {
    $objName = 'instance_details'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 57__DropTable_InstanceHosts
$stepName = '57__DropTable_InstanceHosts'
if( ($stepName -in $Steps2Execute) -and ($ActionType -eq 'Delete') ) {
    $objName = 'instance_hosts'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 58__DropTable_OsTaskList
$stepName = '58__DropTable_OsTaskList'
if($stepName -in $Steps2Execute) {
    $objName = 'os_task_list'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 59__DropTable_BlitzWho
$stepName = '59__DropTable_BlitzWho'
if($stepName -in $Steps2Execute) {
    $objName = 'BlitzWho'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 60__DropTable_BlitzCache
$stepName = '60__DropTable_BlitzCache'
if($stepName -in $Steps2Execute) {
    $objName = 'BlitzCache'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 61__DropTable_ConnectionHistory
$stepName = '61__DropTable_ConnectionHistory'
if($stepName -in $Steps2Execute) {
    $objName = 'connection_history'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 62__DropTable_BlitzFirst
$stepName = '62__DropTable_BlitzFirst'
if($stepName -in $Steps2Execute) {
    $objName = 'BlitzFirst'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 63__DropTable_BlitzFirstFileStats
$stepName = '63__DropTable_BlitzFirstFileStats'
if($stepName -in $Steps2Execute) {
    $objName = 'BlitzFirst_FileStats'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 64__DropTable_DiskSpace
$stepName = '64__DropTable_DiskSpace'
if($stepName -in $Steps2Execute) {
    $objName = 'disk_space'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 65__DropTable_BlitzFirstPerfmonStats
$stepName = '65__DropTable_BlitzFirstPerfmonStats'
if($stepName -in $Steps2Execute) {
    $objName = 'BlitzFirst_PerfmonStats'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 66__DropTable_BlitzFirstWaitStats
$stepName = '66__DropTable_BlitzFirstWaitStats'
if($stepName -in $Steps2Execute) {
    $objName = 'BlitzFirst_WaitStats'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 67__DropTable_BlitzFirstWaitStatsCategories
$stepName = '67__DropTable_BlitzFirstWaitStatsCategories'
if($stepName -in $Steps2Execute) {
    $objName = 'BlitzFirst_WaitStats_Categories'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 68__DropTable_WaitStats
$stepName = '68__DropTable_WaitStats'
if($stepName -in $Steps2Execute) {
    $objName = 'wait_stats'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}



# 69__DropTable_BlitzIndex
$stepName = '69__DropTable_BlitzIndex'
if($stepName -in $Steps2Execute) {
    $objName = 'BlitzIndex'
    $objType = 'tables'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType like '$objName%'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType like '$objName%'.."
    }

    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped = 0 and name like 'BlitzIndex%')
begin
    select 1 as object_exists, [name] as table_name
    into #BlitzIndex
    from sys.objects where is_ms_shipped = 0 and name like 'BlitzIndex%';

	  if ($(if($DryRun){'0'}else{'1'}) = 1)
    begin
      IF OBJECT_ID('[dbo].[BlitzIndex]') IS NOT NULL
          EXEC ('DROP TABLE [dbo].[BlitzIndex]');
      IF OBJECT_ID('[dbo].[BlitzIndex_Mode0]') IS NOT NULL
          EXEC ('DROP TABLE [dbo].[BlitzIndex_Mode0]');
      IF OBJECT_ID('[dbo].[BlitzIndex_Mode1]') IS NOT NULL
          EXEC ('DROP TABLE [dbo].[BlitzIndex_Mode1]');
      IF OBJECT_ID('[dbo].[BlitzIndex_Mode4]') IS NOT NULL
          EXEC ('DROP TABLE [dbo].[BlitzIndex_Mode4]');
    end

    select [object_exists] = case when o.name is not null then 1 else 0 end,
        bi.table_name
    from #BlitzIndex bi left join sys.objects o on bi.table_name = o.name;
end
else
    select 0 as object_exists, convert(varchar,null) as table_name;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0)
    {
        $notExistingObjects = @()
        $stillExistingObjects = @()
        $foundAndRemovedObjects = @()

        $foundAndRemovedObjects += $resultRemoveObject | Where-Object { ([String]::IsNullOrEmpty($_.table_name) -eq $false) -and ($_.object_exists -eq 0)}
        $stillExistingObjects += $resultRemoveObject | Where-Object { ([String]::IsNullOrEmpty($_.table_name) -eq $false) -and ($_.object_exists -eq 1)}
        #$notExistingObjects += $resultRemoveObject | Where-Object { ([String]::IsNullOrEmpty($_.table_name) -eq $false) -and ($_.object_exists -eq 0)}

        if($foundAndRemovedObjects.Count -gt 0) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$($foundAndRemovedObjects.Count) $objTypeTitleCase like '$objName%' found and removed."
        }
        if($stillExistingObjects.Count -gt 0) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$($stillExistingObjects.Count) $objTypeTitleCase like '$objName%' found, but could not be removed."
        }
        if( ($foundAndRemovedObjects.Count + $stillExistingObjects.Count) -gt 0 ) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase like '$objName%' not found."
        }
    }
}


# 70__DropTable_Blitz
$stepName = '70__DropTable_Blitz'
if($stepName -in $Steps2Execute) {
    $objName = 'Blitz'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 71__DropTable_FileIOStats
$stepName = '71__DropTable_FileIOStats'
if($stepName -in $Steps2Execute) {
    $objName = 'file_io_stats'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 72__DropTable_MemoryClerks
$stepName = '72__DropTable_MemoryClerks'
if($stepName -in $Steps2Execute) {
    $objName = 'memory_clerks'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 73__DropTable_AgHealthState
$stepName = '73__DropTable_AgHealthState'
if($stepName -in $Steps2Execute) {
    $objName = 'ag_health_state'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 74__DropTable_LogSpaceConsumers
$stepName = '74__DropTable_LogSpaceConsumers'
if($stepName -in $Steps2Execute) {
    $objName = 'log_space_consumers'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 75__DropTable_PrivilegedInfo
$stepName = '75__DropTable_PrivilegedInfo'
if($stepName -in $Steps2Execute) {
    $objName = 'server_privileged_info'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 76__DropTable_SqlAgentJobStats
$stepName = '76__DropTable_SqlAgentJobStats'
if($stepName -in $Steps2Execute) {
    $objName = 'sql_agent_job_stats'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 77__DropTable_SqlAgentJobThresholds
$stepName = '77__DropTable_SqlAgentJobThresholds'
if($stepName -in $Steps2Execute) {
    $objName = 'sql_agent_job_thresholds'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 78__DropTable_TempdbSpaceConsumers
$stepName = '78__DropTable_TempdbSpaceConsumers'
if($stepName -in $Steps2Execute) {
    $objName = 'tempdb_space_consumers'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 79__DropTable_TempdbSpaceUsage
$stepName = '79__DropTable_TempdbSpaceUsage'
if($stepName -in $Steps2Execute) {
    $objName = 'tempdb_space_usage'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 80__DropTable_AllServerCollectionLatencyInfo
$stepName = '80__DropTable_AllServerCollectionLatencyInfo'
if($stepName -in $Steps2Execute) {
    $objName = 'all_server_collection_latency_info'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 82__DropTable_AllServerVolatileInfoHistory
$stepName = '82__DropTable_AllServerVolatileInfoHistory'
if($stepName -in $Steps2Execute) {
    $objName = 'all_server_volatile_info_history'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 82__DropTable_AllServerVolatileInfoHistory
$stepName = '82__DropTable_AllServerVolatileInfoHistory'
if($stepName -in $Steps2Execute) {
    $objName = 'all_server_volatile_info_history'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 82__DropTable_AllServerVolatileInfo
$stepName = '82__DropTable_AllServerVolatileInfo'
if($stepName -in $Steps2Execute) {
    $objName = 'all_server_volatile_info'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 83__DropTable_AllServerStableInfo
$stepName = '83__DropTable_AllServerStableInfo'
if($stepName -in $Steps2Execute) {
    $objName = 'all_server_stable_info'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 85__DropTable_DiskSpaceAllServersStaging
$stepName = '85__DropTable_DiskSpaceAllServersStaging'
if($stepName -in $Steps2Execute) {
    $objName = 'disk_space_all_servers__staging'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 85__DropTable_DiskSpaceAllServers
$stepName = '85__DropTable_DiskSpaceAllServers'
if($stepName -in $Steps2Execute) {
    $objName = 'disk_space_all_servers'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 86__DropTable_LogSpaceConsumersAllServers
$stepName = '86__DropTable_LogSpaceConsumersAllServers'
if($stepName -in $Steps2Execute) {
    $objName = 'log_space_consumers_all_servers'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 87__DropTable_LogSpaceConsumersAllServersStaging
$stepName = '87__DropTable_LogSpaceConsumersAllServersStaging'
if($stepName -in $Steps2Execute) {
    $objName = 'log_space_consumers_all_servers__staging'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 88__DropTable_SqlAgentJobsAllServers
$stepName = '88__DropTable_SqlAgentJobsAllServers'
if($stepName -in $Steps2Execute) {
    $objName = 'sql_agent_jobs_all_servers'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 89__DropTable_SqlAgentJobsAllServersStaging
$stepName = '89__DropTable_SqlAgentJobsAllServersStaging'
if($stepName -in $Steps2Execute) {
    $objName = 'sql_agent_jobs_all_servers__staging'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 90__DropTable_TempdbSpaceUsageAllServers
$stepName = '90__DropTable_TempdbSpaceUsageAllServers'
if($stepName -in $Steps2Execute) {
    $objName = 'tempdb_space_usage_all_servers'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 91__DropTable_TempdbSpaceUsageAllServersStaging
$stepName = '91__DropTable_TempdbSpaceUsageAllServersStaging'
if($stepName -in $Steps2Execute) {
    $objName = 'tempdb_space_usage_all_servers__staging'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 92__DropTable_AgHealthStateAllServers
$stepName = '92__DropTable_AgHealthStateAllServers'
if($stepName -in $Steps2Execute) {
    $objName = 'ag_health_state_all_servers'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 93__DropTable_AgHealthStateAllServersStaging
$stepName = '93__DropTable_AgHealthStateAllServersStaging'
if($stepName -in $Steps2Execute) {
    $objName = 'ag_health_state_all_servers__staging'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 94__DropTable_AllServerVolatileInfoHistory
$stepName = '94__DropTable_AllServerVolatileInfoHistory'
if($stepName -in $Steps2Execute) {
    $objName = 'all_server_volatile_info_history'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 95__DropTable_DiskSpaceAllServersStaging
$stepName = '95__DropTable_DiskSpaceAllServersStaging'
if($stepName -in $Steps2Execute) {
    $objName = 'disk_space_all_servers__staging'
    $objType = 'table'
    $objTypeTitleCase = (Get-Culture).TextInfo.ToTitleCase("$objType")

    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Find & remove $objType '$objName'.."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Find & remove $objType '$objName'.."
    }
        
    $sqlRemoveObject = @"
if exists (select * from sys.objects where is_ms_shipped= 0 and name = N'$objName')
begin
	$(if($DryRun){'--'})DROP TABLE [dbo].[$objName]
    select 1 as object_exists;
end
else
    select 0 as object_exists;
"@
    $resultRemoveObject = @()
    $resultRemoveObject += $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $sqlRemoveObject -EnableException
    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "$objTypeTitleCase '$objName' found and removed."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "$objTypeTitleCase '$objName' not found."
        }
    }
}


# 96__RemovePerfmonFilesFromDisk
$stepName = '96__RemovePerfmonFilesFromDisk'
if($stepName -in $Steps2Execute) 
{
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."
    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Remove folder '$RemoteSQLMonitorPath' on [$ssnHostName]"
    
    if($HostName -eq $env:COMPUTERNAME)
    {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Checking for [$DataCollectorSetName] data collector set existence.."
        $pfCollector = @()
        $pfCollector += Get-DbaPfDataCollector -CollectorSet $DataCollectorSetName
        if($pfCollector.Count -gt 0) 
        {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Data Collector [$DataCollectorSetName] exists."
            if($DryRun) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Data Collector Set [$DataCollectorSetName] removed."
            }
            else {
                logman stop -name $DataCollectorSetName
                logman delete -name $DataCollectorSetName
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Data Collector Set [$DataCollectorSetName] removed."
            }
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "[$DataCollectorSetName] Data Collector not found."
        }

        if(Test-Path $RemoteSQLMonitorPath)
        {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "'$RemoteSQLMonitorPath' exists."
            if($DryRun) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "'$RemoteSQLMonitorPath' removed."
            }
            else {
                Remove-Item $RemoteSQLMonitorPath -Recurse -Force -ErrorAction Stop
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "'$RemoteSQLMonitorPath' removed."
            }
        }
        else{
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "'$RemoteSQLMonitorPath' does not exists."
        }
    }
    else
    {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Checking for [$DataCollectorSetName] data collector set existence.."
        Invoke-Command -Session $ssn4PerfmonSetup -ScriptBlock {                
            $pfCollector = @()
            $pfCollector += Get-DbaPfDataCollector -CollectorSet $Using:DataCollectorSetName

            if($pfCollector.Count -gt 0) 
            {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Data Collector [$Using:DataCollectorSetName] exists."
                if($Using:DryRun) {
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Data Collector Set [$Using:DataCollectorSetName] removed."
                }
                else {
                    logman stop -name $Using:DataCollectorSetName
                    logman delete -name $Using:DataCollectorSetName
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Data Collector Set [$Using:DataCollectorSetName] removed."
                }
            }
            else {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "[$Using:DataCollectorSetName] Data Collector not found."
            }
        }

        if( (Invoke-Command -Session $ssn4PerfmonSetup -ScriptBlock {Test-Path $Using:RemoteSQLMonitorPath}) ) 
        {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "'$RemoteSQLMonitorPath' exists on remote [$HostName]."
            if($DryRun) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "'$RemoteSQLMonitorPath' removed."
            }
            else {
                Invoke-Command -Session $ssn4PerfmonSetup -ScriptBlock {
                    Remove-Item $Using:RemoteSQLMonitorPath -Recurse -Force -ErrorAction Stop
                    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "'$Using:RemoteSQLMonitorPath' removed."
                }
            }
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "'$RemoteSQLMonitorPath' does not exist on host [$HostName]."
        }
    }
}



# 97__RemoveXEventFilesFromDisk
$stepName = '97__RemoveXEventFilesFromDisk'
if($stepName -in $Steps2Execute) {
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."

    if([String]::IsNullOrEmpty($XEventFilesDirectory))
    {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$XEventFilesDirectory is null. Get default path using tsql.."

        $sqlDbaDatabasePath = @"
    select top 1 physical_name FROM sys.master_files 
    where database_id = DB_ID('$DbaDatabase') and type_desc = 'ROWS' 
    and physical_name not like 'C:\%' order by file_id;
"@
        $dbaDatabasePath = $conSqlInstanceToBaseline | Invoke-DbaQuery -Database master -Query $sqlDbaDatabasePath -EnableException | Select-Object -ExpandProperty physical_name
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$dbaDatabasePath => '$dbaDatabasePath'.."

        $xEventTargetPathParentDirectory = (Split-Path (Split-Path $dbaDatabasePath -Parent))
        if($xEventTargetPathParentDirectory.Length -eq 3) {
            $xEventTargetPathDirectory = "${xEventTargetPathParentDirectory}xevents"
        } else {
            $xEventTargetPathDirectory = Join-Path -Path $xEventTargetPathParentDirectory -ChildPath "xevents"
        }

        $XEventFilesDirectory = $xEventTargetPathDirectory
    }

    if([string]::IsNullOrEmpty($XEventFilesDirectory)) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'ERROR:', "`$XEventFilesDirectory could not be detected. Kindly manually delete same, and skip this step." | Write-Host -ForegroundColor Red
        Write-Error "Stop here. Fix above issue."
    }

    "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Remove folder '$XEventFilesDirectory' on [$SqlInstanceToBaseline]"
    
    if($HostName -eq $env:COMPUTERNAME)
    {
        if(Test-Path $XEventFilesDirectory) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "'$XEventFilesDirectory' exists."
            if($DryRun) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "'$XEventFilesDirectory' removed."
            }
            else {
                Remove-Item $XEventFilesDirectory -Recurse -Force -ErrorAction Stop
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "'$XEventFilesDirectory' removed."
            }
        }
        else{
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "'$XEventFilesDirectory' does not exists."
        }
    }
    else
    {
        if( (Invoke-Command -Session $ssn4PerfmonSetup -ScriptBlock {Test-Path $Using:XEventFilesDirectory}) ) 
        {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "'$XEventFilesDirectory' exists on remote [$ssnHostName]."
            if($DryRun) {
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "'$XEventFilesDirectory' removed."
            }
            else {
                Invoke-Command -Session $ssn4PerfmonSetup -ScriptBlock {Remove-Item $Using:XEventFilesDirectory -Recurse -Force} -ErrorAction Stop            
                "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "'$XEventFilesDirectory' removed."
            }
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "'$XEventFilesDirectory' does exists on host [$($env:COMPUTERNAME)]."
        }
    }
}


# 98__DropProxy
$stepName = '98__DropProxy'


# 99__DropCredential
$stepName = '99__DropCredential'


# 100__RemoveInstanceFromInventory
$stepName = '100__RemoveInstanceFromInventory'
if( ($stepName -in $Steps2Execute) -and ($SqlInstanceToBaseline -ne $InventoryServer) -and ($ActionType -eq 'Delete') ) {
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Working on step '$stepName'.."

    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'DRY RUN:', "Remove entry for SQLInstance [$SqlInstanceToBaseline] from Inventory [$InventoryServer].[$InventoryDatabase].[dbo].[instance_details].."
    }
    else {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO', "Remove entry for SQLInstance [$SqlInstanceToBaseline] from Inventory [$InventoryServer].[$InventoryDatabase].[dbo].[instance_details].."
    }
        
    $sqlRemoveInstanceEntry = @"
begin try
    if exists (select * from dbo.instance_details where sql_instance = '$SqlInstanceToBaseline')
    begin
        begin tran
            delete from dbo.instance_details where sql_instance = '$SqlInstanceToBaseline' and [host_name] = '$HostName';
            if not exists (select * from dbo.instance_details where [host_name] = '$HostName')
                delete from dbo.instance_hosts where [host_name] = '$HostName';
        commit tran

        select 1 as object_exists;
    end
    else
        select 0 as object_exists;
end try
begin catch
    DECLARE	@_errorNumber int,
		    @_errorSeverity int,
		    @_errorState int,
		    @_errorLine int,
		    @_errorMessage nvarchar(4000);
    
    SELECT  @_errorNumber	 = Error_Number(),
		    @_errorSeverity = Error_Severity(),
		    @_errorState	 = Error_State(),
		    @_errorLine	 = Error_Line(),
		    @_errorMessage	 = Error_Message();

    rollback tran;
    
    raiserror (@_errorMessage, 20, -1) with log;
end catch
"@
    $resultRemoveObject = @()
    if($DryRun) {
        "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "`$sqlRemoveInstanceEntry => `n`n$sqlRemoveInstanceEntry`n"        
    }
    else {
        $resultRemoveObject += $conInventoryServer | Invoke-DbaQuery -Database $InventoryDatabase -Query $sqlRemoveInstanceEntry -EnableException
    }

    if($resultRemoveObject.Count -gt 0) 
    {
        $result = $resultRemoveObject | Select-Object -ExpandProperty object_exists;
        if($result -eq 1) {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Instance entry removed from inventory."
        }
        else {
            "$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'WARNING:', "Instance entry not found in inventory."
        }
    }
}

# Execute PostQuery
if(-not [String]::IsNullOrEmpty($PostQuery)) {
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "*****Executing PostQuery on [$SqlInstanceToBaseline].." | Write-Host -ForegroundColor Cyan
    $conSqlInstanceToBaseline | Invoke-DbaQuery -Database $DbaDatabase -Query $PostQuery -EnableException
}


# If SQLMonitor Unistall is successful, then remove the instance_details file
if(Test-Path $instanceDetailsFilePath) {
    "`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Removing the file '$instanceDetailsFilePath'.."
    Remove-Item $instanceDetailsFilePath | Out-Null
}


"`n$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Removal of SQLMonitor for [$SqlInstanceToBaseline] completed."

$timeTaken = New-TimeSpan -Start $startTime -End $(Get-Date)
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Execution completed in $($timeTaken.TotalSeconds) seconds."



<#
    .SYNOPSIS
    Removes SQLMonitor objects, Perfmon data collector, and created SQL Agent jobs. Removes linked server from inventory instance.
    .DESCRIPTION
    This function accepts various parameters and perform removal of SQLMonitor from the SQLInstance with deletion of required tables, views, procedures, jobs, perfmon data collector, and linked server.
    .PARAMETER SqlInstanceToBaseline
    Name/IP of SQL Instance where SQLMonitor need to be removed. Instances should be capable of connecting from remove machine SSMS using this name/ip.
    .PARAMETER DbaDatabase
    Name of DBA database where SQLMonitor objects were created while setup.
    .PARAMETER SqlInstanceAsDataDestination 
    Name/IP of SQL Instance where SQLMonitor is saving OS level metrics like perfmon, OS Processes.
    .PARAMETER SqlInstanceForTsqlJobs 
    Name/IP of SQL Instance where SQLMonitor has created SQLAgent jobs to execute tsql scripts.
    .PARAMETER SqlInstanceForPowershellJobs 
    Name/IP of SQL Instance where SQLMonitor has created SQLAgent jobs to execute PowerShell scripts.
    .PARAMETER InventoryServer
    Name/IP of Inventory Server which acts are source for Grafana Dashboards.
    .PARAMETER InventoryDatabase 
    Name of inventory database on Inventory server
    .PARAMETER HostName
    Name of host for SqlInstanceToBaseline which has perfmon setup.
    .PARAMETER RemoteSQLMonitorPath
    SQLMonitor folder location where SQLMonitor folder was copied, and hosts perfmon generated files.
    .PARAMETER DataCollectorSetName
    Name of DBA perform data collector set created on server that was baselined. By default, its DBA.
    .PARAMETER OnlySteps
    List of steps that should be executed with Remove-SQLMonitor. This is mandatory for parameter ActionType = "Update".
    .PARAMETER StartAtStep
    Starts the baselining automation on this step. If no value provided, then baselining starts with 1st step.
    .PARAMETER SkipSteps
    List of steps that should be skipped in the baselining automation.
    .PARAMETER StopAtStep
    End the baselining automation on this step. If no value provided, then baselining finishes with last step.
    .PARAMETER SkipDropTable
    When enabled, dropping of tables is skipped.
    .PARAMETER SkipRemoveTsqlJobs
    When enabled, removal activity of jobs that execute stored procedures to capture SQL Server inbuilt metrics is skipped.
    .PARAMETER SkipRemovePowerShellJobs
    When enabled, removal activity of jobs that execute powershell scripts is skipped.
    .PARAMETER SkipDropProcedure
    When enabled, dropped of stored procedure is skipped.
    .PARAMETER SkipDropView
    When enabled, dropped of Views is skipped.
    .PARAMETER SkipRDPSessionSteps
    When enabled, any steps that need OS level interaction is skipped. This includes removal of SQLMonitor folder on remote path, removal of Perfmon Data Collector etc.
    .PARAMETER ActionType 
    Default value is 'Delete'. For 'Delete' value, SQLMonitor is removed. With ActionType = 'Update' along with OnlySteps parameter, only specific list of steps can be delete leaving the SQLMonitor baselining intact.
    .PARAMETER SqlCredential
    PowerShell credential object to execute queries any SQL Servers. If no value provided, then connectivity is tried using Windows Integrated Authentication.
    .PARAMETER WindowsCredential
    PowerShell credential object that could be used to perform OS interactives tasks. If no value provided, then connectivity is tried using Windows Integrated Authentication. This is important when [SqlInstanceToBaseline] is not in same domain as current host.
    .PARAMETER ConfirmValidationOfMultiInstance
    If required for confirmation from end user in case multiple SQL Instances are found on same host. At max, perfmon data can be pushed to only one SQL Instance.
    .PARAMETER DryRun
    When enabled, only messages are printed, but actual changes are NOT made.
    .PARAMETER PreQuery
    TSQL Query string that should be executed before starting any steps execution.
    .PARAMETER PostQuery
    TSQL Query string that should be executed after finishing all the steps.

    .EXAMPLE
Import-Module dbatools;
$params = @{
    SqlInstanceToBaseline = 'Workstation'
    DbaDatabase = 'DBA'
    InventoryServer = 'SQLMonitor'
    RemoteSQLMonitorPath = 'C:\SQLMonitor'
    #SqlCredential = $saAdmin
    #WindowsCredential = $DomainCredential
    #SkipSteps = @("43__RemovePerfmonFilesFromDisk")
    #StartAtStep = '22__DropLogin_Grafana'
    #StopAtStep = '19__RemoveJob_UpdateSqlServerVersions'
    SkipDropTable = $true
    #SkipRemoveJob = $true
    #SkipDropProc = $true
    #SkipDropView = $true
    DryRun = $false
}
F:\GitHub\SQLMonitor\SQLMonitor\Remove-SQLMonitor.ps1 @Params

Remove SQLMonitor setup for SQLInstance [Workstation] while dropping all objects from [DBA] database.
    .NOTES
Owner Ajay Kumar Dwivedi (ajay.dwivedi2007@gmail.com)
    .LINK
    https://ajaydwivedi.com/github/sqlmonitor
    https://ajaydwivedi.com/docs/sqlmonitor
    https://ajaydwivedi.com/blog/sqlmonitor
    https://ajaydwivedi.com/youtube/sqlmonitor
#>
