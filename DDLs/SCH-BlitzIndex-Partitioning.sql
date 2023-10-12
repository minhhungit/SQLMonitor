IF DB_NAME() = 'master'
	raiserror ('Kindly execute all queries in [DBA] database', 20, -1) with log;
go

-- Drop Existing PK
USE [DBA];
declare @table_name sysname;
declare @cx_name sysname;
declare @data_space_id int;
declare @sql nvarchar(max);
set @table_name = 'dbo.BlitzIndex';

--select [@cx_name] = name, [@data_space_id] = data_space_id 
select @cx_name = name, @data_space_id = data_space_id 
from sys.indexes 
where [object_id] = OBJECT_ID(@table_name) 
	and type_desc = 'CLUSTERED';

if @cx_name is not null and @data_space_id <= 1
begin
	print @table_name+'.'+quotename(@cx_name)+' can be dropped.';
	set @sql = 'alter table '+@table_name+' drop constraint '+quotename(@cx_name);
	print @sql;
	exec (@sql);
end
else
	if @data_space_id > 1
		print @table_name+' table seems already partitioned.'
	if @cx_name is null
		print @table_name+' table seems to not have [CX].'
GO

-- Create PK with Partitioning
USE [DBA];
declare @table_name sysname;
declare @cx_name sysname;
declare @data_space_id int;
declare @sql nvarchar(max);
set @table_name = 'dbo.BlitzIndex';

--select [@cx_name] = name, [@data_space_id] = data_space_id 
select @cx_name = name, @data_space_id = data_space_id 
from sys.indexes 
where [object_id] = OBJECT_ID(@table_name) 
	and type_desc = 'CLUSTERED';

if @cx_name is null
begin
	print @table_name+' qualify for partitioning.';
	set @cx_name = 'pk_BlitzIndex';

	print 'convert identity column to bigint.'
	set @sql = 'alter table '+@table_name+' alter column [id] [bigint] NOT NULL';
	print @sql;
	exec (@sql);

	print 'add default for [run_datetime] column.'
	set @sql = 'alter table '+@table_name+' add default (getdate()) for [run_datetime]';
	print @sql;
	exec (@sql);

	print 'convert [run_datetime] column to not null.'
	set @sql = 'alter table '+@table_name+' alter column [run_datetime] [datetime] NOT NULL';
	print @sql;
	exec (@sql);

	set @sql = 'alter table '+@table_name+' add constraint '+@cx_name+' primary key clustered ([run_datetime],[id])  on ps_dba_datetime_daily ([run_datetime]);'
	print @sql;
	exec (@sql);
end
else
begin
	if @data_space_id = 1
		raiserror ('Something wrong. Table dbo.BlitzIndex is supposed to be partitioned.', 20, -1) with log;
end
go
