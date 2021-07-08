--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local fs = require("lib.fs")
--local path = require("lib.path") -- doesnt exist, sad
local Data = require("sim.dex-data")
local ____dex_2Dconditions = require("sim.dex-conditions")
local Condition = ____dex_2Dconditions.Condition
local DexConditions = ____dex_2Dconditions.DexConditions
local ____dex_2Dmoves = require("sim.dex-moves")
local DataMove = ____dex_2Dmoves.DataMove
local DexMoves = ____dex_2Dmoves.DexMoves
local ____dex_2Ditems = require("sim.dex-items")
local Item = ____dex_2Ditems.Item
local DexItems = ____dex_2Ditems.DexItems
local ____dex_2Dabilities = require("sim.dex-abilities")
local Ability = ____dex_2Dabilities.Ability
local DexAbilities = ____dex_2Dabilities.DexAbilities
local ____dex_2Dspecies = require("sim.dex-species")
local Species = ____dex_2Dspecies.Species
local DexSpecies = ____dex_2Dspecies.DexSpecies
local ____dex_2Dformats = require("sim.dex-formats")
local Format = ____dex_2Dformats.Format
local DexFormats = ____dex_2Dformats.DexFormats
local ____lib = require("lib.index")
local Utils = ____lib.Utils
local BASE_MOD = "gen8"
local DATA_DIR = ""-- path:resolve(__dirname, "../.data-dist") -- nah
local MODS_DIR = ""-- path:resolve(__dirname, "../.data-dist/mods")
local dexes = {} -- was Object:create(nil) , what?! just make an empty table!
local DATA_TYPES = {"Abilities", "Rulesets", "FormatsData", "Items", "Learnsets", "Moves", "Natures", "Pokedex", "Scripts", "Conditions", "TypeChart"}
local DATA_FILES = {Abilities = "abilities", Aliases = "aliases", Rulesets = "rulesets", FormatsData = "formats-data", Items = "items", Learnsets = "learnsets", Moves = "moves", Natures = "natures", Pokedex = "pokedex", Scripts = "scripts", Conditions = "conditions", TypeChart = "typechart"}
____exports.toID = Data.toID
____exports.ModdedDex = __TS__Class()
local ModdedDex = ____exports.ModdedDex
ModdedDex.name = "ModdedDex"
function ModdedDex.prototype.____constructor(self, mod)
    if mod == nil then
        mod = "base"
    end
    self.Data = Data
    self.Condition = Condition
    self.Ability = Ability
    self.Item = Item
    self.Move = DataMove
    self.Species = Species
    self.Format = Format
    self.ModdedDex = ____exports.ModdedDex
    self.name = "[ModdedDex]"
    self.toID = Data.toID
    self.gen = 0
    self.parentMod = ""
    self.modsLoaded = false
    self.deepClone = Utils.deepClone
    self.isBase = mod == "base"
    self.currentMod = mod
    self.dataDir = ((self.isBase and (function() return DATA_DIR end)) or (function() return (tostring(MODS_DIR) .. "/") .. tostring(self.currentMod) end))()
    self.dataCache = nil
    self.textCache = nil
    self.formats = __TS__New(DexFormats, self)
    self.abilities = __TS__New(DexAbilities, self)
    self.items = __TS__New(DexItems, self)
    self.moves = __TS__New(DexMoves, self)
    self.species = __TS__New(DexSpecies, self)
    self.conditions = __TS__New(DexConditions, self)
    self.natures = __TS__New(Data.DexNatures, self)
    self.types = __TS__New(Data.DexTypes, self)
    self.stats = __TS__New(Data.DexStats, self)
end
__TS__SetDescriptor(
    ModdedDex.prototype,
    "data",
    {
        get = function(self)
            return self:loadData()
        end
    },
    true
)
__TS__SetDescriptor(
    ModdedDex.prototype,
    "dexes",
    {
        get = function(self)
            self:includeMods()
            return dexes
        end
    },
    true
)
function ModdedDex.prototype.mod(self, mod)
    if not dexes.base.modsLoaded then
        dexes.base:includeMods()
    end
    return dexes[mod or "base"]
end
function ModdedDex.prototype.forGen(self, gen)
    if not gen then
        return self
    end
    return self:mod(
        "gen" .. tostring(gen)
    )
end
function ModdedDex.prototype.forFormat(self, format)
    if not self.modsLoaded then
        self:includeMods()
    end
    local mod = self.formats:get(format).mod
    return dexes[mod or BASE_MOD]:includeData()
