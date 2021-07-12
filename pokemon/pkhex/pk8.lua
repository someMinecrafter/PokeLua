-- One pokemon seems to be 344 bytes.
-- this means we would need a lot of bits, like maybe 30 ints per vanilla pokemon...
function utf8_from(t)
  local bytearr = {}
  for _, v in ipairs(t) do
    local utf8byte = v < 0 and (0xff + v + 1) or v
    table.insert(bytearr, string.char(utf8byte))
  end
  return table.concat(bytearr)
end

-- serializer/deserializer
local decrypter = 0
local encrypter = 0

local PokemonToMappings = {

}



local function getPersonalInfo(species, form)
	
end

local function getCheckSum(pokemon)

end

--[[
	I'm making use of https://github.com/kwsch/PKHeX/blob/master/PKHeX.Core/PKM/PK8.cs

	I can just infer the amount of bits something has, if they were all used, however, they are not all used.
	I will use the unused alignment bytes data for this, since we can safely assume we have 8 bits between each value
	have to figure out good way to read and write from/to these as well...
	if a read/write function is not defined (or possibly regardless if it is defined or not) define one based on the unused bytes.
	goal is to be able to either append data at the end of the file(ideal if pkhex simply ignores them), or to use the unused bytes for storing data(if the bytes get discarded).
--]]

-- very lazy code, leaving as is in case I decide to change it, but this should only be run once. I can simply dump the table and paste it afterwards in order to avoid doing it again, in which case this will all be included in the comment block above.
local function calculateAndAddLengthToHex_Mappings(hex_mappings, unused)
	local sorted_by_data = {}
	local current_data, previous_data = 0, 0
	for k,v in pairs(hex_mappings) do
		previous_data = current_data
		current_data = hex_mappings.data
		sorted_by_data[current_data] = k -- swaps data and other thing, we dont really care too much about the key.
	end
	local current_data, previous_data = 0, 0
	for k,v in pairs(unused) do
		previous_data = current_data
		current_data = v
		sorted_by_data[current_data] = string.format("Unused_%s", v)
	end
	local current_data, previous_data = 0, 0
	for k,v in pairs(sorted_by_data) do
		previous_data = current_data
		current_data = k
		if not hex_mappings[v] then
			hex_mappings[v] = {data=k}
		end
		hex_mappings[v].data_size = k - current_data -- we now know the size of our things
	end
end

local function addStandardReadAndWriteToUndefinedEntries(hex_mappings)
	for k,v in pairs(hex_mappings) do
		if v.bit then
			v.read = function()
				
			end
		else
			v.read = function()
				
			end
		end
		v.write = function(data)
		
		end
	end
end


local unused = { -- aka extra bytes?
	-- Alignment bytes
	0x17, 0x1A, 0x1B, 0x23, 0x33, 0x3E, 0x3F,
	0x4C, 0x4D, 0x4E, 0x4F,
	0x52, 0x53, 0x54, 0x55, 0x56, 0x57,
	
	0x91, 0x92, 0x93,
	0x9C, 0x9D, 0x9E, 0x9F, 0xA0, 0xA1, 0xA2, 0xA3, 0xA4, 0xA5, 0xA6, 0xA7,
	
	0xC5,
	0xCE, 0xCF, 0xD0, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD7, 0xD8, 0xD9, 0xDA, 0xDB, 0xDC, 0xDD,
	0xE0, 0xE1, -- Old Console Region / Region
	0xE9, 0xEA, 0xEB, 0xEC, 0xED, 0xEE, 0xEF, 0xF0, 0xF1, 0xF2, 0xF3, 0xF4, 0xF5, 0xF6, 0xF7,
	0x115, 0x11F, -- Alignment

	0x13D, 0x13E, 0x13F,
	0x140, 0x141, 0x142, 0x143, 0x144, 0x145, 0x146, 0x147,
}

local hex_mappings

