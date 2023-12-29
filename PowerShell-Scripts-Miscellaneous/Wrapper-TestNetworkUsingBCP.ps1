[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [String]$DataSourceServer = 'OfficeLaptop',
    [Parameter(Mandatory=$false)]
    [String]$DataSourceDb = 'DBA',
    [Parameter(Mandatory=$false)]
    [int]$Threads = 3,
    [Parameter(Mandatory=$false)]
    [String]$DestinationDirectory = "D:\",
    [Parameter(Mandatory=$false)]
    [int]$DaysThreshold = 0,
    [Parameter(Mandatory=$false)]
    [bool]$ExecuteGeneratedBatchFiles = $true,
    [Parameter(Mandatory=$false)]
    [bool]$ExecuteSerially = $false,
    [Parameter(Mandatory=$false)]
    [String]$SQLUser,
    [Parameter(Mandatory=$false)]
    [String]$SQLUserPassword
)

$ErrorActionPreference = 'STOP'

# Add backslash
if(-not $DestinationDirectory.EndsWith('\')) {
    $DestinationDirectory = "$DestinationDirectory\"
}

# If a drive letter, then add folder name automatically
if($DestinationDirectory.Length -le 3) {
    $DestinationDirectory = "$($DestinationDirectory)DBA-Network-Test\"
}

# Check destination folder
if(-not (Test-Path $DestinationDirectory)) {
    "Kindly ensure folder '$DestinationDirectory' exists" | Write-Host -ForegroundColor DarkYellow
    "Kindly ensure folder '$DestinationDirectory' exists" | Write-Error
}

# Loop, and generate batch files
[int]$counter = 1
while ($counter -le $Threads) {
    $outputDataFile = "$($DestinationDirectory)DBA_BCP_Test_$counter.dat"
    $outputBatchFile = "$($DestinationDirectory)DBA_BCP_Test_Batch_$counter.bat"
    $outputLogFile = "$($DestinationDirectory)DBA_BCP_Test_Batch_$counter`__Result.txt"
    
    if($DaysThreshold -eq 0) {
        $scriptCode = "BCP `"select * from dbo.vw_performance_counters pc where pc.collection_time_utc between dateadd(hour,-1,getutcdate()) and getutcdate()`" "
    }
    else {
        $scriptCode = "BCP `"select * from dbo.vw_performance_counters pc where pc.collection_time_utc between dateadd(day,-$($DaysThreshold+1),getutcdate()) and dateadd(day,-1,getutcdate())`" "
    }
    $scriptCode = $scriptCode +" queryout `"$outputDataFile`" -S $DataSourceServer -d $DataSourceDb -o $outputLogFile "
    if(-not [String]::IsNullOrEmpty($SQLUserPassword)) {
        $scriptCode = $scriptCode +" -U `"$SQLUser`" -P `"$SQLUserPassword`" "
    } else {
        $scriptCode = $scriptCode +" -T "
    }
    $scriptCode = $scriptCode +" -a 65535 -c -t`"!~!`""
    $scriptCode | Out-File $outputBatchFile -Force ascii
    "`n'$outputBatchFile' generated." | Write-Host -ForegroundColor Green

    # If required, then execute the batch files here
    if($ExecuteGeneratedBatchFiles) 
    {
        "`tExecute batch file '$outputBatchFile'.." | Write-Host -ForegroundColor Cyan
        $batchProcResult = Start-Process -FilePath $outputBatchFile -Wait:$ExecuteSerially -passthru;

        # If executed serially
        if($ExecuteSerially) {
            if($batchProcResult.ExitCode -eq 0) {
                "`tBatch executed successfully." | Write-Host -ForegroundColor Green
            }
            else {
                "`tBatch execution failed. Kindly execute manually." | Write-Host -ForegroundColor DarkRed
            }
        }
        else {
            "`tFor results, check log file '$outputLogFile'.." | Write-Host -ForegroundColor Cyan
        }
    }

    $counter += 1
}

