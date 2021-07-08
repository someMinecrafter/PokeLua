--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____dex_2Ddata = require("sim/dex-data")
local toID = ____dex_2Ddata.toID
local BasicEffect = ____dex_2Ddata.BasicEffect
____exports.Species = __TS__Class()
local Species = ____exports.Species
Species.name = "Species"
__TS__ClassExtends(Species, BasicEffect)
function Species.prototype.____constructor(self, data)
    BasicEffect.prototype.____constructor(self, data)
    data = self
    self.fullname = "pokemon: " .. tostring(data.name)
    self.effectType = "Pokemon"
    self.baseSpecies = data.baseSpecies or self.name
    self.forme = data.forme or ""
    self.baseForme = data.baseForme or ""
    self.cosmeticFormes = data.cosmeticFormes or nil
    self.otherFormes = data.otherFormes or nil
    self.formeOrder = data.formeOrder or nil
    self.spriteid = data.spriteid or (tostring(
        toID(_G, self.baseSpecies)
    ) .. tostring(
        (((self.baseSpecies ~= self.name) and (function() return "-" .. tostring(
            toID(_G, self.forme)
        ) end)) or (function() return "" end))()
    ))
    self.abilities = data.abilities or ({[0] = ""})
    self.types = data.types or ({"???"})
    self.addedType = data.addedType or nil
    self.prevo = data.prevo or ""
    self.tier = data.tier or ""
    self.doublesTier = data.doublesTier or ""
    self.evos = data.evos or ({})
    self.evoType = data.evoType or nil
    self.evoMove = data.evoMove or nil
    self.evoLevel = data.evoLevel or nil
    self.nfe = data.nfe or false
    self.eggGroups = data.eggGroups or ({})
    self.canHatch = data.canHatch or false
    self.gender = data.gender or ""
    self.genderRatio = data.genderRatio or (((self.gender == "M") and (function() return {M = 1, F = 0} end)) or (function() return (((self.gender == "F") and (function() return {M = 0, F = 1} end)) or (function() return (((self.gender == "N") and (function() return {M = 0, F = 0} end)) or (function() return {M = 0.5, F = 0.5} end))() end))() end))()
    self.requiredItem = data.requiredItem or nil
    self.requiredItems = self.requiredItems or ((self.requiredItem and (function() return {self.requiredItem} end)) or (function() return nil end))()
    self.baseStats = data.baseStats or ({hp = 0, atk = 0, def = 0, spa = 0, spd = 0, spe = 0})
    self.bst = ((((self.baseStats.hp + self.baseStats.atk) + self.baseStats.def) + self.baseStats.spa) + self.baseStats.spd) + self.baseStats.spe
    self.weightkg = data.weightkg or 0
    self.weighthg = self.weightkg * 10
    self.heightm = data.heightm or 0
    self.color = data.color or ""
    self.tags = data.tags or ({})
    self.unreleasedHidden = data.unreleasedHidden or false
    self.maleOnlyHidden = not (not data.maleOnlyHidden)
    self.maxHP = data.maxHP or nil
    self.isMega = (not (not (self.forme and ({"Mega", "Mega-X", "Mega-Y"}):includes(self.forme)))) or nil
    self.canGigantamax = data.canGigantamax or nil
    self.gmaxUnreleased = not (not data.gmaxUnreleased)
    self.cannotDynamax = not (not data.cannotDynamax)
    self.battleOnly = data.battleOnly or ((self.isMega and (function() return self.baseSpecies end)) or (function() return nil end))()
    self.changesFrom = data.changesFrom or (((self.battleOnly ~= self.baseSpecies) and (function() return self.battleOnly end)) or (function() return self.baseSpecies end))()
    if __TS__ArrayIsArray(data.changesFrom) then
        self.changesFrom = data.changesFrom[0]
    end
    if (not self.gen) and (self.num >= 1) then
        if (self.num >= 810) or ({"Gmax", "Galar", "Galar-Zen"}):includes(self.forme) then
            self.gen = 8
        elseif ((self.num >= 722) or self.forme:startsWith("Alola")) or (self.forme == "Starter") then
            self.gen = 7
        elseif self.forme == "Primal" then
            self.gen = 6
            self.isPrimal = true
            self.battleOnly = self.baseSpecies
        elseif (self.num >= 650) or self.isMega then
            self.gen = 6
        elseif self.num >= 494 then
            self.gen = 5
        elseif self.num >= 387 then
            self.gen = 4
        elseif self.num >= 252 then
            self.gen = 3
        elseif self.num >= 152 then
            self.gen = 2
        else
            self.gen = 1
        end
    end
