--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____state = require("sim/state")
local State = ____state.State
local ____dex = require("sim/dex")
local toID = ____dex.toID
____exports.Field = __TS__Class()
local Field = ____exports.Field
Field.name = "Field"
function Field.prototype.____constructor(self, battle)
    self.battle = battle
    local fieldScripts = self.battle.format.field or self.battle.dex.data.Scripts.field
    if fieldScripts then
        __TS__ObjectAssign(self, fieldScripts)
    end
    self.id = ""
    self.weather = ""
    self.weatherState = {id = ""}
    self.terrain = ""
    self.terrainState = {id = ""}
    self.pseudoWeather = {}
end
function Field.prototype.toJSON(self)
    return State:serializeField(self)
end
function Field.prototype.setWeather(self, status, source, sourceEffect)
    if source == nil then
        source = nil
    end
    if sourceEffect == nil then
        sourceEffect = nil
    end
    status = self.battle.dex.conditions:get(status)
    if (not sourceEffect) and self.battle.effect then
        sourceEffect = self.battle.effect
    end
    if ((not source) and self.battle.event) and self.battle.event.target then
        source = self.battle.event.target
    end
    if source == "debug" then
        source = self.battle.sides[0].active[0]
    end
    if self.weather == status.id then
        if sourceEffect and (sourceEffect.effectType == "Ability") then
            if (self.battle.gen > 5) or (self.weatherState.duration == 0) then
                return false
            end
        elseif (self.battle.gen > 2) or (status.id == "sandstorm") then
            return false
        end
    end
    if source then
        local result = self.battle:runEvent("SetWeather", source, source, status)
        if not result then
            if result == false then
                if sourceEffect.weather then
                    self.battle:add(
                        "-fail",
                        source,
                        sourceEffect,
                        "[from] " .. tostring(self.weather)
                    )
                elseif sourceEffect and (sourceEffect.effectType == "Ability") then
                    self.battle:add(
                        "-ability",
                        source,
                        sourceEffect,
                        "[from] " .. tostring(self.weather),
                        "[fail]"
                    )
                end
            end
            return nil
        end
    end
    local prevWeather = self.weather
    local prevWeatherState = self.weatherState
    self.weather = status.id
    self.weatherState = {id = status.id}
    if source then
        self.weatherState.source = source
        self.weatherState.sourceSlot = source:getSlot()
    end
    if status.duration then
        self.weatherState.duration = status.duration
    end
    if status.durationCallback then
        if not source then
            error(
                __TS__New(Error, "setting weather without a source"),
                0
            )
        end
        self.weatherState.duration = status.durationCallback:call(self.battle, source, source, sourceEffect)
    end
    if not self.battle:singleEvent("FieldStart", status, self.weatherState, self, source, sourceEffect) then
        self.weather = prevWeather
        self.weatherState = prevWeatherState
        return false
    end
    self.battle:runEvent("WeatherStart", source, source, status)
    return true
end
function Field.prototype.clearWeather(self)
    if not self.weather then
        return false
    end
    local prevWeather = self:getWeather()
    self.battle:singleEvent("FieldEnd", prevWeather, self.weatherState, self)
    self.weather = ""
    self.weatherState = {id = ""}
    return true
end
function Field.prototype.effectiveWeather(self)
    if self:suppressingWeather() then
        return ""
    end
    return self.weather
end
function Field.prototype.suppressingWeather(self)
    for ____, side in __TS__Iterator(self.battle.sides) do
        for ____, pokemon in __TS__Iterator(side.active) do
            if ((pokemon and (not pokemon.fainted)) and (not pokemon:ignoringAbility())) and pokemon:getAbility().suppressWeather then
                return true
            end
        end
    end
    return false
end
function Field.prototype.isWeather(self, weather)
    local ourWeather = self:effectiveWeather()
    if not __TS__ArrayIsArray(weather) then
        return ourWeather == toID(_G, weather)
    end
    return __TS__ArrayMap(weather, toID):includes(ourWeather)
end
function Field.prototype.getWeather(self)
    return self.battle.dex.conditions:getByID(self.weather)
