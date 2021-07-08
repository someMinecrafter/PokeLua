--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle_abilities");

local ____exports = {}

____exports.Abilities = {
    noability = {isNonstandard = "Past", name = "No Ability", rating = 0.1, num = 0},
    adaptability = {
        onModifyMove = function(self, move)
            move.stab = 2
        end,
        name = "Adaptability",
        rating = 4,
        num = 91
    },
    aerilate = {
        onModifyTypePriority = -1,
        onModifyType = function(self, move, pokemon)
            local noModifyType = {"judgment", "multiattack", "naturalgift", "revelationdance", "technoblast", "terrainpulse", "weatherball"}
            if ((move.type == "Normal") and (not noModifyType:includes(move.id))) and (not (move.isZ and (move.category ~= "Status"))) then
                move.type = "Flying"
                move.aerilateBoosted = true
            end
        end,
        onBasePowerPriority = 23,
        onBasePower = function(self, basePower, pokemon, target, move)
            if move.aerilateBoosted then
                return self:chainModify({4915, 4096})
            end
        end,
        name = "Aerilate",
        rating = 4,
        num = 184
    },
    aftermath = {
        name = "Aftermath",
        onDamagingHitOrder = 1,
        onDamagingHit = function(self, damage, target, source, move)
            if (not target.hp) and self:checkMoveMakesContact(move, source, target, true) then
                self:damage(source.baseMaxhp / 4, source, target)
            end
        end,
        rating = 2.5,
        num = 106
    },
    airlock = {
        onSwitchIn = function(self, pokemon)
            self.effectState.switchingIn = true
        end,
        onStart = function(self, pokemon)
            if not self.effectState.switchingIn then
                return
            end
            self:add("-ability", pokemon, "Air Lock")
            self.effectState.switchingIn = false
        end,
        suppressWeather = true,
        name = "Air Lock",
        rating = 2,
        num = 76
    },
    analytic = {
        onBasePowerPriority = 21,
        onBasePower = function(self, basePower, pokemon)
            local boosted = true
            for ____, target in __TS__Iterator(
                self:getAllActive()
            ) do
                do
                    if target == pokemon then
                        goto __continue13
                    end
                    if self.queue:willMove(target) then
                        boosted = false
                        break
                    end
                end
                ::__continue13::
            end
            if boosted then
                self:debug("Analytic boost")
                return self:chainModify({5325, 4096})
            end
        end,
        name = "Analytic",
        rating = 2.5,
        num = 148
    },
    angerpoint = {
        onHit = function(self, target, source, move)
            if not target.hp then
                return
            end
            if (move.effectType == "Move") and target:getMoveHitData(move).crit then
                target:setBoost({atk = 6})
                self:add("-setboost", target, "atk", 12, "[from] ability: Anger Point")
            end
        end,
        name = "Anger Point",
        rating = 1.5,
        num = 83
    },
    anticipation = {
        onStart = function(self, pokemon)
            for ____, target in __TS__Iterator(
                pokemon:foes()
            ) do
                for ____, moveSlot in __TS__Iterator(target.moveSlots) do
                    do
                        local move = self.dex.moves:get(moveSlot.move)
                        if move.category == "Status" then
                            goto __continue22
                        end
                        local moveType = (((move.id == "hiddenpower") and (function() return target.hpType end)) or (function() return move.type end))()
                        if (self.dex:getImmunity(moveType, pokemon) and (self.dex:getEffectiveness(moveType, pokemon) > 0)) or move.ohko then
                            self:add("-ability", pokemon, "Anticipation")
                            return
                        end
                    end
                    ::__continue22::
                end
            end
        end,
        name = "Anticipation",
        rating = 0.5,
        num = 107
    },
    arenatrap = {
        onFoeTrapPokemon = function(self, pokemon)
            if not pokemon:isAdjacent(self.effectState.target) then
                return
            end
            if pokemon:isGrounded() then
                pokemon:tryTrap(true)
            end
        end,
        onFoeMaybeTrapPokemon = function(self, pokemon, source)
            if not source then
                source = self.effectState.target
            end
            if (not source) or (not pokemon:isAdjacent(source)) then
                return
            end
            if pokemon:isGrounded(not pokemon.knownType) then
                pokemon.maybeTrapped = true
            end
        end,
        name = "Arena Trap",
        rating = 5,
        num = 71
    },
    aromaveil = {
        onAllyTryAddVolatile = function(self, status, target, source, effect)
            if ({"attract", "disable", "encore", "healblock", "taunt", "torment"}):includes(status.id) then
                if effect.effectType == "Move" then
                    local effectHolder = self.effectState.target
                    self:add(
                        "-block",
                        target,
                        "ability: Aroma Veil",
                        "[of] " .. tostring(effectHolder)
                    )
                end
                return nil
            end
        end,
        isBreakable = true,
        name = "Aroma Veil",
        rating = 2,
        num = 165
    },
    asoneglastrier = {
        onPreStart = function(self, pokemon)
            self:add("-ability", pokemon, "As One")
            self:add("-ability", pokemon, "Unnerve")
            self.effectState.unnerved = true
        end,
        onEnd = function(self)
            self.effectState.unnerved = false
        end,
        onFoeTryEatItem = function(self)
            return not self.effectState.unnerved
        end,
        onSourceAfterFaint = function(self, length, target, source, effect)
            if effect and (effect.effectType == "Move") then
                self:boost(
                    {atk = length},
                    source,
                    source,
                    self.dex.abilities:get("chillingneigh")
                )
            end
        end,
        isPermanent = true,
        name = "As One (Glastrier)",
        rating = 3.5,
        num = 266
    },
    asonespectrier = {
        onPreStart = function(self, pokemon)
            self:add("-ability", pokemon, "As One")
            self:add("-ability", pokemon, "Unnerve")
            self.effectState.unnerved = true
        end,
        onEnd = function(self)
            self.effectState.unnerved = false
        end,
        onFoeTryEatItem = function(self)
            return not self.effectState.unnerved
        end,
        onSourceAfterFaint = function(self, length, target, source, effect)
            if effect and (effect.effectType == "Move") then
                self:boost(
                    {spa = length},
                    source,
                    source,
                    self.dex.abilities:get("grimneigh")
                )
            end
        end,
        isPermanent = true,
        name = "As One (Spectrier)",
        rating = 3.5,
        num = 267
    },
    aurabreak = {
        onStart = function(self, pokemon)
            if self:suppressingAbility(pokemon) then
                return
            end
            self:add("-ability", pokemon, "Aura Break")
        end,
        onAnyTryPrimaryHit = function(self, target, source, move)
            if (target == source) or (move.category == "Status") then
                return
            end
            move.hasAuraBreak = true
        end,
        isBreakable = true,
        name = "Aura Break",
        rating = 1,
        num = 188
    },
    baddreams = {
        onResidualOrder = 28,
        onResidualSubOrder = 2,
        onResidual = function(self, pokemon)
            if not pokemon.hp then
                return
            end
            for ____, target in __TS__Iterator(
                pokemon:foes()
            ) do
                if (target.status == "slp") or target:hasAbility("comatose") then
                    self:damage(target.baseMaxhp / 8, target, pokemon)
                end
            end
        end,
        name = "Bad Dreams",
        rating = 1.5,
        num = 123
    },
    ballfetch = {name = "Ball Fetch", rating = 0, num = 237},
    battery = {
        onAllyBasePowerPriority = 22,
        onAllyBasePower = function(self, basePower, attacker, defender, move)
            if (attacker ~= self.effectState.target) and (move.category == "Special") then
                self:debug("Battery boost")
                return self:chainModify({5325, 4096})
            end
        end,
        name = "Battery",
        rating = 0,
        num = 217
    },
    battlearmor = {onCriticalHit = false, isBreakable = true, name = "Battle Armor", rating = 1, num = 4},
    battlebond = {
        onSourceAfterFaint = function(self, length, target, source, effect)
            if effect.effectType ~= "Move" then
                return
            end
            if (((source.species.id == "greninja") and source.hp) and (not source.transformed)) and source.side:foePokemonLeft() then
                self:add("-activate", source, "ability: Battle Bond")
                source:formeChange("Greninja-Ash", self.effect, true)
            end
        end,
        onModifyMovePriority = -1,
        onModifyMove = function(self, move, attacker)
            if (move.id == "watershuriken") and (attacker.species.name == "Greninja-Ash") then
                move.multihit = 3
            end
        end,
        isPermanent = true,
        name = "Battle Bond",
        rating = 4,
        num = 210
    },
    beastboost = {
        onSourceAfterFaint = function(self, length, target, source, effect)
            if effect and (effect.effectType == "Move") then
                local statName = "atk"
                local bestStat = 0
                local s
                for ____value in pairs(source.storedStats) do
                    s = ____value
                    if source.storedStats[s] > bestStat then
                        statName = s
                        bestStat = source.storedStats[s]
                    end
                end
                self:boost({[statName] = length}, source)
            end
        end,
        name = "Beast Boost",
        rating = 3.5,
        num = 224
    },
    berserk = {
        onDamage = function(self, damage, target, source, effect)
            if ((effect.effectType == "Move") and (not effect.multihit)) and ((not effect.negateSecondary) and (not (effect.hasSheerForce and source:hasAbility("sheerforce")))) then
                target.abilityState.checkedBerserk = false
            else
                target.abilityState.checkedBerserk = true
            end
        end,
        onTryEatItem = function(self, item, pokemon)
            local healingItems = {"aguavberry", "enigmaberry", "figyberry", "iapapaberry", "magoberry", "sitrusberry", "wikiberry", "oranberry", "berryjuice"}
            if healingItems:includes(item.id) then
                return pokemon.abilityState.checkedBerserk
            end
            return true
        end,
        onAfterMoveSecondary = function(self, target, source, move)
            target.abilityState.checkedBerserk = true
            if (((not source) or (source == target)) or (not target.hp)) or (not move.totalDamage) then
                return
            end
            local lastAttackedBy = target:getLastAttackedBy()
            if not lastAttackedBy then
                return
            end
            local damage = ((move.multihit and (function() return move.totalDamage end)) or (function() return lastAttackedBy.damage end))()
            if (target.hp <= (target.maxhp / 2)) and ((target.hp + damage) > (target.maxhp / 2)) then
                self:boost({spa = 1})
            end
        end,
        name = "Berserk",
        rating = 2,
        num = 201
    },
    bigpecks = {
        onBoost = function(self, boost, target, source, effect)
            if source and (target == source) then
                return
            end
            if boost.def and (boost.def < 0) then
                __TS__Delete(boost, "def")
                if (not effect.secondaries) and (effect.id ~= "octolock") then
                    self:add(
                        "-fail",
                        target,
                        "unboost",
                        "Defense",
                        "[from] ability: Big Pecks",
                        "[of] " .. tostring(target)
                    )
                end
            end
        end,
        isBreakable = true,
        name = "Big Pecks",
        rating = 0.5,
        num = 145
    },
    blaze = {
        onModifyAtkPriority = 5,
        onModifyAtk = function(self, atk, attacker, defender, move)
            if (move.type == "Fire") and (attacker.hp <= (attacker.maxhp / 3)) then
                self:debug("Blaze boost")
                return self:chainModify(1.5)
            end
        end,
        onModifySpAPriority = 5,
        onModifySpA = function(self, atk, attacker, defender, move)
            if (move.type == "Fire") and (attacker.hp <= (attacker.maxhp / 3)) then
                self:debug("Blaze boost")
                return self:chainModify(1.5)
            end
        end,
        name = "Blaze",
        rating = 2,
        num = 66
    },
    bulletproof = {
        onTryHit = function(self, pokemon, target, move)
            if move.flags.bullet then
                self:add("-immune", pokemon, "[from] ability: Bulletproof")
                return nil
            end
        end,
        isBreakable = true,
        name = "Bulletproof",
        rating = 3,
        num = 171
    },
    cheekpouch = {
        onEatItem = function(self, item, pokemon)
            self:heal(pokemon.baseMaxhp / 3)
        end,
        name = "Cheek Pouch",
        rating = 2,
        num = 167
    },
    chillingneigh = {
        onSourceAfterFaint = function(self, length, target, source, effect)
            if effect and (effect.effectType == "Move") then
                self:boost({atk = length}, source)
            end
        end,
        name = "Chilling Neigh",
        rating = 3,
        num = 264
    },
    chlorophyll = {
        onModifySpe = function(self, spe, pokemon)
            if ({"sunnyday", "desolateland"}):includes(
                pokemon:effectiveWeather()
            ) then
                return self:chainModify(2)
            end
        end,
        name = "Chlorophyll",
        rating = 3,
        num = 34
    },
    clearbody = {
        onBoost = function(self, boost, target, source, effect)
            if source and (target == source) then
                return
            end
            local showMsg = false
            local i
            for ____value in pairs(boost) do
                i = ____value
                if boost[i] < 0 then
                    __TS__Delete(boost, i)
                    showMsg = true
                end
            end
            if (showMsg and (not effect.secondaries)) and (effect.id ~= "octolock") then
                self:add(
                    "-fail",
                    target,
                    "unboost",
                    "[from] ability: Clear Body",
                    "[of] " .. tostring(target)
                )
            end
        end,
        isBreakable = true,
        name = "Clear Body",
        rating = 2,
        num = 29
    },
    cloudnine = {
        onSwitchIn = function(self, pokemon)
            self.effectState.switchingIn = true
        end,
        onStart = function(self, pokemon)
            if not self.effectState.switchingIn then
                return
            end
            self:add("-ability", pokemon, "Cloud Nine")
            self.effectState.switchingIn = false
        end,
        suppressWeather = true,
        name = "Cloud Nine",
        rating = 2,
        num = 13
    },
    colorchange = {
        onAfterMoveSecondary = function(self, target, source, move)
            if not target.hp then
                return
            end
            local ____type = move.type
            if (((target.isActive and (move.effectType == "Move")) and (move.category ~= "Status")) and (____type ~= "???")) and (not target:hasType(____type)) then
                if not target:setType(____type) then
                    return false
                end
                self:add("-start", target, "typechange", ____type, "[from] ability: Color Change")
                if (target.side.active.length == 2) and (target.position == 1) then
                    local action = self.queue:willMove(target)
                    if action and (action.move.id == "curse") then
                        action.targetLoc = -1
                    end
                end
            end
        end,
        name = "Color Change",
        rating = 0,
        num = 16
    },
    comatose = {
        onStart = function(self, pokemon)
            self:add("-ability", pokemon, "Comatose")
        end,
        onSetStatus = function(self, status, target, source, effect)
            if effect.status then
                self:add("-immune", target, "[from] ability: Comatose")
            end
            return false
        end,
        isPermanent = true,
        name = "Comatose",
        rating = 4,
        num = 213
    },
    competitive = {
        onAfterEachBoost = function(self, boost, target, source, effect)
            if (not source) or target:isAlly(source) then
                if effect.id == "stickyweb" then
                    self:hint("Court Change Sticky Web counts as lowering your own Speed, and Competitive only affects stats lowered by foes.", true, source.side)
                end
                return
            end
            local statsLowered = false
            local i
            for ____value in pairs(boost) do
                i = ____value
                if boost[i] < 0 then
                    statsLowered = true
                end
            end
            if statsLowered then
                self:add("-ability", target, "Competitive")
                self:boost({spa = 2}, target, target, nil, true)
            end
        end,
        name = "Competitive",
        rating = 2.5,
        num = 172
    },
    compoundeyes = {
        onSourceModifyAccuracyPriority = -1,
        onSourceModifyAccuracy = function(self, accuracy)
            if type(accuracy) ~= "number" then
                return
            end
            self:debug("compoundeyes - enhancing accuracy")
            return self:chainModify({5325, 4096})
        end,
        name = "Compound Eyes",
        rating = 3,
        num = 14
    },
    contrary = {
        onBoost = function(self, boost, target, source, effect)
            if effect and (effect.id == "zpower") then
                return
            end
            local i
            for ____value in pairs(boost) do
                i = ____value
                boost[i] = boost[i] * -1
            end
        end,
        isBreakable = true,
        name = "Contrary",
        rating = 4.5,
        num = 126
    },
    corrosion = {name = "Corrosion", rating = 2.5, num = 212},
    cottondown = {
        onDamagingHit = function(self, damage, target, source, move)
            local activated = false
            for ____, pokemon in __TS__Iterator(
                self:getAllActive()
            ) do
                do
                    if (pokemon == target) or pokemon.fainted then
                        goto __continue117
                    end
                    if not activated then
                        self:add("-ability", target, "Cotton Down")
                        activated = true
                    end
                    self:boost({spe = -1}, pokemon, target, nil, true)
                end
                ::__continue117::
            end
        end,
        name = "Cotton Down",
        rating = 2,
        num = 238
    },
    curiousmedicine = {
        onStart = function(self, pokemon)
            for ____, ally in __TS__Iterator(
                pokemon:adjacentAllies()
            ) do
                ally:clearBoosts()
                self:add(
                    "-clearboost",
                    ally,
                    "[from] ability: Curious Medicine",
                    "[of] " .. tostring(pokemon)
                )
            end
        end,
        name = "Curious Medicine",
        rating = 0,
        num = 261
    },
    cursedbody = {
        onDamagingHit = function(self, damage, target, source, move)
            if source.volatiles.disable then
                return
            end
            if ((not move.isMax) and (not move.isFutureMove)) and (move.id ~= "struggle") then
                if self:randomChance(3, 10) then
                    source:addVolatile("disable", self.effectState.target)
                end
            end
        end,
        name = "Cursed Body",
        rating = 2,
        num = 130
    },
    cutecharm = {
        onDamagingHit = function(self, damage, target, source, move)
            if self:checkMoveMakesContact(move, source, target) then
                if self:randomChance(3, 10) then
                    source:addVolatile("attract", self.effectState.target)
                end
            end
        end,
        name = "Cute Charm",
        rating = 0.5,
        num = 56
    },
    damp = {
        onAnyTryMove = function(self, target, source, effect)
            if ({"explosion", "mindblown", "mistyexplosion", "selfdestruct"}):includes(effect.id) then
                self:attrLastMove("[still]")
                self:add(
                    "cant",
                    self.effectState.target,
                    "ability: Damp",
                    effect,
                    "[of] " .. tostring(target)
                )
                return false
            end
        end,
        onAnyDamage = function(self, damage, target, source, effect)
            if effect and (effect.id == "aftermath") then
                return false
            end
        end,
        isBreakable = true,
        name = "Damp",
        rating = 1,
        num = 6
    },
    dancer = {name = "Dancer", rating = 1.5, num = 216},
    darkaura = {
        onStart = function(self, pokemon)
            if self:suppressingAbility(pokemon) then
                return
            end
            self:add("-ability", pokemon, "Dark Aura")
        end,
        onAnyBasePowerPriority = 20,
        onAnyBasePower = function(self, basePower, source, target, move)
            if ((target == source) or (move.category == "Status")) or (move.type ~= "Dark") then
                return
            end
            if not move.auraBooster then
                move.auraBooster = self.effectState.target
            end
            if move.auraBooster ~= self.effectState.target then
                return
            end
            return self:chainModify({(move.hasAuraBreak and 3072) or 5448, 4096})
        end,
        isBreakable = true,
        name = "Dark Aura",
        rating = 3,
        num = 186
    },
    dauntlessshield = {
        onStart = function(self, pokemon)
            self:boost({def = 1}, pokemon)
        end,
        name = "Dauntless Shield",
        rating = 3.5,
        num = 235
    },
    dazzling = {
        onFoeTryMove = function(self, target, source, move)
            local targetAllExceptions = {"perishsong", "flowershield", "rototiller"}
            if (move.target == "foeSide") or ((move.target == "all") and (not targetAllExceptions:includes(move.id))) then
                return
            end
            local dazzlingHolder = self.effectState.target
            if (source:isAlly(dazzlingHolder) or (move.target == "all")) and (move.priority > 0.1) then
                self:attrLastMove("[still]")
                self:add(
                    "cant",
                    dazzlingHolder,
                    "ability: Dazzling",
                    move,
                    "[of] " .. tostring(target)
                )
                return false
            end
        end,
        isBreakable = true,
        name = "Dazzling",
        rating = 2.5,
        num = 219
    },
    defeatist = {
        onModifyAtkPriority = 5,
        onModifyAtk = function(self, atk, pokemon)
            if pokemon.hp <= (pokemon.maxhp / 2) then
                return self:chainModify(0.5)
            end
        end,
        onModifySpAPriority = 5,
        onModifySpA = function(self, atk, pokemon)
            if pokemon.hp <= (pokemon.maxhp / 2) then
                return self:chainModify(0.5)
            end
        end,
        name = "Defeatist",
        rating = -1,
        num = 129
    },
    defiant = {
        onAfterEachBoost = function(self, boost, target, source, effect)
            if (not source) or target:isAlly(source) then
                if effect.id == "stickyweb" then
                    self:hint("Court Change Sticky Web counts as lowering your own Speed, and Defiant only affects stats lowered by foes.", true, source.side)
                end
                return
            end
            local statsLowered = false
            local i
            for ____value in pairs(boost) do
                i = ____value
                if boost[i] < 0 then
                    statsLowered = true
                end
            end
            if statsLowered then
                self:add("-ability", target, "Defiant")
                self:boost({atk = 2}, target, target, nil, true)
            end
        end,
        name = "Defiant",
        rating = 2.5,
        num = 128
    },
    deltastream = {
        onStart = function(self, source)
            self.field:setWeather("deltastream")
        end,
        onAnySetWeather = function(self, target, source, weather)
            local strongWeathers = {"desolateland", "primordialsea", "deltastream"}
            if (self.field:getWeather().id == "deltastream") and (not strongWeathers:includes(weather.id)) then
                return false
            end
        end,
        onEnd = function(self, pokemon)
            if self.field.weatherState.source ~= pokemon then
                return
            end
            for ____, target in __TS__Iterator(
                self:getAllActive()
            ) do
                do
                    if target == pokemon then
                        goto __continue158
                    end
                    if target:hasAbility("deltastream") then
                        self.field.weatherState.source = target
                        return
                    end
                end
                ::__continue158::
            end
            self.field:clearWeather()
        end,
        name = "Delta Stream",
        rating = 4,
        num = 191
    },
    desolateland = {
        onStart = function(self, source)
            self.field:setWeather("desolateland")
        end,
        onAnySetWeather = function(self, target, source, weather)
            local strongWeathers = {"desolateland", "primordialsea", "deltastream"}
            if (self.field:getWeather().id == "desolateland") and (not strongWeathers:includes(weather.id)) then
                return false
            end
        end,
        onEnd = function(self, pokemon)
            if self.field.weatherState.source ~= pokemon then
                return
            end
            for ____, target in __TS__Iterator(
                self:getAllActive()
            ) do
                do
                    if target == pokemon then
                        goto __continue166
                    end
                    if target:hasAbility("desolateland") then
                        self.field.weatherState.source = target
                        return
                    end
                end
                ::__continue166::
            end
            self.field:clearWeather()
        end,
        name = "Desolate Land",
        rating = 4.5,
        num = 190
    },
    disguise = {
        onDamagePriority = 1,
        onDamage = function(self, damage, target, source, effect)
            if ((effect and (effect.effectType == "Move")) and ({"mimikyu", "mimikyutotem"}):includes(target.species.id)) and (not target.transformed) then
                self:add("-activate", target, "ability: Disguise")
                self.effectState.busted = true
                return 0
            end
        end,
        onCriticalHit = function(self, target, source, move)
            if not target then
                return
            end
            if (not ({"mimikyu", "mimikyutotem"}):includes(target.species.id)) or target.transformed then
                return
            end
            local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
            if hitSub then
                return
            end
            if not target:runImmunity(move.type) then
                return
            end
            return false
        end,
        onEffectiveness = function(self, typeMod, target, ____type, move)
            if (not target) or (move.category == "Status") then
                return
            end
            if (not ({"mimikyu", "mimikyutotem"}):includes(target.species.id)) or target.transformed then
                return
            end
            local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
            if hitSub then
                return
            end
            if not target:runImmunity(move.type) then
                return
            end
            return 0
        end,
        onUpdate = function(self, pokemon)
            if ({"mimikyu", "mimikyutotem"}):includes(pokemon.species.id) and self.effectState.busted then
                local speciesid = ((pokemon.species.id == "mimikyutotem") and "Mimikyu-Busted-Totem") or "Mimikyu-Busted"
                pokemon:formeChange(speciesid, self.effect, true)
                self:damage(
                    pokemon.baseMaxhp / 8,
                    pokemon,
                    pokemon,
                    self.dex.species:get(speciesid)
                )
            end
        end,
        isBreakable = true,
        isPermanent = true,
        name = "Disguise",
        rating = 3.5,
        num = 209
    },
    download = {
        onStart = function(self, pokemon)
            local totaldef = 0
            local totalspd = 0
            for ____, target in __TS__Iterator(
                pokemon:foes()
            ) do
                totaldef = totaldef + target:getStat("def", false, true)
                totalspd = totalspd + target:getStat("spd", false, true)
            end
            if totaldef and (totaldef >= totalspd) then
                self:boost({spa = 1})
            elseif totalspd then
                self:boost({atk = 1})
            end
        end,
        name = "Download",
        rating = 3.5,
        num = 88
    },
    dragonsmaw = {
        onModifyAtkPriority = 5,
        onModifyAtk = function(self, atk, attacker, defender, move)
            if move.type == "Dragon" then
                self:debug("Dragon's Maw boost")
                return self:chainModify(1.5)
            end
        end,
        onModifySpAPriority = 5,
        onModifySpA = function(self, atk, attacker, defender, move)
            if move.type == "Dragon" then
                self:debug("Dragon's Maw boost")
                return self:chainModify(1.5)
            end
        end,
        name = "Dragon's Maw",
        rating = 3.5,
        num = 263
    },
    drizzle = {
        onStart = function(self, source)
            for ____, action in __TS__Iterator(self.queue) do
                if ((action.choice == "runPrimal") and (action.pokemon == source)) and (source.species.id == "kyogre") then
                    return
                end
                if (action.choice ~= "runSwitch") and (action.choice ~= "runPrimal") then
                    break
                end
            end
            self.field:setWeather("raindance")
        end,
        name = "Drizzle",
        rating = 4,
        num = 2
    },
    drought = {
        onStart = function(self, source)
            for ____, action in __TS__Iterator(self.queue) do
                if ((action.choice == "runPrimal") and (action.pokemon == source)) and (source.species.id == "groudon") then
                    return
                end
                if (action.choice ~= "runSwitch") and (action.choice ~= "runPrimal") then
                    break
                end
            end
            self.field:setWeather("sunnyday")
        end,
        name = "Drought",
        rating = 4,
        num = 70
    },
    dryskin = {
        onTryHit = function(self, target, source, move)
            if (target ~= source) and (move.type == "Water") then
                if not self:heal(target.baseMaxhp / 4) then
                    self:add("-immune", target, "[from] ability: Dry Skin")
                end
                return nil
            end
        end,
        onFoeBasePowerPriority = 17,
        onFoeBasePower = function(self, basePower, attacker, defender, move)
            if self.effectState.target ~= defender then
                return
            end
            if move.type == "Fire" then
                return self:chainModify(1.25)
            end
        end,
        onWeather = function(self, target, source, effect)
            if target:hasItem("utilityumbrella") then
                return
            end
            if (effect.id == "raindance") or (effect.id == "primordialsea") then
                self:heal(target.baseMaxhp / 8)
            elseif (effect.id == "sunnyday") or (effect.id == "desolateland") then
                self:damage(target.baseMaxhp / 8, target, target)
            end
        end,
        isBreakable = true,
        name = "Dry Skin",
        rating = 3,
        num = 87
    },
    earlybird = {name = "Early Bird", rating = 1.5, num = 48},
    effectspore = {
        onDamagingHit = function(self, damage, target, source, move)
            if (self:checkMoveMakesContact(move, source, target) and (not source.status)) and source:runStatusImmunity("powder") then
                local r = self:random(100)
                if r < 11 then
                    source:setStatus("slp", target)
                elseif r < 21 then
                    source:setStatus("par", target)
                elseif r < 30 then
                    source:setStatus("psn", target)
                end
            end
        end,
        name = "Effect Spore",
        rating = 2,
        num = 27
    },
    electricsurge = {
        onStart = function(self, source)
            self.field:setTerrain("electricterrain")
        end,
        name = "Electric Surge",
        rating = 4,
        num = 226
    },
    emergencyexit = {
        onEmergencyExit = function(self, target)
            if ((not self:canSwitch(target.side)) or target.forceSwitchFlag) or target.switchFlag then
                return
            end
            for ____, side in __TS__Iterator(self.sides) do
                for ____, active in __TS__Iterator(side.active) do
                    active.switchFlag = false
                end
            end
            target.switchFlag = true
            self:add("-activate", target, "ability: Emergency Exit")
        end,
        name = "Emergency Exit",
        rating = 1,
        num = 194
    },
    fairyaura = {
        onStart = function(self, pokemon)
            if self:suppressingAbility(pokemon) then
                return
            end
            self:add("-ability", pokemon, "Fairy Aura")
        end,
        onAnyBasePowerPriority = 20,
        onAnyBasePower = function(self, basePower, source, target, move)
            if ((target == source) or (move.category == "Status")) or (move.type ~= "Fairy") then
                return
            end
            if not move.auraBooster then
                move.auraBooster = self.effectState.target
            end
            if move.auraBooster ~= self.effectState.target then
                return
            end
            return self:chainModify({(move.hasAuraBreak and 3072) or 5448, 4096})
        end,
        isBreakable = true,
        name = "Fairy Aura",
        rating = 3,
        num = 187
    },
    filter = {
        onSourceModifyDamage = function(self, damage, source, target, move)
            if target:getMoveHitData(move).typeMod > 0 then
                self:debug("Filter neutralize")
                return self:chainModify(0.75)
            end
        end,
        isBreakable = true,
        name = "Filter",
        rating = 3,
        num = 111
    },
    flamebody = {
        onDamagingHit = function(self, damage, target, source, move)
            if self:checkMoveMakesContact(move, source, target) then
                if self:randomChance(3, 10) then
                    source:trySetStatus("brn", target)
                end
            end
        end,
        name = "Flame Body",
        rating = 2,
        num = 49
    },
    flareboost = {
        onBasePowerPriority = 19,
        onBasePower = function(self, basePower, attacker, defender, move)
            if (attacker.status == "brn") and (move.category == "Special") then
                return self:chainModify(1.5)
            end
        end,
        name = "Flare Boost",
        rating = 2,
        num = 138
    },
    flashfire = {
        onTryHit = function(self, target, source, move)
            if (target ~= source) and (move.type == "Fire") then
                move.accuracy = true
                if not target:addVolatile("flashfire") then
                    self:add("-immune", target, "[from] ability: Flash Fire")
                end
                return nil
            end
        end,
        onEnd = function(self, pokemon)
            pokemon:removeVolatile("flashfire")
        end,
        condition = {
            noCopy = true,
            onStart = function(self, target)
                self:add("-start", target, "ability: Flash Fire")
            end,
            onModifyAtkPriority = 5,
            onModifyAtk = function(self, atk, attacker, defender, move)
                if (move.type == "Fire") and attacker:hasAbility("flashfire") then
                    self:debug("Flash Fire boost")
                    return self:chainModify(1.5)
                end
            end,
            onModifySpAPriority = 5,
            onModifySpA = function(self, atk, attacker, defender, move)
                if (move.type == "Fire") and attacker:hasAbility("flashfire") then
                    self:debug("Flash Fire boost")
                    return self:chainModify(1.5)
                end
            end,
            onEnd = function(self, target)
                self:add("-end", target, "ability: Flash Fire", "[silent]")
            end
        },
        isBreakable = true,
        name = "Flash Fire",
        rating = 3.5,
        num = 18
    },
    flowergift = {
        onStart = function(self, pokemon)
            __TS__Delete(self.effectState, "forme")
        end,
        onUpdate = function(self, pokemon)
            if ((not pokemon.isActive) or (pokemon.baseSpecies.baseSpecies ~= "Cherrim")) or pokemon.transformed then
                return
            end
            if not pokemon.hp then
                return
            end
            if ({"sunnyday", "desolateland"}):includes(
                pokemon:effectiveWeather()
            ) then
                if pokemon.species.id ~= "cherrimsunshine" then
                    pokemon:formeChange("Cherrim-Sunshine", self.effect, false, "[msg]")
                end
            else
                if pokemon.species.id == "cherrimsunshine" then
                    pokemon:formeChange("Cherrim", self.effect, false, "[msg]")
                end
            end
        end,
        onAllyModifyAtkPriority = 3,
        onAllyModifyAtk = function(self, atk, pokemon)
            if self.effectState.target.baseSpecies.baseSpecies ~= "Cherrim" then
                return
            end
            if ({"sunnyday", "desolateland"}):includes(
                pokemon:effectiveWeather()
            ) then
                return self:chainModify(1.5)
            end
        end,
        onAllyModifySpDPriority = 4,
        onAllyModifySpD = function(self, spd, pokemon)
            if self.effectState.target.baseSpecies.baseSpecies ~= "Cherrim" then
                return
            end
            if ({"sunnyday", "desolateland"}):includes(
                pokemon:effectiveWeather()
            ) then
                return self:chainModify(1.5)
            end
        end,
        isBreakable = true,
        name = "Flower Gift",
        rating = 1,
        num = 122
    },
    flowerveil = {
        onAllyBoost = function(self, boost, target, source, effect)
            if (source and (target == source)) or (not target:hasType("Grass")) then
                return
            end
            local showMsg = false
            local i
            for ____value in pairs(boost) do
                i = ____value
                if boost[i] < 0 then
                    __TS__Delete(boost, i)
                    showMsg = true
                end
            end
            if showMsg and (not effect.secondaries) then
                local effectHolder = self.effectState.target
                self:add(
                    "-block",
                    target,
                    "ability: Flower Veil",
                    "[of] " .. tostring(effectHolder)
                )
            end
        end,
        onAllySetStatus = function(self, status, target, source, effect)
            if (((target:hasType("Grass") and source) and (target ~= source)) and effect) and (effect.id ~= "yawn") then
                self:debug("interrupting setStatus with Flower Veil")
                if (effect.id == "synchronize") or ((effect.effectType == "Move") and (not effect.secondaries)) then
                    local effectHolder = self.effectState.target
                    self:add(
                        "-block",
                        target,
                        "ability: Flower Veil",
                        "[of] " .. tostring(effectHolder)
                    )
                end
                return nil
            end
        end,
        onAllyTryAddVolatile = function(self, status, target)
            if target:hasType("Grass") and (status.id == "yawn") then
                self:debug("Flower Veil blocking yawn")
                local effectHolder = self.effectState.target
                self:add(
                    "-block",
                    target,
                    "ability: Flower Veil",
                    "[of] " .. tostring(effectHolder)
                )
                return nil
            end
        end,
        isBreakable = true,
        name = "Flower Veil",
        rating = 0,
        num = 166
    },
    fluffy = {
        onSourceModifyDamage = function(self, damage, source, target, move)
            local mod = 1
            if move.type == "Fire" then
                mod = mod * 2
            end
            if move.flags.contact then
                mod = mod / 2
            end
            return self:chainModify(mod)
        end,
        isBreakable = true,
        name = "Fluffy",
        rating = 3.5,
        num = 218
    },
    forecast = {
        onUpdate = function(self, pokemon)
            if (pokemon.baseSpecies.baseSpecies ~= "Castform") or pokemon.transformed then
                return
            end
            local forme = nil
            local ____switch271 = pokemon:effectiveWeather()
            if ____switch271 == "sunnyday" then
                goto ____switch271_case_0
            elseif ____switch271 == "desolateland" then
                goto ____switch271_case_1
            elseif ____switch271 == "raindance" then
                goto ____switch271_case_2
            elseif ____switch271 == "primordialsea" then
                goto ____switch271_case_3
            elseif ____switch271 == "hail" then
                goto ____switch271_case_4
            end
            goto ____switch271_case_default
            ::____switch271_case_0::
            do
            end
            ::____switch271_case_1::
            do
                if pokemon.species.id ~= "castformsunny" then
                    forme = "Castform-Sunny"
                end
                goto ____switch271_end
            end
            ::____switch271_case_2::
            do
            end
            ::____switch271_case_3::
            do
                if pokemon.species.id ~= "castformrainy" then
                    forme = "Castform-Rainy"
                end
                goto ____switch271_end
            end
            ::____switch271_case_4::
            do
                if pokemon.species.id ~= "castformsnowy" then
                    forme = "Castform-Snowy"
                end
                goto ____switch271_end
            end
            ::____switch271_case_default::
            do
                if pokemon.species.id ~= "castform" then
                    forme = "Castform"
                end
                goto ____switch271_end
            end
            ::____switch271_end::
            if pokemon.isActive and forme then
                pokemon:formeChange(forme, self.effect, false, "[msg]")
            end
        end,
        name = "Forecast",
        rating = 2,
        num = 59
    },
    forewarn = {
        onStart = function(self, pokemon)
            local warnMoves = {}
            local warnBp = 1
            for ____, target in __TS__Iterator(
                pokemon:foes()
            ) do
                for ____, moveSlot in __TS__Iterator(target.moveSlots) do
                    local move = self.dex.moves:get(moveSlot.move)
                    local bp = move.basePower
                    if move.ohko then
                        bp = 150
                    end
                    if ((move.id == "counter") or (move.id == "metalburst")) or (move.id == "mirrorcoat") then
                        bp = 120
                    end
                    if bp == 1 then
                        bp = 80
                    end
                    if (not bp) and (move.category ~= "Status") then
                        bp = 80
                    end
                    if bp > warnBp then
                        warnMoves = {{move, target}}
                        warnBp = bp
                    elseif bp == warnBp then
                        __TS__ArrayPush(warnMoves, {move, target})
                    end
                end
            end
            if not #warnMoves then
                return
            end
            local warnMoveName, warnTarget = __TS__Unpack(
                self:sample(warnMoves)
            )
            self:add(
                "-activate",
                pokemon,
                "ability: Forewarn",
                warnMoveName,
                "[of] " .. tostring(warnTarget)
            )
        end,
        name = "Forewarn",
        rating = 0.5,
        num = 108
    },
    friendguard = {
        name = "Friend Guard",
        onAnyModifyDamage = function(self, damage, source, target, move)
            if (target ~= self.effectState.target) and target:isAlly(self.effectState.target) then
                self:debug("Friend Guard weaken")
                return self:chainModify(0.75)
            end
        end,
        isBreakable = true,
        rating = 0,
        num = 132
    },
    frisk = {
        onStart = function(self, pokemon)
            for ____, target in __TS__Iterator(
                pokemon:foes()
            ) do
                if target.item then
                    self:add(
                        "-item",
                        target,
                        target:getItem().name,
                        "[from] ability: Frisk",
                        "[of] " .. tostring(pokemon),
                        "[identify]"
                    )
                end
            end
        end,
        name = "Frisk",
        rating = 1.5,
        num = 119
    },
    fullmetalbody = {
        onBoost = function(self, boost, target, source, effect)
            if source and (target == source) then
                return
            end
            local showMsg = false
            local i
            for ____value in pairs(boost) do
                i = ____value
                if boost[i] < 0 then
                    __TS__Delete(boost, i)
                    showMsg = true
                end
            end
            if (showMsg and (not effect.secondaries)) and (effect.id ~= "octolock") then
                self:add(
                    "-fail",
                    target,
                    "unboost",
                    "[from] ability: Full Metal Body",
                    "[of] " .. tostring(target)
                )
            end
        end,
        name = "Full Metal Body",
        rating = 2,
        num = 230
    },
    furcoat = {
        onModifyDefPriority = 6,
        onModifyDef = function(self, def)
            return self:chainModify(2)
        end,
        isBreakable = true,
        name = "Fur Coat",
        rating = 4,
        num = 169
    },
    galewings = {
        onModifyPriority = function(self, priority, pokemon, target, move)
            if (move.type == "Flying") and (pokemon.hp == pokemon.maxhp) then
                return priority + 1
            end
        end,
        name = "Gale Wings",
        rating = 3,
        num = 177
    },
    galvanize = {
        onModifyTypePriority = -1,
        onModifyType = function(self, move, pokemon)
            local noModifyType = {"judgment", "multiattack", "naturalgift", "revelationdance", "technoblast", "terrainpulse", "weatherball"}
            if ((move.type == "Normal") and (not noModifyType:includes(move.id))) and (not (move.isZ and (move.category ~= "Status"))) then
                move.type = "Electric"
                move.galvanizeBoosted = true
            end
        end,
        onBasePowerPriority = 23,
        onBasePower = function(self, basePower, pokemon, target, move)
            if move.galvanizeBoosted then
                return self:chainModify({4915, 4096})
            end
        end,
        name = "Galvanize",
        rating = 4,
        num = 206
    },
    gluttony = {name = "Gluttony", rating = 1.5, num = 82},
    gooey = {
        onDamagingHit = function(self, damage, target, source, move)
            if self:checkMoveMakesContact(move, source, target, true) then
                self:add("-ability", target, "Gooey")
                self:boost({spe = -1}, source, target, nil, true)
            end
        end,
        name = "Gooey",
        rating = 2,
        num = 183
    },
    gorillatactics = {
        onStart = function(self, pokemon)
            pokemon.abilityState.choiceLock = ""
        end,
        onBeforeMove = function(self, pokemon, target, move)
            if move.isZOrMaxPowered or (move.id == "struggle") then
                return
            end
            if pokemon.abilityState.choiceLock and (pokemon.abilityState.choiceLock ~= move.id) then
                self:addMove("move", pokemon, move.name)
                self:attrLastMove("[still]")
                self:debug("Disabled by Gorilla Tactics")
                self:add("-fail", pokemon)
                return false
            end
        end,
        onModifyMove = function(self, move, pokemon)
            if (pokemon.abilityState.choiceLock or move.isZOrMaxPowered) or (move.id == "struggle") then
                return
            end
            pokemon.abilityState.choiceLock = move.id
        end,
        onModifyAtkPriority = 1,
        onModifyAtk = function(self, atk, pokemon)
            if pokemon.volatiles.dynamax then
                return
            end
            self:debug("Gorilla Tactics Atk Boost")
            return self:chainModify(1.5)
        end,
        onDisableMove = function(self, pokemon)
            if not pokemon.abilityState.choiceLock then
                return
            end
            if pokemon.volatiles.dynamax then
                return
            end
            for ____, moveSlot in __TS__Iterator(pokemon.moveSlots) do
                if moveSlot.id ~= pokemon.abilityState.choiceLock then
                    pokemon:disableMove(moveSlot.id, false, self.effectState.sourceEffect)
                end
            end
        end,
        onEnd = function(self, pokemon)
            pokemon.abilityState.choiceLock = ""
        end,
        name = "Gorilla Tactics",
        rating = 4.5,
        num = 255
    },
    grasspelt = {
        onModifyDefPriority = 6,
        onModifyDef = function(self, pokemon)
            if self.field:isTerrain("grassyterrain") then
                return self:chainModify(1.5)
            end
        end,
        isBreakable = true,
        name = "Grass Pelt",
        rating = 0.5,
        num = 179
    },
    grassysurge = {
        onStart = function(self, source)
            self.field:setTerrain("grassyterrain")
        end,
        name = "Grassy Surge",
        rating = 4,
        num = 229
    },
    grimneigh = {
        onSourceAfterFaint = function(self, length, target, source, effect)
            if effect and (effect.effectType == "Move") then
                self:boost({spa = length}, source)
            end
        end,
        name = "Grim Neigh",
        rating = 3,
        num = 265
    },
    gulpmissile = {
        onDamagingHit = function(self, damage, target, source, move)
            if (((not source.hp) or (not source.isActive)) or target.transformed) or target:isSemiInvulnerable() then
                return
            end
            if ({"cramorantgulping", "cramorantgorging"}):includes(target.species.id) then
                self:damage(source.baseMaxhp / 4, source, target)
                if target.species.id == "cramorantgulping" then
                    self:boost({def = -1}, source, target, nil, true)
                else
                    source:trySetStatus("par", target, move)
                end
                target:formeChange("cramorant", move)
            end
        end,
        onSourceTryPrimaryHit = function(self, target, source, effect)
            if (((effect and (effect.id == "surf")) and source:hasAbility("gulpmissile")) and (source.species.name == "Cramorant")) and (not source.transformed) then
                local forme = ((source.hp <= (source.maxhp / 2)) and "cramorantgorging") or "cramorantgulping"
                source:formeChange(forme, effect)
            end
        end,
        isPermanent = true,
        name = "Gulp Missile",
        rating = 2.5,
        num = 241
    },
    guts = {
        onModifyAtkPriority = 5,
        onModifyAtk = function(self, atk, pokemon)
            if pokemon.status then
                return self:chainModify(1.5)
            end
        end,
        name = "Guts",
        rating = 3,
        num = 62
    },
    harvest = {
        name = "Harvest",
        onResidualOrder = 28,
        onResidualSubOrder = 2,
        onResidual = function(self, pokemon)
            if self.field:isWeather({"sunnyday", "desolateland"}) or self:randomChance(1, 2) then
                if (pokemon.hp and (not pokemon.item)) and self.dex.items:get(pokemon.lastItem).isBerry then
                    pokemon:setItem(pokemon.lastItem)
                    pokemon.lastItem = ""
                    self:add(
                        "-item",
                        pokemon,
                        pokemon:getItem(),
                        "[from] ability: Harvest"
                    )
                end
            end
        end,
        rating = 2.5,
        num = 139
    },
    healer = {
        name = "Healer",
        onResidualOrder = 5,
        onResidualSubOrder = 3,
        onResidual = function(self, pokemon)
            for ____, allyActive in __TS__Iterator(
                pokemon:adjacentAllies()
            ) do
                if allyActive.status and self:randomChance(3, 10) then
                    self:add("-activate", pokemon, "ability: Healer")
                    allyActive:cureStatus()
                end
            end
        end,
        rating = 0,
        num = 131
    },
    heatproof = {
        onSourceBasePowerPriority = 18,
        onSourceBasePower = function(self, basePower, attacker, defender, move)
            if move.type == "Fire" then
                return self:chainModify(0.5)
            end
        end,
        onDamage = function(self, damage, target, source, effect)
            if effect and (effect.id == "brn") then
                return damage / 2
            end
        end,
        isBreakable = true,
        name = "Heatproof",
        rating = 2,
        num = 85
    },
    heavymetal = {
        onModifyWeightPriority = 1,
        onModifyWeight = function(self, weighthg)
            return weighthg * 2
        end,
        isBreakable = true,
        name = "Heavy Metal",
        rating = 0,
        num = 134
    },
    honeygather = {name = "Honey Gather", rating = 0, num = 118},
    hugepower = {
        onModifyAtkPriority = 5,
        onModifyAtk = function(self, atk)
            return self:chainModify(2)
        end,
        name = "Huge Power",
        rating = 5,
        num = 37
    },
    hungerswitch = {
        onResidualOrder = 29,
        onResidual = function(self, pokemon)
            if (pokemon.species.baseSpecies ~= "Morpeko") or pokemon.transformed then
                return
            end
            local targetForme = ((pokemon.species.name == "Morpeko") and "Morpeko-Hangry") or "Morpeko"
            pokemon:formeChange(targetForme)
        end,
        name = "Hunger Switch",
        rating = 1,
        num = 258
    },
    hustle = {
        onModifyAtkPriority = 5,
        onModifyAtk = function(self, atk)
            return self:modify(atk, 1.5)
        end,
        onSourceModifyAccuracyPriority = -1,
        onSourceModifyAccuracy = function(self, accuracy, target, source, move)
            if (move.category == "Physical") and (type(accuracy) == "number") then
                return self:chainModify({3277, 4096})
            end
        end,
        name = "Hustle",
        rating = 3.5,
        num = 55
    },
    hydration = {
        onResidualOrder = 5,
        onResidualSubOrder = 3,
        onResidual = function(self, pokemon)
            if pokemon.status and ({"raindance", "primordialsea"}):includes(
                pokemon:effectiveWeather()
            ) then
                self:debug("hydration")
                self:add("-activate", pokemon, "ability: Hydration")
                pokemon:cureStatus()
            end
        end,
        name = "Hydration",
        rating = 1.5,
        num = 93
    },
    hypercutter = {
        onBoost = function(self, boost, target, source, effect)
            if source and (target == source) then
                return
            end
            if boost.atk and (boost.atk < 0) then
                __TS__Delete(boost, "atk")
                if not effect.secondaries then
                    self:add(
                        "-fail",
                        target,
                        "unboost",
                        "Attack",
                        "[from] ability: Hyper Cutter",
                        "[of] " .. tostring(target)
                    )
                end
            end
        end,
        isBreakable = true,
        name = "Hyper Cutter",
        rating = 1.5,
        num = 52
    },
    icebody = {
        onWeather = function(self, target, source, effect)
            if effect.id == "hail" then
                self:heal(target.baseMaxhp / 16)
            end
        end,
        onImmunity = function(self, ____type, pokemon)
            if ____type == "hail" then
                return false
            end
        end,
        name = "Ice Body",
        rating = 1,
        num = 115
    },
    iceface = {
        onStart = function(self, pokemon)
            if (self.field:isWeather("hail") and (pokemon.species.id == "eiscuenoice")) and (not pokemon.transformed) then
                self:add("-activate", pokemon, "ability: Ice Face")
                self.effectState.busted = false
                pokemon:formeChange("Eiscue", self.effect, true)
            end
        end,
        onDamagePriority = 1,
        onDamage = function(self, damage, target, source, effect)
            if (((effect and (effect.effectType == "Move")) and (effect.category == "Physical")) and (target.species.id == "eiscue")) and (not target.transformed) then
                self:add("-activate", target, "ability: Ice Face")
                self.effectState.busted = true
                return 0
            end
        end,
        onCriticalHit = function(self, target, ____type, move)
            if not target then
                return
            end
            if ((move.category ~= "Physical") or (target.species.id ~= "eiscue")) or target.transformed then
                return
            end
            if target.volatiles.substitute and (not (move.flags.authentic or move.infiltrates)) then
                return
            end
            if not target:runImmunity(move.type) then
                return
            end
            return false
        end,
        onEffectiveness = function(self, typeMod, target, ____type, move)
            if not target then
                return
            end
            if ((move.category ~= "Physical") or (target.species.id ~= "eiscue")) or target.transformed then
                return
            end
            local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
            if hitSub then
                return
            end
            if not target:runImmunity(move.type) then
                return
            end
            return 0
        end,
        onUpdate = function(self, pokemon)
            if (pokemon.species.id == "eiscue") and self.effectState.busted then
                pokemon:formeChange("Eiscue-Noice", self.effect, true)
            end
        end,
        onAnyWeatherStart = function(self)
            local pokemon = self.effectState.target
            if not pokemon.hp then
                return
            end
            if (self.field:isWeather("hail") and (pokemon.species.id == "eiscuenoice")) and (not pokemon.transformed) then
                self:add("-activate", pokemon, "ability: Ice Face")
                self.effectState.busted = false
                pokemon:formeChange("Eiscue", self.effect, true)
            end
        end,
        isBreakable = true,
        isPermanent = true,
        name = "Ice Face",
        rating = 3,
        num = 248
    },
    icescales = {
        onSourceModifyDamage = function(self, damage, source, target, move)
            if move.category == "Special" then
                return self:chainModify(0.5)
            end
        end,
        isBreakable = true,
        name = "Ice Scales",
        rating = 4,
        num = 246
    },
    illuminate = {name = "Illuminate", rating = 0, num = 35},
    illusion = {
        onBeforeSwitchIn = function(self, pokemon)
            pokemon.illusion = nil
            do
                local i = pokemon.side.pokemon.length - 1
                while i > pokemon.position do
                    local possibleTarget = pokemon.side.pokemon[i]
                    if not possibleTarget.fainted then
                        pokemon.illusion = possibleTarget
                        break
                    end
                    i = i - 1
                end
            end
        end,
        onDamagingHit = function(self, damage, target, source, move)
            if target.illusion then
                self:singleEvent(
                    "End",
                    self.dex.abilities:get("Illusion"),
                    target.abilityState,
                    target,
                    source,
                    move
                )
            end
        end,
        onEnd = function(self, pokemon)
            if pokemon.illusion then
                self:debug("illusion cleared")
                pokemon.illusion = nil
                local details = ((tostring(pokemon.species.name) .. tostring(
                    ((pokemon.level == 100) and "") or (", L" .. tostring(pokemon.level))
                )) .. tostring(
                    ((pokemon.gender == "") and "") or (", " .. tostring(pokemon.gender))
                )) .. tostring((pokemon.set.shiny and ", shiny") or "")
                self:add("replace", pokemon, details)
                self:add("-end", pokemon, "Illusion")
            end
        end,
        onFaint = function(self, pokemon)
            pokemon.illusion = nil
        end,
        name = "Illusion",
        rating = 4.5,
        num = 149
    },
    immunity = {
        onUpdate = function(self, pokemon)
            if (pokemon.status == "psn") or (pokemon.status == "tox") then
                self:add("-activate", pokemon, "ability: Immunity")
                pokemon:cureStatus()
            end
        end,
        onSetStatus = function(self, status, target, source, effect)
            if (status.id ~= "psn") and (status.id ~= "tox") then
                return
            end
            if effect.status then
                self:add("-immune", target, "[from] ability: Immunity")
            end
            return false
        end,
        isBreakable = true,
        name = "Immunity",
        rating = 2,
        num = 17
    },
    imposter = {
        onSwitchIn = function(self, pokemon)
            self.effectState.switchingIn = true
        end,
        onStart = function(self, pokemon)
            if not self.effectState.switchingIn then
                return
            end
            local target = pokemon.side.foe.active[(pokemon.side.foe.active.length - 1) - pokemon.position]
            if target then
                pokemon:transformInto(
                    target,
                    self.dex.abilities:get("imposter")
                )
            end
            self.effectState.switchingIn = false
        end,
        name = "Imposter",
        rating = 5,
        num = 150
    },
    infiltrator = {
        onModifyMove = function(self, move)
            move.infiltrates = true
        end,
        name = "Infiltrator",
        rating = 2.5,
        num = 151
    },
    innardsout = {
        name = "Innards Out",
        onDamagingHitOrder = 1,
        onDamagingHit = function(self, damage, target, source, move)
            if not target.hp then
                self:damage(
                    target:getUndynamaxedHP(damage),
                    source,
                    target
                )
            end
        end,
        rating = 4,
        num = 215
    },
    innerfocus = {
        onTryAddVolatile = function(self, status, pokemon)
            if status.id == "flinch" then
                return nil
            end
        end,
        onBoost = function(self, boost, target, source, effect)
            if effect.id == "intimidate" then
                __TS__Delete(boost, "atk")
                self:add(
                    "-fail",
                    target,
                    "unboost",
                    "Attack",
                    "[from] ability: Inner Focus",
                    "[of] " .. tostring(target)
                )
            end
        end,
        isBreakable = true,
        name = "Inner Focus",
        rating = 1.5,
        num = 39
    },
    insomnia = {
        onUpdate = function(self, pokemon)
            if pokemon.status == "slp" then
                self:add("-activate", pokemon, "ability: Insomnia")
                pokemon:cureStatus()
            end
        end,
        onSetStatus = function(self, status, target, source, effect)
            if status.id ~= "slp" then
                return
            end
            if effect.status then
                self:add("-immune", target, "[from] ability: Insomnia")
            end
            return false
        end,
        isBreakable = true,
        name = "Insomnia",
        rating = 2,
        num = 15
    },
    intimidate = {
        onStart = function(self, pokemon)
            local activated = false
            for ____, target in __TS__Iterator(
                pokemon:adjacentFoes()
            ) do
                if not activated then
                    self:add("-ability", pokemon, "Intimidate", "boost")
                    activated = true
                end
                if target.volatiles.substitute then
                    self:add("-immune", target)
                else
                    self:boost({atk = -1}, target, pokemon, nil, true)
                end
            end
        end,
        name = "Intimidate",
        rating = 3.5,
        num = 22
    },
    intrepidsword = {
        onStart = function(self, pokemon)
            self:boost({atk = 1}, pokemon)
        end,
        name = "Intrepid Sword",
        rating = 4,
        num = 234
    },
    ironbarbs = {
        onDamagingHitOrder = 1,
        onDamagingHit = function(self, damage, target, source, move)
            if self:checkMoveMakesContact(move, source, target, true) then
                self:damage(source.baseMaxhp / 8, source, target)
            end
        end,
        name = "Iron Barbs",
        rating = 2.5,
        num = 160
    },
    ironfist = {
        onBasePowerPriority = 23,
        onBasePower = function(self, basePower, attacker, defender, move)
            if move.flags.punch then
                self:debug("Iron Fist boost")
                return self:chainModify({4915, 4096})
            end
        end,
        name = "Iron Fist",
        rating = 3,
        num = 89
    },
    justified = {
        onDamagingHit = function(self, damage, target, source, move)
            if move.type == "Dark" then
                self:boost({atk = 1})
            end
        end,
        name = "Justified",
        rating = 2.5,
        num = 154
    },
    keeneye = {
        onBoost = function(self, boost, target, source, effect)
            if source and (target == source) then
                return
            end
            if boost.accuracy and (boost.accuracy < 0) then
                __TS__Delete(boost, "accuracy")
                if not effect.secondaries then
                    self:add(
                        "-fail",
                        target,
                        "unboost",
                        "accuracy",
                        "[from] ability: Keen Eye",
                        "[of] " .. tostring(target)
                    )
                end
            end
        end,
        onModifyMove = function(self, move)
            move.ignoreEvasion = true
        end,
        isBreakable = true,
        name = "Keen Eye",
        rating = 0.5,
        num = 51
    },
    klutz = {name = "Klutz", rating = -1, num = 103},
    leafguard = {
        onSetStatus = function(self, status, target, source, effect)
            if ({"sunnyday", "desolateland"}):includes(
                target:effectiveWeather()
            ) then
                if effect.status then
                    self:add("-immune", target, "[from] ability: Leaf Guard")
                end
                return false
            end
        end,
        onTryAddVolatile = function(self, status, target)
            if (status.id == "yawn") and ({"sunnyday", "desolateland"}):includes(
                target:effectiveWeather()
            ) then
                self:add("-immune", target, "[from] ability: Leaf Guard")
                return nil
            end
        end,
        isBreakable = true,
        name = "Leaf Guard",
        rating = 0.5,
        num = 102
    },
    levitate = {isBreakable = true, name = "Levitate", rating = 3.5, num = 26},
    libero = {
        onPrepareHit = function(self, source, target, move)
            if move.hasBounced or (move.sourceEffect == "snatch") then
                return
            end
            local ____type = move.type
            if (____type and (____type ~= "???")) and (source:getTypes():join() ~= ____type) then
                if not source:setType(____type) then
                    return
                end
                self:add("-start", source, "typechange", ____type, "[from] ability: Libero")
            end
        end,
        name = "Libero",
        rating = 4.5,
        num = 236
    },
    lightmetal = {
        onModifyWeight = function(self, weighthg)
            return self:trunc(weighthg / 2)
        end,
        isBreakable = true,
        name = "Light Metal",
        rating = 1,
        num = 135
    },
    lightningrod = {
        onTryHit = function(self, target, source, move)
            if (target ~= source) and (move.type == "Electric") then
                if not self:boost({spa = 1}) then
                    self:add("-immune", target, "[from] ability: Lightning Rod")
                end
                return nil
            end
        end,
        onAnyRedirectTarget = function(self, target, source, source2, move)
            if (move.type ~= "Electric") or ({"firepledge", "grasspledge", "waterpledge"}):includes(move.id) then
                return
            end
            local redirectTarget = (({"randomNormal", "adjacentFoe"}):includes(move.target) and "normal") or move.target
            if self:validTarget(self.effectState.target, source, redirectTarget) then
                if move.smartTarget then
                    move.smartTarget = false
                end
                if self.effectState.target ~= target then
                    self:add("-activate", self.effectState.target, "ability: Lightning Rod")
                end
                return self.effectState.target
            end
        end,
        isBreakable = true,
        name = "Lightning Rod",
        rating = 3,
        num = 31
    },
    limber = {
        onUpdate = function(self, pokemon)
            if pokemon.status == "par" then
                self:add("-activate", pokemon, "ability: Limber")
                pokemon:cureStatus()
            end
        end,
        onSetStatus = function(self, status, target, source, effect)
            if status.id ~= "par" then
                return
            end
            if effect.status then
                self:add("-immune", target, "[from] ability: Limber")
            end
            return false
        end,
        isBreakable = true,
        name = "Limber",
        rating = 2,
        num = 7
    },
    liquidooze = {
        onSourceTryHeal = function(self, damage, target, source, effect)
            self:debug(
                (((("Heal is occurring: " .. tostring(target)) .. " <- ") .. tostring(source)) .. " :: ") .. tostring(effect.id)
            )
            local canOoze = {"drain", "leechseed", "strengthsap"}
            if canOoze:includes(effect.id) then
                self:damage(damage)
                return 0
            end
        end,
        name = "Liquid Ooze",
        rating = 1.5,
        num = 64
    },
    liquidvoice = {
        onModifyTypePriority = -1,
        onModifyType = function(self, move, pokemon)
            if move.flags.sound and (not pokemon.volatiles.dynamax) then
                move.type = "Water"
            end
        end,
        name = "Liquid Voice",
        rating = 1.5,
        num = 204
    },
    longreach = {
        onModifyMove = function(self, move)
            __TS__Delete(move.flags, "contact")
        end,
        name = "Long Reach",
        rating = 1,
        num = 203
    },
    magicbounce = {
        name = "Magic Bounce",
        onTryHitPriority = 1,
        onTryHit = function(self, target, source, move)
            if ((target == source) or move.hasBounced) or (not move.flags.reflectable) then
                return
            end
            local newMove = self.dex:getActiveMove(move.id)
            newMove.hasBounced = true
            newMove.pranksterBoosted = false
            self.actions:useMove(newMove, target, source)
            return nil
        end,
        onAllyTryHitSide = function(self, target, source, move)
            if (target:isAlly(source) or move.hasBounced) or (not move.flags.reflectable) then
                return
            end
            local newMove = self.dex:getActiveMove(move.id)
            newMove.hasBounced = true
            newMove.pranksterBoosted = false
            self.actions:useMove(newMove, self.effectState.target, source)
            return nil
        end,
        condition = {duration = 1},
        isBreakable = true,
        rating = 4,
        num = 156
    },
    magicguard = {
        onDamage = function(self, damage, target, source, effect)
            if effect.effectType ~= "Move" then
                if effect.effectType == "Ability" then
                    self:add(
                        "-activate",
                        source,
                        "ability: " .. tostring(effect.name)
                    )
                end
                return false
            end
        end,
        name = "Magic Guard",
        rating = 4,
        num = 98
    },
    magician = {
        onAfterMoveSecondarySelf = function(self, source, target, move)
            if (not move) or (not target) then
                return
            end
            if (target ~= source) and (move.category ~= "Status") then
                if (source.item or source.volatiles.gem) or (move.id == "fling") then
                    return
                end
                local yourItem = target:takeItem(source)
                if not yourItem then
                    return
                end
                if not source:setItem(yourItem) then
                    target.item = yourItem.id
                    return
                end
                self:add(
                    "-item",
                    source,
                    yourItem,
                    "[from] ability: Magician",
                    "[of] " .. tostring(target)
                )
            end
        end,
        name = "Magician",
        rating = 1.5,
        num = 170
    },
    magmaarmor = {
        onUpdate = function(self, pokemon)
            if pokemon.status == "frz" then
                self:add("-activate", pokemon, "ability: Magma Armor")
                pokemon:cureStatus()
            end
        end,
        onImmunity = function(self, ____type, pokemon)
            if ____type == "frz" then
                return false
            end
        end,
        isBreakable = true,
        name = "Magma Armor",
        rating = 1,
        num = 40
    },
    magnetpull = {
        onFoeTrapPokemon = function(self, pokemon)
            if pokemon:hasType("Steel") and pokemon:isAdjacent(self.effectState.target) then
                pokemon:tryTrap(true)
            end
        end,
        onFoeMaybeTrapPokemon = function(self, pokemon, source)
            if not source then
                source = self.effectState.target
            end
            if (not source) or (not pokemon:isAdjacent(source)) then
                return
            end
            if (not pokemon.knownType) or pokemon:hasType("Steel") then
                pokemon.maybeTrapped = true
            end
        end,
        name = "Magnet Pull",
        rating = 4,
        num = 42
    },
    marvelscale = {
        onModifyDefPriority = 6,
        onModifyDef = function(self, def, pokemon)
            if pokemon.status then
                return self:chainModify(1.5)
            end
        end,
        isBreakable = true,
        name = "Marvel Scale",
        rating = 2.5,
        num = 63
    },
    megalauncher = {
        onBasePowerPriority = 19,
        onBasePower = function(self, basePower, attacker, defender, move)
            if move.flags.pulse then
                return self:chainModify(1.5)
            end
        end,
        name = "Mega Launcher",
        rating = 3,
        num = 178
    },
    merciless = {
        onModifyCritRatio = function(self, critRatio, source, target)
            if target and ({"psn", "tox"}):includes(target.status) then
                return 5
            end
        end,
        name = "Merciless",
        rating = 1.5,
        num = 196
    },
    mimicry = {
        onStart = function(self, pokemon)
            if self.field.terrain then
                pokemon:addVolatile("mimicry")
            else
                local types = pokemon.baseSpecies.types
                if (pokemon:getTypes():join() == types:join()) or (not pokemon:setType(types)) then
                    return
                end
                self:add(
                    "-start",
                    pokemon,
                    "typechange",
                    types:join("/"),
                    "[from] ability: Mimicry"
                )
                self:hint("Transform Mimicry changes you to your original un-transformed types.")
            end
        end,
        onAnyTerrainStart = function(self)
            local pokemon = self.effectState.target
            __TS__Delete(pokemon.volatiles, "mimicry")
            pokemon:addVolatile("mimicry")
        end,
        onEnd = function(self, pokemon)
            __TS__Delete(pokemon.volatiles, "mimicry")
        end,
        condition = {
            onStart = function(self, pokemon)
                local newType
                local ____switch492 = self.field.terrain
                if ____switch492 == "electricterrain" then
                    goto ____switch492_case_0
                elseif ____switch492 == "grassyterrain" then
                    goto ____switch492_case_1
                elseif ____switch492 == "mistyterrain" then
                    goto ____switch492_case_2
                elseif ____switch492 == "psychicterrain" then
                    goto ____switch492_case_3
                end
                goto ____switch492_end
                ::____switch492_case_0::
                do
                    newType = "Electric"
                    goto ____switch492_end
                end
                ::____switch492_case_1::
                do
                    newType = "Grass"
                    goto ____switch492_end
                end
                ::____switch492_case_2::
                do
                    newType = "Fairy"
                    goto ____switch492_end
                end
                ::____switch492_case_3::
                do
                    newType = "Psychic"
                    goto ____switch492_end
                end
                ::____switch492_end::
                if ((not newType) or (pokemon:getTypes():join() == newType)) or (not pokemon:setType(newType)) then
                    return
                end
                self:add("-start", pokemon, "typechange", newType, "[from] ability: Mimicry")
            end,
            onUpdate = function(self, pokemon)
                if not self.field.terrain then
                    local types = pokemon.species.types
                    if (pokemon:getTypes():join() == types:join()) or (not pokemon:setType(types)) then
                        return
                    end
                    self:add("-activate", pokemon, "ability: Mimicry")
                    self:add("-end", pokemon, "typechange", "[silent]")
                    pokemon:removeVolatile("mimicry")
                end
            end
        },
        name = "Mimicry",
        rating = 0.5,
        num = 250
    },
    minus = {
        onModifySpAPriority = 5,
        onModifySpA = function(self, spa, pokemon)
            for ____, allyActive in __TS__Iterator(
                pokemon:allies()
            ) do
                if allyActive:hasAbility({"minus", "plus"}) then
                    return self:chainModify(1.5)
                end
            end
        end,
        name = "Minus",
        rating = 0,
        num = 58
    },
    mirrorarmor = {
        onBoost = function(self, boost, target, source, effect)
            if ((target == source) or (not boost)) or (effect.id == "mirrorarmor") then
                return
            end
            local b
            for ____value in pairs(boost) do
                b = ____value
                do
                    if boost[b] < 0 then
                        if target.boosts[b] == -6 then
                            goto __continue502
                        end
                        local negativeBoost = {}
                        negativeBoost[b] = boost[b]
                        __TS__Delete(boost, b)
                        self:add("-ability", target, "Mirror Armor")
                        self:boost(negativeBoost, source, target, nil, true)
                    end
                end
                ::__continue502::
            end
        end,
        isBreakable = true,
        name = "Mirror Armor",
        rating = 2,
        num = 240
    },
    mistysurge = {
        onStart = function(self, source)
            self.field:setTerrain("mistyterrain")
        end,
        name = "Misty Surge",
        rating = 3.5,
        num = 228
    },
    moldbreaker = {
        onStart = function(self, pokemon)
            self:add("-ability", pokemon, "Mold Breaker")
        end,
        onModifyMove = function(self, move)
            move.ignoreAbility = true
        end,
        name = "Mold Breaker",
        rating = 3.5,
        num = 104
    },
    moody = {
        onResidualOrder = 28,
        onResidualSubOrder = 2,
        onResidual = function(self, pokemon)
            local stats = {}
            local boost = {}
            local statPlus
            for ____value in pairs(pokemon.boosts) do
                statPlus = ____value
                do
                    if (statPlus == "accuracy") or (statPlus == "evasion") then
                        goto __continue509
                    end
                    if pokemon.boosts[statPlus] < 6 then
                        __TS__ArrayPush(stats, statPlus)
                    end
                end
                ::__continue509::
            end
            local randomStat = ((#stats and (function() return self:sample(stats) end)) or (function() return nil end))()
            if randomStat then
                boost[randomStat] = 2
            end
            stats = {}
            local statMinus
            for ____value in pairs(pokemon.boosts) do
                statMinus = ____value
                do
                    if (statMinus == "accuracy") or (statMinus == "evasion") then
                        goto __continue513
                    end
                    if (pokemon.boosts[statMinus] > -6) and (statMinus ~= randomStat) then
                        __TS__ArrayPush(stats, statMinus)
                    end
                end
                ::__continue513::
            end
            randomStat = ((#stats and (function() return self:sample(stats) end)) or (function() return nil end))()
            if randomStat then
                boost[randomStat] = -1
            end
            self:boost(boost)
        end,
        name = "Moody",
        rating = 5,
        num = 141
    },
    motordrive = {
        onTryHit = function(self, target, source, move)
            if (target ~= source) and (move.type == "Electric") then
                if not self:boost({spe = 1}) then
                    self:add("-immune", target, "[from] ability: Motor Drive")
                end
                return nil
            end
        end,
        isBreakable = true,
        name = "Motor Drive",
        rating = 3,
        num = 78
    },
    moxie = {
        onSourceAfterFaint = function(self, length, target, source, effect)
            if effect and (effect.effectType == "Move") then
                self:boost({atk = length}, source)
            end
        end,
        name = "Moxie",
        rating = 3,
        num = 153
    },
    multiscale = {
        onSourceModifyDamage = function(self, damage, source, target, move)
            if target.hp >= target.maxhp then
                self:debug("Multiscale weaken")
                return self:chainModify(0.5)
            end
        end,
        isBreakable = true,
        name = "Multiscale",
        rating = 3.5,
        num = 136
    },
    multitype = {isPermanent = true, name = "Multitype", rating = 4, num = 121},
    mummy = {
        name = "Mummy",
        onDamagingHit = function(self, damage, target, source, move)
            local sourceAbility = source:getAbility()
            if sourceAbility.isPermanent or (sourceAbility.id == "mummy") then
                return
            end
            if self:checkMoveMakesContact(
                move,
                source,
                target,
                not source:isAlly(target)
            ) then
                local oldAbility = source:setAbility("mummy", target)
                if oldAbility then
                    self:add(
                        "-activate",
                        target,
                        "ability: Mummy",
                        self.dex.abilities:get(oldAbility).name,
                        "[of] " .. tostring(source)
                    )
                end
            end
        end,
        rating = 2,
        num = 152
    },
    naturalcure = {
        onCheckShow = function(self, pokemon)
            if pokemon.side.active.length == 1 then
                return
            end
            if (pokemon.showCure == true) or (pokemon.showCure == false) then
                return
            end
            local cureList = {}
            local noCureCount = 0
            for ____, curPoke in __TS__Iterator(pokemon.side.active) do
                do
                    if not curPoke.status then
                        goto __continue531
                    end
                    if curPoke.showCure then
                        goto __continue531
                    end
                    local species = curPoke.species
                    if not __TS__ObjectValues(species.abilities):includes("Natural Cure") then
                        goto __continue531
                    end
                    if (not species.abilities["1"]) and (not species.abilities.H) then
                        goto __continue531
                    end
                    if (curPoke ~= pokemon) and (not self.queue:willSwitch(curPoke)) then
                        goto __continue531
                    end
                    if curPoke:hasAbility("naturalcure") then
                        __TS__ArrayPush(cureList, curPoke)
                    else
                        noCureCount = noCureCount + 1
                    end
                end
                ::__continue531::
            end
            if (not #cureList) or (not noCureCount) then
                for ____, pkmn in ipairs(cureList) do
                    pkmn.showCure = true
                end
            else
                self:add(
                    "-message",
                    ((((("(" .. tostring(#cureList)) .. " of ") .. tostring(pokemon.side.name)) .. "'s pokemon ") .. tostring(((#cureList == 1) and "was") or "were")) .. " cured by Natural Cure.)"
                )
                for ____, pkmn in ipairs(cureList) do
                    pkmn.showCure = false
                end
            end
        end,
        onSwitchOut = function(self, pokemon)
            if not pokemon.status then
                return
            end
            if pokemon.showCure == nil then
                pokemon.showCure = true
            end
            if pokemon.showCure then
                self:add("-curestatus", pokemon, pokemon.status, "[from] ability: Natural Cure")
            end
            pokemon:setStatus("")
            if not pokemon.showCure then
                pokemon.showCure = nil
            end
        end,
        name = "Natural Cure",
        rating = 2.5,
        num = 30
    },
    neuroforce = {
        onModifyDamage = function(self, damage, source, target, move)
            if move and (target:getMoveHitData(move).typeMod > 0) then
                return self:chainModify({5120, 4096})
            end
        end,
        name = "Neuroforce",
        rating = 2.5,
        num = 233
    },
    neutralizinggas = {
        onPreStart = function(self, pokemon)
            self:add("-ability", pokemon, "Neutralizing Gas")
            pokemon.abilityState.ending = false
            for ____, target in __TS__Iterator(
                self:getAllActive()
            ) do
                if target.illusion then
                    self:singleEvent(
                        "End",
                        self.dex.abilities:get("Illusion"),
                        target.abilityState,
                        target,
                        pokemon,
                        "neutralizinggas"
                    )
                end
                if target.volatiles.slowstart then
                    __TS__Delete(target.volatiles, "slowstart")
                    self:add("-end", target, "Slow Start", "[silent]")
                end
            end
        end,
        onEnd = function(self, source)
            for ____, pokemon in __TS__Iterator(
                self:getAllActive()
            ) do
                if (pokemon ~= source) and pokemon:hasAbility("Neutralizing Gas") then
                    return
                end
            end
            self:add("-end", source, "ability: Neutralizing Gas")
            if source.abilityState.ending then
                return
            end
            source.abilityState.ending = true
            local sortedActive = self:getAllActive()
            self:speedSort(sortedActive)
            for ____, pokemon in __TS__Iterator(sortedActive) do
                if pokemon ~= source then
                    self:singleEvent(
                        "Start",
                        pokemon:getAbility(),
                        pokemon.abilityState,
                        pokemon
                    )
                end
            end
        end,
        name = "Neutralizing Gas",
        rating = 4,
        num = 256
    },
    noguard = {
        onAnyInvulnerabilityPriority = 1,
        onAnyInvulnerability = function(self, target, source, move)
            if move and ((source == self.effectState.target) or (target == self.effectState.target)) then
                return 0
            end
        end,
        onAnyAccuracy = function(self, accuracy, target, source, move)
            if move and ((source == self.effectState.target) or (target == self.effectState.target)) then
                return true
            end
            return accuracy
        end,
        name = "No Guard",
        rating = 4,
        num = 99
    },
    normalize = {
        onModifyTypePriority = 1,
        onModifyType = function(self, move, pokemon)
            local noModifyType = {"hiddenpower", "judgment", "multiattack", "naturalgift", "revelationdance", "struggle", "technoblast", "terrainpulse", "weatherball"}
            if (not (move.isZ and (move.category ~= "Status"))) and (not noModifyType:includes(move.id)) then
                move.type = "Normal"
                move.normalizeBoosted = true
            end
        end,
        onBasePowerPriority = 23,
        onBasePower = function(self, basePower, pokemon, target, move)
            if move.normalizeBoosted then
                return self:chainModify({4915, 4096})
            end
        end,
        name = "Normalize",
        rating = 0,
        num = 96
    },
    oblivious = {
        onUpdate = function(self, pokemon)
            if pokemon.volatiles.attract then
                self:add("-activate", pokemon, "ability: Oblivious")
                pokemon:removeVolatile("attract")
                self:add("-end", pokemon, "move: Attract", "[from] ability: Oblivious")
            end
            if pokemon.volatiles.taunt then
                self:add("-activate", pokemon, "ability: Oblivious")
                pokemon:removeVolatile("taunt")
            end
        end,
        onImmunity = function(self, ____type, pokemon)
            if ____type == "attract" then
                return false
            end
        end,
        onTryHit = function(self, pokemon, target, move)
            if ((move.id == "attract") or (move.id == "captivate")) or (move.id == "taunt") then
                self:add("-immune", pokemon, "[from] ability: Oblivious")
                return nil
            end
        end,
        onBoost = function(self, boost, target, source, effect)
            if effect.id == "intimidate" then
                __TS__Delete(boost, "atk")
                self:add(
                    "-fail",
                    target,
                    "unboost",
                    "Attack",
                    "[from] ability: Oblivious",
                    "[of] " .. tostring(target)
                )
            end
        end,
        isBreakable = true,
        name = "Oblivious",
        rating = 1.5,
        num = 12
    },
    overcoat = {
        onImmunity = function(self, ____type, pokemon)
            if ((____type == "sandstorm") or (____type == "hail")) or (____type == "powder") then
                return false
            end
        end,
        onTryHitPriority = 1,
        onTryHit = function(self, target, source, move)
            if (move.flags.powder and (target ~= source)) and self.dex:getImmunity("powder", target) then
                self:add("-immune", target, "[from] ability: Overcoat")
                return nil
            end
        end,
        isBreakable = true,
        name = "Overcoat",
        rating = 2,
        num = 142
    },
    overgrow = {
        onModifyAtkPriority = 5,
        onModifyAtk = function(self, atk, attacker, defender, move)
            if (move.type == "Grass") and (attacker.hp <= (attacker.maxhp / 3)) then
                self:debug("Overgrow boost")
                return self:chainModify(1.5)
            end
        end,
        onModifySpAPriority = 5,
        onModifySpA = function(self, atk, attacker, defender, move)
            if (move.type == "Grass") and (attacker.hp <= (attacker.maxhp / 3)) then
                self:debug("Overgrow boost")
                return self:chainModify(1.5)
            end
        end,
        name = "Overgrow",
        rating = 2,
        num = 65
    },
    owntempo = {
        onUpdate = function(self, pokemon)
            if pokemon.volatiles.confusion then
                self:add("-activate", pokemon, "ability: Own Tempo")
                pokemon:removeVolatile("confusion")
            end
        end,
        onTryAddVolatile = function(self, status, pokemon)
            if status.id == "confusion" then
                return nil
            end
        end,
        onHit = function(self, target, source, move)
            if move.volatileStatus == "confusion" then
                self:add("-immune", target, "confusion", "[from] ability: Own Tempo")
            end
        end,
        onBoost = function(self, boost, target, source, effect)
            if effect.id == "intimidate" then
                __TS__Delete(boost, "atk")
                self:add(
                    "-fail",
                    target,
                    "unboost",
                    "Attack",
                    "[from] ability: Own Tempo",
                    "[of] " .. tostring(target)
                )
            end
        end,
        isBreakable = true,
        name = "Own Tempo",
        rating = 1.5,
        num = 20
    },
    parentalbond = {
        onPrepareHit = function(self, source, target, move)
            if ((move.category == "Status") or move.selfdestruct) or move.multihit then
                return
            end
            if ({"endeavor", "fling", "iceball", "rollout"}):includes(move.id) then
                return
            end
            if (((not move.flags.charge) and (not move.spreadHit)) and (not move.isZ)) and (not move.isMax) then
                move.multihit = 2
                move.multihitType = "parentalbond"
            end
        end,
        onSourceModifySecondaries = function(self, secondaries, target, source, move)
            if ((move.multihitType == "parentalbond") and (move.id == "secretpower")) and (move.hit < 2) then
                return secondaries:filter(
                    function(____, effect) return effect.volatileStatus == "flinch" end
                )
            end
        end,
        name = "Parental Bond",
        rating = 4.5,
        num = 185
    },
    pastelveil = {
        onStart = function(self, pokemon)
            for ____, ally in __TS__Iterator(
                pokemon:alliesAndSelf()
            ) do
                if ({"psn", "tox"}):includes(ally.status) then
                    self:add("-activate", pokemon, "ability: Pastel Veil")
                    ally:cureStatus()
                end
            end
        end,
        onUpdate = function(self, pokemon)
            if ({"psn", "tox"}):includes(pokemon.status) then
                self:add("-activate", pokemon, "ability: Pastel Veil")
                pokemon:cureStatus()
            end
        end,
        onAllySwitchIn = function(self, pokemon)
            if ({"psn", "tox"}):includes(pokemon.status) then
                self:add("-activate", self.effectState.target, "ability: Pastel Veil")
                pokemon:cureStatus()
            end
        end,
        onSetStatus = function(self, status, target, source, effect)
            if not ({"psn", "tox"}):includes(status.id) then
                return
            end
            if effect.status then
                self:add("-immune", target, "[from] ability: Pastel Veil")
            end
            return false
        end,
        onAllySetStatus = function(self, status, target, source, effect)
            if not ({"psn", "tox"}):includes(status.id) then
                return
            end
            if effect.status then
                local effectHolder = self.effectState.target
                self:add(
                    "-block",
                    target,
                    "ability: Pastel Veil",
                    "[of] " .. tostring(effectHolder)
                )
            end
            return false
        end,
        isBreakable = true,
        name = "Pastel Veil",
        rating = 2,
        num = 257
    },
    perishbody = {
        onDamagingHit = function(self, damage, target, source, move)
            if not self:checkMoveMakesContact(move, source, target) then
                return
            end
            local announced = false
            for ____, pokemon in ipairs({target, source}) do
                do
                    if pokemon.volatiles.perishsong then
                        goto __continue615
                    end
                    if not announced then
                        self:add("-ability", target, "Perish Body")
                        announced = true
                    end
                    pokemon:addVolatile("perishsong")
                end
                ::__continue615::
            end
        end,
        name = "Perish Body",
        rating = 1,
        num = 253
    },
    pickpocket = {
        onAfterMoveSecondary = function(self, target, source, move)
            if (source and (source ~= target)) and move.flags.contact then
                if ((target.item or target.switchFlag) or target.forceSwitchFlag) or (source.switchFlag == true) then
                    return
                end
                local yourItem = source:takeItem(target)
                if not yourItem then
                    return
                end
                if not target:setItem(yourItem) then
                    source.item = yourItem.id
                    return
                end
                self:add(
                    "-enditem",
                    source,
                    yourItem,
                    "[silent]",
                    "[from] ability: Pickpocket",
                    "[of] " .. tostring(source)
                )
                self:add(
                    "-item",
                    target,
                    yourItem,
                    "[from] ability: Pickpocket",
                    "[of] " .. tostring(source)
                )
            end
        end,
        name = "Pickpocket",
        rating = 1,
        num = 124
    },
    pickup = {
        onResidualOrder = 28,
        onResidualSubOrder = 2,
        onResidual = function(self, pokemon)
            if pokemon.item then
                return
            end
            local pickupTargets = self:getAllActive():filter(
                function(____, target) return (target.lastItem and target.usedItemThisTurn) and pokemon:isAdjacent(target) end
            )
            if not pickupTargets.length then
                return
            end
            local randomTarget = self:sample(pickupTargets)
            local item = randomTarget.lastItem
            randomTarget.lastItem = ""
            self:add(
                "-item",
                pokemon,
                self.dex.items:get(item),
                "[from] ability: Pickup"
            )
            pokemon:setItem(item)
        end,
        name = "Pickup",
        rating = 0.5,
        num = 53
    },
    pixilate = {
        onModifyTypePriority = -1,
        onModifyType = function(self, move, pokemon)
            local noModifyType = {"judgment", "multiattack", "naturalgift", "revelationdance", "technoblast", "terrainpulse", "weatherball"}
            if ((move.type == "Normal") and (not noModifyType:includes(move.id))) and (not (move.isZ and (move.category ~= "Status"))) then
                move.type = "Fairy"
                move.pixilateBoosted = true
            end
        end,
        onBasePowerPriority = 23,
        onBasePower = function(self, basePower, pokemon, target, move)
            if move.pixilateBoosted then
                return self:chainModify({4915, 4096})
            end
        end,
        name = "Pixilate",
        rating = 4,
        num = 182
    },
    plus = {
        onModifySpAPriority = 5,
        onModifySpA = function(self, spa, pokemon)
            for ____, allyActive in __TS__Iterator(
                pokemon:allies()
            ) do
                if allyActive:hasAbility({"minus", "plus"}) then
                    return self:chainModify(1.5)
                end
            end
        end,
        name = "Plus",
        rating = 0,
        num = 57
    },
    poisonheal = {
        onDamagePriority = 1,
        onDamage = function(self, damage, target, source, effect)
            if (effect.id == "psn") or (effect.id == "tox") then
                self:heal(target.baseMaxhp / 8)
                return false
            end
        end,
        name = "Poison Heal",
        rating = 4,
        num = 90
    },
    poisonpoint = {
        onDamagingHit = function(self, damage, target, source, move)
            if self:checkMoveMakesContact(move, source, target) then
                if self:randomChance(3, 10) then
                    source:trySetStatus("psn", target)
                end
            end
        end,
        name = "Poison Point",
        rating = 1.5,
        num = 38
    },
    poisontouch = {
        onModifyMove = function(self, move)
            if (not move.flags.contact) or (move.target == "self") then
                return
            end
            if not move.secondaries then
                move.secondaries = {}
            end
            move.secondaries:push(
                {
                    chance = 30,
                    status = "psn",
                    ability = self.dex.abilities:get("poisontouch")
                }
            )
        end,
        name = "Poison Touch",
        rating = 2,
        num = 143
    },
    powerconstruct = {
        onResidualOrder = 29,
        onResidual = function(self, pokemon)
            if ((pokemon.baseSpecies.baseSpecies ~= "Zygarde") or pokemon.transformed) or (not pokemon.hp) then
                return
            end
            if (pokemon.species.id == "zygardecomplete") or (pokemon.hp > (pokemon.maxhp / 2)) then
                return
            end
            self:add("-activate", pokemon, "ability: Power Construct")
            pokemon:formeChange("Zygarde-Complete", self.effect, true)
            pokemon.baseMaxhp = math.floor(
                ((math.floor(
                    (((2 * pokemon.species.baseStats.hp) + pokemon.set.ivs.hp) + math.floor(pokemon.set.evs.hp / 4)) + 100
                ) * pokemon.level) / 100) + 10
            )
            local newMaxHP = ((pokemon.volatiles.dynamax and (function() return 2 * pokemon.baseMaxhp end)) or (function() return pokemon.baseMaxhp end))()
            pokemon.hp = newMaxHP - (pokemon.maxhp - pokemon.hp)
            pokemon.maxhp = newMaxHP
            self:add("-heal", pokemon, pokemon.getHealth, "[silent]")
        end,
        isPermanent = true,
        name = "Power Construct",
        rating = 5,
        num = 211
    },
    powerofalchemy = {
        onAllyFaint = function(self, target)
            if not self.effectState.target.hp then
                return
            end
            local ability = target:getAbility()
            local additionalBannedAbilities = {"noability", "flowergift", "forecast", "hungerswitch", "illusion", "imposter", "neutralizinggas", "powerofalchemy", "receiver", "trace", "wonderguard"}
            if target:getAbility().isPermanent or additionalBannedAbilities:includes(target.ability) then
                return
            end
            self:add(
                "-ability",
                self.effectState.target,
                ability,
                "[from] ability: Power of Alchemy",
                "[of] " .. tostring(target)
            )
            self.effectState.target:setAbility(ability)
        end,
        name = "Power of Alchemy",
        rating = 0,
        num = 223
    },
    powerspot = {
        onAllyBasePowerPriority = 22,
        onAllyBasePower = function(self, basePower, attacker, defender, move)
            if attacker ~= self.effectState.target then
                self:debug("Power Spot boost")
                return self:chainModify({5325, 4096})
            end
        end,
        name = "Power Spot",
        rating = 1,
        num = 249
    },
    prankster = {
        onModifyPriority = function(self, priority, pokemon, target, move)
            if move.category == "Status" then
                move.pranksterBoosted = true
                return priority + 1
            end
        end,
        name = "Prankster",
        rating = 4,
        num = 158
    },
    pressure = {
        onStart = function(self, pokemon)
            self:add("-ability", pokemon, "Pressure")
        end,
        onDeductPP = function(self, target, source)
            if target:isAlly(source) then
                return
            end
            return 1
        end,
        name = "Pressure",
        rating = 2.5,
        num = 46
    },
    primordialsea = {
        onStart = function(self, source)
            self.field:setWeather("primordialsea")
        end,
        onAnySetWeather = function(self, target, source, weather)
            local strongWeathers = {"desolateland", "primordialsea", "deltastream"}
            if (self.field:getWeather().id == "primordialsea") and (not strongWeathers:includes(weather.id)) then
                return false
            end
        end,
        onEnd = function(self, pokemon)
            if self.field.weatherState.source ~= pokemon then
                return
            end
            for ____, target in __TS__Iterator(
                self:getAllActive()
            ) do
                do
                    if target == pokemon then
                        goto __continue660
                    end
                    if target:hasAbility("primordialsea") then
                        self.field.weatherState.source = target
                        return
                    end
                end
                ::__continue660::
            end
            self.field:clearWeather()
        end,
        name = "Primordial Sea",
        rating = 4.5,
        num = 189
    },
    prismarmor = {
        onSourceModifyDamage = function(self, damage, source, target, move)
            if target:getMoveHitData(move).typeMod > 0 then
                self:debug("Prism Armor neutralize")
                return self:chainModify(0.75)
            end
        end,
        name = "Prism Armor",
        rating = 3,
        num = 232
    },
    propellertail = {
        onModifyMovePriority = 1,
        onModifyMove = function(self, move)
            move.tracksTarget = move.target ~= "scripted"
        end,
        name = "Propeller Tail",
        rating = 0,
        num = 239
    },
    protean = {
        onPrepareHit = function(self, source, target, move)
            if move.hasBounced or (move.sourceEffect == "snatch") then
                return
            end
            local ____type = move.type
            if (____type and (____type ~= "???")) and (source:getTypes():join() ~= ____type) then
                if not source:setType(____type) then
                    return
                end
                self:add("-start", source, "typechange", ____type, "[from] ability: Protean")
            end
        end,
        name = "Protean",
        rating = 4.5,
        num = 168
    },
    psychicsurge = {
        onStart = function(self, source)
            self.field:setTerrain("psychicterrain")
        end,
        name = "Psychic Surge",
        rating = 4,
        num = 227
    },
    punkrock = {
        onBasePowerPriority = 7,
        onBasePower = function(self, basePower, attacker, defender, move)
            if move.flags.sound then
                self:debug("Punk Rock boost")
                return self:chainModify({5325, 4096})
            end
        end,
        onSourceModifyDamage = function(self, damage, source, target, move)
            if move.flags.sound then
                self:debug("Punk Rock weaken")
                return self:chainModify(0.5)
            end
        end,
        isBreakable = true,
        name = "Punk Rock",
        rating = 3.5,
        num = 244
    },
    purepower = {
        onModifyAtkPriority = 5,
        onModifyAtk = function(self, atk)
            return self:chainModify(2)
        end,
        name = "Pure Power",
        rating = 5,
        num = 74
    },
    queenlymajesty = {
        onFoeTryMove = function(self, target, source, move)
            local targetAllExceptions = {"perishsong", "flowershield", "rototiller"}
            if (move.target == "foeSide") or ((move.target == "all") and (not targetAllExceptions:includes(move.id))) then
                return
            end
            local dazzlingHolder = self.effectState.target
            if (source:isAlly(dazzlingHolder) or (move.target == "all")) and (move.priority > 0.1) then
                self:attrLastMove("[still]")
                self:add(
                    "cant",
                    dazzlingHolder,
                    "ability: Queenly Majesty",
                    move,
                    "[of] " .. tostring(target)
                )
                return false
            end
        end,
        isBreakable = true,
        name = "Queenly Majesty",
        rating = 2.5,
        num = 214
    },
    quickdraw = {
        onFractionalPriorityPriority = -1,
        onFractionalPriority = function(self, priority, pokemon, target, move)
            if (move.category ~= "Status") and self:randomChance(3, 10) then
                self:add("-activate", pokemon, "ability: Quick Draw")
                return 0.1
            end
        end,
        name = "Quick Draw",
        rating = 2.5,
        num = 259
    },
    quickfeet = {
        onModifySpe = function(self, spe, pokemon)
            if pokemon.status then
                return self:chainModify(1.5)
            end
        end,
        name = "Quick Feet",
        rating = 2.5,
        num = 95
    },
    raindish = {
        onWeather = function(self, target, source, effect)
            if target:hasItem("utilityumbrella") then
                return
            end
            if (effect.id == "raindance") or (effect.id == "primordialsea") then
                self:heal(target.baseMaxhp / 16)
            end
        end,
        name = "Rain Dish",
        rating = 1.5,
        num = 44
    },
    rattled = {
        onDamagingHit = function(self, damage, target, source, move)
            if ({"Dark", "Bug", "Ghost"}):includes(move.type) then
                self:boost({spe = 1})
            end
        end,
        onAfterBoost = function(self, boost, target, source, effect)
            if effect and (effect.id == "intimidate") then
                self:boost({spe = 1})
            end
        end,
        name = "Rattled",
        rating = 1.5,
        num = 155
    },
    receiver = {
        onAllyFaint = function(self, target)
            if not self.effectState.target.hp then
                return
            end
            local ability = target:getAbility()
            local additionalBannedAbilities = {"noability", "flowergift", "forecast", "hungerswitch", "illusion", "imposter", "neutralizinggas", "powerofalchemy", "receiver", "trace", "wonderguard"}
            if target:getAbility().isPermanent or additionalBannedAbilities:includes(target.ability) then
                return
            end
            self:add(
                "-ability",
                self.effectState.target,
                ability,
                "[from] ability: Receiver",
                "[of] " .. tostring(target)
            )
            self.effectState.target:setAbility(ability)
        end,
        name = "Receiver",
        rating = 0,
        num = 222
    },
    reckless = {
        onBasePowerPriority = 23,
        onBasePower = function(self, basePower, attacker, defender, move)
            if move.recoil or move.hasCrashDamage then
                self:debug("Reckless boost")
                return self:chainModify({4915, 4096})
            end
        end,
        name = "Reckless",
        rating = 3,
        num = 120
    },
    refrigerate = {
        onModifyTypePriority = -1,
        onModifyType = function(self, move, pokemon)
            local noModifyType = {"judgment", "multiattack", "naturalgift", "revelationdance", "technoblast", "terrainpulse", "weatherball"}
            if ((move.type == "Normal") and (not noModifyType:includes(move.id))) and (not (move.isZ and (move.category ~= "Status"))) then
                move.type = "Ice"
                move.refrigerateBoosted = true
            end
        end,
        onBasePowerPriority = 23,
        onBasePower = function(self, basePower, pokemon, target, move)
            if move.refrigerateBoosted then
                return self:chainModify({4915, 4096})
            end
        end,
        name = "Refrigerate",
        rating = 4,
        num = 174
    },
    regenerator = {
        onSwitchOut = function(self, pokemon)
            pokemon:heal(pokemon.baseMaxhp / 3)
        end,
        name = "Regenerator",
        rating = 4.5,
        num = 144
    },
    ripen = {
        onTryHeal = function(self, damage, target, source, effect)
            if not effect then
                return
            end
            if (effect.id == "berryjuice") or (effect.id == "leftovers") then
                self:add("-activate", target, "ability: Ripen")
            end
            if effect.isBerry then
                return self:chainModify(2)
            end
        end,
        onBoost = function(self, boost, target, source, effect)
            if effect and effect.isBerry then
                local b
                for ____value in pairs(boost) do
                    b = ____value
                    boost[b] = boost[b] * 2
                end
            end
        end,
        onSourceModifyDamagePriority = -1,
        onSourceModifyDamage = function(self, damage, source, target, move)
            if target.abilityState.berryWeaken then
                target.abilityState.berryWeaken = false
                return self:chainModify(0.5)
            end
        end,
        onTryEatItemPriority = -1,
        onTryEatItem = function(self, item, pokemon)
            self:add("-activate", pokemon, "ability: Ripen")
        end,
        onEatItem = function(self, item, pokemon)
            local weakenBerries = {"Babiri Berry", "Charti Berry", "Chilan Berry", "Chople Berry", "Coba Berry", "Colbur Berry", "Haban Berry", "Kasib Berry", "Kebia Berry", "Occa Berry", "Passho Berry", "Payapa Berry", "Rindo Berry", "Roseli Berry", "Shuca Berry", "Tanga Berry", "Wacan Berry", "Yache Berry"}
            pokemon.abilityState.berryWeaken = weakenBerries:includes(item.name)
        end,
        name = "Ripen",
        rating = 2,
        num = 247
    },
    rivalry = {
        onBasePowerPriority = 24,
        onBasePower = function(self, basePower, attacker, defender, move)
            if attacker.gender and defender.gender then
                if attacker.gender == defender.gender then
                    self:debug("Rivalry boost")
                    return self:chainModify(1.25)
                else
                    self:debug("Rivalry weaken")
                    return self:chainModify(0.75)
                end
            end
        end,
        name = "Rivalry",
        rating = 0,
        num = 79
    },
    rkssystem = {isPermanent = true, name = "RKS System", rating = 4, num = 225},
    rockhead = {
        onDamage = function(self, damage, target, source, effect)
            if effect.id == "recoil" then
                if not self.activeMove then
                    error(
                        __TS__New(Error, "Battle.activeMove is null"),
                        0
                    )
                end
                if self.activeMove.id ~= "struggle" then
                    return nil
                end
            end
        end,
        name = "Rock Head",
        rating = 3,
        num = 69
    },
    roughskin = {
        onDamagingHitOrder = 1,
        onDamagingHit = function(self, damage, target, source, move)
            if self:checkMoveMakesContact(move, source, target, true) then
                self:damage(source.baseMaxhp / 8, source, target)
            end
        end,
        name = "Rough Skin",
        rating = 2.5,
        num = 24
    },
    runaway = {name = "Run Away", rating = 0, num = 50},
    sandforce = {
        onBasePowerPriority = 21,
        onBasePower = function(self, basePower, attacker, defender, move)
            if self.field:isWeather("sandstorm") then
                if ((move.type == "Rock") or (move.type == "Ground")) or (move.type == "Steel") then
                    self:debug("Sand Force boost")
                    return self:chainModify({5325, 4096})
                end
            end
        end,
        onImmunity = function(self, ____type, pokemon)
            if ____type == "sandstorm" then
                return false
            end
        end,
        name = "Sand Force",
        rating = 2,
        num = 159
    },
    sandrush = {
        onModifySpe = function(self, spe, pokemon)
            if self.field:isWeather("sandstorm") then
                return self:chainModify(2)
            end
        end,
        onImmunity = function(self, ____type, pokemon)
            if ____type == "sandstorm" then
                return false
            end
        end,
        name = "Sand Rush",
        rating = 3,
        num = 146
    },
    sandspit = {
        onDamagingHit = function(self, damage, target, source, move)
            if self.field:getWeather().id ~= "sandstorm" then
                self.field:setWeather("sandstorm")
            end
        end,
        name = "Sand Spit",
        rating = 2,
        num = 245
    },
    sandstream = {
        onStart = function(self, source)
            self.field:setWeather("sandstorm")
        end,
        name = "Sand Stream",
        rating = 4,
        num = 45
    },
    sandveil = {
        onImmunity = function(self, ____type, pokemon)
            if ____type == "sandstorm" then
                return false
            end
        end,
        onModifyAccuracyPriority = -1,
        onModifyAccuracy = function(self, accuracy)
            if type(accuracy) ~= "number" then
                return
            end
            if self.field:isWeather("sandstorm") then
                self:debug("Sand Veil - decreasing accuracy")
                return self:chainModify({3277, 4096})
            end
        end,
        isBreakable = true,
        name = "Sand Veil",
        rating = 1.5,
        num = 8
    },
    sapsipper = {
        onTryHitPriority = 1,
        onTryHit = function(self, target, source, move)
            if (target ~= source) and (move.type == "Grass") then
                if not self:boost({atk = 1}) then
                    self:add("-immune", target, "[from] ability: Sap Sipper")
                end
                return nil
            end
        end,
        onAllyTryHitSide = function(self, target, source, move)
            if (source == self.effectState.target) or (not target:isAlly(source)) then
                return
            end
            if move.type == "Grass" then
                self:boost({atk = 1}, self.effectState.target)
            end
        end,
        isBreakable = true,
        name = "Sap Sipper",
        rating = 3,
        num = 157
    },
    schooling = {
        onStart = function(self, pokemon)
            if ((pokemon.baseSpecies.baseSpecies ~= "Wishiwashi") or (pokemon.level < 20)) or pokemon.transformed then
                return
            end
            if pokemon.hp > (pokemon.maxhp / 4) then
                if pokemon.species.id == "wishiwashi" then
                    pokemon:formeChange("Wishiwashi-School")
                end
            else
                if pokemon.species.id == "wishiwashischool" then
                    pokemon:formeChange("Wishiwashi")
                end
            end
        end,
        onResidualOrder = 29,
        onResidual = function(self, pokemon)
            if (((pokemon.baseSpecies.baseSpecies ~= "Wishiwashi") or (pokemon.level < 20)) or pokemon.transformed) or (not pokemon.hp) then
                return
            end
            if pokemon.hp > (pokemon.maxhp / 4) then
                if pokemon.species.id == "wishiwashi" then
                    pokemon:formeChange("Wishiwashi-School")
                end
            else
                if pokemon.species.id == "wishiwashischool" then
                    pokemon:formeChange("Wishiwashi")
                end
            end
        end,
        isPermanent = true,
        name = "Schooling",
        rating = 3,
        num = 208
    },
    scrappy = {
        onModifyMovePriority = -5,
        onModifyMove = function(self, move)
            if not move.ignoreImmunity then
                move.ignoreImmunity = {}
            end
            if move.ignoreImmunity ~= true then
                move.ignoreImmunity.Fighting = true
                move.ignoreImmunity.Normal = true
            end
        end,
        onBoost = function(self, boost, target, source, effect)
            if effect.id == "intimidate" then
                __TS__Delete(boost, "atk")
                self:add(
                    "-fail",
                    target,
                    "unboost",
                    "Attack",
                    "[from] ability: Scrappy",
                    "[of] " .. tostring(target)
                )
            end
        end,
        name = "Scrappy",
        rating = 3,
        num = 113
    },
    screencleaner = {
        onStart = function(self, pokemon)
            local activated = false
            for ____, sideCondition in ipairs({"reflect", "lightscreen", "auroraveil"}) do
                for ____, side in ipairs(
                    {
                        pokemon.side,
                        __TS__Spread(
                            pokemon.side:foeSidesWithConditions()
                        )
                    }
                ) do
                    if side:getSideCondition(sideCondition) then
                        if not activated then
                            self:add("-activate", pokemon, "ability: Screen Cleaner")
                            activated = true
                        end
                        side:removeSideCondition(sideCondition)
                    end
                end
            end
        end,
        name = "Screen Cleaner",
        rating = 2,
        num = 251
    },
    serenegrace = {
        onModifyMovePriority = -2,
        onModifyMove = function(self, move)
            if move.secondaries then
                self:debug("doubling secondary chance")
                for ____, secondary in __TS__Iterator(move.secondaries) do
                    if secondary.chance then
                        secondary.chance = secondary.chance * 2
                    end
                end
            end
            if move.self.chance then
                local ____obj, ____index = move.self, "chance"
                ____obj[____index] = ____obj[____index] * 2
            end
        end,
        name = "Serene Grace",
        rating = 3.5,
        num = 32
    },
    shadowshield = {
        onSourceModifyDamage = function(self, damage, source, target, move)
            if target.hp >= target.maxhp then
                self:debug("Shadow Shield weaken")
                return self:chainModify(0.5)
            end
        end,
        name = "Shadow Shield",
        rating = 3.5,
        num = 231
    },
    shadowtag = {
        onFoeTrapPokemon = function(self, pokemon)
            if (not pokemon:hasAbility("shadowtag")) and pokemon:isAdjacent(self.effectState.target) then
                pokemon:tryTrap(true)
            end
        end,
        onFoeMaybeTrapPokemon = function(self, pokemon, source)
            if not source then
                source = self.effectState.target
            end
            if (not source) or (not pokemon:isAdjacent(source)) then
                return
            end
            if not pokemon:hasAbility("shadowtag") then
                pokemon.maybeTrapped = true
            end
        end,
        name = "Shadow Tag",
        rating = 5,
        num = 23
    },
    shedskin = {
        onResidualOrder = 5,
        onResidualSubOrder = 3,
        onResidual = function(self, pokemon)
            if (pokemon.hp and pokemon.status) and self:randomChance(33, 100) then
                self:debug("shed skin")
                self:add("-activate", pokemon, "ability: Shed Skin")
                pokemon:cureStatus()
            end
        end,
        name = "Shed Skin",
        rating = 3,
        num = 61
    },
    sheerforce = {
        onModifyMove = function(self, move, pokemon)
            if move.secondaries then
                __TS__Delete(move, "secondaries")
                __TS__Delete(move, "self")
                if move.id == "clangoroussoulblaze" then
                    __TS__Delete(move, "selfBoost")
                end
                move.hasSheerForce = true
            end
        end,
        onBasePowerPriority = 21,
        onBasePower = function(self, basePower, pokemon, target, move)
            if move.hasSheerForce then
                return self:chainModify({5325, 4096})
            end
        end,
        name = "Sheer Force",
        rating = 3.5,
        num = 125
    },
    shellarmor = {onCriticalHit = false, isBreakable = true, name = "Shell Armor", rating = 1, num = 75},
    shielddust = {
        onModifySecondaries = function(self, secondaries)
            self:debug("Shield Dust prevent secondary")
            return secondaries:filter(
                function(____, effect) return not (not (effect.self or effect.dustproof)) end
            )
        end,
        isBreakable = true,
        name = "Shield Dust",
        rating = 2,
        num = 19
    },
    shieldsdown = {
        onStart = function(self, pokemon)
            if (pokemon.baseSpecies.baseSpecies ~= "Minior") or pokemon.transformed then
                return
            end
            if pokemon.hp > (pokemon.maxhp / 2) then
                if pokemon.species.forme ~= "Meteor" then
                    pokemon:formeChange("Minior-Meteor")
                end
            else
                if pokemon.species.forme == "Meteor" then
                    pokemon:formeChange(pokemon.set.species)
                end
            end
        end,
        onResidualOrder = 29,
        onResidual = function(self, pokemon)
            if ((pokemon.baseSpecies.baseSpecies ~= "Minior") or pokemon.transformed) or (not pokemon.hp) then
                return
            end
            if pokemon.hp > (pokemon.maxhp / 2) then
                if pokemon.species.forme ~= "Meteor" then
                    pokemon:formeChange("Minior-Meteor")
                end
            else
                if pokemon.species.forme == "Meteor" then
                    pokemon:formeChange(pokemon.set.species)
                end
            end
        end,
        onSetStatus = function(self, status, target, source, effect)
            if (target.species.id ~= "miniormeteor") or target.transformed then
                return
            end
            if effect.status then
                self:add("-immune", target, "[from] ability: Shields Down")
            end
            return false
        end,
        onTryAddVolatile = function(self, status, target)
            if (target.species.id ~= "miniormeteor") or target.transformed then
                return
            end
            if status.id ~= "yawn" then
                return
            end
            self:add("-immune", target, "[from] ability: Shields Down")
            return nil
        end,
        isPermanent = true,
        name = "Shields Down",
        rating = 3,
        num = 197
    },
    simple = {
        onBoost = function(self, boost, target, source, effect)
            if effect and (effect.id == "zpower") then
                return
            end
            local i
            for ____value in pairs(boost) do
                i = ____value
                boost[i] = boost[i] * 2
            end
        end,
        isBreakable = true,
        name = "Simple",
        rating = 4,
        num = 86
    },
    skilllink = {
        onModifyMove = function(self, move)
            if (move.multihit and __TS__ArrayIsArray(move.multihit)) and move.multihit.length then
                move.multihit = move.multihit[1]
            end
            if move.multiaccuracy then
                __TS__Delete(move, "multiaccuracy")
            end
        end,
        name = "Skill Link",
        rating = 3,
        num = 92
    },
    slowstart = {
        onStart = function(self, pokemon)
            pokemon:addVolatile("slowstart")
        end,
        onEnd = function(self, pokemon)
            __TS__Delete(pokemon.volatiles, "slowstart")
            self:add("-end", pokemon, "Slow Start", "[silent]")
        end,
        condition = {
            duration = 5,
            onResidualOrder = 28,
            onResidualSubOrder = 2,
            onStart = function(self, target)
                self:add("-start", target, "ability: Slow Start")
            end,
            onModifyAtkPriority = 5,
            onModifyAtk = function(self, atk, pokemon)
                return self:chainModify(0.5)
            end,
            onModifySpe = function(self, spe, pokemon)
                return self:chainModify(0.5)
            end,
            onEnd = function(self, target)
                self:add("-end", target, "Slow Start")
            end
        },
        name = "Slow Start",
        rating = -1,
        num = 112
    },
    slushrush = {
        onModifySpe = function(self, spe, pokemon)
            if self.field:isWeather("hail") then
                return self:chainModify(2)
            end
        end,
        name = "Slush Rush",
        rating = 3,
        num = 202
    },
    sniper = {
        onModifyDamage = function(self, damage, source, target, move)
            if target:getMoveHitData(move).crit then
                self:debug("Sniper boost")
                return self:chainModify(1.5)
            end
        end,
        name = "Sniper",
        rating = 2,
        num = 97
    },
    snowcloak = {
        onImmunity = function(self, ____type, pokemon)
            if ____type == "hail" then
                return false
            end
        end,
        onModifyAccuracyPriority = -1,
        onModifyAccuracy = function(self, accuracy)
            if type(accuracy) ~= "number" then
                return
            end
            if self.field:isWeather("hail") then
                self:debug("Snow Cloak - decreasing accuracy")
                return self:chainModify({3277, 4096})
            end
        end,
        isBreakable = true,
        name = "Snow Cloak",
        rating = 1.5,
        num = 81
    },
    snowwarning = {
        onStart = function(self, source)
            self.field:setWeather("hail")
        end,
        name = "Snow Warning",
        rating = 4,
        num = 117
    },
    solarpower = {
        onModifySpAPriority = 5,
        onModifySpA = function(self, spa, pokemon)
            if ({"sunnyday", "desolateland"}):includes(
                pokemon:effectiveWeather()
            ) then
                return self:chainModify(1.5)
            end
        end,
        onWeather = function(self, target, source, effect)
            if target:hasItem("utilityumbrella") then
                return
            end
            if (effect.id == "sunnyday") or (effect.id == "desolateland") then
                self:damage(target.baseMaxhp / 8, target, target)
            end
        end,
        name = "Solar Power",
        rating = 2,
        num = 94
    },
    solidrock = {
        onSourceModifyDamage = function(self, damage, source, target, move)
            if target:getMoveHitData(move).typeMod > 0 then
                self:debug("Solid Rock neutralize")
                return self:chainModify(0.75)
            end
        end,
        isBreakable = true,
        name = "Solid Rock",
        rating = 3,
        num = 116
    },
    soulheart = {
        onAnyFaintPriority = 1,
        onAnyFaint = function(self)
            self:boost({spa = 1}, self.effectState.target)
        end,
        name = "Soul-Heart",
        rating = 3.5,
        num = 220
    },
    soundproof = {
        onTryHit = function(self, target, source, move)
            if (target ~= source) and move.flags.sound then
                self:add("-immune", target, "[from] ability: Soundproof")
                return nil
            end
        end,
        onAllyTryHitSide = function(self, target, source, move)
            if move.flags.sound then
                self:add("-immune", self.effectState.target, "[from] ability: Soundproof")
            end
        end,
        isBreakable = true,
        name = "Soundproof",
        rating = 1.5,
        num = 43
    },
    speedboost = {
        onResidualOrder = 28,
        onResidualSubOrder = 2,
        onResidual = function(self, pokemon)
            if pokemon.activeTurns then
                self:boost({spe = 1})
            end
        end,
        name = "Speed Boost",
        rating = 4.5,
        num = 3
    },
    stakeout = {
        onModifyAtkPriority = 5,
        onModifyAtk = function(self, atk, attacker, defender)
            if not defender.activeTurns then
                self:debug("Stakeout boost")
                return self:chainModify(2)
            end
        end,
        onModifySpAPriority = 5,
        onModifySpA = function(self, atk, attacker, defender)
            if not defender.activeTurns then
                self:debug("Stakeout boost")
                return self:chainModify(2)
            end
        end,
        name = "Stakeout",
        rating = 4.5,
        num = 198
    },
    stall = {onFractionalPriority = -0.1, name = "Stall", rating = -1, num = 100},
    stalwart = {
        onModifyMovePriority = 1,
        onModifyMove = function(self, move)
            move.tracksTarget = move.target ~= "scripted"
        end,
        name = "Stalwart",
        rating = 0,
        num = 242
    },
    stamina = {
        onDamagingHit = function(self, damage, target, source, effect)
            self:boost({def = 1})
        end,
        name = "Stamina",
        rating = 3.5,
        num = 192
    },
    stancechange = {
        onModifyMovePriority = 1,
        onModifyMove = function(self, move, attacker, defender)
            if (attacker.species.baseSpecies ~= "Aegislash") or attacker.transformed then
                return
            end
            if (move.category == "Status") and (move.id ~= "kingsshield") then
                return
            end
            local targetForme = ((move.id == "kingsshield") and "Aegislash") or "Aegislash-Blade"
            if attacker.species.name ~= targetForme then
                attacker:formeChange(targetForme)
            end
        end,
        isPermanent = true,
        name = "Stance Change",
        rating = 4,
        num = 176
    },
    static = {
        onDamagingHit = function(self, damage, target, source, move)
            if self:checkMoveMakesContact(move, source, target) then
                if self:randomChance(3, 10) then
                    source:trySetStatus("par", target)
                end
            end
        end,
        name = "Static",
        rating = 2,
        num = 9
    },
    steadfast = {
        onFlinch = function(self, pokemon)
            self:boost({spe = 1})
        end,
        name = "Steadfast",
        rating = 1,
        num = 80
    },
    steamengine = {
        onDamagingHit = function(self, damage, target, source, move)
            if ({"Water", "Fire"}):includes(move.type) then
                self:boost({spe = 6})
            end
        end,
        name = "Steam Engine",
        rating = 2,
        num = 243
    },
    steelworker = {
        onModifyAtkPriority = 5,
        onModifyAtk = function(self, atk, attacker, defender, move)
            if move.type == "Steel" then
                self:debug("Steelworker boost")
                return self:chainModify(1.5)
            end
        end,
        onModifySpAPriority = 5,
        onModifySpA = function(self, atk, attacker, defender, move)
            if move.type == "Steel" then
                self:debug("Steelworker boost")
                return self:chainModify(1.5)
            end
        end,
        name = "Steelworker",
        rating = 3.5,
        num = 200
    },
    steelyspirit = {
        onAllyBasePowerPriority = 22,
        onAllyBasePower = function(self, basePower, attacker, defender, move)
            if move.type == "Steel" then
                self:debug("Steely Spirit boost")
                return self:chainModify(1.5)
            end
        end,
        name = "Steely Spirit",
        rating = 3.5,
        num = 252
    },
    stench = {
        onModifyMovePriority = -1,
        onModifyMove = function(self, move)
            if move.category ~= "Status" then
                self:debug("Adding Stench flinch")
                if not move.secondaries then
                    move.secondaries = {}
                end
                for ____, secondary in __TS__Iterator(move.secondaries) do
                    if secondary.volatileStatus == "flinch" then
                        return
                    end
                end
                move.secondaries:push({chance = 10, volatileStatus = "flinch"})
            end
        end,
        name = "Stench",
        rating = 0.5,
        num = 1
    },
    stickyhold = {
        onTakeItem = function(self, item, pokemon, source)
            if not self.activeMove then
                error(
                    __TS__New(Error, "Battle.activeMove is null"),
                    0
                )
            end
            if (not pokemon.hp) or (pokemon.item == "stickybarb") then
                return
            end
            if (source and (source ~= pokemon)) or (self.activeMove.id == "knockoff") then
                self:add("-activate", pokemon, "ability: Sticky Hold")
                return false
            end
        end,
        isBreakable = true,
        name = "Sticky Hold",
        rating = 2,
        num = 60
    },
    stormdrain = {
        onTryHit = function(self, target, source, move)
            if (target ~= source) and (move.type == "Water") then
                if not self:boost({spa = 1}) then
                    self:add("-immune", target, "[from] ability: Storm Drain")
                end
                return nil
            end
        end,
        onAnyRedirectTarget = function(self, target, source, source2, move)
            if (move.type ~= "Water") or ({"firepledge", "grasspledge", "waterpledge"}):includes(move.id) then
                return
            end
            local redirectTarget = (({"randomNormal", "adjacentFoe"}):includes(move.target) and "normal") or move.target
            if self:validTarget(self.effectState.target, source, redirectTarget) then
                if move.smartTarget then
                    move.smartTarget = false
                end
                if self.effectState.target ~= target then
                    self:add("-activate", self.effectState.target, "ability: Storm Drain")
                end
                return self.effectState.target
            end
        end,
        isBreakable = true,
        name = "Storm Drain",
        rating = 3,
        num = 114
    },
    strongjaw = {
        onBasePowerPriority = 19,
        onBasePower = function(self, basePower, attacker, defender, move)
            if move.flags.bite then
                return self:chainModify(1.5)
            end
        end,
        name = "Strong Jaw",
        rating = 3,
        num = 173
    },
    sturdy = {
        onTryHit = function(self, pokemon, target, move)
            if move.ohko then
                self:add("-immune", pokemon, "[from] ability: Sturdy")
                return nil
            end
        end,
        onDamagePriority = -30,
        onDamage = function(self, damage, target, source, effect)
            if (((target.hp == target.maxhp) and (damage >= target.hp)) and effect) and (effect.effectType == "Move") then
                self:add("-ability", target, "Sturdy")
                return target.hp - 1
            end
        end,
        isBreakable = true,
        name = "Sturdy",
        rating = 3,
        num = 5
    },
    suctioncups = {
        onDragOutPriority = 1,
        onDragOut = function(self, pokemon)
            self:add("-activate", pokemon, "ability: Suction Cups")
            return nil
        end,
        isBreakable = true,
        name = "Suction Cups",
        rating = 1,
        num = 21
    },
    superluck = {
        onModifyCritRatio = function(self, critRatio)
            return critRatio + 1
        end,
        name = "Super Luck",
        rating = 1.5,
        num = 105
    },
    surgesurfer = {
        onModifySpe = function(self, spe)
            if self.field:isTerrain("electricterrain") then
                return self:chainModify(2)
            end
        end,
        name = "Surge Surfer",
        rating = 3,
        num = 207
    },
    swarm = {
        onModifyAtkPriority = 5,
        onModifyAtk = function(self, atk, attacker, defender, move)
            if (move.type == "Bug") and (attacker.hp <= (attacker.maxhp / 3)) then
                self:debug("Swarm boost")
                return self:chainModify(1.5)
            end
        end,
        onModifySpAPriority = 5,
        onModifySpA = function(self, atk, attacker, defender, move)
            if (move.type == "Bug") and (attacker.hp <= (attacker.maxhp / 3)) then
                self:debug("Swarm boost")
                return self:chainModify(1.5)
            end
        end,
        name = "Swarm",
        rating = 2,
        num = 68
    },
    sweetveil = {
        name = "Sweet Veil",
        onAllySetStatus = function(self, status, target, source, effect)
            if status.id == "slp" then
                self:debug("Sweet Veil interrupts sleep")
                local effectHolder = self.effectState.target
                self:add(
                    "-block",
                    target,
                    "ability: Sweet Veil",
                    "[of] " .. tostring(effectHolder)
                )
                return nil
            end
        end,
        onAllyTryAddVolatile = function(self, status, target)
            if status.id == "yawn" then
                self:debug("Sweet Veil blocking yawn")
                local effectHolder = self.effectState.target
                self:add(
                    "-block",
                    target,
                    "ability: Sweet Veil",
                    "[of] " .. tostring(effectHolder)
                )
                return nil
            end
        end,
        isBreakable = true,
        rating = 2,
        num = 175
    },
    swiftswim = {
        onModifySpe = function(self, spe, pokemon)
            if ({"raindance", "primordialsea"}):includes(
                pokemon:effectiveWeather()
            ) then
                return self:chainModify(2)
            end
        end,
        name = "Swift Swim",
        rating = 3,
        num = 33
    },
    symbiosis = {
        onAllyAfterUseItem = function(self, item, pokemon)
            if pokemon.switchFlag then
                return
            end
            local source = self.effectState.target
            local myItem = source:takeItem()
            if not myItem then
                return
            end
            if (not self:singleEvent("TakeItem", myItem, source.itemState, pokemon, source, self.effect, myItem)) or (not pokemon:setItem(myItem)) then
                source.item = myItem.id
                return
            end
            self:add(
                "-activate",
                source,
                "ability: Symbiosis",
                myItem,
                "[of] " .. tostring(pokemon)
            )
        end,
        name = "Symbiosis",
        rating = 0,
        num = 180
    },
    synchronize = {
        onAfterSetStatus = function(self, status, target, source, effect)
            if (not source) or (source == target) then
                return
            end
            if effect and (effect.id == "toxicspikes") then
                return
            end
            if (status.id == "slp") or (status.id == "frz") then
                return
            end
            self:add("-activate", target, "ability: Synchronize")
            source:trySetStatus(status, target, {status = status.id, id = "synchronize"})
        end,
        name = "Synchronize",
        rating = 2,
        num = 28
    },
    tangledfeet = {
        onModifyAccuracyPriority = -1,
        onModifyAccuracy = function(self, accuracy, target)
            if type(accuracy) ~= "number" then
                return
            end
            if target.volatiles.confusion then
                self:debug("Tangled Feet - decreasing accuracy")
                return self:chainModify(0.5)
            end
        end,
        isBreakable = true,
        name = "Tangled Feet",
        rating = 1,
        num = 77
    },
    tanglinghair = {
        onDamagingHit = function(self, damage, target, source, move)
            if self:checkMoveMakesContact(move, source, target, true) then
                self:add("-ability", target, "Tangling Hair")
                self:boost({spe = -1}, source, target, nil, true)
            end
        end,
        name = "Tangling Hair",
        rating = 2,
        num = 221
    },
    technician = {
        onBasePowerPriority = 30,
        onBasePower = function(self, basePower, attacker, defender, move)
            local basePowerAfterMultiplier = self:modify(basePower, self.event.modifier)
            self:debug(
                "Base Power: " .. tostring(basePowerAfterMultiplier)
            )
            if basePowerAfterMultiplier <= 60 then
                self:debug("Technician boost")
                return self:chainModify(1.5)
            end
        end,
        name = "Technician",
        rating = 3.5,
        num = 101
    },
    telepathy = {
        onTryHit = function(self, target, source, move)
            if ((target ~= source) and target:isAlly(source)) and (move.category ~= "Status") then
                self:add("-activate", target, "ability: Telepathy")
                return nil
            end
        end,
        isBreakable = true,
        name = "Telepathy",
        rating = 0,
        num = 140
    },
    teravolt = {
        onStart = function(self, pokemon)
            self:add("-ability", pokemon, "Teravolt")
        end,
        onModifyMove = function(self, move)
            move.ignoreAbility = true
        end,
        name = "Teravolt",
        rating = 3.5,
        num = 164
    },
    thickfat = {
        onSourceModifyAtkPriority = 6,
        onSourceModifyAtk = function(self, atk, attacker, defender, move)
            if (move.type == "Ice") or (move.type == "Fire") then
                self:debug("Thick Fat weaken")
                return self:chainModify(0.5)
            end
        end,
        onSourceModifySpAPriority = 5,
        onSourceModifySpA = function(self, atk, attacker, defender, move)
            if (move.type == "Ice") or (move.type == "Fire") then
                self:debug("Thick Fat weaken")
                return self:chainModify(0.5)
            end
        end,
        isBreakable = true,
        name = "Thick Fat",
        rating = 3.5,
        num = 47
    },
    tintedlens = {
        onModifyDamage = function(self, damage, source, target, move)
            if target:getMoveHitData(move).typeMod < 0 then
                self:debug("Tinted Lens boost")
                return self:chainModify(2)
            end
        end,
        name = "Tinted Lens",
        rating = 4,
        num = 110
    },
    torrent = {
        onModifyAtkPriority = 5,
        onModifyAtk = function(self, atk, attacker, defender, move)
            if (move.type == "Water") and (attacker.hp <= (attacker.maxhp / 3)) then
                self:debug("Torrent boost")
                return self:chainModify(1.5)
            end
        end,
        onModifySpAPriority = 5,
        onModifySpA = function(self, atk, attacker, defender, move)
            if (move.type == "Water") and (attacker.hp <= (attacker.maxhp / 3)) then
                self:debug("Torrent boost")
                return self:chainModify(1.5)
            end
        end,
        name = "Torrent",
        rating = 2,
        num = 67
    },
    toughclaws = {
        onBasePowerPriority = 21,
        onBasePower = function(self, basePower, attacker, defender, move)
            if move.flags.contact then
                return self:chainModify({5325, 4096})
            end
        end,
        name = "Tough Claws",
        rating = 3.5,
        num = 181
    },
    toxicboost = {
        onBasePowerPriority = 19,
        onBasePower = function(self, basePower, attacker, defender, move)
            if ((attacker.status == "psn") or (attacker.status == "tox")) and (move.category == "Physical") then
                return self:chainModify(1.5)
            end
        end,
        name = "Toxic Boost",
        rating = 2.5,
        num = 137
    },
    trace = {
        onStart = function(self, pokemon)
            if pokemon:adjacentFoes():some(
                function(____, foeActive) return foeActive.ability == "noability" end
            ) then
                self.effectState.gaveUp = true
            end
        end,
        onUpdate = function(self, pokemon)
            if (not pokemon.isStarted) or self.effectState.gaveUp then
                return
            end
            local additionalBannedAbilities = {"noability", "flowergift", "forecast", "hungerswitch", "illusion", "imposter", "neutralizinggas", "powerofalchemy", "receiver", "trace", "zenmode"}
            local possibleTargets = pokemon:adjacentFoes():filter(
                function(____, target) return (not target:getAbility().isPermanent) and (not additionalBannedAbilities:includes(target.ability)) end
            )
            if not possibleTargets.length then
                return
            end
            local target = self:sample(possibleTargets)
            local ability = target:getAbility()
            self:add(
                "-ability",
                pokemon,
                ability,
                "[from] ability: Trace",
                "[of] " .. tostring(target)
            )
            pokemon:setAbility(ability)
        end,
        name = "Trace",
        rating = 2.5,
        num = 36
    },
    transistor = {
        onModifyAtkPriority = 5,
        onModifyAtk = function(self, atk, attacker, defender, move)
            if move.type == "Electric" then
                self:debug("Transistor boost")
                return self:chainModify(1.5)
            end
        end,
        onModifySpAPriority = 5,
        onModifySpA = function(self, atk, attacker, defender, move)
            if move.type == "Electric" then
                self:debug("Transistor boost")
                return self:chainModify(1.5)
            end
        end,
        name = "Transistor",
        rating = 3.5,
        num = 262
    },
    triage = {
        onModifyPriority = function(self, priority, pokemon, target, move)
            if move.flags.heal then
                return priority + 3
            end
        end,
        name = "Triage",
        rating = 3.5,
        num = 205
    },
    truant = {
        onStart = function(self, pokemon)
            pokemon:removeVolatile("truant")
            if pokemon.activeTurns and ((pokemon.moveThisTurnResult ~= nil) or (not self.queue:willMove(pokemon))) then
                pokemon:addVolatile("truant")
            end
        end,
        onBeforeMovePriority = 9,
        onBeforeMove = function(self, pokemon)
            if pokemon:removeVolatile("truant") then
                self:add("cant", pokemon, "ability: Truant")
                return false
            end
            pokemon:addVolatile("truant")
        end,
        condition = {},
        name = "Truant",
        rating = -1,
        num = 54
    },
    turboblaze = {
        onStart = function(self, pokemon)
            self:add("-ability", pokemon, "Turboblaze")
        end,
        onModifyMove = function(self, move)
            move.ignoreAbility = true
        end,
        name = "Turboblaze",
        rating = 3.5,
        num = 163
    },
    unaware = {
        name = "Unaware",
        onAnyModifyBoost = function(self, boosts, pokemon)
            local unawareUser = self.effectState.target
            if unawareUser == pokemon then
                return
            end
            if (unawareUser == self.activePokemon) and (pokemon == self.activeTarget) then
                boosts.def = 0
                boosts.spd = 0
                boosts.evasion = 0
            end
            if (pokemon == self.activePokemon) and (unawareUser == self.activeTarget) then
                boosts.atk = 0
                boosts.def = 0
                boosts.spa = 0
                boosts.accuracy = 0
            end
        end,
        isBreakable = true,
        rating = 4,
        num = 109
    },
    unburden = {
        onAfterUseItem = function(self, item, pokemon)
            if pokemon ~= self.effectState.target then
                return
            end
            pokemon:addVolatile("unburden")
        end,
        onTakeItem = function(self, item, pokemon)
            pokemon:addVolatile("unburden")
        end,
        onEnd = function(self, pokemon)
            pokemon:removeVolatile("unburden")
        end,
        condition = {
            onModifySpe = function(self, spe, pokemon)
                if (not pokemon.item) and (not pokemon:ignoringAbility()) then
                    return self:chainModify(2)
                end
            end
        },
        name = "Unburden",
        rating = 3.5,
        num = 84
    },
    unnerve = {
        onPreStart = function(self, pokemon)
            self:add("-ability", pokemon, "Unnerve")
            self.effectState.unnerved = true
        end,
        onStart = function(self, pokemon)
            if self.effectState.unnerved then
                return
            end
            self:add("-ability", pokemon, "Unnerve")
            self.effectState.unnerved = true
        end,
        onEnd = function(self)
            self.effectState.unnerved = false
        end,
        onFoeTryEatItem = function(self)
            return not self.effectState.unnerved
        end,
        name = "Unnerve",
        rating = 1.5,
        num = 127
    },
    unseenfist = {
        onModifyMove = function(self, move)
            if move.flags.contact then
                __TS__Delete(move.flags, "protect")
            end
        end,
        name = "Unseen Fist",
        rating = 2,
        num = 260
    },
    victorystar = {
        onAnyModifyAccuracyPriority = -1,
        onAnyModifyAccuracy = function(self, accuracy, target, source)
            if source:isAlly(self.effectState.target) and (type(accuracy) == "number") then
                return self:chainModify({4506, 4096})
            end
        end,
        name = "Victory Star",
        rating = 2,
        num = 162
    },
    vitalspirit = {
        onUpdate = function(self, pokemon)
            if pokemon.status == "slp" then
                self:add("-activate", pokemon, "ability: Vital Spirit")
                pokemon:cureStatus()
            end
        end,
        onSetStatus = function(self, status, target, source, effect)
            if status.id ~= "slp" then
                return
            end
            if effect.status then
                self:add("-immune", target, "[from] ability: Vital Spirit")
            end
            return false
        end,
        isBreakable = true,
        name = "Vital Spirit",
        rating = 2,
        num = 72
    },
    voltabsorb = {
        onTryHit = function(self, target, source, move)
            if (target ~= source) and (move.type == "Electric") then
                if not self:heal(target.baseMaxhp / 4) then
                    self:add("-immune", target, "[from] ability: Volt Absorb")
                end
                return nil
            end
        end,
        isBreakable = true,
        name = "Volt Absorb",
        rating = 3.5,
        num = 10
    },
    wanderingspirit = {
        onDamagingHit = function(self, damage, target, source, move)
            local additionalBannedAbilities = {"hungerswitch", "illusion", "neutralizinggas", "wonderguard"}
            if (source:getAbility().isPermanent or additionalBannedAbilities:includes(source.ability)) or target.volatiles.dynamax then
                return
            end
            if self:checkMoveMakesContact(move, source, target) then
                local sourceAbility = source:setAbility("wanderingspirit", target)
                if not sourceAbility then
                    return
                end
                if target:isAlly(source) then
                    self:add(
                        "-activate",
                        target,
                        "Skill Swap",
                        "",
                        "",
                        "[of] " .. tostring(source)
                    )
                else
                    self:add(
                        "-activate",
                        target,
                        "ability: Wandering Spirit",
                        self.dex.abilities:get(sourceAbility).name,
                        "Wandering Spirit",
                        "[of] " .. tostring(source)
                    )
                end
                target:setAbility(sourceAbility)
            end
        end,
        name = "Wandering Spirit",
        rating = 2.5,
        num = 254
    },
    waterabsorb = {
        onTryHit = function(self, target, source, move)
            if (target ~= source) and (move.type == "Water") then
                if not self:heal(target.baseMaxhp / 4) then
                    self:add("-immune", target, "[from] ability: Water Absorb")
                end
                return nil
            end
        end,
        isBreakable = true,
        name = "Water Absorb",
        rating = 3.5,
        num = 11
    },
    waterbubble = {
        onSourceModifyAtkPriority = 5,
        onSourceModifyAtk = function(self, atk, attacker, defender, move)
            if move.type == "Fire" then
                return self:chainModify(0.5)
            end
        end,
        onSourceModifySpAPriority = 5,
        onSourceModifySpA = function(self, atk, attacker, defender, move)
            if move.type == "Fire" then
                return self:chainModify(0.5)
            end
        end,
        onModifyAtk = function(self, atk, attacker, defender, move)
            if move.type == "Water" then
                return self:chainModify(2)
            end
        end,
        onModifySpA = function(self, atk, attacker, defender, move)
            if move.type == "Water" then
                return self:chainModify(2)
            end
        end,
        onUpdate = function(self, pokemon)
            if pokemon.status == "brn" then
                self:add("-activate", pokemon, "ability: Water Bubble")
                pokemon:cureStatus()
            end
        end,
        onSetStatus = function(self, status, target, source, effect)
            if status.id ~= "brn" then
                return
            end
            if effect.status then
                self:add("-immune", target, "[from] ability: Water Bubble")
            end
            return false
        end,
        isBreakable = true,
        name = "Water Bubble",
        rating = 4.5,
        num = 199
    },
    watercompaction = {
        onDamagingHit = function(self, damage, target, source, move)
            if move.type == "Water" then
                self:boost({def = 2})
            end
        end,
        name = "Water Compaction",
        rating = 1.5,
        num = 195
    },
    waterveil = {
        onUpdate = function(self, pokemon)
            if pokemon.status == "brn" then
                self:add("-activate", pokemon, "ability: Water Veil")
                pokemon:cureStatus()
            end
        end,
        onSetStatus = function(self, status, target, source, effect)
            if status.id ~= "brn" then
                return
            end
            if effect.status then
                self:add("-immune", target, "[from] ability: Water Veil")
            end
            return false
        end,
        isBreakable = true,
        name = "Water Veil",
        rating = 2,
        num = 41
    },
    weakarmor = {
        onDamagingHit = function(self, damage, target, source, move)
            if move.category == "Physical" then
                self:boost({def = -1, spe = 2}, target, target)
            end
        end,
        name = "Weak Armor",
        rating = 1,
        num = 133
    },
    whitesmoke = {
        onBoost = function(self, boost, target, source, effect)
            if source and (target == source) then
                return
            end
            local showMsg = false
            local i
            for ____value in pairs(boost) do
                i = ____value
                if boost[i] < 0 then
                    __TS__Delete(boost, i)
                    showMsg = true
                end
            end
            if (showMsg and (not effect.secondaries)) and (effect.id ~= "octolock") then
                self:add(
                    "-fail",
                    target,
                    "unboost",
                    "[from] ability: White Smoke",
                    "[of] " .. tostring(target)
                )
            end
        end,
        isBreakable = true,
        name = "White Smoke",
        rating = 2,
        num = 73
    },
    wimpout = {
        onEmergencyExit = function(self, target)
            if ((not self:canSwitch(target.side)) or target.forceSwitchFlag) or target.switchFlag then
                return
            end
            for ____, side in __TS__Iterator(self.sides) do
                for ____, active in __TS__Iterator(side.active) do
                    active.switchFlag = false
                end
            end
            target.switchFlag = true
            self:add("-activate", target, "ability: Wimp Out")
        end,
        name = "Wimp Out",
        rating = 1,
        num = 193
    },
    wonderguard = {
        onTryHit = function(self, target, source, move)
            if (((target == source) or (move.category == "Status")) or (move.type == "???")) or (move.id == "struggle") then
                return
            end
            if (move.id == "skydrop") and (not source.volatiles.skydrop) then
                return
            end
            self:debug(
                "Wonder Guard immunity: " .. tostring(move.id)
            )
            if target:runEffectiveness(move) <= 0 then
                if move.smartTarget then
                    move.smartTarget = false
                else
                    self:add("-immune", target, "[from] ability: Wonder Guard")
                end
                return nil
            end
        end,
        isBreakable = true,
        name = "Wonder Guard",
        rating = 5,
        num = 25
    },
    wonderskin = {
        onModifyAccuracyPriority = 10,
        onModifyAccuracy = function(self, accuracy, target, source, move)
            if (move.category == "Status") and (type(accuracy) == "number") then
                self:debug("Wonder Skin - setting accuracy to 50")
                return 50
            end
        end,
        isBreakable = true,
        name = "Wonder Skin",
        rating = 2,
        num = 147
    },
    zenmode = {
        onResidualOrder = 29,
        onResidual = function(self, pokemon)
            if (pokemon.baseSpecies.baseSpecies ~= "Darmanitan") or pokemon.transformed then
                return
            end
            if (pokemon.hp <= (pokemon.maxhp / 2)) and (not ({"Zen", "Galar-Zen"}):includes(pokemon.species.forme)) then
                pokemon:addVolatile("zenmode")
            elseif (pokemon.hp > (pokemon.maxhp / 2)) and ({"Zen", "Galar-Zen"}):includes(pokemon.species.forme) then
                pokemon:addVolatile("zenmode")
                pokemon:removeVolatile("zenmode")
            end
        end,
        onEnd = function(self, pokemon)
            if (not pokemon.volatiles.zenmode) or (not pokemon.hp) then
                return
            end
            pokemon.transformed = false
            __TS__Delete(pokemon.volatiles, "zenmode")
            if (pokemon.species.baseSpecies == "Darmanitan") and pokemon.species.battleOnly then
                pokemon:formeChange(pokemon.species.battleOnly, self.effect, false, "[silent]")
            end
        end,
        condition = {
            onStart = function(self, pokemon)
                if not pokemon.species.name:includes("Galar") then
                    if pokemon.species.id ~= "darmanitanzen" then
                        pokemon:formeChange("Darmanitan-Zen")
                    end
                else
                    if pokemon.species.id ~= "darmanitangalarzen" then
                        pokemon:formeChange("Darmanitan-Galar-Zen")
                    end
                end
            end,
            onEnd = function(self, pokemon)
                if ({"Zen", "Galar-Zen"}):includes(pokemon.species.forme) then
                    pokemon:formeChange(pokemon.species.battleOnly)
                end
            end
        },
        isPermanent = true,
        name = "Zen Mode",
        rating = 0,
        num = 161
    },
    mountaineer = {
        onDamage = function(self, damage, target, source, effect)
            if effect and (effect.id == "stealthrock") then
                return false
            end
        end,
        onTryHit = function(self, target, source, move)
            if (move.type == "Rock") and (not target.activeTurns) then
                self:add("-immune", target, "[from] ability: Mountaineer")
                return nil
            end
        end,
        isNonstandard = "CAP",
        isBreakable = true,
        name = "Mountaineer",
        rating = 3,
        num = -2
    },
    rebound = {
        isNonstandard = "CAP",
        name = "Rebound",
        onTryHitPriority = 1,
        onTryHit = function(self, target, source, move)
            if self.effectState.target.activeTurns then
                return
            end
            if ((target == source) or move.hasBounced) or (not move.flags.reflectable) then
                return
            end
            local newMove = self.dex:getActiveMove(move.id)
            newMove.hasBounced = true
            self.actions:useMove(newMove, target, source)
            return nil
        end,
        onAllyTryHitSide = function(self, target, source, move)
            if self.effectState.target.activeTurns then
                return
            end
            if (target:isAlly(source) or move.hasBounced) or (not move.flags.reflectable) then
                return
            end
            local newMove = self.dex:getActiveMove(move.id)
            newMove.hasBounced = true
            self.actions:useMove(newMove, self.effectState.target, source)
            return nil
        end,
        condition = {duration = 1},
        isBreakable = true,
        rating = 3,
        num = -3
    },
    persistent = {isNonstandard = "CAP", name = "Persistent", rating = 3, num = -4}
}

return ____exports
