--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____dex_2Ddata = require("sim/dex-data")
local BasicEffect = ____dex_2Ddata.BasicEffect
local toID = ____dex_2Ddata.toID
____exports.Ability = __TS__Class()
local Ability = ____exports.Ability
Ability.name = "Ability"
__TS__ClassExtends(Ability, BasicEffect)
function Ability.prototype.____constructor(self, data)
    BasicEffect.prototype.____constructor(self, data)
    self.fullname = "ability: " .. self.name
    self.effectType = "Ability"
    self.suppressWeather = not (not data.suppressWeather)
    self.rating = data.rating or 0
    if not self.gen then
        if self.num >= 234 then
            self.gen = 8
        elseif self.num >= 192 then
            self.gen = 7
        elseif self.num >= 165 then
            self.gen = 6
        elseif self.num >= 124 then
            self.gen = 5
        elseif self.num >= 77 then
            self.gen = 4
        elseif self.num >= 1 then
            self.gen = 3
        end
    end
end
____exports.DexAbilities = __TS__Class()
local DexAbilities = ____exports.DexAbilities
DexAbilities.name = "DexAbilities"
function DexAbilities.prototype.____constructor(self, dex)
    self.abilityCache = __TS__New(Map)
    self.allCache = nil
    self.dex = dex
end
function DexAbilities.prototype.get(self, name)
    if name == nil then
        name = ""
    end
    if name and (type(name) ~= "string") then
        return name
    end
    local id = toID(_G, name)
    return self:getByID(id)
end
function DexAbilities.prototype.getByID(self, id)
    local ability = self.abilityCache:get(id)
    if ability then
        return ability
    end
    if rawget(self.dex.data.Aliases, id) ~= nil then
        ability = self:get(self.dex.data.Aliases[id])
    elseif id and (rawget(self.dex.data.Abilities, id) ~= nil) then
        local abilityData = self.dex.data.Abilities[id]
        local abilityTextData = self.dex:getDescs("Abilities", id, abilityData)
        ability = __TS__New(
            ____exports.Ability,
            __TS__ObjectAssign({name = id}, abilityData, abilityTextData)
        )
        if ability.gen > self.dex.gen then
            ability.isNonstandard = "Future"
        end
        if (self.dex.currentMod == "gen7letsgo") and (ability.id ~= "noability") then
            ability.isNonstandard = "Past"
        end
        if ((self.dex.currentMod == "gen7letsgo") or (self.dex.gen <= 2)) and (ability.id == "noability") then
            ability.isNonstandard = nil
        end
    else
        ability = __TS__New(____exports.Ability, {id = id, name = id, exists = false})
    end
    if ability.exists then
        self.abilityCache:set(id, ability)
    end
    return ability
end
function DexAbilities.prototype.all(self)
    if self.allCache then
        return self.allCache
    end
    local abilities = {}
    for id in pairs(self.dex.data.Abilities) do
        __TS__ArrayPush(
            abilities,
            self:getByID(id)
        )
    end
    self.allCache = abilities
    return self.allCache
end
return ____exports
