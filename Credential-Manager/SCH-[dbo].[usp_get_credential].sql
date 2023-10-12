use DBA
go

IF DB_NAME() = 'master'
	raiserror ('Kindly execute all queries in [DBA] database', 20, -1) with log;
go

--drop procedure dbo.usp_get_credential
create or alter procedure dbo.usp_get_credential
	@server_ip char(15) = null, 
	@server_name varchar(125) = null, 
	@user_name varchar(125) = null,
	@passphrase_string varchar(125) = null,
	@password varchar(256) = null output
with  encryption
as
begin
	set nocount on;
	if (@server_ip is null and @user_name is null and @server_name is null) and (IS_SRVROLEMEMBER('SYSADMIN') <> 1)
		throw 50000, 'Kindly provide both server_ip/server_name or user_name.', 1;

	if IS_SRVROLEMEMBER('SYSADMIN') <> 1
		print 'Since caller is not a sysadmin, Only look for credentials created/updated by caller, or caller is delegate.'

	if object_id('tempdb..#matched_credentials') is not null
		drop table #matched_credentials;
	select server_ip, server_name, [user_name], is_sql_user, is_rdp_user, 
			password_hash, --[password] = cast(DecryptByPassPhrase(cast(salt as varchar),password_hash ,1, @server_ip) as varchar),
			salt, --salt_raw = cast(salt as varchar),		
			created_date, created_by, updated_date, updated_by, 
			delegate_login_01, delegate_login_02, remarks
	into #matched_credentials
	from dbo.credential_manager
	where (@server_ip is null or server_ip = @server_ip)
	and (@server_name is null or server_name = @server_name)
	and (@user_name is null or [user_name] = @user_name)
	and (	(IS_SRVROLEMEMBER('SYSADMIN') = 1)
		or	(created_by = SUSER_NAME() or updated_by = SUSER_NAME() or delegate_login_01 = SUSER_NAME() or delegate_login_02 = SUSER_NAME())
		);

	if(@passphrase_string is not null) and (select count(*) from #matched_credentials) > 1
		throw 50000, 'More than one credentials found. Kindly provide both server_ip and user_name to narrow down credential search.', 1;

	if IS_SRVROLEMEMBER('SYSADMIN') <> 1 and (select count(*) from #matched_credentials) > 1
		throw 50000, 'More than one credentials found. Kindly provide both server_ip and user_name to narrow down credential search.', 1;
	
	if exists (select 1 from #matched_credentials)
	begin
		if (select count(*) from #matched_credentials) = 1
		begin
			print 'exact one match found. Decrypting password, and storing to output variable..';
			select @password = case when @passphrase_string is null 
										then cast(DecryptByPassPhrase(cast(salt as varchar),password_hash ,1, isnull(@server_ip,server_ip)) as varchar)
										else cast(DecryptByPassPhrase(@passphrase_string,password_hash ,1, isnull(@server_ip,server_ip)) as varchar)
										end
			from #matched_credentials
		end
		else
		begin
			select server_ip, server_name, [user_name], is_sql_user, is_rdp_user,
				[password] = case when @passphrase_string is null 
									then cast(DecryptByPassPhrase(cast(salt as varchar),password_hash ,1, isnull(@server_ip,server_ip)) as varchar)
									else cast(DecryptByPassPhrase(@passphrase_string,password_hash ,1, isnull(@server_ip,server_ip)) as varchar)
									end,
				created_date, created_by, updated_date, updated_by, remarks
			from #matched_credentials
		end
	end
	else
		throw 50000, 'No matching credentials found.', 1;
end
go