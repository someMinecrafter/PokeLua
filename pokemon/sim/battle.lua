--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____dex = require("sim/dex")
local Dex = ____dex.Dex
local toID = ____dex.toID
local ____teams = require("sim/teams")
local Teams = ____teams.Teams
local ____field = require("sim/field")
local Field = ____field.Field
local ____pokemon = require("sim/pokemon")
local Pokemon = ____pokemon.Pokemon
local RESTORATIVE_BERRIES = ____pokemon.RESTORATIVE_BERRIES
local ____prng = require("sim/prng")
local PRNG = ____prng.PRNG
local ____side = require("sim/side")
local Side = ____side.Side
local ____state = require("sim/state")
local State = ____state.State
local ____battle_2Dqueue = require("sim/battle-queue")
local BattleQueue = ____battle_2Dqueue.BattleQueue
local ____battle_2Dactions = require("sim/battle-actions")
local BattleActions = ____battle_2Dactions.BattleActions
local ____lib = require("lib/index")
local Utils = ____lib.Utils
____exports.Battle = __TS__Class()
local Battle = ____exports.Battle
Battle.name = "Battle"
function Battle.prototype.____constructor(self, options)
    self.toID = toID
    self.log = {}
    self:add(
        "t:",
        math.floor(
            Date:now() / 1000
        )
    )
    local format = options.format or Dex.formats:get(options.formatid, true)
    self.format = format
    self.dex = Dex:forFormat(format)
    self.gen = self.dex.gen
    self.ruleTable = self.dex.formats:getRuleTable(format)
    self.trunc = self.dex.trunc
    self.clampIntRange = Utils.clampIntRange
    for i in pairs(self.dex.data.Scripts) do
        local entry = self.dex.data.Scripts[i]
        if type(entry) == "function" then
            self[i] = entry
        end
    end
    if format.battle then
        __TS__ObjectAssign(self, format.battle)
    end
    self.id = ""
    self.debugMode = format.debug or (not (not options.debug))
    self.deserialized = not (not options.deserialized)
    self.strictChoices = not (not options.strictChoices)
    self.formatData = {id = format.id}
    self.gameType = format.gameType or "singles"
    self.field = __TS__New(Field, self)
    local isFourPlayer = (self.gameType == "multi") or (self.gameType == "freeforall")
    self.sides = Array(_G, (isFourPlayer and 4) or 2):fill(nil)
    self.activePerHalf = ((self.gameType == "triples") and 3) or (((isFourPlayer or (self.gameType == "doubles")) and 2) or 1)
    self.prng = options.prng or __TS__New(PRNG, options.seed or nil)
    self.prngSeed = __TS__ArraySlice(self.prng.startingSeed)
    self.rated = options.rated or (not (not options.rated))
    self.reportExactHP = not (not format.debug)
    self.reportPercentages = false
    self.supportCancel = false
    self.queue = __TS__New(BattleQueue, self)
    self.actions = __TS__New(BattleActions, self)
    self.faintQueue = {}
    self.inputLog = {}
    self.messageLog = {}
    self.sentLogPos = 0
    self.sentEnd = false
    self.requestState = ""
    self.turn = 0
    self.midTurn = false
    self.started = false
    self.ended = false
    self.effect = {id = ""}
    self.effectState = {id = ""}
    self.event = {id = ""}
    self.events = nil
    self.eventDepth = 0
    self.activeMove = nil
    self.activePokemon = nil
    self.activeTarget = nil
    self.lastMove = nil
    self.lastMoveLine = -1
    self.lastSuccessfulMoveThisTurn = nil
    self.lastDamage = 0
    self.abilityOrder = 0
    self.quickClawRoll = false
    self.teamGenerator = nil
    self.hints = __TS__New(Set)
    self.NOT_FAIL = ""
    self.HIT_SUBSTITUTE = 0
    self.FAIL = false
    self.SILENT_FAIL = nil
    self.send = options.send or (function()
    end)
    local inputOptions = {formatid = options.formatid, seed = self.prng.seed}
    if self.rated then
        inputOptions.rated = self.rated
    end
    if type(__version) ~= "nil" then
        if __version.head then
            __TS__ArrayPush(
                self.inputLog,
                ">version " .. tostring(__version.head)
            )
        end
        if __version.origin then
            __TS__ArrayPush(
                self.inputLog,
                ">version-origin " .. tostring(__version.origin)
            )
        end
    end
    __TS__ArrayPush(
        self.inputLog,
        ">start " .. tostring(
            JSON:stringify(inputOptions)
        )
    )
    self:add("gametype", self.gameType)
    for ____, rule in __TS__Iterator(
        self.ruleTable:keys()
    ) do
        do
            if ("+*-!"):includes(
                rule:charAt(0)
            ) then
                goto __continue11
            end
            local subFormat = self.dex.formats:get(rule)
            if subFormat.exists then
                local hasEventHandler = __TS__ArraySome(
                    __TS__ObjectKeys(subFormat),
                    function(____, val) return val:startsWith("on") and (not ({"onBegin", "onTeamPreview", "onBattleStart", "onValidateRule", "onValidateTeam", "onChangeSet", "onValidateSet"}):includes(val)) end
                )
                if hasEventHandler then
                    self.field:addPseudoWeather(rule)
                end
            end
        end
        ::__continue11::
    end
    local sides = {"p1", "p2", "p3", "p4"}
    for ____, side in ipairs(sides) do
        if options[side] then
            self:setPlayer(side, options[side])
        end
    end
end
__TS__SetDescriptor(
    Battle.prototype,
    "p1",
    {
        get = function(self)
            return self.sides[1]
        end
    },
    true
)
__TS__SetDescriptor(
    Battle.prototype,
    "p2",
    {
        get = function(self)
            return self.sides[2]
        end
    },
    true
)
__TS__SetDescriptor(
    Battle.prototype,
    "p3",
    {
        get = function(self)
            return self.sides[3]
        end
    },
    true
)
__TS__SetDescriptor(
    Battle.prototype,
    "p4",
    {
        get = function(self)
            return self.sides[4]
        end
    },
    true
)
function Battle.prototype.toJSON(self)
    return State:serializeBattle(self)
end
function Battle.fromJSON(self, serialized)
    return State:deserializeBattle(serialized)
end
function Battle.prototype.__tostring(self)
    return "Battle: " .. tostring(self.format)
end
function Battle.prototype.random(self, m, n)
    return self.prng:next(m, n)
end
function Battle.prototype.randomChance(self, numerator, denominator)
    return self.prng:randomChance(numerator, denominator)
end
function Battle.prototype.sample(self, items)
    return self.prng:sample(items)
end
function Battle.prototype.resetRNG(self, seed)
    if seed == nil then
        seed = self.prng.startingSeed
    end
    self.prng = __TS__New(PRNG, seed)
    self:add("message", "The battle's RNG was reset.")
end
function Battle.prototype.suppressingAbility(self, target)
    return (((self.activePokemon and self.activePokemon.isActive) and ((self.activePokemon ~= target) or (self.gen < 8))) and self.activeMove) and self.activeMove.ignoreAbility
end
function Battle.prototype.setActiveMove(self, move, pokemon, target)
    self.activeMove = move or nil
    self.activePokemon = pokemon or nil
    self.activeTarget = (target or pokemon) or nil
end
function Battle.prototype.clearActiveMove(self, failed)
    if self.activeMove then
        if not failed then
            self.lastMove = self.activeMove
        end
        self.activeMove = nil
        self.activePokemon = nil
        self.activeTarget = nil
    end
end
function Battle.prototype.updateSpeed(self)
    for ____, pokemon in ipairs(
        self:getAllActive()
    ) do
        pokemon:updateSpeed()
    end
end
function Battle.prototype.comparePriority(self, a, b)
    return (((-((b.order or 4294967296) - (a.order or 4294967296)) or ((b.priority or 0) - (a.priority or 0))) or ((b.speed or 0) - (a.speed or 0))) or -((b.subOrder or 0) - (a.subOrder or 0))) or 0
end
function Battle.compareRedirectOrder(self, a, b)
    return ((((b.priority or 0) - (a.priority or 0)) or ((b.speed or 0) - (a.speed or 0))) or (((a.effectHolder and b.effectHolder) and (function() return -(b.effectHolder.abilityOrder - a.effectHolder.abilityOrder) end)) or (function() return 0 end))()) or 0
end
function Battle.compareLeftToRightOrder(self, a, b)
    return ((-((b.order or 4294967296) - (a.order or 4294967296)) or ((b.priority or 0) - (a.priority or 0))) or -((b.index or 0) - (a.index or 0))) or 0
