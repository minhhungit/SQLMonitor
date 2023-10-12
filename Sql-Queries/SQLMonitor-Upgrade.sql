use DBA
go

select *
from dbo.instance_details id
where 1=1
and id.sqlmonitor_version <> '1.5.0.4'
--and id.sqlmonitor_version = '1.5.0.4'
go



select *
from vw_all_server_info asi
where asi.at_server_name like '%SomeHostName%'

select id.*, asi.domain
from dbo.instance_details id
outer apply (select top 1 asi.domain from dbo.vw_all_server_info asi where asi.srv_name = id.sql_instance) asi
where 1=1 and id.sqlmonitor_version <> '1.3.0'
and asi.domain in ('WORKGROUP')
-- 

-- Query to find out JobServers with List of Hosts & SQLInstances
;with t_job_servers as (
	select distinct js.collector_powershell_jobs_server --, id.[job_server_hosts]
	from dbo.instance_details js /* PowerShell Job Server */
	outer apply (select top 1 asi.domain from dbo.vw_all_server_info asi where asi.srv_name = js.sql_instance) asi
	where 1=1
	and js.sqlmonitor_version <> '1.3.0'
	--and asi.domain = 'Lab'
)
, t_job_servers_hosts as (
	select js.collector_powershell_jobs_server, id.job_server_hosts, srvs.sql_instances
	from t_job_servers js
	outer apply (select [job_server_hosts] = STUFF(( select ', '+id.host_name
				 from (select distinct id.host_name from dbo.instance_details id where id.sql_instance = js.collector_powershell_jobs_server) id
				 for xml path(''), TYPE)
				.value('.','varchar(max)'),1,2,' ')
				) id
	outer apply (select [sql_instances] = STUFF(( select ', '+srvs.sql_instance
				 from (select distinct srvs.sql_instance from dbo.instance_details srvs where srvs.collector_powershell_jobs_server = js.collector_powershell_jobs_server) srvs
				 for xml path(''), TYPE)
				.value('.','varchar(max)'),1,2,' ')
				) srvs
)
select js.collector_powershell_jobs_server, job_server_hosts = ltrim(rtrim(js.job_server_hosts)), sql_instances = ltrim(rtrim(js.sql_instances))
from t_job_servers_hosts js
order by js.collector_powershell_jobs_server --, sql_instance
go

/*
select upd.*
-- update upd set sqlmonitor_version = '1.5.0.5'
from dbo.instance_details id
join dbo.instance_details upd
	on upd.sql_instance = id.sql_instance
	and upd.[database] = id.[database]
	and upd.sqlmonitor_version <> '1.5.0.5'
	and upd.host_name <> id.host_name
	and upd.is_available = 1
	and upd.is_enabled = 1
where id.sqlmonitor_version = '1.5.0.5'
and id.is_alias = 0 and id.is_enabled = 1 and id.is_available = 1
go
*/

/*
select id.*, asi.*
-- update id set sqlmonitor_version = '1.3.0'
from dbo.instance_details id
outer apply (select top 1 asi.domain from dbo.vw_all_server_info asi where asi.srv_name = id.sql_instance) asi
where 1=1 
and id.sqlmonitor_version <> '1.3.0'
and asi.domain in ('Lab')
and id.sql_instance in ('192.168.1.10')
*/

/*
insert dbo.instance_details 
(sql_instance, [host_name], [database], collector_tsql_jobs_server, collector_powershell_jobs_server, data_destination_sql_instance, is_available, created_date_utc, last_unavailability_time_utc, dba_group_mail_id, sqlmonitor_script_path, sqlmonitor_version, is_alias, source_sql_instance, sql_instance_port)
select sql_instance = 'Alias Server Name', [host_name], [database], collector_tsql_jobs_server, collector_powershell_jobs_server, data_destination_sql_instance, is_available, created_date_utc, last_unavailability_time_utc, dba_group_mail_id, sqlmonitor_script_path, sqlmonitor_version, is_alias = 1, source_sql_instance = sql_instance, sql_instance_port
from dbo.instance_details id
where 1=1
*/