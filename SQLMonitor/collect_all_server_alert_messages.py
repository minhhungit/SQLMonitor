import pyodbc
from prettytable import PrettyTable
#from prettytable import from_db_cursor
import argparse
from datetime import datetime
import os
#from slack_sdk import WebClient
from multiprocessing import Pool
#import math

parser = argparse.ArgumentParser(description="Script to execute sql query on multiple SQLServer",
                                  formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument("-s", "--inventory_server", type=str, required=False, action="store", default="localhost", help="Inventory Server")
parser.add_argument("-d", "--inventory_database", type=str, required=False, action="store", default="DBA", help="Inventory Database")
parser.add_argument("--app_name", type=str, required=False, action="store", default="(dba) Collect-AllServerAlertMessages", help="Application Name")
parser.add_argument("--threads", type=int, required=False, action="store", default=4, help="No of parallel threads")

args=parser.parse_args()

start_time = datetime.now()

today = datetime.today()
today_str = today.strftime('%Y-%m-%d')
inventory_server = args.inventory_server
inventory_database = args.inventory_database
app_name = args.app_name
threads = args.threads

# Get list of servers from Inventory
invCon = pyodbc.connect("Driver={SQL Server Native Client 11.0};"
                      f"Server={inventory_server};"
                      f"Database={inventory_database};"
                      f"App={app_name};"
                      "Trusted_Connection=yes;")

invCursor = invCon.cursor()

sql_get_servers = f"""
declare @max_duration_threshold_minutes int = 120;

;with cte_instances as (
	select distinct [sql_instance], [sql_instance_port], [database]
	from dbo.instance_details id
	where is_enabled = 1 and is_alias = 0 and is_available = 1
)
select id.[sql_instance], [sql_instance_port], [database], 
		collection_time_utc = coalesce(collection_time_utc, dateadd(minute,-@max_duration_threshold_minutes,sysutcdatetime()))
from cte_instances id
left join (
		select sql_instance, collection_time_utc = max(collection_time_utc)
		from [dbo].[alert_history_all_servers] ahas
		group by sql_instance
	) ahas
	on ahas.sql_instance = id.sql_instance
where 1=1;
"""

invCursor.execute(sql_get_servers)
servers = invCursor.fetchall()
#invCursor.close()
#invCon.close()

result_handles = []
final_result = []
pt_results = PrettyTable()
successful_servers = []
failed_servers = []
pt_successful_servers = PrettyTable()
pt_failed_servers = PrettyTable()
total_servers_count = len(servers)
success_servers_count = 0
failed_servers_count = 0

def query_server(server_row):
    #app_name = "(dba) Run-MultiServerQuery"
    #app_config = {"app_name": app_name}
    server = server_row.sql_instance
    database = server_row.database
    port = server_row.sql_instance_port
    collection_time_utc = server_row.collection_time_utc

    #print(f"Working on [{server}].[{database}]..")

    if port is None:
      #connectionString = f'DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={server};DATABASE={database};Trusted_Connection=yes;TrustServerCertificate=YES;App={app_name};UID=grafana;PWD=grafana;'
      connectionString = f'DRIVER={{SQL Server Native Client 11.0}};SERVER={server};DATABASE={database};TrustServerCertificate=YES;App={app_name};UID=grafana;PWD=grafana;'
    else:
      #connectionString = f'DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={server},{port};DATABASE={database};Trusted_Connection=yes;TrustServerCertificate=YES;App={app_name};UID=grafana;PWD=grafana;'
      connectionString = f'DRIVER={{SQL Server Native Client 11.0}};SERVER={server},{port};DATABASE={database};TrustServerCertificate=YES;App={app_name};UID=grafana;PWD=grafana;'
    
    '''
    cnxn = pyodbc.connect("Driver={SQL Server Native Client 11.0};"
                      f"Server={server},{port};"
                      f"Database={database};"
                      f"App={app_name};"
                      "Trusted_Connection=yes;")
    '''
    
    sql_query = f"""
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(max);
    DECLARE @params NVARCHAR(max);
    DECLARE @sql_instance varchar(125);
    DECLARE @collection_time_utc datetime2;

    SET @sql_instance = ?;
    SET @collection_time_utc = ?;

    --WAITFOR DELAY '00:00:10';

    SET @params = N'@sql_instance varchar(125), @collection_time_utc datetime2';
    SET @sql = N'
    select	ah.collection_time_utc, [sql_instance] = @sql_instance, 
        ah.server_name, ah.database_name, ah.error_number, 
        ah.error_severity, ah.error_message, ah.host_instance,
        [updated_time_utc] = sysutcdatetime()
    from dbo.alert_history ah
    where 1=1
    and ah.collection_time_utc > @collection_time_utc
    ';

    EXEC sp_executesql @sql
      ,@params
      ,@sql_instance
      ,@collection_time_utc;
    """

    cnxn = pyodbc.connect(connectionString)
    #print(sql_query)
    cursor = cnxn.cursor()
    cursor.execute(sql_query, server, collection_time_utc)
    #cursor.execute(sql_query)
    result = cursor.fetchall()
    cursor.close()
    cnxn.close()

    return result

def pool_handler():
    global threads
    pool = Pool(threads)

    print(f"Loop {len(servers)} servers using {threads} threads ..\n")
    for server_row in servers:
      server = server_row.sql_instance
      #print(server)
      #pool.apply_async(query_server,(server_row,), callback = log_result)
      result = {}
      result['server'] = server
      result['result_handle'] = pool.apply_async(query_server,(server_row,))
      result_handles.append(result)
    
    pool.close()
    pool.join()

    #print(result_handles)
    for server,result in [server_row.values() for server_row in result_handles]:
      try:
        if result._success:
          successful_servers.append(server)
        rows = result.get()
        for row in rows:
          final_result.append(row)
      except Exception as e:
          print("\n*****************************************************")
          print(f"Error occurred for server [{server}]\n")
          print(e)
          print("*****************************************************\n")
          failed_servers.append(server)

    #print(final_result)

    #result_handles = []
    #final_result = []
    #ptable = PrettyTable()

    #for allrows in p.map(query_server, servers):
        #for row in allrows:
          #final_result.append(row)
    
    #total_servers_count = len(servers)
    global success_servers_count
    global failed_servers_count
    #success_servers_count = len(final_result)
    success_servers_count = len(successful_servers)
    failed_servers_count = len(failed_servers)

    #print(final_result)
    #pt_results.field_names = [column[0] for column in final_result[0].cursor_description]
    #pt_results.add_rows(final_result)
    #print(f"Servers with successful connectivity: {success_servers_count}/{total_servers_count}")
    #print(pt_results)

    #print(successful_servers)
    if success_servers_count > 0:
      pt_successful_servers.field_names = ["server",]
      for row in successful_servers:
        pt_successful_servers.add_row([row,])
        #print(row)
      print(f"\nServers with successful connectivity: {success_servers_count}/{total_servers_count}")    
      print(pt_successful_servers)
    else:
      print(f"\nNo server with successful connectivity.")    

    if failed_servers_count > 0:
      #print(failed_servers)
      pt_failed_servers.field_names = ["server",]
      for row in failed_servers:
        pt_failed_servers.add_row([row,])
        #print(row)
      print(f"\nServers with failed connectivity: {failed_servers_count}/{total_servers_count}")    
      print(pt_failed_servers)
    else:
      print(f"\nNo server with failed connectivity.")    


def update_inventory():
    if(success_servers_count > 0):
      print(f"\nUpdate [is_available] flag for {success_servers_count} servers..")

      #print(final_result)
      #print([server_row[0] for server_row in final_result])
      servers_csv = ','.join([f"'{server_row[0]}'" for server_row in final_result])
      #print(servers_csv)
      sql_update_online_servers = f"""
      update dbo.instance_details set is_available = 1
      where is_enabled = 1 and is_available = 0
          and ( sql_instance in ({servers_csv}) or source_sql_instance in ({servers_csv}) )
      """
      invCursor.execute(sql_update_online_servers)
      invCon.commit()
    else:
       print(f"No successful servers found.")

    if(failed_servers_count > 0):
      print(f"\nUpdate [is_available] flag for {failed_servers_count} servers..")

      servers_csv = ','.join([f"'{server}'" for server in failed_servers])
      sql_update_offline_servers = f"""
      update dbo.instance_details set is_available = 0, last_unavailability_time_utc = SYSUTCDATETIME()
      where is_enabled = 1 and is_available = 1 
          and ( sql_instance in ({servers_csv}) or source_sql_instance in ({servers_csv}) )
      """
      invCursor.execute(sql_update_offline_servers)
      invCon.commit()
    else:
       print(f"No failed servers found.")
      #invCursor.execute(sql_get_servers)
      #servers = invCursor.fetchall()
    invCursor.close()
    invCon.close()

if __name__ == '__main__':

    pool_handler()
    #update_inventory()

    end_time = datetime.now()
    print(f"\n\nTime taken: {end_time-start_time}")



'''
# https://www.analyticsvidhya.com/blog/2024/01/ways-to-convert-python-scripts-to-exe-files/

pip install pyinstaller

PS C:\\Windows\\system32> cd C:\\sqlmonitor\\Work\
PS C:\\sqlmonitor\\Work> pyinstaller.exe --onefile .\\Raise-AgHealthStateAlert.py

C:\\sqlmonitor\\Work\\dist\\Raise-AgHealthStateAlert.exe
'''