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

local pokedex = require("data.pokedex").Pokedex -- vanilla

local balls = require("data.balls")

local languages = require("data.languages")

local items = require("data.items")

local natures = require("data.natures")

local moves = require("data.moves")

-- default pokemon will be bulbasaur
-- Copying this order from PKHeX as I will be using it to help myself convert to and from the relevant format (pk8)

-- copied from: http://notebook.kulchenko.com/algorithms/alphanumeric-natural-sorting-for-humans-in-lua
local function alphanumsort(o)
  local function padnum(d) local dec, n = string.match(d, "(%.?)0*(.+)")
    return #dec > 0 and ("%.12f"):format(d) or ("%s%03d%s"):format(dec, #n, n) end
  table.sort(o, function(a,b)
    return tostring(a):gsub("%.?%d+",padnum)..("%3d"):format(#b)
         < tostring(b):gsub("%.?%d+",padnum)..("%3d"):format(#a) end)
  return o
end
-- /copy

local function generateIndexFromTable(tbl)
	-- generated index should be based on alphanumerical order
	-- this should then be printed and used as hardcoded, so as to make it easier to control and manage, as keys are loaded in a random order in lua (not part of lua specs to load things in specific order if not indexed by integers)
	local i = 0
	for k,v in ipairs(alphanumsort(tbl)) do
		print(string.format([["%s",[%s]=%s,]], k, k, i))
		i = i + 1
	end	
end

generateIndexFromTable(balls)

-- use something like binser to write these into binary and then read them back, instead of storing them in pkhex.
-- only export/import pkhex format manually (?)

-- TODO: use index thingies to decrease used space, and to allow easy de/serialization of the pokemon.

-- use metatable nonsense to allow tables be non-case-sensitive
local Pokemon = {
	-- Main
	main = {
		pokemon_id = 0, -- determines shininess
		dex_name = "bulbasaur", -- maybe just point directly to the relevant entry? would mean we need pokedex accessible globally but thats not a problem probably
		dex_type = "pokedex", -- which dex to look in
		nickname = "Chika", -- well, if this is not false then it's true so we dont need a separate field for the flag.
		experience = 0,
		level = 1,
		nature = natures.Hardy,
		stat_nature = natures.Hardy,
		form = 0,
		held_item = items.stick, -- point to the actual item?
		ability = 0, -- Hidden is -1
		ability_number = 0, -- important for legality
		friendship = 69,
		language = languages.Japanese,
		is_egg = false,
		pokerus = {
			infected = false,
			cured = false,
			days = 0,
		},
		height = 127,
		weight = 127,
		shadow = {
			is_shadow_pokemon = false,
			is_purified = false,
			heart_gauge = 0,
		},
		ball_decorations = {
			shiny_leaves = 0,-- up to 5?
			seals = {
				{name = "heart", coordinates = {0,4,0}, size = {0,0,0}}, -- probably restrict coordinates to be at most n% away from the pokemons hitbox or the pokeballs.
			}
		}
	},
	
	-- Met
	met = {
		origin_game = 0,
		battle_version = 0,
		ball = balls.pokeball,
		
		met_level = 1,
		met_location = 0,
		met_date = {
			year = 0,
			month = 0,
			day = 0
		},
		fateful_encounter = false,
		
		as_egg = false,
		egg_met_location = false,
		egg_met_date = {
			year = 0,
			month = 0,
			day = 0
		},
		
		home_tracker = 0,
	},
	
	-- Stats
	stats = {
		ivs = {
			hp = 0,
			attack = 0,
			defense = 0,
			special_attack = 0,
			special_defense = 0,
			speed = 0,
		},
		
		hyper_trained = {
			hp = false,
			attack = false,
			defense = false,
			special_attack = false,
			special_defense = false,
			speed = false,
		},
		
		evs = {
			hp = 0,
			attack = 0,
			defense = 0,
			special_attack = 0,
			special_defense = 0,
			speed = 0,
		},
		
		dynamaxLevel = 0,
		gigantamax = false,
		
		contest = {
			cool = 0,
			beauty = 0,
			cute = 0,
			clever = 0,
			tough = 0,
			sheen = 0
		}
	},
	
	-- Attacks, unsure about the best approach, but this will at least let me easily access and modify moves
	attacks = {
		moves = {
			{name = moves.pound, pp = 1, pp_ups = 0 },
			{name = moves.leechseed, pp = 0, pp_ups = 1 },
			{name = moves.solarbeam, pp = 2, pp_ups = 2 },
			--moves.skyattack,
			--4,
			--3
		},
		
		relearn_moves = {
			moves.batonpass
		},
		
		trs = {
			
		}
	},
	
	-- OT/Misc
	
	misc = {
		original_trainer = {
			name = "Minecraft Steve",
			trainer_id = 123456,
			secret_id = 678910,
			gender = 0,
			language = languages.English,
			intensity = 0,
			memory = 0,
			feeling = 0,
			text_variant = 0,
		},
		previous_trainer = {
			name = "Minecraft Alex",
			trainer_id = 654321,
			secret_id = 019876,
			gender = 1,
			language = languages.French,
			intensity = 0,
			memory = 0,
			feeling = 0,
			text_variant = 0,
		},
		
		markings = {
			"square", -- use index thingy for this as well?
			"triangle",
			"heart"
		},
		
		ribbons = {
			"national" -- use an index thingy and generate a list and use numbers for ribbons to decrease used space?
		},
		
		memories = { -- superfluous due to trainer thing? move trainer thing into this? create previous/old_memories?
		
		},
		
		checksum = 0, -- only update when writing to pk8
		encryptionConstant = 0
	},
	
	battle_stats = {
		hp = 0,
		attack = 0,
		defense = 0,
		special_attack = 0,
		special_defense = 0,
		speed = 0,
		-- modifiers?
		status_condition = 0,
	},
	
	unknown = {
	
	},
	
	unused = {
	
	},
	
	
	-- I decided that I may as well just store all pokemon in PCs using memory-effecient formats, and just general party pokemon using the above.
	-- This would allow me to more easily add custom ribbons, moves etc, without making it difficult to store memory-effeciently since I can just split the legal data into one part and the custom data into another
	--[[
	TRs = 2 << 34, -- just a big number since it can be stored in 100 bits, lua allows -2^63 to 2^63  (-9223372036854775808 to 9223372036854775807), however, it would be more sensible to use the string id and then do the logic for writing it only when dealing with pk8, possibly.
	Markings = 0, -- Shiny, PokerusCured, Circle, Triangle, Square, Heart, Star, Rhombus, OriginGame, OriginBattle, ??? what is that blue white star symbol im out of the loop. Anyway just merged these into a single integer and figure out what it was when viewing a pokemon using math so we dont need to store more data since this information is rarely viewed(?).
	Ribbons = 0, -- Same as above/TRs, we have 98 possible ribbons, two of which require 4 bits and 6 bits respectively, we can store that in a single int using up 108 out of 116(?) bits. do we want to?
	--]]
	
}

-- do this every reload? pros: consistent, easy to fix problems. cons: not as easily customizable?
for k, v in pairs(pokedex.bulbasaur) do
	Pokemon[k] = v
end


--[[

    What is in a Pokemon?
        Dex ID
        Pokemon Species
        Pokemon Subspecies (alternate forms)
        Type(s)
        Abilities
        Learnsets
        
        What about a specific pokemon (owned)?
            Checksum
            Personality Value
            Language
            Original Trainer
            Trainer ID
            Hidden ID
            Ball
            Nickname
            Markings
            Date Egg Received
            Date Met
            Met location
            Met level
            Caught/Hatched/Received
            Encounter Type
            Original Game
            Obedience
            Coolness
            Beauty
            Cuteness
            Smartness
            Toughness
            Feel
            Sheen
            Ribbons
            Nature
            IVs (Determines Hidden Power)
            IVs (Hypertrained)
            EVs
            Current Ability
            Current Moves
            Current Moves Max PP
            Shininess
            Friendship
            Level
            Experience
            Dynamax Level
            Pokerus status
            Held Item
            Status Condition
            Current HP
            Gender
            Shadow
			Heart Gauge
            Shiny Leaves
            Seals
            Seal Coordinates
--]]

function Pokemon:create(specs)
	for k,v in pairs(specs) do
		--
	end
	self.__gender = specs.gender
	self.__level = specs.level
end

local PKM

-- ok lets try deserializing a pk8 file a bits

local pk8 = require("pkhex.pk8")
--print(pk8)