end
function Field.prototype.setTerrain(self, status, source, sourceEffect)
    if source == nil then
        source = nil
    end
    if sourceEffect == nil then
        sourceEffect = nil
    end
    status = self.battle.dex.conditions:get(status)
    if (not sourceEffect) and self.battle.effect then
        sourceEffect = self.battle.effect
    end
    if ((not source) and self.battle.event) and self.battle.event.target then
        source = self.battle.event.target
    end
    if source == "debug" then
        source = self.battle.sides[0].active[0]
    end
    if not source then
        error(
            __TS__New(Error, "setting terrain without a source"),
            0
        )
    end
    if self.terrain == status.id then
        return false
    end
    local prevTerrain = self.terrain
    local prevTerrainState = self.terrainState
    self.terrain = status.id
    self.terrainState = {
        id = status.id,
        source = source,
        sourceSlot = source:getSlot(),
        duration = status.duration
    }
    if status.durationCallback then
        self.terrainState.duration = status.durationCallback:call(self.battle, source, source, sourceEffect)
    end
    if not self.battle:singleEvent("FieldStart", status, self.terrainState, self, source, sourceEffect) then
        self.terrain = prevTerrain
        self.terrainState = prevTerrainState
        return false
    end
    self.battle:runEvent("TerrainStart", source, source, status)
    return true
end
function Field.prototype.clearTerrain(self)
    if not self.terrain then
        return false
    end
    local prevTerrain = self:getTerrain()
    self.battle:singleEvent("FieldEnd", prevTerrain, self.terrainState, self)
    self.terrain = ""
    self.terrainState = {id = ""}
    return true
end
function Field.prototype.effectiveTerrain(self, target)
    if self.battle.event and (not target) then
        target = self.battle.event.target
    end
    return ((self.battle:runEvent("TryTerrain", target) and (function() return self.terrain end)) or (function() return "" end))()
end
function Field.prototype.isTerrain(self, terrain, target)
    local ourTerrain = self:effectiveTerrain(target)
    if not __TS__ArrayIsArray(terrain) then
        return ourTerrain == toID(_G, terrain)
    end
    return __TS__ArrayMap(terrain, toID):includes(ourTerrain)
end
function Field.prototype.getTerrain(self)
    return self.battle.dex.conditions:getByID(self.terrain)
end
function Field.prototype.addPseudoWeather(self, status, source, sourceEffect)
    if source == nil then
        source = nil
    end
    if sourceEffect == nil then
        sourceEffect = nil
    end
    if ((not source) and self.battle.event) and self.battle.event.target then
        source = self.battle.event.target
    end
    if source == "debug" then
        source = self.battle.sides[0].active[0]
    end
    status = self.battle.dex.conditions:get(status)
    local state = self.pseudoWeather[status.id]
    if state then
        if not status.onFieldRestart then
            return false
        end
        return self.battle:singleEvent("FieldRestart", status, state, self, source, sourceEffect)
    end
    state = (function(o, i, v)
        o[i] = v
        return v
    end)(
        self.pseudoWeather,
        status.id,
        {
            id = status.id,
            source = source,
            sourceSlot = source:getSlot(),
            duration = status.duration
        }
    )
    if status.durationCallback then
        if not source then
            error(
                __TS__New(Error, "setting fieldcond without a source"),
                0
            )
        end
        state.duration = status.durationCallback:call(self.battle, source, source, sourceEffect)
    end
    if not self.battle:singleEvent("FieldStart", status, state, self, source, sourceEffect) then
        __TS__Delete(self.pseudoWeather, status.id)
        return false
    end
    return true
end
function Field.prototype.getPseudoWeather(self, status)
    status = self.battle.dex.conditions:get(status)
    return ((self.pseudoWeather[status.id] and (function() return status end)) or (function() return nil end))()
end
function Field.prototype.removePseudoWeather(self, status)
    status = self.battle.dex.conditions:get(status)
    local state = self.pseudoWeather[status.id]
    if not state then
        return false
    end
    self.battle:singleEvent("FieldEnd", status, state, self)
    __TS__Delete(self.pseudoWeather, status.id)
    return true
end
function Field.prototype.destroy(self)
    self.battle = nil
end
return ____exports