end
function ModdedDex.prototype.modData(self, dataType, id)
    if self.isBase then
        return self.data[dataType][id]
    end
    if self.data[dataType][id] ~= dexes[self.parentMod].data[dataType][id] then
        return self.data[dataType][id]
    end
    return (function(o, i, v)
        o[i] = v
        return v
    end)(
        self.data[dataType],
        id,
        Utils:deepClone(self.data[dataType][id])
    )
end
function ModdedDex.prototype.effectToString(self)
    return self.name
end
function ModdedDex.prototype.getName(self, name)
    if (type(name) ~= "string") and (type(name) ~= "number") then
        return ""
    end
    name = __TS__StringTrim(
        __TS__StringReplace(
            "" .. tostring(name),
            nil,
            " "
        )
    )
    if name.length > 18 then
        name = name:substr(0, 18):trim()
    end
    name = name:replace(nil, "")
    name = name:replace(nil, "")
    return name
end
function ModdedDex.prototype.getImmunity(self, source, target)
    local sourceType = (((type(source) ~= "string") and (function() return source.type end)) or (function() return source end))()
    local targetTyping = (target:getTypes() or target.types) or target
    if __TS__ArrayIsArray(targetTyping) then
        for ____, ____type in ipairs(targetTyping) do
            if not self:getImmunity(sourceType, ____type) then
                return false
            end
        end
        return true
    end
    local typeData = self.types:get(targetTyping)
    if typeData and (typeData.damageTaken[sourceType] == 3) then
        return false
    end
    return true
end
function ModdedDex.prototype.getEffectiveness(self, source, target)
    local sourceType = (((type(source) ~= "string") and (function() return source.type end)) or (function() return source end))()
    local targetTyping = (target:getTypes() or target.types) or target
    local totalTypeMod = 0
    if __TS__ArrayIsArray(targetTyping) then
        for ____, ____type in ipairs(targetTyping) do
            totalTypeMod = totalTypeMod + self:getEffectiveness(sourceType, ____type)
        end
        return totalTypeMod
    end
    local typeData = self.types:get(targetTyping)
    if not typeData then
        return 0
    end
    local ____switch28 = typeData.damageTaken[sourceType]
    if ____switch28 == 1 then
        goto ____switch28_case_0
    elseif ____switch28 == 2 then
        goto ____switch28_case_1
    end
    goto ____switch28_case_default
    ::____switch28_case_0::
    do
        return 1
    end
    ::____switch28_case_1::
    do
        return -1
    end
    ::____switch28_case_default::
    do
        return 0
    end
    ::____switch28_end::
end
function ModdedDex.prototype.getDescs(self, ____table, id, dataEntry)
    if dataEntry.shortDesc then
        return {desc = dataEntry.desc, shortDesc = dataEntry.shortDesc}
    end
    local entry = self:loadTextData()[____table][id]
    if not entry then
        return nil
    end
    local descs = {desc = "", shortDesc = ""}
    do
        local i = self.gen
        while i < dexes.base.gen do
            local curDesc = entry["gen" .. tostring(i)].desc
            local curShortDesc = entry["gen" .. tostring(i)].shortDesc
            if (not descs.desc) and curDesc then
                descs.desc = curDesc
            end
            if (not descs.shortDesc) and curShortDesc then
                descs.shortDesc = curShortDesc
            end
            if descs.desc and descs.shortDesc then
                break
            end
            i = i + 1
        end
    end
    if not descs.shortDesc then
        descs.shortDesc = entry.shortDesc or ""
    end
    if not descs.desc then
        descs.desc = entry.desc or descs.shortDesc
    end
    return descs
end
function ModdedDex.prototype.getActiveMove(self, move)
    if move and (type(move.hit) == "number") then
        return move
    end
    move = self.moves:get(move)
    local moveCopy = self:deepClone(move)
    moveCopy.hit = 0
    return moveCopy
