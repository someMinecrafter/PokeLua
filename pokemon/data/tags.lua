--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}

____exports.Tags = {
    physical = {
        name = "Physical",
        desc = "Move deals damage with the Attack and Defense stats.",
        moveFilter = function(____, move) return move.category == "Physical" end
    },
    special = {
        name = "Special",
        desc = "Move deals damage with the Special Attack and Special Defense stats.",
        moveFilter = function(____, move) return move.category == "Special" end
    },
    status = {
        name = "Status",
        desc = "Move does not deal damage.",
        moveFilter = function(____, move) return move.category == "Status" end
    },
	
    mega = {
        name = "Mega",
        speciesFilter = function(____, species) return not (not species.isMega) end
    },
    mythical = {
        name = "Mythical",
        speciesFilter = function(____, species) return species.tags:includes("Mythical") end
    },
    sublegendary = {
        name = "Sub-Legendary",
        speciesFilter = function(____, species) return species.tags:includes("Sub-Legendary") end
    },
    restrictedlegendary = {
        name = "Restricted Legendary",
        speciesFilter = function(____, species) return species.tags:includes("Restricted Legendary") end
    },
	
    zmove = {
        name = "Z-Move",
        moveFilter = function(____, move) return not (not move.isZ) end
    },
    maxmove = {
        name = "Max Move",
        moveFilter = function(____, move) return not (not move.isMax) end
    },
	
    contact = {
        name = "Contact",
        desc = "Affected by a variety of moves, abilities, and items. Moves affected by contact moves include: Spiky Shield, King's Shield. Abilities affected by contact moves include: Iron Barbs, Rough Skin, Gooey, Flame Body, Static, Tough Claws. Items affected by contact moves include: Rocky Helmet, Sticky Barb.",
        moveFilter = function(____, move) return move.flags.contact ~= nil end
    },
    sound = {
        name = "Sound",
        desc = "Doesn't affect Soundproof Pokémon. (All sound moves also bypass Substitute.)",
        moveFilter = function(____, move) return move.flags.sound ~= nil end
    },
    powder = {
        name = "Powder",
        desc = "Doesn't affect Grass-type Pokémon, Overcoat Pokémon, or Safety Goggles holders.",
        moveFilter = function(____, move) return move.flags.powder ~= nil end
    },
    fist = {
        name = "Fist",
        desc = "Boosted 1.2x by Iron Fist.",
        moveFilter = function(____, move) return move.flags.punch ~= nil end
    },
    pulse = {
        name = "Pulse",
        desc = "Boosted 1.5x by Mega Launcher.",
        moveFilter = function(____, move) return move.flags.pulse ~= nil end
    },
    bite = {
        name = "Bite",
        desc = "Boosted 1.5x by Strong Jaw.",
        moveFilter = function(____, move) return move.flags.bite ~= nil end
    },
    ballistic = {
        name = "Ballistic",
        desc = "Doesn't affect Bulletproof Pokémon.",
        moveFilter = function(____, move) return move.flags.bullet ~= nil end
    },
    bypassprotect = {
        name = "Bypass Protect",
        desc = "Bypasses Protect, Detect, King's Shield, and Spiky Shield.",
        moveFilter = function(____, move) return (move.target ~= "self") and (not (move.flags.protect ~= nil)) end
    },
    nonreflectable = {
        name = "Nonreflectable",
        desc = "Can't be bounced by Magic Coat or Magic Bounce.",
        moveFilter = function(____, move) return ((move.target ~= "self") and (move.category == "Status")) and (not (move.flags.reflectable ~= nil)) end
    },
    nonmirror = {
        name = "Nonmirror",
        desc = "Can't be copied by Mirror Move.",
        moveFilter = function(____, move) return (move.target ~= "self") and (not (move.flags.mirror ~= nil)) end
    },
    nonsnatchable = {
        name = "Nonsnatchable",
        desc = "Can't be copied by Snatch.",
        moveFilter = function(____, move) return ({"allyTeam", "self", "adjacentAllyOrSelf"}):includes(move.target) and (not (move.flags.snatch ~= nil)) end
    },
    bypasssubstitute = {
        name = "Bypass Substitute",
        desc = "Bypasses but does not break a Substitute.",
        moveFilter = function(____, move) return move.flags.authentic ~= nil end
    },
    gmaxmove = {
        name = "G-Max Move",
        moveFilter = function(____, move) return type(move.isMax) == "string" end
    },
	
    uber = {
        name = "Uber",
        speciesFilter = function(____, species) return ((species.tier == "Uber") or (species.tier == "(Uber)")) or (species.tier == "AG") end
    },
    ou = {
        name = "OU",
        speciesFilter = function(____, species) return (species.tier == "OU") or (species.tier == "(OU)") end
    },
    uubl = {
        name = "UUBL",
        speciesFilter = function(____, species) return species.tier == "UUBL" end
    },
    uu = {
        name = "UU",
        speciesFilter = function(____, species) return species.tier == "UU" end
    },
    rubl = {
        name = "RUBL",
        speciesFilter = function(____, species) return species.tier == "RUBL" end
    },
    ru = {
        name = "RU",
        speciesFilter = function(____, species) return species.tier == "RU" end
    },
    nubl = {
        name = "NUBL",
        speciesFilter = function(____, species) return species.tier == "NUBL" end
    },
    nu = {
        name = "NU",
        speciesFilter = function(____, species) return species.tier == "NU" end
    },
    publ = {
        name = "PUBL",
        speciesFilter = function(____, species) return species.tier == "PUBL" end
    },
    pu = {
        name = "PU",
        speciesFilter = function(____, species) return (species.tier == "PU") or (species.tier == "(NU)") end
    },
    zu = {
        name = "ZU",
        speciesFilter = function(____, species) return species.tier == "(PU)" end
    },
    nfe = {
        name = "NFE",
        speciesFilter = function(____, species) return species.tier == "NFE" end
    },
    lc = {
        name = "LC",
        speciesFilter = function(____, species) return species.doublesTier == "LC" end
    },
    captier = {
        name = "CAP Tier",
        speciesFilter = function(____, species) return species.isNonstandard == "CAP" end
    },
    caplc = {
        name = "CAP LC",
        speciesFilter = function(____, species) return species.tier == "CAP LC" end
    },
    capnfe = {
        name = "CAP NFE",
        speciesFilter = function(____, species) return species.tier == "CAP NFE" end
    },
    ag = {
        name = "AG",
        speciesFilter = function(____, species) return species.tier == "AG" end
    },
    nduubl = {
        name = "ND UUBL",
        speciesFilter = function(____, species) return ({"Aerodactyl-Mega", "Azumarill", "Blacephalon", "Diancie-Mega", "Gallade-Mega", "Gardevoir-Mega", "Gengar", "Gyarados", "Gyarados-Mega", "Hawlucha", "Heracross-Mega", "Hoopa-Unbound", "Hydreigon", "Latias", "Latias-Mega", "Latios", "Latios-Mega", "Manaphy", "Pinsir-Mega", "Sableye-Mega", "Slowbro-Mega", "Thundurus", "Thundurus-Therian", "Venusaur-Mega", "Xurkitree", "Zapdos-Galar"}):includes(species.name) end
    },
    duber = {
        name = "DUber",
        speciesFilter = function(____, species) return (species.doublesTier == "DUber") or (species.doublesTier == "(DUber)") end
    },
    dou = {
        name = "DOU",
        speciesFilter = function(____, species) return species.doublesTier == "DOU" end
    },
    dbl = {
        name = "DBL",
        speciesFilter = function(____, species) return species.doublesTier == "DBL" end
    },
    duu = {
        name = "DUU",
        speciesFilter = function(____, species) return species.doublesTier == "DUU" end
    },
    dnu = {
        name = "DNU",
        speciesFilter = function(____, species) return species.doublesTier == "(DUU)" end
    },
	
    past = {
        name = "Past",
        genericFilter = function(____, thing) return thing.isNonstandard == "Past" end
    },
    future = {
        name = "Future",
        genericFilter = function(____, thing) return thing.isNonstandard == "Future" end
    },
    lgpe = {
        name = "LGPE",
        genericFilter = function(____, thing) return thing.isNonstandard == "LGPE" end
    },
    unobtainable = {
        name = "Unobtainable",
        genericFilter = function(____, thing) return thing.isNonstandard == "Unobtainable" end
    },
    cap = {
        name = "CAP",
        speciesFilter = function(____, thing) return thing.isNonstandard == "CAP" end
    },
    custom = {
        name = "Custom",
        genericFilter = function(____, thing) return thing.isNonstandard == "Custom" end
    },
    nonexistent = {
        name = "Nonexistent",
        genericFilter = function(____, thing) return (not (not thing.isNonstandard)) and (thing.isNonstandard ~= "Unobtainable") end
    },
    introducedgen = {
        name = "Introduced Gen",
        genericNumCol = function(____, thing) return thing.gen end
    },
	
    height = {
        name = "Height",
        speciesNumCol = function(____, species) return species.heightm end
    },
    weight = {
        name = "Weight",
        speciesNumCol = function(____, species) return species.weightkg end
    },
    hp = {
        name = "HP",
        desc = "Hit Points",
        speciesNumCol = function(____, species) return species.baseStats.hp end
    },
    atk = {
        name = "Atk",
        desc = "Attack",
        speciesNumCol = function(____, species) return species.baseStats.atk end
    },
    def = {
        name = "Def",
        desc = "Defense",
        speciesNumCol = function(____, species) return species.baseStats.def end
    },
    spa = {
        name = "SpA",
        desc = "Special Attack",
        speciesNumCol = function(____, species) return species.baseStats.spa end
    },
    spd = {
        name = "SpD",
        desc = "Special Defense",
        speciesNumCol = function(____, species) return species.baseStats.spd end
    },
    spe = {
        name = "Spe",
        desc = "Speed",
        speciesNumCol = function(____, species) return species.baseStats.spe end
    },
    bst = {
        name = "BST",
        desc = "Base Stat Total",
        speciesNumCol = function(____, species) return species.bst end
    },
    basepower = {
        name = "Base Power",
        moveNumCol = function(____, move) return move.basePower end
    },
    priority = {
        name = "Priority",
        moveNumCol = function(____, move) return move.priority end
    },
    accuracy = {
        name = "Accuracy",
        moveNumCol = function(____, move) return ((move.accuracy == true) and 101) or move.accuracy end
    },
    maxpp = {
        name = "Max PP",
        moveNumCol = function(____, move) return move.pp end
    }
}
-- consider separating out the tiers?
return ____exports
