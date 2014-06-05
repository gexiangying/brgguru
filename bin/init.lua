dofile("setup.lua")
dofile("round_datas.lua")

os.execute("copy Default.bws " .. database_name)
local db = ADO_Open(db_string)
db:exec("UPDATE [Clients] SET Computer = '" .. Clients[1].Computer .. "' WHERE Computer <> '" .. Clients[1].Computer .. "'")

local sections = round_datas.section
local desks = round_datas.desks

for i =1,sections do
db:exec("INSERT INTO [Section] VALUES(" .. i .. ",'" .. string.char(string.byte("A") + i - 1) .. "'," .. desks .. ",0)")
end

for j=1,sections do
for i=1,desks do
db:exec("INSERT INTO [Tables] VALUES (" .. j .. "," .. i .. ",1,0,2,0,0,0)")
end
end
--os.execute("\"C:\\Program Files\\Bridgemate Pro\\BMPro.exe\" /f:[d:\\mdbplus\\" .. database_name .. "]  /s /r")
db:close()


