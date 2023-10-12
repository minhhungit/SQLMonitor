use [master]
go
if not exists (select * from sys.syslogins where name = 'grafana')
	create login [grafana] with password=N'grafana', default_database=[DBA], check_expiration=off, check_policy=off
go
if exists (select * from sys.sysusers where name = 'grafana')
	drop user [grafana]
go
use [master];
create user [grafana] for login [grafana]
go
grant view any definition to [grafana]
go
grant view server state to [grafana]
go
grant view any database to [grafana]
go

if object_id('dbo.SqlServerVersions') is not null
	exec ('grant select on object::dbo.SqlServerVersions to [grafana]')
go

use [msdb];
go
use [msdb];
if exists (select * from sys.sysusers where name = 'grafana')
	drop user [grafana];
go
use [msdb]
	create user [grafana] for login [grafana]
go
use [msdb]
alter role [db_datareader] add member [grafana]
go
use [msdb]
grant view database state to [grafana]
go


use [DBA]
if exists (select * from sys.sysusers where name = 'grafana')
	drop user [grafana];
go
use [DBA]
	create user [grafana] for login [grafana]
go
use [DBA]
alter role [db_datareader] add member [grafana]
go
use [DBA]
grant view database state to [grafana]
go
use [DBA]
if OBJECT_ID('dbo.usp_extended_results') is not null
	exec ('grant execute on object::dbo.usp_extended_results to [grafana]')
go
use [DBA]
if OBJECT_ID('dbo.sp_WhatIsRunning') is not null
	exec ('grant execute on object::dbo.sp_WhatIsRunning to [grafana]')
go
use [DBA]
if OBJECT_ID('dbo.vw_xevent_metrics') is not null
	exec ('grant select on object::dbo.vw_xevent_metrics to [grafana]')
go
use [DBA]
if OBJECT_ID('dbo.usp_GetAllServerInfo') is not null
	exec ('grant execute on object::dbo.usp_GetAllServerInfo TO [grafana]')
go
use [DBA]
if OBJECT_ID('dbo.usp_active_requests_count') is not null
	exec ('grant execute on object::dbo.usp_active_requests_count TO [grafana]')
go
use [DBA]
if OBJECT_ID('dbo.usp_waits_per_core_per_minute') is not null
	exec ('grant execute on object::dbo.usp_waits_per_core_per_minute TO [grafana]')
go
