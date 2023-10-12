IF DB_NAME() = 'master'
	raiserror ('Kindly execute all queries in [DBA] database', 20, -1) with log;
go

use DBA
go

insert dbo.sm_inventory
(server, friendly_name, sql_instance, host_name, ipv4, stability, priority, product_version, has_hadr, hadr_strategy, hadr_preferred_role, hadr_current_role, hadr_partner_friendly_name, hadr_partner_sql_instance, hadr_partner_ipv4, server_owner, availability_zone, application, is_active, monitoring_enabled, other_details, rdp_credential, sql_credential )
select	server = 'SqlPractice',
		friendly_name = 'SqlPractice',
		sql_instance = 'SqlPractice',
		host_name = 'SqlPractice',
		ipv4 = '192.168.29.18',
		stability = 'Prod',
		priority = 1,
		product_version = '15.0.4198.2',
		has_hadr = 0,
		hadr_strategy = NULL,
		hadr_preferred_role = NULL,
		hadr_current_role = NULL,
		hadr_partner_friendly_name = NULL,
		hadr_partner_sql_instance = NULL,
		hadr_partner_ipv4 = NULL,
		server_owner = 'some_dba_mail_id@gmail.com',
		availability_zone = NULL,
		application = 'DBA Team',
		is_active = 1,
		monitoring_enabled = 1,
		other_details = NULL,
		rdp_credential = NULL,
		sql_credential = 'sa'
GO

exec dbo.usp_GetAllServerInfo @servers = 'SQLMonitor,Demo\SQL2019,Workstation,SqlPractice'
go

select *
from dbo.sm_inventory
go