end
function Battle.prototype.speedSort(self, list, comparator)
    if comparator == nil then
        comparator = self.comparePriority
    end
    if #list < 2 then
        return
    end
    local sorted = 0
    while (sorted + 1) < #list do
        local nextIndexes = {sorted}
        do
            local i = sorted + 1
            while i < #list do
                do
                    local delta = comparator(_G, list[nextIndexes[1] + 1], list[i + 1])
                    if delta < 0 then
                        goto __continue42
                    end
                    if delta > 0 then
                        nextIndexes = {i}
                    end
                    if delta == 0 then
                        __TS__ArrayPush(nextIndexes, i)
                    end
                end
                ::__continue42::
                i = i + 1
            end
        end
        do
            local i = 0
            while i < #nextIndexes do
                local index = nextIndexes[i + 1]
                if index ~= (sorted + i) then
                    list[(sorted + i) + 1], list[index + 1] = __TS__Unpack({list[index + 1], list[(sorted + i) + 1]})
                end
                i = i + 1
            end
        end
        if #nextIndexes > 1 then
            self.prng:shuffle(list, sorted, sorted + #nextIndexes)
        end
        sorted = sorted + #nextIndexes
    end
end
function Battle.prototype.eachEvent(self, eventid, effect, relayVar)
    local actives = self:getAllActive()
    if (not effect) and self.effect then
        effect = self.effect
    end
    self:speedSort(
        actives,
        function(____, a, b) return b.speed - a.speed end
    )
    for ____, pokemon in ipairs(actives) do
        self:runEvent(eventid, pokemon, nil, effect, relayVar)
    end
    if (eventid == "Weather") and (self.gen >= 7) then
        self:eachEvent("Update")
    end
end
function Battle.prototype.residualEvent(self, eventid, relayVar)
    local callbackName = "on" .. eventid
    local handlers = self:findBattleEventHandlers(callbackName, "duration")
    handlers = __TS__ArrayConcat(
        handlers,
        self:findFieldEventHandlers(self.field, "onField" .. eventid, "duration")
    )
    for ____, side in ipairs(self.sides) do
        if (side.n < 2) or (not side.allySide) then
            handlers = __TS__ArrayConcat(
                handlers,
                self:findSideEventHandlers(side, "onSide" .. eventid, "duration")
            )
        end
        for ____, active in ipairs(side.active) do
            do
                if not active then
                    goto __continue57
                end
                handlers = __TS__ArrayConcat(
                    handlers,
                    self:findPokemonEventHandlers(active, callbackName, "duration")
                )
                handlers = __TS__ArrayConcat(
                    handlers,
                    self:findSideEventHandlers(side, callbackName, nil, active)
                )
                handlers = __TS__ArrayConcat(
                    handlers,
                    self:findFieldEventHandlers(self.field, callbackName, nil, active)
                )
            end
            ::__continue57::
        end
    end
    self:speedSort(handlers)
    while #handlers do
        do
            local handler = handlers[1]
            __TS__ArrayShift(handlers)
            local effect = handler.effect
            if handler.effectHolder.fainted then
                goto __continue59
            end
            if (handler["end"] and handler.state) and handler.state.duration then
                local ____obj, ____index = handler.state, "duration"
                ____obj[____index] = ____obj[____index] - 1
                if not handler.state.duration then
                    local endCallArgs = handler.endCallArgs or ({handler.effectHolder, effect.id})
                    handler["end"]:call(
                        __TS__Unpack(endCallArgs)
                    )
                    goto __continue59
                end
            end
            local handlerEventid = eventid
            if handler.effectHolder.sideConditions then
                handlerEventid = "Side" .. eventid
            end
            if handler.effectHolder.pseudoWeather then
                handlerEventid = "Field" .. eventid
            end
            if handler.callback then
                self:singleEvent(handlerEventid, effect, handler.state, handler.effectHolder, nil, nil, relayVar, handler.callback)
            end
            self:faintMessages()
            if self.ended then
                return
            end
        end
        ::__continue59::
    end
end
function Battle.prototype.singleEvent(self, eventid, effect, state, target, source, sourceEffect, relayVar, customCallback)
    if self.eventDepth >= 8 then
        self:add("message", "STACK LIMIT EXCEEDED")
        self:add("message", "PLEASE REPORT IN BUG THREAD")
        self:add(
            "message",
            "Event: " .. tostring(eventid)
        )
        self:add(
            "message",
            "Parent event: " .. tostring(self.event.id)
        )
        error(
            __TS__New(Error, "Stack overflow"),
            0
        )
    end
    if (#self.log - self.sentLogPos) > 1000 then
        self:add("message", "LINE LIMIT EXCEEDED")
        self:add("message", "PLEASE REPORT IN BUG THREAD")
        self:add(
            "message",
            "Event: " .. tostring(eventid)
        )
        self:add(
            "message",
            "Parent event: " .. tostring(self.event.id)
        )
        error(
            __TS__New(Error, "Infinite loop"),
            0
        )
    end
    local hasRelayVar = true
    if relayVar == nil then
        relayVar = true
        hasRelayVar = false
    end
    if ((effect.effectType == "Status") and __TS__InstanceOf(target, Pokemon)) and (target.status ~= effect.id) then
        return relayVar
    end
    if (((((eventid ~= "Start") and (eventid ~= "TakeItem")) and (eventid ~= "Primal")) and (effect.effectType == "Item")) and __TS__InstanceOf(target, Pokemon)) and target:ignoringItem() then
        self:debug(
            tostring(eventid) .. " handler suppressed by Embargo, Klutz or Magic Room"
        )
        return relayVar
    end
    if (((eventid ~= "End") and (effect.effectType == "Ability")) and __TS__InstanceOf(target, Pokemon)) and target:ignoringAbility() then
        self:debug(
            tostring(eventid) .. " handler suppressed by Gastro Acid"
        )
        return relayVar
    end
    if ((((effect.effectType == "Weather") and (eventid ~= "FieldStart")) and (eventid ~= "FieldResidual")) and (eventid ~= "FieldEnd")) and self.field:suppressingWeather() then
        self:debug(
            tostring(eventid) .. " handler suppressed by Air Lock"
        )
        return relayVar
    end
    local callback = customCallback or effect["on" .. eventid]
    if callback == nil then
        return relayVar
    end
    local parentEffect = self.effect
    local parentEffectState = self.effectState
    local parentEvent = self.event
    self.effect = effect
    self.effectState = state or ({})
    self.event = {id = eventid, target = target, source = source, effect = sourceEffect}
    self.eventDepth = self.eventDepth + 1
    local args = {target, source, sourceEffect}
    if hasRelayVar then
        __TS__ArrayUnshift(args, relayVar)
    end
    local returnVal
    if type(callback) == "function" then
        returnVal = callback:apply(self, args)
    else
        returnVal = callback
    end
    self.eventDepth = self.eventDepth - 1
    self.effect = parentEffect
    self.effectState = parentEffectState
    self.event = parentEvent
    return (((returnVal == nil) and (function() return relayVar end)) or (function() return returnVal end))()
end
function Battle.prototype.runEvent(self, eventid, target, source, sourceEffect, relayVar, onEffect, fastExit)
    if self.eventDepth >= 8 then
        self:add("message", "STACK LIMIT EXCEEDED")
        self:add("message", "PLEASE REPORT IN BUG THREAD")
        self:add(
            "message",
            "Event: " .. tostring(eventid)
        )
        self:add(
            "message",
            "Parent event: " .. tostring(self.event.id)
        )
        error(
            __TS__New(Error, "Stack overflow"),
            0
        )
    end
    if not target then
        target = self
    end
    local effectSource = nil
    if __TS__InstanceOf(source, Pokemon) then
        effectSource = source
    end
    local handlers = self:findEventHandlers(target, eventid, effectSource)
    if onEffect then
        if not sourceEffect then
            error(
                __TS__New(Error, "onEffect passed without an effect"),
                0
            )
        end
        local callback = sourceEffect["on" .. eventid]
        if callback ~= nil then
            if __TS__ArrayIsArray(target) then
                error(
                    __TS__New(Error, ""),
                    0
                )
            end
            __TS__ArrayUnshift(
                handlers,
                self:resolvePriority({effect = sourceEffect, callback = callback, state = {}, ["end"] = nil, effectHolder = target}, "on" .. eventid)
            )
        end
    end
    if ((eventid == "Invulnerability") or (eventid == "TryHit")) or (eventid == "DamagingHit") then
        __TS__ArraySort(handlers, ____exports.Battle.compareLeftToRightOrder)
    elseif fastExit then
        __TS__ArraySort(handlers, ____exports.Battle.compareRedirectOrder)
    else
        self:speedSort(handlers)
    end
    local hasRelayVar = 1
    local args = {target, source, sourceEffect}
    if (relayVar == nil) or (relayVar == nil) then
        relayVar = true
        hasRelayVar = 0
    else
        __TS__ArrayUnshift(args, relayVar)
    end
    local parentEvent = self.event
    self.event = {id = eventid, target = target, source = source, effect = sourceEffect, modifier = 1}
    self.eventDepth = self.eventDepth + 1
    local targetRelayVars = {}
    if __TS__ArrayIsArray(target) then
        if __TS__ArrayIsArray(relayVar) then
            targetRelayVars = relayVar
        else
            do
                local i = 0
                while i < #target do
                    targetRelayVars[i + 1] = true
                    i = i + 1
                end
            end
        end
    end
    for ____, handler in ipairs(handlers) do
        do
            if handler.index ~= nil then
                if (not targetRelayVars[handler.index + 1]) and (not ((targetRelayVars[handler.index + 1] == 0) and (eventid == "DamagingHit"))) then
                    goto __continue96
                end
                if handler.target then
                    args[hasRelayVar + 1] = handler.target
                    self.event.target = handler.target
                end
                if hasRelayVar then
                    args[1] = targetRelayVars[handler.index + 1]
                end
            end
            local effect = handler.effect
            local effectHolder = handler.effectHolder
            if (effect.effectType == "Status") and (effectHolder.status ~= effect.id) then
                goto __continue96
            end
            if ((effect.effectType == "Ability") and (effect.isBreakable ~= false)) and self:suppressingAbility(effectHolder) then
                if effect.isBreakable then
                    self:debug(
                        tostring(eventid) .. " handler suppressed by Mold Breaker"
                    )
                    goto __continue96
                end
                if not effect.num then
                    local AttackingEvents = {BeforeMove = 1, BasePower = 1, Immunity = 1, RedirectTarget = 1, Heal = 1, SetStatus = 1, CriticalHit = 1, ModifyAtk = 1, ModifyDef = 1, ModifySpA = 1, ModifySpD = 1, ModifySpe = 1, ModifyAccuracy = 1, ModifyBoost = 1, ModifyDamage = 1, ModifySecondaries = 1, ModifyWeight = 1, TryAddVolatile = 1, TryHit = 1, TryHitSide = 1, TryMove = 1, Boost = 1, DragOut = 1, Effectiveness = 1}
                    if AttackingEvents[eventid] ~= nil then
                        self:debug(
                            tostring(eventid) .. " handler suppressed by Mold Breaker"
                        )
                        goto __continue96
                    elseif ((eventid == "Damage") and sourceEffect) and (sourceEffect.effectType == "Move") then
                        self:debug(
                            tostring(eventid) .. " handler suppressed by Mold Breaker"
                        )
                        goto __continue96
                    end
                end
            end
            if (((((eventid ~= "Start") and (eventid ~= "SwitchIn")) and (eventid ~= "TakeItem")) and (effect.effectType == "Item")) and __TS__InstanceOf(effectHolder, Pokemon)) and effectHolder:ignoringItem() then
                if eventid ~= "Update" then
                    self:debug(
                        tostring(eventid) .. " handler suppressed by Embargo, Klutz or Magic Room"
                    )
                end
                goto __continue96
            elseif (((eventid ~= "End") and (effect.effectType == "Ability")) and __TS__InstanceOf(effectHolder, Pokemon)) and effectHolder:ignoringAbility() then
                if eventid ~= "Update" then
                    self:debug(
                        tostring(eventid) .. " handler suppressed by Gastro Acid"
                    )
                end
                goto __continue96
            end
            if ((((effect.effectType == "Weather") or (eventid == "Weather")) and (eventid ~= "Residual")) and (eventid ~= "End")) and self.field:suppressingWeather() then
                self:debug(
                    tostring(eventid) .. " handler suppressed by Air Lock"
                )
                goto __continue96
            end
            local returnVal
            if type(handler.callback) == "function" then
                local parentEffect = self.effect
                local parentEffectState = self.effectState
                self.effect = handler.effect
                self.effectState = handler.state or ({})
                self.effectState.target = effectHolder
                returnVal = handler.callback:apply(self, args)
                self.effect = parentEffect
                self.effectState = parentEffectState
            else
                returnVal = handler.callback
            end
            if returnVal ~= nil then
                relayVar = returnVal
                if (not relayVar) or fastExit then
                    if handler.index ~= nil then
                        targetRelayVars[handler.index + 1] = relayVar
                        if __TS__ArrayEvery(
                            targetRelayVars,
                            function(____, val) return not val end
                        ) then
                            break
                        end
                    else
                        break
                    end
                end
                if hasRelayVar then
                    args[1] = relayVar
                end
            end
        end
        ::__continue96::
    end
    self.eventDepth = self.eventDepth - 1
    if (type(relayVar) == "number") and (relayVar == math.abs(
        math.floor(relayVar)
    )) then
        relayVar = self:modify(relayVar, self.event.modifier)
    end
    self.event = parentEvent
    return ((__TS__ArrayIsArray(target) and (function() return targetRelayVars end)) or (function() return relayVar end))()
end
function Battle.prototype.priorityEvent(self, eventid, target, source, effect, relayVar, onEffect)
    return self:runEvent(eventid, target, source, effect, relayVar, onEffect, true)
end
function Battle.prototype.resolvePriority(self, handler, callbackName)
    handler.order = handler.effect[callbackName .. "Order"] or false
    handler.priority = handler.effect[callbackName .. "Priority"] or 0
    handler.subOrder = handler.effect[callbackName .. "SubOrder"] or 0
    if handler.effectHolder and handler.effectHolder.getStat then
        handler.speed = handler.effectHolder.speed
    end
    return handler
end
function Battle.prototype.findEventHandlers(self, target, eventName, source)
    local handlers = {}
    if __TS__ArrayIsArray(target) then
        for ____, ____value in __TS__Iterator(
            target:entries()
        ) do
            local i
            i = ____value[1]
            local pokemon
            pokemon = ____value[2]
            local curHandlers = self:findEventHandlers(pokemon, eventName, source)
            for ____, handler in ipairs(curHandlers) do
                handler.target = pokemon
                handler.index = i
            end
            handlers = __TS__ArrayConcat(handlers, curHandlers)
        end
        return handlers
    end
    if __TS__InstanceOf(target, Pokemon) and (target.isActive or source.isActive) then
        handlers = self:findPokemonEventHandlers(target, "on" .. eventName)
        for ____, allyActive in ipairs(
            target:alliesAndSelf()
        ) do
            __TS__ArrayPush(
                handlers,
                __TS__Unpack(
                    self:findPokemonEventHandlers(allyActive, "onAlly" .. eventName)
                )
            )
            __TS__ArrayPush(
                handlers,
                __TS__Unpack(
                    self:findPokemonEventHandlers(allyActive, "onAny" .. eventName)
                )
            )
        end
        for ____, foeActive in ipairs(
            target:foes()
        ) do
            __TS__ArrayPush(
                handlers,
                __TS__Unpack(
                    self:findPokemonEventHandlers(foeActive, "onFoe" .. eventName)
                )
            )
            __TS__ArrayPush(
                handlers,
                __TS__Unpack(
                    self:findPokemonEventHandlers(foeActive, "onAny" .. eventName)
                )
            )
        end
        target = target.side
    end
    if source then
        __TS__ArrayPush(
            handlers,
            __TS__Unpack(
                self:findPokemonEventHandlers(source, "onSource" .. eventName)
            )
        )
    end
    if __TS__InstanceOf(target, Side) then
        for ____, side in ipairs(self.sides) do
            if (side.n >= 2) and side.allySide then
                break
            end
            if (side == target) or (side == target.allySide) then
                __TS__ArrayPush(
                    handlers,
                    __TS__Unpack(
                        self:findSideEventHandlers(side, "on" .. eventName)
                    )
                )
            else
                __TS__ArrayPush(
                    handlers,
                    __TS__Unpack(
                        self:findSideEventHandlers(side, "onFoe" .. eventName)
                    )
                )
            end
            __TS__ArrayPush(
                handlers,
                __TS__Unpack(
                    self:findSideEventHandlers(side, "onAny" .. eventName)
                )
            )
        end
    end
    __TS__ArrayPush(
        handlers,
        __TS__Unpack(
            self:findFieldEventHandlers(self.field, "on" .. eventName)
        )
    )
    __TS__ArrayPush(
        handlers,
        __TS__Unpack(
            self:findBattleEventHandlers("on" .. eventName)
        )
    )
    return handlers
end
function Battle.prototype.findPokemonEventHandlers(self, pokemon, callbackName, getKey)
    local handlers = {}
    local status = pokemon:getStatus()
    local callback = status[callbackName]
    if (callback ~= nil) or (getKey and pokemon.statusState[getKey]) then
        __TS__ArrayPush(
            handlers,
            self:resolvePriority({effect = status, callback = callback, state = pokemon.statusState, ["end"] = pokemon.clearStatus, effectHolder = pokemon}, callbackName)
        )
    end
    for id in pairs(pokemon.volatiles) do
        local volatileState = pokemon.volatiles[id]
        local volatile = self.dex.conditions:getByID(id)
        callback = volatile[callbackName]
        if (callback ~= nil) or (getKey and volatileState[getKey]) then
            __TS__ArrayPush(
                handlers,
                self:resolvePriority({effect = volatile, callback = callback, state = volatileState, ["end"] = pokemon.removeVolatile, effectHolder = pokemon}, callbackName)
            )
        end
    end
    local ability = pokemon:getAbility()
    callback = ability[callbackName]
    if (callback ~= nil) or (getKey and pokemon.abilityState[getKey]) then
        __TS__ArrayPush(
            handlers,
            self:resolvePriority({effect = ability, callback = callback, state = pokemon.abilityState, ["end"] = pokemon.clearAbility, effectHolder = pokemon}, callbackName)
        )
    end
    local item = pokemon:getItem()
    callback = item[callbackName]
    if (callback ~= nil) or (getKey and pokemon.itemState[getKey]) then
        __TS__ArrayPush(
            handlers,
            self:resolvePriority({effect = item, callback = callback, state = pokemon.itemState, ["end"] = pokemon.clearItem, effectHolder = pokemon}, callbackName)
        )
    end
    local species = pokemon.baseSpecies
    callback = species[callbackName]
    if callback ~= nil then
        __TS__ArrayPush(
            handlers,
            self:resolvePriority(
                {
                    effect = species,
                    callback = callback,
                    state = pokemon.speciesState,
                    ["end"] = function(self)
                    end,
                    effectHolder = pokemon
                },
                callbackName
            )
        )
    end
    local side = pokemon.side
    for conditionid in pairs(side.slotConditions[pokemon.position]) do
        local slotConditionState = side.slotConditions[pokemon.position][conditionid]
        local slotCondition = self.dex.conditions:getByID(conditionid)
        callback = slotCondition[callbackName]
        if (callback ~= nil) or (getKey and slotConditionState[getKey]) then
            __TS__ArrayPush(
                handlers,
                self:resolvePriority({effect = slotCondition, callback = callback, state = slotConditionState, ["end"] = side.removeSlotCondition, endCallArgs = {side, pokemon, slotCondition.id}, effectHolder = side}, callbackName)
            )
        end
    end
    return handlers
end
function Battle.prototype.findBattleEventHandlers(self, callbackName, getKey)
    local handlers = {}
    local callback
    local format = self.format
    callback = format[callbackName]
    if (callback ~= nil) or (getKey and self.formatData[getKey]) then
        __TS__ArrayPush(
            handlers,
            self:resolvePriority({effect = format, callback = callback, state = self.formatData, ["end"] = nil, effectHolder = self}, callbackName)
        )
    end
    if self.events and ((function()
        callback = self.events[callbackName]
        return callback
    end)() ~= nil) then
        for ____, handler in __TS__Iterator(callback) do
            local state = (((handler.target.effectType == "Format") and (function() return self.formatData end)) or (function() return nil end))()
            __TS__ArrayPush(handlers, {effect = handler.target, callback = handler.callback, state = state, ["end"] = nil, effectHolder = self, priority = handler.priority, order = handler.order, subOrder = handler.subOrder})
        end
    end
    return handlers
end
function Battle.prototype.findFieldEventHandlers(self, field, callbackName, getKey, customHolder)
    local handlers = {}
    local callback
    for id in pairs(field.pseudoWeather) do
        local pseudoWeatherState = field.pseudoWeather[id]
        local pseudoWeather = self.dex.conditions:getByID(id)
        callback = pseudoWeather[callbackName]
        if (callback ~= nil) or (getKey and pseudoWeatherState[getKey]) then
            __TS__ArrayPush(
                handlers,
                self:resolvePriority(
                    {
                        effect = pseudoWeather,
                        callback = callback,
                        state = pseudoWeatherState,
                        ["end"] = ((customHolder and (function() return nil end)) or (function() return field.removePseudoWeather end))(),
                        effectHolder = customHolder or field
                    },
                    callbackName
                )
            )
        end
    end
    local weather = field:getWeather()
    callback = weather[callbackName]
    if (callback ~= nil) or (getKey and self.field.weatherState[getKey]) then
        __TS__ArrayPush(
            handlers,
            self:resolvePriority(
                {
                    effect = weather,
                    callback = callback,
                    state = self.field.weatherState,
                    ["end"] = ((customHolder and (function() return nil end)) or (function() return field.clearWeather end))(),
                    effectHolder = customHolder or field
                },
                callbackName
            )
        )
    end
    local terrain = field:getTerrain()
    callback = terrain[callbackName]
    if (callback ~= nil) or (getKey and field.terrainState[getKey]) then
        __TS__ArrayPush(
            handlers,
            self:resolvePriority(
                {
                    effect = terrain,
                    callback = callback,
                    state = field.terrainState,
                    ["end"] = ((customHolder and (function() return nil end)) or (function() return field.clearTerrain end))(),
                    effectHolder = customHolder or field
                },
                callbackName
            )
        )
    end
    return handlers
end
function Battle.prototype.findSideEventHandlers(self, side, callbackName, getKey, customHolder)
    local handlers = {}
    for id in pairs(side.sideConditions) do
        local sideConditionData = side.sideConditions[id]
        local sideCondition = self.dex.conditions:getByID(id)
        local callback = sideCondition[callbackName]
        if (callback ~= nil) or (getKey and sideConditionData[getKey]) then
            __TS__ArrayPush(
                handlers,
                self:resolvePriority(
                    {
                        effect = sideCondition,
                        callback = callback,
                        state = sideConditionData,
                        ["end"] = ((customHolder and (function() return nil end)) or (function() return side.removeSideCondition end))(),
                        effectHolder = customHolder or side
                    },
                    callbackName
                )
            )
        end
    end
    return handlers
end
function Battle.prototype.onEvent(self, eventid, target, ...)
    local rest = {...}
    if not eventid then
        error(
            __TS__New(TypeError, "Event handlers must have an event to listen to"),
            0
        )
    end
    if not target then
        error(
            __TS__New(TypeError, "Event handlers must have a target"),
            0
        )
    end
    if not #rest then
        error(
            __TS__New(TypeError, "Event handlers must have a callback"),
            0
        )
    end
    if target.effectType ~= "Format" then
        error(
            __TS__New(
                TypeError,
                ((tostring(target.name) .. " is a ") .. tostring(target.effectType)) .. " but only Format targets are supported right now"
            ),
            0
        )
    end
    local callback
    local priority
    local order
    local subOrder
    local data
    if #rest == 1 then
        callback = __TS__Unpack(rest)
        priority = 0
        order = false
        subOrder = 0
    else
        data, callback = __TS__Unpack(rest)
        if type(data) == "table" then
            priority = data.priority or 0
            order = data.order or false
            subOrder = data.subOrder or 0
        else
            priority = data or 0
            order = false
            subOrder = 0
        end
    end
    local eventHandler = {callback = callback, target = target, priority = priority, order = order, subOrder = subOrder}
    if not self.events then
        self.events = {}
    end
    local callbackName = "on" .. eventid
    local eventHandlers = self.events[callbackName]
    if eventHandlers == nil then
        self.events[callbackName] = {eventHandler}
    else
        eventHandlers:push(eventHandler)
    end
end
function Battle.prototype.checkMoveMakesContact(self, move, attacker, defender, announcePads)
    if announcePads == nil then
        announcePads = false
    end
    if move.flags.contact and attacker:hasItem("protectivepads") then
        if announcePads then
            self:add("-activate", defender, self.effect.fullname)
            self:add("-activate", attacker, "item: Protective Pads")
        end
        return false
    end
    return move.flags.contact
end
function Battle.prototype.getPokemon(self, fullname)
    if type(fullname) ~= "string" then
        fullname = fullname.fullname
    end
    for ____, side in ipairs(self.sides) do
        for ____, pokemon in ipairs(side.pokemon) do
            if pokemon.fullname == fullname then
                return pokemon
            end
        end
    end
    return nil
end
function Battle.prototype.getAllPokemon(self)
    local pokemonList = {}
    for ____, side in ipairs(self.sides) do
        __TS__ArrayPush(
            pokemonList,
            __TS__Unpack(side.pokemon)
        )
    end
    return pokemonList
end
function Battle.prototype.getAllActive(self)
    local pokemonList = {}
    for ____, side in ipairs(self.sides) do
        for ____, pokemon in ipairs(side.active) do
            if pokemon and (not pokemon.fainted) then
                __TS__ArrayPush(pokemonList, pokemon)
            end
        end
    end
    return pokemonList
end
function Battle.prototype.makeRequest(self, ____type)
    if ____type then
        self.requestState = ____type
        for ____, side in ipairs(self.sides) do
            side:clearChoice()
        end
    else
        ____type = self.requestState
    end
    for ____, side in ipairs(self.sides) do
        side.activeRequest = nil
    end
    if ____type == "teampreview" then
        local pickedTeamSize = self.ruleTable.pickedTeamSize
        self:add(
            "teampreview" .. tostring(
                ((pickedTeamSize and (function() return "|" .. tostring(pickedTeamSize) end)) or (function() return "" end))()
            )
        )
    end
    local requests = self:getRequests(____type)
    do
        local i = 0
        while i < #self.sides do
            self.sides[i + 1]:emitRequest(requests[i + 1])
            i = i + 1
        end
    end
    if __TS__ArrayEvery(
        self.sides,
        function(____, side) return side:isChoiceDone() end
    ) then
        error(
            __TS__New(Error, "Choices are done immediately after a request"),
            0
        )
    end
end
function Battle.prototype.clearRequest(self)
    self.requestState = ""
    for ____, side in ipairs(self.sides) do
        side.activeRequest = nil
        side:clearChoice()
    end
end
function Battle.prototype.getRequests(self, ____type)
    local requests = Array(_G, #self.sides):fill(nil)
    local ____switch199 = ____type
    local i, i, i
    if ____switch199 == "switch" then
        goto ____switch199_case_0
    elseif ____switch199 == "teampreview" then
        goto ____switch199_case_1
    end
    goto ____switch199_case_default
    ::____switch199_case_0::
    do
        do
            i = 0
            while i < #self.sides do
                do
                    local side = self.sides[i + 1]
                    if not side.pokemonLeft then
                        goto __continue200
                    end
                    local switchTable = __TS__ArrayMap(
                        side.active,
                        function(____, pokemon) return not (not pokemon.switchFlag) end
                    )
                    if __TS__ArraySome(switchTable, Boolean) then
                        requests[i + 1] = {
                            forceSwitch = switchTable,
                            side = side:getRequestData()
                        }
                    end
                end
                ::__continue200::
                i = i + 1
            end
        end
        goto ____switch199_end
    end
    ::____switch199_case_1::
    do
        do
            i = 0
            while i < #self.sides do
                local side = self.sides[i + 1]
                local maxChosenTeamSize = self.ruleTable.pickedTeamSize or nil
                requests[i + 1] = {
                    teamPreview = true,
                    maxChosenTeamSize = maxChosenTeamSize,
                    side = side:getRequestData()
                }
                i = i + 1
            end
        end
        goto ____switch199_end
    end
    ::____switch199_case_default::
    do
        do
            i = 0
            while i < #self.sides do
                do
                    local side = self.sides[i + 1]
                    if not side.pokemonLeft then
                        goto __continue205
                    end
                    local activeData = __TS__ArrayMap(
                        side.active,
                        function(____, pokemon) return pokemon:getMoveRequestData() end
                    )
                    requests[i + 1] = {
                        active = activeData,
                        side = side:getRequestData()
                    }
                    if side.allySide then
                        requests[i + 1].ally = side.allySide:getRequestData(true)
                    end
                end
                ::__continue205::
                i = i + 1
            end
        end
        goto ____switch199_end
    end
    ::____switch199_end::
    local multipleRequestsExist = #__TS__ArrayFilter(requests, Boolean) >= 2
    do
        local i = 0
        while i < #self.sides do
            if requests[i + 1] then
                if (not self.supportCancel) or (not multipleRequestsExist) then
                    requests[i + 1].noCancel = true
                end
            else
                requests[i + 1] = {
                    wait = true,
                    side = self.sides[i + 1]:getRequestData()
                }
            end
            i = i + 1
        end
    end
    return requests
end
function Battle.prototype.tiebreak(self)
    if self.ended then
        return false
    end
    __TS__ArrayPush(self.inputLog, ">tiebreak")
    self:add("message", "Time's up! Going to tiebreaker...")
    local notFainted = __TS__ArrayMap(
        self.sides,
        function(____, side) return #__TS__ArrayFilter(
            side.pokemon,
            function(____, pokemon) return not pokemon.fainted end
        ) end
    )
    self:add(
        "-message",
        table.concat(
            __TS__ArrayMap(
                self.sides,
                function(____, side, i) return ((side.name .. ": ") .. tostring(notFainted[i + 1])) .. " Pokemon left" end
            ),
            "; " or ","
        )
    )
    local maxNotFainted = math.max(
        __TS__Unpack(notFainted)
    )
    local tiedSides = __TS__ArrayFilter(
        self.sides,
        function(____, side, i) return notFainted[i + 1] == maxNotFainted end
    )
    if #tiedSides <= 1 then
        return self:win(tiedSides[1])
    end
    local hpPercentage = __TS__ArrayMap(
        tiedSides,
        function(____, side) return (__TS__ArrayReduce(
            __TS__ArrayMap(
                side.pokemon,
                function(____, pokemon) return pokemon.hp / pokemon.maxhp end
            ),
            function(____, a, b) return a + b end
        ) * 100) / 6 end
    )
    self:add(
        "-message",
        table.concat(
            __TS__ArrayMap(
                tiedSides,
                function(____, side, i) return ((side.name .. ": ") .. tostring(
                    math.floor(hpPercentage[i + 1] + 0.5)
                )) .. "% total HP left" end
            ),
            "; " or ","
        )
    )
    local maxPercentage = math.max(
        __TS__Unpack(hpPercentage)
    )
    tiedSides = __TS__ArrayFilter(
        tiedSides,
        function(____, side, i) return hpPercentage[i + 1] == maxPercentage end
    )
    if #tiedSides <= 1 then
        return self:win(tiedSides[1])
    end
    local hpTotal = __TS__ArrayMap(
        tiedSides,
        function(____, side) return __TS__ArrayReduce(
            __TS__ArrayMap(
                side.pokemon,
                function(____, pokemon) return pokemon.hp end
            ),
            function(____, a, b) return a + b end
        ) end
    )
    self:add(
        "-message",
        table.concat(
            __TS__ArrayMap(
                tiedSides,
                function(____, side, i) return ((side.name .. ": ") .. tostring(
                    math.floor(hpTotal[i + 1] + 0.5)
                )) .. " total HP left" end
            ),
            "; " or ","
        )
    )
    local maxTotal = math.max(
        __TS__Unpack(hpTotal)
    )
    tiedSides = __TS__ArrayFilter(
        tiedSides,
        function(____, side, i) return hpTotal[i + 1] == maxTotal end
    )
    if #tiedSides <= 1 then
        return self:win(tiedSides[1])
    end
    return self:tie()
end
function Battle.prototype.forceWin(self, side)
    if side == nil then
        side = nil
    end
    if self.ended then
        return false
    end
    __TS__ArrayPush(
        self.inputLog,
        ((side and (function() return ">forcewin " .. tostring(side) end)) or (function() return ">forcetie" end))()
    )
    return self:win(side)
end
function Battle.prototype.tie(self)
    return self:win()
end
function Battle.prototype.win(self, side)
    if self.ended then
        return false
    end
    if side and (type(side) == "string") then
        side = self:getSide(side)
    elseif (not side) or (not self.sides:includes(side)) then
        side = nil
    end
    self.winner = ((side and (function() return side.name end)) or (function() return "" end))()
    self:add("")
    if side.allySide then
        self:add(
            "win",
            (tostring(side.name) .. " & ") .. tostring(side.allySide.name)
        )
    elseif side then
        self:add("win", side.name)
    else
        self:add("tie")
    end
    self.ended = true
    self.requestState = ""
    for ____, s in ipairs(self.sides) do
        if s then
            s.activeRequest = nil
        end
    end
    return true
end
function Battle.prototype.lose(self, side)
    if type(side) == "string" then
        side = self:getSide(side)
    end
    if not side then
        return
    end
    if self.gameType ~= "freeforall" then
        return self:win(side.foe)
    end
    if not side.pokemonLeft then
        return
    end
    side.pokemonLeft = 0
    side.active[0]:faint()
    self:faintMessages(false, true)
    if (not self.ended) and side.requestState then
        side:emitRequest(
            {
                wait = true,
                side = side:getRequestData()
            }
        )
        side:clearChoice()
        if self:allChoicesDone() then
            self:commitDecisions()
        end
    end
    return true
end
function Battle.prototype.canSwitch(self, side)
    return #self:possibleSwitches(side)
end
function Battle.prototype.getRandomSwitchable(self, side)
    local canSwitchIn = self:possibleSwitches(side)
    return ((#canSwitchIn and (function() return self:sample(canSwitchIn) end)) or (function() return nil end))()
end
function Battle.prototype.possibleSwitches(self, side)
    if not side.pokemonLeft then
        return {}
    end
    local canSwitchIn = {}
    do
        local i = #side.active
        while i < #side.pokemon do
            local pokemon = side.pokemon[i + 1]
            if not pokemon.fainted then
                __TS__ArrayPush(canSwitchIn, pokemon)
            end
            i = i + 1
        end
    end
    return canSwitchIn
end
function Battle.prototype.swapPosition(self, pokemon, newPosition, attributes)
    if newPosition >= pokemon.side.active.length then
        error(
            __TS__New(Error, "Invalid swap position"),
            0
        )
    end
    local target = pokemon.side.active[newPosition]
    if (newPosition ~= 1) and ((not target) or target.fainted) then
        return false
    end
    self:add("swap", pokemon, newPosition, attributes or "")
    local side = pokemon.side
    side.pokemon[pokemon.position] = target
    side.pokemon[newPosition] = pokemon
    side.active[pokemon.position] = side.pokemon[pokemon.position]
    side.active[newPosition] = side.pokemon[newPosition]
    if target then
        target.position = pokemon.position
    end
    pokemon.position = newPosition
    self:runEvent("Swap", target, pokemon)
    self:runEvent("Swap", pokemon, target)
    return true
end
function Battle.prototype.getAtSlot(self, slot)
    if not slot then
        return nil
    end
    local side = self.sides[(slot:charCodeAt(1) - 49) + 1]
    local position = slot:charCodeAt(2) - 97
    local positionOffset = math.floor(side.n / 2) * #side.active
    return side.active[(position - positionOffset) + 1]
end
function Battle.prototype.faint(self, pokemon, source, effect)
    pokemon:faint(source, effect)
end
function Battle.prototype.nextTurn(self)
    self.turn = self.turn + 1
    self.lastSuccessfulMoveThisTurn = nil
    local trappedBySide = {}
    local stalenessBySide = {}
    for ____, side in ipairs(self.sides) do
        local sideTrapped = true
        local sideStaleness
        for ____, pokemon in ipairs(side.active) do
            do
                if not pokemon then
                    goto __continue266
                end
                pokemon.moveThisTurn = ""
                pokemon.newlySwitched = false
                pokemon.moveLastTurnResult = pokemon.moveThisTurnResult
                pokemon.moveThisTurnResult = nil
                if self.turn ~= 1 then
                    pokemon.usedItemThisTurn = false
                    pokemon.statsRaisedThisTurn = false
                    pokemon.statsLoweredThisTurn = false
                    pokemon.hurtThisTurn = nil
                end
                pokemon.maybeDisabled = false
                for ____, moveSlot in ipairs(pokemon.moveSlots) do
                    moveSlot.disabled = false
                    moveSlot.disabledSource = ""
                end
                self:runEvent("DisableMove", pokemon)
                if not pokemon.ateBerry then
                    pokemon:disableMove("belch")
                end
                if not pokemon:getItem().isBerry then
                    pokemon:disableMove("stuffcheeks")
                end
                if pokemon:getLastAttackedBy() and (self.gen >= 7) then
                    pokemon.knownType = true
                end
                do
                    local i = #pokemon.attackedBy - 1
                    while i >= 0 do
                        local attack = pokemon.attackedBy[i + 1]
                        if attack.source.isActive then
                            attack.thisTurn = false
                        else
                            __TS__ArraySplice(
                                pokemon.attackedBy,
                                __TS__ArrayIndexOf(pokemon.attackedBy, attack),
                                1
                            )
                        end
                        i = i - 1
                    end
                end
                if self.gen >= 7 then
                    local seenPokemon = pokemon.illusion or pokemon
                    local realTypeString = table.concat(
                        seenPokemon:getTypes(true),
                        "/" or ","
                    )
                    if realTypeString ~= seenPokemon.apparentType then
                        self:add("-start", pokemon, "typechange", realTypeString, "[silent]")
                        seenPokemon.apparentType = realTypeString
                        if pokemon.addedType then
                            self:add("-start", pokemon, "typeadd", pokemon.addedType, "[silent]")
                        end
                    end
                end
                pokemon.trapped = (function(o, i, v)
                    o[i] = v
                    return v
                end)(pokemon, "maybeTrapped", false)
                self:runEvent("TrapPokemon", pokemon)
                if (not pokemon.knownType) or self.dex:getImmunity("trapped", pokemon) then
                    self:runEvent("MaybeTrapPokemon", pokemon)
                end
                if self.gen > 2 then
                    for ____, source in ipairs(
                        pokemon:foes()
                    ) do
                        do
                            local species = (source.illusion or source).species
                            if not species.abilities then
                                goto __continue282
                            end
                            for abilitySlot in pairs(species.abilities) do
                                do
                                    local abilityName = species.abilities[abilitySlot]
                                    if abilityName == source.ability then
                                        goto __continue284
                                    end
                                    local ruleTable = self.ruleTable
                                    if (ruleTable:has("+hackmons") or (not ruleTable:has("obtainableabilities"))) and (not self.format.team) then
                                        goto __continue284
                                    elseif (abilitySlot == "H") and species.unreleasedHidden then
                                        goto __continue284
                                    end
                                    local ability = self.dex.abilities:get(abilityName)
                                    if ruleTable:has(
                                        "-ability:" .. tostring(ability.id)
                                    ) then
                                        goto __continue284
                                    end
                                    if pokemon.knownType and (not self.dex:getImmunity("trapped", pokemon)) then
                                        goto __continue284
                                    end
                                    self:singleEvent("FoeMaybeTrapPokemon", ability, {}, pokemon, source)
                                end
                                ::__continue284::
                            end
                        end
                        ::__continue282::
                    end
                end
                if pokemon.fainted then
                    goto __continue266
                end
                sideTrapped = sideTrapped and pokemon.trapped
                local staleness = pokemon.volatileStaleness or pokemon.staleness
                if staleness then
                    sideStaleness = ((sideStaleness == "external") and sideStaleness) or staleness
                end
                pokemon.activeTurns = pokemon.activeTurns + 1
            end
            ::__continue266::
        end
        __TS__ArrayPush(trappedBySide, sideTrapped)
        __TS__ArrayPush(stalenessBySide, sideStaleness)
        side.faintedLastTurn = side.faintedThisTurn
        side.faintedThisTurn = nil
    end
    if self:maybeTriggerEndlessBattleClause(trappedBySide, stalenessBySide) then
        return
    end
    if (self.gameType == "triples") and __TS__ArrayEvery(
        self.sides,
        function(____, side) return side.pokemonLeft == 1 end
    ) then
        local actives = self:getAllActive()
        if (#actives > 1) and (not actives[1]:isAdjacent(actives[2])) then
            self:swapPosition(actives[1], 1, "[silent]")
            self:swapPosition(actives[2], 1, "[silent]")
            self:add("-center")
        end
    end
    self:add("turn", self.turn)
    if self.gameType == "multi" then
        for ____, side in ipairs(self.sides) do
            if side:canDynamaxNow() then
                if self.turn == 1 then
                    self:addSplit(side.id, {"-candynamax", side.id})
                else
                    self:add("-candynamax", side.id)
                end
            end
        end
    end
    if self.gen == 2 then
        self.quickClawRoll = self:randomChance(60, 256)
    end
    if self.gen == 3 then
        self.quickClawRoll = self:randomChance(1, 5)
    end
    self:makeRequest("move")
end
function Battle.prototype.maybeTriggerEndlessBattleClause(self, trappedBySide, stalenessBySide)
    if self.turn <= 100 then
        return
    end
    if self.turn >= 1000 then
        self:add("message", "It is turn 1000. You have hit the turn limit!")
        self:tie()
        return true
    end
    if (((self.turn >= 500) and ((self.turn % 100) == 0)) or ((self.turn >= 900) and ((self.turn % 10) == 0))) or (self.turn >= 990) then
        local turnsLeft = 1000 - self.turn
        local turnsLeftText = ((turnsLeft == 1) and "1 turn") or (tostring(turnsLeft) .. " turns")
        self:add("bigerror", ("You will auto-tie if the battle doesn't end in " .. turnsLeftText) .. " (on turn 1000).")
    end
    if not self.ruleTable:has("endlessbattleclause") then
        return
    end
    if self.format.gameType == "freeforall" then
        return
    end
    if self.gen <= 1 then
        local noProgressPossible = __TS__ArrayEvery(
            self.sides,
            function(____, side)
                local foeAllGhosts = __TS__ArrayEvery(
                    side.foe.pokemon,
                    function(____, pokemon) return pokemon.types:includes("Ghost") end
                )
                local foeAllTransform = __TS__ArrayEvery(
                    side.foe.pokemon,
                    function(____, pokemon) return ((self.dex.currentMod ~= "gen1stadium") or (pokemon.species.id ~= "ditto")) and __TS__ArrayEvery(
                        pokemon.moves,
                        function(____, moveid) return moveid == "transform" end
                    ) end
                )
                return __TS__ArrayEvery(
                    side.pokemon,
                    function(____, pokemon) return ((pokemon.status == "frz") or (__TS__ArrayEvery(
                        pokemon.moves,
                        function(____, moveid) return moveid == "transform" end
                    ) and foeAllTransform)) or (__TS__ArrayEvery(
                        pokemon.moveSlots,
                        function(____, slot) return slot.pp == 0 end
                    ) and foeAllGhosts) end
                )
            end
        )
        if noProgressPossible then
            self:add("-message", "This battle cannot progress. Endless Battle Clause activated!")
            return self:tie()
        end
    end
    if (not __TS__ArrayEvery(
        stalenessBySide,
        function(____, s) return not (not s) end
    )) or (not __TS__ArraySome(
        stalenessBySide,
        function(____, s) return s == "external" end
    )) then
        return
    end
    local canSwitch = {}
    for ____, ____value in __TS__Iterator(
        trappedBySide:entries()
    ) do
        local i
        i = ____value[1]
        local trapped
        trapped = ____value[2]
        canSwitch[i] = false
        if trapped then
            break
        end
        local side = self.sides[i]
        for ____, pokemon in ipairs(side.pokemon) do
            if (not pokemon.fainted) and (not (pokemon.volatileStaleness or pokemon.staleness)) then
                canSwitch[i] = true
                break
            end
        end
    end
    if __TS__ArrayEvery(
        canSwitch,
        function(____, s) return s end
    ) then
        return
    end
    local losers = {}
    for ____, side in ipairs(self.sides) do
        local berry = false
        local cycle = false
        for ____, pokemon in ipairs(side.pokemon) do
            berry = RESTORATIVE_BERRIES:has(
                toID(_G, pokemon.set.item)
            )
            if ({"harvest", "pickup"}):includes(
                toID(_G, pokemon.set.ability)
            ) or pokemon.set.moves:map(toID):includes("recycle") then
                cycle = true
            end
            if berry and cycle then
                break
            end
        end
        if berry and cycle then
            __TS__ArrayPush(losers, side)
        end
    end
    if #losers == 1 then
        local loser = losers[1]
        self:add("-message", loser.name .. "'s team started with the rudimentary means to perform restorative berry-cycling and thus loses.")
        return self:win(loser.foe)
    end
    if #losers == #self.sides then
        self:add("-message", "Each side's team started with the rudimentary means to perform restorative berry-cycling.")
    end
    return self:tie()
end
function Battle.prototype.start(self)
    if self.deserialized then
        return
    end
    if not __TS__ArrayEvery(
        self.sides,
        function(____, side) return not (not side) end
    ) then
        error(
            __TS__New(
                Error,
                "Missing sides: " .. tostring(self.sides)
            ),
            0
        )
    end
    if self.started then
        error(
            __TS__New(Error, "Battle already started"),
            0
        )
    end
    local format = self.format
    self.started = true
    if self.gameType == "multi" then
        self.sides[2].foe = self.sides[3]
        self.sides[1].foe = self.sides[4]
        self.sides[3].foe = self.sides[2]
        self.sides[4].foe = self.sides[1]
        self.sides[2].allySide = self.sides[4]
        self.sides[1].allySide = self.sides[3]
        self.sides[3].allySide = self.sides[1]
        self.sides[4].allySide = self.sides[2]
        self.sides[3].sideConditions = self.sides[1].sideConditions
        self.sides[4].sideConditions = self.sides[2].sideConditions
    else
        self.sides[2].foe = self.sides[1]
        self.sides[1].foe = self.sides[2]
        if #self.sides > 2 then
            self.sides[3].foe = self.sides[4]
            self.sides[4].foe = self.sides[3]
        end
    end
    for ____, side in ipairs(self.sides) do
        self:add("teamsize", side.id, #side.pokemon)
    end
    self:add("gen", self.gen)
    self:add("tier", format.name)
    if self.rated then
        if self.rated == "Rated battle" then
            self.rated = true
        end
        self:add(
            "rated",
            (((type(self.rated) == "string") and (function() return self.rated end)) or (function() return "" end))()
        )
    end
    if format.onBegin then
        format.onBegin:call(self)
    end
    for ____, rule in __TS__Iterator(
        self.ruleTable:keys()
    ) do
        do
            if ("+*-!"):includes(
                rule:charAt(0)
            ) then
                goto __continue346
            end
            local subFormat = self.dex.formats:get(rule)
            if subFormat.onBegin then
                subFormat.onBegin:call(self)
            end
        end
        ::__continue346::
    end
    if __TS__ArraySome(
        self.sides,
        function(____, side) return not side.pokemon[1] end
    ) then
        error(
            __TS__New(Error, "Battle not started: A player has an empty team."),
            0
        )
    end
    if self.debugMode then
        self:checkEVBalance()
    end
    if format.onTeamPreview then
        format.onTeamPreview:call(self)
    end
    for ____, rule in __TS__Iterator(
        self.ruleTable:keys()
    ) do
        do
            if ("+*-!"):includes(
                rule:charAt(0)
            ) then
                goto __continue353
            end
            local subFormat = self.dex.formats:get(rule)
            if subFormat.onTeamPreview then
                subFormat.onTeamPreview:call(self)
            end
        end
        ::__continue353::
    end
    self.queue:addChoice({choice = "start"})
    self.midTurn = true
    if not self.requestState then
        self:go()
    end
end
function Battle.prototype.restart(self, send)
    if not self.deserialized then
        error(
            __TS__New(Error, "Attempt to restart a battle which has not been deserialized"),
            0
        )
    end
    self.send = send
end
function Battle.prototype.checkEVBalance(self)
    local limitedEVs = nil
    for ____, side in ipairs(self.sides) do
        local sideLimitedEVs = not __TS__ArraySome(
            side.pokemon,
            function(____, pokemon) return __TS__ObjectValues(pokemon.set.evs):reduce(
                function(____, a, b) return a + b end,
                0
            ) > 510 end
        )
        if limitedEVs == nil then
            limitedEVs = sideLimitedEVs
        elseif limitedEVs ~= sideLimitedEVs then
            self:add("bigerror", "Warning: One player isn't adhering to a 510 EV limit, and the other player is.")
        end
    end
end
function Battle.prototype.boost(self, boost, target, source, effect, isSecondary, isSelf)
    if target == nil then
        target = nil
    end
    if source == nil then
        source = nil
    end
    if effect == nil then
        effect = nil
    end
    if isSecondary == nil then
        isSecondary = false
    end
    if isSelf == nil then
        isSelf = false
    end
    if self.event then
        if not target then
            target = self.event.target
        end
        if not source then
            source = self.event.source
        end
        if not effect then
            effect = self.effect
        end
    end
    if not target.hp then
        return 0
    end
    if not target.isActive then
        return false
    end
    if (self.gen > 5) and (not target.side:foePokemonLeft()) then
        return false
    end
    boost = self:runEvent(
        "Boost",
        target,
        source,
        effect,
        __TS__ObjectAssign({}, boost)
    )
    local success = nil
    local boosted = isSecondary
    local boostName
    for ____value in pairs(boost) do
        boostName = ____value
        local currentBoost = {[boostName] = boost[boostName]}
        local boostBy = target:boostBy(currentBoost)
        local msg = "-boost"
        if boost[boostName] < 0 then
            msg = "-unboost"
            boostBy = -boostBy
        end
        if boostBy then
            success = true
            local ____switch376 = effect.id
            if ____switch376 == "bellydrum" then
                goto ____switch376_case_0
            elseif ____switch376 == "bellydrum2" then
                goto ____switch376_case_1
            elseif ____switch376 == "zpower" then
                goto ____switch376_case_2
            end
            goto ____switch376_case_default
            ::____switch376_case_0::
            do
                self:add("-setboost", target, "atk", target.boosts.atk, "[from] move: Belly Drum")
                goto ____switch376_end
            end
            ::____switch376_case_1::
            do
                self:add(msg, target, boostName, boostBy, "[silent]")
                self:hint("In Gen 2, Belly Drum boosts by 2 when it fails.")
                goto ____switch376_end
            end
            ::____switch376_case_2::
            do
                self:add(msg, target, boostName, boostBy, "[zeffect]")
                goto ____switch376_end
            end
            ::____switch376_case_default::
            do
                if not effect then
                    goto ____switch376_end
                end
                if effect.effectType == "Move" then
                    self:add(msg, target, boostName, boostBy)
                elseif effect.effectType == "Item" then
                    self:add(
                        msg,
                        target,
                        boostName,
                        boostBy,
                        "[from] item: " .. tostring(effect.name)
                    )
                else
                    if (effect.effectType == "Ability") and (not boosted) then
                        self:add("-ability", target, effect.name, "boost")
                        boosted = true
                    end
                    self:add(msg, target, boostName, boostBy)
                end
                goto ____switch376_end
            end
            ::____switch376_end::
            self:runEvent("AfterEachBoost", target, source, effect, currentBoost)
        elseif effect and (effect.effectType == "Ability") then
            if isSecondary then
                self:add(msg, target, boostName, boostBy)
            end
        elseif (not isSecondary) and (not isSelf) then
            self:add(msg, target, boostName, boostBy)
        end
    end
    self:runEvent("AfterBoost", target, source, effect, boost)
    if success then
        if __TS__ObjectValues(boost):some(
            function(____, x) return x > 0 end
        ) then
            target.statsRaisedThisTurn = true
        end
        if __TS__ObjectValues(boost):some(
            function(____, x) return x < 0 end
        ) then
            target.statsLoweredThisTurn = true
        end
    end
    return success
end
function Battle.prototype.spreadDamage(self, damage, targetArray, source, effect, instafaint)
    if targetArray == nil then
        targetArray = nil
    end
    if source == nil then
        source = nil
    end
    if effect == nil then
        effect = nil
    end
    if instafaint == nil then
        instafaint = false
    end
    if not targetArray then
        return {0}
    end
    local retVals = {}
    if (type(effect) == "string") or (not effect) then
        effect = self.dex.conditions:getByID(effect or "")
    end
    for ____, ____value in __TS__Iterator(
        damage:entries()
    ) do
        local i
        i = ____value[1]
        local curDamage
        curDamage = ____value[2]
        do
            local target = targetArray[i]
            local targetDamage = curDamage
            if not (targetDamage or (targetDamage == 0)) then
                retVals[i] = targetDamage
                goto __continue393
            end
            if (not target) or (not target.hp) then
                retVals[i] = 0
                goto __continue393
            end
            if not target.isActive then
                retVals[i] = false
                goto __continue393
            end
            if targetDamage ~= 0 then
                targetDamage = self:clampIntRange(targetDamage, 1)
            end
            if effect.id ~= "struggle-recoil" then
                if (effect.effectType == "Weather") and (not target:runStatusImmunity(effect.id)) then
                    self:debug("weather immunity")
                    retVals[i] = 0
                    goto __continue393
                end
                targetDamage = self:runEvent("Damage", target, source, effect, targetDamage, true)
                if not (targetDamage or (targetDamage == 0)) then
                    self:debug("damage event failed")
                    retVals[i] = (((curDamage == true) and (function() return nil end)) or (function() return targetDamage end))()
                    goto __continue393
                end
            end
            if targetDamage ~= 0 then
                targetDamage = self:clampIntRange(targetDamage, 1)
            end
            if self.gen <= 1 then
                if (self.dex.currentMod == "gen1stadium") or ((not ({"recoil", "drain"}):includes(effect.id)) and (effect.effectType ~= "Status")) then
                    self.lastDamage = targetDamage
                end
            end
            retVals[i] = (function()
                targetDamage = target:damage(targetDamage, source, effect)
                return targetDamage
            end)()
            if targetDamage ~= 0 then
                target.hurtThisTurn = target.hp
            end
            if source and (effect.effectType == "Move") then
                source.lastDamage = targetDamage
            end
            local name = ((effect.fullname == "tox") and "psn") or effect.fullname
            local ____switch407 = effect.id
            if ____switch407 == "partiallytrapped" then
                goto ____switch407_case_0
            elseif ____switch407 == "powder" then
                goto ____switch407_case_1
            elseif ____switch407 == "confused" then
                goto ____switch407_case_2
            end
            goto ____switch407_case_default
            ::____switch407_case_0::
            do
                self:add(
                    "-damage",
                    target,
                    target.getHealth,
                    "[from] " .. tostring(self.effectState.sourceEffect.fullname),
                    "[partiallytrapped]"
                )
                goto ____switch407_end
            end
            ::____switch407_case_1::
            do
                self:add("-damage", target, target.getHealth, "[silent]")
                goto ____switch407_end
            end
            ::____switch407_case_2::
            do
                self:add("-damage", target, target.getHealth, "[from] confusion")
                goto ____switch407_end
            end
            ::____switch407_case_default::
            do
                if (effect.effectType == "Move") or (not name) then
                    self:add("-damage", target, target.getHealth)
                elseif source and ((source ~= target) or (effect.effectType == "Ability")) then
                    self:add(
                        "-damage",
                        target,
                        target.getHealth,
                        "[from] " .. tostring(name),
                        "[of] " .. tostring(source)
                    )
                else
                    self:add(
                        "-damage",
                        target,
                        target.getHealth,
                        "[from] " .. tostring(name)
                    )
                end
                goto ____switch407_end
            end
            ::____switch407_end::
            if targetDamage and (effect.effectType == "Move") then
                if ((self.gen <= 1) and effect.recoil) and source then
                    if (self.dex.currentMod ~= "gen1stadium") or (target.hp > 0) then
                        local amount = self:clampIntRange(
                            math.floor((targetDamage * effect.recoil[0]) / effect.recoil[1]),
                            1
                        )
                        self:damage(amount, source, target, "recoil")
                    end
                end
                if ((self.gen <= 4) and effect.drain) and source then
                    local amount = self:clampIntRange(
                        math.floor((targetDamage * effect.drain[0]) / effect.drain[1]),
                        1
                    )
                    self:heal(amount, source, target, "drain")
                end
                if ((self.gen > 4) and effect.drain) and source then
                    local amount = math.floor(((targetDamage * effect.drain[0]) / effect.drain[1]) + 0.5)
                    self:heal(amount, source, target, "drain")
                end
            end
        end
        ::__continue393::
    end
    if instafaint then
        for ____, ____value in __TS__Iterator(
            targetArray:entries()
        ) do
            local i
            i = ____value[1]
            local target
            target = ____value[2]
            do
                if (not retVals[i]) or (not target) then
                    goto __continue417
                end
                if target.hp <= 0 then
                    self:debug(
                        "instafaint: " .. tostring(
                            __TS__ArrayMap(
                                self.faintQueue,
                                function(____, entry) return entry.target.name end
                            )
                        )
                    )
                    self:faintMessages(true)
                    if self.gen <= 2 then
                        target:faint()
                        if self.gen <= 1 then
                            self.queue:clear()
                        end
                    end
                end
            end
            ::__continue417::
        end
    end
    return retVals
end
function Battle.prototype.damage(self, damage, target, source, effect, instafaint)
    if target == nil then
        target = nil
    end
    if source == nil then
        source = nil
    end
    if effect == nil then
        effect = nil
    end
    if instafaint == nil then
        instafaint = false
    end
    if self.event then
        if not target then
            target = self.event.target
        end
        if not source then
            source = self.event.source
        end
        if not effect then
            effect = self.effect
        end
    end
    return self:spreadDamage({damage}, {target}, source, effect, instafaint)[1]
end
function Battle.prototype.directDamage(self, damage, target, source, effect)
    if source == nil then
        source = nil
    end
    if effect == nil then
        effect = nil
    end
    if self.event then
        if not target then
            target = self.event.target
        end
        if not source then
            source = self.event.source
        end
        if not effect then
            effect = self.effect
        end
    end
    if not target.hp then
        return 0
    end
    if not damage then
        return 0
    end
    damage = self:clampIntRange(damage, 1)
    if (type(effect) == "string") or (not effect) then
        effect = self.dex.conditions:getByID(effect or "")
    end
    if (((self.gen <= 1) and (self.dex.currentMod ~= "gen1stadium")) and ({"confusion", "jumpkick", "highjumpkick"}):includes(effect.id)) and target.volatiles.substitute then
        local hint = "In Gen 1, if a Pokemon with a Substitute hurts itself due to confusion or Jump Kick/Hi Jump Kick recoil and the target"
        if source.volatiles.substitute then
            local ____obj, ____index = source.volatiles.substitute, "hp"
            ____obj[____index] = ____obj[____index] - damage
            if source.volatiles.substitute.hp <= 0 then
                source:removeVolatile("substitute")
                source.subFainted = true
            else
                self:add("-activate", source, "Substitute", "[damage]")
            end
            self:hint(
                tostring(hint) .. " has a Substitute, the target's Substitute takes the damage."
            )
            return damage
        else
            self:hint(
                tostring(hint) .. " does not have a Substitute there is no damage dealt."
            )
            return 0
        end
    end
    damage = target:damage(damage, source, effect)
    local ____switch441 = effect.id
    if ____switch441 == "strugglerecoil" then
        goto ____switch441_case_0
    elseif ____switch441 == "confusion" then
        goto ____switch441_case_1
    end
    goto ____switch441_case_default
    ::____switch441_case_0::
    do
        self:add("-damage", target, target.getHealth, "[from] recoil")
        goto ____switch441_end
    end
    ::____switch441_case_1::
    do
        self:add("-damage", target, target.getHealth, "[from] confusion")
        goto ____switch441_end
    end
    ::____switch441_case_default::
    do
        self:add("-damage", target, target.getHealth)
        goto ____switch441_end
    end
    ::____switch441_end::
    if target.fainted then
        self:faint(target)
    end
    return damage
end
function Battle.prototype.heal(self, damage, target, source, effect)
    if source == nil then
        source = nil
    end
    if effect == nil then
        effect = nil
    end
    if self.event then
        if not target then
            target = self.event.target
        end
        if not source then
            source = self.event.source
        end
        if not effect then
            effect = self.effect
        end
    end
    if effect == "drain" then
        effect = self.dex.conditions:getByID(effect)
    end
    if damage and (damage <= 1) then
        damage = 1
    end
    damage = self:trunc(damage)
    damage = self:runEvent("TryHeal", target, source, effect, damage)
    if not damage then
        return damage
    end
    if not target.hp then
        return false
    end
    if not target.isActive then
        return false
    end
    if target.hp >= target.maxhp then
        return false
    end
    local finalDamage = target:heal(damage, source, effect)
    local ____switch454 = effect.id
    if ____switch454 == "leechseed" then
        goto ____switch454_case_0
    elseif ____switch454 == "rest" then
        goto ____switch454_case_1
    elseif ____switch454 == "drain" then
        goto ____switch454_case_2
    elseif ____switch454 == "wish" then
        goto ____switch454_case_3
    elseif ____switch454 == "zpower" then
        goto ____switch454_case_4
    end
    goto ____switch454_case_default
    ::____switch454_case_0::
    do
    end
    ::____switch454_case_1::
    do
        self:add("-heal", target, target.getHealth, "[silent]")
        goto ____switch454_end
    end
    ::____switch454_case_2::
    do
        self:add(
            "-heal",
            target,
            target.getHealth,
            "[from] drain",
            "[of] " .. tostring(source)
        )
        goto ____switch454_end
    end
    ::____switch454_case_3::
    do
        goto ____switch454_end
    end
    ::____switch454_case_4::
    do
        self:add("-heal", target, target.getHealth, "[zeffect]")
        goto ____switch454_end
    end
    ::____switch454_case_default::
    do
        if not effect then
            goto ____switch454_end
        end
        if effect.effectType == "Move" then
            self:add("-heal", target, target.getHealth)
        elseif source and (source ~= target) then
            self:add(
                "-heal",
                target,
                target.getHealth,
                "[from] " .. tostring(effect.fullname),
                "[of] " .. tostring(source)
            )
        else
            self:add(
                "-heal",
                target,
                target.getHealth,
                "[from] " .. tostring(effect.fullname)
            )
        end
        goto ____switch454_end
    end
    ::____switch454_end::
    self:runEvent("Heal", target, source, effect, finalDamage)
    return finalDamage
end
function Battle.prototype.chain(self, previousMod, nextMod)
    if __TS__ArrayIsArray(previousMod) then
        previousMod = self:trunc((previousMod[1] * 4096) / previousMod[2])
    else
        previousMod = self:trunc(previousMod * 4096)
    end
    if __TS__ArrayIsArray(nextMod) then
        nextMod = self:trunc((nextMod[1] * 4096) / nextMod[2])
    else
        nextMod = self:trunc(nextMod * 4096)
    end
    return bit.arshift((previousMod * nextMod) + 2048, 12) / 4096
end
function Battle.prototype.chainModify(self, numerator, denominator)
    local previousMod = self:trunc(self.event.modifier * 4096)
    if __TS__ArrayIsArray(numerator) then
        denominator = numerator[2]
        numerator = numerator[1]
    end
    local nextMod = 0
    if self.event.ceilModifier then
        nextMod = math.ceil((numerator * 4096) / (denominator or 1))
    else
        nextMod = self:trunc((numerator * 4096) / (denominator or 1))
    end
    self.event.modifier = bit.arshift((previousMod * nextMod) + 2048, 12) / 4096
end
function Battle.prototype.modify(self, value, numerator, denominator)
    if not denominator then
        denominator = 1
    end
    if __TS__ArrayIsArray(numerator) then
        denominator = numerator[2]
        numerator = numerator[1]
    end
    local tr = self.trunc
    local modifier = tr(_G, (numerator * 4096) / denominator)
    return tr(
        _G,
        ((tr(_G, value * modifier) + 2048) - 1) / 4096
    )
end
function Battle.prototype.spreadModify(self, baseStats, set)
    local modStats = {atk = 10, def = 10, spa = 10, spd = 10, spe = 10}
    local tr = self.trunc
    local statName
    for ____value in pairs(modStats) do
        statName = ____value
        local stat = baseStats[statName]
        modStats[statName] = tr(
            _G,
            ((tr(
                _G,
                ((2 * stat) + set.ivs[statName]) + tr(_G, set.evs[statName] / 4)
            ) * set.level) / 100) + 5
        )
    end
    if baseStats.hp ~= nil then
        local stat = baseStats.hp
        modStats.hp = tr(
            _G,
            ((tr(
                _G,
                (((2 * stat) + set.ivs.hp) + tr(_G, set.evs.hp / 4)) + 100
            ) * set.level) / 100) + 10
        )
    end
    return self:natureModify(modStats, set)
end
function Battle.prototype.natureModify(self, stats, set)
    local tr = self.trunc
    local nature = self.dex.natures:get(set.nature)
    local s
    if nature.plus then
        s = nature.plus
        local stat = ((self.ruleTable:has("overflowstatmod") and (function() return math.min(stats[s], 595) end)) or (function() return stats[s] end))()
        stats[s] = tr(
            _G,
            tr(_G, stat * 110, 16) / 100
        )
    end
    if nature.minus then
        s = nature.minus
        local stat = ((self.ruleTable:has("overflowstatmod") and (function() return math.min(stats[s], 728) end)) or (function() return stats[s] end))()
        stats[s] = tr(
            _G,
            tr(_G, stat * 90, 16) / 100
        )
    end
    return stats
end
function Battle.prototype.getCategory(self, move)
    return self.dex.moves:get(move).category or "Physical"
end
function Battle.prototype.randomizer(self, baseDamage)
    local tr = self.trunc
    return tr(
        _G,
        tr(
            _G,
            baseDamage * (100 - self:random(16))
        ) / 100
    )
end
function Battle.prototype.validTargetLoc(self, targetLoc, source, targetType)
    if targetLoc == 0 then
        return true
    end
    local numSlots = self.activePerHalf
    local sourceLoc = source:getLocOf(source)
    if math.abs(targetLoc) > numSlots then
        return false
    end
    local isSelf = sourceLoc == targetLoc
    local isFoe = (((self.gameType == "freeforall") and (function() return not isSelf end)) or (function() return targetLoc > 0 end))()
    local acrossFromTargetLoc = -((numSlots + 1) - targetLoc)
    local isAdjacent = (((targetLoc > 0) and (function() return math.abs(acrossFromTargetLoc - sourceLoc) <= 1 end)) or (function() return math.abs(targetLoc - sourceLoc) == 1 end))()
    if (self.gameType == "freeforall") and (targetType == "adjacentAlly") then
        return isAdjacent
    end
    local ____switch483 = targetType
    if ____switch483 == "randomNormal" then
        goto ____switch483_case_0
    elseif ____switch483 == "scripted" then
        goto ____switch483_case_1
    elseif ____switch483 == "normal" then
        goto ____switch483_case_2
    elseif ____switch483 == "adjacentAlly" then
        goto ____switch483_case_3
    elseif ____switch483 == "adjacentAllyOrSelf" then
        goto ____switch483_case_4
    elseif ____switch483 == "adjacentFoe" then
        goto ____switch483_case_5
    elseif ____switch483 == "any" then
        goto ____switch483_case_6
    end
    goto ____switch483_end
    ::____switch483_case_0::
    do
    end
    ::____switch483_case_1::
    do
    end
    ::____switch483_case_2::
    do
        return isAdjacent
    end
    ::____switch483_case_3::
    do
        return isAdjacent and (not isFoe)
    end
    ::____switch483_case_4::
    do
        return (isAdjacent and (not isFoe)) or isSelf
    end
    ::____switch483_case_5::
    do
        return isAdjacent and isFoe
    end
    ::____switch483_case_6::
    do
        return not isSelf
    end
    ::____switch483_end::
    return false
end
function Battle.prototype.validTarget(self, target, source, targetType)
    return self:validTargetLoc(
        source:getLocOf(target),
        source,
        targetType
    )
end
function Battle.prototype.getTarget(self, pokemon, move, targetLoc, originalTarget)
    move = self.dex.moves:get(move)
    local tracksTarget = move.tracksTarget
    if pokemon:hasAbility({"stalwart", "propellertail"}) then
        tracksTarget = true
    end
    if (tracksTarget and originalTarget) and originalTarget.isActive then
        return originalTarget
    end
    if move.smartTarget then
        local curTarget = pokemon:getAtLoc(targetLoc)
        return (((curTarget and (not curTarget.fainted)) and (function() return curTarget end)) or (function() return self:getRandomTarget(pokemon, move) end))()
    end
    local selfLoc = pokemon:getLocOf(pokemon)
    if (((({"adjacentAlly", "any", "normal"}):includes(move.target) and (targetLoc == selfLoc)) and (not pokemon.volatiles.twoturnmove)) and (not pokemon.volatiles.iceball)) and (not pokemon.volatiles.rollout) then
        return ((move.isFutureMove and (function() return pokemon end)) or (function() return nil end))()
    end
    if (move.target ~= "randomNormal") and self:validTargetLoc(targetLoc, pokemon, move.target) then
        local target = pokemon:getAtLoc(targetLoc)
        if target.fainted then
            if self.gameType == "freeforall" then
                return target
            end
            if target:isAlly(pokemon) then
                return target
            end
        end
        if target and (not target.fainted) then
            return target
        end
    end
    return self:getRandomTarget(pokemon, move)
end
function Battle.prototype.getRandomTarget(self, pokemon, move)
    move = self.dex.moves:get(move)
    if move.target == "adjacentAlly" then
        local adjacentAllies = pokemon:adjacentAllies()
        return ((#adjacentAllies and (function() return self:sample(adjacentAllies) end)) or (function() return nil end))()
    end
    if ({"self", "all", "allySide", "allyTeam", "adjacentAllyOrSelf"}):includes(move.target) then
        return pokemon
    end
    if self.activePerHalf > 2 then
        if ((move.target == "adjacentFoe") or (move.target == "normal")) or (move.target == "randomNormal") then
            local adjacentFoes = pokemon:adjacentFoes()
            if #adjacentFoes then
                return self:sample(adjacentFoes)
            end
            return pokemon.side.foe.active[0]
        end
    end
    return pokemon.side:randomFoe() or pokemon.side.foe.active[0]
end
function Battle.prototype.checkFainted(self)
    for ____, side in ipairs(self.sides) do
        for ____, pokemon in ipairs(side.active) do
            if pokemon.fainted then
                pokemon.status = "fnt"
                pokemon.switchFlag = true
            end
        end
    end
end
function Battle.prototype.faintMessages(self, lastFirst, forceCheck, checkWin)
    if lastFirst == nil then
        lastFirst = false
    end
    if forceCheck == nil then
        forceCheck = false
    end
    if checkWin == nil then
        checkWin = true
    end
    if self.ended then
        return
    end
    local length = #self.faintQueue
    if not length then
        if forceCheck and self:checkWin() then
            return true
        end
        return false
    end
    if lastFirst then
        __TS__ArrayUnshift(self.faintQueue, self.faintQueue[#self.faintQueue])
        table.remove(self.faintQueue)
    end
    local faintQueueLeft
    local faintData
    while #self.faintQueue do
        faintQueueLeft = #self.faintQueue
        faintData = __TS__ArrayShift(self.faintQueue)
        local pokemon = faintData.target
        if (not pokemon.fainted) and self:runEvent("BeforeFaint", pokemon, faintData.source, faintData.effect) then
            self:add("faint", pokemon)
            if pokemon.side.pokemonLeft then
                local ____obj, ____index = pokemon.side, "pokemonLeft"
                ____obj[____index] = ____obj[____index] - 1
            end
            self:runEvent("Faint", pokemon, faintData.source, faintData.effect)
            self:singleEvent(
                "End",
                pokemon:getAbility(),
                pokemon.abilityState,
                pokemon
            )
            pokemon:clearVolatile(false)
            pokemon.fainted = true
            pokemon.illusion = nil
            pokemon.isActive = false
            pokemon.isStarted = false
            pokemon.side.faintedThisTurn = pokemon
            if #self.faintQueue >= faintQueueLeft then
                checkWin = true
            end
        end
    end
    if self.gen <= 1 then
        self.queue:clear()
    elseif (self.gen <= 3) and (self.gameType == "singles") then
        for ____, pokemon in ipairs(
            self:getAllActive()
        ) do
            if self.gen <= 2 then
                self.queue:cancelMove(pokemon)
            else
                self.queue:cancelAction(pokemon)
            end
        end
    end
    if checkWin and self:checkWin(faintData) then
        return true
    end
    if faintData and length then
        self:runEvent("AfterFaint", faintData.target, faintData.source, faintData.effect, length)
    end
    return false
end
function Battle.prototype.checkWin(self, faintData)
    local team1PokemonLeft = self.sides[1].pokemonLeft
    local team2PokemonLeft = self.sides[2].pokemonLeft
    local team3PokemonLeft = (self.gameType == "freeforall") and self.sides[3].pokemonLeft
    local team4PokemonLeft = (self.gameType == "freeforall") and self.sides[4].pokemonLeft
    if self.gameType == "multi" then
        team1PokemonLeft = team1PokemonLeft + self.sides[3].pokemonLeft
        team2PokemonLeft = team2PokemonLeft + self.sides[4].pokemonLeft
    end
    if (((not team1PokemonLeft) and (not team2PokemonLeft)) and (not team3PokemonLeft)) and (not team4PokemonLeft) then
        self:win(
            (((faintData and (self.gen > 4)) and (function() return faintData.target.side end)) or (function() return nil end))()
        )
        return true
    end
    for ____, side in ipairs(self.sides) do
        if not side:foePokemonLeft() then
            self:win(side)
            return true
        end
    end
end
function Battle.prototype.getActionSpeed(self, action)
    if action.choice == "move" then
        local move = action.move
        if action.zmove then
            local zMoveName = self.actions:getZMove(action.move, action.pokemon, true)
            if zMoveName then
                local zMove = self.dex:getActiveMove(zMoveName)
                if zMove.exists and zMove.isZ then
                    move = zMove
                end
            end
        end
        if action.maxMove then
            local maxMoveName = self.actions:getMaxMove(action.maxMove, action.pokemon)
            if maxMoveName then
                local maxMove = self.actions:getActiveMaxMove(action.move, action.pokemon)
                if maxMove.exists and maxMove.isMax then
                    move = maxMove
                end
            end
        end
        local priority = self.dex.moves:get(move.id).priority
        priority = self:singleEvent("ModifyPriority", move, nil, action.pokemon, nil, nil, priority)
        priority = self:runEvent("ModifyPriority", action.pokemon, nil, move, priority)
        action.priority = priority + action.fractionalPriority
        if self.gen > 5 then
            action.move.priority = priority
        end
    end
    if not action.pokemon then
        action.speed = 1
    else
        action.speed = action.pokemon:getActionSpeed()
    end
end
function Battle.prototype.runAction(self, action)
    local pokemonOriginalHP = action.pokemon.hp
    local residualPokemon = {}
    local ____switch538 = action.choice
    if ____switch538 == "start" then
        goto ____switch538_case_0
    elseif ____switch538 == "move" then
        goto ____switch538_case_1
    elseif ____switch538 == "megaEvo" then
        goto ____switch538_case_2
    elseif ____switch538 == "runDynamax" then
        goto ____switch538_case_3
    elseif ____switch538 == "beforeTurnMove" then
        goto ____switch538_case_4
    elseif ____switch538 == "event" then
        goto ____switch538_case_5
    elseif ____switch538 == "team" then
        goto ____switch538_case_6
    elseif ____switch538 == "pass" then
        goto ____switch538_case_7
    elseif ____switch538 == "instaswitch" then
        goto ____switch538_case_8
    elseif ____switch538 == "switch" then
        goto ____switch538_case_9
    elseif ____switch538 == "runUnnerve" then
        goto ____switch538_case_10
    elseif ____switch538 == "runSwitch" then
        goto ____switch538_case_11
    elseif ____switch538 == "runPrimal" then
        goto ____switch538_case_12
    elseif ____switch538 == "shift" then
        goto ____switch538_case_13
    elseif ____switch538 == "beforeTurn" then
        goto ____switch538_case_14
    elseif ____switch538 == "residual" then
        goto ____switch538_case_15
    end
    goto ____switch538_end
    ::____switch538_case_0::
    do
        do
            for ____, side in ipairs(self.sides) do
                if side.pokemonLeft then
                    side.pokemonLeft = #side.pokemon
                end
            end
            self:add("start")
            if self.format.onBattleStart then
                self.format.onBattleStart:call(self)
            end
            for ____, rule in __TS__Iterator(
                self.ruleTable:keys()
            ) do
                do
                    if ("+*-!"):includes(
                        rule:charAt(0)
                    ) then
                        goto __continue543
                    end
                    local subFormat = self.dex.formats:get(rule)
                    if subFormat.onBattleStart then
                        subFormat.onBattleStart:call(self)
                    end
                end
                ::__continue543::
            end
            for ____, side in ipairs(self.sides) do
                do
                    local i = 0
                    while i < #side.active do
                        if not side.pokemonLeft then
                            side.active[i + 1] = side.pokemon[i + 1]
                            side.active[i + 1].fainted = true
                            side.active[i + 1].hp = 0
                        else
                            self.actions:switchIn(side.pokemon[i + 1], i)
                        end
                        i = i + 1
                    end
                end
            end
            for ____, pokemon in ipairs(
                self:getAllPokemon()
            ) do
                self:singleEvent(
                    "Start",
                    self.dex.conditions:getByID(pokemon.species.id),
                    pokemon.speciesState,
                    pokemon
                )
            end
            self.midTurn = true
            goto ____switch538_end
        end
    end
    ::____switch538_case_1::
    do
        if not action.pokemon.isActive then
            return false
        end
        if action.pokemon.fainted then
            return false
        end
        self.actions:runMove(action.move, action.pokemon, action.targetLoc, action.sourceEffect, action.zmove, nil, action.maxMove, action.originalTarget)
        goto ____switch538_end
    end
    ::____switch538_case_2::
    do
        self.actions:runMegaEvo(action.pokemon)
        goto ____switch538_end
    end
    ::____switch538_case_3::
    do
        action.pokemon:addVolatile("dynamax")
        action.pokemon.side.dynamaxUsed = true
        if action.pokemon.side.allySide then
            action.pokemon.side.allySide.dynamaxUsed = true
        end
        goto ____switch538_end
    end
    ::____switch538_case_4::
    do
        do
            if not action.pokemon.isActive then
                return false
            end
            if action.pokemon.fainted then
                return false
            end
            self:debug(
                "before turn callback: " .. tostring(action.move.id)
            )
            local target = self:getTarget(action.pokemon, action.move, action.targetLoc)
            if not target then
                return false
            end
            if not action.move.beforeTurnCallback then
                error(
                    __TS__New(Error, "beforeTurnMove has no beforeTurnCallback"),
                    0
                )
            end
            action.move.beforeTurnCallback:call(self, action.pokemon, target)
            goto ____switch538_end
        end
    end
    ::____switch538_case_5::
    do
        self:runEvent(action.event, action.pokemon)
        goto ____switch538_end
    end
    ::____switch538_case_6::
    do
        if action.index == 0 then
            action.pokemon.side.pokemon = {}
        end
        action.pokemon.side.pokemon:push(action.pokemon)
        action.pokemon.position = action.index
        return
    end
    ::____switch538_case_7::
    do
        return
    end
    ::____switch538_case_8::
    do
    end
    ::____switch538_case_9::
    do
        if (action.choice == "switch") and action.pokemon.status then
            self:singleEvent(
                "CheckShow",
                self.dex.abilities:getByID("naturalcure"),
                nil,
                action.pokemon
            )
        end
        if self.actions:switchIn(action.target, action.pokemon.position, action.sourceEffect) == "pursuitfaint" then
            if self.gen <= 4 then
                self:hint("Previously chosen switches continue in Gen 2-4 after a Pursuit target faints.")
                action.priority = -101
                self.queue:unshift(action)
                goto ____switch538_end
            else
                self:hint("A Pokemon can't switch between when it runs out of HP and when it faints")
                goto ____switch538_end
            end
        end
        goto ____switch538_end
    end
    ::____switch538_case_10::
    do
        self:singleEvent(
            "PreStart",
            action.pokemon:getAbility(),
            action.pokemon.abilityState,
            action.pokemon
        )
        goto ____switch538_end
    end
    ::____switch538_case_11::
    do
        self.actions:runSwitch(action.pokemon)
        goto ____switch538_end
    end
    ::____switch538_case_12::
    do
        if not action.pokemon.transformed then
            self:singleEvent(
                "Primal",
                action.pokemon:getItem(),
                action.pokemon.itemState,
                action.pokemon
            )
        end
        goto ____switch538_end
    end
    ::____switch538_case_13::
    do
        if not action.pokemon.isActive then
            return false
        end
        if action.pokemon.fainted then
            return false
        end
        self:swapPosition(action.pokemon, 1)
        goto ____switch538_end
    end
    ::____switch538_case_14::
    do
        self:eachEvent("BeforeTurn")
        goto ____switch538_end
    end
    ::____switch538_case_15::
    do
        self:add("")
        self:clearActiveMove(true)
        self:updateSpeed()
        residualPokemon = __TS__ArrayMap(
            self:getAllActive(),
            function(____, pokemon) return {
                pokemon,
                pokemon:getUndynamaxedHP()
            } end
        )
        self:residualEvent("Residual")
        self:add("upkeep")
        goto ____switch538_end
    end
    ::____switch538_end::
    for ____, side in ipairs(self.sides) do
        for ____, pokemon in ipairs(side.active) do
            if pokemon.forceSwitchFlag then
                if pokemon.hp then
                    self.actions:dragIn(pokemon.side, pokemon.position)
                end
                pokemon.forceSwitchFlag = false
            end
        end
    end
    self:clearActiveMove()
    self:faintMessages()
    if self.ended then
        return true
    end
    if (not self.queue:peek()) or ((self.gen <= 3) and ({"move", "residual"}):includes(
        self.queue:peek().choice
    )) then
        self:checkFainted()
    elseif (action.choice == "megaEvo") and (self.gen == 7) then
        self:eachEvent("Update")
        for ____, ____value in __TS__Iterator(
            self.queue.list:entries()
        ) do
            local i
            i = ____value[1]
            local queuedAction
            queuedAction = ____value[2]
            if (queuedAction.pokemon == action.pokemon) and (queuedAction.choice == "move") then
                __TS__ArraySplice(self.queue.list, i, 1)
                queuedAction.mega = "done"
                self.queue:insertChoice(queuedAction, true)
                break
            end
        end
        return false
    elseif self.queue:peek().choice == "instaswitch" then
        return false
    end
    if self.gen >= 5 then
        self:eachEvent("Update")
        for ____, ____value in ipairs(residualPokemon) do
            local pokemon
            pokemon = ____value[1]
            local originalHP
            originalHP = ____value[2]
            local maxhp = pokemon:getUndynamaxedHP(pokemon.maxhp)
            if (pokemon.hp and (pokemon:getUndynamaxedHP() <= (maxhp / 2))) and (originalHP > (maxhp / 2)) then
                self:runEvent("EmergencyExit", pokemon)
            end
        end
    end
    if action.choice == "runSwitch" then
        local pokemon = action.pokemon
        if (pokemon.hp and (pokemon.hp <= (pokemon.maxhp / 2))) and (pokemonOriginalHP > (pokemon.maxhp / 2)) then
            self:runEvent("EmergencyExit", pokemon)
        end
    end
    local switches = __TS__ArrayMap(
        self.sides,
        function(____, side) return __TS__ArraySome(
            side.active,
            function(____, pokemon) return pokemon and (not (not pokemon.switchFlag)) end
        ) end
    )
    do
        local i = 0
        while i < #self.sides do
            if switches[i + 1] and (not self:canSwitch(self.sides[i + 1])) then
                for ____, pokemon in ipairs(self.sides[i + 1].active) do
                    pokemon.switchFlag = false
                end
                switches[i + 1] = false
            elseif switches[i + 1] then
                for ____, pokemon in ipairs(self.sides[i + 1].active) do
                    if pokemon.switchFlag and (not pokemon.skipBeforeSwitchOutEventFlag) then
                        self:runEvent("BeforeSwitchOut", pokemon)
                        pokemon.skipBeforeSwitchOutEventFlag = true
                        self:faintMessages()
                        if self.ended then
                            return true
                        end
                        if pokemon.fainted then
                            switches[i + 1] = __TS__ArraySome(
                                self.sides[i + 1].active,
                                function(____, sidePokemon) return sidePokemon and (not (not sidePokemon.switchFlag)) end
                            )
                        end
                    end
                end
            end
            i = i + 1
        end
    end
    for ____, playerSwitch in ipairs(switches) do
        if playerSwitch then
            self:makeRequest("switch")
            return true
        end
    end
    if self.gen < 5 then
        self:eachEvent("Update")
    end
    if (self.gen >= 8) and (self.queue:peek().choice == "move") then
        self:updateSpeed()
        for ____, queueAction in ipairs(self.queue.list) do
            if queueAction.pokemon then
                self:getActionSpeed(queueAction)
            end
        end
        self.queue:sort()
    end
    return false
end
function Battle.prototype.go(self)
    self:add("")
    self:add(
        "t:",
        math.floor(
            Date:now() / 1000
        )
    )
    if self.requestState then
        self.requestState = ""
    end
    if not self.midTurn then
        self.queue:insertChoice({choice = "beforeTurn"})
        self.queue:addChoice({choice = "residual"})
        self.midTurn = true
    end
    local action
    while (function()
        action = self.queue:shift()
        return action
    end)() do
        self:runAction(action)
        if self.requestState or self.ended then
            return
        end
    end
    self:nextTurn()
    self.midTurn = false
    self.queue:clear()
end
function Battle.prototype.choose(self, sideid, input)
    local side = self:getSide(sideid)
    if not side:choose(input) then
        return false
    end
    if not side:isChoiceDone() then
        side:emitChoiceError(("Incomplete choice: " .. input) .. " - missing other pokemon")
        return false
    end
    if self:allChoicesDone() then
        self:commitDecisions()
    end
    return true
end
function Battle.prototype.makeChoices(self, ...)
    local inputs = {...}
    if #inputs then
        for ____, ____value in __TS__Iterator(
            inputs:entries()
        ) do
            local i
            i = ____value[1]
            local input
            input = ____value[2]
            if input then
                self.sides[i]:choose(input)
            end
        end
    else
        for ____, side in ipairs(self.sides) do
            side:autoChoose()
        end
    end
    self:commitDecisions()
end
function Battle.prototype.commitDecisions(self)
    self:updateSpeed()
    local oldQueue = self.queue.list
    self.queue:clear()
    if not self:allChoicesDone() then
        error(
            __TS__New(Error, "Not all choices done"),
            0
        )
    end
    for ____, side in ipairs(self.sides) do
        local choice = side:getChoice()
        if choice then
            __TS__ArrayPush(
                self.inputLog,
                ((">" .. tostring(side.id)) .. " ") .. choice
            )
        end
    end
    for ____, side in ipairs(self.sides) do
        self.queue:addChoice(side.choice.actions)
    end
    self:clearRequest()
    self.queue:sort()
    __TS__ArrayPush(
        self.queue.list,
        __TS__Unpack(oldQueue)
    )
    self.requestState = ""
    for ____, side in ipairs(self.sides) do
        side.activeRequest = nil
    end
    self:go()
    if (#self.log - self.sentLogPos) > 500 then
        self:sendUpdates()
    end
end
function Battle.prototype.undoChoice(self, sideid)
    local side = self:getSide(sideid)
    if not side.requestState then
        return
    end
    if side.choice.cantUndo then
        side:emitChoiceError("Can't undo: A trapping/disabling effect would cause undo to leak information")
        return
    end
    side:clearChoice()
end
function Battle.prototype.allChoicesDone(self)
    local totalActions = 0
    for ____, side in ipairs(self.sides) do
        if side:isChoiceDone() then
            if not self.supportCancel then
                side.choice.cantUndo = true
            end
            totalActions = totalActions + 1
        end
    end
    return totalActions >= #self.sides
end
function Battle.prototype.hint(self, hint, once, side)
    if self.hints:has(hint) then
        return
    end
    if side then
        self:addSplit(side.id, {"-hint", hint})
    else
        self:add("-hint", hint)
    end
    if once then
        self.hints:add(hint)
    end
end
function Battle.prototype.addSplit(self, side, secret, shared)
    __TS__ArrayPush(
        self.log,
        "|split|" .. tostring(side)
    )
    self:add(
        __TS__Unpack(secret)
    )
    if shared then
        self:add(
            __TS__Unpack(shared)
        )
    else
        __TS__ArrayPush(self.log, "")
    end
end
function Battle.prototype.add(self, ...)
    local parts = {...}
    if not __TS__ArraySome(
        parts,
        function(____, part) return type(part) == "function" end
    ) then
        __TS__ArrayPush(
            self.log,
            "|" .. __TS__ArrayJoin(parts, "|")
        )
        return
    end
    local side = nil
    local secret = {}
    local shared = {}
    for ____, part in ipairs(parts) do
        if type(part) == "function" then
            local split = part(_G)
            if side and (side ~= split.side) then
                error(
                    __TS__New(Error, "Multiple sides passed to add"),
                    0
                )
            end
            side = split.side
            __TS__ArrayPush(secret, split.secret)
            __TS__ArrayPush(shared, split.shared)
        else
            __TS__ArrayPush(secret, part)
            __TS__ArrayPush(shared, part)
        end
    end
    self:addSplit(side, secret, shared)
end
function Battle.prototype.addMove(self, ...)
    local args = {...}
    self.lastMoveLine = #self.log
    __TS__ArrayPush(
        self.log,
        "|" .. __TS__ArrayJoin(args, "|")
    )
end
function Battle.prototype.attrLastMove(self, ...)
    local args = {...}
    if self.lastMoveLine < 0 then
        return
    end
    if self.log[self.lastMoveLine + 1]:startsWith("|-anim|") then
        if args:includes("[still]") then
            __TS__ArraySplice(self.log, self.lastMoveLine, 1)
            self.lastMoveLine = -1
            return
        end
    elseif args:includes("[still]") then
        local parts = __TS__StringSplit(self.log[self.lastMoveLine + 1], "|")
        parts[5] = ""
        self.log[self.lastMoveLine + 1] = table.concat(parts, "|" or ",")
    end
    local ____obj, ____index = self.log, self.lastMoveLine + 1
    ____obj[____index] = tostring(____obj[____index]) .. ("|" .. __TS__ArrayJoin(args, "|"))
end
function Battle.prototype.retargetLastMove(self, newTarget)
    if self.lastMoveLine < 0 then
        return
    end
    local parts = __TS__StringSplit(self.log[self.lastMoveLine + 1], "|")
    parts[5] = tostring(newTarget)
    self.log[self.lastMoveLine + 1] = table.concat(parts, "|" or ",")
end
function Battle.prototype.debug(self, activity)
    if self.debugMode then
        self:add("debug", activity)
    end
end
function Battle.extractUpdateForSide(self, data, side)
    if side == nil then
        side = "spectator"
    end
    if side == "omniscient" then
        return __TS__StringReplace(data, nil, "\n$1")
    end
    local ____switch657 = side
    if ____switch657 == "p1" then
        goto ____switch657_case_0
    elseif ____switch657 == "p2" then
        goto ____switch657_case_1
    elseif ____switch657 == "p3" then
        goto ____switch657_case_2
    elseif ____switch657 == "p4" then
        goto ____switch657_case_3
    end
    goto ____switch657_end
    ::____switch657_case_0::
    do
        data = __TS__StringReplace(data, nil, "\n$1")
        goto ____switch657_end
    end
    ::____switch657_case_1::
    do
        data = __TS__StringReplace(data, nil, "\n$1")
        goto ____switch657_end
    end
    ::____switch657_case_2::
    do
        data = __TS__StringReplace(data, nil, "\n$1")
        goto ____switch657_end
    end
    ::____switch657_case_3::
    do
        data = __TS__StringReplace(data, nil, "\n$1")
        goto ____switch657_end
    end
    ::____switch657_end::
    return __TS__StringReplace(data, nil, "\n")
end
function Battle.prototype.getDebugLog(self)
    return ____exports.Battle:extractUpdateForSide(
        table.concat(self.log, "\n" or ","),
        "omniscient"
    )
end
function Battle.prototype.debugError(self, activity)
    self:add("debug", activity)
end
function Battle.prototype.getTeam(self, options)
    local team = options.team
    if type(team) == "string" then
        team = Teams:unpack(team)
    end
    if team then
        return team
    end
    if not options.seed then
        options.seed = PRNG:generateSeed()
    end
    if not self.teamGenerator then
        self.teamGenerator = Teams:getGenerator(self.format, options.seed)
    else
        self.teamGenerator:setSeed(options.seed)
    end
    team = self.teamGenerator:getTeam(options)
    return team
end
function Battle.prototype.setPlayer(self, slot, options)
    local side
    local didSomething = true
    local slotNum = __TS__ParseInt(slot[1]) - 1
    if not self.sides[slotNum + 1] then
        local team = self:getTeam(options)
        side = __TS__New(
            Side,
            options.name or ("Player " .. tostring(slotNum + 1)),
            self,
            slotNum,
            team
        )
        if options.avatar then
            side.avatar = "" .. tostring(options.avatar)
        end
        self.sides[slotNum + 1] = side
    else
        side = self.sides[slotNum + 1]
        didSomething = false
        if options.name and (side.name ~= options.name) then
            side.name = options.name
            didSomething = true
        end
        if options.avatar and (side.avatar ~= ("" .. tostring(options.avatar))) then
            side.avatar = "" .. tostring(options.avatar)
            didSomething = true
        end
        if options.team then
            error(
                __TS__New(
                    Error,
                    ("Player " .. tostring(slot)) .. " already has a team!"
                ),
                0
            )
        end
    end
    if options.team and (type(options.team) ~= "string") then
        options.team = Teams:pack(options.team)
    end
    if not didSomething then
        return
    end
    __TS__ArrayPush(
        self.inputLog,
        ((">player " .. tostring(slot)) .. " ") .. tostring(
            JSON:stringify(options)
        )
    )
    self:add("player", side.id, side.name, side.avatar, options.rating or "")
    if __TS__ArrayEvery(
        self.sides,
        function(____, playerSide) return not (not playerSide) end
    ) and (not self.started) then
        self:start()
    end
end
function Battle.prototype.join(self, slot, name, avatar, team)
    self:setPlayer(slot, {name = name, avatar = avatar, team = team})
    return self:getSide(slot)
end
function Battle.prototype.sendUpdates(self)
    if self.sentLogPos >= #self.log then
        return
    end
    self:send(
        "update",
        __TS__ArraySlice(self.log, self.sentLogPos)
    )
    self.sentLogPos = #self.log
    if (not self.sentEnd) and self.ended then
        local log = {winner = self.winner, seed = self.prngSeed, turns = self.turn, p1 = self.sides[1].name, p2 = self.sides[2].name, p3 = self.sides[3] and self.sides[3].name, p4 = self.sides[4] and self.sides[4].name, p1team = self.sides[1].team, p2team = self.sides[2].team, p3team = self.sides[3] and self.sides[3].team, p4team = self.sides[4] and self.sides[4].team, score = {self.sides[1].pokemonLeft, self.sides[2].pokemonLeft}, inputLog = self.inputLog}
        if self.sides[3] then
            __TS__ArrayPush(log.score, self.sides[3].pokemonLeft)
        else
            __TS__Delete(log, "p3")
            __TS__Delete(log, "p3team")
        end
        if self.sides[4] then
            __TS__ArrayPush(log.score, self.sides[4].pokemonLeft)
        else
            __TS__Delete(log, "p4")
            __TS__Delete(log, "p4team")
        end
        self:send(
            "end",
            JSON:stringify(log)
        )
        self.sentEnd = true
    end
end
function Battle.prototype.getSide(self, sideid)
    return self.sides[__TS__ParseInt(sideid[1])]
end
function Battle.prototype.destroy(self)
    self.field:destroy()
    self.field = nil
    do
        local i = 0
        while i < #self.sides do
            if self.sides[i + 1] then
                self.sides[i + 1]:destroy()
                self.sides[i + 1] = nil
            end
            i = i + 1
        end
    end
    for ____, action in ipairs(self.queue.list) do
        __TS__Delete(action, "pokemon")
    end
    self.queue.battle = nil
    self.queue = nil
    self.log = {}
end
return ____exports
