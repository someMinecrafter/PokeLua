--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____lib = require("lib/index")
local Utils = ____lib.Utils
local ____pokemon = require("sim/pokemon")
local Pokemon = ____pokemon.Pokemon
local ____state = require("sim/state")
local State = ____state.State
local ____dex = require("sim/dex")
local toID = ____dex.toID
____exports.Side = __TS__Class()
local Side = ____exports.Side
Side.name = "Side"
function Side.prototype.____constructor(self, name, battle, sideNum, team)
    self.foe = nil
    self.allySide = nil
    self.lastSelectedMove = ""
    local sideScripts = battle.dex.data.Scripts.side
    if sideScripts then
        __TS__ObjectAssign(self, sideScripts)
    end
    self.battle = battle
    self.id = ({"p1", "p2", "p3", "p4"})[sideNum + 1]
    self.n = sideNum
    self.name = name
    self.avatar = ""
    self.team = team
    self.pokemon = {}
    do
        local i = 0
        while (i < #self.team) and (i < 24) do
            __TS__ArrayPush(
                self.pokemon,
                __TS__New(Pokemon, self.team[i + 1], self)
            )
            self.pokemon[i + 1].position = i
            i = i + 1
        end
    end
    local ____switch5 = self.battle.gameType
    if ____switch5 == "doubles" then
        goto ____switch5_case_0
    elseif ____switch5 == "triples" then
        goto ____switch5_case_1
    elseif ____switch5 == "rotation" then
        goto ____switch5_case_2
    end
    goto ____switch5_case_default
    ::____switch5_case_0::
    do
        self.active = {nil, nil}
        goto ____switch5_end
    end
    ::____switch5_case_1::
    do
    end
    ::____switch5_case_2::
    do
        self.active = {nil, nil, nil}
        goto ____switch5_end
    end
    ::____switch5_case_default::
    do
        self.active = {nil}
    end
    ::____switch5_end::
    self.pokemonLeft = #self.pokemon
    self.faintedLastTurn = nil
    self.faintedThisTurn = nil
    self.zMoveUsed = false
    self.dynamaxUsed = self.battle.gen < 8
    self.sideConditions = {}
    self.slotConditions = {}
    do
        local i = 0
        while i < #self.active do
            self.slotConditions[i + 1] = {}
            i = i + 1
        end
    end
    self.activeRequest = nil
    self.choice = {
        cantUndo = false,
        error = "",
        actions = {},
        forcedSwitchesLeft = 0,
        forcedPassesLeft = 0,
        switchIns = __TS__New(Set),
        zMove = false,
        mega = false,
        ultra = false,
        dynamax = false
    }
    self.lastMove = nil
end
__TS__SetDescriptor(
    Side.prototype,
    "requestState",
    {
        get = function(self)
            if (not self.activeRequest) or self.activeRequest.wait then
                return ""
            end
            if self.activeRequest.teamPreview then
                return "teampreview"
            end
            if self.activeRequest.forceSwitch then
                return "switch"
            end
            return "move"
        end
    },
    true
)
function Side.prototype.toJSON(self)
    return State:serializeSide(self)
end
function Side.prototype.canDynamaxNow(self)
    if (self.battle.gameType == "multi") and ((self.battle.turn % 2) ~= ({1, 1, 0, 0})[self.n + 1]) then
        return false
    end
    return not self.dynamaxUsed
end
function Side.prototype.getChoice(self)
    if (#self.choice.actions > 1) and __TS__ArrayEvery(
        self.choice.actions,
        function(____, action) return action.choice == "team" end
    ) then
        return "team " .. tostring(
            table.concat(
                __TS__ArrayMap(
                    self.choice.actions,
                    function(____, action) return action.pokemon.position + 1 end
                ),
                ", " or ","
            )
        )
    end
    return table.concat(
        __TS__ArrayMap(
            self.choice.actions,
            function(____, action)
                local ____switch19 = action.choice
                local details
                if ____switch19 == "move" then
                    goto ____switch19_case_0
                elseif ____switch19 == "switch" then
                    goto ____switch19_case_1
                elseif ____switch19 == "instaswitch" then
                    goto ____switch19_case_2
                elseif ____switch19 == "team" then
                    goto ____switch19_case_3
                end
                goto ____switch19_case_default
                ::____switch19_case_0::
                do
                    details = ""
                    if action.targetLoc and (#self.active > 1) then
                        details = tostring(details) .. ((" " .. (((action.targetLoc > 0) and "+") or "")) .. tostring(action.targetLoc))
                    end
                    if action.mega then
                        details = tostring(details) .. tostring(((action.pokemon.item == "ultranecroziumz") and " ultra") or " mega")
                    end
                    if action.zmove then
                        details = tostring(details) .. " zmove"
                    end
                    if action.maxMove then
                        details = tostring(details) .. " dynamax"
                    end
                    return ("move " .. action.moveid) .. details
                end
                ::____switch19_case_1::
                do
                end
                ::____switch19_case_2::
                do
                    return "switch " .. tostring(action.target.position + 1)
                end
                ::____switch19_case_3::
                do
                    return "team " .. tostring(action.pokemon.position + 1)
                end
                ::____switch19_case_default::
                do
                    return action.choice
                end
                ::____switch19_end::
            end
        ),
        ", " or ","
    )
end
function Side.prototype.__tostring(self)
    return (tostring(self.id) .. ": ") .. self.name
end
function Side.prototype.getRequestData(self, forAlly)
    local data = {name = self.name, id = self.id, pokemon = {}}
    for ____, pokemon in ipairs(self.pokemon) do
        __TS__ArrayPush(
            data.pokemon,
            pokemon:getSwitchRequestData(forAlly)
        )
    end
    return data
end
function Side.prototype.randomFoe(self)
    local actives = self:foes()
    if not actives.length then
        return nil
    end
    return self.battle:sample(actives)
end
function Side.prototype.foeSidesWithConditions(self)
    if self.battle.gameType == "freeforall" then
        return self.battle.sides:filter(
            function(____, side) return side ~= self end
        )
    end
    return {self.foe}
end
function Side.prototype.foePokemonLeft(self)
    if self.battle.gameType == "freeforall" then
        return self.battle.sides:filter(
            function(____, side) return side ~= self end
        ):map(
            function(____, side) return side.pokemonLeft end
        ):reduce(
            function(____, a, b) return a + b end
        )
    end
    if self.foe.allySide then
        return self.foe.pokemonLeft + self.foe.allySide.pokemonLeft
    end
    return self.foe.pokemonLeft
end
function Side.prototype.allies(self, all)
    local allies = self:activeTeam():filter(
        function(____, ally) return ally end
    )
    if not all then
        allies = allies:filter(
            function(____, ally) return not ally.fainted end
        )
    end
    return allies
end
function Side.prototype.foes(self, all)
    if self.battle.gameType == "freeforall" then
        return self.battle.sides:map(
            function(____, side) return side.active[0] end
        ):filter(
            function(____, pokemon) return (pokemon and (pokemon.side ~= self)) and (all or (not pokemon.fainted)) end
        )
    end
    return self.foe:allies(all)
end
function Side.prototype.activeTeam(self)
    if self.battle.gameType ~= "multi" then
        return self.active
    end
    return self.battle.sides[self.n % 2].active:concat(self.battle.sides[(self.n % 2) + 2].active)
end
function Side.prototype.hasAlly(self, pokemon)
    return (pokemon.side == self) or (pokemon.side == self.allySide)
end
function Side.prototype.addSideCondition(self, status, source, sourceEffect)
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
        source = self.active[1]
    end
    if not source then
        error(
            __TS__New(Error, "setting sidecond without a source"),
            0
        )
    end
    if not source.getSlot then
        source = source.active[1]
    end
    status = self.battle.dex.conditions:get(status)
    if self.sideConditions[status.id] then
        if not status.onSideRestart then
            return false
        end
        return self.battle:singleEvent("SideRestart", status, self.sideConditions[status.id], self, source, sourceEffect)
    end
    self.sideConditions[status.id] = {
        id = status.id,
        target = self,
        source = source,
        sourceSlot = source:getSlot(),
        duration = status.duration
    }
    if status.durationCallback then
        self.sideConditions[status.id].duration = status.durationCallback:call(self.battle, self.active[1], source, sourceEffect)
    end
    if not self.battle:singleEvent("SideStart", status, self.sideConditions[status.id], self, source, sourceEffect) then
        __TS__Delete(self.sideConditions, status.id)
        return false
    end
    return true
end
function Side.prototype.getSideCondition(self, status)
    status = self.battle.dex.conditions:get(status)
    if not self.sideConditions[status.id] then
        return nil
    end
    return status
end
function Side.prototype.getSideConditionData(self, status)
    status = self.battle.dex.conditions:get(status)
    return self.sideConditions[status.id] or nil
end
function Side.prototype.removeSideCondition(self, status)
    status = self.battle.dex.conditions:get(status)
    if not self.sideConditions[status.id] then
        return false
    end
    self.battle:singleEvent("SideEnd", status, self.sideConditions[status.id], self)
    __TS__Delete(self.sideConditions, status.id)
    return true
end
function Side.prototype.addSlotCondition(self, target, status, source, sourceEffect)
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
        source = self.active[1]
    end
    if __TS__InstanceOf(target, Pokemon) then
        target = target.position
    end
    if not source then
        error(
            __TS__New(Error, "setting sidecond without a source"),
            0
        )
    end
    status = self.battle.dex.conditions:get(status)
    if self.slotConditions[target + 1][status.id] then
        if not status.onRestart then
            return false
        end
        return self.battle:singleEvent("Restart", status, self.slotConditions[target + 1][status.id], self, source, sourceEffect)
    end
    local conditionState = (function(o, i, v)
        o[i] = v
        return v
    end)(
        self.slotConditions[target + 1],
        status.id,
        {
            id = status.id,
            target = self,
            source = source,
            sourceSlot = source:getSlot(),
            duration = status.duration
        }
    )
    if status.durationCallback then
        conditionState.duration = status.durationCallback:call(self.battle, self.active[1], source, sourceEffect)
    end
    if not self.battle:singleEvent("Start", status, conditionState, self.active[target + 1], source, sourceEffect) then
        __TS__Delete(self.slotConditions[target + 1], status.id)
        return false
    end
    return true
end
function Side.prototype.getSlotCondition(self, target, status)
    if __TS__InstanceOf(target, Pokemon) then
        target = target.position
    end
    status = self.battle.dex.conditions:get(status)
    if not self.slotConditions[target + 1][status.id] then
        return nil
    end
    return status
end
function Side.prototype.removeSlotCondition(self, target, status)
    if __TS__InstanceOf(target, Pokemon) then
        target = target.position
    end
    status = self.battle.dex.conditions:get(status)
    if not self.slotConditions[target + 1][status.id] then
        return false
    end
    self.battle:singleEvent("End", status, self.slotConditions[target + 1][status.id], self.active[target + 1])
    __TS__Delete(self.slotConditions[target + 1], status.id)
    return true
end
function Side.prototype.send(self, ...)
    local parts = {...}
    local sideUpdate = "|" .. tostring(
        __TS__ArrayJoin(
            __TS__ArrayMap(
                parts,
                function(____, part)
                    if type(part) ~= "function" then
                        return part
                    end
                    return part(_G, self)
                end
            ),
            "|"
        )
    )
    self.battle:send(
        "sideupdate",
        (tostring(self.id) .. "\n") .. sideUpdate
    )
end
function Side.prototype.emitRequest(self, update)
    self.battle:send(
        "sideupdate",
        (tostring(self.id) .. "\n|request|") .. JSON:stringify(update)
    )
    self.activeRequest = update
end
function Side.prototype.emitChoiceError(self, message, unavailable)
    self.choice.error = message
    local ____type = ("[" .. ((unavailable and "Unavailable") or "Invalid")) .. " choice]"
    self.battle:send(
        "sideupdate",
        (((tostring(self.id) .. "\n|error|") .. ____type) .. " ") .. message
    )
    if self.battle.strictChoices then
        error(
            __TS__New(Error, (____type .. " ") .. message),
            0
        )
    end
    return false
end
function Side.prototype.isChoiceDone(self)
    if not self.requestState then
        return true
    end
    if self.choice.forcedSwitchesLeft then
        return false
    end
    if self.requestState == "teampreview" then
        return #self.choice.actions >= self:pickedTeamSize()
    end
    self:getChoiceIndex()
    return #self.choice.actions >= #self.active
end
function Side.prototype.chooseMove(self, moveText, targetLoc, megaDynaOrZ)
    if targetLoc == nil then
        targetLoc = 0
    end
    if megaDynaOrZ == nil then
        megaDynaOrZ = ""
    end
    if self.requestState ~= "move" then
        return self:emitChoiceError(("Can't move: You need a " .. self.requestState) .. " response")
    end
    local index = self:getChoiceIndex()
    if index >= #self.active then
        return self:emitChoiceError("Can't move: You sent more choices than unfainted Pokémon.")
    end
    local autoChoose = not moveText
    local pokemon = self.active[index + 1]
    local request = pokemon:getMoveRequestData()
    local moveid = ""
    local targetType = ""
    if autoChoose then
        moveText = 1
    end
    if (type(moveText) == "number") or (moveText and nil:test(moveText)) then
        local moveIndex = __TS__Number(moveText) - 1
        if ((moveIndex < 0) or (moveIndex >= #request.moves)) or (not request.moves[moveIndex + 1]) then
            return self:emitChoiceError(
                (("Can't move: Your " .. pokemon.name) .. " doesn't have a move ") .. tostring(moveIndex + 1)
            )
        end
        moveid = request.moves[moveIndex + 1].id
        targetType = request.moves[moveIndex + 1].target
    else
        moveid = toID(_G, moveText)
        if moveid:startsWith("hiddenpower") then
            moveid = "hiddenpower"
        end
        for ____, move in ipairs(request.moves) do
            do
                if move.id ~= moveid then
                    goto __continue97
                end
                targetType = move.target or "normal"
                break
            end
            ::__continue97::
        end
        if ((not targetType) and ({"", "dynamax"}):includes(megaDynaOrZ)) and request.maxMoves then
            for ____, ____value in __TS__Iterator(
                request.maxMoves.maxMoves:entries()
            ) do
                local i
                i = ____value[1]
                local moveRequest
                moveRequest = ____value[2]
                if moveid == moveRequest.move then
                    moveid = request.moves[i].id
                    targetType = moveRequest.target
                    megaDynaOrZ = "dynamax"
                    break
                end
            end
        end
        if ((not targetType) and ({"", "zmove"}):includes(megaDynaOrZ)) and request.canZMove then
            for ____, ____value in __TS__Iterator(
                request.canZMove:entries()
            ) do
                local i
                i = ____value[1]
                local moveRequest
                moveRequest = ____value[2]
                do
                    if not moveRequest then
                        goto __continue103
                    end
                    if moveid == toID(_G, moveRequest.move) then
                        moveid = request.moves[i].id
                        targetType = moveRequest.target
                        megaDynaOrZ = "zmove"
                        break
                    end
                end
                ::__continue103::
            end
        end
        if not targetType then
            return self:emitChoiceError((("Can't move: Your " .. pokemon.name) .. " doesn't have a move matching ") .. moveid)
        end
    end
    local moves = pokemon:getMoves()
    if autoChoose then
        for ____, ____value in __TS__Iterator(
            request.moves:entries()
        ) do
            local i
            i = ____value[1]
            local move
            move = ____value[2]
            do
                if move.disabled then
                    goto __continue108
                end
                if ((i < #moves) and (move.id == moves[i].id)) and moves[i].disabled then
                    goto __continue108
                end
                moveid = move.id
                targetType = move.target
                break
            end
            ::__continue108::
        end
    end
    local move = self.battle.dex.moves:get(moveid)
    local zMove = (((megaDynaOrZ == "zmove") and (function() return self.battle.actions:getZMove(move, pokemon) end)) or (function() return nil end))()
    if (megaDynaOrZ == "zmove") and (not zMove) then
        return self:emitChoiceError(
            ((("Can't move: " .. pokemon.name) .. " can't use ") .. tostring(move.name)) .. " as a Z-move"
        )
    end
    if zMove and self.choice.zMove then
        return self:emitChoiceError("Can't move: You can't Z-move more than once per battle")
    end
    if zMove then
        targetType = self.battle.dex.moves:get(zMove).target
    end
    local maxMove = ((((megaDynaOrZ == "dynamax") or pokemon.volatiles.dynamax) and (function() return self.battle.actions:getMaxMove(move, pokemon) end)) or (function() return nil end))()
    if (megaDynaOrZ == "dynamax") and (not maxMove) then
        return self:emitChoiceError(
            ((("Can't move: " .. pokemon.name) .. " can't use ") .. tostring(move.name)) .. " as a Max Move"
        )
    end
    if maxMove then
        targetType = self.battle.dex.moves:get(maxMove).target
    end
    if autoChoose then
        targetLoc = 0
    elseif self.battle.actions:targetTypeChoices(targetType) then
        if (not targetLoc) and (#self.active >= 2) then
            return self:emitChoiceError(
                ("Can't move: " .. tostring(move.name)) .. " needs a target"
            )
        end
        if not self.battle:validTargetLoc(targetLoc, pokemon, targetType) then
            return self:emitChoiceError(
                "Can't move: Invalid target for " .. tostring(move.name)
            )
        end
    else
        if targetLoc then
            return self:emitChoiceError(
                "Can't move: You can't choose a target for " .. tostring(move.name)
            )
        end
    end
    local lockedMove = pokemon:getLockedMove()
    if lockedMove then
        local lockedMoveTargetLoc = pokemon.lastMoveTargetLoc or 0
        local lockedMoveID = toID(_G, lockedMove)
        if pokemon.volatiles[lockedMoveID] and pokemon.volatiles[lockedMoveID].targetLoc then
            lockedMoveTargetLoc = pokemon.volatiles[lockedMoveID].targetLoc
        end
        __TS__ArrayPush(self.choice.actions, {choice = "move", pokemon = pokemon, targetLoc = lockedMoveTargetLoc, moveid = lockedMoveID})
        return true
    elseif (not #moves) and (not zMove) then
        if self.battle.gen <= 4 then
            self:send("-activate", pokemon, "move: Struggle")
        end
        moveid = "struggle"
    elseif maxMove then
        if pokemon:maxMoveDisabled(move) then
            return self:emitChoiceError(
                ((("Can't move: " .. pokemon.name) .. "'s ") .. tostring(maxMove.name)) .. " is disabled"
            )
        end
    elseif not zMove then
        local isEnabled = false
        local disabledSource = ""
        for ____, m in ipairs(moves) do
            do
                if m.id ~= moveid then
                    goto __continue129
                end
                if not m.disabled then
                    isEnabled = true
                    break
                elseif m.disabledSource then
                    disabledSource = m.disabledSource
                end
            end
            ::__continue129::
        end
        if not isEnabled then
            if autoChoose then
                error(
                    __TS__New(Error, "autoChoose chose a disabled move"),
                    0
                )
            end
            local includeRequest = self:updateRequestForPokemon(
                pokemon,
                function(____, req)
                    local updated = false
                    for ____, m in __TS__Iterator(req.moves) do
                        if m.id == moveid then
                            if not m.disabled then
                                m.disabled = true
                                updated = true
                            end
                            if m.disabledSource ~= disabledSource then
                                m.disabledSource = disabledSource
                                updated = true
                            end
                            break
                        end
                    end
                    return updated
                end
            )
            local status = self:emitChoiceError(
                ((("Can't move: " .. pokemon.name) .. "'s ") .. tostring(move.name)) .. " is disabled",
                includeRequest
            )
            if includeRequest then
                self:emitRequest(self.activeRequest)
            end
            return status
        end
    end
    local mega = megaDynaOrZ == "mega"
    if mega and (not pokemon.canMegaEvo) then
        return self:emitChoiceError(("Can't move: " .. pokemon.name) .. " can't mega evolve")
    end
    if mega and self.choice.mega then
        return self:emitChoiceError("Can't move: You can only mega-evolve once per battle")
    end
    local ultra = megaDynaOrZ == "ultra"
    if ultra and (not pokemon.canUltraBurst) then
        return self:emitChoiceError(("Can't move: " .. pokemon.name) .. " can't ultra burst")
    end
    if ultra and self.choice.ultra then
        return self:emitChoiceError("Can't move: You can only ultra burst once per battle")
    end
    local dynamax = megaDynaOrZ == "dynamax"
    local canDynamax = self.activeRequest.active[__TS__ArrayIndexOf(self.active, pokemon)].canDynamax
    if dynamax and (self.choice.dynamax or (not canDynamax)) then
        if pokemon.volatiles.dynamax then
            dynamax = false
        else
            if self.battle.gen < 8 then
                return self:emitChoiceError("Can't move: Dynamaxing doesn't exist before Gen 8.")
            elseif pokemon.side:canDynamaxNow() then
                return self:emitChoiceError(("Can't move: " .. pokemon.name) .. " can't Dynamax now.")
            elseif pokemon.side.allySide:canDynamaxNow() then
                return self:emitChoiceError("Can't move: It's your partner's turn to Dynamax.")
            end
            return self:emitChoiceError("Can't move: You can only Dynamax once per battle.")
        end
    end
    __TS__ArrayPush(
        self.choice.actions,
        {
            choice = "move",
            pokemon = pokemon,
            targetLoc = targetLoc,
            moveid = moveid,
            mega = mega or ultra,
            zmove = zMove,
            maxMove = ((maxMove and (function() return maxMove.id end)) or (function() return nil end))()
        }
    )
    if pokemon.maybeDisabled then
        self.choice.cantUndo = self.choice.cantUndo or pokemon:isLastActive()
    end
    if mega then
        self.choice.mega = true
    end
    if ultra then
        self.choice.ultra = true
    end
    if zMove then
        self.choice.zMove = true
    end
    if dynamax then
        self.choice.dynamax = true
    end
    return true
end
function Side.prototype.updateRequestForPokemon(self, pokemon, update)
    if not self.activeRequest.active then
        error(
            __TS__New(Error, "Can't update a request without active Pokemon"),
            0
        )
    end
    local req = self.activeRequest.active[pokemon.position]
    if not req then
        error(
            __TS__New(Error, "Pokemon not found in request's active field"),
            0
        )
    end
    return update(_G, req)
end
function Side.prototype.chooseSwitch(self, slotText)
    if (self.requestState ~= "move") and (self.requestState ~= "switch") then
        return self:emitChoiceError(("Can't switch: You need a " .. self.requestState) .. " response")
    end
    local index = self:getChoiceIndex()
    if index >= #self.active then
        if self.requestState == "switch" then
            return self:emitChoiceError("Can't switch: You sent more switches than Pokémon that need to switch")
        end
        return self:emitChoiceError("Can't switch: You sent more choices than unfainted Pokémon")
    end
    local pokemon = self.active[index + 1]
    local autoChoose = not slotText
    local slot
    if autoChoose then
        if self.requestState ~= "switch" then
            return self:emitChoiceError("Can't switch: You need to select a Pokémon to switch in")
        end
        if not self.choice.forcedSwitchesLeft then
            return self:choosePass()
        end
        slot = #self.active
        while self.choice.switchIns:has(slot) or self.pokemon[slot].fainted do
            slot = slot + 1
        end
    else
        slot = __TS__ParseInt(slotText) - 1
    end
    if __TS__NumberIsNaN(
        __TS__Number(slot)
    ) or (slot < 0) then
        slot = -1
        for ____, ____value in __TS__Iterator(
            self.pokemon:entries()
        ) do
            local i
            i = ____value[1]
            local mon
            mon = ____value[2]
            if (string.lower(slotText) == mon.name:toLowerCase()) or (toID(_G, slotText) == mon.species.id) then
                slot = i
                break
            end
        end
        if slot < 0 then
            return self:emitChoiceError(("Can't switch: You do not have a Pokémon named \"" .. slotText) .. "\" to switch to")
        end
    end
    if slot >= #self.pokemon then
        return self:emitChoiceError(
            ("Can't switch: You do not have a Pokémon in slot " .. tostring(slot + 1)) .. " to switch to"
        )
    elseif slot < #self.active then
        return self:emitChoiceError("Can't switch: You can't switch to an active Pokémon")
    elseif self.choice.switchIns:has(slot) then
        return self:emitChoiceError(
            ("Can't switch: The Pokémon in slot " .. tostring(slot + 1)) .. " can only switch in once"
        )
    end
    local targetPokemon = self.pokemon[slot]
    if targetPokemon.fainted then
        return self:emitChoiceError("Can't switch: You can't switch to a fainted Pokémon")
    end
    if self.requestState == "move" then
        if pokemon.trapped then
            local includeRequest = self:updateRequestForPokemon(
                pokemon,
                function(____, req)
                    local updated = false
                    if req.maybeTrapped then
                        __TS__Delete(req, "maybeTrapped")
                        updated = true
                    end
                    if not req.trapped then
                        req.trapped = true
                        updated = true
                    end
                    return updated
                end
            )
            local status = self:emitChoiceError("Can't switch: The active Pokémon is trapped", includeRequest)
            if includeRequest then
                self:emitRequest(self.activeRequest)
            end
            return status
        elseif pokemon.maybeTrapped then
            self.choice.cantUndo = self.choice.cantUndo or pokemon:isLastActive()
        end
    elseif self.requestState == "switch" then
        if not self.choice.forcedSwitchesLeft then
            error(
                __TS__New(Error, "Player somehow switched too many Pokemon"),
                0
            )
        end
        local ____obj, ____index = self.choice, "forcedSwitchesLeft"
        ____obj[____index] = ____obj[____index] - 1
    end
    self.choice.switchIns:add(slot)
    __TS__ArrayPush(self.choice.actions, {choice = ((self.requestState == "switch") and "instaswitch") or "switch", pokemon = pokemon, target = targetPokemon})
    return true
end
function Side.prototype.pickedTeamSize(self)
    return math.min(#self.pokemon, self.battle.ruleTable.pickedTeamSize or math.huge)
end
function Side.prototype.chooseTeam(self, data)
    if data == nil then
        data = ""
    end
    if self.requestState ~= "teampreview" then
        return self:emitChoiceError("Can't choose for Team Preview: You're not in a Team Preview phase")
    end
    local ruleTable = self.battle.ruleTable
    local positions = __TS__ArrayMap(
        __TS__StringSplit(
            data,
            (data:includes(",") and ",") or ""
        ),
        function(____, datum) return __TS__ParseInt(datum) - 1 end
    )
    local pickedTeamSize = self:pickedTeamSize()
    __TS__ArraySplice(positions, pickedTeamSize)
    if #positions == 0 then
        do
            local i = 0
            while i < pickedTeamSize do
                __TS__ArrayPush(positions, i)
                i = i + 1
            end
        end
    elseif #positions < pickedTeamSize then
        do
            local i = 0
            while i < pickedTeamSize do
                if not positions:includes(i) then
                    __TS__ArrayPush(positions, i)
                end
                if #positions >= pickedTeamSize then
                    break
                end
                i = i + 1
            end
        end
    end
    for ____, ____value in __TS__Iterator(
        positions:entries()
    ) do
        local index
        index = ____value[1]
        local pos
        pos = ____value[2]
        if (__TS__NumberIsNaN(
            __TS__Number(pos)
        ) or (pos < 0)) or (pos >= #self.pokemon) then
            return self:emitChoiceError(
                "Can't choose for Team Preview: You do not have a Pokémon in slot " .. tostring(pos + 1)
            )
        end
        if __TS__ArrayIndexOf(positions, pos) ~= index then
            return self:emitChoiceError(
                ("Can't choose for Team Preview: The Pokémon in slot " .. tostring(pos + 1)) .. " can only switch in once"
            )
        end
    end
    if ruleTable.maxTotalLevel then
        local totalLevel = 0
        for ____, pos in ipairs(positions) do
            totalLevel = totalLevel + self.pokemon[pos + 1].level
        end
        if totalLevel > ruleTable.maxTotalLevel then
            if not data then
                positions = __TS__ArraySlice(
                    __TS__ArraySort(
                        {
                            __TS__Spread(
                                self.pokemon:keys()
                            )
                        },
                        function(____, a, b) return self.pokemon[a].level - self.pokemon[b].level end
                    ),
                    0,
                    pickedTeamSize
                )
            else
                return self:emitChoiceError(
                    ((((("Your selected team has a total level of " .. tostring(totalLevel)) .. ", but it can't be above ") .. tostring(ruleTable.maxTotalLevel)) .. "; please select a valid team of ") .. tostring(pickedTeamSize)) .. " Pokémon"
                )
            end
        end
    end
    for ____, ____value in __TS__Iterator(
        positions:entries()
    ) do
        local index
        index = ____value[1]
        local pos
        pos = ____value[2]
        self.choice.switchIns:add(pos)
        __TS__ArrayPush(self.choice.actions, {choice = "team", index = index, pokemon = self.pokemon[pos], priority = -index})
    end
    return true
end
function Side.prototype.chooseShift(self)
    local index = self:getChoiceIndex()
    if index >= #self.active then
        return self:emitChoiceError(
            "Can't shift: You do not have a Pokémon in slot " .. tostring(index + 1)
        )
    elseif self.requestState ~= "move" then
        return self:emitChoiceError("Can't shift: You can only shift during a move phase")
    elseif self.battle.gameType ~= "triples" then
        return self:emitChoiceError("Can't shift: You can only shift to the center in triples")
    elseif index == 1 then
        return self:emitChoiceError("Can't shift: You can only shift from the edge to the center")
    end
    local pokemon = self.active[index + 1]
    __TS__ArrayPush(self.choice.actions, {choice = "shift", pokemon = pokemon})
    return true
end
function Side.prototype.clearChoice(self)
    local forcedSwitches = 0
    local forcedPasses = 0
    if self.battle.requestState == "switch" then
        local canSwitchOut = #__TS__ArrayFilter(
            self.active,
            function(____, pokemon) return pokemon.switchFlag end
        )
        local canSwitchIn = #__TS__ArrayFilter(
            __TS__ArraySlice(self.pokemon, #self.active),
            function(____, pokemon) return pokemon and (not pokemon.fainted) end
        )
        forcedSwitches = math.min(canSwitchOut, canSwitchIn)
        forcedPasses = canSwitchOut - forcedSwitches
    end
    self.choice = {
        cantUndo = false,
        error = "",
        actions = {},
        forcedSwitchesLeft = forcedSwitches,
        forcedPassesLeft = forcedPasses,
        switchIns = __TS__New(Set),
        zMove = false,
        mega = false,
        ultra = false,
        dynamax = false
    }
end
function Side.prototype.choose(self, input)
    if not self.requestState then
        return self:emitChoiceError((self.battle.ended and "Can't do anything: The game is over") or "Can't do anything: It's not your turn")
    end
    if self.choice.cantUndo then
        return self:emitChoiceError("Can't undo: A trapping/disabling effect would cause undo to leak information")
    end
    self:clearChoice()
    local choiceStrings = ((input:startsWith("team ") and (function() return {input} end)) or (function() return __TS__StringSplit(input, ",") end))()
    if #choiceStrings > #self.active then
        return self:emitChoiceError(
            ((("Can't make choices: You sent choices for " .. tostring(#choiceStrings)) .. " Pokémon, but this is a ") .. tostring(self.battle.gameType)) .. " game!"
        )
    end
    for ____, choiceString in ipairs(choiceStrings) do
        local choiceType, data = __TS__Unpack(
            Utils:splitFirst(
                __TS__StringTrim(choiceString),
                " "
            )
        )
        data = __TS__StringTrim(data)
        local ____switch219 = choiceType
        local original, ____error, targetLoc, megaDynaOrZ
        if ____switch219 == "move" then
            goto ____switch219_case_0
        elseif ____switch219 == "switch" then
            goto ____switch219_case_1
        elseif ____switch219 == "shift" then
            goto ____switch219_case_2
        elseif ____switch219 == "team" then
            goto ____switch219_case_3
        elseif ____switch219 == "pass" then
            goto ____switch219_case_4
        elseif ____switch219 == "skip" then
            goto ____switch219_case_5
        elseif ____switch219 == "auto" then
            goto ____switch219_case_6
        elseif ____switch219 == "default" then
            goto ____switch219_case_7
        end
        goto ____switch219_case_default
        ::____switch219_case_0::
        do
            original = data
            ____error = function() return self:emitChoiceError("Conflicting arguments for \"move\": " .. original) end
            megaDynaOrZ = ""
            while true do
                if nil:test(data) and (toID(_G, data) ~= "conversion2") then
                    if targetLoc ~= nil then
                        return ____error(_G)
                    end
                    targetLoc = __TS__ParseInt(
                        string.sub(data, -2)
                    )
                    data = __TS__StringTrim(
                        string.sub(data, 1, -3)
                    )
                elseif data:endsWith(" mega") then
                    if megaDynaOrZ then
                        return ____error(_G)
                    end
                    megaDynaOrZ = "mega"
                    data = string.sub(data, 1, -6)
                elseif data:endsWith(" zmove") then
                    if megaDynaOrZ then
                        return ____error(_G)
                    end
                    megaDynaOrZ = "zmove"
                    data = string.sub(data, 1, -7)
                elseif data:endsWith(" ultra") then
                    if megaDynaOrZ then
                        return ____error(_G)
                    end
                    megaDynaOrZ = "ultra"
                    data = string.sub(data, 1, -7)
                elseif data:endsWith(" dynamax") then
                    if megaDynaOrZ then
                        return ____error(_G)
                    end
                    megaDynaOrZ = "dynamax"
                    data = string.sub(data, 1, -9)
                elseif data:endsWith(" gigantamax") then
                    if megaDynaOrZ then
                        return ____error(_G)
                    end
                    megaDynaOrZ = "dynamax"
                    data = string.sub(data, 1, -12)
                elseif data:endsWith(" max") then
                    if megaDynaOrZ then
                        return ____error(_G)
                    end
                    megaDynaOrZ = "dynamax"
                    data = string.sub(data, 1, -5)
                else
                    break
                end
            end
            if not self:chooseMove(data, targetLoc, megaDynaOrZ) then
                return false
            end
            goto ____switch219_end
        end
        ::____switch219_case_1::
        do
            self:chooseSwitch(data)
            goto ____switch219_end
        end
        ::____switch219_case_2::
        do
            if data then
                return self:emitChoiceError("Unrecognized data after \"shift\": " .. data)
            end
            if not self:chooseShift() then
                return false
            end
            goto ____switch219_end
        end
        ::____switch219_case_3::
        do
            if not self:chooseTeam(data) then
                return false
            end
            goto ____switch219_end
        end
        ::____switch219_case_4::
        do
        end
        ::____switch219_case_5::
        do
            if data then
                return self:emitChoiceError("Unrecognized data after \"pass\": " .. data)
            end
            if not self:choosePass() then
                return false
            end
            goto ____switch219_end
        end
        ::____switch219_case_6::
        do
        end
        ::____switch219_case_7::
        do
            self:autoChoose()
            goto ____switch219_end
        end
        ::____switch219_case_default::
        do
            self:emitChoiceError("Unrecognized choice: " .. choiceString)
            goto ____switch219_end
        end
        ::____switch219_end::
    end
    return not self.choice.error
end
function Side.prototype.getChoiceIndex(self, isPass)
    local index = #self.choice.actions
    if not isPass then
        local ____switch245 = self.requestState
        if ____switch245 == "move" then
            goto ____switch245_case_0
        elseif ____switch245 == "switch" then
            goto ____switch245_case_1
        end
        goto ____switch245_end
        ::____switch245_case_0::
        do
            while (index < #self.active) and self.active[index + 1].fainted do
                self:choosePass()
                index = index + 1
            end
            goto ____switch245_end
        end
        ::____switch245_case_1::
        do
            while (index < #self.active) and (not self.active[index + 1].switchFlag) do
                self:choosePass()
                index = index + 1
            end
            goto ____switch245_end
        end
        ::____switch245_end::
    end
    return index
end
function Side.prototype.choosePass(self)
    local index = self:getChoiceIndex(true)
    if index >= #self.active then
        return false
    end
    local pokemon = self.active[index + 1]
    local ____switch250 = self.requestState
    if ____switch250 == "switch" then
        goto ____switch250_case_0
    elseif ____switch250 == "move" then
        goto ____switch250_case_1
    end
    goto ____switch250_case_default
    ::____switch250_case_0::
    do
        if pokemon.switchFlag then
            if not self.choice.forcedPassesLeft then
                return self:emitChoiceError("Can't pass: You need to switch in a Pokémon to replace " .. pokemon.name)
            end
            local ____obj, ____index = self.choice, "forcedPassesLeft"
            ____obj[____index] = ____obj[____index] - 1
        end
        goto ____switch250_end
    end
    ::____switch250_case_1::
    do
        if not pokemon.fainted then
            return self:emitChoiceError(("Can't pass: Your " .. pokemon.name) .. " must make a move (or switch)")
        end
        goto ____switch250_end
    end
    ::____switch250_case_default::
    do
        return self:emitChoiceError("Can't pass: Not a move or switch request")
    end
    ::____switch250_end::
    __TS__ArrayPush(self.choice.actions, {choice = "pass"})
    return true
end
function Side.prototype.autoChoose(self)
    if self.requestState == "teampreview" then
        if not self:isChoiceDone() then
            self:chooseTeam()
        end
    elseif self.requestState == "switch" then
        local i = 0
        while not self:isChoiceDone() do
            if not self:chooseSwitch() then
                error(
                    __TS__New(Error, "autoChoose switch crashed: " .. self.choice.error),
                    0
                )
            end
            i = i + 1
            if i > 10 then
                error(
                    __TS__New(Error, "autoChoose failed: infinite looping"),
                    0
                )
            end
        end
    elseif self.requestState == "move" then
        local i = 0
        while not self:isChoiceDone() do
            if not self:chooseMove() then
                error(
                    __TS__New(Error, "autoChoose crashed: " .. self.choice.error),
                    0
                )
            end
            i = i + 1
            if i > 10 then
                error(
                    __TS__New(Error, "autoChoose failed: infinite looping"),
                    0
                )
            end
        end
    end
    return true
end
function Side.prototype.destroy(self)
    for ____, pokemon in ipairs(self.pokemon) do
        if pokemon then
            pokemon:destroy()
        end
    end
    for ____, action in ipairs(self.choice.actions) do
        __TS__Delete(action, "side")
        __TS__Delete(action, "pokemon")
        __TS__Delete(action, "target")
    end
    self.choice.actions = {}
    self.pokemon = {}
    self.active = {}
    self.foe = nil
    self.battle = nil
end
return ____exports
