--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____state = require("sim/state")
local State = ____state.State
local ____dex = require("sim/dex")
local toID = ____dex.toID
____exports.RESTORATIVE_BERRIES = __TS__New(Set, {"leppaberry", "aguavberry", "enigmaberry", "figyberry", "iapapaberry", "magoberry", "sitrusberry", "wikiberry", "oranberry"})
____exports.Pokemon = __TS__Class()
local Pokemon = ____exports.Pokemon
Pokemon.name = "Pokemon"
function Pokemon.prototype.____constructor(self, set, side)
    self.getDetails = function()
        local health = self:getHealth()
        local details = self.details
        if self.illusion then
            local illusionDetails = ((tostring(self.illusion.species.name) .. tostring(
                ((self.level == 100) and "") or (", L" .. tostring(self.level))
            )) .. tostring(
                ((self.illusion.gender == "") and "") or (", " .. tostring(self.illusion.gender))
            )) .. tostring((self.illusion.set.shiny and ", shiny") or "")
            details = illusionDetails
        end
        return {
            side = health.side,
            secret = (details .. "|") .. health.secret,
            shared = (details .. "|") .. tostring(health.shared)
        }
    end
    self.getHealth = function()
        if not self.hp then
            return {side = self.side.id, secret = "0 fnt", shared = "0 fnt"}
        end
        local secret = (tostring(self.hp) .. "/") .. tostring(self.maxhp)
        local shared
        local ratio = self.hp / self.maxhp
        if self.battle.reportExactHP then
            shared = secret
        elseif self.battle.reportPercentages or (self.battle.gen >= 8) then
            local percentage = math.ceil(ratio * 100)
            if (percentage == 100) and (ratio < 1) then
                percentage = 99
            end
            shared = tostring(percentage) .. "/100"
        else
            local pixels = math.floor(ratio * 48) or 1
            shared = tostring(pixels) .. "/48"
            if (pixels == 9) and (ratio > 0.2) then
                shared = tostring(shared) .. "y"
            elseif (pixels == 24) and (ratio > 0.5) then
                shared = tostring(shared) .. "g"
            end
        end
        if self.status then
            secret = tostring(secret) .. (" " .. tostring(self.status))
            shared = tostring(shared) .. (" " .. tostring(self.status))
        end
        return {side = self.side.id, secret = secret, shared = shared}
    end
    self.side = side
    self.battle = side.battle
    self.m = {}
    local pokemonScripts = self.battle.format.pokemon or self.battle.dex.data.Scripts.pokemon
    if pokemonScripts then
        __TS__ObjectAssign(self, pokemonScripts)
    end
    if type(set) == "string" then
        set = {name = set}
    end
    self.baseSpecies = self.battle.dex.species:get(set.species or set.name)
    if not self.baseSpecies.exists then
        error(
            __TS__New(
                Error,
                "Unidentified species: " .. tostring(self.baseSpecies.name)
            ),
            0
        )
    end
    self.set = set
    self.species = self.baseSpecies
    if (set.name == set.species) or (not set.name) then
        set.name = self.baseSpecies.baseSpecies
    end
    self.speciesState = {id = self.species.id}
    self.name = set.name:substr(0, 20)
    self.fullname = (tostring(self.side.id) .. ": ") .. tostring(self.name)
    set.level = self.battle:clampIntRange((set.adjustLevel or set.level) or 100, 1, 9999)
    self.level = set.level
    local genders = {M = "M", F = "F", N = "N"}
    self.gender = (genders[set.gender] or self.species.gender) or ((((self.battle:random() * 2) < 1) and "M") or "F")
    if self.gender == "N" then
        self.gender = ""
    end
    self.happiness = (((type(set.happiness) == "number") and (function() return self.battle:clampIntRange(set.happiness, 0, 255) end)) or (function() return 255 end))()
    self.pokeball = self.set.pokeball or "pokeball"
    self.gigantamax = self.set.gigantamax or false
    self.baseMoveSlots = {}
    self.moveSlots = {}
    if not self.set.moves.length then
        error(
            __TS__New(Error, ("Set " .. self.name) .. " has no moves"),
            0
        )
    end
    for ____, moveid in __TS__Iterator(self.set.moves) do
        do
            local move = self.battle.dex.moves:get(moveid)
            if not move.id then
                goto __continue9
            end
            if (move.id == "hiddenpower") and (move.type ~= "Normal") then
                if not set.hpType then
                    set.hpType = move.type
                end
                move = self.battle.dex.moves:get("hiddenpower")
            end
            local basepp = (((move.noPPBoosts or move.isZ) and (function() return move.pp end)) or (function() return (move.pp * 8) / 5 end))()
            if self.battle.gen < 3 then
                basepp = math.min(61, basepp)
            end
            __TS__ArrayPush(self.baseMoveSlots, {move = move.name, id = move.id, pp = basepp, maxpp = basepp, target = move.target, disabled = false, disabledSource = "", used = false})
        end
        ::__continue9::
    end
    self.position = 0
    self.details = ((tostring(self.species.name) .. tostring(
        ((self.level == 100) and "") or (", L" .. tostring(self.level))
    )) .. tostring(
        ((self.gender == "") and "") or (", " .. tostring(self.gender))
    )) .. tostring((self.set.shiny and ", shiny") or "")
    self.status = ""
    self.statusState = {}
    self.volatiles = {}
    self.showCure = false
    if not self.set.evs then
        self.set.evs = {hp = 0, atk = 0, def = 0, spa = 0, spd = 0, spe = 0}
    end
    if not self.set.ivs then
        self.set.ivs = {hp = 31, atk = 31, def = 31, spa = 31, spd = 31, spe = 31}
    end
    local stats = {hp = 31, atk = 31, def = 31, spe = 31, spa = 31, spd = 31}
    local stat
    for ____value in pairs(stats) do
        stat = ____value
        if not self.set.evs[stat] then
            self.set.evs[stat] = 0
        end
        if (not self.set.ivs[stat]) and (self.set.ivs[stat] ~= 0) then
            self.set.ivs[stat] = 31
        end
    end
    for ____value in pairs(self.set.evs) do
        stat = ____value
        self.set.evs[stat] = self.battle:clampIntRange(self.set.evs[stat], 0, 255)
    end
    for ____value in pairs(self.set.ivs) do
        stat = ____value
        self.set.ivs[stat] = self.battle:clampIntRange(self.set.ivs[stat], 0, 31)
    end
    if self.battle.gen and (self.battle.gen <= 2) then
        for ____value in pairs(self.set.ivs) do
            stat = ____value
            local ____obj, ____index = self.set.ivs, stat
            ____obj[____index] = bit.band(____obj[____index], 30)
        end
    end
    local hpData = self.battle.dex:getHiddenPower(self.set.ivs)
    self.hpType = set.hpType or hpData.type
    self.hpPower = hpData.power
    self.baseHpType = self.hpType
    self.baseHpPower = self.hpPower
    self.baseStoredStats = nil
    self.storedStats = {atk = 0, def = 0, spa = 0, spd = 0, spe = 0}
    self.boosts = {atk = 0, def = 0, spa = 0, spd = 0, spe = 0, accuracy = 0, evasion = 0}
    self.baseAbility = toID(_G, set.ability)
    self.ability = self.baseAbility
    self.abilityState = {id = self.ability}
    self.item = toID(_G, set.item)
    self.itemState = {id = self.item}
    self.lastItem = ""
    self.usedItemThisTurn = false
    self.ateBerry = false
    self.trapped = false
    self.maybeTrapped = false
    self.maybeDisabled = false
    self.illusion = nil
    self.transformed = false
    self.fainted = false
    self.faintQueued = false
    self.subFainted = nil
    self.types = self.baseSpecies.types
    self.addedType = ""
    self.knownType = true
    self.apparentType = self.baseSpecies.types:join("/")
    self.switchFlag = false
    self.forceSwitchFlag = false
    self.skipBeforeSwitchOutEventFlag = false
    self.draggedIn = nil
    self.newlySwitched = false
    self.beingCalledBack = false
    self.lastMove = nil
    self.lastMoveUsed = nil
    self.moveThisTurn = ""
    self.statsRaisedThisTurn = false
    self.statsLoweredThisTurn = false
    self.hurtThisTurn = nil
    self.lastDamage = 0
    self.attackedBy = {}
    self.isActive = false
    self.activeTurns = 0
    self.activeMoveActions = 0
    self.previouslySwitchedIn = 0
    self.truantTurn = false
    self.isStarted = false
    self.duringMove = false
    self.weighthg = 1
    self.speed = 0
    self.abilityOrder = 0
    self.canMegaEvo = self.battle.actions:canMegaEvo(self)
    self.canUltraBurst = self.battle.actions:canUltraBurst(self)
    self.canGigantamax = self.baseSpecies.canGigantamax or nil
    if self.battle.gen == 1 then
        self.modifiedStats = {atk = 0, def = 0, spa = 0, spd = 0, spe = 0}
    end
    self.maxhp = 0
    self.baseMaxhp = 0
    self.hp = 0
    self:clearVolatile()
    self.hp = self.maxhp
end
__TS__SetDescriptor(
    Pokemon.prototype,
    "moves",
    {
        get = function(self)
            return __TS__ArrayMap(
                self.moveSlots,
                function(____, moveSlot) return moveSlot.id end
            )
        end
    },
    true
)
__TS__SetDescriptor(
    Pokemon.prototype,
    "baseMoves",
    {
        get = function(self)
            return __TS__ArrayMap(
                self.baseMoveSlots,
                function(____, moveSlot) return moveSlot.id end
            )
        end
    },
    true
)
function Pokemon.prototype.toJSON(self)
    return State:serializePokemon(self)
end
function Pokemon.prototype.getSlot(self)
    local positionOffset = math.floor(self.side.n / 2) * self.side.active.length
    local positionLetter = __TS__StringCharAt("abcdef", self.position + positionOffset)
    return tostring(self.side.id) .. tostring(positionLetter)
end
function Pokemon.prototype.__tostring(self)
    local fullname = ((self.illusion and (function() return self.illusion.fullname end)) or (function() return self.fullname end))()
    return ((self.isActive and (function() return tostring(
        self:getSlot()
    ) .. tostring(
        string.sub(fullname, 3)
    ) end)) or (function() return fullname end))()
end
function Pokemon.prototype.updateSpeed(self)
    self.speed = self:getActionSpeed()
end
function Pokemon.prototype.calculateStat(self, statName, boost, modifier)
    statName = toID(_G, statName)
    if statName == "hp" then
        error(
            __TS__New(Error, "Please read `maxhp` directly"),
            0
        )
    end
    local stat = self.storedStats[statName]
    if self.battle.field.pseudoWeather.wonderroom ~= nil then
        if statName == "def" then
            stat = self.storedStats.spd
        elseif statName == "spd" then
            stat = self.storedStats.def
        end
    end
    local boosts = {}
    local boostName = statName
    boosts[boostName] = boost
    boosts = self.battle:runEvent("ModifyBoost", self, nil, nil, boosts)
    boost = boosts[boostName]
    local boostTable = {1, 1.5, 2, 2.5, 3, 3.5, 4}
    if boost > 6 then
        boost = 6
    end
    if boost < -6 then
        boost = -6
    end
    if boost >= 0 then
        stat = math.floor(stat * boostTable[boost + 1])
    else
        stat = math.floor(stat / boostTable[-boost + 1])
    end
    return self.battle:modify(stat, modifier or 1)
end
function Pokemon.prototype.getStat(self, statName, unboosted, unmodified)
    statName = toID(_G, statName)
    if statName == "hp" then
        error(
            __TS__New(Error, "Please read `maxhp` directly"),
            0
        )
    end
    local stat = self.storedStats[statName]
    if unmodified and (self.battle.field.pseudoWeather.wonderroom ~= nil) then
        if statName == "def" then
            statName = "spd"
        elseif statName == "spd" then
            statName = "def"
        end
    end
    if not unboosted then
        local boosts = self.battle:runEvent(
            "ModifyBoost",
            self,
            nil,
            nil,
            __TS__ObjectAssign({}, self.boosts)
        )
        local boost = boosts[statName]
        local boostTable = {1, 1.5, 2, 2.5, 3, 3.5, 4}
        if boost > 6 then
            boost = 6
        end
        if boost < -6 then
            boost = -6
        end
        if boost >= 0 then
            stat = math.floor(stat * boostTable[boost])
        else
            stat = math.floor(stat / boostTable[-boost + 1])
        end
    end
    if not unmodified then
        local statTable = {atk = "Atk", def = "Def", spa = "SpA", spd = "SpD", spe = "Spe"}
        stat = self.battle:runEvent(
            "Modify" .. tostring(statTable[statName]),
            self,
            nil,
            nil,
            stat
        )
    end
    if (statName == "spe") and (stat > 10000) then
        stat = 10000
    end
    return stat
end
function Pokemon.prototype.getActionSpeed(self)
    local speed = self:getStat("spe", false, false)
    if self.battle.field:getPseudoWeather("trickroom") then
        speed = 10000 - speed
    end
    return self.battle:trunc(speed, 13)
end
function Pokemon.prototype.getWeight(self)
    local weighthg = self.battle:runEvent("ModifyWeight", self, nil, nil, self.weighthg)
    return math.max(1, weighthg)
end
function Pokemon.prototype.getMoveData(self, move)
    move = self.battle.dex.moves:get(move)
    for ____, moveSlot in ipairs(self.moveSlots) do
        if moveSlot.id == move.id then
            return moveSlot
        end
    end
    return nil
end
function Pokemon.prototype.getMoveHitData(self, move)
    if not move.moveHitData then
        move.moveHitData = {}
    end
    local slot = self:getSlot()
    return move.moveHitData[slot] or (function(o, i, v)
        o[i] = v
        return v
    end)(move.moveHitData, slot, {crit = false, typeMod = 0, zBrokeProtect = false})
end
function Pokemon.prototype.alliesAndSelf(self)
    return self.side:allies()
end
function Pokemon.prototype.allies(self)
    return self.side:allies():filter(
        function(____, ally) return ally ~= self end
    )
end
function Pokemon.prototype.adjacentAllies(self)
    return self.side:allies():filter(
        function(____, ally) return self:isAdjacent(ally) end
    )
end
function Pokemon.prototype.foes(self, all)
    return self.side:foes(all)
end
function Pokemon.prototype.adjacentFoes(self)
    if self.battle.activePerHalf <= 2 then
        return self.side:foes()
    end
    return self.side:foes():filter(
        function(____, foe) return self:isAdjacent(foe) end
    )
end
function Pokemon.prototype.isAlly(self, pokemon)
    return (not (not pokemon)) and ((self.side == pokemon.side) or (self.side.allySide == pokemon.side))
end
function Pokemon.prototype.isAdjacent(self, pokemon2)
    if self.fainted or pokemon2.fainted then
        return false
    end
    if self.battle.activePerHalf <= 2 then
        return self ~= pokemon2
    end
    if self.side == pokemon2.side then
        return math.abs(self.position - pokemon2.position) == 1
    end
    return math.abs(((self.position + pokemon2.position) + 1) - self.side.active.length) <= 1
end
function Pokemon.prototype.getUndynamaxedHP(self, amount)
    local hp = amount or self.hp
    if self.volatiles.dynamax then
        return math.ceil((hp * self.baseMaxhp) / self.maxhp)
    end
    return hp
end
function Pokemon.prototype.getSmartTargets(self, target, move)
    local target2 = target:adjacentAllies()[1]
    if ((not target2) or (target2 == self)) or (not target2.hp) then
        move.smartTarget = false
        return {target}
    end
    if not target.hp then
        move.smartTarget = false
        return {target2}
    end
    return {target, target2}
end
function Pokemon.prototype.getAtLoc(self, targetLoc)
    local side = self.battle.sides[(((targetLoc < 0) and (function() return self.side.n % 2 end)) or (function() return (self.side.n + 1) % 2 end))()]
    targetLoc = math.abs(targetLoc)
    if targetLoc > side.active.length then
        targetLoc = targetLoc - side.active.length
        side = self.battle.sides[side.n + 2]
    end
    return side.active[targetLoc - 1]
end
function Pokemon.prototype.getLocOf(self, target)
    local positionOffset = math.floor(target.side.n / 2) * target.side.active.length
    local position = (target.position + positionOffset) + 1
    local sameHalf = (self.side.n % 2) == (target.side.n % 2)
    return ((sameHalf and (function() return -position end)) or (function() return position end))()
end
function Pokemon.prototype.getMoveTargets(self, move, target)
    local targets = {}
    local ____switch96 = move.target
    local selectedTarget
    if ____switch96 == "all" then
        goto ____switch96_case_0
    elseif ____switch96 == "foeSide" then
        goto ____switch96_case_1
    elseif ____switch96 == "allySide" then
        goto ____switch96_case_2
    elseif ____switch96 == "allyTeam" then
        goto ____switch96_case_3
    elseif ____switch96 == "allAdjacent" then
        goto ____switch96_case_4
    elseif ____switch96 == "allAdjacentFoes" then
        goto ____switch96_case_5
    elseif ____switch96 == "allies" then
        goto ____switch96_case_6
    end
    goto ____switch96_case_default
    ::____switch96_case_0::
    do
    end
    ::____switch96_case_1::
    do
    end
    ::____switch96_case_2::
    do
    end
    ::____switch96_case_3::
    do
        if not move.target:startsWith("foe") then
            __TS__ArrayPush(
                targets,
                __TS__Unpack(
                    self:alliesAndSelf()
                )
            )
        end
        if not move.target:startsWith("ally") then
            __TS__ArrayPush(
                targets,
                __TS__Unpack(
                    self:foes(true)
                )
            )
        end
        if #targets and (not targets:includes(target)) then
            self.battle:retargetLastMove(targets[#targets])
        end
        goto ____switch96_end
    end
    ::____switch96_case_4::
    do
        __TS__ArrayPush(
            targets,
            __TS__Unpack(
                self:adjacentAllies()
            )
        )
    end
    ::____switch96_case_5::
    do
        __TS__ArrayPush(
            targets,
            __TS__Unpack(
                self:adjacentFoes()
            )
        )
        if #targets and (not targets:includes(target)) then
            self.battle:retargetLastMove(targets[#targets])
        end
        goto ____switch96_end
    end
    ::____switch96_case_6::
    do
        targets = self:alliesAndSelf()
        goto ____switch96_end
    end
    ::____switch96_case_default::
    do
        selectedTarget = target
        if (not target) or ((target.fainted and (not target:isAlly(self))) and (self.battle.gameType ~= "freeforall")) then
            local possibleTarget = self.battle:getRandomTarget(self, move)
            if not possibleTarget then
                return {targets = {}, pressureTargets = {}}
            end
            target = possibleTarget
        end
        if (self.battle.activePerHalf > 1) and (not move.tracksTarget) then
            local isCharging = ((move.flags.charge and (not self.volatiles.twoturnmove)) and (not (move.id:startsWith("solarb") and self.battle.field:isWeather({"sunnyday", "desolateland"})))) and (not (self:hasItem("powerherb") and (move.id ~= "skydrop")))
            if not isCharging then
                target = self.battle:priorityEvent("RedirectTarget", self, self, move, target)
            end
        end
        if move.smartTarget then
            targets = self:getSmartTargets(target, move)
            target = targets[1]
        else
            __TS__ArrayPush(targets, target)
        end
        if target.fainted and (not move.isFutureMove) then
            return {targets = {}, pressureTargets = {}}
        end
        if selectedTarget ~= target then
            self.battle:retargetLastMove(target)
        end
    end
    ::____switch96_end::
    local pressureTargets = targets
    local ____switch109 = move.pressureTarget
    if ____switch109 == "foeSide" then
        goto ____switch109_case_0
    elseif ____switch109 == "self" then
        goto ____switch109_case_1
    end
    goto ____switch109_end
    ::____switch109_case_0::
    do
        pressureTargets = self:foes()
        goto ____switch109_end
    end
    ::____switch109_case_1::
    do
        pressureTargets = {}
        goto ____switch109_end
    end
    ::____switch109_end::
    return {targets = targets, pressureTargets = pressureTargets}
end
function Pokemon.prototype.ignoringAbility(self)
    local neutralizinggas = false
    for ____, pokemon in __TS__Iterator(
        self.battle:getAllActive()
    ) do
        if ((pokemon.ability == "neutralizinggas") and (not pokemon.volatiles.gastroacid)) and (not pokemon.abilityState.ending) then
            neutralizinggas = true
            break
        end
    end
    return not (not (((self.battle.gen >= 5) and (not self.isActive)) or ((self.volatiles.gastroacid or (neutralizinggas and (self.ability ~= "neutralizinggas"))) and (not self:getAbility().isPermanent))))
end
function Pokemon.prototype.ignoringItem(self)
    return not (not (((((self.battle.gen >= 5) and (not self.isActive)) or (self:hasAbility("klutz") and (not self:getItem().ignoreKlutz))) or self.volatiles.embargo) or self.battle.field.pseudoWeather.magicroom))
end
function Pokemon.prototype.deductPP(self, move, amount, target)
    local gen = self.battle.gen
    move = self.battle.dex.moves:get(move)
    local ppData = self:getMoveData(move)
    if not ppData then
        return 0
    end
    ppData.used = true
    if (not ppData.pp) and (gen > 1) then
        return 0
    end
    if not amount then
        amount = 1
    end
    ppData.pp = ppData.pp - amount
    if (ppData.pp < 0) and (gen > 1) then
        amount = amount + ppData.pp
        ppData.pp = 0
    end
    return amount
end
function Pokemon.prototype.moveUsed(self, move, targetLoc)
    self.lastMove = move
    self.lastMoveTargetLoc = targetLoc
    self.moveThisTurn = move.id
end
function Pokemon.prototype.gotAttacked(self, move, damage, source)
    local damageNumber = (((type(damage) == "number") and (function() return damage end)) or (function() return 0 end))()
    move = self.battle.dex.moves:get(move)
    __TS__ArrayPush(
        self.attackedBy,
        {
            source = source,
            damage = damageNumber,
            move = move.id,
            thisTurn = true,
            slot = source:getSlot(),
            damageValue = damage
        }
    )
end
function Pokemon.prototype.getLastAttackedBy(self)
    if #self.attackedBy == 0 then
        return nil
    end
    return self.attackedBy[#self.attackedBy]
end
function Pokemon.prototype.getLastDamagedBy(self, filterOutSameSide)
    local damagedBy = __TS__ArrayFilter(
        self.attackedBy,
        function(____, attacker) return (type(attacker.damageValue) == "number") and ((filterOutSameSide == nil) or (not self:isAlly(attacker.source))) end
    )
    if #damagedBy == 0 then
        return nil
    end
    return damagedBy[#damagedBy]
end
function Pokemon.prototype.getLockedMove(self)
    local lockedMove = self.battle:runEvent("LockMove", self)
    return (((lockedMove == true) and (function() return nil end)) or (function() return lockedMove end))()
end
function Pokemon.prototype.getMoves(self, lockedMove, restrictData)
    if lockedMove then
        lockedMove = toID(_G, lockedMove)
        self.trapped = true
        if lockedMove == "recharge" then
            return {{move = "Recharge", id = "recharge"}}
        end
        for ____, moveSlot in ipairs(self.moveSlots) do
            do
                if moveSlot.id ~= lockedMove then
                    goto __continue130
                end
                return {{move = moveSlot.move, id = moveSlot.id}}
            end
            ::__continue130::
        end
        return {
            {
                move = self.battle.dex.moves:get(lockedMove).name,
                id = lockedMove
            }
        }
    end
    local moves = {}
    local hasValidMove = false
    for ____, moveSlot in ipairs(self.moveSlots) do
        local moveName = moveSlot.move
        if moveSlot.id == "hiddenpower" then
            moveName = "Hidden Power " .. tostring(self.hpType)
            if self.battle.gen < 6 then
                moveName = tostring(moveName) .. (" " .. tostring(self.hpPower))
            end
        elseif (moveSlot.id == "return") or (moveSlot.id == "frustration") then
            local basePowerCallback = self.battle.dex.moves:get(moveSlot.id).basePowerCallback
            moveName = tostring(moveName) .. (" " .. tostring(
                basePowerCallback(_G, self)
            ))
        end
        local target = moveSlot.target
        if moveSlot.id == "curse" then
            if not self:hasType("Ghost") then
                target = self.battle.dex.moves:get("curse").nonGhostTarget or moveSlot.target
            end
        end
        local disabled = moveSlot.disabled
        if self.volatiles.dynamax then
            local canCauseStruggle = {"Encore", "Disable", "Taunt", "Assault Vest", "Belch", "Stuff Cheeks"}
            disabled = self:maxMoveDisabled(moveSlot.id) or (disabled and canCauseStruggle:includes(moveSlot.disabledSource))
        elseif ((moveSlot.pp <= 0) and (not self.volatiles.partialtrappinglock)) or ((disabled and (self.side.active.length >= 2)) and self.battle.actions:targetTypeChoices(target)) then
            disabled = true
        end
        if not disabled then
            hasValidMove = true
        elseif (disabled == "hidden") and restrictData then
            disabled = false
        end
        __TS__ArrayPush(moves, {move = moveName, id = moveSlot.id, pp = moveSlot.pp, maxpp = moveSlot.maxpp, target = target, disabled = disabled})
    end
    return ((hasValidMove and (function() return moves end)) or (function() return {} end))()
end
function Pokemon.prototype.maxMoveDisabled(self, baseMove)
    baseMove = self.battle.dex.moves:get(baseMove)
    if not self:getMoveData(baseMove.id).pp then
        return true
    end
    return not (not ((baseMove.category == "Status") and (self:hasItem("assaultvest") or self.volatiles.taunt)))
end
function Pokemon.prototype.getDynamaxRequest(self, skipChecks)
    if not skipChecks then
        if not self.side:canDynamaxNow() then
            return
        end
        if (((self.species.isMega or self.species.isPrimal) or (self.species.forme == "Ultra")) or self:getItem().zMove) or self.canMegaEvo then
            return
        end
        if self.species.cannotDynamax or self.illusion.species.cannotDynamax then
            return
        end
    end
    local result = {maxMoves = {}}
    local atLeastOne = false
    for ____, moveSlot in ipairs(self.moveSlots) do
        local move = self.battle.dex.moves:get(moveSlot.id)
        local maxMove = self.battle.actions:getMaxMove(move, self)
        if maxMove then
            if self:maxMoveDisabled(move) then
                result.maxMoves:push({move = maxMove.id, target = maxMove.target, disabled = true})
            else
                result.maxMoves:push({move = maxMove.id, target = maxMove.target})
                atLeastOne = true
            end
        end
    end
    if not atLeastOne then
        return
    end
    if self.canGigantamax then
        result.gigantamax = self.canGigantamax
    end
    return result
end
function Pokemon.prototype.getMoveRequestData(self)
    local lockedMove = self:getLockedMove()
    local isLastActive = self:isLastActive()
    local canSwitchIn = self.battle:canSwitch(self.side) > 0
    local moves = self:getMoves(lockedMove, isLastActive)
    if not #moves then
        moves = {{move = "Struggle", id = "struggle", target = "randomNormal", disabled = false}}
        lockedMove = "struggle"
    end
    local data = {moves = moves}
    if isLastActive then
        if self.maybeDisabled then
            data.maybeDisabled = true
        end
        if canSwitchIn then
            if self.trapped == true then
                data.trapped = true
            elseif self.maybeTrapped then
                data.maybeTrapped = true
            end
        end
    elseif canSwitchIn then
        if self.trapped then
            data.trapped = true
        end
    end
    if not lockedMove then
        if self.canMegaEvo then
            data.canMegaEvo = true
        end
        if self.canUltraBurst then
            data.canUltraBurst = true
        end
        local canZMove = self.battle.actions:canZMove(self)
        if canZMove then
            data.canZMove = canZMove
        end
        if self:getDynamaxRequest() then
            data.canDynamax = true
        end
        if data.canDynamax or self.volatiles.dynamax then
            data.maxMoves = self:getDynamaxRequest(true)
        end
    end
    return data
end
function Pokemon.prototype.getSwitchRequestData(self, forAlly)
    local entry = {
        ident = self.fullname,
        details = self.details,
        condition = self:getHealth().secret,
        active = self.position < self.side.active.length,
        stats = {atk = self.baseStoredStats.atk, def = self.baseStoredStats.def, spa = self.baseStoredStats.spa, spd = self.baseStoredStats.spd, spe = self.baseStoredStats.spe},
        moves = __TS__ArrayMap(
            self[(forAlly and "baseMoves") or "moves"],
            function(____, move)
                if move == "hiddenpower" then
                    return (tostring(move) .. tostring(
                        toID(_G, self.hpType)
                    )) .. tostring(((self.battle.gen < 6) and "") or self.hpPower)
                end
                if (move == "frustration") or (move == "return") then
                    local basePowerCallback = self.battle.dex.moves:get(move).basePowerCallback
                    return tostring(move) .. tostring(
                        basePowerCallback(_G, self)
                    )
                end
                return move
            end
        ),
        baseAbility = self.baseAbility,
        item = self.item,
        pokeball = self.pokeball
    }
    if self.battle.gen > 6 then
        entry.ability = self.ability
    end
    return entry
end
function Pokemon.prototype.isLastActive(self)
    if not self.isActive then
        return false
    end
    local allyActive = self.side.active
    do
        local i = self.position + 1
        while i < allyActive.length do
            if allyActive[i] and (not allyActive[i].fainted) then
                return false
            end
            i = i + 1
        end
    end
    return true
end
function Pokemon.prototype.positiveBoosts(self)
    local boosts = 0
    local boost
    for ____value in pairs(self.boosts) do
        boost = ____value
        if self.boosts[boost] > 0 then
            boosts = boosts + self.boosts[boost]
        end
    end
    return boosts
end
function Pokemon.prototype.boostBy(self, boosts)
    local delta = 0
    local boostName
    for ____value in pairs(boosts) do
        boostName = ____value
        delta = boosts[boostName]
        local ____obj, ____index = self.boosts, boostName
        ____obj[____index] = ____obj[____index] + delta
        if self.boosts[boostName] > 6 then
            delta = delta - (self.boosts[boostName] - 6)
            self.boosts[boostName] = 6
        end
        if self.boosts[boostName] < -6 then
            delta = delta - (self.boosts[boostName] - -6)
            self.boosts[boostName] = -6
        end
    end
    return delta
end
function Pokemon.prototype.clearBoosts(self)
    local boostName
    for ____value in pairs(self.boosts) do
        boostName = ____value
        self.boosts[boostName] = 0
    end
end
function Pokemon.prototype.setBoost(self, boosts)
    local boostName
    for ____value in pairs(boosts) do
        boostName = ____value
        self.boosts[boostName] = boosts[boostName]
    end
end
function Pokemon.prototype.copyVolatileFrom(self, pokemon)
    self:clearVolatile()
    self.boosts = pokemon.boosts
    for i in pairs(pokemon.volatiles) do
        do
            if self.battle.dex.conditions:getByID(i).noCopy then
                goto __continue191
            end
            self.volatiles[i] = __TS__ObjectAssign({}, pokemon.volatiles[i])
            if self.volatiles[i].linkedPokemon then
                __TS__Delete(pokemon.volatiles[i], "linkedPokemon")
                __TS__Delete(pokemon.volatiles[i], "linkedStatus")
                for ____, linkedPoke in __TS__Iterator(self.volatiles[i].linkedPokemon) do
                    local linkedPokeLinks = linkedPoke.volatiles[self.volatiles[i].linkedStatus].linkedPokemon
                    linkedPokeLinks[linkedPokeLinks:indexOf(pokemon)] = self
                end
            end
        end
        ::__continue191::
    end
    pokemon:clearVolatile()
    for i in pairs(self.volatiles) do
        local volatile = self:getVolatile(i)
        self.battle:singleEvent("Copy", volatile, self.volatiles[i], self)
    end
end
function Pokemon.prototype.transformInto(self, pokemon, effect)
    local species = pokemon.species
    if ((((pokemon.fainted or pokemon.illusion) or (pokemon.volatiles.substitute and (self.battle.gen >= 5))) or (pokemon.transformed and (self.battle.gen >= 2))) or (self.transformed and (self.battle.gen >= 5))) or (species.name == "Eternatus-Eternamax") then
        return false
    end
    if (self.battle.dex.currentMod == "gen1stadium") and ((species.name == "Ditto") or ((self.species.name == "Ditto") and pokemon.moves:includes("transform"))) then
        return false
    end
    if not self:setSpecies(species, effect, true) then
        return false
    end
    self.transformed = true
    self.weighthg = pokemon.weighthg
    local types = pokemon:getTypes(true)
    self:setType(
        ((pokemon.volatiles.roost and (function() return pokemon.volatiles.roost.typeWas end)) or (function() return types end))(),
        true
    )
    self.addedType = pokemon.addedType
    self.knownType = self:isAlly(pokemon) and pokemon.knownType
    self.apparentType = pokemon.apparentType
    local statName
    for ____value in pairs(self.storedStats) do
        statName = ____value
        self.storedStats[statName] = pokemon.storedStats[statName]
    end
    self.moveSlots = {}
    self.set.ivs = (((self.battle.gen >= 5) and (function() return self.set.ivs end)) or (function() return pokemon.set.ivs end))()
    self.hpType = (((self.battle.gen >= 5) and (function() return self.hpType end)) or (function() return pokemon.hpType end))()
    self.hpPower = (((self.battle.gen >= 5) and (function() return self.hpPower end)) or (function() return pokemon.hpPower end))()
    for ____, moveSlot in ipairs(pokemon.moveSlots) do
        local moveName = moveSlot.move
        if moveSlot.id == "hiddenpower" then
            moveName = "Hidden Power " .. tostring(self.hpType)
        end
        __TS__ArrayPush(
            self.moveSlots,
            {
                move = moveName,
                id = moveSlot.id,
                pp = ((moveSlot.maxpp == 1) and 1) or 5,
                maxpp = (((self.battle.gen >= 5) and (function() return ((moveSlot.maxpp == 1) and 1) or 5 end)) or (function() return moveSlot.maxpp end))(),
                target = moveSlot.target,
                disabled = false,
                used = false,
                virtual = true
            }
        )
    end
    local boostName
    for ____value in pairs(pokemon.boosts) do
        boostName = ____value
        self.boosts[boostName] = pokemon.boosts[boostName]
    end
    if self.battle.gen >= 6 then
        local volatilesToCopy = {"focusenergy", "gmaxchistrike", "laserfocus"}
        for ____, volatile in ipairs(volatilesToCopy) do
            if pokemon.volatiles[volatile] then
                self:addVolatile(volatile)
                if volatile == "gmaxchistrike" then
                    self.volatiles[volatile].layers = pokemon.volatiles[volatile].layers
                end
            else
                self:removeVolatile(volatile)
            end
        end
    end
    if effect then
        self.battle:add(
            "-transform",
            self,
            pokemon,
            "[from] " .. tostring(effect.fullname)
        )
    else
        self.battle:add("-transform", self, pokemon)
    end
    if self.battle.gen > 2 then
        self:setAbility(pokemon.ability, self, true)
    end
    if self.battle.gen == 4 then
        if self.species.num == 487 then
            if (self.species.name == "Giratina") and (self.item == "griseousorb") then
                self:formeChange("Giratina-Origin")
            elseif (self.species.name == "Giratina-Origin") and (self.item ~= "griseousorb") then
                self:formeChange("Giratina")
            end
        end
        if self.species.num == 493 then
            local item = self:getItem()
            local targetForme = ((item.onPlate and (function() return "Arceus-" .. tostring(item.onPlate) end)) or (function() return "Arceus" end))()
            if self.species.name ~= targetForme then
                self:formeChange(targetForme)
            end
        end
    end
    return true
end
function Pokemon.prototype.setSpecies(self, rawSpecies, source, isTransform)
    if source == nil then
        source = self.battle.effect
    end
    if isTransform == nil then
        isTransform = false
    end
    local species = self.battle:runEvent("ModifySpecies", self, nil, source, rawSpecies)
    if not species then
        return nil
    end
    self.species = species
    self:setType(species.types, true)
    self.apparentType = rawSpecies.types:join("/")
    self.addedType = species.addedType or ""
    self.knownType = true
    self.weighthg = species.weighthg
    local stats = self.battle:spreadModify(self.species.baseStats, self.set)
    if self.species.maxHP then
        stats.hp = self.species.maxHP
    end
    if not self.maxhp then
        self.baseMaxhp = stats.hp
        self.maxhp = stats.hp
        self.hp = stats.hp
    end
    if not isTransform then
        self.baseStoredStats = stats
    end
    local statName
    for ____value in pairs(self.storedStats) do
        statName = ____value
        self.storedStats[statName] = stats[statName]
        if self.modifiedStats then
            self.modifiedStats[statName] = stats[statName]
        end
    end
    if self.battle.gen <= 1 then
        if self.status == "par" then
            self.modifyStat(_G, "spe", 0.25)
        end
        if self.status == "brn" then
            self.modifyStat(_G, "atk", 0.5)
        end
    end
    self.speed = self.storedStats.spe
    return species
end
function Pokemon.prototype.formeChange(self, speciesId, source, isPermanent, message)
    if source == nil then
        source = self.battle.effect
    end
    local rawSpecies = self.battle.dex.species:get(speciesId)
    local species = self:setSpecies(rawSpecies, source)
    if not species then
        return false
    end
    if self.battle.gen <= 2 then
        return true
    end
    local apparentSpecies = ((self.illusion and (function() return self.illusion.species.name end)) or (function() return species.baseSpecies end))()
    if isPermanent then
        self.baseSpecies = rawSpecies
        self.details = ((tostring(species.name) .. tostring(
            ((self.level == 100) and "") or (", L" .. tostring(self.level))
        )) .. tostring(
            ((self.gender == "") and "") or (", " .. tostring(self.gender))
        )) .. tostring((self.set.shiny and ", shiny") or "")
        self.battle:add("detailschange", self, (self.illusion or self).details)
        if source.effectType == "Item" then
            if source.zMove then
                self.battle:add("-burst", self, apparentSpecies, species.requiredItem)
                self.moveThisTurnResult = true
            elseif source.onPrimal then
                if self.illusion then
                    self.ability = ""
                    self.battle:add("-primal", self.illusion)
                else
                    self.battle:add("-primal", self)
                end
            else
                self.battle:add("-mega", self, apparentSpecies, species.requiredItem)
                self.moveThisTurnResult = true
            end
        elseif source.effectType == "Status" then
            self.battle:add("-formechange", self, species.name, message)
        end
    else
        if source.effectType == "Ability" then
            self.battle:add(
                "-formechange",
                self,
                species.name,
                message,
                "[from] ability: " .. tostring(source.name)
            )
        else
            self.battle:add(
                "-formechange",
                self,
                ((self.illusion and (function() return self.illusion.species.name end)) or (function() return species.name end))(),
                message
            )
        end
    end
    if isPermanent and (not ({"disguise", "iceface"}):includes(source.id)) then
        if self.illusion then
            self.ability = ""
        end
        self:setAbility(species.abilities["0"], nil, true)
        self.baseAbility = self.ability
    end
    return true
end
function Pokemon.prototype.clearVolatile(self, includeSwitchFlags)
    if includeSwitchFlags == nil then
        includeSwitchFlags = true
    end
    self.boosts = {atk = 0, def = 0, spa = 0, spd = 0, spe = 0, accuracy = 0, evasion = 0}
    if ((self.battle.gen == 1) and self.baseMoves:includes("mimic")) and (not self.transformed) then
        local moveslot = __TS__ArrayIndexOf(self.baseMoves, "mimic")
        local mimicPP = ((self.moveSlots[moveslot + 1] and (function() return self.moveSlots[moveslot + 1].pp end)) or (function() return 16 end))()
        self.moveSlots = __TS__ArraySlice(self.baseMoveSlots)
        self.moveSlots[moveslot + 1].pp = mimicPP
    else
        self.moveSlots = __TS__ArraySlice(self.baseMoveSlots)
    end
    self.transformed = false
    self.ability = self.baseAbility
    self.hpType = self.baseHpType
    self.hpPower = self.baseHpPower
    for i in pairs(self.volatiles) do
        if self.volatiles[i].linkedStatus then
            self:removeLinkedVolatiles(self.volatiles[i].linkedStatus, self.volatiles[i].linkedPokemon)
        end
    end
    if (self.species.name == "Eternatus-Eternamax") and self.volatiles.dynamax then
        self.volatiles = {dynamax = self.volatiles.dynamax}
    else
        self.volatiles = {}
    end
    if includeSwitchFlags then
        self.switchFlag = false
        self.forceSwitchFlag = false
    end
    self.lastMove = nil
    self.lastMoveUsed = nil
    self.moveThisTurn = ""
    self.lastDamage = 0
    self.attackedBy = {}
    self.hurtThisTurn = nil
    self.newlySwitched = true
    self.beingCalledBack = false
    self.volatileStaleness = nil
    self:setSpecies(self.baseSpecies)
end
function Pokemon.prototype.hasType(self, ____type)
    local thisTypes = self:getTypes()
    if type(____type) == "string" then
        return thisTypes:includes(____type)
    end
    for ____, typeName in ipairs(____type) do
        if thisTypes:includes(typeName) then
            return true
        end
    end
    return false
end
function Pokemon.prototype.faint(self, source, effect)
    if source == nil then
        source = nil
    end
    if effect == nil then
        effect = nil
    end
    if self.fainted or self.faintQueued then
        return 0
    end
    local d = self.hp
    self.hp = 0
    self.switchFlag = false
    self.faintQueued = true
    self.battle.faintQueue:push({target = self, source = source, effect = effect})
    return d
end
function Pokemon.prototype.damage(self, d, source, effect)
    if source == nil then
        source = nil
    end
    if effect == nil then
        effect = nil
    end
    if ((not self.hp) or __TS__NumberIsNaN(
        __TS__Number(d)
    )) or (d <= 0) then
        return 0
    end
    if (d < 1) and (d > 0) then
        d = 1
    end
    d = self.battle:trunc(d)
    self.hp = self.hp - d
    if self.hp <= 0 then
        d = d + self.hp
        self:faint(source, effect)
    end
    return d
end
function Pokemon.prototype.tryTrap(self, isHidden)
    if isHidden == nil then
        isHidden = false
    end
    if not self:runStatusImmunity("trapped") then
        return false
    end
    if self.trapped and isHidden then
        return true
    end
    self.trapped = (isHidden and "hidden") or true
    return true
end
function Pokemon.prototype.hasMove(self, moveid)
    moveid = toID(_G, moveid)
    if __TS__StringSubstr(moveid, 0, 11) == "hiddenpower" then
        moveid = "hiddenpower"
    end
    for ____, moveSlot in ipairs(self.moveSlots) do
        if moveid == moveSlot.id then
            return moveid
        end
    end
    return false
end
function Pokemon.prototype.disableMove(self, moveid, isHidden, sourceEffect)
    if (not sourceEffect) and self.battle.event then
        sourceEffect = self.battle.effect
    end
    moveid = toID(_G, moveid)
    for ____, moveSlot in ipairs(self.moveSlots) do
        if (moveSlot.id == moveid) and (moveSlot.disabled ~= true) then
            moveSlot.disabled = isHidden or true
            moveSlot.disabledSource = sourceEffect.fullname or moveSlot.move
        end
    end
end
function Pokemon.prototype.heal(self, d, source, effect)
    if source == nil then
        source = nil
    end
    if effect == nil then
        effect = nil
    end
    if not self.hp then
        return false
    end
    d = self.battle:trunc(d)
    if __TS__NumberIsNaN(
        __TS__Number(d)
    ) then
        return false
    end
    if d <= 0 then
        return false
    end
    if self.hp >= self.maxhp then
        return false
    end
    self.hp = self.hp + d
    if self.hp > self.maxhp then
        d = d - (self.hp - self.maxhp)
        self.hp = self.maxhp
    end
    return d
end
function Pokemon.prototype.sethp(self, d)
    if not self.hp then
        return 0
    end
    d = self.battle:trunc(d)
    if __TS__NumberIsNaN(
        __TS__Number(d)
    ) then
        return
    end
    if d < 1 then
        d = 1
    end
    d = d - self.hp
    self.hp = self.hp + d
    if self.hp > self.maxhp then
        d = d - (self.hp - self.maxhp)
        self.hp = self.maxhp
    end
    return d
end
function Pokemon.prototype.trySetStatus(self, status, source, sourceEffect)
    if source == nil then
        source = nil
    end
    if sourceEffect == nil then
        sourceEffect = nil
    end
    return self:setStatus(self.status or status, source, sourceEffect)
end
function Pokemon.prototype.cureStatus(self, silent)
    if silent == nil then
        silent = false
    end
    if (not self.hp) or (not self.status) then
        return false
    end
    self.battle:add("-curestatus", self, self.status, (silent and "[silent]") or "[msg]")
    if ((self.status == "slp") and (not self:hasAbility("comatose"))) and self:removeVolatile("nightmare") then
        self.battle:add("-end", self, "Nightmare", "[silent]")
    end
    self:setStatus("")
    return true
end
function Pokemon.prototype.setStatus(self, status, source, sourceEffect, ignoreImmunities)
    if source == nil then
        source = nil
    end
    if sourceEffect == nil then
        sourceEffect = nil
    end
    if ignoreImmunities == nil then
        ignoreImmunities = false
    end
    if not self.hp then
        return false
    end
    status = self.battle.dex.conditions:get(status)
    if self.battle.event then
        if not source then
            source = self.battle.event.source
        end
        if not sourceEffect then
            sourceEffect = self.battle.effect
        end
    end
    if not source then
        source = self
    end
    if self.status == status.id then
        if sourceEffect.status == self.status then
            self.battle:add("-fail", self, self.status)
        elseif sourceEffect.status then
            self.battle:add("-fail", source)
            self.battle:attrLastMove("[still]")
        end
        return false
    end
    if ((not ignoreImmunities) and status.id) and (not (source:hasAbility("corrosion") and ({"tox", "psn"}):includes(status.id))) then
        if not self:runStatusImmunity(((status.id == "tox") and "psn") or status.id) then
            self.battle:debug("immune to status")
            if sourceEffect.status then
                self.battle:add("-immune", self)
            end
            return false
        end
    end
    local prevStatus = self.status
    local prevStatusState = self.statusState
    if status.id then
        local result = self.battle:runEvent("SetStatus", self, source, sourceEffect, status)
        if not result then
            self.battle:debug(
                ("set status [" .. tostring(status.id)) .. "] interrupted"
            )
            return result
        end
    end
    self.status = status.id
    self.statusState = {id = status.id, target = self}
    if source then
        self.statusState.source = source
    end
    if status.duration then
        self.statusState.duration = status.duration
    end
    if status.durationCallback then
        self.statusState.duration = status.durationCallback:call(self.battle, self, source, sourceEffect)
    end
    if status.id and (not self.battle:singleEvent("Start", status, self.statusState, self, source, sourceEffect)) then
        self.battle:debug(
            ("status start [" .. tostring(status.id)) .. "] interrupted"
        )
        self.status = prevStatus
        self.statusState = prevStatusState
        return false
    end
    if status.id and (not self.battle:runEvent("AfterSetStatus", self, source, sourceEffect, status)) then
        return false
    end
    return true
end
function Pokemon.prototype.clearStatus(self)
    return self:setStatus("")
end
function Pokemon.prototype.getStatus(self)
    return self.battle.dex.conditions:getByID(self.status)
end
function Pokemon.prototype.eatItem(self, force, source, sourceEffect)
    if not self.item then
        return false
    end
    if (((not self.hp) and (self.item ~= "jabocaberry")) and (self.item ~= "rowapberry")) or (not self.isActive) then
        return false
    end
    if (not sourceEffect) and self.battle.effect then
        sourceEffect = self.battle.effect
    end
    if ((not source) and self.battle.event) and self.battle.event.target then
        source = self.battle.event.target
    end
    local item = self:getItem()
    if self.battle:runEvent("UseItem", self, nil, nil, item) and (force or self.battle:runEvent("TryEatItem", self, nil, nil, item)) then
        self.battle:add("-enditem", self, item, "[eat]")
        self.battle:singleEvent("Eat", item, self.itemState, self, source, sourceEffect)
        self.battle:runEvent("EatItem", self, nil, nil, item)
        if ____exports.RESTORATIVE_BERRIES:has(item.id) then
            local ____switch316 = self.pendingStaleness
            if ____switch316 == "internal" then
                goto ____switch316_case_0
            elseif ____switch316 == "external" then
                goto ____switch316_case_1
            end
            goto ____switch316_end
            ::____switch316_case_0::
            do
                if self.staleness ~= "external" then
                    self.staleness = "internal"
                end
                goto ____switch316_end
            end
            ::____switch316_case_1::
            do
                self.staleness = "external"
                goto ____switch316_end
            end
            ::____switch316_end::
            self.pendingStaleness = nil
        end
        self.lastItem = self.item
        self.item = ""
        self.itemState = {id = "", target = self}
        self.usedItemThisTurn = true
        self.ateBerry = true
        self.battle:runEvent("AfterUseItem", self, nil, nil, item)
        return true
    end
    return false
end
function Pokemon.prototype.useItem(self, source, sourceEffect)
    if ((not self.hp) and (not self:getItem().isGem)) or (not self.isActive) then
        return false
    end
    if not self.item then
        return false
    end
    if (not sourceEffect) and self.battle.effect then
        sourceEffect = self.battle.effect
    end
    if ((not source) and self.battle.event) and self.battle.event.target then
        source = self.battle.event.target
    end
    local item = self:getItem()
    if self.battle:runEvent("UseItem", self, nil, nil, item) then
        local ____switch324 = item.id
        if ____switch324 == "redcard" then
            goto ____switch324_case_0
        end
        goto ____switch324_case_default
        ::____switch324_case_0::
        do
            self.battle:add(
                "-enditem",
                self,
                item,
                "[of] " .. tostring(source)
            )
            goto ____switch324_end
        end
        ::____switch324_case_default::
        do
            if item.isGem then
                self.battle:add("-enditem", self, item, "[from] gem")
            else
                self.battle:add("-enditem", self, item)
            end
            goto ____switch324_end
        end
        ::____switch324_end::
        if item.boosts then
            self.battle:boost(item.boosts, self, source, item)
        end
        self.battle:singleEvent("Use", item, self.itemState, self, source, sourceEffect)
        self.lastItem = self.item
        self.item = ""
        self.itemState = {id = "", target = self}
        self.usedItemThisTurn = true
        self.battle:runEvent("AfterUseItem", self, nil, nil, item)
        return true
    end
    return false
end
function Pokemon.prototype.takeItem(self, source)
    if not self.isActive then
        return false
    end
    if not self.item then
        return false
    end
    if not source then
        source = self
    end
    if self.battle.gen == 4 then
        if toID(_G, self.ability) == "multitype" then
            return false
        end
        if source and (toID(_G, source.ability) == "multitype") then
            return false
        end
    end
    local item = self:getItem()
    if self.battle:runEvent("TakeItem", self, source, nil, item) then
        self.item = ""
        self.itemState = {id = "", target = self}
        self.pendingStaleness = nil
        return item
    end
    return false
end
function Pokemon.prototype.setItem(self, item, source, effect)
    if (not self.hp) or (not self.isActive) then
        return false
    end
    if type(item) == "string" then
        item = self.battle.dex.items:get(item)
    end
    local effectid = ((self.battle.effect and (function() return self.battle.effect.id end)) or (function() return "" end))()
    if ____exports.RESTORATIVE_BERRIES:has("leppaberry") then
        local inflicted = ({"trick", "switcheroo"}):includes(effectid)
        local external = (inflicted and source) and (not source:isAlly(self))
        self.pendingStaleness = (external and "external") or "internal"
    else
        self.pendingStaleness = nil
    end
    self.item = item.id
    self.itemState = {id = item.id, target = self}
    if item.id then
        self.battle:singleEvent("Start", item, self.itemState, self, source, effect)
    end
    return true
end
function Pokemon.prototype.getItem(self)
    return self.battle.dex.items:getByID(self.item)
end
function Pokemon.prototype.hasItem(self, item)
    if self:ignoringItem() then
        return false
    end
    local ownItem = self.item
    if not __TS__ArrayIsArray(item) then
        return ownItem == toID(_G, item)
    end
    return __TS__ArrayMap(item, toID):includes(ownItem)
end
function Pokemon.prototype.clearItem(self)
    return self:setItem("")
end
function Pokemon.prototype.setAbility(self, ability, source, isFromFormeChange)
    if not self.hp then
        return false
    end
    if type(ability) == "string" then
        ability = self.battle.dex.abilities:get(ability)
    end
    local oldAbility = self.ability
    if not isFromFormeChange then
        if ability.isPermanent or self:getAbility().isPermanent then
            return false
        end
    end
    if not self.battle:runEvent("SetAbility", self, source, self.battle.effect, ability) then
        return false
    end
    self.battle:singleEvent(
        "End",
        self.battle.dex.abilities:get(oldAbility),
        self.abilityState,
        self,
        source
    )
    if (self.battle.effect and (self.battle.effect.effectType == "Move")) and (not isFromFormeChange) then
        self.battle:add(
            "-endability",
            self,
            self.battle.dex.abilities:get(oldAbility),
            "[from] move: " .. tostring(
                self.battle.dex.moves:get(self.battle.effect.id)
            )
        )
    end
    self.ability = ability.id
    self.abilityState = {id = ability.id, target = self}
    if ability.id and (self.battle.gen > 3) then
        self.battle:singleEvent("Start", ability, self.abilityState, self, source)
    end
    self.abilityOrder = (function()
        local ____obj, ____index = self.battle, "abilityOrder"
        local ____tmp = ____obj[____index]
        ____obj[____index] = ____tmp + 1
        return ____tmp
    end)()
    return oldAbility
end
function Pokemon.prototype.getAbility(self)
    return self.battle.dex.abilities:getByID(self.ability)
end
function Pokemon.prototype.hasAbility(self, ability)
    if self:ignoringAbility() then
        return false
    end
    local ownAbility = self.ability
    if not __TS__ArrayIsArray(ability) then
        return ownAbility == toID(_G, ability)
    end
    return __TS__ArrayMap(ability, toID):includes(ownAbility)
end
function Pokemon.prototype.clearAbility(self)
    return self:setAbility("")
end
function Pokemon.prototype.getNature(self)
    return self.battle.dex.natures:get(self.set.nature)
end
function Pokemon.prototype.addVolatile(self, status, source, sourceEffect, linkedStatus)
    if source == nil then
        source = nil
    end
    if sourceEffect == nil then
        sourceEffect = nil
    end
    if linkedStatus == nil then
        linkedStatus = nil
    end
    local result
    status = self.battle.dex.conditions:get(status)
    if (not self.hp) and (not status.affectsFainted) then
        return false
    end
    if (linkedStatus and source) and (not source.hp) then
        return false
    end
    if self.battle.event then
        if not source then
            source = self.battle.event.source
        end
        if not sourceEffect then
            sourceEffect = self.battle.effect
        end
    end
    if not source then
        source = self
    end
    if self.volatiles[status.id] then
        if not status.onRestart then
            return false
        end
        return self.battle:singleEvent("Restart", status, self.volatiles[status.id], self, source, sourceEffect)
    end
    if not self:runStatusImmunity(status.id) then
        self.battle:debug("immune to volatile status")
        if sourceEffect.status then
            self.battle:add("-immune", self)
        end
        return false
    end
    result = self.battle:runEvent("TryAddVolatile", self, source, sourceEffect, status)
    if not result then
        self.battle:debug(
            ("add volatile [" .. tostring(status.id)) .. "] interrupted"
        )
        return result
    end
    self.volatiles[status.id] = {id = status.id}
    self.volatiles[status.id].target = self
    if source then
        self.volatiles[status.id].source = source
        self.volatiles[status.id].sourceSlot = source:getSlot()
    end
    if sourceEffect then
        self.volatiles[status.id].sourceEffect = sourceEffect
    end
    if status.duration then
        self.volatiles[status.id].duration = status.duration
    end
    if status.durationCallback then
        self.volatiles[status.id].duration = status.durationCallback:call(self.battle, self, source, sourceEffect)
    end
    result = self.battle:singleEvent("Start", status, self.volatiles[status.id], self, source, sourceEffect)
    if not result then
        __TS__Delete(self.volatiles, status.id)
        return result
    end
    if linkedStatus and source then
        if not source.volatiles[tostring(linkedStatus)] then
            source:addVolatile(linkedStatus, self, sourceEffect)
            source.volatiles[tostring(linkedStatus)].linkedPokemon = {self}
            source.volatiles[tostring(linkedStatus)].linkedStatus = status
        else
            source.volatiles[tostring(linkedStatus)].linkedPokemon:push(self)
        end
        self.volatiles[tostring(status)].linkedPokemon = {source}
        self.volatiles[tostring(status)].linkedStatus = linkedStatus
    end
    return true
end
function Pokemon.prototype.getVolatile(self, status)
    status = self.battle.dex.conditions:get(status)
    if not self.volatiles[status.id] then
        return nil
    end
    return status
end
function Pokemon.prototype.removeVolatile(self, status)
    if not self.hp then
        return false
    end
    status = self.battle.dex.conditions:get(status)
    if not self.volatiles[status.id] then
        return false
    end
    self.battle:singleEvent("End", status, self.volatiles[status.id], self)
    local linkedPokemon = self.volatiles[status.id].linkedPokemon
    local linkedStatus = self.volatiles[status.id].linkedStatus
    __TS__Delete(self.volatiles, status.id)
    if linkedPokemon then
        self:removeLinkedVolatiles(linkedStatus, linkedPokemon)
    end
    return true
end
function Pokemon.prototype.removeLinkedVolatiles(self, linkedStatus, linkedPokemon)
    linkedStatus = tostring(linkedStatus)
    for ____, linkedPoke in ipairs(linkedPokemon) do
        do
            local volatileData = linkedPoke.volatiles[linkedStatus]
            if not volatileData then
                goto __continue389
            end
            volatileData.linkedPokemon:splice(
                volatileData.linkedPokemon:indexOf(self),
                1
            )
            if volatileData.linkedPokemon.length == 0 then
                linkedPoke:removeVolatile(linkedStatus)
            end
        end
        ::__continue389::
    end
end
function Pokemon.prototype.setType(self, newType, enforce)
    if enforce == nil then
        enforce = false
    end
    if not enforce then
        if ((self.battle.gen >= 5) and ((self.species.num == 493) or (self.species.num == 773))) or ((self.battle.gen == 4) and self:hasAbility("multitype")) then
            return false
        end
    end
    if not newType then
        error(
            __TS__New(Error, "Must pass type to setType"),
            0
        )
    end
    self.types = (((type(newType) == "string") and (function() return {newType} end)) or (function() return newType end))()
    self.addedType = ""
    self.knownType = true
    self.apparentType = table.concat(self.types, "/" or ",")
    return true
end
function Pokemon.prototype.addType(self, newType)
    self.addedType = newType
    return true
end
function Pokemon.prototype.getTypes(self, excludeAdded)
    local types = self.battle:runEvent("Type", self, nil, nil, self.types)
    if (not excludeAdded) and self.addedType then
        return types:concat(self.addedType)
    end
    if types.length then
        return types
    end
    return {((self.battle.gen >= 5) and "Normal") or "???"}
end
function Pokemon.prototype.isGrounded(self, negateImmunity)
    if negateImmunity == nil then
        negateImmunity = false
    end
    if self.battle.field.pseudoWeather.gravity ~= nil then
        return true
    end
    if (self.volatiles.ingrain ~= nil) and (self.battle.gen >= 4) then
        return true
    end
    if self.volatiles.smackdown ~= nil then
        return true
    end
    local item = (self:ignoringItem() and "") or self.item
    if item == "ironball" then
        return true
    end
    if ((not negateImmunity) and self:hasType("Flying")) and (not (self.volatiles.roost ~= nil)) then
        return false
    end
    if self:hasAbility("levitate") and (not self.battle:suppressingAbility()) then
        return nil
    end
    if self.volatiles.magnetrise ~= nil then
        return false
    end
    if self.volatiles.telekinesis ~= nil then
        return false
    end
    return item ~= "airballoon"
end
function Pokemon.prototype.isSemiInvulnerable(self)
    return (((((self.volatiles.fly or self.volatiles.bounce) or self.volatiles.dive) or self.volatiles.dig) or self.volatiles.phantomforce) or self.volatiles.shadowforce) or self:isSkyDropped()
end
function Pokemon.prototype.isSkyDropped(self)
    if self.volatiles.skydrop then
        return true
    end
    for ____, foeActive in __TS__Iterator(self.side.foe.active) do
        if foeActive.volatiles.skydrop and (foeActive.volatiles.skydrop.source == self) then
            return true
        end
    end
    return false
end
function Pokemon.prototype.isProtected(self)
    return not (not ((((((self.volatiles.protect or self.volatiles.detect) or self.volatiles.maxguard) or self.volatiles.kingsshield) or self.volatiles.spikyshield) or self.volatiles.banefulbunker) or self.volatiles.obstruct))
end
function Pokemon.prototype.effectiveWeather(self)
    local weather = self.battle.field:effectiveWeather()
    local ____switch416 = weather
    if ____switch416 == "sunnyday" then
        goto ____switch416_case_0
    elseif ____switch416 == "raindance" then
        goto ____switch416_case_1
    elseif ____switch416 == "desolateland" then
        goto ____switch416_case_2
    elseif ____switch416 == "primordialsea" then
        goto ____switch416_case_3
    end
    goto ____switch416_end
    ::____switch416_case_0::
    do
    end
    ::____switch416_case_1::
    do
    end
    ::____switch416_case_2::
    do
    end
    ::____switch416_case_3::
    do
        if self:hasItem("utilityumbrella") then
            return ""
        end
    end
    ::____switch416_end::
    return weather
end
function Pokemon.prototype.runEffectiveness(self, move)
    local totalTypeMod = 0
    for ____, ____type in ipairs(
        self:getTypes()
    ) do
        local typeMod = self.battle.dex:getEffectiveness(move, ____type)
        typeMod = self.battle:singleEvent("Effectiveness", move, nil, self, ____type, move, typeMod)
        totalTypeMod = totalTypeMod + self.battle:runEvent("Effectiveness", self, ____type, move, typeMod)
    end
    return totalTypeMod
end
function Pokemon.prototype.runImmunity(self, ____type, message)
    if (not ____type) or (____type == "???") then
        return true
    end
    if not self.battle.dex.types:isName(____type) then
        error(
            __TS__New(
                Error,
                "Use runStatusImmunity for " .. tostring(____type)
            ),
            0
        )
    end
    if self.fainted then
        return false
    end
    local negateImmunity = not self.battle:runEvent("NegateImmunity", self, ____type)
    local notImmune = (((____type == "Ground") and (function() return self:isGrounded(negateImmunity) end)) or (function() return negateImmunity or self.battle.dex:getImmunity(____type, self) end))()
    if notImmune then
        return true
    end
    if not message then
        return false
    end
    if notImmune == nil then
        self.battle:add("-immune", self, "[from] ability: Levitate")
    else
        self.battle:add("-immune", self)
    end
    return false
end
function Pokemon.prototype.runStatusImmunity(self, ____type, message)
    if self.fainted then
        return false
    end
    if not ____type then
        return true
    end
    if not self.battle.dex:getImmunity(____type, self) then
        self.battle:debug("natural status immunity")
        if message then
            self.battle:add("-immune", self)
        end
        return false
    end
    local immunity = self.battle:runEvent("Immunity", self, nil, nil, ____type)
    if not immunity then
        self.battle:debug("artificial status immunity")
        if message and (immunity ~= nil) then
            self.battle:add("-immune", self)
        end
        return false
    end
    return true
end
function Pokemon.prototype.destroy(self)
    self.battle = nil
    self.side = nil
end
return ____exports
