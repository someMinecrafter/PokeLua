-- One pokemon seems to be 344 bytes.
-- this means we would need a lot of bits, like maybe 30 ints per vanilla pokemon...
-- serializer/deserializer
local decrypter = 0
local encrypter = 0

local PokemonToMappings = {

}



local function getPersonalInfo(species, form)
	
end

local function getCheckSum(pokemon)

end

local Blob = require("pkhex.Blob") -- lua requires from wherever shell was called

local pk8 = Blob.load("testpokemon.pk8")

-- lazy for now, can change later if even needed but this will probably be the only file io, otherwise I'll probably just do copy/paste json since this format has actual community support.
local function writeBinary(file, data)
	
end

local function readBinary(file)
	local data
	return data
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
local function lazySort(t)
	local data_checked = {}
	local key_checked = {}
	local indexed = {}
	local smallest = 9999
	local key
	for k,v in pairs(t) do
		smallest = 9999
		for a,b in pairs(t) do
			-- have we checked the key before?
			if not key_checked[a] then
				-- have we checked the data before?
				if not data_checked[b.data] then
					-- if we haven't, is this the smallest one available?
					if b.data <= smallest then
						smallest = b.data
						key = a
					end
					
				-- if we have, is the current value of a equal to the most recent index.data?
				elseif indexed[#indexed].data == b.data then
					-- if this is true, are we selecting the smallest a?
					if b.data <= smallest then
						smallest = b.data
						key = a
					end
				end
			end
			--[[
			if #indexed > 0 and indexed[#indexed].data == a then
				key = b
			end
			if not checked[a] then
				if a < smallest then
					smallest = a
					key = b
				end
			end
			--]]
		end
		if smallest ~= 9999 then
			data_checked[smallest] = true
			key_checked[key] = true
			indexed[#indexed+1] = {data=smallest,key=key}
		end
		--print(key)
	end
	return indexed
end

local function calculateAndAddLengthToHex_Mappings(hex_mappings, unused)
	local sorted_by_data = {}
	local current_data, previous_data = 0, 0
	for k,v in pairs(hex_mappings) do
		previous_data = current_data
		current_data = v.data
		sorted_by_data[current_data] = k -- swaps data and other thing, we dont really care too much about the key.
	end
	local current_data, previous_data = 0, 0
	for k,v in pairs(unused) do
		previous_data = current_data
		current_data = v
		sorted_by_data[current_data] = string.format("Unused_%s", v)
	end
	
	local current_data, previous_data
	for k,v in pairs(sorted_by_data) do
		if not current_data then
			previous_data = k
			--print(k)
		end
		previous_data = current_data
		current_data = k
		if not hex_mappings[v] then
			--print(k)
			hex_mappings[v] = {data=k}
		end
	end
	
	local list_of_data = lazySort(hex_mappings)
	list_of_data[#list_of_data+1] = {data=list_of_data[#list_of_data].data + 2} -- we need to end it somewhere, so on what byte do we end it?
	
	-- figure out data_size
	local current_data, previous_data
	for k,v in ipairs(list_of_data) do
		if k < #list_of_data then
			hex_mappings[v.key].data_size = list_of_data[k+1].data - v.data -- we now know the size of our things
			--print(hex_mappings[v.key].data_size)
		end
	end
	
	-- im lazy, lets just manually add the first one, and also iv32
	hex_mappings.EncryptionConstant.data_size = 0x4
	hex_mappings.IV32.data_size = 0x4
end

local isBoolean = {[true] = true, [false] = true}
-- todo: rename data to address?, makes more sense sort of
-- todo: replace pk8 with something so I can just freely read/write to something bla bla its 6 am
local function addStandardReadAndWriteToUndefinedEntries(hex_mappings)
	for k,v in pairs(hex_mappings) do
		if v.bit then -- or data_size = 0 if i wrote a more complex function above, but im lazy so im only gonna check v.bit and pray i dont forget something
			v.read = function(specific_bit)
				if specific_bit then
					pk8:seek(v.data)
					return pk8:bits(1,15-specific_bit) -- 0 to 7
				else
					pk8:seek(v.data) -- seek to byte at this index
					return pk8:bits(1,15-v.bit) -- read the following (1) bits offset by v.bit'
				end
			end
		elseif not v.specific_read then
			v.read = function(asNumber)
				pk8:seek(v.data) -- seek to byte at this index
				return pk8:bytes(v.data_size > 26 and 24 or v.data_size) -- read the following v.data_size bytes, unless we are reading a string in which case it has two termination bytes which should be ZEROed (does lua even read them in? might be an unneeded check for reading specifically.)
			end
		else
			v.read = function()
				pk8:seek(v.data+1)
				return v.specific_read(pk8:bytes(1))
			end
		end
		v.write = function(data)
			-- uhhhh?????
			pk8:seek(v.data) -- seek to byte at this index
			if v.bit and isBoolean[data] then
				local bits = 0x100 -- we just create an integer
				 -- 10101111
				local x = 0
				for i = 0, 7 do
					bits = bits >> 1 -- shift it left once every loop

					if v.bit == i then
						bits = bits | (data and 0x100 or 0)
					else
						bits = bits | (v.read(i) and 0x100 or 0)
					end
					--print(7 - i, data, bits)
				end
				
				bits = bits >> 1 --remove lsb since we started at 0x100
				--print(bits)
				pk8:write( string.char(bits), v.data+1, 0 )
			elseif v.specific_write and tonumber(data) and 0x100 > data then
				local hex_data = string.format("%02x", data)
				pk8:write( string.char( tonumber( hex_data ) ), v.data+1, v.data_size ) --why do i need to offset this by 1? I do not at all understand
			elseif tonumber(data) and 0x100 ^ v.data_size > data then -- for normal data, align to bytes, for strings, remove termination bytes and divide by two (each char is 0x0000-0xFFFF, but lua wants each char to be 0x00-0xFF normally. Use utf8. builtin?) -- and data/(8*v.data_size) <= v.data_size
				local hex_data = string.format("%0" .. string.format("%sx", v.data_size > 0 and v.data_size + v.data_size or 2), data)
				local padded_data = ""
				for i = 1, hex_data:len() / 2 do
					padded_data = padded_data .. string.char(tonumber("0x" .. hex_data:sub(
						(i-1)*2  +1,
						(i-1)*2  +2
					)))
				end
				--[[
				local padding = ""
				if v.data_size > 1 then-- if the data should have a size greater than one byte, but does not 
					padding = ( (" "):rep( v.data_size - math.ceil(data / 0x100) ) )
				end
				--]]
				local padded_string = padded_data -- padding ..
				pk8:write( padded_string, v.data, v.data_size )
			elseif tostring(data):len() < (v.data_size - 2) / 2 then
				local padded_string = data:gsub(".", string.char(0x00) .. "%1") -- add space before each character
				--print(padded_string)
				pk8:write( padded_string, v.data, v.data_size ) -- write the data here, but only up to data_size (Todo!)
			else
				print("What are you doing this is not correct?", data)
			end 
		end
		if v.specific_write then
			v._write = v.write
			v.write = function(data)
				v.specific_write(v._write, v.read(), data)
			end
		end
	end
end

local function getValueAt(seek_pos, data_size)
	pk8:seek(seek_pos)
	return pk8:bytes(data_size)
end

local SIZE_8BLOCK = 80 -- 0x50
local SIZE_8STORED = 8 + (4 * SIZE_8BLOCK) -- 0x148
local SIZE_8PARTY = SIZE_8STORED + 0x10 -- 0x158

local function calculateChecksum()
	local chk = 0
	local x = 8
	for i = x, SIZE_8STORED do
		if x < SIZE_8STORED then
			local num = getValueAt(x,2)
			num = (num:sub(1,1):byte() * 0x100) + num:sub(2,2):byte()
			if chk + num > 0xFFFF then -- pretend ushort
				chk = tonumber("0x" .. string.format("%X",chk+num):sub(-4))
			else
				chk = chk + num
			end
			x = x + 2
		end
	end
	if chk >= 0x100 ^ 2 then
		chk = chk -- remove everything larger than 0xFFFF
	end
	return chk
end

print(string.format("%X",calculateChecksum()))

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
	["AbilityNumber"] = {data=0x16,
		specific_read = function(r)
			return (r:byte() & 0x7)
		end,
		specific_write = function(fw, r, data)
			fw( (r & ~0x7) | (data & 0x7) )
		end
	},
	
	-- the specific functions with ternary operators may need adjustments
	
	["Favorite"] = {data=0x16, -- unused, was in LGPE but not in SWSH
		specific_read = function(r)
			return (r:byte() & 8) ~= 0
		end,
		specific_write = function(fw, r, data)
			fw( ((r and 1 or 0) & ~0x8) | ((data and 1 or 0) << 3) )
		end
	},
	["CanGigantamax"] = {data=0x16,
		specific_read = function(r)
			return r:byte() & 16
		end,
		specific_write = function(fw, r, data)
			fw( (r & ~16) | (data and 16 or 0) )
		end
	},
	-- 0x17 alignment unused
	["MarkValue"] = {data=0x18},
	-- 0x1A alignment unused
	-- 0x1B alignment unused
	["PID"] = {data=0x1C},
	["Nature"] = {data=0x20},
	["StatNature"] = {data=0x21},
	["FatefulEncounter"] = {data=0x22,
		specific_read = function(r)
			return (r:byte() & 1) == 1
		end,
		specific_write = function(fw, r, data)
			fw( ((r and 1 or 0) & ~0x01) | (data and 1 or 0) )
		end
	},
	["Flag2"] = {data=0x22,
		specific_read = function(r)
			return (r:byte() & 2) == 2
		end,
		specific_write = function(fw, r, data)
			fw( ((r and 1 or 0) & ~0x02) | (data and 2 or 0) )
		end
	},
	["Gender"] = {data=0x22,
		specific_read = function(r)
			return (r:byte() >> 2) & 0x3
		end,
		specific_write = function(fw, r, data)
			fw( (r & 0xF3) | (data << 2) )
		end
	},
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
	["PKRS_Days"] = {data=0x32,
		specific_read = function(r)
			return r:byte() & 0xF
		end,
		specific_write = function(fw, r, data)
			fw( (r & ~0xF) | data )
		end
	},
	["PKRS_Strain"] = {data=0x32,
		specific_read = function(r)
			return r:byte() >> 4
		end,
		specific_write = function(fw, r, data)
			fw( (r & ~0xF) | data << 4 )
		end
	},
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
	["RibbonCountMemoryContest"] = {data=0x3C}, -- TODO: HasMemoryContestRibbon (r:byte() ~= 0)
	["RibbonCountMemoryBattle"] = {data=0x3D}, -- TODO: HasBattleMemoryRibbon (r:byte() ~= 0)
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
	
	["Sociability"] = {data=0x48},
	
	-- 0x4C-0x4F unused
	
	["HeightScalar"] = {data=0x50},
	["WeightScalar"] = {data=0x51},
	
	-- 0x52-0x57 unused
	
	-- endregion
	
	-- region Block B
	["Nickname"] = {data=0x58},
	
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
	
	["IV32"] = {
		data=0x8C,
		specific_read = function()
			pk8:seek(hex_mappings.IV32.data+1)
			local str = pk8:bytes(hex_mappings.IV32.data_size)
			local num = ""
			for i = 1, str:len() do
				num = num .. string.format("%X",str:sub(str:len()-i+1,str:len()-i+1):byte()) -- alternatively: num = (num * 0x100 ) | str:sub(i,i):byte()
			end
			num = "0x" .. num
			return tonumber(num)
		end,
		specific_write = function(_,_,data)
			pk8:seek(hex_mappings.IV32.data)
			
			local hex_data = string.format("%0" .. string.format("%sx", hex_mappings.IV32.data_size > 0 and hex_mappings.IV32.data_size + hex_mappings.IV32.data_size or 2), data)

			local reversed = ""
			for i = 1, hex_data:len() / 2 do
				reversed = reversed .. hex_data:sub(
					(math.floor(hex_data:len()/2)-i)*2  +1,
					(math.floor(hex_data:len()/2)-i)*2  +2
				)
			end
			hex_data = reversed
			print(hex_data)
			local padded_data = ""
			for i = 1, hex_data:len() / 2 do
				padded_data = padded_data .. string.char(tonumber("0x" .. hex_data:sub(
					(i-1)*2  +1,
					(i-1)*2  +2
				)))
			end
			--[[
			local padding = ""
			if v.data_size > 1 then-- if the data should have a size greater than one byte, but does not 
				padding = ( (" "):rep( v.data_size - math.ceil(data / 0x100) ) )
			end
			--]]
			local padded_string = padded_data -- padding ..
			print("asd")
			print(hex_mappings.IV32.data_size)
			pk8:write( padded_string, hex_mappings.IV32.data+1, hex_mappings.IV32.data_size-1 )
		end
	}, -- 32 bits
	-- todo: use hex_mappings.IV32.write() here, tired do this when im not tired
	
	-- 5 bits is 2^5 = 32
	["IV_HP"] = {
		data=0x8C,
		specific_read = function()
			return (hex_mappings.IV32.read(true) >> 00) & 0x1F
		end,
		specific_write = function(_,_,data)
			hex_mappings.IV32.write(
				(hex_mappings.IV32.read(true) & ~(0x1F << 00)) | ((data > 31 and 31 or data) << 00)
			)
		end
	},
	["IV_ATK"] = {data=0x8C,
		specific_read = function()
			return (hex_mappings.IV32.read(true) >> 05) & 0x1F
		end,
		specific_write = function(_,_,data)
			hex_mappings.IV32.write((hex_mappings.IV32.read(true) & ~(0x1F << 05)) | ((data > 31 and 31 or data) << 05))
		end
	},
	["IV_DEF"] = {data=0x8C,
		specific_read=function()
			return (hex_mappings.IV32.read(true) >> 10) & 0x1F
		end,
		specific_write=function(_,_,data)
			hex_mappings.IV32.write((hex_mappings.IV32.read(true) & ~(0x1F << 10)) | ((data > 31 and 31 or data) << 10))
		end
	},
	["IV_SPE"] = {data=0x8C,
		specific_read=function()
			return (hex_mappings.IV32.read(true) >> 15) & 0x1F
		end,
		specific_write=function(_,_,data)
			hex_mappings.IV32.write((hex_mappings.IV32.read(true) & ~(0x1F << 15)) | ((data > 31 and 31 or data) << 15))
		end
	},
	["IV_SPA"] = {data=0x8C,
		specific_read=function()
			return (hex_mappings.IV32.read(true) >> 20) & 0x1F
		end,
		specific_write=function(_,_,data)
			hex_mappings.IV32.write((hex_mappings.IV32.read(true) & ~(0x1F << 20)) | ((data > 31 and 31 or data) << 20))
		end
	},
	["IV_SPD"] = {data=0x8C,
		specific_read=function()
			return (hex_mappings.IV32.read(true) >> 25) & 0x1F
		end,
		specific_write=function(_,_,data)
			hex_mappings.IV32.write((hex_mappings.IV32.read(true) & ~(0x1F << 25)) | ((data > 31 and 31 or data) << 25))
		end
	},
	["IsEgg"] = {data=0x8C,
		specific_read=function()
			return ((hex_mappings.IV32.read(true) >> 30) & 1) == 1
		end,
		specific_write=function(_,_,data)
			hex_mappings.IV32.write((hex_mappings.IV32.read(true) & ~0x40000000) | (data and 0x40000000 or 0))
		end
	},
	["IsNicknamed"] = {data=0x8C,
		specific_read=function()
			return ((hex_mappings.IV32.read(true) >> 31) & 1) == 1
		end,
		specific_write=function(_,_,data)
			hex_mappings.IV32.write((hex_mappings.IV32.read(true) & 0x7FFFFFFF) | ( data and 0x80000000 or 0))
		end
	},
	
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

	["MoveRecordFlag"] = {data=0x127}, -- HasAnyMoveRecordFlag

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

calculateAndAddLengthToHex_Mappings(hex_mappings, unused)

--lazySort(hex_mappings)

addStandardReadAndWriteToUndefinedEntries(hex_mappings)


local hex_mappings_helper_functions = {
	-- I dont really understand why this was at this spot but I will have to change it
	["HasMark"] = {data=0x00,
		read = function()
			local a = getValueAt(0x3A,2)
			local b = getValueAt(0x40,4)
			
			local a_total = 0
			for i = 1, a:len() do
				a_total = ( a_total * 0x100 ) | a:sub(i,i):byte()
			end
			
			if a_total & 0xFFE0 ~= 0 then
				return true
			end
			
			for i = 1, b:len() do
				if b:sub(i,i):byte() ~= 0 then
					return true
				end
			end

			return (getValueAt(0x44,1):byte() & 3) ~= 0	
		end
	},
	["HasMemoryContestRibbon"] = {data=0x3C,
		read = function(r)
			return hex_mappings.RibbonCountMemoryContest.read():byte() ~= 0
		end
	},
	["HasBattleMemoryRibbon"] = {data=0x3D,
		read = function()
			return hex_mappings.RibbonCountMemoryBattle.read():byte() ~= 0
		end
	},
	["HasAnyMoveRecordFlag"] = {data=0x127,
		read = function()
			return hex_mappings.MoveRecordFlag.read():byte() ~= 0
		end
	},
}

-- add helper functions
for k,v in pairs(hex_mappings_helper_functions) do
	hex_mappings[k] = v
end

print(pk8.buffer:len())

print("Testing read function: OT_Name")
print(hex_mappings.OT_Name.read())

print("Testing write function: OT_Name")
hex_mappings.OT_Name.write("Testing")

print("Testing read function: OT_Name")
print(hex_mappings.OT_Name.read())
print("Testing read function: Nickname")
print(hex_mappings.Nickname.read())

print("Testing read function: Stat_HPMax") -- ok this thing is 2 bytes, how will this print?: badly. Lua reads one char as 0x00-0xFF instead of 0x0000-0xFFFF. How to fix? We try to read it as one number, starting with 0x00XX?
print(hex_mappings.Stat_HPMax.read())

print("Testing write+read function: Stat_HPMax")
hex_mappings.Stat_HPMax.write(0x11F5) -- upercase C, but thats whatever really
print(hex_mappings.Stat_HPMax.read():sub(1,1):byte())
print(hex_mappings.Stat_HPMax.read():sub(2,2):byte())
print(hex_mappings.Stat_HPMax.read())

print("Testing write+read function: EncryptionConstant")
hex_mappings.EncryptionConstant.write(0x41424344) --ABCD

print(hex_mappings.EncryptionConstant.read():sub(1,1):byte())
print(hex_mappings.EncryptionConstant.read():sub(2,2):byte())
print(hex_mappings.EncryptionConstant.read():sub(3,3):byte())
print(hex_mappings.EncryptionConstant.read():sub(4,4):byte())

print("Testing read function: Ribbons")
print(hex_mappings.RibbonMarkDawn.read())
print(hex_mappings.RibbonMarkRainy.read())
print(hex_mappings.RibbonMarkStormy.read()) -- all true ^
print(hex_mappings.RibbonMarkSandstorm.read()) -- false
print("Testing read function: Ribbons")
print(hex_mappings.RibbonMarkDawn.read())
print(hex_mappings.RibbonMarkCloudy.read())
print(hex_mappings.RibbonMarkRainy.read())
print(hex_mappings.RibbonMarkStormy.read())
print(hex_mappings.RibbonMarkSnowy.read())
print(hex_mappings.RibbonMarkBlizzard.read())
print(hex_mappings.RibbonMarkDry.read())
print(hex_mappings.RibbonMarkSandstorm.read())
print("Testing write+read function: Ribbons")
hex_mappings.RibbonMarkDawn.write(true) -- 10101111
hex_mappings.RibbonMarkCloudy.write(false)
hex_mappings.RibbonMarkRainy.write(true)
hex_mappings.RibbonMarkStormy.write(false)
hex_mappings.RibbonMarkSnowy.write(true)
hex_mappings.RibbonMarkBlizzard.write(true)
hex_mappings.RibbonMarkDry.write(true)
hex_mappings.RibbonMarkSandstorm.write(true)
print(hex_mappings.RibbonMarkDawn.read())
print(hex_mappings.RibbonMarkCloudy.read())
print(hex_mappings.RibbonMarkRainy.read())
print(hex_mappings.RibbonMarkStormy.read())
print(hex_mappings.RibbonMarkSnowy.read())
print(hex_mappings.RibbonMarkBlizzard.read())
print(hex_mappings.RibbonMarkDry.read())
print(hex_mappings.RibbonMarkSandstorm.read())
hex_mappings.RibbonMarkDawn.write(false) -- 10101111
hex_mappings.RibbonMarkCloudy.write(false)
hex_mappings.RibbonMarkRainy.write(false)
hex_mappings.RibbonMarkStormy.write(false)
hex_mappings.RibbonMarkSnowy.write(false)
hex_mappings.RibbonMarkBlizzard.write(false)
hex_mappings.RibbonMarkDry.write(false)
hex_mappings.RibbonMarkSandstorm.write(false)

print("Testing read function: AbilityNumber")
print(tostring( hex_mappings.AbilityNumber.read() ))
print("Testing write function: AbilityNumber")
hex_mappings.AbilityNumber.write(2)
print("Testing read function: AbilityNumber")
print(tostring( hex_mappings.AbilityNumber.read() ))

print("Testing read function: Gender")
print(tostring( hex_mappings.Gender.read() ))
print("Testing write function: Gender")
hex_mappings.Gender.write(0x0)
print("Testing read function: Gender")
print(tostring( hex_mappings.Gender.read() ))


print("Testing read function: IV_*")
print(tostring(hex_mappings.IV32.read()))
print(tostring( hex_mappings.IV_HP.read() ))
print(tostring( hex_mappings.IV_ATK.read() ))
print(tostring( hex_mappings.IV_DEF.read() ))
print(tostring( hex_mappings.IV_SPE.read() ))
print(tostring( hex_mappings.IV_SPA.read() ))
print(tostring( hex_mappings.IV_SPD.read() ))

hex_mappings.IV_SPD.write(14)
print(tostring( hex_mappings.IV_SPD.read() ))



hex_mappings.Favorite.write(1)

print("Testing HasMark")
hex_mappings.RibbonMarkJittery.write(false)
print(hex_mappings.HasMark.read())
print("Testing HasMark after writing a mark")
hex_mappings.RibbonMarkJittery.write(true)
print(hex_mappings.HasMark.read()) -- it works!

--[[ checksums borked, at least writing it is
print("Testing checksum read")
print(tostring(hex_mappings.Checksum.read()))

print("Testing checksum calculation")
print(calculateChecksum())

print("Testing checksum write")
hex_mappings.Checksum.write(calculateChecksum())

print("Testing checksum read")
print(tostring(hex_mappings.Checksum.read()))
--]]

print(pk8.buffer:len())
pk8:save()
--[[
Testing read function: OT_Name
 G r e e n     a r 7   n
Testing read function: Nickname
 S y l v e o n
--]]