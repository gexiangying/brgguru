require"luabridge"
module(...,package.seeall)

default_vp = 12.0

function floor_num(n)
if n > 0 then
	n = n + 0.005
  n = n - n % 0.01  	
else
	n = -n
	n = n + 0.005
  n = n - n % 0.01  	
  n = -n
end
return n
end

function init_result_item(t)
  t.mp = t.mp or 0.0
  t.ximp = t.ximp or 0.0
  t.imp = t.imp or 0.0
  t.plus = t.plus or 0
  t.minus = t.minus or 0
	t.num = t.num or 0
end

function cal_im_EW(sets,result)
for i,v in ipairs(sets) do
  local ew_name = "EW" .. v.EW
	result[ew_name] = result[ew_name] or {}
	local t = result[ew_name]
  init_result_item(t) 
	t.mp = t.mp + v.EW_mp
  t.ximp = t.ximp + v.EW_ximp
  t.num = t.num + 1
  t.no = v.EW
  if(v.EW_imp >0) then 
		t.plus = t.plus + v.EW_imp 
  else
    t.minus = t.minus - v.EW_imp
	end
end
end 



function cal_im_NS(sets,result)
for i,v in ipairs(sets) do
  local ns_name = "NS" .. v.NS
	result[ns_name] = result[ns_name] or {}
	local t = result[ns_name]
  init_result_item(t) 
	t.mp = t.mp + v.NS_mp
  t.no = v.NS
  t.section = v.section
  t.ximp = t.ximp + v.NS_ximp
  t.num = t.num + 1
  if(v.NS_imp >0) then 
		t.plus = t.plus + v.NS_imp 
  else
    t.minus = t.minus - v.NS_imp
	end
end
end 

function cal_sets_EW(sets)
	local result = {}
	for k,v in ipairs(sets) do
	  cal_im_EW(v,result)
	end 
	return result
end


function cal_sets_NS(sets)
	local result = {}
	for k,v in ipairs(sets) do
	  cal_im_NS(v,result)
	end 
	return result
end

function mk_sets_nil(t)
local sets = {}
	for i,v in ipairs(t) do
			sets[v.board] = sets[v.board] or {}
      table.insert(sets[v.board],v)
  end
	return sets
end

function mk_sets_round_table(t,round,desk)
	local sets = {}
	for i,v in ipairs(t) do
   if v.round == round  and v.table == desk then
			sets[v.board] = sets[v.board] or {}
      table.insert(sets[v.board],v)
   end 
  end
	return sets
end


function mk_sets_round(t,round)
	local sets = {}
	for i,v in ipairs(t) do
   if v.round == round then
			sets[v.board] = sets[v.board] or {}
      table.insert(sets[v.board],v)
   end 
  end
	return sets
end

function mk_sets(t,round,desk)
	if desk then
		return mk_sets_round_table(t,round,desk)
	elseif round then
		return mk_sets_round(t,round)
  else
		return mk_sets_nil(t)
  end
end

function imp_im(t,sets)
	local num = 0.0
	for i,v in ipairs(sets) do
    if t.table == v.table then 
			local score = t.score - v.score
			num = num + luabridge.imp(score)
    end
  end
  t.NS_imp = num 	
  t.EW_imp = -t.NS_imp
end

function imp(sets)
	for i,v in ipairs(sets) do
		imp_im(v,sets)
	end
end

function ximp_im(t,sets)
  local num = 0.0
	for i,v in ipairs(sets) do
    local score = t.score - v.score
    num = num + luabridge.imp(score)
  end
  t.NS_ximp = num /(#sets -1) 	
  t.NS_ximp = floor_num(t.NS_ximp)
  t.EW_ximp = -t.NS_ximp
end
function ximp(sets)
	for i,v in ipairs(sets) do
		ximp_im(v,sets)
	end
end
function mp_im(t,sets)
	local num = 0.0
	for i,v in ipairs(sets) do
   if t.score > v.score then
		num = num + 1.0
   elseif t.score == v.score then
		num = num + 0.5
   end
  end
  num = num - 0.5;
  t.NS_mp = num * 100 /(#sets -1) 
  t.NS_mp = floor_num(t.NS_mp)  
  t.EW_mp = 100 - t.NS_mp
end

function mp(sets)
	for i,v in ipairs(sets) do
		mp_im(v,sets)
	end
end

function vp(boards,imp)
        if boards < 1 then return 0.0 end
	flag = true
	if imp < 0.0 then
	 flag = false
	 imp = -imp 
	end
	local a = (math.sqrt(5) - 1) / 2
	local b = imp / ( 5 * math.sqrt(boards))
	if b > 3 then b = 3 end
	local z = 10 * ( 1 - math.pow(a,b)) /  (1 - math.pow(a,3))
	z = z + 0.005
	if flag then
		return 10 + z - z % 0.01
	else
		return 10 - (z - z % 0.01) 
	end
end

function bgl(m)
	local result = {}
	local a =1
	local b =1
	local index = 1
	local loop = 0

	local iter = 0
	--print([[round_data = {}]])
	for i=1,(m-1)*(m/2) do
	if a>=m then a = 1 end
	if index > m/2 then index = 1 end
	if index == 1 then
	loop = loop +1
	if i==1 then 
	b=m
	else
	b=a
	end
	--print("round_data[" .. loop .. "] = {}" )
	result[loop] = {}
	iter = 0	
	if (((i-1)/(m/2))%2 == 0) then
	iter = iter + 1
  result[loop][iter] = a
	--print("round_data[" .. loop .. "][" .. iter .. "] = " .. a)
	iter = iter + 1
	result[loop][iter] = m
	--print("round_data[" .. loop .. "][" .. iter .. "] = " .. m)
	else
	iter = iter + 1
  result[loop][iter] = m
	--print("round_data[" .. loop .. "][" .. iter .. "] = " .. m)
	iter = iter + 1
  result[loop][iter] = a
	--print("round_data[" .. loop .. "][" .. iter .. "] = " .. a)
	end

	elseif (index >1 and index <= m/2) then
	if b>1 then b= b-1
	else b = m -1
	end
	iter = iter + 1
  result[loop][iter] = a
	--print("round_data[" .. loop .. "][" .. iter .. "] = " .. a)
	iter = iter + 1
  result[loop][iter] = b
	--print("round_data[" .. loop .. "][" .. iter .. "] = " .. b)
	end
	index = index + 1
	a = a + 1
	end

	return result
end
