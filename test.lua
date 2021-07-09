local pokedex = require("sim.dex")

local function printkv(t)
	for k,v in pairs(t) do
		print(("Key: %s, Value: %s"):format(k, v))
	end
end

printkv(pokedex)