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
		print(("%sKey: %s, Value: %s"):format(("  "):rep(depth), k, v))
		if type(v) == "table" and not hash[v] then
			hash[v] = true
			printkvRecursively(v, depth + 1)
		end
	end
end

--printkvRecursively(pokedex)

--[[ Output of above:
Key: toID, Value: function: 000000000069b190
Key: Dex, Value: table: 00000000006effc0
Key: default, Value: table: 00000000006effc0 -- the above 3 are empty?
Key: ModdedDex, Value: table: 00000000006efe00
  Key: prototype, Value: table: 00000000006f0040
    Key: trunc, Value: function: 00000000006e8e30
    Key: effectToString, Value: function: 00000000006e9310
    Key: getName, Value: function: 00000000006e9220
    Key: loadTextFile, Value: function: 00000000006f02c0
    Key: includeFormats, Value: function: 00000000006e9100
    Key: constructor, Value: table: 00000000006efe00
    Key: loadData, Value: function: 00000000006f0640
    Key: modData, Value: function: 00000000006efc40
    Key: __newindex, Value: function: 0000000000657780
    Key: __index, Value: function: 0000000000656f70
    Key: getDescs, Value: function: 00000000006f0300
    Key: includeData, Value: function: 00000000006e8f50
    Key: includeModData, Value: function: 00000000006efec0
    Key: includeMods, Value: function: 00000000006b8c60
    Key: mod, Value: function: 00000000006e8e00
    Key: dataSearch, Value: function: 00000000006f0600
    Key: _descriptors, Value: table: 00000000006f0080
      Key: dexes, Value: table: 00000000006f0280
        Key: configurable, Value: false
        Key: get, Value: function: 00000000006e8bf0
        Key: enumerable, Value: false
      Key: data, Value: table: 00000000006ef980
        Key: configurable, Value: false
        Key: get, Value: function: 00000000006e88c0
        Key: enumerable, Value: false
    Key: forFormat, Value: function: 00000000006f00c0
    Key: loadDataFile, Value: function: 00000000006f0140
    Key: getEffectiveness, Value: function: 00000000006e9340
    Key: getActiveMove, Value: function: 00000000006e90a0
    Key: loadTextData, Value: function: 00000000006e8f80
    Key: forGen, Value: function: 00000000006e92e0
    Key: ____constructor, Value: function: 000000000067f030
    Key: getImmunity, Value: function: 00000000006e8da0
    Key: getHiddenPower, Value: function: 00000000006e8860
  Key: name, Value: ModdedDex
--]]


printkvRecursively(pokedex.Dex)

local pokemon = pokedex

