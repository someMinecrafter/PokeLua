--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____battle = require("sim/battle")
local Battle = ____battle.Battle
local ____dex = require("sim/dex")
local Dex = ____dex.Dex
local ____field = require("sim/field")
local Field = ____field.Field
local ____pokemon = require("sim/pokemon")
local Pokemon = ____pokemon.Pokemon
local ____prng = require("sim/prng")
local PRNG = ____prng.PRNG
local ____side = require("sim/side")
local Side = ____side.Side
local POSITIONS = "abcdefghijklmnopqrstuvwx"
local BATTLE = __TS__New(Set, {"dex", "gen", "ruleTable", "id", "log", "inherit", "format", "teamGenerator", "HIT_SUBSTITUTE", "NOT_FAIL", "FAIL", "SILENT_FAIL", "field", "sides", "prng", "hints", "deserialized", "queue", "actions"})
local FIELD = __TS__New(Set, {"id", "battle"})
local SIDE = __TS__New(Set, {"battle", "team", "pokemon", "choice", "activeRequest"})
local POKEMON = __TS__New(Set, {"side", "battle", "set", "name", "fullname", "id", "happiness", "level", "pokeball", "baseMoveSlots"})
local CHOICE = __TS__New(Set, {"switchIns"})
local ACTIVE_MOVE = __TS__New(Set, {"move"})
____exports.State = __TS__New(
    (function()
        local ____ = __TS__Class()
        ____.name = ""
        function ____.prototype.____constructor(self)
        end
        function ____.prototype.serializeBattle(self, battle)
            local state = self:serialize(battle, BATTLE, battle)
            state.field = self:serializeField(battle.field)
            state.sides = __TS__New(Array, #battle.sides)
            for ____, ____value in __TS__Iterator(
                battle.sides:entries()
            ) do
                local i
                i = ____value[1]
                local side
                side = ____value[2]
                state.sides[i] = self:serializeSide(side)
            end
            state.prng = battle.prng.seed
            state.hints = Array:from(battle.hints)
            state.log = battle.log
            state.queue = self:serializeWithRefs(battle.queue.list, battle)
            state.formatid = battle.format.id
            return state
        end
        function ____.prototype.deserializeBattle(self, serialized)
            local state = (((type(serialized) == "string") and (function() return JSON:parse(serialized) end)) or (function() return serialized end))()
            local options = {formatid = state.formatid, seed = state.prngSeed, rated = state.rated, debug = state.debugMode, deserialized = true, strictChoices = state.strictChoices}
            for ____, side in __TS__Iterator(state.sides) do
                local team = side.team:split(((side.team.length > 9) and ",") or "")
                options[side.id] = {
                    name = side.name,
                    avatar = side.avatar,
                    team = team:map(
                        function(____, p) return side.pokemon[__TS__Number(p) - 1].set end
                    )
                }
            end
            local battle = __TS__New(Battle, options)
            for ____, ____value in __TS__Iterator(
                state.sides:entries()
            ) do
                local i
                i = ____value[1]
                local s
                s = ____value[2]
                local side = battle.sides[i]
                local ordered = __TS__New(Array, #side.pokemon)
                local team = s.team:split(((s.team.length > 9) and ",") or "")
                for ____, ____value in __TS__Iterator(
                    team:entries()
                ) do
                    local j
                    j = ____value[1]
                    local pos
                    pos = ____value[2]
                    ordered[__TS__Number(pos)] = side.pokemon[j]
                end
                side.pokemon = ordered
            end
            self:deserialize(state, battle, BATTLE, battle)
            self:deserializeField(state.field, battle.field)
            local activeRequests = false
            for ____, ____value in __TS__Iterator(
                state.sides:entries()
            ) do
                local i
                i = ____value[1]
                local side
                side = ____value[2]
                self:deserializeSide(side, battle.sides[i])
                activeRequests = activeRequests or (side.activeRequest == nil)
            end
            if activeRequests then
                local requests = battle:getRequests(battle.requestState)
                for ____, ____value in __TS__Iterator(
                    state.sides:entries()
                ) do
                    local i
                    i = ____value[1]
                    local side
                    side = ____value[2]
                    battle.sides[i].activeRequest = (((side.activeRequest == nil) and (function() return nil end)) or (function() return requests[i] end))()
                end
            end
            battle.prng = __TS__New(PRNG, state.prng)
            local queue = self:deserializeWithRefs(state.queue, battle)
            battle.queue.list = queue
            battle.hints = __TS__New(Set, state.hints)
            battle.log = state.log
            return battle
        end
        function ____.prototype.normalize(self, state)
            state.log = self:normalizeLog(state.log)
            return state
        end
        function ____.prototype.normalizeLog(self, log)
            if not log then
                return log
            end
            local normalized = __TS__ArrayMap(
                (((type(log) == "string") and (function() return __TS__StringSplit(log, "\n") end)) or (function() return log end))(),
                function(____, line) return (line:startsWith("|t:|") and "|t:|") or line end
            )
            return (((type(log) == "string") and (function() return table.concat(normalized, "\n" or ",") end)) or (function() return normalized end))()
        end
        function ____.prototype.serializeField(self, field)
            return self:serialize(field, FIELD, field.battle)
        end
        function ____.prototype.deserializeField(self, state, field)
            self:deserialize(state, field, FIELD, field.battle)
        end
        function ____.prototype.serializeSide(self, side)
            local state = self:serialize(side, SIDE, side.battle)
            state.pokemon = __TS__New(Array, #side.pokemon)
            local team = __TS__New(Array, #side.pokemon)
            for ____, ____value in __TS__Iterator(
                side.pokemon:entries()
            ) do
                local i
                i = ____value[1]
                local pokemon
                pokemon = ____value[2]
                state.pokemon[i] = self:serializePokemon(pokemon)
                team[__TS__ArrayIndexOf(side.team, pokemon.set) + 1] = i + 1
            end
            state.team = __TS__ArrayJoin(team, ((#team > 9) and ",") or "")
            state.choice = self:serializeChoice(side.choice, side.battle)
            if side.activeRequest == nil then
                state.activeRequest = nil
            end
            return state
        end
        function ____.prototype.deserializeSide(self, state, side)
            self:deserialize(state, side, SIDE, side.battle)
            for ____, ____value in __TS__Iterator(
                state.pokemon:entries()
            ) do
                local i
                i = ____value[1]
                local pokemon
                pokemon = ____value[2]
                self:deserializePokemon(pokemon, side.pokemon[i])
            end
            self:deserializeChoice(state.choice, side.choice, side.battle)
        end
        function ____.prototype.serializePokemon(self, pokemon)
            local state = self:serialize(pokemon, POKEMON, pokemon.battle)
            state.set = pokemon.set
            if (#pokemon.baseMoveSlots ~= #pokemon.moveSlots) or (not __TS__ArrayEvery(
                pokemon.baseMoveSlots,
                function(____, ms, i) return ms == pokemon.moveSlots[i + 1] end
            )) then
                state.baseMoveSlots = self:serializeWithRefs(pokemon.baseMoveSlots, pokemon.battle)
            end
            return state
        end
        function ____.prototype.deserializePokemon(self, state, pokemon)
            self:deserialize(state, pokemon, POKEMON, pokemon.battle)
            pokemon.set = state.set
            local baseMoveSlots
            if state.baseMoveSlots then
                baseMoveSlots = self:deserializeWithRefs(state.baseMoveSlots, pokemon.battle)
                for ____, ____value in __TS__Iterator(
                    baseMoveSlots:entries()
                ) do
                    local i
                    i = ____value[1]
                    local baseMoveSlot
                    baseMoveSlot = ____value[2]
                    local moveSlot = pokemon.moveSlots[i]
                    if (moveSlot.id == baseMoveSlot.id) and (not moveSlot.virtual) then
                        baseMoveSlots[i] = moveSlot
                    end
                end
            else
                baseMoveSlots = __TS__ArraySlice(pokemon.moveSlots)
            end
            pokemon.baseMoveSlots = baseMoveSlots
            if state.showCure == nil then
                pokemon.showCure = nil
            end
        end
        function ____.prototype.serializeChoice(self, choice, battle)
            local state = self:serialize(choice, CHOICE, battle)
            state.switchIns = Array:from(choice.switchIns)
            return state
        end
        function ____.prototype.deserializeChoice(self, state, choice, battle)
            self:deserialize(state, choice, CHOICE, battle)
            choice.switchIns = __TS__New(Set, state.switchIns)
        end
        function ____.prototype.isActiveMove(self, obj)
            return (rawget(obj, "hit") ~= nil) and ((rawget(obj, "id") ~= nil) or (rawget(obj, "move") ~= nil))
        end
        function ____.prototype.serializeActiveMove(self, move, battle)
            local base = battle.dex.moves:get(move.id)
            local skip = __TS__New(
                Set,
                {
                    __TS__Spread(ACTIVE_MOVE)
                }
            )
            for ____, ____value in __TS__Iterator(
                __TS__ObjectEntries(base)
            ) do
                local key
                key = ____value[1]
                local value
                value = ____value[2]
                if (type(value) == "table") or (move[key] == value) then
                    skip:add(key)
                end
            end
            local state = self:serialize(move, skip, battle)
            state.move = ("[Move:" .. tostring(move.id)) .. "]"
            return state
        end
        function ____.prototype.deserializeActiveMove(self, state, battle)
            local move = battle.dex:getActiveMove(
                self:fromRef(state.move, battle)
            )
            self:deserialize(state, move, ACTIVE_MOVE, battle)
            return move
        end
        function ____.prototype.serializeWithRefs(self, obj, battle)
            local ____switch42 = __TS__TypeOf(obj)
            local o, key, value
            if ____switch42 == "function" then
                goto ____switch42_case_0
            elseif ____switch42 == "undefined" then
                goto ____switch42_case_1
            elseif ____switch42 == "boolean" then
                goto ____switch42_case_2
            elseif ____switch42 == "number" then
                goto ____switch42_case_3
            elseif ____switch42 == "string" then
                goto ____switch42_case_4
            elseif ____switch42 == "object" then
                goto ____switch42_case_5
            end
            goto ____switch42_case_default
            ::____switch42_case_0::
            do
                return nil
            end
            ::____switch42_case_1::
            do
            end
            ::____switch42_case_2::
            do
            end
            ::____switch42_case_3::
            do
            end
            ::____switch42_case_4::
            do
                return obj
            end
            ::____switch42_case_5::
            do
                if obj == nil then
                    return nil
                end
                if __TS__ArrayIsArray(obj) then
                    local arr = __TS__New(Array, #obj)
                    for ____, ____value in __TS__Iterator(
                        obj:entries()
                    ) do
                        local i
                        i = ____value[1]
                        local o
                        o = ____value[2]
                        arr[i] = self:serializeWithRefs(o, battle)
                    end
                    return arr
                end
                if self:isActiveMove(obj) then
                    return self:serializeActiveMove(obj, battle)
                end
                if self:isReferable(obj) then
                    return self:toRef(obj)
                end
                if obj.constructor ~= Object then
                    error(
                        __TS__New(
                            TypeError,
                            (("Unsupported type " .. tostring(obj.constructor.name)) .. ": ") .. tostring(obj)
                        ),
                        0
                    )
                end
                o = {}
                for ____, ____value in __TS__Iterator(
                    __TS__ObjectEntries(obj)
                ) do
                    key = ____value[1]
                    value = ____value[2]
                    o[key] = self:serializeWithRefs(value, battle)
                end
                return o
            end
            ::____switch42_case_default::
            do
                error(
                    __TS__New(
                        TypeError,
                        (("Unexpected typeof === '" .. __TS__TypeOf(obj)) .. "': ") .. tostring(obj)
                    ),
                    0
                )
            end
            ::____switch42_end::
        end
        function ____.prototype.deserializeWithRefs(self, obj, battle)
            local ____switch51 = __TS__TypeOf(obj)
            local o, key, value
            if ____switch51 == "undefined" then
                goto ____switch51_case_0
            elseif ____switch51 == "boolean" then
                goto ____switch51_case_1
            elseif ____switch51 == "number" then
                goto ____switch51_case_2
            elseif ____switch51 == "string" then
                goto ____switch51_case_3
            elseif ____switch51 == "object" then
                goto ____switch51_case_4
            elseif ____switch51 == "function" then
                goto ____switch51_case_5
            end
            goto ____switch51_case_default
            ::____switch51_case_0::
            do
            end
            ::____switch51_case_1::
            do
            end
            ::____switch51_case_2::
            do
                return obj
            end
            ::____switch51_case_3::
            do
                return self:fromRef(obj, battle) or obj
            end
            ::____switch51_case_4::
            do
                if obj == nil then
                    return nil
                end
                if __TS__ArrayIsArray(obj) then
                    local arr = __TS__New(Array, #obj)
                    for ____, ____value in __TS__Iterator(
                        obj:entries()
                    ) do
                        local i
                        i = ____value[1]
                        local o
                        o = ____value[2]
                        arr[i] = self:deserializeWithRefs(o, battle)
                    end
                    return arr
                end
                if self:isActiveMove(obj) then
                    return self:deserializeActiveMove(obj, battle)
                end
                o = {}
                for ____, ____value in __TS__Iterator(
                    __TS__ObjectEntries(obj)
                ) do
                    key = ____value[1]
                    value = ____value[2]
                    o[key] = self:deserializeWithRefs(value, battle)
                end
                return o
            end
            ::____switch51_case_5::
            do
            end
            ::____switch51_case_default::
            do
                error(
                    __TS__New(
                        TypeError,
                        (("Unexpected typeof === '" .. __TS__TypeOf(obj)) .. "': ") .. tostring(obj)
                    ),
                    0
                )
            end
            ::____switch51_end::
        end
        function ____.prototype.isReferable(self, obj)
            if not self.REFERABLE then
                self.REFERABLE = __TS__New(Set, {Battle, Field, Side, Pokemon, Dex.Condition, Dex.Ability, Dex.Item, Dex.Move, Dex.Species})
            end
            return self.REFERABLE:has(obj.constructor)
        end
        function ____.prototype.toRef(self, obj)
            local id = ((__TS__InstanceOf(obj, Pokemon) and (function() return tostring(obj.side.id) .. __TS__StringAccess(POSITIONS, obj.position) end)) or (function() return tostring(obj.id) end))()
            return ((("[" .. tostring(obj.constructor.name)) .. ((id and ":") or "")) .. id) .. "]"
        end
        function ____.prototype.fromRef(self, ref, battle)
            if (not ref:startsWith("[")) and (not ref:endsWith("]")) then
                return nil
            end
            ref = __TS__StringSubstring(ref, 1, #ref - 1)
            if ref == "Battle" then
                return battle
            end
            if ref == "Field" then
                return battle.field
            end
            local ____type, id = __TS__Unpack(
                __TS__StringSplit(ref, ":")
            )
            local ____switch64 = ____type
            if ____switch64 == "Side" then
                goto ____switch64_case_0
            elseif ____switch64 == "Pokemon" then
                goto ____switch64_case_1
            elseif ____switch64 == "Ability" then
                goto ____switch64_case_2
            elseif ____switch64 == "Item" then
                goto ____switch64_case_3
            elseif ____switch64 == "Move" then
                goto ____switch64_case_4
            elseif ____switch64 == "Condition" then
                goto ____switch64_case_5
            elseif ____switch64 == "Species" then
                goto ____switch64_case_6
            end
            goto ____switch64_case_default
            ::____switch64_case_0::
            do
                return battle.sides[__TS__Number(
                    __TS__StringAccess(id, 1)
                )]
            end
            ::____switch64_case_1::
            do
                return battle.sides[__TS__Number(
                    __TS__StringAccess(id, 1)
                )].pokemon[string.find(
                    POSITIONS,
                    __TS__StringAccess(id, 2),
                    nil,
                    true
                ) or 0]
            end
            ::____switch64_case_2::
            do
                return battle.dex.abilities:get(id)
            end
            ::____switch64_case_3::
            do
                return battle.dex.items:get(id)
            end
            ::____switch64_case_4::
            do
                return battle.dex.moves:get(id)
            end
            ::____switch64_case_5::
            do
                return battle.dex.conditions:get(id)
            end
            ::____switch64_case_6::
            do
                return battle.dex.species:get(id)
            end
            ::____switch64_case_default::
            do
                return nil
            end
            ::____switch64_end::
        end
        function ____.prototype.serialize(self, obj, skip, battle)
            local state = {}
            for ____, ____value in __TS__Iterator(
                __TS__ObjectEntries(obj)
            ) do
                local key
                key = ____value[1]
                local value
                value = ____value[2]
                do
                    if skip:has(key) then
                        goto __continue66
                    end
                    local val = self:serializeWithRefs(value, battle)
                    if type(val) ~= "nil" then
                        state[key] = val
                    end
                end
                ::__continue66::
            end
            return state
        end
        function ____.prototype.deserialize(self, state, obj, skip, battle)
            for ____, ____value in __TS__Iterator(
                __TS__ObjectEntries(state)
            ) do
                local key
                key = ____value[1]
                local value
                value = ____value[2]
                do
                    if skip:has(key) then
                        goto __continue70
                    end
                    obj[key] = self:deserializeWithRefs(value, battle)
                end
                ::__continue70::
            end
        end
        return ____
    end)(),
    true
)
return ____exports
