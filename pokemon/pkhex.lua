-- One pokemon seems to be 344 bytes.
-- this means we would need a lot of bits, like maybe 30 ints per vanilla pokemon...

local decrypter = 0
local encrypter = 0

local PokemonToMappings = {

}


-- I'm making use of https://github.com/kwsch/PKHeX/blob/master/PKHeX.Core/PKM/PK8.cs
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

local function getPersonalInfo(species, form)
	
end

local function getCheckSum(pokemon)

end

-- I can just infer the amount of bits something has, if they were all used, however, they are not all used.
-- I will use the unused alignment bytes data for this, since we can safely assume we have 8 bits between each value
local hex_mappings = {
	[0x00] = {name="EncryptionConstant"}, -- 32
	[0x04] = {name="Sanity"}, -- 16
	[0x06] = {name="Checksum"}, -- 16
	[0x08] = {name="Species"},
	[0x0A] = {name="HeldItem"},
	[0x0C] = {name="TID"},
	[0x0E] = {name="SID"},
	[0x10] = {name="EXP"},
	[0x14] = {name="Ability"},
	[0x16] = {name="AbilityNumber",Specific=function(data, value) data = data & 7; data = (data & ~7) | (value & 7) ; return data end},
	[0x16] = {name="Favorite",Specific=function(data, value) data = data & 8; data = (data & ~8) | ((value and 1 or 0) << 3) ; return data end},
	[0x16] = {name="CanGigantamax",Specific=function(data, value) data = data & 16; data = (data & ~16) | (value and 16 or 0) ; return data end},
	-- 0x17 alignment unused
	[0x18] = {name="MarkValue"},
	-- 0x1A alignment unused
	-- 0x1B alignment unused
	[0x1C] = {name="PID"},
	[0x20] = {name="Nature"},
	[0x21] = {name="StatNature"},
	[0x22] = {name="FatefulEncounter",Specific=function(data, value) data = (data & 1) == 1; data = (data & ~0x01) | (value and 1 or 0) ; return data end},
	[0x22] = {name="Flag2",Specific=function(data, value) data = (data & 2) == 2; data = (data & ~0x02) | (value and 2 or 0) ; return data end},
	[0x22] = {name="Gender",Specific=function(data, value) data = (data >> 2) & 0x3; data = (data & 0xF3) | (value << 2) ; return data end},
	-- 0x23 alignment unused
	[0x24] = {name="Form"},
	[0x26] = {name="EV_HP"},
	[0x27] = {name="EV_ATK"},
	[0x28] = {name="EV_DEF"},
	[0x29] = {name="EV_SPE"},
	[0x2A] = {name="EV_SPA"},
	[0x2B] = {name="EV_SPD"},
	[0x2C] = {name="CNT_Cool"},
	[0x2D] = {name="CNT_Beauty"},
	[0x2E] = {name="CNT_Cute"},
	[0x2F] = {name="CNT_Smart"},
	[0x30] = {name="CNT_Tough"},
	[0x31] = {name="CNT_Sheen"},
	[0x32] = {name="PKRS"},
	[0x32] = {name="PKRS_Days",Specific=function(data, value) data = data & 0xF; data = (data & ~0xF) | value end},
	[0x32] = {name="PKRS_Strain",Specific=function(data, value) data = data >> 4; data = (data & ~0xF) | value << 4 end},
	-- 0x33 unused padding
}
