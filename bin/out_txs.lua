dofile(arg[1])
local function out_txs(num)
	for k= 1,num do
		for i,v in ipairs(project.data) do
			if v.board == k then
				print(v.score)
			end
		end
	end
end

function txs()
	local num = #project.index
	out_txs(num)
end
txs()
