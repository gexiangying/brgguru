require "ado"

file_name = os.date("%Y-%m-%d")
--file_name =  "2013"
database_name = file_name .. ".bws"
db_string = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" .. database_name

Clients = {}
Clients[1] = {}
Clients[1].ID = 1
Clients[1].Computer = "LENOVO-PC"