end
function ModdedDex.prototype.getHiddenPower(self, ivs)
    local hpTypes = {"Fighting", "Flying", "Poison", "Ground", "Rock", "Bug", "Ghost", "Steel", "Fire", "Water", "Grass", "Electric", "Psychic", "Ice", "Dragon", "Dark"}
    local tr = self.trunc
    local stats = {hp = 31, atk = 31, def = 31, spe = 31, spa = 31, spd = 31}
    if self.gen <= 2 then
        local atkDV = tr(_G, ivs.atk / 2)
        local defDV = tr(_G, ivs.def / 2)
        local speDV = tr(_G, ivs.spe / 2)
        local spcDV = tr(_G, ivs.spa / 2)
        return {
            type = hpTypes[((4 * (atkDV % 4)) + (defDV % 4)) + 1],
            power = tr(
                _G,
                (((5 * (((bit.arshift(spcDV, 3) + (2 * bit.arshift(speDV, 3))) + (4 * bit.arshift(defDV, 3))) + (8 * bit.arshift(atkDV, 3)))) + (spcDV % 4)) / 2) + 31
            )
        }
    else
        local hpTypeX = 0
        local hpPowerX = 0
        local i = 1
        for s in pairs(stats) do
            hpTypeX = hpTypeX + (i * (ivs[s] % 2))
            hpPowerX = hpPowerX + (i * (tr(_G, ivs[s] / 2) % 2))
            i = i * 2
        end
        return {
            type = hpTypes[tr(_G, (hpTypeX * 15) / 63) + 1],
            power = (((self.gen and (self.gen < 6)) and (function() return tr(_G, (hpPowerX * 40) / 63) + 30 end)) or (function() return 60 end))()
        }
    end
end
function ModdedDex.prototype.trunc(self, num, bits)
    if bits == nil then
        bits = 0
    end
    if bits then
        return bit.rshift(num, 0) % (2 ^ bits)
    end
    return bit.rshift(num, 0)
end
function ModdedDex.prototype.dataSearch(self, target, searchIn, isInexact)
    if not target then
        return nil
    end
    searchIn = searchIn or ({"Pokedex", "Moves", "Abilities", "Items", "Natures"})
    local searchObjects = {Pokedex = "species", Moves = "moves", Abilities = "abilities", Items = "items", Natures = "natures"}
    local searchTypes = {Pokedex = "pokemon", Moves = "move", Abilities = "ability", Items = "item", Natures = "nature"}
    local searchResults = {}
    for ____, ____table in ipairs(searchIn) do
        local res = self[searchObjects[____table]]:get(target)
        if res.exists and (res.gen <= self.gen) then
            __TS__ArrayPush(searchResults, {isInexact = isInexact, searchType = searchTypes[____table], name = res.name})
        end
    end
    if #searchResults then
        return searchResults
    end
    if isInexact then
        return nil
    end
    local cmpTarget = ____exports.toID(_G, target)
    local maxLd = 3
    if cmpTarget.length <= 1 then
        return nil
    elseif cmpTarget.length <= 4 then
        maxLd = 1
    elseif cmpTarget.length <= 6 then
        maxLd = 2
    end
    searchResults = nil
    for ____, ____table in ipairs(
        {
            __TS__Unpack(
                __TS__ArrayConcat(
                    {
                        __TS__Unpack(searchIn)
                    },
                    {"Aliases"}
                )
            )
        }
    ) do
        do
            local searchObj = self.data[____table]
            if not searchObj then
                goto __continue55
            end
            for j in pairs(searchObj) do
                local ld = Utils:levenshtein(cmpTarget, j, maxLd)
                if ld <= maxLd then
                    local word = (searchObj[j].name or searchObj[j].species) or j
                    local results = self:dataSearch(word, searchIn, word)
                    if results then
                        searchResults = results
                        maxLd = ld
                    end
                end
            end
        end
        ::__continue55::
    end
    return searchResults
end
function ModdedDex.prototype.loadDataFile(self, basePath, dataType)
    do
        local ____try, e, ____returnValue = pcall(
            function()
                local filePath = tostring(basePath) .. tostring(DATA_FILES[dataType])
                local dataObject = require(_G, filePath)
                if (not dataObject) or (type(dataObject) ~= "table") then
                    error(
                        __TS__New(TypeError, filePath .. ", if it exists, must export a non-null object"),
                        0
                    )
                end
                if dataObject[dataType].constructor.name ~= "Object" then
                    error(
                        __TS__New(TypeError, ((filePath .. ", if it exists, must export an object whose '") .. dataType) .. "' property is an Object"),
                        0
                    )
                end
                return true, dataObject[dataType]
            end
        )
        if not ____try then
            e, ____returnValue = (function()
                if (e.code ~= "MODULE_NOT_FOUND") and (e.code ~= "ENOENT") then
                    error(e, 0)
                end
            end)()
        end
        if e then
            return ____returnValue
        end
    end
    return {}
end
function ModdedDex.prototype.loadTextFile(self, name, exportName)
    return require(
        _G,
        (tostring(DATA_DIR) .. "/text/") .. name
    )[exportName]
