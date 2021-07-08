--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____lib = require("lib/index")
local Utils = ____lib.Utils
local ____dex_2Ddata = require("sim/dex-data")
local BasicEffect = ____dex_2Ddata.BasicEffect
local toID = ____dex_2Ddata.toID
____exports.DataMove = __TS__Class()
local DataMove = ____exports.DataMove
DataMove.name = "DataMove"
__TS__ClassExtends(DataMove, BasicEffect)
function DataMove.prototype.____constructor(self, data)
    BasicEffect.prototype.____constructor(self, data)
    data = self
    self.fullname = "move: " .. self.name
    self.effectType = "Move"
    self.type = Utils:getString(data.type)
    self.target = data.target
    self.basePower = __TS__Number(data.basePower)
    self.accuracy = data.accuracy
    self.critRatio = __TS__Number(data.critRatio) or 1
    self.baseMoveType = Utils:getString(data.baseMoveType) or self.type
    self.secondary = data.secondary or nil
    self.secondaries = (data.secondaries or (self.secondary and ({self.secondary}))) or nil
    self.priority = __TS__Number(data.priority) or 0
    self.category = data.category
    self.defensiveCategory = data.defensiveCategory or nil
    self.useTargetOffensive = not (not data.useTargetOffensive)
    self.useSourceDefensiveAsOffensive = not (not data.useSourceDefensiveAsOffensive)
    self.ignoreNegativeOffensive = not (not data.ignoreNegativeOffensive)
    self.ignorePositiveDefensive = not (not data.ignorePositiveDefensive)
    self.ignoreOffensive = not (not data.ignoreOffensive)
    self.ignoreDefensive = not (not data.ignoreDefensive)
    self.ignoreImmunity = (((data.ignoreImmunity ~= nil) and (function() return data.ignoreImmunity end)) or (function() return self.category == "Status" end))()
    self.pp = __TS__Number(data.pp)
    self.noPPBoosts = not (not data.noPPBoosts)
    self.isZ = data.isZ or false
    self.isMax = data.isMax or false
    self.flags = data.flags or ({})
    self.selfSwitch = (((type(data.selfSwitch) == "string") and (function() return data.selfSwitch end)) or (function() return data.selfSwitch end))() or nil
    self.pressureTarget = data.pressureTarget or ""
    self.nonGhostTarget = data.nonGhostTarget or ""
    self.ignoreAbility = data.ignoreAbility or false
    self.damage = data.damage
    self.spreadHit = data.spreadHit or false
    self.forceSTAB = not (not data.forceSTAB)
    self.noSketch = not (not data.noSketch)
    self.stab = data.stab or nil
    self.volatileStatus = (((type(data.volatileStatus) == "string") and (function() return data.volatileStatus end)) or (function() return nil end))()
    if ((self.category ~= "Status") and (not self.maxMove)) and (self.id ~= "struggle") then
        self.maxMove = {basePower = 1}
        if self.isMax or self.isZ then
        elseif not self.basePower then
            self.maxMove.basePower = 100
        elseif ({"Fighting", "Poison"}):includes(self.type) then
            if self.basePower >= 150 then
                self.maxMove.basePower = 100
            elseif self.basePower >= 110 then
                self.maxMove.basePower = 95
            elseif self.basePower >= 75 then
                self.maxMove.basePower = 90
            elseif self.basePower >= 65 then
                self.maxMove.basePower = 85
            elseif self.basePower >= 55 then
                self.maxMove.basePower = 80
            elseif self.basePower >= 45 then
                self.maxMove.basePower = 75
            else
                self.maxMove.basePower = 70
            end
        else
            if self.basePower >= 150 then
                self.maxMove.basePower = 150
            elseif self.basePower >= 110 then
                self.maxMove.basePower = 140
            elseif self.basePower >= 75 then
                self.maxMove.basePower = 130
            elseif self.basePower >= 65 then
                self.maxMove.basePower = 120
            elseif self.basePower >= 55 then
                self.maxMove.basePower = 110
            elseif self.basePower >= 45 then
                self.maxMove.basePower = 100
            else
                self.maxMove.basePower = 90
            end
        end
    end
    if ((((self.category ~= "Status") and (not self.zMove)) and (not self.isZ)) and (not self.isMax)) and (self.id ~= "struggle") then
        local basePower = self.basePower
        self.zMove = {}
        if __TS__ArrayIsArray(self.multihit) then
            basePower = basePower * 3
        end
        if not basePower then
            self.zMove.basePower = 100
        elseif basePower >= 140 then
            self.zMove.basePower = 200
        elseif basePower >= 130 then
            self.zMove.basePower = 195
        elseif basePower >= 120 then
            self.zMove.basePower = 190
        elseif basePower >= 110 then
            self.zMove.basePower = 185
        elseif basePower >= 100 then
            self.zMove.basePower = 180
        elseif basePower >= 90 then
            self.zMove.basePower = 175
        elseif basePower >= 80 then
            self.zMove.basePower = 160
        elseif basePower >= 70 then
            self.zMove.basePower = 140
        elseif basePower >= 60 then
            self.zMove.basePower = 120
        else
            self.zMove.basePower = 100
        end
    end
    if not self.gen then
        if self.num >= 743 then
            self.gen = 8
        elseif self.num >= 622 then
            self.gen = 7
        elseif self.num >= 560 then
            self.gen = 6
        elseif self.num >= 468 then
            self.gen = 5
        elseif self.num >= 355 then
            self.gen = 4
        elseif self.num >= 252 then
            self.gen = 3
        elseif self.num >= 166 then
            self.gen = 2
        elseif self.num >= 1 then
            self.gen = 1
        end
    end
end
____exports.DexMoves = __TS__Class()
local DexMoves = ____exports.DexMoves
DexMoves.name = "DexMoves"
function DexMoves.prototype.____constructor(self, dex)
    self.moveCache = __TS__New(Map)
    self.allCache = nil
    self.dex = dex
end
function DexMoves.prototype.get(self, name)
    if name and (type(name) ~= "string") then
        return name
    end
    name = (name or ""):trim()
    local id = toID(_G, name)
    return self:getByID(id)
end
function DexMoves.prototype.getByID(self, id)
    local move = self.moveCache:get(id)
    if move then
        return move
    end
    if rawget(self.dex.data.Aliases, id) ~= nil then
        move = self:get(self.dex.data.Aliases[id])
        if move.exists then
            self.moveCache:set(id, move)
        end
        return move
    end
    if id:startsWith("hiddenpower") then
        id = nil:exec(id)[2]
    end
    if id and (rawget(self.dex.data.Moves, id) ~= nil) then
        local moveData = self.dex.data.Moves[id]
        local moveTextData = self.dex:getDescs("Moves", id, moveData)
        move = __TS__New(
            ____exports.DataMove,
            __TS__ObjectAssign({name = id}, moveData, moveTextData)
        )
        if move.gen > self.dex.gen then
            move.isNonstandard = "Future"
        end
    else
        move = __TS__New(____exports.DataMove, {name = id, exists = false})
    end
    if move.exists then
        self.moveCache:set(id, move)
    end
    return move
end
function DexMoves.prototype.all(self)
    if self.allCache then
        return self.allCache
    end
    local moves = {}
    for id in pairs(self.dex.data.Moves) do
        __TS__ArrayPush(
            moves,
            self:getByID(id)
        )
    end
    self.allCache = moves
    return self.allCache
end
return ____exports
