module(...,package.seeall)

local function basicSerialize(o,saved)
if type(o) == "number" then
return tostring(o)
elseif type(o) == "table" then
return saved[o]
elseif type(o) == "boolean" then
return tostring(o)
else
return string.format("%q",o)
end
end

local function save(name,value,saved)
if not name then return end
saved = saved or {}
io.write(name," = ")
if type(value) == "number" or type(value) == "string" or type(value) =="boolean" then
io.write(basicSerialize(value),"\n")
elseif type(value) == "table" then
if saved[value] then
io.write(saved[value],"\n")
else
saved[value] = name
io.write("{}\n")
for k,v in pairs(value) do
k = basicSerialize(k,saved)
if k then 
local fname =  string.format("%s[%s]",name,k)
save(fname,v,saved)
end
end
end
else
error("cannot save a "..type(value))
end
end

function save_file(file,content,key)
local temp = io.output()
io.output(file)
local t = {}
if key then
  save(key,content,t)
else
for k,v in pairs(content) do
save(k,v,t)
end
end
io.flush()
io.output():close()
io.output(temp)
end