end
function ModdedDex.prototype.includeMods(self)
    if not self.isBase then
        error(
            __TS__New(Error, "This must be called on the base Dex"),
            0
        )
    end
    if self.modsLoaded then
        return self
    end
    for ____, mod in __TS__Iterator(
        fs:readdirSync(MODS_DIR)
    ) do
        dexes[mod] = __TS__New(____exports.ModdedDex, mod)
    end
    self.modsLoaded = true
    return self
end
function ModdedDex.prototype.includeModData(self)
    for mod in pairs(self.dexes) do
        dexes[mod]:includeData()
    end
    return self
end
function ModdedDex.prototype.includeData(self)
    self:loadData()
    return self
end
function ModdedDex.prototype.loadTextData(self)
    if dexes.base.textCache then
        return dexes.base.textCache
    end
    dexes.base.textCache = {
        Pokedex = self:loadTextFile("pokedex", "PokedexText"),
        Moves = self:loadTextFile("moves", "MovesText"),
        Abilities = self:loadTextFile("abilities", "AbilitiesText"),
        Items = self:loadTextFile("items", "ItemsText"),
        Default = self:loadTextFile("default", "DefaultText")
    }
    return dexes.base.textCache
end
function ModdedDex.prototype.loadData(self)
    if self.dataCache then
        return self.dataCache
    end
    dexes.base:includeMods()
    local dataCache = {}
    local basePath = tostring(self.dataDir) .. "/"
    local Scripts = self:loadDataFile(basePath, "Scripts")
    self.parentMod = (self.isBase and "") or (Scripts.inherit or "base")
    local parentDex
    if self.parentMod then
        parentDex = dexes[self.parentMod]
        if (not parentDex) or (parentDex == self) then
            error(
                __TS__New(Error, ("Unable to load " .. self.currentMod) .. ". 'inherit' in scripts.ts should specify a parent mod from which to inherit data, or must be not specified."),
                0
            )
        end
    end
    if not parentDex then
        self:includeFormats()
    end
    for ____, dataType in ipairs(
        __TS__ArrayConcat(DATA_TYPES, "Aliases")
    ) do
        local BattleData = self:loadDataFile(basePath, dataType)
        if BattleData ~= dataCache[dataType] then
            dataCache[dataType] = __TS__ObjectAssign(BattleData, dataCache[dataType])
        end
        if (dataType == "Rulesets") and (not parentDex) then
            for ____, format in ipairs(
                self.formats:all()
            ) do
                BattleData[format.id] = __TS__ObjectAssign({}, format, {ruleTable = nil})
            end
        end
    end
    if parentDex then
        for ____, dataType in ipairs(DATA_TYPES) do
            local parentTypedData = parentDex.data[dataType]
            local childTypedData = dataCache[dataType] or (function(o, i, v)
                o[i] = v
                return v
            end)(dataCache, dataType, {})
            for entryId in pairs(parentTypedData) do
                if childTypedData[entryId] == nil then
                    __TS__Delete(childTypedData, entryId)
                elseif not (childTypedData[entryId] ~= nil) then
                    if dataType == "Pokedex" then
                        childTypedData[entryId] = self:deepClone(parentTypedData[entryId])
                    else
                        childTypedData[entryId] = parentTypedData[entryId]
                    end
                elseif childTypedData[entryId] and childTypedData[entryId].inherit then
                    __TS__Delete(childTypedData[entryId], "inherit")
                    for key in pairs(parentTypedData[entryId]) do
                        do
                            if childTypedData[entryId][key] ~= nil then
                                goto __continue94
                            end
                            childTypedData[entryId][key] = parentTypedData[entryId][key]
                        end
                        ::__continue94::
                    end
                end
            end
        end
        dataCache.Aliases = parentDex.data.Aliases
    end
    self.gen = dataCache.Scripts.gen
    if not self.gen then
        error(
            __TS__New(Error, ("Mod " .. self.currentMod) .. " needs a generation number in scripts.js"),
            0
        )
    end
    self.dataCache = dataCache
    if Scripts.init then
        Scripts.init:call(self)
    end
    return self.dataCache
end
function ModdedDex.prototype.includeFormats(self)
    self.formats:load()
    return self
end
dexes.base = __TS__New(____exports.ModdedDex)
dexes[BASE_MOD] = dexes.base
____exports.Dex = dexes.base
____exports.Dex = {}
____exports.default = ____exports.Dex
return ____exports
