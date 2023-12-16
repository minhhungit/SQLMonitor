<#
    Purpose: Run sql script on multiple servers, and process result
#>
#$saAdmin = Get-Credential -UserName 'sa' -Message 'sa Login'

cls

# Parameters
$InventoryServer = 'localhost'
$InventoryDatabase = 'DBA'
$CredentialManagerDatabase = 'DBA'

# Connect to Inventory Server, and get sa credential
"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "[Connect-DbaInstance] Create connection for InventoryServer '$InventoryServer'.."
$conInventoryServer = Connect-DbaInstance -SqlInstance $InventoryServer -Database $InventoryDatabase -ClientName "Get-FailedLogins.ps1" `
                                                    -TrustServerCertificate -ErrorAction Stop -SqlCredential $personal

"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Fetch [sa] password from Credential Manager [$InventoryServer].[$CredentialManagerDatabase].."
$getCredential = @"
/* Fetch Credentials */
declare @password varchar(256);
exec dbo.usp_get_credential 
		@server_ip = '*',
		@user_name = 'sa',
		@password = @password output;
select @password as [password];
"@
[string]$saPassword = Invoke-DbaQuery -SqlInstance $conInventoryServer -Database $CredentialManagerDatabase -Query $getCredential | 
                                    Select-Object -ExpandProperty password -First 1

"$(Get-Date -Format yyyyMMMdd_HHmm) {0,-10} {1}" -f 'INFO:', "Create sa credential from fetched password.."
[string]$saUser = 'sa'
[securestring]$secStringPassword = ConvertTo-SecureString $saPassword -AsPlainText -Force
[pscredential]$saCredential = New-Object System.Management.Automation.PSCredential $saUser, $secStringPassword


# Get servers list
$serversAudit = Get-Content "C:\Users\Ajay\Downloads\SOC\server-list-audit-2023Dec04.txt" | Select-Object -Unique | Sort-Object | % {$_.trim()}

$auditSchemaFile = "D:\GitHub-Personal\SQLDBA-SSMS-Solution __BEFORE_REMOVAL\Work-SOC-Project\LRAudit-Install_v2_app_log-Minimum.sql"

# Hide Instance
$sqlHideInstance = @"
EXEC master.sys.xp_instance_regwrite
  @rootkey = N'HKEY_LOCAL_MACHINE',
  @key = N'SOFTWARE\Microsoft\Microsoft SQL Server\MSSQLServer\SuperSocketNetLib',
  @value_name = N'HideInstance',
  @type = N'REG_DWORD',
  @value = 1;
"@

$sqlOrphanUsers = @"
if object_id('tempdb..#orphan_users') is not null
	drop table #orphan_users;
create table #orphan_users ([db_name] nvarchar(125) default db_name(), [user_name] nvarchar(125), [user_sid] nvarchar(125));

exec sp_MSforeachdb '
use [?];
insert #orphan_users ([user_name], [user_sid])
exec sp_change_users_login @Action=''Report''
' ;

select [sql_instance] = @sql_instance, [db_name], [user_name], [user_sid] from #orphan_users;
"@

# Loop through servers list, and perform required action
[System.Collections.ArrayList]$successServers = @()
[System.Collections.ArrayList]$failedServers = @()
[System.Collections.ArrayList]$queryResult = @()

#$serversRemaining = $servers | ? {$_ -notin $successServers }
#$successServersFinal = $successServers

foreach($srv in $serversSA)
{
    "Working on [$srv].." | Write-Host -ForegroundColor Cyan
    try {
        $srvObj = Connect-DbaInstance -SqlInstance $srv -Database master -ClientName "DBA-Ajay-Dwivedi-PowerShell.ps1" `
                                                    -SqlCredential $saCredential -TrustServerCertificate -ErrorAction Stop

        # Create server audit
            #Invoke-DbaQuery -SqlInstance $srvObj -Database master -File $auditSchemaFile -SqlCredential $saCredential -EnableException
        
        # When no data resultset is expected
            #Invoke-DbaQuery -SqlInstance $srvObj -Database master -Query $sqlAlterAudit -EnableException
        
        # When resultset is expected
        Invoke-DbaQuery -SqlInstance $srvObj -Database master -Query $sqlGetMultipleProperties -SqlCredential $saCredential -EnableException `
                    -SqlParameter @{ sql_instance = $srv } `
                    -As PSObject | % {$queryResult.Add($_)|Out-Null}
                
        $successServers.Add($srv) | Out-Null
    }
    catch {
        $errMsg = $_.Exception.Message
        $failedServers.Add([PSCustomObject]@{server = $srv; error = $errMsg}) | Out-Null
        "`n`tError: $errMsg" | Write-Host -ForegroundColor Red
    }
}

#$successServers | ogv
$failedServers | ogv
#$queryResult | ogv

$excelPath = "$($env:USERPROFILE)\Downloads\SomeTask-2023Dec04.xlsx"
$queryResult | Export-Excel -Path $excelPath -WorksheetName 'Orphan-Users'


$successServers | ? {$_ -notin $queryResult.sql_instance} | ogv -Title "Servers Missing Not in Results"


