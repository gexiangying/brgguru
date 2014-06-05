require("brg")
require("comma")
dofile("result.dat")

if not arg[1] then
print("lua swiss.lua round")
os.exit()
end

--cur = round_datas.cur_round - 1
cur = tonumber(arg[1])

for k,v in pairs(pk) do
  for i,v1 in pairs(v) do
    if v1 > cur then
     pk[k][i] = nil
    end
  end
end

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

-- get miss add remov it
if #t % 2 ~=0 then
for i=#t,1,-1 do
  if not miss[t[i].no] then	
    miss[t[i].no] = cur + 1
    t[i].flag = true
		break
  end 
end
end

--caculate next pk info
local desks = #t / 2
local next_round = cur + 1
local flag = false
--even round big pre little no
if next_round % 2 == 0 then
 flag = true
end

function get_opp(v1,t)
	pk[v1.no] = pk[v1.no] or {}
	v1.count = v1.count or 1
  local count = 0
  for i,v in ipairs(t) do
		if (not v.flag) and (not pk[v1.no][v.no]) then
     count = count + 1
     if count == v1.count then
     v.flag = true
     return v
     end
    end  
	end
end

local desk_info = {}
--get top t,add remove ,search opp,if fail ,readd top,back to i-1
--for i = 1,desks do

function get_first()
  for i,v in ipairs(t) do
    if not v.flag then
      v.flag = true
      return v
    end
  end
end

function get_desk(i)
	desk_info[i] = {}	
  local v1 = get_first() 
  local no1 = v1.no
	local v2 = get_opp(v1,t)

  if v2 then 
		desk_info[i].v1 = v1
    desk_info[i].v2 = v2
		return true
  else
    desk_info[i] = nil
		v1.flag = nil 
		return false
  end
end


--rollback predesk
function rollback(desk)
  local v1 = desk_info[desk].v1
  local v2 = desk_info[desk].v2
	v1.flag = nil
	v2.flag = nil
  desk_info[desk] = nil
  v1.count = v1.count or 2
  v1.count = v1.count + 1
end

local desk = 1

while true do
  if desk > desks then break end
  if get_desk(desk) then
		desk = desk + 1
  else
    desk = desk - 1 
    if desk == 0 then 
			print("conn't  swiss next!") 
			break 
		end
    rollback(desk)
  end
end

print("\n\n##########################")
print("table\tteam1\tteam2")
for i,v in ipairs(desk_info) do
  local big = v.v1.no > v.v2.no and v.v1 or v.v2
  local little = v.v1.no < v.v2.no and v.v1 or v.v2
  --even round bid>little
  if flag then
   v.v1 = big
   v.v2 = little
  else
   v.v1 = little
   v.v2 = big
  end
  print(i .. "\t" .. v.v1.no  .. "\t" .. v.v2.no)	
end

---add info to pk table
for i,v in ipairs(desk_info) do
  local no1 = v.v1.no
  local no2 = v.v2.no
  pk[no1] = pk[no1] or {}
  pk[no2] = pk[no2] or {}
  pk[no1][no2] = next_round
  pk[no2][no1] = next_round
  ns_dat[next_round] = ns_dat[next_round] or {}
  ns_dat[next_round][no1] = {} 
  ns_dat[next_round][no1].no = no1
  ns_dat[next_round][no1].vp = math.random(20)

  ns_dat[next_round][no2] = {} 
  ns_dat[next_round][no2].no = no2
  ns_dat[next_round][no2].vp = 20 - ns_dat[next_round][no1].vp
end

if arg[2] and arg[2] == "w" then
local save_t = {}
save_t.miss = miss
save_t.pk = pk
save_t.ns_dat = ns_dat
save_t.ew_dat = ew_dat
comma.save_file("result.dat",save_t)
end
