# SQLMonitor - Baseline SQL Server with PowerShell & Grafana

If you are a developer, or DBA who manages Microsoft SQL Servers, it becames important to understand current load vs usual load when SQL Server is slow. This repository contains scripts that will help you to setup baseline on individual SQL Server instances, and then visualize the collected data using Grafana through one Inventory server with Linked Server for individual SQL Server instances.

Navigation
- [SQLMonitor - Baseline SQL Server with PowerShell \& Grafana](#sqlmonitor---baseline-sql-server-with-powershell--grafana)
  - [Why SQLMonitor?](#why-sqlmonitor)
    - [Features](#features)
  - [Live Dashboard - Basic Metrics](#live-dashboard---basic-metrics)
  - [Live Dashboard - Perfmon Counters - Quest Softwares](#live-dashboard---perfmon-counters---quest-softwares)
    - [Portal Credentials](#portal-credentials)
  - [How to Setup](#how-to-setup)
    - [Jobs for SQLMonitor](#jobs-for-sqlmonitor)
    - [Download SQLMonitor](#download-sqlmonitor)
    - [Execute Wrapper Script](#execute-wrapper-script)
    - [Setup Grafana Dashboards](#setup-grafana-dashboards)
  - [Remove SQLMonitor](#remove-sqlmonitor)
  - [Support](#support)

## Why SQLMonitor?
SQLMonitor is designed as opensource tool to replace expensive enterprise monitoring or to simply fill the gap and monitor all environments such as DEV, TEST, QA/UAT & PROD.

[![YouTube Tutorial on SQLMonitor](https://github.com/imajaydwivedi/Images/blob/master/SQLMonitor/YouTube-Thumbnail-Live-All-Servers.png)](https://ajaydwivedi.com/youtube/sqlmonitor)<br>

### Features
- Simple & customizable as metric collection happens through SQL Agent jobs.
- Easy to debug since entire SQLMonitor tools is built of just few tables, stored procedures & sql agent jobs.
- Grafana based Central & Individual dashboards to analyze metrics
- Collection jobs using stored procedures with data loading utilizing very small sized perfmon/xevent files puts very minimal performance overhead.
- Highly optimized grafana dashboard queries using dynamically Parameterized tsql makes the data visualization to scale well even when dashboard users increase.
- Near to zero manual configuration required. Purging controlled through just one table/job.
- Depending on version of SQL Server, tables are automatically "Hourly" partitioned & Compressed. So index or other maintenance not even required.
- Utilizing Memory Optimized tables on central server for core stability metric storage gives it Unlimited scalability. 
- Tools has capability to allow same or different sql instance as Data Target. Thus gives high flexibility & scalability.
- Works with all supported SQL Servers (with some limitations on 2008R2 like XEvent not available).
- Utilizing Grafana Unified Alerting gives flexibility to create meaningful alerts.

## Live Dashboard - Basic Metrics
You can visit [https://ajaydwivedi.ddns.net:3000](https://ajaydwivedi.ddns.net:3000/d/distributed_live_dashboard/monitoring-live-distributed?orgId=1&refresh=5s) for live dashboard for basic real time monitoring.<br><br>

![](https://github.com/imajaydwivedi/Images/blob/master/SQLMonitor/Live-Dashboards-All.gif) <br>


## Live Dashboard - Perfmon Counters - Quest Softwares
Visit [https://ajaydwivedi.ddns.net:3000](https://ajaydwivedi.ddns.net:3000/d/distributed_perfmon/monitoring-perfmon-counters-quest-softwares-distributed?orgId=1&refresh=5m) for live dashboard of all Perfmon counters suggested in [SQL Server Perfmon Counters of Interest - Quest Software](https://drive.google.com/file/d/1LB7Joo6055T1FfPcholXByazOX55e5b8/view?usp=sharing).<br><br>

![](https://github.com/imajaydwivedi/Images/blob/master/SQLMonitor/Quest-Dashboards-All.gif) <br>

### Portal Credentials
Database/Grafana Portal | User Name | Password
------------ | --------- | ---------
[https://ajaydwivedi.ddns.net:3000/](https://ajaydwivedi.ddns.net:3000/dashboards?tag=sqlmonitor) | guest | ajaydwivedi-guest
Sql Instance -> ajaydwivedi.ddns.net:1433 | grafana | grafana

## How to Setup
SQLMonitor supports both Central & Distributed topology. In preferred distributed topology, each SQL Server instance monitors itself. The required objects like tables, view, functions, procedures, scripts, jobs etc. are created on the monitored instance itself.

SQLMonitor utilizes PowerShell script to collect various metric from operating system including setting up Perfmon data collector, pushing the collected perfmon data to sql tables, collecting os processes running etc.

For collecting metrics available from inside SQL Server, it used standard tsql procedures.

All the objects are created in [`DBA`] databases. Only few stored procedures that should have capability to be executed from context of any databases are created in [master] database.

For both OS metrics & SQL metric, SQL Agent jobs are used as schedulers. Each job has its own schedule which may differ in frequency of data collection from every one minute to once a week.

![](https://github.com/imajaydwivedi/Images/blob/master/SQLMonitor/SQLMonitor-Distributed-Topology.png) <br>

### Jobs for SQLMonitor

Following are few of the SQLMonitor data collection jobs. Each of these jobs is set to ‘(dba) SQLMonitor’ job category along with fixed naming convention of `(dba) *********`.

| Job Name                          | Job Category     | Schedule         | Job Type   | Location               |
| ---------------------------------:|:----------------:|:----------------:|:----------:|:----------------------:|
| (dba) Check-InstanceAvailability  | (dba) SQLMonitor | Every 1 minute   | PowerShell | Inventory Server       |
| (dba) Get-AllServerInfo           | (dba) SQLMonitor | Every 1 minute   | TSQL       | Inventory Server       |
| (dba) Get-AllServerCollectedData  | (dba) SQLMonitor | Every 5 minute   | TSQL       | Inventory Server       |
| (dba) Update-SqlServerVersions    | (dba) SQLMonitor | Once a week      | PowerShell | Inventory Server       |
| (dba) Collect-PerfmonData         | (dba) SQLMonitor | Every 2 minute   | PowerShell | PowerShell Jobs Server |
| (dba) Check-SQLAgentJobs          | (dba) SQLMonitor | Every 5 minute   | TSQL       | Tsql Jobs Server       |
| (dba) Collect-DiskSpace           | (dba) SQLMonitor | Every 30 minutes | PowerShell | PowerShell Jobs Server |
| (dba) Collect-FileIOStats         | (dba) SQLMonitor | Every 10 minute  | TSQL       | Tsql Jobs Server       |
| (dba) Collect-MemoryClerks        | (dba) SQLMonitor | Every 2 minute   | TSQL       | Tsql Jobs Server       |
| (dba) Collect-OSProcesses         | (dba) SQLMonitor | Every 2 minute   | PowerShell | PowerShell Jobs Server |
| (dba) Collect-PrivilegedInfo      | (dba) SQLMonitor | Every 10 minute  | TSQL       | Tsql Jobs Server       |
| (dba) Collect-WaitStats           | (dba) SQLMonitor | Every 10 minutes | TSQL       | Tsql Jobs Server       |
| (dba) Collect-XEvents             | (dba) SQLMonitor | Every minute     | TSQL       | Tsql Jobs Server       |
| (dba) Partitions-Maintenance      | (dba) SQLMonitor | Every Day        | TSQL       | Tsql Jobs Server       |
| (dba) Purge-Tables                | (dba) SQLMonitor | Every Day        | TSQL       | Tsql Jobs Server       |
| (dba) Remove-XEventFiles          | (dba) SQLMonitor | Every 4 hours    | PowerShell | PowerShell Jobs Server |
| (dba) Run-BlitzIndex              | (dba) SQLMonitor | Every Day        | TSQL       | Tsql Jobs Server       |
| (dba) Run-BlitzIndex - Weekly     | (dba) SQLMonitor | Once a Week      | TSQL       | Tsql Jobs Server       |
| (dba) Run-LogSaver                | (dba) SQLMonitor | Every 5 minutes  | TSQL       | Tsql Jobs Server       |
| (dba) Run-TempDbSaver             | (dba) SQLMonitor | Every 5 minutes  | TSQL       | Tsql Jobs Server       |
| (dba) Run-WhoIsActive             | (dba) SQLMonitor | Every 2 minute   | TSQL       | Tsql Jobs Server       |

----
`PowerShell Jobs Server` can be same SQL Instance that is being baselined, or some other server in same Cluster network, or some some other server in same network, or even Inventory Server.

`Tsql Jobs Server` can be same SQL Instance that is being baselined, or some other server in same Cluster network, or some some other server in same network, or even Inventory Server.

### Download SQLMonitor
Download SQLMonitor repository on your central server from where you deploy your scripts on all other servers. Say, after closing SQLMonitor, our local repo directory is `D:\Ajay-Dwivedi\GitHub-Personal\SQLMonitor`.

If the local SQLMonitor repo folder already exists, simply pull the latest from master branch.

### Execute Wrapper Script
Create a directory named Private inside SQLMonitor, and copy the scripts of SQLMonitor\Wrapper-Samples\ into SQLMonitor\Private\ folder.
Open the script `D:\Ajay-Dwivedi\GitHub-Personal\SQLMonitor\Private\Wrapper-InstallSQLMonitor.ps1`. Replace the appropriate values for parameters, and execute the script.

```
#$DomainCredential = Get-Credential -UserName 'Lab\SQLServices' -Message 'AD Account'
#$personal = Get-Credential -UserName 'sa' -Message 'sa'
#$localAdmin = Get-Credential -UserName 'Administrator' -Message 'Local Admin'

cls
import-module dbatools
$params = @{
    SqlInstanceToBaseline = 'Workstation'
    DbaDatabase = 'DBA'
    #HostName = 'Workstation'
    #RetentionDays = 7
    DbaToolsFolderPath = 'F:\GitHub\dbatools'
    RemoteSQLMonitorPath = 'C:\SQLMonitor'
    InventoryServer = 'SQLMonitor'
    InventoryDatabase = 'DBA'
    DbaGroupMailId = 'some_dba_mail_id@gmail.com'
    #SqlCredential = $personal
    #WindowsCredential = $DomainCredential
    #SkipSteps = @("21__CreateJobRemoveXEventFiles")
    #StartAtStep = '1__sp_WhoIsActive'
    #StopAtStep = '28__AlterViewsForDataDestinationInstance'
    #DropCreatePowerShellJobs = $true
    #DryRun = $false
    #SkipRDPSessionSteps = $true
    #SkipPowerShellJobs = $true
    #SkipTsqlJobs = $true
    #SkipMailProfileCheck = $true
    #skipCollationCheck = $true
    #SkipWindowsAdminAccessTest = $true
    #SqlInstanceAsDataDestination = 'Workstation'
    #SqlInstanceForPowershellJobs = 'Workstation'
    #SqlInstanceForTsqlJobs = 'Workstation'
    #ConfirmValidationOfMultiInstance = $true
}
D:\Ajay-Dwivedi\GitHub-Personal\SQLMonitor\SQLMonitor\Install-SQLMonitor.ps1 @Params

#Copy-DbaDbMail -Source 'SomeSourceInstance' -Destination 'SomeDestinationInstance' -SourceSqlCredential $personal -DestinationSqlCredential $personal
<#

Enable-PSRemoting -Force # run on remote machine
Set-Item WSMAN:\Localhost\Client\TrustedHosts -Value * -Force # run on local machine
Set-Item WSMAN:\Localhost\Client\TrustedHosts -Value InventoryServerIP -Force
#Set-NetConnectionProfile -NetworkCategory Private # Execute this only if above command fails

Enter-PSSession -ComputerName 'SqlInstanceToBaseline' -Credential $localAdmin -Authentication Negotiate
Test-WSMan 'SqlInstanceToBaseline' -Credential $localAdmin -Authentication Negotiate

#>
```

Below are some key highlight of above code:

`Line` 1-> Enable/use this variable when the `SqlInstanceToBaseline`  is not in same domain as inventory server (server from where these scripts are being executed). In this line, we are creating/saving credentials that could take RDP to SqlInstanceToBaseline .

`Line 2`-> Enable/use this variable when the `SqlInstanceToBaseline`  is not in same domain as inventory server (server from where these scripts are being executed). In this line, we are creating/saving credentials that could execute elevated SQL Queries against `SqlInstanceToBaseline`.

`Line 3`-> Enable/use this variable when the `SqlInstanceToBaseline`  is not joined to any domain. In this line, we are creating/saving credentials that could take RDP to SqlInstanceToBaseline.

`Lines 7-45` → These are the parameters for function `Install-SQLMonitor`. Enable/use them based on the requirement of various behavior of function. For example, when target server belongs different domain, then SqlCredential & WindowsCredential parameters can be utilized.

### Setup Grafana Dashboards
Download Grafana which is open source visualization tool. Install & configure same.

Create a datasource on Grafana that connects to your Inventory Server. Say, we set it with name 'SQLMonitor'. Use `grafana` as login & password while setting up this data source. The `grafana` sql login is created on each server being baselined with `db_datareader` on `DBA` database.

At next step, import all the dashboard `*.json` files on path `D:\Ajay-Dwivedi\GitHub-Personal\SQLMonitor\Grafana-Dashboards` into `SQLServer` folder on grafana portal. While importing each JSON file, we need to explicitly choose `SQLMonitor` Data Source & Folder we created in above steps.

## Remove SQLMonitor
Similar to `Wrapper-InstallSQLMonitor`, we have `Wrapper-RemoveSQLMonitor` that can help us remove SQLMonitor for a particular baselined server.
Ensure that all scripts from folder \SQLMonitor\Wrapper-Samples\ are copied into \SQLMonitor\Private\ folder.

Open script `D:\Ajay-Dwivedi\GitHub-Personal\SQLMonitor\Private\Wrapper-RemoveSQLMonitor.ps1`. Replace the appropriate values for parameters, and execute the script.

## Support

For community support regarding this tool, kindly join [#sqlmonitor](https://ajaydwivedi.com/go/slack) channel on [sqlcommunity.slack.com](https://ajaydwivedi.com/go/slack) slack workspace.
For paid support, reach out to me directly on [sqlcommunity.slack.com](https://ajaydwivedi.com/go/slack) slack workspace.

-----------------------------

Thanks :smiley:. Subscribe for updates :thumbsup:
