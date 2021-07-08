--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____dex = require("sim/dex")
local Dex = ____dex.Dex
local toID = ____dex.toID
local CHOOSABLE_TARGETS = __TS__New(Set, {"normal", "any", "adjacentAlly", "adjacentAllyOrSelf", "adjacentFoe"})
____exports.BattleActions = __TS__Class()
local BattleActions = ____exports.BattleActions
BattleActions.name = "BattleActions"
function BattleActions.prototype.____constructor(self, battle)
    self.MAX_MOVES = {Flying = "Max Airstream", Dark = "Max Darkness", Fire = "Max Flare", Bug = "Max Flutterby", Water = "Max Geyser", Status = "Max Guard", Ice = "Max Hailstorm", Fighting = "Max Knuckle", Electric = "Max Lightning", Psychic = "Max Mindstorm", Poison = "Max Ooze", Grass = "Max Overgrowth", Ghost = "Max Phantasm", Ground = "Max Quake", Rock = "Max Rockfall", Fairy = "Max Starfall", Steel = "Max Steelspike", Normal = "Max Strike", Dragon = "Max Wyrmwind"}
    self.Z_MOVES = {Poison = "Acid Downpour", Fighting = "All-Out Pummeling", Dark = "Black Hole Eclipse", Grass = "Bloom Doom", Normal = "Breakneck Blitz", Rock = "Continental Crush", Steel = "Corkscrew Crash", Dragon = "Devastating Drake", Electric = "Gigavolt Havoc", Water = "Hydro Vortex", Fire = "Inferno Overdrive", Ghost = "Never-Ending Nightmare", Bug = "Savage Spin-Out", Psychic = "Shattered Psyche", Ice = "Subzero Slammer", Flying = "Supersonic Skystrike", Ground = "Tectonic Rage", Fairy = "Twinkle Tackle"}
    self.battle = battle
    self.dex = battle.dex
    if self.dex.data.Scripts.actions then
        __TS__ObjectAssign(self, self.dex.data.Scripts.actions)
    end
    if battle.format.actions then
        __TS__ObjectAssign(self, battle.format.actions)
    end
end
function BattleActions.prototype.switchIn(self, pokemon, pos, sourceEffect, isDrag)
    if sourceEffect == nil then
        sourceEffect = nil
    end
    if (not pokemon) or pokemon.isActive then
        self.battle:hint("A switch failed because the Pokémon trying to switch in is already in.")
        return false
    end
    local side = pokemon.side
    if pos >= side.active.length then
        error(
            __TS__New(
                Error,
                (("Invalid switch position " .. tostring(pos)) .. " / ") .. tostring(side.active.length)
            ),
            0
        )
    end
    local oldActive = side.active[pos]
    local unfaintedActive = ((oldActive.hp and (function() return oldActive end)) or (function() return nil end))()
    if unfaintedActive then
        oldActive.beingCalledBack = true
        local switchCopyFlag = false
        if sourceEffect and (sourceEffect.selfSwitch == "copyvolatile") then
            switchCopyFlag = true
        end
        if (not oldActive.skipBeforeSwitchOutEventFlag) and (not isDrag) then
            self.battle:runEvent("BeforeSwitchOut", oldActive)
            if self.battle.gen >= 5 then
                self.battle:eachEvent("Update")
            end
        end
        oldActive.skipBeforeSwitchOutEventFlag = false
        if not self.battle:runEvent("SwitchOut", oldActive) then
            return false
        end
        if not oldActive.hp then
            return "pursuitfaint"
        end
        oldActive.illusion = nil
        self.battle:singleEvent(
            "End",
            oldActive:getAbility(),
            oldActive.abilityState,
            oldActive
        )
        self.battle.queue:cancelAction(oldActive)
        local newMove = nil
        if (self.battle.gen == 4) and sourceEffect then
            newMove = oldActive.lastMove
        end
        if switchCopyFlag then
            pokemon:copyVolatileFrom(oldActive)
        end
        if newMove then
            pokemon.lastMove = newMove
        end
        oldActive:clearVolatile()
    end
    if oldActive then
        oldActive.isActive = false
        oldActive.isStarted = false
        oldActive.usedItemThisTurn = false
        oldActive.position = pokemon.position
        pokemon.position = pos
        side.pokemon[pokemon.position] = pokemon
        side.pokemon[oldActive.position] = oldActive
    end
    pokemon.isActive = true
    side.active[pos] = pokemon
    pokemon.activeTurns = 0
    pokemon.activeMoveActions = 0
    for ____, moveSlot in __TS__Iterator(pokemon.moveSlots) do
        moveSlot.used = false
    end
    self.battle:runEvent("BeforeSwitchIn", pokemon)
    self.battle:add((isDrag and "drag") or "switch", pokemon, pokemon.getDetails)
    pokemon.abilityOrder = (function()
        local ____obj, ____index = self.battle, "abilityOrder"
        local ____tmp = ____obj[____index]
        ____obj[____index] = ____tmp + 1
        return ____tmp
    end)()
    if isDrag and (self.battle.gen == 2) then
        pokemon.draggedIn = self.battle.turn
    end
    if sourceEffect then
        local ____obj, ____index = self.battle.log, self.battle.log.length - 1
        ____obj[____index] = tostring(____obj[____index]) .. ("|[from]" .. tostring(sourceEffect.fullname))
    end
    pokemon.previouslySwitchedIn = pokemon.previouslySwitchedIn + 1
    if isDrag and (self.battle.gen >= 5) then
        self.battle:singleEvent(
            "PreStart",
            pokemon:getAbility(),
            pokemon.abilityState,
            pokemon
        )
        self:runSwitch(pokemon)
    else
        self.battle.queue:insertChoice({choice = "runUnnerve", pokemon = pokemon})
        self.battle.queue:insertChoice({choice = "runSwitch", pokemon = pokemon})
    end
    return true
end
function BattleActions.prototype.dragIn(self, side, pos)
    local pokemon = self.battle:getRandomSwitchable(side)
    if (not pokemon) or pokemon.isActive then
        return false
    end
    local oldActive = side.active[pos]
    if not oldActive then
        error(
            __TS__New(Error, "nothing to drag out"),
            0
        )
    end
    if not oldActive.hp then
        return false
    end
    if not self.battle:runEvent("DragOut", oldActive) then
        return false
    end
    if not self:switchIn(pokemon, pos, nil, true) then
        return false
    end
    return true
end
function BattleActions.prototype.runSwitch(self, pokemon)
    self.battle:runEvent("Swap", pokemon)
    self.battle:runEvent("SwitchIn", pokemon)
    if ((self.battle.gen <= 2) and (not pokemon.side.faintedThisTurn)) and (pokemon.draggedIn ~= self.battle.turn) then
        self.battle:runEvent("AfterSwitchInSelf", pokemon)
    end
    if not pokemon.hp then
        return false
    end
    pokemon.isStarted = true
    if not pokemon.fainted then
        self.battle:singleEvent(
            "Start",
            pokemon:getAbility(),
            pokemon.abilityState,
            pokemon
        )
        self.battle:singleEvent(
            "Start",
            pokemon:getItem(),
            pokemon.itemState,
            pokemon
        )
    end
    if self.battle.gen == 4 then
        for ____, foeActive in __TS__Iterator(
            pokemon:foes()
        ) do
            foeActive:removeVolatile("substitutebroken")
        end
    end
    pokemon.draggedIn = nil
    return true
end
function BattleActions.prototype.runMove(self, moveOrMoveName, pokemon, targetLoc, sourceEffect, zMove, externalMove, maxMove, originalTarget)
    pokemon.activeMoveActions = pokemon.activeMoveActions + 1
    local target = self.battle:getTarget(pokemon, (maxMove or zMove) or moveOrMoveName, targetLoc, originalTarget)
    local baseMove = self.dex:getActiveMove(moveOrMoveName)
    local pranksterBoosted = baseMove.pranksterBoosted
    if (((baseMove.id ~= "struggle") and (not zMove)) and (not maxMove)) and (not externalMove) then
        local changedMove = self.battle:runEvent("OverrideAction", pokemon, target, baseMove)
        if changedMove and (changedMove ~= true) then
            baseMove = self.dex:getActiveMove(changedMove)
            if pranksterBoosted then
                baseMove.pranksterBoosted = pranksterBoosted
            end
            target = self.battle:getRandomTarget(pokemon, baseMove)
        end
    end
    local move = baseMove
    if zMove then
        move = self:getActiveZMove(baseMove, pokemon)
    elseif maxMove then
        move = self:getActiveMaxMove(baseMove, pokemon)
    end
    move.isExternal = externalMove
    self.battle:setActiveMove(move, pokemon, target)
    local willTryMove = self.battle:runEvent("BeforeMove", pokemon, target, move)
    if not willTryMove then
        self.battle:runEvent("MoveAborted", pokemon, target, move)
        self.battle:clearActiveMove(true)
        pokemon.moveThisTurnResult = willTryMove
        return
    end
    if move.beforeMoveCallback then
        if move.beforeMoveCallback:call(self.battle, pokemon, target, move) then
            self.battle:clearActiveMove(true)
            pokemon.moveThisTurnResult = false
            return
        end
    end
    pokemon.lastDamage = 0
    local lockedMove
    if not externalMove then
        lockedMove = self.battle:runEvent("LockMove", pokemon)
        if lockedMove == true then
            lockedMove = false
        end
        if not lockedMove then
            if (not pokemon:deductPP(baseMove, nil, target)) and (move.id ~= "struggle") then
                self.battle:add("cant", pokemon, "nopp", move)
                self.battle:clearActiveMove(true)
                pokemon.moveThisTurnResult = false
                return
            end
        else
            sourceEffect = self.dex.conditions:get("lockedmove")
        end
        pokemon:moveUsed(move, targetLoc)
    end
    local noLock = externalMove and (not pokemon.volatiles.lockedmove)
    if zMove then
        if pokemon.illusion then
            self.battle:singleEvent(
                "End",
                self.dex.abilities:get("Illusion"),
                pokemon.abilityState,
                pokemon
            )
        end
        self.battle:add("-zpower", pokemon)
        pokemon.side.zMoveUsed = true
    end
    local moveDidSomething = self:useMove(baseMove, pokemon, target, sourceEffect, zMove, maxMove)
    self.battle.lastSuccessfulMoveThisTurn = ((moveDidSomething and (function() return self.battle.activeMove and self.battle.activeMove.id end)) or (function() return nil end))()
    if self.battle.activeMove then
        move = self.battle.activeMove
    end
    self.battle:singleEvent("AfterMove", move, nil, pokemon, target, move)
    self.battle:runEvent("AfterMove", pokemon, target, move)
    if (move.flags.dance and moveDidSomething) and (not move.isExternal) then
        local dancers = {}
        for ____, currentPoke in __TS__Iterator(
            self.battle:getAllActive()
        ) do
            do
                if pokemon == currentPoke then
                    goto __continue54
                end
                if currentPoke:hasAbility("dancer") and (not currentPoke:isSemiInvulnerable()) then
                    __TS__ArrayPush(dancers, currentPoke)
                end
            end
            ::__continue54::
        end
        __TS__ArraySort(
            dancers,
            function(____, a, b) return -(b.storedStats.spe - a.storedStats.spe) or (b.abilityOrder - a.abilityOrder) end
        )
        for ____, dancer in ipairs(dancers) do
            do
                if self.battle:faintMessages() then
                    break
                end
                if dancer.fainted then
                    goto __continue58
                end
                self.battle:add("-activate", dancer, "ability: Dancer")
                local dancersTarget = ((((not target:isAlly(dancer)) and pokemon:isAlly(dancer)) and (function() return target end)) or (function() return pokemon end))()
                local dancersTargetLoc = dancer:getLocOf(dancersTarget)
                self:runMove(
                    move.id,
                    dancer,
                    dancersTargetLoc,
                    self.dex.abilities:get("dancer"),
                    nil,
                    true
                )
            end
            ::__continue58::
        end
    end
    if noLock and pokemon.volatiles.lockedmove then
        __TS__Delete(pokemon.volatiles, "lockedmove")
    end
    self.battle:faintMessages()
    self.battle:checkWin()
end
function BattleActions.prototype.useMove(self, move, pokemon, target, sourceEffect, zMove, maxMove)
    pokemon.moveThisTurnResult = nil
    local oldMoveResult = pokemon.moveThisTurnResult
    local moveResult = self:useMoveInner(move, pokemon, target, sourceEffect, zMove, maxMove)
    if oldMoveResult == pokemon.moveThisTurnResult then
        pokemon.moveThisTurnResult = moveResult
    end
    return moveResult
end
function BattleActions.prototype.useMoveInner(self, moveOrMoveName, pokemon, target, sourceEffect, zMove, maxMove)
    if (not sourceEffect) and self.battle.effect.id then
        sourceEffect = self.battle.effect
    end
    if sourceEffect and ({"instruct", "custapberry"}):includes(sourceEffect.id) then
        sourceEffect = nil
    end
    local move = self.dex:getActiveMove(moveOrMoveName)
    pokemon.lastMoveUsed = move
    if (move.id == "weatherball") and zMove then
        self.battle:singleEvent("ModifyType", move, nil, pokemon, target, move, move)
        if move.type ~= "Normal" then
            sourceEffect = move
        end
    end
    if zMove or (((move.category ~= "Status") and sourceEffect) and sourceEffect.isZ) then
        move = self:getActiveZMove(move, pokemon)
    end
    if maxMove and (move.category ~= "Status") then
        self.battle:singleEvent("ModifyType", move, nil, pokemon, target, move, move)
        self.battle:runEvent("ModifyType", pokemon, target, move, move)
    end
    if maxMove or (((move.category ~= "Status") and sourceEffect) and sourceEffect.isMax) then
        move = self:getActiveMaxMove(move, pokemon)
    end
    if self.battle.activeMove then
        move.priority = self.battle.activeMove.priority
        if not move.hasBounced then
            move.pranksterBoosted = self.battle.activeMove.pranksterBoosted
        end
    end
    local baseTarget = move.target
    local targetRelayVar = {target = target}
    targetRelayVar = self.battle:runEvent("ModifyTarget", pokemon, target, move, targetRelayVar, true)
    if targetRelayVar.target ~= nil then
        target = targetRelayVar.target
    end
    if target == nil then
        target = self.battle:getRandomTarget(pokemon, move)
    end
    if (move.target == "self") or (move.target == "allies") then
        target = pokemon
    end
    if sourceEffect then
        move.sourceEffect = sourceEffect.id
        move.ignoreAbility = false
    end
    local moveResult = false
    self.battle:setActiveMove(move, pokemon, target)
    self.battle:singleEvent("ModifyType", move, nil, pokemon, target, move, move)
    self.battle:singleEvent("ModifyMove", move, nil, pokemon, target, move, move)
    if baseTarget ~= move.target then
        target = self.battle:getRandomTarget(pokemon, move)
    end
    move = self.battle:runEvent("ModifyType", pokemon, target, move, move)
    move = self.battle:runEvent("ModifyMove", pokemon, target, move, move)
    if baseTarget ~= move.target then
        target = self.battle:getRandomTarget(pokemon, move)
    end
    if (not move) or pokemon.fainted then
        return false
    end
    local attrs = ""
    local movename = move.name
    if move.id == "hiddenpower" then
        movename = "Hidden Power"
    end
    if sourceEffect then
        attrs = tostring(attrs) .. ("|[from]" .. tostring(sourceEffect.fullname))
    end
    if zMove and (move.isZ == true) then
        attrs = ("|[anim]" .. tostring(movename)) .. tostring(attrs)
        movename = "Z-" .. tostring(movename)
    end
    self.battle:addMove(
        "move",
        pokemon,
        movename,
        tostring(target) .. tostring(attrs)
    )
    if zMove then
        self:runZPower(move, pokemon)
    end
    if not target then
        self.battle:attrLastMove("[notarget]")
        self.battle:add(((self.battle.gen >= 5) and "-fail") or "-notarget", pokemon)
        return false
    end
    local ____ = pokemon:getMoveTargets(move, target)
    local targets = ____.targets
    local pressureTargets = ____.pressureTargets
    if targets.length then
        target = targets[targets.length - 1]
    end
    if (not sourceEffect) or (sourceEffect.id == "pursuit") then
        local extraPP = 0
        for ____, source in __TS__Iterator(pressureTargets) do
            local ppDrop = self.battle:runEvent("DeductPP", source, pokemon, move)
            if ppDrop ~= true then
                extraPP = extraPP + (ppDrop or 0)
            end
        end
        if extraPP > 0 then
            pokemon:deductPP(moveOrMoveName, extraPP)
        end
    end
    if (not self.battle:singleEvent("TryMove", move, nil, pokemon, target, move)) or (not self.battle:runEvent("TryMove", pokemon, target, move)) then
        move.mindBlownRecoil = false
        return false
    end
    self.battle:singleEvent("UseMoveMessage", move, nil, pokemon, target, move)
    if move.ignoreImmunity == nil then
        move.ignoreImmunity = move.category == "Status"
    end
    if (self.battle.gen ~= 4) and (move.selfdestruct == "always") then
        self.battle:faint(pokemon, pokemon, move)
    end
    local damage = false
    if (((move.target == "all") or (move.target == "foeSide")) or (move.target == "allySide")) or (move.target == "allyTeam") then
        damage = self:tryMoveHit(targets, pokemon, move)
        if damage == self.battle.NOT_FAIL then
            pokemon.moveThisTurnResult = nil
        end
        if (damage or (damage == 0)) or (damage == nil) then
            moveResult = true
        end
    else
        if not targets.length then
            self.battle:attrLastMove("[notarget]")
            self.battle:add(((self.battle.gen >= 5) and "-fail") or "-notarget", pokemon)
            return false
        end
        if (self.battle.gen == 4) and (move.selfdestruct == "always") then
            self.battle:faint(pokemon, pokemon, move)
        end
        moveResult = self:trySpreadMoveHit(targets, pokemon, move)
    end
    if move.selfBoost and moveResult then
        self:moveHit(pokemon, pokemon, move, move.selfBoost, false, true)
    end
    if not pokemon.hp then
        self.battle:faint(pokemon, pokemon, move)
    end
    if not moveResult then
        self.battle:singleEvent("MoveFail", move, nil, target, pokemon, move)
        return false
    end
    if ((not move.negateSecondary) and (not (move.hasSheerForce and pokemon:hasAbility("sheerforce")))) and (not move.isFutureMove) then
        local originalHp = pokemon.hp
        self.battle:singleEvent("AfterMoveSecondarySelf", move, nil, pokemon, target, move)
        self.battle:runEvent("AfterMoveSecondarySelf", pokemon, target, move)
        if (pokemon and (pokemon ~= target)) and (move.category ~= "Status") then
            if (pokemon.hp <= (pokemon.maxhp / 2)) and (originalHp > (pokemon.maxhp / 2)) then
                self.battle:runEvent("EmergencyExit", pokemon, pokemon)
            end
        end
    end
    return true
end
function BattleActions.prototype.trySpreadMoveHit(self, targets, pokemon, move, notActive)
    if (#targets > 1) and (not move.smartTarget) then
        move.spreadHit = true
    end
    local moveSteps = {self.hitStepInvulnerabilityEvent, self.hitStepTryHitEvent, self.hitStepTypeImmunity, self.hitStepTryImmunity, self.hitStepAccuracy, self.hitStepBreakProtect, self.hitStepStealBoosts, self.hitStepMoveHitLoop}
    if self.battle.gen <= 6 then
        moveSteps[2], moveSteps[3] = __TS__Unpack({moveSteps[3], moveSteps[2]})
    end
    if self.battle.gen == 4 then
        moveSteps[3], moveSteps[5] = __TS__Unpack({moveSteps[5], moveSteps[3]})
    end
    if not notActive then
        self.battle:setActiveMove(move, pokemon, targets[1])
    end
    local hitResult = (self.battle:singleEvent("Try", move, nil, pokemon, targets[1], move) and self.battle:singleEvent("PrepareHit", move, {}, targets[1], pokemon, move)) and self.battle:runEvent("PrepareHit", pokemon, targets[1], move)
    if not hitResult then
        if hitResult == false then
            self.battle:add("-fail", pokemon)
            self.battle:attrLastMove("[still]")
        end
        return hitResult == self.battle.NOT_FAIL
    end
    local atLeastOneFailure = false
    for ____, step in ipairs(moveSteps) do
        do
            local hitResults = step(self, targets, pokemon, move)
            if not hitResults then
                goto __continue113
            end
            targets = __TS__ArrayFilter(
                targets,
                function(____, val, i) return hitResults[i + 1] or (hitResults[i + 1] == 0) end
            )
            atLeastOneFailure = atLeastOneFailure or __TS__ArraySome(
                hitResults,
                function(____, val) return val == false end
            )
            if not #targets then
                break
            end
        end
        ::__continue113::
    end
    local moveResult = not (not #targets)
    if (not moveResult) and (not atLeastOneFailure) then
        pokemon.moveThisTurnResult = nil
    end
    local hitSlot = __TS__ArrayMap(
        targets,
        function(____, p) return p:getSlot() end
    )
    if move.spreadHit then
        self.battle:attrLastMove(
            "[spread] " .. tostring(
                __TS__ArrayJoin(hitSlot, ",")
            )
        )
    end
    return moveResult
end
function BattleActions.prototype.hitStepInvulnerabilityEvent(self, targets, pokemon, move)
    if (move.id == "helpinghand") or (((self.battle.gen >= 8) and (move.id == "toxic")) and pokemon:hasType("Poison")) then
        return __TS__New(Array, #targets):fill(true)
    end
    local hitResults = self.battle:runEvent("Invulnerability", targets, pokemon, move)
    for ____, ____value in __TS__Iterator(
        targets:entries()
    ) do
        local i
        i = ____value[1]
        local target
        target = ____value[2]
        if hitResults[i] == false then
            if move.smartTarget then
                move.smartTarget = false
            else
                if not move.spreadHit then
                    self.battle:attrLastMove("[miss]")
                end
                self.battle:add("-miss", pokemon, target)
            end
        end
    end
    return hitResults
end
function BattleActions.prototype.hitStepTryHitEvent(self, targets, pokemon, move)
    local hitResults = self.battle:runEvent("TryHit", targets, pokemon, move)
    if (not hitResults:includes(true)) and hitResults:includes(false) then
        self.battle:add("-fail", pokemon)
        self.battle:attrLastMove("[still]")
    end
    for ____, i in __TS__Iterator(
        targets:keys()
    ) do
        if hitResults[i] ~= self.battle.NOT_FAIL then
            hitResults[i] = hitResults[i] or false
        end
    end
    return hitResults
end
function BattleActions.prototype.hitStepTypeImmunity(self, targets, pokemon, move)
    if move.ignoreImmunity == nil then
        move.ignoreImmunity = move.category == "Status"
    end
    local hitResults = {}
    for ____, i in __TS__Iterator(
        targets:keys()
    ) do
        hitResults[i] = (move.ignoreImmunity and ((move.ignoreImmunity == true) or move.ignoreImmunity[move.type])) or targets[i]:runImmunity(move.type, not move.smartTarget)
        if move.smartTarget and (not hitResults[i]) then
            move.smartTarget = false
        end
    end
    return hitResults
end
function BattleActions.prototype.hitStepTryImmunity(self, targets, pokemon, move)
    local hitResults = {}
    for ____, ____value in __TS__Iterator(
        targets:entries()
    ) do
        local i
        i = ____value[1]
        local target
        target = ____value[2]
        if (((self.battle.gen >= 6) and move.flags.powder) and (target ~= pokemon)) and (not self.dex:getImmunity("powder", target)) then
            self.battle:debug("natural powder immunity")
            self.battle:add("-immune", target)
            hitResults[i] = false
        elseif not self.battle:singleEvent("TryImmunity", move, {}, target, pokemon, move) then
            self.battle:add("-immune", target)
            hitResults[i] = false
        elseif ((((self.battle.gen >= 7) and move.pranksterBoosted) and pokemon:hasAbility("prankster")) and (not targets[i]:isAlly(pokemon))) and (not self.dex:getImmunity("prankster", target)) then
            self.battle:debug("natural prankster immunity")
            if not target.illusion then
                self.battle:hint("Since gen 7, Dark is immune to Prankster moves.")
            end
            self.battle:add("-immune", target)
            hitResults[i] = false
        else
            hitResults[i] = true
        end
    end
    return hitResults
end
function BattleActions.prototype.hitStepAccuracy(self, targets, pokemon, move)
    local hitResults = {}
    for ____, ____value in __TS__Iterator(
        targets:entries()
    ) do
        local i
        i = ____value[1]
        local target
        target = ____value[2]
        do
            self.battle.activeTarget = target
            local accuracy = move.accuracy
            if move.ohko then
                if not target:isSemiInvulnerable() then
                    accuracy = 30
                    if ((move.ohko == "Ice") and (self.battle.gen >= 7)) and (not pokemon:hasType("Ice")) then
                        accuracy = 20
                    end
                    if ((not target.volatiles.dynamax) and (pokemon.level >= target.level)) and ((move.ohko == true) or (not target:hasType(move.ohko))) then
                        accuracy = accuracy + (pokemon.level - target.level)
                    else
                        self.battle:add("-immune", target, "[ohko]")
                        hitResults[i] = false
                        goto __continue144
                    end
                end
            else
                accuracy = self.battle:runEvent("ModifyAccuracy", target, pokemon, move, accuracy)
                if accuracy ~= true then
                    local boost = 0
                    if not move.ignoreAccuracy then
                        local boosts = self.battle:runEvent(
                            "ModifyBoost",
                            pokemon,
                            nil,
                            nil,
                            __TS__ObjectAssign({}, pokemon.boosts)
                        )
                        boost = self.battle:clampIntRange(boosts.accuracy, -6, 6)
                    end
                    if not move.ignoreEvasion then
                        local boosts = self.battle:runEvent(
                            "ModifyBoost",
                            target,
                            nil,
                            nil,
                            __TS__ObjectAssign({}, target.boosts)
                        )
                        boost = self.battle:clampIntRange(boost - boosts.evasion, -6, 6)
                    end
                    if boost > 0 then
                        accuracy = self.battle:trunc((accuracy * (3 + boost)) / 3)
                    elseif boost < 0 then
                        accuracy = self.battle:trunc((accuracy * 3) / (3 - boost))
                    end
                end
            end
            if (move.alwaysHit or (((move.id == "toxic") and (self.battle.gen >= 8)) and pokemon:hasType("Poison"))) or (((move.target == "self") and (move.category == "Status")) and (not target:isSemiInvulnerable())) then
                accuracy = true
            else
                accuracy = self.battle:runEvent("Accuracy", target, pokemon, move, accuracy)
            end
            if (accuracy ~= true) and (not self.battle:randomChance(accuracy, 100)) then
                if move.smartTarget then
                    move.smartTarget = false
                else
                    if not move.spreadHit then
                        self.battle:attrLastMove("[miss]")
                    end
                    self.battle:add("-miss", pokemon, target)
                end
                if ((not move.ohko) and pokemon:hasItem("blunderpolicy")) and pokemon:useItem() then
                    self.battle:boost({spe = 2}, pokemon)
                end
                hitResults[i] = false
                goto __continue144
            end
            hitResults[i] = true
        end
        ::__continue144::
    end
    return hitResults
end
function BattleActions.prototype.hitStepBreakProtect(self, targets, pokemon, move)
    if move.breaksProtect then
        for ____, target in ipairs(targets) do
            local broke = false
            for ____, effectid in ipairs({"banefulbunker", "kingsshield", "obstruct", "protect", "spikyshield"}) do
                if target:removeVolatile(effectid) then
                    broke = true
                end
            end
            if (self.battle.gen >= 6) or (not target:isAlly(pokemon)) then
                for ____, effectid in ipairs({"craftyshield", "matblock", "quickguard", "wideguard"}) do
                    if target.side:removeSideCondition(effectid) then
                        broke = true
                    end
                end
            end
            if broke then
                if move.id == "feint" then
                    self.battle:add("-activate", target, "move: Feint")
                else
                    self.battle:add(
                        "-activate",
                        target,
                        "move: " .. tostring(move.name),
                        "[broken]"
                    )
                end
                if self.battle.gen >= 6 then
                    __TS__Delete(target.volatiles, "stall")
                end
            end
        end
    end
    return nil
end
function BattleActions.prototype.hitStepStealBoosts(self, targets, pokemon, move)
    local target = targets[1]
    if move.stealsBoosts then
        local boosts = {}
        local stolen = false
        local statName
        for ____value in pairs(target.boosts) do
            statName = ____value
            local stage = target.boosts[statName]
            if stage > 0 then
                boosts[statName] = stage
                stolen = true
            end
        end
        if stolen then
            self.battle:attrLastMove("[still]")
            self.battle:add(
                "-clearpositiveboost",
                target,
                pokemon,
                "move: " .. tostring(move.name)
            )
            self.battle:boost(boosts, pokemon, pokemon)
            local statName2
            for ____value in pairs(boosts) do
                statName2 = ____value
                boosts[statName2] = 0
            end
            target:setBoost(boosts)
            self.battle:addMove("-anim", pokemon, "Spectral Thief", target)
        end
    end
    return nil
end
function BattleActions.prototype.afterMoveSecondaryEvent(self, targets, pokemon, move)
    if (not move.negateSecondary) and (not (move.hasSheerForce and pokemon:hasAbility("sheerforce"))) then
        self.battle:singleEvent("AfterMoveSecondary", move, nil, targets[1], pokemon, move)
        self.battle:runEvent("AfterMoveSecondary", targets, pokemon, move)
    end
    return nil
end
function BattleActions.prototype.tryMoveHit(self, targetOrTargets, pokemon, move)
    local target = ((__TS__ArrayIsArray(targetOrTargets) and (function() return targetOrTargets[1] end)) or (function() return targetOrTargets end))()
    local targets = ((__TS__ArrayIsArray(targetOrTargets) and (function() return targetOrTargets end)) or (function() return {target} end))()
    self.battle:setActiveMove(move, pokemon, targets[1])
    local hitResult = (self.battle:singleEvent("Try", move, nil, pokemon, target, move) and self.battle:singleEvent("PrepareHit", move, {}, target, pokemon, move)) and self.battle:runEvent("PrepareHit", pokemon, target, move)
    if not hitResult then
        if hitResult == false then
            self.battle:add("-fail", pokemon)
            self.battle:attrLastMove("[still]")
        end
        return false
    end
    local isFFAHazard = (move.target == "foeSide") and (self.battle.gameType == "freeforall")
    if move.target == "all" then
        hitResult = self.battle:runEvent("TryHitField", target, pokemon, move)
    elseif isFFAHazard then
        local hitResults = self.battle:runEvent("TryHitSide", targets, pokemon, move)
        if __TS__ArraySome(
            hitResults,
            function(____, result) return not result end
        ) then
            return false
        end
        hitResult = true
    else
        hitResult = self.battle:runEvent("TryHitSide", target, pokemon, move)
    end
    if not hitResult then
        if hitResult == false then
            self.battle:add("-fail", pokemon)
            self.battle:attrLastMove("[still]")
        end
        return false
    end
    return self:moveHit(
        ((isFFAHazard and (function() return targets end)) or (function() return target end))(),
        pokemon,
        move
    )
end
function BattleActions.prototype.hitStepMoveHitLoop(self, targets, pokemon, move)
    local damage = {}
    for ____, i in __TS__Iterator(
        targets:keys()
    ) do
        damage[i] = 0
    end
    move.totalDamage = 0
    pokemon.lastDamage = 0
    local targetHits = move.multihit or 1
    if __TS__ArrayIsArray(targetHits) then
        if (targetHits[1] == 2) and (targetHits[2] == 5) then
            if self.battle.gen >= 5 then
                targetHits = self.battle:sample({2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 5, 5, 5})
            else
                targetHits = self.battle:sample({2, 2, 2, 3, 3, 3, 4, 5})
            end
        else
            targetHits = self.battle:random(targetHits[1], targetHits[2] + 1)
        end
    end
    targetHits = math.floor(targetHits)
    local nullDamage = true
    local moveDamage = {}
    local isSleepUsable = move.sleepUsable or self.dex.moves:get(move.sourceEffect).sleepUsable
    local targetsCopy = __TS__ArraySlice(targets, 0)
    local hit
    do
        hit = 1
        while hit <= targetHits do
            if damage:includes(false) then
                break
            end
            if ((hit > 1) and (pokemon.status == "slp")) and ((not isSleepUsable) or (self.battle.gen == 4)) then
                break
            end
            if __TS__ArrayEvery(
                targets,
                function(____, target) return not target.hp end
            ) then
                break
            end
            move.hit = hit
            if move.smartTarget and (#targets > 1) then
                targetsCopy = {targets[hit]}
            else
                targetsCopy = __TS__ArraySlice(targets, 0)
            end
            local target = targetsCopy[1]
            if target and (type(move.smartTarget) == "boolean") then
                if hit > 1 then
                    self.battle:addMove("-anim", pokemon, move.name, target)
                else
                    self.battle:retargetLastMove(target)
                end
            end
            if (target and move.multiaccuracy) and (hit > 1) then
                local accuracy = move.accuracy
                local boostTable = {1, 4 / 3, 5 / 3, 2, 7 / 3, 8 / 3, 3}
                if accuracy ~= true then
                    if not move.ignoreAccuracy then
                        local boosts = self.battle:runEvent(
                            "ModifyBoost",
                            pokemon,
                            nil,
                            nil,
                            __TS__ObjectAssign({}, pokemon.boosts)
                        )
                        local boost = self.battle:clampIntRange(boosts.accuracy, -6, 6)
                        if boost > 0 then
                            accuracy = accuracy * boostTable[boost]
                        else
                            accuracy = accuracy / boostTable[-boost + 1]
                        end
                    end
                    if not move.ignoreEvasion then
                        local boosts = self.battle:runEvent(
                            "ModifyBoost",
                            target,
                            nil,
                            nil,
                            __TS__ObjectAssign({}, target.boosts)
                        )
                        local boost = self.battle:clampIntRange(boosts.evasion, -6, 6)
                        if boost > 0 then
                            accuracy = accuracy / boostTable[boost]
                        elseif boost < 0 then
                            accuracy = accuracy * boostTable[-boost + 1]
                        end
                    end
                end
                accuracy = self.battle:runEvent("ModifyAccuracy", target, pokemon, move, accuracy)
                if not move.alwaysHit then
                    accuracy = self.battle:runEvent("Accuracy", target, pokemon, move, accuracy)
                    if (accuracy ~= true) and (not self.battle:randomChance(accuracy, 100)) then
                        break
                    end
                end
            end
            local moveData = move
            if not moveData.flags then
                moveData.flags = {}
            end
            moveDamage, targetsCopy = __TS__Unpack(
                self:spreadMoveHit(targetsCopy, pokemon, move, moveData)
            )
            if not __TS__ArraySome(
                moveDamage,
                function(____, val) return val ~= false end
            ) then
                break
            end
            nullDamage = false
            for ____, ____value in __TS__Iterator(
                moveDamage:entries()
            ) do
                local i
                i = ____value[1]
                local md
                md = ____value[2]
                damage[i] = (((md == true) or (not md)) and 0) or md
                move.totalDamage = move.totalDamage + damage[i]
            end
            if move.mindBlownRecoil then
                self.battle:damage(
                    math.floor((pokemon.maxhp / 2) + 0.5),
                    pokemon,
                    pokemon,
                    self.dex.conditions:get("Mind Blown"),
                    true
                )
                move.mindBlownRecoil = false
            end
            self.battle:eachEvent("Update")
            if (not pokemon.hp) and (#targets == 1) then
                hit = hit + 1
                break
            end
            hit = hit + 1
        end
    end
    if hit == 1 then
        return damage:fill(false)
    end
    if nullDamage then
        damage:fill(false)
    end
    self.battle:faintMessages(false, false, not pokemon.hp)
    if move.multihit and (type(move.smartTarget) ~= "boolean") then
        self.battle:add("-hitcount", targets[1], hit - 1)
    end
    if move.recoil and move.totalDamage then
        self.battle:damage(
            self:calcRecoilDamage(move.totalDamage, move),
            pokemon,
            pokemon,
            "recoil"
        )
    end
    if move.struggleRecoil then
        local recoilDamage
        if self.dex.gen >= 5 then
            recoilDamage = self.battle:clampIntRange(
                math.floor((pokemon.baseMaxhp / 4) + 0.5),
                1
            )
        else
            recoilDamage = self.battle:clampIntRange(
                self.battle:trunc(pokemon.maxhp / 4),
                1
            )
        end
        self.battle:directDamage(recoilDamage, pokemon, pokemon, {id = "strugglerecoil"})
    end
    if move.smartTarget then
        targetsCopy = __TS__ArraySlice(targets, 0)
    end
    for ____, ____value in __TS__Iterator(
        targetsCopy:entries()
    ) do
        local i
        i = ____value[1]
        local target
        target = ____value[2]
        if target and (pokemon ~= target) then
            target:gotAttacked(move, moveDamage[i], pokemon)
        end
    end
    if move.ohko and (not targets[1].hp) then
        self.battle:add("-ohko")
    end
    if not __TS__ArraySome(
        damage,
        function(____, val) return (not (not val)) or (val == 0) end
    ) then
        return damage
    end
    self.battle:eachEvent("Update")
    self:afterMoveSecondaryEvent(
        __TS__ArrayFilter(
            targetsCopy,
            function(____, val) return not (not val) end
        ),
        pokemon,
        move
    )
    if (not move.negateSecondary) and (not (move.hasSheerForce and pokemon:hasAbility("sheerforce"))) then
        for ____, ____value in __TS__Iterator(
            damage:entries()
        ) do
            local i
            i = ____value[1]
            local d
            d = ____value[2]
            local curDamage = (((#targets == 1) and (function() return move.totalDamage end)) or (function() return d end))()
            if (type(curDamage) == "number") and targets[i].hp then
                local targetHPBeforeDamage = (targets[i].hurtThisTurn or 0) + curDamage
                if (targets[i].hp <= (targets[i].maxhp / 2)) and (targetHPBeforeDamage > (targets[i].maxhp / 2)) then
                    self.battle:runEvent("EmergencyExit", targets[i], pokemon)
                end
            end
        end
    end
    return damage
end
function BattleActions.prototype.spreadMoveHit(self, targets, pokemon, moveOrMoveName, hitEffect, isSecondary, isSelf)
    local target = targets[0]
    local damage = {}
    for ____, i in __TS__Iterator(
        targets:keys()
    ) do
        damage[i] = true
    end
    local move = self.dex:getActiveMove(moveOrMoveName)
    local hitResult = true
    local moveData = hitEffect
    if not moveData then
        moveData = move
    end
    if not moveData.flags then
        moveData.flags = {}
    end
    if (move.target == "all") and (not isSelf) then
        hitResult = self.battle:singleEvent("TryHitField", moveData, {}, target or nil, pokemon, move)
    elseif (((move.target == "foeSide") or (move.target == "allySide")) or (move.target == "allyTeam")) and (not isSelf) then
        hitResult = self.battle:singleEvent("TryHitSide", moveData, {}, target or nil, pokemon, move)
    elseif target then
        hitResult = self.battle:singleEvent("TryHit", moveData, {}, target, pokemon, move)
    end
    if not hitResult then
        if hitResult == false then
            self.battle:add("-fail", pokemon)
            self.battle:attrLastMove("[still]")
        end
        return {{false}, targets}
    end
    if (not isSecondary) and (not isSelf) then
        if (((move.target ~= "all") and (move.target ~= "allyTeam")) and (move.target ~= "allySide")) and (move.target ~= "foeSide") then
            damage = self:tryPrimaryHitEvent(damage, targets, pokemon, move, moveData, isSecondary)
        end
    end
    for ____, i in __TS__Iterator(
        targets:keys()
    ) do
        if damage[i] == self.battle.HIT_SUBSTITUTE then
            damage[i] = true
            targets[i] = nil
        end
        if (targets[i] and isSecondary) and (not moveData.self) then
            damage[i] = true
        end
        if not damage[i] then
            targets[i] = false
        end
    end
    damage = self:getSpreadDamage(damage, targets, pokemon, move, moveData, isSecondary, isSelf)
    for ____, i in __TS__Iterator(
        targets:keys()
    ) do
        if damage[i] == false then
            targets[i] = false
        end
    end
    damage = self.battle:spreadDamage(damage, targets, pokemon, move)
    for ____, i in __TS__Iterator(
        targets:keys()
    ) do
        if damage[i] == false then
            targets[i] = false
        end
    end
    damage = self:runMoveEffects(damage, targets, pokemon, move, moveData, isSecondary, isSelf)
    for ____, i in __TS__Iterator(
        targets:keys()
    ) do
        if (not damage[i]) and (damage[i] ~= 0) then
            targets[i] = false
        end
    end
    if moveData.self and (not move.selfDropped) then
        self:selfDrops(targets, pokemon, move, moveData, isSecondary)
    end
    if moveData.secondaries then
        self:secondaries(targets, pokemon, move, moveData, isSelf)
    end
    if moveData.forceSwitch then
        damage = self:forceSwitch(damage, targets, pokemon, move)
    end
    for ____, i in __TS__Iterator(
        targets:keys()
    ) do
        if (not damage[i]) and (damage[i] ~= 0) then
            targets[i] = false
        end
    end
    local damagedTargets = {}
    local damagedDamage = {}
    for ____, ____value in __TS__Iterator(
        targets:entries()
    ) do
        local i
        i = ____value[1]
        local t
        t = ____value[2]
        if (type(damage[i]) == "number") and t then
            __TS__ArrayPush(damagedTargets, t)
            __TS__ArrayPush(damagedDamage, damage[i])
        end
    end
    local pokemonOriginalHP = pokemon.hp
    if (#damagedDamage and (not isSecondary)) and (not isSelf) then
        self.battle:runEvent("DamagingHit", damagedTargets, pokemon, move, damagedDamage)
        if moveData.onAfterHit then
            for ____, t in ipairs(damagedTargets) do
                self.battle:singleEvent("AfterHit", moveData, {}, t, pokemon, move)
            end
        end
        if (pokemon.hp and (pokemon.hp <= (pokemon.maxhp / 2))) and (pokemonOriginalHP > (pokemon.maxhp / 2)) then
            self.battle:runEvent("EmergencyExit", pokemon)
        end
    end
    return {damage, targets}
end
function BattleActions.prototype.tryPrimaryHitEvent(self, damage, targets, pokemon, move, moveData, isSecondary)
    for ____, ____value in __TS__Iterator(
        targets:entries()
    ) do
        local i
        i = ____value[1]
        local target
        target = ____value[2]
        do
            if not target then
                goto __continue277
            end
            damage[i] = self.battle:runEvent("TryPrimaryHit", target, pokemon, moveData)
        end
        ::__continue277::
    end
    return damage
end
function BattleActions.prototype.getSpreadDamage(self, damage, targets, source, move, moveData, isSecondary, isSelf)
    for ____, ____value in __TS__Iterator(
        targets:entries()
    ) do
        local i
        i = ____value[1]
        local target
        target = ____value[2]
        do
            if not target then
                goto __continue280
            end
            self.battle.activeTarget = target
            damage[i] = nil
            local curDamage = self:getDamage(source, target, moveData)
            if (curDamage == false) or (curDamage == nil) then
                if ((damage[i] == false) and (not isSecondary)) and (not isSelf) then
                    self.battle:add("-fail", source)
                    self.battle:attrLastMove("[still]")
                end
                self.battle:debug("damage calculation interrupted")
                damage[i] = false
                goto __continue280
            end
            damage[i] = curDamage
            if move.selfdestruct == "ifHit" then
                self.battle:faint(source, source, move)
            end
        end
        ::__continue280::
    end
    return damage
end
function BattleActions.prototype.runMoveEffects(self, damage, targets, source, move, moveData, isSecondary, isSelf)
    local didAnything = damage:reduce(self.combineResults)
    for ____, ____value in __TS__Iterator(
        targets:entries()
    ) do
        local i
        i = ____value[1]
        local target
        target = ____value[2]
        do
            if target == false then
                goto __continue286
            end
            local hitResult
            local didSomething = nil
            if target then
                if moveData.boosts and (not target.fainted) then
                    hitResult = self.battle:boost(moveData.boosts, target, source, move, isSecondary, isSelf)
                    didSomething = self:combineResults(didSomething, hitResult)
                end
                if moveData.heal and (not target.fainted) then
                    if target.hp >= target.maxhp then
                        self.battle:add("-fail", target, "heal")
                        self.battle:attrLastMove("[still]")
                        damage[i] = self:combineResults(damage[i], false)
                        didAnything = self:combineResults(didAnything, nil)
                        goto __continue286
                    end
                    local amount = (target.baseMaxhp * moveData.heal[0]) / moveData.heal[1]
                    local d = target:heal(
                        (((self.battle.gen < 5) and (function() return Math.floor end)) or (function() return Math.round end))()(_G, amount)
                    )
                    if (not d) and (d ~= 0) then
                        self.battle:add("-fail", source)
                        self.battle:attrLastMove("[still]")
                        self.battle:debug("heal interrupted")
                        damage[i] = self:combineResults(damage[i], false)
                        didAnything = self:combineResults(didAnything, nil)
                        goto __continue286
                    end
                    self.battle:add("-heal", target, target.getHealth)
                    didSomething = true
                end
                if moveData.status then
                    hitResult = target:trySetStatus(
                        moveData.status,
                        source,
                        ((moveData.ability and (function() return moveData.ability end)) or (function() return move end))()
                    )
                    if (not hitResult) and move.status then
                        damage[i] = self:combineResults(damage[i], false)
                        didAnything = self:combineResults(didAnything, nil)
                        goto __continue286
                    end
                    didSomething = self:combineResults(didSomething, hitResult)
                end
                if moveData.forceStatus then
                    hitResult = target:setStatus(moveData.forceStatus, source, move)
                    didSomething = self:combineResults(didSomething, hitResult)
                end
                if moveData.volatileStatus then
                    hitResult = target:addVolatile(moveData.volatileStatus, source, move)
                    didSomething = self:combineResults(didSomething, hitResult)
                end
                if moveData.sideCondition then
                    hitResult = target.side:addSideCondition(moveData.sideCondition, source, move)
                    didSomething = self:combineResults(didSomething, hitResult)
                end
                if moveData.slotCondition then
                    hitResult = target.side:addSlotCondition(target, moveData.slotCondition, source, move)
                    didSomething = self:combineResults(didSomething, hitResult)
                end
                if moveData.weather then
                    hitResult = self.battle.field:setWeather(moveData.weather, source, move)
                    didSomething = self:combineResults(didSomething, hitResult)
                end
                if moveData.terrain then
                    hitResult = self.battle.field:setTerrain(moveData.terrain, source, move)
                    didSomething = self:combineResults(didSomething, hitResult)
                end
                if moveData.pseudoWeather then
                    hitResult = self.battle.field:addPseudoWeather(moveData.pseudoWeather, source, move)
                    didSomething = self:combineResults(didSomething, hitResult)
                end
                if moveData.forceSwitch then
                    hitResult = not (not self.battle:canSwitch(target.side))
                    didSomething = self:combineResults(didSomething, hitResult)
                end
                if (move.target == "all") and (not isSelf) then
                    if moveData.onHitField then
                        hitResult = self.battle:singleEvent("HitField", moveData, {}, target, source, move)
                        didSomething = self:combineResults(didSomething, hitResult)
                    end
                elseif ((move.target == "foeSide") or (move.target == "allySide")) and (not isSelf) then
                    if moveData.onHitSide then
                        hitResult = self.battle:singleEvent("HitSide", moveData, {}, target.side, source, move)
                        didSomething = self:combineResults(didSomething, hitResult)
                    end
                else
                    if moveData.onHit then
                        hitResult = self.battle:singleEvent("Hit", moveData, {}, target, source, move)
                        didSomething = self:combineResults(didSomething, hitResult)
                    end
                    if (not isSelf) and (not isSecondary) then
                        self.battle:runEvent("Hit", target, source, move)
                    end
                end
            end
            if moveData.selfSwitch then
                if self.battle:canSwitch(source.side) then
                    didSomething = true
                else
                    didSomething = self:combineResults(didSomething, false)
                end
            end
            if didSomething == nil then
                didSomething = true
            end
            damage[i] = self:combineResults(
                damage[i],
                (((didSomething == nil) and (function() return false end)) or (function() return didSomething end))()
            )
            didAnything = self:combineResults(didAnything, didSomething)
        end
        ::__continue286::
    end
    if (((not didAnything) and (didAnything ~= 0)) and (not moveData.self)) and (not moveData.selfdestruct) then
        if (not isSelf) and (not isSecondary) then
            if didAnything == false then
                self.battle:add("-fail", source)
                self.battle:attrLastMove("[still]")
            end
        end
        self.battle:debug("move failed because it did nothing")
    elseif move.selfSwitch and source.hp then
        source.switchFlag = move.id
    end
    return damage
end
function BattleActions.prototype.selfDrops(self, targets, source, move, moveData, isSecondary)
    for ____, target in __TS__Iterator(targets) do
        do
            if target == false then
                goto __continue319
            end
            if moveData.self and (not move.selfDropped) then
                if (not isSecondary) and moveData.self.boosts then
                    local secondaryRoll = self.battle:random(100)
                    if (type(moveData.self.chance) == "nil") or (secondaryRoll < moveData.self.chance) then
                        self:moveHit(source, source, move, moveData.self, isSecondary, true)
                    end
                    if not move.multihit then
                        move.selfDropped = true
                    end
                else
                    self:moveHit(source, source, move, moveData.self, isSecondary, true)
                end
            end
        end
        ::__continue319::
    end
end
function BattleActions.prototype.secondaries(self, targets, source, move, moveData, isSelf)
    if not moveData.secondaries then
        return
    end
    for ____, target in __TS__Iterator(targets) do
        do
            if target == false then
                goto __continue328
            end
            local secondaries = self.battle:runEvent(
                "ModifySecondaries",
                target,
                source,
                moveData,
                moveData.secondaries:slice()
            )
            for ____, secondary in ipairs(secondaries) do
                local secondaryRoll = self.battle:random(100)
                if (type(secondary.chance) == "nil") or (secondaryRoll < secondary.chance) then
                    self:moveHit(target, source, move, secondary, true, isSelf)
                end
            end
        end
        ::__continue328::
    end
end
function BattleActions.prototype.forceSwitch(self, damage, targets, source, move)
    for ____, ____value in __TS__Iterator(
        targets:entries()
    ) do
        local i
        i = ____value[1]
        local target
        target = ____value[2]
        if ((target and (target.hp > 0)) and (source.hp > 0)) and self.battle:canSwitch(target.side) then
            local hitResult = self.battle:runEvent("DragOut", target, source, move)
            if hitResult then
                target.forceSwitchFlag = true
            elseif (hitResult == false) and (move.category == "Status") then
                self.battle:add("-fail", source)
                self.battle:attrLastMove("[still]")
                damage[i] = false
            end
        end
    end
    return damage
end
function BattleActions.prototype.moveHit(self, targets, pokemon, moveOrMoveName, moveData, isSecondary, isSelf)
    if not __TS__ArrayIsArray(targets) then
        targets = {targets}
    end
    local retVal = self:spreadMoveHit(targets, pokemon, moveOrMoveName, moveData, isSecondary, isSelf)[1][0]
    return (((retVal == true) and (function() return nil end)) or (function() return retVal end))()
end
function BattleActions.prototype.calcRecoilDamage(self, damageDealt, move)
    return self.battle:clampIntRange(
        math.floor(((damageDealt * move.recoil[0]) / move.recoil[1]) + 0.5),
        1
    )
end
function BattleActions.prototype.getZMove(self, move, pokemon, skipChecks)
    local item = pokemon:getItem()
    if not skipChecks then
        if pokemon.side.zMoveUsed then
            return
        end
        if not item.zMove then
            return
        end
        if item.itemUser and (not item.itemUser:includes(pokemon.species.name)) then
            return
        end
        local moveData = pokemon:getMoveData(move)
        if not moveData.pp then
            return
        end
    end
    if item.zMoveFrom then
        if move.name == item.zMoveFrom then
            return item.zMove
        end
    elseif item.zMove == true then
        if move.type == item.zMoveType then
            if move.category == "Status" then
                return move.name
            elseif move.zMove.basePower then
                return self.Z_MOVES[move.type]
            end
        end
    end
end
function BattleActions.prototype.getActiveZMove(self, move, pokemon)
    if pokemon then
        local item = pokemon:getItem()
        if move.name == item.zMoveFrom then
            local zMove = self.dex:getActiveMove(item.zMove)
            zMove.isZOrMaxPowered = true
            return zMove
        end
    end
    if move.category == "Status" then
        local zMove = self.dex:getActiveMove(move)
        zMove.isZ = true
        zMove.isZOrMaxPowered = true
        return zMove
    end
    local zMove = self.dex:getActiveMove(self.Z_MOVES[move.type])
    zMove.basePower = move.zMove.basePower
    zMove.category = move.category
    zMove.priority = move.priority
    zMove.isZOrMaxPowered = true
    return zMove
end
function BattleActions.prototype.canZMove(self, pokemon)
    if pokemon.side.zMoveUsed or (pokemon.transformed and ((pokemon.species.isMega or pokemon.species.isPrimal) or (pokemon.species.forme == "Ultra"))) then
        return
    end
    local item = pokemon:getItem()
    if not item.zMove then
        return
    end
    if item.itemUser and (not item.itemUser:includes(pokemon.species.name)) then
        return
    end
    local atLeastOne = false
    local mustStruggle = true
    local zMoves = {}
    for ____, moveSlot in __TS__Iterator(pokemon.moveSlots) do
        do
            if moveSlot.pp <= 0 then
                zMoves:push(nil)
                goto __continue360
            end
            if not moveSlot.disabled then
                mustStruggle = false
            end
            local move = self.dex.moves:get(moveSlot.move)
            local zMoveName = self:getZMove(move, pokemon, true) or ""
            if zMoveName then
                local zMove = self.dex.moves:get(zMoveName)
                if (not zMove.isZ) and (zMove.category == "Status") then
                    zMoveName = "Z-" .. tostring(zMoveName)
                end
                zMoves:push({move = zMoveName, target = zMove.target})
            else
                zMoves:push(nil)
            end
            if zMoveName then
                atLeastOne = true
            end
        end
        ::__continue360::
    end
    if atLeastOne and (not mustStruggle) then
        return zMoves
    end
end
function BattleActions.prototype.getMaxMove(self, move, pokemon)
    if type(move) == "string" then
        move = self.dex.moves:get(move)
    end
    if move.name == "Struggle" then
        return move
    end
    if (pokemon.gigantamax and pokemon.canGigantamax) and (move.category ~= "Status") then
        local gMaxMove = self.dex.moves:get(pokemon.canGigantamax)
        if gMaxMove.exists and (gMaxMove.type == move.type) then
            return gMaxMove
        end
    end
    local maxMove = self.dex.moves:get(
        self.MAX_MOVES[(((move.category == "Status") and (function() return move.category end)) or (function() return move.type end))()]
    )
    if maxMove.exists then
        return maxMove
    end
end
function BattleActions.prototype.getActiveMaxMove(self, move, pokemon)
    if type(move) == "string" then
        move = self.dex:getActiveMove(move)
    end
    if move.name == "Struggle" then
        return self.dex:getActiveMove(move)
    end
    local maxMove = self.dex:getActiveMove(
        self.MAX_MOVES[(((move.category == "Status") and (function() return move.category end)) or (function() return move.type end))()]
    )
    if move.category ~= "Status" then
        if pokemon.gigantamax and pokemon.canGigantamax then
            local gMaxMove = self.dex:getActiveMove(pokemon.canGigantamax)
            if gMaxMove.exists and (gMaxMove.type == move.type) then
                maxMove = gMaxMove
            end
        end
        if not move.maxMove.basePower then
            error(
                __TS__New(
                    Error,
                    tostring(move.name) .. " doesn't have a maxMove basePower"
                ),
                0
            )
        end
        if not ({"gmaxdrumsolo", "gmaxfireball", "gmaxhydrosnipe"}):includes(maxMove.id) then
            maxMove.basePower = move.maxMove.basePower
        end
        maxMove.category = move.category
    end
    maxMove.baseMove = move.id
    maxMove.priority = move.priority
    maxMove.isZOrMaxPowered = true
    return maxMove
end
function BattleActions.prototype.runZPower(self, move, pokemon)
    local zPower = self.dex.conditions:get("zpower")
    if move.category ~= "Status" then
        self.battle:attrLastMove("[zeffect]")
    elseif move.zMove.boost then
        self.battle:boost(move.zMove.boost, pokemon, pokemon, zPower)
    elseif move.zMove.effect then
        local ____switch386 = move.zMove.effect
        local boosts, i
        if ____switch386 == "heal" then
            goto ____switch386_case_0
        elseif ____switch386 == "healreplacement" then
            goto ____switch386_case_1
        elseif ____switch386 == "clearnegativeboost" then
            goto ____switch386_case_2
        elseif ____switch386 == "redirect" then
            goto ____switch386_case_3
        elseif ____switch386 == "crit2" then
            goto ____switch386_case_4
        elseif ____switch386 == "curse" then
            goto ____switch386_case_5
        end
        goto ____switch386_end
        ::____switch386_case_0::
        do
            self.battle:heal(pokemon.maxhp, pokemon, pokemon, zPower)
            goto ____switch386_end
        end
        ::____switch386_case_1::
        do
            move.self = {slotCondition = "healreplacement"}
            goto ____switch386_end
        end
        ::____switch386_case_2::
        do
            boosts = {}
            for ____value in pairs(pokemon.boosts) do
                i = ____value
                if pokemon.boosts[i] < 0 then
                    boosts[i] = 0
                end
            end
            pokemon:setBoost(boosts)
            self.battle:add("-clearnegativeboost", pokemon, "[zeffect]")
            goto ____switch386_end
        end
        ::____switch386_case_3::
        do
            pokemon:addVolatile("followme", pokemon, zPower)
            goto ____switch386_end
        end
        ::____switch386_case_4::
        do
            pokemon:addVolatile("focusenergy", pokemon, zPower)
            goto ____switch386_end
        end
        ::____switch386_case_5::
        do
            if pokemon:hasType("Ghost") then
                self.battle:heal(pokemon.maxhp, pokemon, pokemon, zPower)
            else
                self.battle:boost({atk = 1}, pokemon, pokemon, zPower)
            end
        end
        ::____switch386_end::
    end
end
function BattleActions.prototype.targetTypeChoices(self, targetType)
    return CHOOSABLE_TARGETS:has(targetType)
end
function BattleActions.prototype.combineResults(self, left, right)
    local NOT_FAILURE = "string"
    local NULL = "object"
    local resultsPriorities = {"undefined", NOT_FAILURE, NULL, "boolean", "number"}
    if __TS__ArrayIndexOf(
        resultsPriorities,
        __TS__TypeOf(left)
    ) > __TS__ArrayIndexOf(
        resultsPriorities,
        __TS__TypeOf(right)
    ) then
        return left
    elseif (left and (not right)) and (right ~= 0) then
        return left
    elseif (type(left) == "number") and (type(right) == "number") then
        return left + right
    else
        return right
    end
end
function BattleActions.prototype.getDamage(self, pokemon, target, move, suppressMessages)
    if suppressMessages == nil then
        suppressMessages = false
    end
    if type(move) == "string" then
        move = self.dex:getActiveMove(move)
    end
    if type(move) == "number" then
        local basePower = move
        move = __TS__New(Dex.Move, {basePower = basePower, type = "???", category = "Physical", willCrit = false})
        move.hit = 0
    end
    if (not move.ignoreImmunity) or ((move.ignoreImmunity ~= true) and (not move.ignoreImmunity[move.type])) then
        if not target:runImmunity(move.type, not suppressMessages) then
            return false
        end
    end
    if move.ohko then
        return target.maxhp
    end
    if move.damageCallback then
        return move.damageCallback:call(self.battle, pokemon, target)
    end
    if move.damage == "level" then
        return pokemon.level
    elseif move.damage then
        return move.damage
    end
    local category = self.battle:getCategory(move)
    local defensiveCategory = move.defensiveCategory or category
    local basePower = move.basePower
    if move.basePowerCallback then
        basePower = move.basePowerCallback:call(self.battle, pokemon, target, move)
    end
    if not basePower then
        return (((basePower == 0) and (function() return nil end)) or (function() return basePower end))()
    end
    basePower = self.battle:clampIntRange(basePower, 1)
    local critMult
    local critRatio = self.battle:runEvent("ModifyCritRatio", pokemon, target, move, move.critRatio or 0)
    if self.battle.gen <= 5 then
        critRatio = self.battle:clampIntRange(critRatio, 0, 5)
        critMult = {0, 16, 8, 4, 3, 2}
    else
        critRatio = self.battle:clampIntRange(critRatio, 0, 4)
        if self.battle.gen == 6 then
            critMult = {0, 16, 8, 2, 1}
        else
            critMult = {0, 24, 8, 2, 1}
        end
    end
    local moveHit = target:getMoveHitData(move)
    moveHit.crit = move.willCrit or false
    if move.willCrit == nil then
        if critRatio then
            moveHit.crit = self.battle:randomChance(1, critMult[critRatio])
        end
    end
    if moveHit.crit then
        moveHit.crit = self.battle:runEvent("CriticalHit", target, nil, move)
    end
    basePower = self.battle:runEvent("BasePower", pokemon, target, move, basePower, true)
    if not basePower then
        return 0
    end
    basePower = self.battle:clampIntRange(basePower, 1)
    local level = pokemon.level
    local attacker = pokemon
    local defender = target
    local attackStat = ((category == "Physical") and "atk") or "spa"
    local defenseStat = ((defensiveCategory == "Physical") and "def") or "spd"
    if move.useSourceDefensiveAsOffensive then
        attackStat = defenseStat
        if self.battle.field.pseudoWeather.wonderroom ~= nil then
            if attackStat == "def" then
                attackStat = "spd"
            elseif attackStat == "spd" then
                attackStat = "def"
            end
            if attacker.boosts.def or attacker.boosts.spd then
                self.battle:hint("Body Press uses Sp. Def boosts when Wonder Room is active.")
            end
        end
    end
    local statTable = {atk = "Atk", def = "Def", spa = "SpA", spd = "SpD", spe = "Spe"}
    local attack
    local defense
    local atkBoosts = ((move.useTargetOffensive and (function() return defender.boosts[attackStat] end)) or (function() return attacker.boosts[attackStat] end))()
    local defBoosts = defender.boosts[defenseStat]
    local ignoreNegativeOffensive = not (not move.ignoreNegativeOffensive)
    local ignorePositiveDefensive = not (not move.ignorePositiveDefensive)
    if moveHit.crit then
        ignoreNegativeOffensive = true
        ignorePositiveDefensive = true
    end
    local ignoreOffensive = not (not (move.ignoreOffensive or (ignoreNegativeOffensive and (atkBoosts < 0))))
    local ignoreDefensive = not (not (move.ignoreDefensive or (ignorePositiveDefensive and (defBoosts > 0))))
    if ignoreOffensive then
        self.battle:debug("Negating (sp)atk boost/penalty.")
        atkBoosts = 0
    end
    if ignoreDefensive then
        self.battle:debug("Negating (sp)def boost/penalty.")
        defBoosts = 0
    end
    if move.useTargetOffensive then
        attack = defender:calculateStat(attackStat, atkBoosts)
    else
        attack = attacker:calculateStat(attackStat, atkBoosts)
    end
    attackStat = ((category == "Physical") and "atk") or "spa"
    defense = defender:calculateStat(defenseStat, defBoosts)
    attack = self.battle:runEvent(
        "Modify" .. tostring(statTable[attackStat]),
        attacker,
        defender,
        move,
        attack
    )
    defense = self.battle:runEvent(
        "Modify" .. tostring(statTable[defenseStat]),
        defender,
        attacker,
        move,
        defense
    )
    if ((self.battle.gen <= 4) and ({"explosion", "selfdestruct"}):includes(move.id)) and (defenseStat == "def") then
        defense = self.battle:clampIntRange(
            math.floor(defense / 2),
            1
        )
    end
    local tr = self.battle.trunc
    local baseDamage = tr(
        _G,
        tr(
            _G,
            tr(
                _G,
                (tr(_G, ((2 * level) / 5) + 2) * basePower) * attack
            ) / defense
        ) / 50
    )
    return self:modifyDamage(baseDamage, pokemon, target, move, suppressMessages)
end
function BattleActions.prototype.modifyDamage(self, baseDamage, pokemon, target, move, suppressMessages)
    if suppressMessages == nil then
        suppressMessages = false
    end
    local tr = self.battle.trunc
    if not move.type then
        move.type = "???"
    end
    local ____type = move.type
    baseDamage = baseDamage + 2
    if move.spreadHit then
        local spreadModifier = move.spreadModifier or (((self.battle.gameType == "freeforall") and 0.5) or 0.75)
        self.battle:debug(
            "Spread modifier: " .. tostring(spreadModifier)
        )
        baseDamage = self.battle:modify(baseDamage, spreadModifier)
    elseif (move.multihitType == "parentalbond") and (move.hit > 1) then
        local bondModifier = ((self.battle.gen > 6) and 0.25) or 0.5
        self.battle:debug(
            "Parental Bond modifier: " .. tostring(bondModifier)
        )
        baseDamage = self.battle:modify(baseDamage, bondModifier)
    end
    baseDamage = self.battle:runEvent("WeatherModifyDamage", pokemon, target, move, baseDamage)
    local isCrit = target:getMoveHitData(move).crit
    if isCrit then
        baseDamage = tr(_G, baseDamage * (move.critModifier or (((self.battle.gen >= 6) and 1.5) or 2)))
    end
    baseDamage = self.battle:randomizer(baseDamage)
    if move.forceSTAB or ((____type ~= "???") and pokemon:hasType(____type)) then
        baseDamage = self.battle:modify(baseDamage, move.stab or 1.5)
    end
    local typeMod = target:runEffectiveness(move)
    typeMod = self.battle:clampIntRange(typeMod, -6, 6)
    target:getMoveHitData(move).typeMod = typeMod
    if typeMod > 0 then
        if not suppressMessages then
            self.battle:add("-supereffective", target)
        end
        do
            local i = 0
            while i < typeMod do
                baseDamage = baseDamage * 2
                i = i + 1
            end
        end
    end
    if typeMod < 0 then
        if not suppressMessages then
            self.battle:add("-resisted", target)
        end
        do
            local i = 0
            while i > typeMod do
                baseDamage = tr(_G, baseDamage / 2)
                i = i - 1
            end
        end
    end
    if isCrit and (not suppressMessages) then
        self.battle:add("-crit", target)
    end
    if ((pokemon.status == "brn") and (move.category == "Physical")) and (not pokemon:hasAbility("guts")) then
        if (self.battle.gen < 6) or (move.id ~= "facade") then
            baseDamage = self.battle:modify(baseDamage, 0.5)
        end
    end
    if (self.battle.gen == 5) and (not baseDamage) then
        baseDamage = 1
    end
    baseDamage = self.battle:runEvent("ModifyDamage", pokemon, target, move, baseDamage)
    if move.isZOrMaxPowered and target:getMoveHitData(move).zBrokeProtect then
        baseDamage = self.battle:modify(baseDamage, 0.25)
        self.battle:add("-zbroken", target)
    end
    if (self.battle.gen ~= 5) and (not baseDamage) then
        return 1
    end
    return tr(_G, baseDamage, 16)
end
function BattleActions.prototype.getConfusionDamage(self, pokemon, basePower)
    local tr = self.battle.trunc
    local attack = pokemon:calculateStat("atk", pokemon.boosts.atk)
    local defense = pokemon:calculateStat("def", pokemon.boosts.def)
    local level = pokemon.level
    local baseDamage = tr(
        _G,
        tr(
            _G,
            tr(
                _G,
                (tr(_G, ((2 * level) / 5) + 2) * basePower) * attack
            ) / defense
        ) / 50
    ) + 2
    local damage = tr(_G, baseDamage, 16)
    damage = self.battle:randomizer(damage)
    return math.max(1, damage)
end
function BattleActions.prototype.canMegaEvo(self, pokemon)
    local species = pokemon.baseSpecies
    local altForme = species.otherFormes and self.dex.species:get(species.otherFormes[0])
    local item = pokemon:getItem()
    if (((((self.battle.gen <= 7) or self.battle.ruleTable:has("standardnatdex")) and altForme.isMega) and altForme.requiredMove) and pokemon.baseMoves:includes(
        toID(_G, altForme.requiredMove)
    )) and (not item.zMove) then
        return altForme.name
    end
    if (item.megaEvolves == species.baseSpecies) and (item.megaStone ~= species.name) then
        return item.megaStone
    end
    return nil
end
function BattleActions.prototype.canUltraBurst(self, pokemon)
    if ({"Necrozma-Dawn-Wings", "Necrozma-Dusk-Mane"}):includes(pokemon.baseSpecies.name) and (pokemon:getItem().id == "ultranecroziumz") then
        return "Necrozma-Ultra"
    end
    return nil
end
function BattleActions.prototype.runMegaEvo(self, pokemon)
    local speciesid = pokemon.canMegaEvo or pokemon.canUltraBurst
    if not speciesid then
        return false
    end
    for ____, foeActive in __TS__Iterator(
        pokemon:foes()
    ) do
        if foeActive.volatiles.skydrop.source == pokemon then
            return false
        end
    end
    pokemon:formeChange(
        speciesid,
        pokemon:getItem(),
        true
    )
    local wasMega = pokemon.canMegaEvo
    for ____, ally in __TS__Iterator(pokemon.side.pokemon) do
        if wasMega then
            ally.canMegaEvo = nil
        else
            ally.canUltraBurst = nil
        end
    end
    self.battle:runEvent("AfterMega", pokemon)
    return true
end
return ____exports