end
____exports.Learnset = __TS__Class()
local Learnset = ____exports.Learnset
Learnset.name = "Learnset"
function Learnset.prototype.____constructor(self, data)
    self.exists = true
    self.effectType = "Learnset"
    self.learnset = data.learnset or nil
    self.eventOnly = not (not data.eventOnly)
    self.eventData = data.eventData or nil
    self.encounters = data.encounters or nil
end
____exports.DexSpecies = __TS__Class()
local DexSpecies = ____exports.DexSpecies
DexSpecies.name = "DexSpecies"
function DexSpecies.prototype.____constructor(self, dex)
    self.speciesCache = __TS__New(Map)
    self.learnsetCache = __TS__New(Map)
    self.allCache = nil
    self.dex = dex
end
function DexSpecies.prototype.get(self, name)
    if name and (type(name) ~= "string") then
        return name
    end
    name = (name or ""):trim()
    local id = toID(_G, name)
    if (id == "nidoran") and name:endsWith("♀") then
        id = "nidoranf"
    elseif (id == "nidoran") and name:endsWith("♂") then
        id = "nidoranm"
    end
    return self:getByID(id)
end
function DexSpecies.prototype.getByID(self, id)
    local species = self.speciesCache:get(id)
    if species then
        return species
    end
    if rawget(self.dex.data.Aliases, id) ~= nil then
        if rawget(self.dex.data.FormatsData, id) ~= nil then
            local baseId = toID(_G, self.dex.data.Aliases[id])
            species = __TS__New(
                ____exports.Species,
                __TS__ObjectAssign({}, self.dex.data.Pokedex[baseId], self.dex.data.FormatsData[id], {name = id})
            )
            species.abilities = {[0] = species.abilities.S}
        else
            species = self:get(self.dex.data.Aliases[id])
            if species.cosmeticFormes then
                for ____, forme in __TS__Iterator(species.cosmeticFormes) do
                    if toID(_G, forme) == id then
                        species = __TS__New(
                            ____exports.Species,
                            __TS__ObjectAssign(
                                {},
                                species,
                                {
                                    name = forme,
                                    forme = forme:slice(species.name.length + 1),
                                    baseForme = "",
                                    baseSpecies = species.name,
                                    otherFormes = nil,
                                    cosmeticFormes = nil
                                }
                            )
                        )
                        break
                    end
                end
            end
        end
        self.speciesCache:set(id, species)
        return species
    end
    if not (rawget(self.dex.data.Pokedex, id) ~= nil) then
        local aliasTo = ""
        local formeNames = {alola = {"a", "alola", "alolan"}, galar = {"g", "galar", "galarian"}, mega = {"m", "mega"}, primal = {"p", "primal"}}
        for forme in pairs(formeNames) do
            local pokeName = ""
            for ____, i in ipairs(formeNames[forme]) do
                if id:startsWith(i) then
                    pokeName = id:slice(#i)
                elseif id:endsWith(i) then
                    pokeName = id:slice(0, -#i)
                end
            end
            if rawget(self.dex.data.Aliases, pokeName) ~= nil then
                pokeName = toID(_G, self.dex.data.Aliases[pokeName])
            end
            if self.dex.data.Pokedex[tostring(pokeName) .. tostring(forme)] then
                aliasTo = tostring(pokeName) .. tostring(forme)
                break
            end
        end
        if aliasTo then
            species = self:get(aliasTo)
            if species.exists then
                self.speciesCache:set(id, species)
                return species
            end
        end
    end
    if id and (rawget(self.dex.data.Pokedex, id) ~= nil) then
        local pokedexData = self.dex.data.Pokedex[id]
        local baseSpeciesTags = pokedexData.baseSpecies and self.dex.data.Pokedex[toID(_G, pokedexData.baseSpecies)].tags
        species = __TS__New(
            ____exports.Species,
            __TS__ObjectAssign({tags = baseSpeciesTags}, pokedexData, self.dex.data.FormatsData[id])
        )
        local baseSpeciesStatuses = self.dex.data.Conditions[toID(_G, species.baseSpecies)]
        if baseSpeciesStatuses ~= nil then
            local key
            for ____value in pairs(baseSpeciesStatuses) do
                key = ____value
                if not (species[key] ~= nil) then
                    species[key] = baseSpeciesStatuses[key]
                end
            end
        end
        if ((not species.tier) and (not species.doublesTier)) and (species.baseSpecies ~= species.name) then
            if species.baseSpecies == "Mimikyu" then
                species.tier = self.dex.data.FormatsData[toID(_G, species.baseSpecies)].tier or "Illegal"
                species.doublesTier = self.dex.data.FormatsData[toID(_G, species.baseSpecies)].doublesTier or "Illegal"
            elseif species.id:endsWith("totem") then
                species.tier = self.dex.data.FormatsData[species.id:slice(0, -5)].tier or "Illegal"
                species.doublesTier = self.dex.data.FormatsData[species.id:slice(0, -5)].doublesTier or "Illegal"
            elseif species.battleOnly then
                species.tier = self.dex.data.FormatsData[toID(_G, species.battleOnly)].tier or "Illegal"
                species.doublesTier = self.dex.data.FormatsData[toID(_G, species.battleOnly)].doublesTier or "Illegal"
            else
                local baseFormatsData = self.dex.data.FormatsData[toID(_G, species.baseSpecies)]
                if not baseFormatsData then
                    error(
                        __TS__New(
                            Error,
                            tostring(species.baseSpecies) .. " has no formats-data entry"
                        ),
                        0
                    )
                end
                species.tier = baseFormatsData.tier or "Illegal"
                species.doublesTier = baseFormatsData.doublesTier or "Illegal"
            end
        end
        if not species.tier then
            species.tier = "Illegal"
        end
        if not species.doublesTier then
            species.doublesTier = species.tier
        end
        if species.gen > self.dex.gen then
            species.tier = "Illegal"
            species.doublesTier = "Illegal"
            species.isNonstandard = "Future"
        end
        if (self.dex.currentMod == "gen7letsgo") and (not species.isNonstandard) then
            local isLetsGo = ((species.num <= 151) or ({"Meltan", "Melmetal"}):includes(species.name)) and ((not species.forme) or ({"Alola", "Mega", "Mega-X", "Mega-Y", "Starter"}):includes(species.forme))
            if not isLetsGo then
                species.isNonstandard = "Past"
            end
        end
        species.nfe = not (not (species.evos.length and (self:get(species.evos[0]).gen <= self.dex.gen)))
        species.canHatch = species.canHatch or (((not ({"Ditto", "Undiscovered"}):includes(species.eggGroups[0])) and (not species.prevo)) and (species.name ~= "Manaphy"))
        if self.dex.gen == 1 then
            species.bst = species.bst - species.baseStats.spd
        end
        if self.dex.gen < 5 then
            __TS__Delete(species.abilities, "H")
        end
    else
        species = __TS__New(____exports.Species, {id = id, name = id, exists = false, tier = "Illegal", doublesTier = "Illegal", isNonstandard = "Custom"})
    end
    if species.exists then
        self.speciesCache:set(id, species)
    end
    return species
end
function DexSpecies.prototype.getLearnset(self, id)
    return self:getLearnsetData(id).learnset
end
function DexSpecies.prototype.getLearnsetData(self, id)
    local learnsetData = self.learnsetCache:get(id)
    if learnsetData then
        return learnsetData
    end
    if not (rawget(self.dex.data.Learnsets, id) ~= nil) then
        return __TS__New(____exports.Learnset, {exists = false})
    end
    learnsetData = __TS__New(____exports.Learnset, self.dex.data.Learnsets[id])
    self.learnsetCache:set(id, learnsetData)
    return learnsetData
end
function DexSpecies.prototype.all(self)
    if self.allCache then
        return self.allCache
    end
    local species = {}
    for id in pairs(self.dex.data.Pokedex) do
        __TS__ArrayPush(
            species,
            self:getByID(id)
        )
    end
    self.allCache = species
    return self.allCache
end
return ____exports
