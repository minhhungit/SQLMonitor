import pyodbc
from prettytable import PrettyTable
from prettytable import from_db_cursor
import argparse
from datetime import datetime
import os
from slack_sdk import WebClient
from multiprocessing import Pool
import math

parser = argparse.ArgumentParser(description="Script to execute sql query on multiple SQLServer",
                                  formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument("-s", "--inventory_server", type=str, required=False, action="store", default="localhost", help="Inventory Server")
parser.add_argument("-d", "--inventory_database", type=str, required=False, action="store", default="DBA", help="Inventory Database")
parser.add_argument("--app_name", type=str, required=False, action="store", default="(dba) Check-InstanceAvailability", help="Application Name")
parser.add_argument("--threads", type=int, required=False, action="store", default="4", help="No of parallel threads")

args=parser.parse_args()

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
select distinct [sql_instance], [sql_instance_port], [database]
from dbo.instance_details id
where is_enabled = 1 and is_alias = 0
and id.host_name <> CONVERT(varchar,SERVERPROPERTY('ComputerNamePhysicalNetBIOS'))
"""

invCursor.execute(sql_get_servers)
servers = invCursor.fetchall()
invCursor.close()
invCon.close()

def query_server(server_row):
    #app_name = "(dba) Run-MultiServerQuery"
    #app_config = {"app_name": app_name}
    server = server_row.sql_instance
    database = server_row.database
    port = server_row.sql_instance_port

    print(f"Working on [{server}].[{database}]..")

    if port is None:
      connectionString = f'DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={server};DATABASE={database};Trusted_Connection=yes;TrustServerCertificate=YES;App={app_name};'
    else:
      connectionString = f'DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={server},{port};DATABASE={database};Trusted_Connection=yes;TrustServerCertificate=YES;App={app_name};'
    
    '''
    cnxn = pyodbc.connect("Driver={SQL Server Native Client 11.0};"
                      f"Server={server},{port};"
                      f"Database={database};"
                      f"App={app_name};"
                      "Trusted_Connection=yes;")
    '''
    
    sql_query = f"""
    select [sql_instance] = ?, [database] = db_name();
    """

    try:
      cnxn = pyodbc.connect(connectionString)
      #print(sql_query)
      cursor = cnxn.cursor()
      cursor.execute(sql_query, server)
      #cursor.execute(sql_query)
      result = cursor.fetchall()
      cursor.close()
      cnxn.close()
    except Exception as e:
      print('An error occurred.')
      print(e)
    return result
  
def pool_handler():
    #threads = math.ceil((os.cpu_count())/2)
    p = Pool(threads)
    result_all = []
    disk_result = []
    ptable = PrettyTable()

    for allrows in p.map(query_server, servers):
        for row in allrows:
          disk_result.append(row)
    
    #print(disk_result)
    ptable.field_names = [column[0] for column in disk_result[0].cursor_description]
    ptable.add_rows(disk_result)
    
    print(ptable)

if __name__ == '__main__':
    pool_handler()

