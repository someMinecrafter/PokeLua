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

local Pokedex = require("data.pokedex")

local Balls = require("data.balls")

local languages = require("data.languages")

-- default pokemon will be bulbasaur
-- Copying this order from PKHeX as I will be using it to help myself convert to and from the relevant format (pk8)
local Pokemon = {
	-- Main
	Main = {
		PID = 0, -- determines shininess
		DexName = "bulbasaur", -- maybe just point directly to the relevant entry? would mean we need pokedex accessible globally but thats not a problem probably
		DexType = "Pokedex",
		Nickname = "Chika", -- well, if this is not false then it's true so we dont need a separate field for the flag.
		EXP = 0,
		Level = 1,
		Nature = natures.Hardy,
		StatNature = ,
		Form = 0,
		HeldItem = , -- point to the actual item?
		Ability = 0, -- Hidden is -1
		Friendship = 69,
		Language = languages.Japanese,
		IsEgg = false,
		Infected = false,
		Cured = false,
		Height = 127,
		Weight = 127,
	},
	
	-- Met
	Met = {
		OriginGame = 0,
		BattleVersion = 0,
		MetLocation = 0,
		Ball = Balls.pokeball,
		MetLevel = 1,
		MetDate = ,
		FatefulEncounter = false,
		AsEgg = false,
		EggMetLocation = false,
		EggMetDate = false,
		HOMETracker = 0,
	}
	
	-- Stats
	Stats = {
		IVs = {
			HP = 0,
			Atk = 0,
			Def = 0,
			SpA = 0,
			SpD = 0,
			Spe = 0
		},
		
		EVs = {
			HP = 0,
			Atk = 0,
			Def = 0,
			SpA = 0,
			SpD = 0,
			Spe = 0
		},
		
		DynamaxLevel = 0,
		Gigantamax = false,
		
		Contest = {
			Cool = 0,
			Beauty = 0,
			Cute = 0,
			Clever = 0,
			Tough = 0,
			Sheen = 0
		}
	},
	
	-- Attacks, unsure about the best approach, but this will at least let me easily access and modify moves
	Attacks = {
		Moves = {
			moves.pound,
			1, -- one base PP, no upgrades
			0,
			moves.leechseed,
			10, -- ten base PP, plus one upgrade
			1,
			moves.solarbeam,
			3, -- three base PP, plus two upgrade
			2,
			--moves.skyattack,
			--4,
			--3
		}
		
		RelearnMoves = {
			moves.batonpass
		},
		
		TRs = {
			
		}
	},
	
	-- OT/Misc
	
	Misc = {
		TrainerInfo = {
			OT = "Minecraft Steve",
			TID = 123456,
			SID = 678910,
			Gender = 1,
		},
		PreviousTrainerInfo = {
			OT = "Minecraft Alex",
			Language = languages.French,
		},
		
		ExtraBytes = {
			
		},
		
		Markings = {
		
		},
		
		Ribbons = {
		
		},
		
		Memories = {
		
		},
		
		EncryptionConstant = 0
	},
	
	BattleStats = {
		HP = 1,
		
	},
	
	
	-- I decided that I may as well just store all pokemon in PCs using memory-effecient formats, and just general party pokemon using the above.
	-- This would allow me to more easily add custom ribbons, moves etc, without making it difficult to store memory-effeciently since I can just split the legal data into one part and the custom data into another
	--[[
	TRs = 2 << 34, -- just a big number since it can be stored in 100 bits, lua allows -2^63 to 2^63  (-9223372036854775808 to 9223372036854775807)
	Markings = 0, -- Shiny, PokerusCured, Circle, Triangle, Square, Heart, Star, Rhombus, OriginGame, OriginBattle, ??? what is that blue white star symbol im out of the loop. Anyway just merged these into a single integer and figure out what it was when viewing a pokemon using math so we dont need to store more data since this information is rarely viewed(?).
	Ribbons = 0, -- Same as above/TRs, we have 98 possible ribbons, two of which require 4 bits and 6 bits respectively, we can store that in a single int using up 108 out of 116(?) bits. do we want to?
	--]]
	
}

for k, v in pairs(Pokedex.bulbasaur) do
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
	self.__gender = specs.gender
	self.__level = specs.level
end

local PKM = pokemon:c

