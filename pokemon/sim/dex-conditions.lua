--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____dex_2Ddata = require("sim/dex-data")
local BasicEffect = ____dex_2Ddata.BasicEffect
local toID = ____dex_2Ddata.toID
____exports.Condition = __TS__Class()
local Condition = ____exports.Condition
Condition.name = "Condition"
__TS__ClassExtends(Condition, BasicEffect)
function Condition.prototype.____constructor(self, data)
    BasicEffect.prototype.____constructor(self, data)
    data = self
	-- slight rewrite
    self.effectType = ( data.effectType == "Weather" or data.effectType == "Status" ) and data.effectType or "Condition"
end
local EMPTY_CONDITION = __TS__New(____exports.Condition, {name = "", exists = false})
____exports.DexConditions = __TS__Class()
local DexConditions = ____exports.DexConditions
DexConditions.name = "DexConditions"
function DexConditions.prototype.____constructor(self, dex)
    self.conditionCache = __TS__New(Map)
    self.dex = dex
end
function DexConditions.prototype.get(self, name)
    if not name then
        return EMPTY_CONDITION
    end
    if type(name) ~= "string" then
        return name
    end
    return self:getByID(
        (((name:startsWith("item:") or name:startsWith("ability:")) and (function() return name end)) or (function() return toID(_G, name) end))()
    )
end
function DexConditions.prototype.getByID(self, id)
    if not id then
        return EMPTY_CONDITION
    end
    local condition = self.conditionCache:get(id)
    if condition then
        return condition
    end
    local found
    if id:startsWith("item:") then
        local item = self.dex.items:getByID(
            id:slice(5)
        )
        condition = __TS__ObjectAssign(
            {},
            item,
            {
                id = "item:" .. tostring(item.id)
            }
        )
    elseif id:startsWith("ability:") then
        local ability = self.dex.abilities:getByID(
            id:slice(8)
        )
        condition = __TS__ObjectAssign(
            {},
            ability,
            {
                id = "ability:" .. tostring(ability.id)
            }
        )
    elseif rawget(self.dex.data.Rulesets, id) ~= nil then
        condition = self.dex.formats:get(id)
    elseif rawget(self.dex.data.Conditions, id) ~= nil then
        condition = __TS__New(
            ____exports.Condition,
            __TS__ObjectAssign({name = id}, self.dex.data.Conditions[id])
        )
    elseif (((rawget(self.dex.data.Moves, id) ~= nil) and (function()
        found = self.dex.data.Moves[id]
        return found
    end)().condition) or ((rawget(self.dex.data.Abilities, id) ~= nil) and (function()
        found = self.dex.data.Abilities[id]
        return found
    end)().condition)) or ((rawget(self.dex.data.Items, id) ~= nil) and (function()
        found = self.dex.data.Items[id]
        return found
    end)().condition) then
        condition = __TS__New(
            ____exports.Condition,
            __TS__ObjectAssign({name = found.name or id}, found.condition)
        )
    elseif id == "recoil" then
        condition = __TS__New(____exports.Condition, {name = "Recoil", effectType = "Recoil"})
    elseif id == "drain" then
        condition = __TS__New(____exports.Condition, {name = "Drain", effectType = "Drain"})
    else
        condition = __TS__New(____exports.Condition, {name = id, exists = false})
    end
    self.conditionCache:set(id, condition)
    return condition
end
return ____exports
