require("brg")
dofile("round_datas.lua")
dofile("result.dat")

if not arg[1] then
print("lua robin.lua round")
os.exit()
end

cur = tonumber(arg[1])

ns = {}
-- caculate total vp
for round,data in pairs(ns_dat) do
	if round <= cur then
		for no,v in pairs(data) do
			ns[no] = ns[no] or 0.0
      ns[no] = ns[no] + v.vp
		end
  end
end
-- add miss round default vp
for k,v in pairs(miss) do
  if v <= cur then
		ns[k] = ns[k] or 0.0
    ns[k] = ns[k] + brg.default_vp
  end	
end

function cmp_vp(a,b)
	return a.vp > b.vp
end

function sort_ns()
local temp = {}
for k,v in pairs(ns) do
  local t = {}
	t.no = k
  t.vp = v
	table.insert(temp,t)
end	
table.sort(temp,cmp_vp)
return temp
end

--sorted by vp
local t = sort_ns()

print("----------------------------")
print("class\tteam\tvp")
print("----------------------------")
for i,v in ipairs(t) do
  print(i .. "\t" .. v.no .. "\t" .. v.vp)
end
--


