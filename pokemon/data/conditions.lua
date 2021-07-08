--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");

local ____exports = {}

____exports.Conditions = {
    brn = {
        name = "brn",
        effectType = "Status",
        onStart = function(self, target, source, sourceEffect)
            if sourceEffect and (sourceEffect.id == "flameorb") then
                self:add("-status", target, "brn", "[from] item: Flame Orb")
            elseif sourceEffect and (sourceEffect.effectType == "Ability") then
                self:add(
                    "-status",
                    target,
                    "brn",
                    "[from] ability: " .. tostring(sourceEffect.name),
                    "[of] " .. tostring(source)
                )
            else
                self:add("-status", target, "brn")
            end
        end,
        onResidualOrder = 10,
        onResidual = function(self, pokemon)
            self:damage(pokemon.baseMaxhp / 16)
        end
    },
    par = {
        name = "par",
        effectType = "Status",
        onStart = function(self, target, source, sourceEffect)
            if sourceEffect and (sourceEffect.effectType == "Ability") then
                self:add(
                    "-status",
                    target,
                    "par",
                    "[from] ability: " .. tostring(sourceEffect.name),
                    "[of] " .. tostring(source)
                )
            else
                self:add("-status", target, "par")
            end
        end,
        onModifySpe = function(self, spe, pokemon)
            if not pokemon:hasAbility("quickfeet") then
                return self:chainModify(0.5)
            end
        end,
        onBeforeMovePriority = 1,
        onBeforeMove = function(self, pokemon)
            if self:randomChance(1, 4) then
                self:add("cant", pokemon, "par")
                return false
            end
        end
    },
    slp = {
        name = "slp",
        effectType = "Status",
        onStart = function(self, target, source, sourceEffect)
            if sourceEffect and (sourceEffect.effectType == "Ability") then
                self:add(
                    "-status",
                    target,
                    "slp",
                    "[from] ability: " .. tostring(sourceEffect.name),
                    "[of] " .. tostring(source)
                )
            elseif sourceEffect and (sourceEffect.effectType == "Move") then
                self:add(
                    "-status",
                    target,
                    "slp",
                    "[from] move: " .. tostring(sourceEffect.name)
                )
            else
                self:add("-status", target, "slp")
            end
            self.effectState.startTime = self:random(2, 5)
            self.effectState.time = self.effectState.startTime
        end,
        onBeforeMovePriority = 10,
        onBeforeMove = function(self, pokemon, target, move)
            if pokemon:hasAbility("earlybird") then
                local ____obj, ____index = pokemon.statusState, "time"
                ____obj[____index] = ____obj[____index] - 1
            end
            local ____obj, ____index = pokemon.statusState, "time"
            ____obj[____index] = ____obj[____index] - 1
            if pokemon.statusState.time <= 0 then
                pokemon:cureStatus()
                return
            end
            self:add("cant", pokemon, "slp")
            if move.sleepUsable then
                return
            end
            return false
        end
    },
    frz = {
        name = "frz",
        effectType = "Status",
        onStart = function(self, target, source, sourceEffect)
            if sourceEffect and (sourceEffect.effectType == "Ability") then
                self:add(
                    "-status",
                    target,
                    "frz",
                    "[from] ability: " .. tostring(sourceEffect.name),
                    "[of] " .. tostring(source)
                )
            else
                self:add("-status", target, "frz")
            end
            if (target.species.name == "Shaymin-Sky") and (target.baseSpecies.baseSpecies == "Shaymin") then
                target:formeChange("Shaymin", self.effect, true)
            end
        end,
        onBeforeMovePriority = 10,
        onBeforeMove = function(self, pokemon, target, move)
            if move.flags.defrost then
                return
            end
            if self:randomChance(1, 5) then
                pokemon:cureStatus()
                return
            end
            self:add("cant", pokemon, "frz")
            return false
        end,
        onModifyMove = function(self, move, pokemon)
            if move.flags.defrost then
                self:add(
                    "-curestatus",
                    pokemon,
                    "frz",
                    "[from] move: " .. tostring(move)
                )
                pokemon:setStatus("")
            end
        end,
        onHit = function(self, target, source, move)
            if move.thawsTarget or ((move.type == "Fire") and (move.category ~= "Status")) then
                target:cureStatus()
            end
        end
    },
    psn = {
        name = "psn",
        effectType = "Status",
        onStart = function(self, target, source, sourceEffect)
            if sourceEffect and (sourceEffect.effectType == "Ability") then
                self:add(
                    "-status",
                    target,
                    "psn",
                    "[from] ability: " .. tostring(sourceEffect.name),
                    "[of] " .. tostring(source)
                )
            else
                self:add("-status", target, "psn")
            end
        end,
        onResidualOrder = 9,
        onResidual = function(self, pokemon)
            self:damage(pokemon.baseMaxhp / 8)
        end
    },
    tox = {
        name = "tox",
        effectType = "Status",
        onStart = function(self, target, source, sourceEffect)
            self.effectState.stage = 0
            if sourceEffect and (sourceEffect.id == "toxicorb") then
                self:add("-status", target, "tox", "[from] item: Toxic Orb")
            elseif sourceEffect and (sourceEffect.effectType == "Ability") then
                self:add(
                    "-status",
                    target,
                    "tox",
                    "[from] ability: " .. tostring(sourceEffect.name),
                    "[of] " .. tostring(source)
                )
            else
                self:add("-status", target, "tox")
            end
        end,
        onSwitchIn = function(self)
            self.effectState.stage = 0
        end,
        onResidualOrder = 9,
        onResidual = function(self, pokemon)
            if self.effectState.stage < 15 then
                local ____obj, ____index = self.effectState, "stage"
                ____obj[____index] = ____obj[____index] + 1
            end
            self:damage(
                self:clampIntRange(pokemon.baseMaxhp / 16, 1) * self.effectState.stage
            )
        end
    },
    confusion = {
        name = "confusion",
        onStart = function(self, target, source, sourceEffect)
            if sourceEffect and (sourceEffect.id == "lockedmove") then
                self:add("-start", target, "confusion", "[fatigue]")
            else
                self:add("-start", target, "confusion")
            end
            self.effectState.time = self:random(2, 6)
        end,
        onEnd = function(self, target)
            self:add("-end", target, "confusion")
        end,
        onBeforeMovePriority = 3,
        onBeforeMove = function(self, pokemon)
            local ____obj, ____index = pokemon.volatiles.confusion, "time"
            ____obj[____index] = ____obj[____index] - 1
            if not pokemon.volatiles.confusion.time then
                pokemon:removeVolatile("confusion")
                return
            end
            self:add("-activate", pokemon, "confusion")
            if not self:randomChance(33, 100) then
                return
            end
            self.activeTarget = pokemon
            local damage = self.actions:getConfusionDamage(pokemon, 40)
            if type(damage) ~= "number" then
                error(
                    __TS__New(Error, "Confusion damage not dealt"),
                    0
                )
            end
            local activeMove = {
                id = self:toID("confused"),
                effectType = "Move",
                type = "???"
            }
            self:damage(damage, pokemon, pokemon, activeMove)
            return false
        end
    },
    flinch = {
        name = "flinch",
        duration = 1,
        onBeforeMovePriority = 8,
        onBeforeMove = function(self, pokemon)
            self:add("cant", pokemon, "flinch")
            self:runEvent("Flinch", pokemon)
            return false
        end
    },
    trapped = {
        name = "trapped",
        noCopy = true,
        onTrapPokemon = function(self, pokemon)
            pokemon:tryTrap()
        end,
        onStart = function(self, target)
            self:add("-activate", target, "trapped")
        end
    },
    trapper = {name = "trapper", noCopy = true},
    partiallytrapped = {
        name = "partiallytrapped",
        duration = 5,
        durationCallback = function(self, target, source)
            if source:hasItem("gripclaw") then
                return 8
            end
            return self:random(5, 7)
        end,
        onStart = function(self, pokemon, source)
            self:add(
                "-activate",
                pokemon,
                "move: " .. tostring(self.effectState.sourceEffect),
                "[of] " .. tostring(source)
            )
            self.effectState.boundDivisor = (source:hasItem("bindingband") and 6) or 8
        end,
        onResidualOrder = 13,
        onResidual = function(self, pokemon)
            local source = self.effectState.source
            local gmaxEffect = ({"gmaxcentiferno", "gmaxsandblast"}):includes(self.effectState.sourceEffect.id)
            if (source and (((not source.isActive) or (source.hp <= 0)) or (not source.activeTurns))) and (not gmaxEffect) then
                __TS__Delete(pokemon.volatiles, "partiallytrapped")
                self:add("-end", pokemon, self.effectState.sourceEffect, "[partiallytrapped]", "[silent]")
                return
            end
            self:damage(pokemon.baseMaxhp / self.effectState.boundDivisor)
        end,
        onEnd = function(self, pokemon)
            self:add("-end", pokemon, self.effectState.sourceEffect, "[partiallytrapped]")
        end,
        onTrapPokemon = function(self, pokemon)
            local gmaxEffect = ({"gmaxcentiferno", "gmaxsandblast"}):includes(self.effectState.sourceEffect.id)
            if self.effectState.source.isActive or gmaxEffect then
                pokemon:tryTrap()
            end
        end
    },
    lockedmove = {
        name = "lockedmove",
        duration = 2,
        onResidual = function(self, target)
            if target.status == "slp" then
                __TS__Delete(target.volatiles, "lockedmove")
            end
            local ____obj, ____index = self.effectState, "trueDuration"
            ____obj[____index] = ____obj[____index] - 1
        end,
        onStart = function(self, target, source, effect)
            self.effectState.trueDuration = self:random(2, 4)
            self.effectState.move = effect.id
        end,
        onRestart = function(self)
            if self.effectState.trueDuration >= 2 then
                self.effectState.duration = 2
            end
        end,
        onEnd = function(self, target)
            if self.effectState.trueDuration > 1 then
                return
            end
            target:addVolatile("confusion")
        end,
        onLockMove = function(self, pokemon)
            if pokemon.volatiles.dynamax then
                return
            end
            return self.effectState.move
        end
    },
    twoturnmove = {
        name = "twoturnmove",
        duration = 2,
        onStart = function(self, attacker, defender, effect)
            self.effectState.move = effect.id
            attacker:addVolatile(effect.id)
            local moveTargetLoc = attacker.lastMoveTargetLoc
            if effect.sourceEffect and (self.dex.moves:get(effect.id).target == "normal") then
                if defender.fainted then
                    defender = self:sample(
                        attacker:foes(true)
                    )
                end
                moveTargetLoc = attacker:getLocOf(defender)
            end
            attacker.volatiles[effect.id].targetLoc = moveTargetLoc
            self:attrLastMove("[still]")
            self:runEvent("PrepareHit", attacker, defender, effect)
        end,
        onEnd = function(self, target)
            target:removeVolatile(self.effectState.move)
        end,
        onLockMove = function(self)
            return self.effectState.move
        end,
        onMoveAborted = function(self, pokemon)
            pokemon:removeVolatile("twoturnmove")
        end
    },
    choicelock = {
        name = "choicelock",
        noCopy = true,
        onStart = function(self, pokemon)
            if not self.activeMove then
                error(
                    __TS__New(Error, "Battle.activeMove is null"),
                    0
                )
            end
            if ((not self.activeMove.id) or self.activeMove.hasBounced) or (self.activeMove.sourceEffect == "snatch") then
                return false
            end
            self.effectState.move = self.activeMove.id
        end,
        onBeforeMove = function(self, pokemon, target, move)
            if not pokemon:getItem().isChoice then
                pokemon:removeVolatile("choicelock")
                return
            end
            if (((not pokemon:ignoringItem()) and (not pokemon.volatiles.dynamax)) and (move.id ~= self.effectState.move)) and (move.id ~= "struggle") then
                self:addMove("move", pokemon, move.name)
                self:attrLastMove("[still]")
                self:debug("Disabled by Choice item lock")
                self:add("-fail", pokemon)
                return false
            end
        end,
        onDisableMove = function(self, pokemon)
            if (not pokemon:getItem().isChoice) or (not pokemon:hasMove(self.effectState.move)) then
                pokemon:removeVolatile("choicelock")
                return
            end
            if pokemon:ignoringItem() or pokemon.volatiles.dynamax then
                return
            end
            for ____, moveSlot in __TS__Iterator(pokemon.moveSlots) do
                if moveSlot.id ~= self.effectState.move then
                    pokemon:disableMove(moveSlot.id, false, self.effectState.sourceEffect)
                end
            end
        end
    },
    mustrecharge = {
        name = "mustrecharge",
        duration = 2,
        onBeforeMovePriority = 11,
        onBeforeMove = function(self, pokemon)
            self:add("cant", pokemon, "recharge")
            pokemon:removeVolatile("mustrecharge")
            pokemon:removeVolatile("truant")
            return nil
        end,
        onStart = function(self, pokemon)
            self:add("-mustrecharge", pokemon)
        end,
        onLockMove = "recharge"
    },
    futuremove = {
        name = "futuremove",
        duration = 3,
        onResidualOrder = 3,
        onEnd = function(self, target)
            local data = self.effectState
            local move = self.dex.moves:get(data.move)
            if target.fainted or (target == data.source) then
                self:hint(
                    ((tostring(move.name) .. " did not hit because the target is ") .. ((target.fainted and "fainted") or "the user")) .. "."
                )
                return
            end
            self:add(
                "-end",
                target,
                "move: " .. tostring(move.name)
            )
            target:removeVolatile("Protect")
            target:removeVolatile("Endure")
            if data.source:hasAbility("infiltrator") and (self.gen >= 6) then
                data.moveData.infiltrates = true
            end
            if data.source:hasAbility("normalize") and (self.gen >= 6) then
                data.moveData.type = "Normal"
            end
            if data.source:hasAbility("adaptability") and (self.gen >= 6) then
                data.moveData.stab = 2
            end
            local hitMove = __TS__New(self.dex.Move, data.moveData)
            self.actions:trySpreadMoveHit({target}, data.source, hitMove, true)
            if (data.source.isActive and data.source:hasItem("lifeorb")) and (self.gen >= 5) then
                self:singleEvent(
                    "AfterMoveSecondarySelf",
                    data.source:getItem(),
                    data.source.itemState,
                    data.source,
                    target,
                    data.source:getItem()
                )
            end
            self:checkWin()
        end
    },
    healreplacement = {
        name = "healreplacement",
        onStart = function(self, target, source, sourceEffect)
            self.effectState.sourceEffect = sourceEffect
            self:add("-activate", source, "healreplacement")
        end,
        onSwitchInPriority = 1,
        onSwitchIn = function(self, target)
            if not target.fainted then
                target:heal(target.maxhp)
                self:add(
                    "-heal",
                    target,
                    target.getHealth,
                    "[from] move: " .. tostring(self.effectState.sourceEffect),
                    "[zeffect]"
                )
                target.side:removeSlotCondition(target, "healreplacement")
            end
        end
    },
    stall = {
        name = "stall",
        duration = 2,
        counterMax = 729,
        onStart = function(self)
            self.effectState.counter = 3
        end,
        onStallMove = function(self, pokemon)
            local counter = self.effectState.counter or 1
            self:debug(
                ("Success chance: " .. tostring(
                    math.floor((100 / counter) + 0.5)
                )) .. "%"
            )
            local success = self:randomChance(1, counter)
            if not success then
                __TS__Delete(pokemon.volatiles, "stall")
            end
            return success
        end,
        onRestart = function(self)
            if self.effectState.counter < self.effect.counterMax then
                local ____obj, ____index = self.effectState, "counter"
                ____obj[____index] = ____obj[____index] * 3
            end
            self.effectState.duration = 2
        end
    },
    gem = {
        name = "gem",
        duration = 1,
        affectsFainted = true,
        onBasePowerPriority = 14,
        onBasePower = function(self, basePower, user, target, move)
            self:debug("Gem Boost")
            return self:chainModify({5325, 4096})
        end
    },
    raindance = {
        name = "RainDance",
        effectType = "Weather",
        duration = 5,
        durationCallback = function(self, source, effect)
            if source:hasItem("damprock") then
                return 8
            end
            return 5
        end,
        onWeatherModifyDamage = function(self, damage, attacker, defender, move)
            if defender:hasItem("utilityumbrella") then
                return
            end
            if move.type == "Water" then
                self:debug("rain water boost")
                return self:chainModify(1.5)
            end
            if move.type == "Fire" then
                self:debug("rain fire suppress")
                return self:chainModify(0.5)
            end
        end,
        onFieldStart = function(self, field, source, effect)
            if effect.effectType == "Ability" then
                if self.gen <= 5 then
                    self.effectState.duration = 0
                end
                self:add(
                    "-weather",
                    "RainDance",
                    "[from] ability: " .. tostring(effect),
                    "[of] " .. tostring(source)
                )
            else
                self:add("-weather", "RainDance")
            end
        end,
        onFieldResidualOrder = 1,
        onFieldResidual = function(self)
            self:add("-weather", "RainDance", "[upkeep]")
            self:eachEvent("Weather")
        end,
        onFieldEnd = function(self)
            self:add("-weather", "none")
        end
    },
    primordialsea = {
        name = "PrimordialSea",
        effectType = "Weather",
        duration = 0,
        onTryMovePriority = 1,
        onTryMove = function(self, attacker, defender, move)
            if (move.type == "Fire") and (move.category ~= "Status") then
                self:debug("Primordial Sea fire suppress")
                self:add("-fail", attacker, move, "[from] Primordial Sea")
                self:attrLastMove("[still]")
                return nil
            end
        end,
        onWeatherModifyDamage = function(self, damage, attacker, defender, move)
            if defender:hasItem("utilityumbrella") then
                return
            end
            if move.type == "Water" then
                self:debug("Rain water boost")
                return self:chainModify(1.5)
            end
        end,
        onFieldStart = function(self, field, source, effect)
            self:add(
                "-weather",
                "PrimordialSea",
                "[from] ability: " .. tostring(effect),
                "[of] " .. tostring(source)
            )
        end,
        onFieldResidualOrder = 1,
        onFieldResidual = function(self)
            self:add("-weather", "PrimordialSea", "[upkeep]")
            self:eachEvent("Weather")
        end,
        onFieldEnd = function(self)
            self:add("-weather", "none")
        end
    },
    sunnyday = {
        name = "SunnyDay",
        effectType = "Weather",
        duration = 5,
        durationCallback = function(self, source, effect)
            if source:hasItem("heatrock") then
                return 8
            end
            return 5
        end,
        onWeatherModifyDamage = function(self, damage, attacker, defender, move)
            if defender:hasItem("utilityumbrella") then
                return
            end
            if move.type == "Fire" then
                self:debug("Sunny Day fire boost")
                return self:chainModify(1.5)
            end
            if move.type == "Water" then
                self:debug("Sunny Day water suppress")
                return self:chainModify(0.5)
            end
        end,
        onFieldStart = function(self, battle, source, effect)
            if effect.effectType == "Ability" then
                if self.gen <= 5 then
                    self.effectState.duration = 0
                end
                self:add(
                    "-weather",
                    "SunnyDay",
                    "[from] ability: " .. tostring(effect),
                    "[of] " .. tostring(source)
                )
            else
                self:add("-weather", "SunnyDay")
            end
        end,
        onImmunity = function(self, ____type, pokemon)
            if pokemon:hasItem("utilityumbrella") then
                return
            end
            if ____type == "frz" then
                return false
            end
        end,
        onFieldResidualOrder = 1,
        onFieldResidual = function(self)
            self:add("-weather", "SunnyDay", "[upkeep]")
            self:eachEvent("Weather")
        end,
        onFieldEnd = function(self)
            self:add("-weather", "none")
        end
    },
    desolateland = {
        name = "DesolateLand",
        effectType = "Weather",
        duration = 0,
        onTryMovePriority = 1,
        onTryMove = function(self, attacker, defender, move)
            if (move.type == "Water") and (move.category ~= "Status") then
                self:debug("Desolate Land water suppress")
                self:add("-fail", attacker, move, "[from] Desolate Land")
                self:attrLastMove("[still]")
                return nil
            end
        end,
        onWeatherModifyDamage = function(self, damage, attacker, defender, move)
            if defender:hasItem("utilityumbrella") then
                return
            end
            if move.type == "Fire" then
                self:debug("Sunny Day fire boost")
                return self:chainModify(1.5)
            end
        end,
        onFieldStart = function(self, field, source, effect)
            self:add(
                "-weather",
                "DesolateLand",
                "[from] ability: " .. tostring(effect),
                "[of] " .. tostring(source)
            )
        end,
        onImmunity = function(self, ____type, pokemon)
            if pokemon:hasItem("utilityumbrella") then
                return
            end
            if ____type == "frz" then
                return false
            end
        end,
        onFieldResidualOrder = 1,
        onFieldResidual = function(self)
            self:add("-weather", "DesolateLand", "[upkeep]")
            self:eachEvent("Weather")
        end,
        onFieldEnd = function(self)
            self:add("-weather", "none")
        end
    },
    sandstorm = {
        name = "Sandstorm",
        effectType = "Weather",
        duration = 5,
        durationCallback = function(self, source, effect)
            if source:hasItem("smoothrock") then
                return 8
            end
            return 5
        end,
        onModifySpDPriority = 10,
        onModifySpD = function(self, spd, pokemon)
            if pokemon:hasType("Rock") and self.field:isWeather("sandstorm") then
                return self:modify(spd, 1.5)
            end
        end,
        onFieldStart = function(self, field, source, effect)
            if effect.effectType == "Ability" then
                if self.gen <= 5 then
                    self.effectState.duration = 0
                end
                self:add(
                    "-weather",
                    "Sandstorm",
                    "[from] ability: " .. tostring(effect),
                    "[of] " .. tostring(source)
                )
            else
                self:add("-weather", "Sandstorm")
            end
        end,
        onFieldResidualOrder = 1,
        onFieldResidual = function(self)
            self:add("-weather", "Sandstorm", "[upkeep]")
            if self.field:isWeather("sandstorm") then
                self:eachEvent("Weather")
            end
        end,
        onWeather = function(self, target)
            self:damage(target.baseMaxhp / 16)
        end,
        onFieldEnd = function(self)
            self:add("-weather", "none")
        end
    },
    hail = {
        name = "Hail",
        effectType = "Weather",
        duration = 5,
        durationCallback = function(self, source, effect)
            if source:hasItem("icyrock") then
                return 8
            end
            return 5
        end,
        onFieldStart = function(self, field, source, effect)
            if effect.effectType == "Ability" then
                if self.gen <= 5 then
                    self.effectState.duration = 0
                end
                self:add(
                    "-weather",
                    "Hail",
                    "[from] ability: " .. tostring(effect),
                    "[of] " .. tostring(source)
                )
            else
                self:add("-weather", "Hail")
            end
        end,
        onFieldResidualOrder = 1,
        onFieldResidual = function(self)
            self:add("-weather", "Hail", "[upkeep]")
            if self.field:isWeather("hail") then
                self:eachEvent("Weather")
            end
        end,
        onWeather = function(self, target)
            self:damage(target.baseMaxhp / 16)
        end,
        onFieldEnd = function(self)
            self:add("-weather", "none")
        end
    },
    deltastream = {
        name = "DeltaStream",
        effectType = "Weather",
        duration = 0,
        onEffectivenessPriority = -1,
        onEffectiveness = function(self, typeMod, target, ____type, move)
            if (((move and (move.effectType == "Move")) and (move.category ~= "Status")) and (____type == "Flying")) and (typeMod > 0) then
                self:add("-activate", "", "deltastream")
                return 0
            end
        end,
        onFieldStart = function(self, field, source, effect)
            self:add(
                "-weather",
                "DeltaStream",
                "[from] ability: " .. tostring(effect),
                "[of] " .. tostring(source)
            )
        end,
        onFieldResidualOrder = 1,
        onFieldResidual = function(self)
            self:add("-weather", "DeltaStream", "[upkeep]")
            self:eachEvent("Weather")
        end,
        onFieldEnd = function(self)
            self:add("-weather", "none")
        end
    },
    dynamax = {
        name = "Dynamax",
        noCopy = true,
        duration = 3,
        onStart = function(self, pokemon)
            pokemon:removeVolatile("minimize")
            pokemon:removeVolatile("substitute")
            if pokemon.volatiles.torment then
                __TS__Delete(pokemon.volatiles, "torment")
                self:add("-end", pokemon, "Torment", "[silent]")
            end
            if ({"cramorantgulping", "cramorantgorging"}):includes(pokemon.species.id) and (not pokemon.transformed) then
                pokemon:formeChange("cramorant")
            end
            self:add("-start", pokemon, "Dynamax")
            if pokemon.gigantamax then
                self:add(
                    "-formechange",
                    pokemon,
                    tostring(pokemon.species.name) .. "-Gmax"
                )
            end
            if pokemon.baseSpecies.name == "Shedinja" then
                return
            end
            local ratio = 2
            pokemon.maxhp = math.floor(pokemon.maxhp * ratio)
            pokemon.hp = math.floor(pokemon.hp * ratio)
            self:add("-heal", pokemon, pokemon.getHealth, "[silent]")
        end,
        onTryAddVolatile = function(self, status, pokemon)
            if status.id == "flinch" then
                return nil
            end
        end,
        onBeforeSwitchOutPriority = -1,
        onBeforeSwitchOut = function(self, pokemon)
            pokemon:removeVolatile("dynamax")
        end,
        onSourceModifyDamage = function(self, damage, source, target, move)
            if ((move.id == "behemothbash") or (move.id == "behemothblade")) or (move.id == "dynamaxcannon") then
                return self:chainModify(2)
            end
        end,
        onDragOutPriority = 2,
        onDragOut = function(self, pokemon)
            self:add("-block", pokemon, "Dynamax")
            return nil
        end,
        onResidualPriority = -100,
        onEnd = function(self, pokemon)
            self:add("-end", pokemon, "Dynamax")
            if pokemon.gigantamax then
                self:add("-formechange", pokemon, pokemon.species.name)
            end
            if pokemon.baseSpecies.name == "Shedinja" then
                return
            end
            pokemon.hp = pokemon:getUndynamaxedHP()
            pokemon.maxhp = pokemon.baseMaxhp
            self:add("-heal", pokemon, pokemon.getHealth, "[silent]")
        end
    },
    arceus = {
        name = "Arceus",
        onTypePriority = 1,
        onType = function(self, types, pokemon)
            if pokemon.transformed or ((pokemon.ability ~= "multitype") and (self.gen >= 8)) then
                return types
            end
            local ____type = "Normal"
            if pokemon.ability == "multitype" then
                ____type = pokemon:getItem().onPlate
                if not ____type then
                    ____type = "Normal"
                end
            end
            return {____type}
        end
    },
    silvally = {
        name = "Silvally",
        onTypePriority = 1,
        onType = function(self, types, pokemon)
            if pokemon.transformed or ((pokemon.ability ~= "rkssystem") and (self.gen >= 8)) then
                return types
            end
            local ____type = "Normal"
            if pokemon.ability == "rkssystem" then
                ____type = pokemon:getItem().onMemory
                if not ____type then
                    ____type = "Normal"
                end
            end
            return {____type}
        end
    }
}

return ____exports
