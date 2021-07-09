local pokedex = require("sim.dex")

local function printkv(t)
	for k,v in pairs(t) do
		print(("Key: %s, Value: %s"):format(k, v))
	end
end

local hash = {}
local function printkvRecursively(t, depth)
	depth = depth or 0
	for k,v in pairs(t) do
		if type(v) == "table" and not hash[v] then
			hash[v] = true
			printkvRecursively(v, depth + 1)
		end
		print(("%sKey: %s, Value: %s"):format(("	"):rep(depth), k, v))
	end
end

printkvRecursively(pokedex)