hex_mappings = {
	-- region Block A
	["EncryptionConstant"] = {data=0x00}, -- 32
	["Sanity"] = {data=0x04}, -- 16
	["Checksum"] = {data=0x06}, -- 16
	["Species"] = {data=0x08},
	["HeldItem"] = {data=0x0A},
	["TID"] = {data=0x0C},
	["SID"] = {data=0x0E},
	["EXP"] = {data=0x10},
	["Ability"] = {data=0x14},
	["AbilityNumber"] = {data=0x16,Specific=function(data, value) data = data & 7; data = (data & ~7) | (value & 7) ; return data end},
	["Favorite"] = {data=0x16,Specific=function(data, value) data = data & 8; data = (data & ~8) | ((value and 1 or 0) << 3) ; return data end},
	["CanGigantamax"] = {data=0x16,Specific=function(data, value) data = data & 16; data = (data & ~16) | (value and 16 or 0) ; return data end},
	-- 0x17 alignment unused
	["MarkValue"] = {data=0x18},
	-- 0x1A alignment unused
	-- 0x1B alignment unused
	["PID"] = {data=0x1C},
	["Nature"] = {data=0x20},
	["StatNature"] = {data=0x21},
	["FatefulEncounter"] = {data=0x22,Specific=function(data, value) data = (data & 1) == 1; data = (data & ~0x01) | (value and 1 or 0) ; return data end},
	["Flag2"] = {data=0x22,Specific=function(data, value) data = (data & 2) == 2; data = (data & ~0x02) | (value and 2 or 0) ; return data end},
	["Gender"] = {data=0x22,Specific=function(data, value) data = (data >> 2) & 0x3; data = (data & 0xF3) | (value << 2) ; return data end},
	-- 0x23 alignment unused
	["Form"] = {data=0x24},
	["EV_HP"] = {data=0x26},
	["EV_ATK"] = {data=0x27},
	["EV_DEF"] = {data=0x28},
	["EV_SPE"] = {data=0x29},
	["EV_SPA"] = {data=0x2A},
	["EV_SPD"] = {data=0x2B},
	["CNT_Cool"] = {data=0x2C},
	["CNT_Beauty"] = {data=0x2D},
	["CNT_Cute"] = {data=0x2E},
	["CNT_Smart"] = {data=0x2F},
	["CNT_Tough"] = {data=0x30},
	["CNT_Sheen"] = {data=0x31},
	["PKRS"] = {data=0x32},
	["PKRS_Days"] = {data=0x32,Specific=function(data, value) data = data & 0xF; data = (data & ~0xF) | value end},
	["PKRS_Strain"] = {data=0x32,Specific=function(data, value) data = data >> 4; data = (data & ~0xF) | value << 4 end},
	-- 0x33 unused padding
	

	-- ribbon u32
	["RibbonChampionKalos"] = {data=0x34,bit=0},
	["RibbonChampionG3"] = {data=0x34,bit=1},
	["RibbonChampionSinnoh"] = {data=0x34,bit=2},
	["RibbonBestFriends"] = {data=0x34,bit=3},
	["RibbonTraining"] = {data=0x34,bit=4},
	["RibbonBattlerSkillful"] = {data=0x34,bit=5},
	["RibbonBattlerExpert"] = {data=0x34,bit=6},
	["RibbonEffort"] = {data=0x34,bit=7},

	["RibbonAlert"] = {data=0x35,bit=0},
	["RibbonShock"] = {data=0x35,bit=1},
	["RibbonDowncast"] = {data=0x35,bit=2},
	["RibbonCareless"] = {data=0x35,bit=3},
	["RibbonRelax"] = {data=0x35,bit=4},
	["RibbonSnooze"] = {data=0x35,bit=5},
	["RibbonSmile"] = {data=0x35,bit=6},
	["RibbonGorgeous"] = {data=0x35,bit=7},

	["RibbonRoyal"] = {data=0x36,bit=0},
	["RibbonGorgeousRoyal"] = {data=0x36,bit=1},
	["RibbonArtist"] = {data=0x36,bit=2},
	["RibbonFootprint"] = {data=0x36,bit=3},
	["RibbonRecord"] = {data=0x36,bit=4},
	["RibbonLegend"] = {data=0x36,bit=5},
	["RibbonCountry"] = {data=0x36,bit=6},
	["RibbonNational"] = {data=0x36,bit=7},
               
	["RibbonEarth"] = {data=0x37,bit=0},
	["RibbonWorld"] = {data=0x37,bit=1},
	["RibbonClassic"] = {data=0x37,bit=2},
	["RibbonPremier"] = {data=0x37,bit=3},
	["RibbonEvent"] = {data=0x37,bit=4},
	["RibbonBirthday"] = {data=0x37,bit=5},
	["RibbonSpecial"] = {data=0x37,bit=6},
	["RibbonSouvenir"] = {data=0x37,bit=7},
	
	-- ribbon u32
	["RibbonWishing"] = {data=0x38,bit=0},
	["RibbonChampionBattle"] = {data=0x38,bit=1},
	["RibbonChampionRegional"] = {data=0x38,bit=2},
	["RibbonChampionNational"] = {data=0x38,bit=3},
	["RibbonChampionWorld"] = {data=0x38,bit=4},
	["HasContestMemoryRibbon"] = {data=0x38,bit=5},
	["HasBattleMemoryRibbon"] = {data=0x38,bit=6},
	["RibbonChampionG6Hoenn"] = {data=0x38,bit=7},
               
	["RibbonContestStar"] = {data=0x39,bit=0},
	["RibbonMasterCoolness"] = {data=0x39,bit=1},
	["RibbonMasterBeauty"] = {data=0x39,bit=2},
	["RibbonMasterCuteness"] = {data=0x39,bit=3},
	["RibbonMasterCleverness"] = {data=0x39,bit=4},
	["RibbonMasterToughness"] = {data=0x39,bit=5},
	["RibbonChampionAlola"] = {data=0x39,bit=6},
	["RibbonBattleRoyale"] = {data=0x39,bit=7},
               
	["RibbonBattleTreeGreat"] = {data=0x3A,bit=0},
	["RibbonBattleTreeMaster"] = {data=0x3A,bit=1},
	["RibbonChampionGalar"] = {data=0x3A,bit=2},
	["RibbonTowerMaster"] = {data=0x3A,bit=3},
	["RibbonMasterRank"] = {data=0x3A,bit=4},
	["RibbonMarkLunchtime"] = {data=0x3A,bit=5},
	["RibbonMarkSleepyTime"] = {data=0x3A,bit=6},
	["RibbonMarkDusk"] = {data=0x3A,bit=7},
               
	["RibbonMarkDawn"] = {data=0x3B,bit=0},
	["RibbonMarkCloudy"] = {data=0x3B,bit=1},
	["RibbonMarkRainy"] = {data=0x3B,bit=2},
	["RibbonMarkStormy"] = {data=0x3B,bit=3},
	["RibbonMarkSnowy"] = {data=0x3B,bit=4},
	["RibbonMarkBlizzard"] = {data=0x3B,bit=5},
	["RibbonMarkDry"] = {data=0x3B,bit=6},
	["RibbonMarkSandstorm"] = {data=0x3B,bit=7},
	["RibbonCountMemoryContest"] = {data=0x3C,Specific = function(data,value) data = value ~= 0; return data end},
	["RibbonCountMemoryBattle"] = {data=0x3D,Specific = function(data,value) data = value ~= 0; return data end},
	-- 0x3E padding
	-- 0x3F padding
	
	-- 0x40 Ribbon 1
	["RibbonMarkMisty"]={data=0x40,bit=0},
	["RibbonMarkDestiny"]={data=0x40,bit=1},
	["RibbonMarkFishing"]={data=0x40,bit=2},
	["RibbonMarkCurry"]={data=0x40,bit=3},
	["RibbonMarkUncommon"]={data=0x40,bit=4},
	["RibbonMarkRare"]={data=0x40,bit=5},
	["RibbonMarkRowdy"]={data=0x40,bit=6},
	["RibbonMarkAbsentMinded"]={data=0x40,bit=7},

	["RibbonMarkJittery"] = {data=0x41,bit=0},
	["RibbonMarkExcited"] = {data=0x41,bit=1},
	["RibbonMarkCharismatic"] = {data=0x41,bit=2},
	["RibbonMarkCalmness"] = {data=0x41,bit=3},
	["RibbonMarkIntense"] = {data=0x41,bit=4},
	["RibbonMarkZonedOut"] = {data=0x41,bit=5},
	["RibbonMarkJoyful"] = {data=0x41,bit=6},
	["RibbonMarkAngry"] = {data=0x41,bit=7},

	["RibbonMarkSmiley"] = {data=0x42,bit=0},
	["RibbonMarkTeary"] = {data=0x42,bit=1},
	["RibbonMarkUpbeat"] = {data=0x42,bit=2},
	["RibbonMarkPeeved"] = {data=0x42,bit=3},
	["RibbonMarkIntellectual"] = {data=0x42,bit=4},
	["RibbonMarkFerocious"] = {data=0x42,bit=5},
	["RibbonMarkCrafty"] = {data=0x42,bit=6},
	["RibbonMarkScowling"] = {data=0x42,bit=7},

	["RibbonMarkKindly"] = {data=0x43,bit=0},
	["RibbonMarkFlustered"] = {data=0x43,bit=1},
	["RibbonMarkPumpedUp"] = {data=0x43,bit=2},
	["RibbonMarkZeroEnergy"] = {data=0x43,bit=3},
	["RibbonMarkPrideful"] = {data=0x43,bit=4},
	["RibbonMarkUnsure"] = {data=0x43,bit=5},
	["RibbonMarkHumble"] = {data=0x43,bit=6},
	["RibbonMarkThorny"] = {data=0x43,bit=7},
	-- 0x44 Ribbon 2
	
	["RibbonMarkVigor"] = {data=0x44,bit=0},
	["RibbonMarkSlump"] = {data=0x44,bit=1},
	["RIB44_2"] = {data=0x44,bit=2},
	["RIB44_3"] = {data=0x44,bit=3},
	["RIB44_4"] = {data=0x44,bit=4},
	["RIB44_5"] = {data=0x44,bit=5},
	["RIB44_6"] = {data=0x44,bit=6},
	["RIB44_7"] = {data=0x44,bit=7},

	["RIB45_0"] = {data=0x45,bit=0},
	["RIB45_1"] = {data=0x45,bit=1},
	["RIB45_2"] = {data=0x45,bit=2},
	["RIB45_3"] = {data=0x45,bit=3},
	["RIB45_4"] = {data=0x45,bit=4},
	["RIB45_5"] = {data=0x45,bit=5},
	["RIB45_6"] = {data=0x45,bit=6},
	["RIB45_7"] = {data=0x45,bit=7},

	["RIB46_0"] = {data=0x46,bit=0},
	["RIB46_1"] = {data=0x46,bit=1},
	["RIB46_2"] = {data=0x46,bit=2},
	["RIB46_3"] = {data=0x46,bit=3},
	["RIB46_4"] = {data=0x46,bit=4},
	["RIB46_5"] = {data=0x46,bit=5},
	["RIB46_6"] = {data=0x46,bit=6},
	["RIB46_7"] = {data=0x46,bit=7},

	["RIB47_0"] = {data=0x47,bit=0},
	["RIB47_1"] = {data=0x47,bit=1},
	["RIB47_2"] = {data=0x47,bit=2},
	["RIB47_3"] = {data=0x47,bit=3},
	["RIB47_4"] = {data=0x47,bit=4},
	["RIB47_5"] = {data=0x47,bit=5},
	["RIB47_6"] = {data=0x47,bit=6},
	["RIB47_7"] = {data=0x47,bit=7},
	["RIB47_7"] = {data=0x47,bit=7},
	
	-- I dont really understand why this was at this spot but I will have to change it
	["HasMark"] = {data=0x00, Specific=function(data, value)
		if (mappings[0x3A] & 0xFFE0 ~= 0) or (mappings[0x40] ~= 0) then
			return true
		end
		return (mappings[0x44] & 3) ~= 0	
	end},
	
	["Sociability"] = {data=0x48},
	
	-- 0x4C-0x4F unused
	
	["HeightScalar"] = {data=0x50},
	["WeightScalar"] = {data=0x51},
	
	-- 0x52-0x57 unused
	
	-- endregion
	
	-- region Block B
	["Nickname"] = {data=0x58,Specific=function(data,value) local str = data; return str end},
	
	-- 2 bytes for \0, automatically handled above -- so, we just need to write at most the amount of space between 0x58 and 0x70, so 12 bytes.
	
	["Move1"] = {data=0x72},
	["Move2"] = {data=0x74},
	["Move3"] = {data=0x76},
	["Move4"] = {data=0x78},
	
	["Move1_PP"] = {data=0x7A},
	["Move2_PP"] = {data=0x7B},
	["Move3_PP"] = {data=0x7C},
	["Move4_PP"] = {data=0x7D},
	
	["Move1_PPUps"] = {data=0x7E},
	["Move2_PPUps"] = {data=0x7F},
	["Move3_PPUps"] = {data=0x80},
	["Move4_PPUps"] = {data=0x81},
	
	["RelearnMove1"] = {data=0x82},
	["RelearnMove2"] = {data=0x84},
	["RelearnMove3"] = {data=0x86},
	["RelearnMove4"] = {data=0x88},
	
	["Stat_HPCurrent"] = {data=0x8A},
	
	["IV32"] = {data=0x8C}, -- 32 bits
	["IV_HP"] = {data=0x8C, read=function() return (hex_mappings.IV32.read() >> 00) & 0x1F end, write=function(value) (hex_mappings.IV32.read() & ~(0x1F << 00)) | ((value > 31 and 31 or value) << 00) end},
	["IV_ATK"] = {data=0x8C, read=function() return (hex_mappings.IV32.read() >> 05) & 0x1F end, write=function(value) (hex_mappings.IV32.read() & ~(0x1F << 05)) | ((value > 31 and 31 or value) << 00) end},
	["IV_DEF"] = {data=0x8C, read=function() return (hex_mappings.IV32.read() >> 10) & 0x1F end, write=function(value) (hex_mappings.IV32.read() & ~(0x1F << 10)) | ((value > 31 and 31 or value) << 00) end},
	["IV_SPE"] = {data=0x8C, read=function() return (hex_mappings.IV32.read() >> 15) & 0x1F end, write=function(value) (hex_mappings.IV32.read() & ~(0x1F << 15)) | ((value > 31 and 31 or value) << 00) end},
	["IV_SPA"] = {data=0x8C, read=function() return (hex_mappings.IV32.read() >> 20) & 0x1F end, write=function(value) (hex_mappings.IV32.read() & ~(0x1F << 20)) | ((value > 31 and 31 or value) << 00) end},
	["IV_SPD"] = {data=0x8C, read=function() return (hex_mappings.IV32.read() >> 25) & 0x1F end, write=function(value) (hex_mappings.IV32.read() & ~(0x1F << 25)) | ((value > 31 and 31 or value) << 00) end},
	["IsEgg"] = {data=0x8C, read=function() return ((hex_mappings.IV32.read() >> 30) & 1) == 1 end, write=function(value) (hex_mappings.IV32.read() & ~0x40000000) | ((value > 31 and 31 or value) << 00) end) end},
	["IsNicknamed"] = {data=0x8C, read=function() return ((hex_mappings.IV32.read() >> 31) & 1) == 1 end, write=function(value) (hex_mappings.IV32.read() & 0x7FFFFFFF) | (value and 0x80000000 or 0) end},
	
	["DynamaxLevel"] = {data=0x90},
	
	-- 0x90-0x93 unused
	
	["Status_Condition"] = {data=0x94},
	["Unk98"] = {data=0x98},
	
	-- 0x9C-0xA7 unused
	
	-- endregion
	-- region Block C
	
	["HT_Name"] = {data=0xA8}, -- 12 bytes
	["HT_Gender"] = {data=0xC2},
	["HT_Language"] = {data=0xC3},
	["CurrentHandler"] = {data=0xC4},
	-- 0xC5 unused (alignment)
	["HT_TrainerID"] = {data=0xC6}, -- unused?
	["HT_Friendship"] = {data=0xC8},
	["HT_Intensity"] = {data=0xC9},
	["HT_Memory"] = {data=0xCA},
	["HT_Feeling"] = {data=0xCB},
	["HT_TextVar"] = {data=0xCC},

	-- 0xCE-0xDB unused

	["Fullness"] = {data=0xDC},
	["Enjoyment"] = {data=0xDD},
	["Version"] = {data=0xDE},
	["BattleVersion"] = {data=0xDF},
	-- ["Region"] = {data=0xE0},
	-- ["ConsoleRegion"] = {data=0xE1},
	["Language"] = {data=0xE2},
	["Unk3"] = {data=0xE3},
	["FormArgument"] = {data=0xE4},
	["FormArgumentRemain"] = {data=0xE4},
	["FormArgumentElapsed"] = {data=0xE4},
	["FormArgumentMaximum"] = {data=0xE4},
	["AffixedRibbon"] = {data=0xE4},
	-- remainder unused
	
	-- endregion
	-- region Block D
	["OT_Name"] = {data=0xF8}, -- 12 bytes
	["OT_Friendship"] = {data=0x112},
	["OT_Intensity"] = {data=0x113},
	["OT_Memory"] = {data=0x114},
	-- 0x115 unused align
	["OT_TextVar"] = {data=0x116},
	["OT_Feeling"] = {data=0x118},
	["Egg_Year"] = {data=0x119},
	["Egg_Month"] = {data=0x11A},
	["Egg_Day"] = {data=0x11B},
	["Met_Year"] = {data=0x11C},
	["Met_Month"] = {data=0x11D},
	["Met_Day"] = {data=0x11E},
	-- 0x11F unused align
	["Egg_Location"] = {data=0x120},
	["Met_Location"] = {data=0x122},
	["Ball"] = {data=0x124},
	["Met_Level"] = {data=0x125},
	["OT_Gender"] = {data=0x125},
	["HyperTrainFlags"] = {data=0x126},
	["HT_HP"] = {data=0x126},
	["HT_ATK"] = {data=0x126},
	["HT_DEF"] = {data=0x126},
	["HT_SPA"] = {data=0x126},
	["HT_SPD"] = {data=0x126},
	["HT_SPE"] = {data=0x126},

	["MoveRecordFlag"] = {data=0x127, HasAnyMoveRecordFlag=function()end},

	-- Why did you mis-align this field, GameFreak?
	["Tracker"] = {data=0x135},
	
	-- endregion
	-- region Battle Stats
	["Stat_Level"] = {data=0x148},
	-- 0x149 unused alignment
	["Stat_HPMax"] = {data=0x14A},
	["Stat_ATK"] = {data=0x14C},
	["Stat_DEF"] = {data=0x14E},
	["Stat_SPE"] = {data=0x150},
	["Stat_SPA"] = {data=0x152},
	["Stat_SPD"] = {data=0x154},
	["DynamaxType"] = {data=0x156},
	
	-- endregion
	
	
}
