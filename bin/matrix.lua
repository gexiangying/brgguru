module(...,package.seeall)

mode_flag = "round"
function get_matrix()
local mat = iup.matrix{widthdef=50,SCROLLBAR="YES"}
mat.resizematrix = "YES"
return mat
end

local function reset_round(mat)
mat.numcol = 5
mat.numcol_visible = 5
mat.numlin=project.desks or 0
mat.numlin_visible=project.desks or 0
local desks = project.desks or 0
mat:setcell(0,0,"����")
mat:setcell(0,1,"NS")
mat:setcell(0,2,"EW")
mat:setcell(0,3,"����")
mat:setcell(0,4,"��ʼ�ƺ�")
mat:setcell(0,5,"�����ƺ�")
for i=1,desks do
local round = project.round[project.cur_round][i]
mat:setcell(i,0,i)
mat:setcell(i,1,round.NS)
mat:setcell(i,2,round.EW)
mat:setcell(i,3,round.section)
mat:setcell(i,4,round.l)
mat:setcell(i,5,round.h)
end
end

local function reset_data(mat,cur,desk)
mat.numcol = 8
mat.numcol_visible = 8
local num =0
for i,v in ipairs(project.data) do
if v.round == cur and v["table"] == desk then
num = num + 1
end
end
mat.numlin= num
mat.numlin_visible= num

mat:setcell(0,0,"��¼")
mat:setcell(0,1,"����")
mat:setcell(0,2,"�ϱ�")
mat:setcell(0,3,"����")
mat:setcell(0,4,"����")
mat:setcell(0,5,"�ִ�")
mat:setcell(0,6,"����")
mat:setcell(0,7,"��Լ")
mat:setcell(0,8,"�÷�")
num=0
for i,v in ipairs(project.data) do
if v.round == cur and v["table"] == desk then
num = num + 1
mat:setcell(num,0,i)
mat:setcell(num,1,v["table"])
mat:setcell(num,2,v["NS"])
mat:setcell(num,3,v["EW"])
mat:setcell(num,4,v["section"])
mat:setcell(num,5,v["round"])
mat:setcell(num,6,v["board"])
mat:setcell(num,7,v["constr"])
mat:setcell(num,8,v["score"])
end
end

end

function reset(mat,flag,cur,desk)
mode_flag = flag or "round"
if mode_flag == "round" then
reset_round(mat)
elseif mode_flag == "data" then
reset_data(mat,cur,desk)
end
iup.UpdateChildren(MDI1Form)
end

function get_value(mat)
if mode_flag ~= "round" then return nil end
local dat = {}
for i = 1,mat.numlin do
 dat[i] = dat[i] or {}
 dat[i].NS = tonumber(mat[i .. ":" .. 1])
 dat[i].EW = tonumber(mat[i .. ":" .. 2])
 dat[i].section = tonumber(mat[i .. ":" .. 3])
 dat[i].l = tonumber(mat[i .. ":" .. 4])
 dat[i].h = tonumber(mat[i .. ":" .. 5])
end
return dat
end
