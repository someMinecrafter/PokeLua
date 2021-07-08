--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");

local ____exports = {}

____exports.Moves = {
    ["10000000voltthunderbolt"] = {num = 719, accuracy = true, basePower = 195, category = "Special", isNonstandard = "Past", name = "10,000,000 Volt Thunderbolt", pp = 1, priority = 0, flags = {}, isZ = "pikashuniumz", critRatio = 3, secondary = nil, target = "normal", type = "Electric", contestType = "Cool"},
    absorb = {num = 71, accuracy = 100, basePower = 20, category = "Special", name = "Absorb", pp = 25, priority = 0, flags = {protect = 1, mirror = 1, heal = 1}, drain = {1, 2}, secondary = nil, target = "normal", type = "Grass", contestType = "Clever"},
    accelerock = {num = 709, accuracy = 100, basePower = 40, category = "Physical", name = "Accelerock", pp = 20, priority = 1, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Rock", contestType = "Cool"},
    acid = {num = 51, accuracy = 100, basePower = 40, category = "Special", name = "Acid", pp = 30, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, boosts = {spd = -1}}, target = "allAdjacentFoes", type = "Poison", contestType = "Clever"},
    acidarmor = {num = 151, accuracy = true, basePower = 0, category = "Status", name = "Acid Armor", pp = 20, priority = 0, flags = {snatch = 1}, boosts = {def = 2}, secondary = nil, target = "self", type = "Poison", zMove = {effect = "clearnegativeboost"}, contestType = "Tough"},
    aciddownpour = {num = 628, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Acid Downpour", pp = 1, priority = 0, flags = {}, isZ = "poisoniumz", secondary = nil, target = "normal", type = "Poison", contestType = "Cool"},
    acidspray = {num = 491, accuracy = 100, basePower = 40, category = "Special", name = "Acid Spray", pp = 20, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {spd = -2}}, target = "normal", type = "Poison", contestType = "Beautiful"},
    acrobatics = {
        num = 512,
        accuracy = 100,
        basePower = 55,
        basePowerCallback = function(self, pokemon, target, move)
            if not pokemon.item then
                self:debug("Power doubled for no item")
                return move.basePower * 2
            end
            return move.basePower
        end,
        category = "Physical",
        name = "Acrobatics",
        pp = 15,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1, distance = 1},
        secondary = nil,
        target = "any",
        type = "Flying",
        contestType = "Cool"
    },
    acupressure = {
        num = 367,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Acupressure",
        pp = 30,
        priority = 0,
        flags = {},
        onHit = function(self, target)
            local stats = {}
            local stat
            for ____value in pairs(target.boosts) do
                stat = ____value
                if target.boosts[stat] < 6 then
                    __TS__ArrayPush(stats, stat)
                end
            end
            if #stats then
                local randomStat = self:sample(stats)
                local boost = {}
                boost[randomStat] = 2
                self:boost(boost)
            else
                return false
            end
        end,
        secondary = nil,
        target = "adjacentAllyOrSelf",
        type = "Normal",
        zMove = {effect = "crit2"},
        contestType = "Tough"
    },
    aerialace = {num = 332, accuracy = true, basePower = 60, category = "Physical", name = "Aerial Ace", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, distance = 1}, secondary = nil, target = "any", type = "Flying", contestType = "Cool"},
    aeroblast = {num = 177, accuracy = 95, basePower = 100, category = "Special", name = "Aeroblast", pp = 5, priority = 0, flags = {protect = 1, mirror = 1, distance = 1}, critRatio = 2, secondary = nil, target = "any", type = "Flying", contestType = "Cool"},
    afteryou = {
        num = 495,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "After You",
        pp = 15,
        priority = 0,
        flags = {authentic = 1, mystery = 1},
        onHit = function(self, target)
            if target.side.active.length < 2 then
                return false
            end
            local action = self.queue:willMove(target)
            if action then
                self.queue:prioritizeAction(action)
                self:add("-activate", target, "move: After You")
            else
                return false
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {spe = 1}},
        contestType = "Cute"
    },
    agility = {num = 97, accuracy = true, basePower = 0, category = "Status", name = "Agility", pp = 30, priority = 0, flags = {snatch = 1}, boosts = {spe = 2}, secondary = nil, target = "self", type = "Psychic", zMove = {effect = "clearnegativeboost"}, contestType = "Cool"},
    aircutter = {num = 314, accuracy = 95, basePower = 60, category = "Special", name = "Air Cutter", pp = 25, priority = 0, flags = {protect = 1, mirror = 1}, critRatio = 2, secondary = nil, target = "allAdjacentFoes", type = "Flying", contestType = "Cool"},
    airslash = {num = 403, accuracy = 95, basePower = 75, category = "Special", name = "Air Slash", pp = 15, priority = 0, flags = {protect = 1, mirror = 1, distance = 1}, secondary = {chance = 30, volatileStatus = "flinch"}, target = "any", type = "Flying", contestType = "Cool"},
    alloutpummeling = {num = 624, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "All-Out Pummeling", pp = 1, priority = 0, flags = {}, isZ = "fightiniumz", secondary = nil, target = "normal", type = "Fighting", contestType = "Cool"},
    allyswitch = {
        num = 502,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Ally Switch",
        pp = 15,
        priority = 2,
        flags = {},
        onTryHit = function(self, source)
            if source.side.active.length == 1 then
                return false
            end
            if (source.side.active.length == 3) and (source.position == 1) then
                return false
            end
        end,
        onHit = function(self, pokemon)
            local newPosition = (((pokemon.position == 0) and (function() return pokemon.side.active.length - 1 end)) or (function() return 0 end))()
            if not pokemon.side.active[newPosition] then
                return false
            end
            if pokemon.side.active[newPosition].fainted then
                return false
            end
            self:swapPosition(pokemon, newPosition, "[from] move: Ally Switch")
        end,
        secondary = nil,
        target = "self",
        type = "Psychic",
        zMove = {boost = {spe = 2}},
        contestType = "Clever"
    },
    amnesia = {num = 133, accuracy = true, basePower = 0, category = "Status", name = "Amnesia", pp = 20, priority = 0, flags = {snatch = 1}, boosts = {spd = 2}, secondary = nil, target = "self", type = "Psychic", zMove = {effect = "clearnegativeboost"}, contestType = "Cute"},
    anchorshot = {
        num = 677,
        accuracy = 100,
        basePower = 80,
        category = "Physical",
        name = "Anchor Shot",
        pp = 20,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = {
            chance = 100,
            onHit = function(self, target, source, move)
                if source.isActive then
                    target:addVolatile("trapped", source, move, "trapper")
                end
            end
        },
        target = "normal",
        type = "Steel",
        contestType = "Tough"
    },
    ancientpower = {num = 246, accuracy = 100, basePower = 60, category = "Special", name = "Ancient Power", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, self = {boosts = {atk = 1, def = 1, spa = 1, spd = 1, spe = 1}}}, target = "normal", type = "Rock", contestType = "Tough"},
    appleacid = {num = 787, accuracy = 100, basePower = 80, category = "Special", name = "Apple Acid", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {spd = -1}}, target = "normal", type = "Grass"},
    aquajet = {num = 453, accuracy = 100, basePower = 40, category = "Physical", name = "Aqua Jet", pp = 20, priority = 1, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Water", contestType = "Cool"},
    aquaring = {
        num = 392,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Aqua Ring",
        pp = 20,
        priority = 0,
        flags = {snatch = 1},
        volatileStatus = "aquaring",
        condition = {
            onStart = function(self, pokemon)
                self:add("-start", pokemon, "Aqua Ring")
            end,
            onResidualOrder = 6,
            onResidual = function(self, pokemon)
                self:heal(pokemon.baseMaxhp / 16)
            end
        },
        secondary = nil,
        target = "self",
        type = "Water",
        zMove = {boost = {def = 1}},
        contestType = "Beautiful"
    },
    aquatail = {num = 401, accuracy = 90, basePower = 90, category = "Physical", name = "Aqua Tail", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Water", contestType = "Beautiful"},
    armthrust = {num = 292, accuracy = 100, basePower = 15, category = "Physical", name = "Arm Thrust", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, multihit = {2, 5}, secondary = nil, target = "normal", type = "Fighting", contestType = "Tough"},
    aromatherapy = {
        num = 312,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Aromatherapy",
        pp = 5,
        priority = 0,
        flags = {snatch = 1, distance = 1},
        onHit = function(self, pokemon, source, move)
            self:add("-activate", source, "move: Aromatherapy")
            local success = false
            for ____, ally in __TS__Iterator(pokemon.side.pokemon) do
                do
                    if (ally ~= source) and (ally:hasAbility("sapsipper") or (ally.volatiles.substitute and (not move.infiltrates))) then
                        goto __continue24
                    end
                    if ally:cureStatus() then
                        success = true
                    end
                end
                ::__continue24::
            end
            return success
        end,
        target = "allyTeam",
        type = "Grass",
        zMove = {effect = "heal"},
        contestType = "Clever"
    },
    aromaticmist = {num = 597, accuracy = true, basePower = 0, category = "Status", name = "Aromatic Mist", pp = 20, priority = 0, flags = {authentic = 1}, boosts = {spd = 1}, secondary = nil, target = "adjacentAlly", type = "Fairy", zMove = {boost = {spd = 2}}, contestType = "Beautiful"},
    assist = {
        num = 274,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Assist",
        pp = 20,
        priority = 0,
        flags = {},
        onHit = function(self, target)
            local noAssist = {"assist", "banefulbunker", "beakblast", "belch", "bestow", "bounce", "celebrate", "chatter", "circlethrow", "copycat", "counter", "covet", "destinybond", "detect", "dig", "dive", "dragontail", "endure", "feint", "fly", "focuspunch", "followme", "helpinghand", "holdhands", "kingsshield", "matblock", "mefirst", "metronome", "mimic", "mirrorcoat", "mirrormove", "naturepower", "phantomforce", "protect", "ragepowder", "roar", "shadowforce", "shelltrap", "sketch", "skydrop", "sleeptalk", "snatch", "spikyshield", "spotlight", "struggle", "switcheroo", "thief", "transform", "trick", "whirlwind"}
            local moves = {}
            for ____, pokemon in __TS__Iterator(target.side.pokemon) do
                do
                    if pokemon == target then
                        goto __continue28
                    end
                    for ____, moveSlot in __TS__Iterator(pokemon.moveSlots) do
                        do
                            local moveid = moveSlot.id
                            if noAssist:includes(moveid) then
                                goto __continue30
                            end
                            local move = self.dex.moves:get(moveid)
                            if move.isZ or move.isMax then
                                goto __continue30
                            end
                            __TS__ArrayPush(moves, moveid)
                        end
                        ::__continue30::
                    end
                end
                ::__continue28::
            end
            local randomMove = ""
            if #moves then
                randomMove = self:sample(moves)
            end
            if not randomMove then
                return false
            end
            self.actions:useMove(randomMove, target)
        end,
        secondary = nil,
        target = "self",
        type = "Normal",
        contestType = "Cute"
    },
    assurance = {
        num = 372,
        accuracy = 100,
        basePower = 60,
        basePowerCallback = function(self, pokemon, target, move)
            if target.hurtThisTurn then
                self:debug("Boosted for being damaged this turn")
                return move.basePower * 2
            end
            return move.basePower
        end,
        category = "Physical",
        name = "Assurance",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Dark",
        contestType = "Clever"
    },
    astonish = {num = 310, accuracy = 100, basePower = 30, category = "Physical", name = "Astonish", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 30, volatileStatus = "flinch"}, target = "normal", type = "Ghost", contestType = "Cute"},
    astralbarrage = {num = 825, accuracy = 100, basePower = 120, category = "Special", name = "Astral Barrage", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "allAdjacentFoes", type = "Ghost"},
    attackorder = {num = 454, accuracy = 100, basePower = 90, category = "Physical", name = "Attack Order", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, critRatio = 2, secondary = nil, target = "normal", type = "Bug", contestType = "Clever"},
    attract = {
        num = 213,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Attract",
        pp = 15,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, authentic = 1},
        volatileStatus = "attract",
        condition = {
            noCopy = true,
            onStart = function(self, pokemon, source, effect)
                if (not ((pokemon.gender == "M") and (source.gender == "F"))) and (not ((pokemon.gender == "F") and (source.gender == "M"))) then
                    self:debug("incompatible gender")
                    return false
                end
                if not self:runEvent("Attract", pokemon, source) then
                    self:debug("Attract event failed")
                    return false
                end
                if effect.id == "cutecharm" then
                    self:add(
                        "-start",
                        pokemon,
                        "Attract",
                        "[from] ability: Cute Charm",
                        "[of] " .. tostring(source)
                    )
                elseif effect.id == "destinyknot" then
                    self:add(
                        "-start",
                        pokemon,
                        "Attract",
                        "[from] item: Destiny Knot",
                        "[of] " .. tostring(source)
                    )
                else
                    self:add("-start", pokemon, "Attract")
                end
            end,
            onUpdate = function(self, pokemon)
                if (self.effectState.source and (not self.effectState.source.isActive)) and pokemon.volatiles.attract then
                    self:debug(
                        "Removing Attract volatile on " .. tostring(pokemon)
                    )
                    pokemon:removeVolatile("attract")
                end
            end,
            onBeforeMovePriority = 2,
            onBeforeMove = function(self, pokemon, target, move)
                self:add(
                    "-activate",
                    pokemon,
                    "move: Attract",
                    "[of] " .. tostring(self.effectState.source)
                )
                if self:randomChance(1, 2) then
                    self:add("cant", pokemon, "Attract")
                    return false
                end
            end,
            onEnd = function(self, pokemon)
                self:add("-end", pokemon, "Attract", "[silent]")
            end
        },
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Cute"
    },
    aurasphere = {num = 396, accuracy = true, basePower = 80, category = "Special", name = "Aura Sphere", pp = 20, priority = 0, flags = {bullet = 1, protect = 1, pulse = 1, mirror = 1, distance = 1}, secondary = nil, target = "any", type = "Fighting", contestType = "Beautiful"},
    aurawheel = {
        num = 783,
        accuracy = 100,
        basePower = 110,
        category = "Physical",
        name = "Aura Wheel",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        secondary = {chance = 100, self = {boosts = {spe = 1}}},
        onTry = function(self, source)
            if source.species.baseSpecies == "Morpeko" then
                return
            end
            self:attrLastMove("[still]")
            self:add("-fail", source, "move: Aura Wheel")
            self:hint("Only a Pokemon whose form is Morpeko or Morpeko-Hangry can use this move.")
            return nil
        end,
        onModifyType = function(self, move, pokemon)
            if pokemon.species.name == "Morpeko-Hangry" then
                move.type = "Dark"
            else
                move.type = "Electric"
            end
        end,
        target = "normal",
        type = "Electric"
    },
    aurorabeam = {num = 62, accuracy = 100, basePower = 65, category = "Special", name = "Aurora Beam", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, boosts = {atk = -1}}, target = "normal", type = "Ice", contestType = "Beautiful"},
    auroraveil = {
        num = 694,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Aurora Veil",
        pp = 20,
        priority = 0,
        flags = {snatch = 1},
        sideCondition = "auroraveil",
        onTry = function(self)
            return self.field:isWeather("hail")
        end,
        condition = {
            duration = 5,
            durationCallback = function(self, target, source, effect)
                if source:hasItem("lightclay") then
                    return 8
                end
                return 5
            end,
            onAnyModifyDamage = function(self, damage, source, target, move)
                if (target ~= source) and self.effectState.target:hasAlly(target) then
                    if (target.side:getSideCondition("reflect") and (self:getCategory(move) == "Physical")) or (target.side:getSideCondition("lightscreen") and (self:getCategory(move) == "Special")) then
                        return
                    end
                    if (not target:getMoveHitData(move).crit) and (not move.infiltrates) then
                        self:debug("Aurora Veil weaken")
                        if self.activePerHalf > 1 then
                            return self:chainModify({2732, 4096})
                        end
                        return self:chainModify(0.5)
                    end
                end
            end,
            onSideStart = function(self, side)
                self:add("-sidestart", side, "move: Aurora Veil")
            end,
            onSideResidualOrder = 26,
            onSideResidualSubOrder = 10,
            onSideEnd = function(self, side)
                self:add("-sideend", side, "move: Aurora Veil")
            end
        },
        secondary = nil,
        target = "allySide",
        type = "Ice",
        zMove = {boost = {spe = 1}},
        contestType = "Beautiful"
    },
    autotomize = {
        num = 475,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Autotomize",
        pp = 15,
        priority = 0,
        flags = {snatch = 1},
        onTryHit = function(self, pokemon)
            local hasContrary = pokemon:hasAbility("contrary")
            if ((not hasContrary) and (pokemon.boosts.spe == 6)) or (hasContrary and (pokemon.boosts.spe == -6)) then
                return false
            end
        end,
        boosts = {spe = 2},
        onHit = function(self, pokemon)
            if pokemon.weighthg > 1 then
                pokemon.weighthg = math.max(1, pokemon.weighthg - 1000)
                self:add("-start", pokemon, "Autotomize")
            end
        end,
        secondary = nil,
        target = "self",
        type = "Steel",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Beautiful"
    },
    avalanche = {
        num = 419,
        accuracy = 100,
        basePower = 60,
        basePowerCallback = function(self, pokemon, target, move)
            local damagedByTarget = pokemon.attackedBy:some(
                function(____, p) return ((p.source == target) and (p.damage > 0)) and p.thisTurn end
            )
            if damagedByTarget then
                self:debug(
                    "Boosted for getting hit by " .. tostring(target)
                )
                return move.basePower * 2
            end
            return move.basePower
        end,
        category = "Physical",
        name = "Avalanche",
        pp = 10,
        priority = -4,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Ice",
        contestType = "Beautiful"
    },
    babydolleyes = {num = 608, accuracy = 100, basePower = 0, category = "Status", name = "Baby-Doll Eyes", pp = 30, priority = 1, flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1}, boosts = {atk = -1}, secondary = nil, target = "normal", type = "Fairy", zMove = {boost = {def = 1}}, contestType = "Cute"},
    baddybad = {num = 737, accuracy = 95, basePower = 80, category = "Special", isNonstandard = "LGPE", name = "Baddy Bad", pp = 15, priority = 0, flags = {protect = 1}, self = {sideCondition = "reflect"}, secondary = nil, target = "normal", type = "Dark", contestType = "Clever"},
    banefulbunker = {
        num = 661,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Baneful Bunker",
        pp = 10,
        priority = 4,
        flags = {},
        stallingMove = true,
        volatileStatus = "banefulbunker",
        onPrepareHit = function(self, pokemon)
            return (not (not self.queue:willAct())) and self:runEvent("StallMove", pokemon)
        end,
        onHit = function(self, pokemon)
            pokemon:addVolatile("stall")
        end,
        condition = {
            duration = 1,
            onStart = function(self, target)
                self:add("-singleturn", target, "move: Protect")
            end,
            onTryHitPriority = 3,
            onTryHit = function(self, target, source, move)
                if not move.flags.protect then
                    if ({"gmaxoneblow", "gmaxrapidflow"}):includes(move.id) then
                        return
                    end
                    if move.isZ or move.isMax then
                        target:getMoveHitData(move).zBrokeProtect = true
                    end
                    return
                end
                if move.smartTarget then
                    move.smartTarget = false
                else
                    self:add("-activate", target, "move: Protect")
                end
                local lockedmove = source:getVolatile("lockedmove")
                if lockedmove then
                    if source.volatiles.lockedmove.duration == 2 then
                        __TS__Delete(source.volatiles, "lockedmove")
                    end
                end
                if self:checkMoveMakesContact(move, source, target) then
                    source:trySetStatus("psn", target)
                end
                return self.NOT_FAIL
            end,
            onHit = function(self, target, source, move)
                if move.isZOrMaxPowered and self:checkMoveMakesContact(move, source, target) then
                    source:trySetStatus("psn", target)
                end
            end
        },
        secondary = nil,
        target = "self",
        type = "Poison",
        zMove = {boost = {def = 1}},
        contestType = "Tough"
    },
    barrage = {num = 140, accuracy = 85, basePower = 15, category = "Physical", isNonstandard = "Past", name = "Barrage", pp = 20, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, multihit = {2, 5}, secondary = nil, target = "normal", type = "Normal", contestType = "Cute"},
    barrier = {num = 112, accuracy = true, basePower = 0, category = "Status", isNonstandard = "Past", name = "Barrier", pp = 20, priority = 0, flags = {snatch = 1}, boosts = {def = 2}, secondary = nil, target = "self", type = "Psychic", zMove = {effect = "clearnegativeboost"}, contestType = "Cool"},
    batonpass = {
        num = 226,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Baton Pass",
        pp = 40,
        priority = 0,
        flags = {},
        self = {
            onHit = function(self, source)
                source.skipBeforeSwitchOutEventFlag = true
            end
        },
        selfSwitch = "copyvolatile",
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Cute"
    },
    beakblast = {
        num = 690,
        accuracy = 100,
        basePower = 100,
        category = "Physical",
        isNonstandard = "Past",
        name = "Beak Blast",
        pp = 15,
        priority = -3,
        flags = {bullet = 1, protect = 1},
        beforeTurnCallback = function(self, pokemon)
            pokemon:addVolatile("beakblast")
        end,
        condition = {
            duration = 1,
            onStart = function(self, pokemon)
                self:add("-singleturn", pokemon, "move: Beak Blast")
            end,
            onHit = function(self, target, source, move)
                if self:checkMoveMakesContact(move, source, target) then
                    source:trySetStatus("brn", target)
                end
            end
        },
        onAfterMove = function(self, pokemon)
            pokemon:removeVolatile("beakblast")
        end,
        secondary = nil,
        target = "normal",
        type = "Flying",
        contestType = "Tough"
    },
    beatup = {
        num = 251,
        accuracy = 100,
        basePower = 0,
        basePowerCallback = function(self, pokemon, target, move)
            return 5 + math.floor(
                move.allies:shift().species.baseStats.atk / 10
            )
        end,
        category = "Physical",
        name = "Beat Up",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, mystery = 1},
        onModifyMove = function(self, move, pokemon)
            move.allies = pokemon.side.pokemon:filter(
                function(____, ally) return (ally == pokemon) or ((not ally.fainted) and (not ally.status)) end
            )
            move.multihit = move.allies.length
        end,
        secondary = nil,
        target = "normal",
        type = "Dark",
        contestType = "Clever"
    },
    behemothbash = {num = 782, accuracy = 100, basePower = 100, category = "Physical", name = "Behemoth Bash", pp = 5, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Steel"},
    behemothblade = {num = 781, accuracy = 100, basePower = 100, category = "Physical", name = "Behemoth Blade", pp = 5, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Steel"},
    belch = {num = 562, accuracy = 90, basePower = 120, category = "Special", name = "Belch", pp = 10, priority = 0, flags = {protect = 1}, secondary = nil, target = "normal", type = "Poison", contestType = "Tough"},
    bellydrum = {
        num = 187,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Belly Drum",
        pp = 10,
        priority = 0,
        flags = {snatch = 1},
        onHit = function(self, target)
            if ((target.hp <= (target.maxhp / 2)) or (target.boosts.atk >= 6)) or (target.maxhp == 1) then
                return false
            end
            self:directDamage(target.maxhp / 2)
            self:boost({atk = 12}, target)
        end,
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {effect = "heal"},
        contestType = "Cute"
    },
    bestow = {
        num = 516,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Bestow",
        pp = 15,
        priority = 0,
        flags = {mirror = 1, authentic = 1, mystery = 1},
        onHit = function(self, target, source, move)
            if target.item then
                return false
            end
            local myItem = source:takeItem()
            if not myItem then
                return false
            end
            if (not self:singleEvent("TakeItem", myItem, source.itemState, target, source, move, myItem)) or (not target:setItem(myItem)) then
                source.item = myItem.id
                return false
            end
            self:add(
                "-item",
                target,
                myItem.name,
                "[from] move: Bestow",
                "[of] " .. tostring(source)
            )
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {spe = 2}},
        contestType = "Cute"
    },
    bide = {
        num = 117,
        accuracy = true,
        basePower = 0,
        category = "Physical",
        isNonstandard = "Past",
        name = "Bide",
        pp = 10,
        priority = 1,
        flags = {contact = 1, protect = 1},
        volatileStatus = "bide",
        ignoreImmunity = true,
        beforeMoveCallback = function(self, pokemon)
            if pokemon.volatiles.bide then
                return true
            end
        end,
        condition = {
            duration = 3,
            onLockMove = "bide",
            onStart = function(self, pokemon)
                self.effectState.totalDamage = 0
                self:add("-start", pokemon, "move: Bide")
            end,
            onDamagePriority = -101,
            onDamage = function(self, damage, target, source, move)
                if ((not move) or (move.effectType ~= "Move")) or (not source) then
                    return
                end
                local ____obj, ____index = self.effectState, "totalDamage"
                ____obj[____index] = ____obj[____index] + damage
                self.effectState.lastDamageSource = source
            end,
            onBeforeMove = function(self, pokemon, target, move)
                if self.effectState.duration == 1 then
                    self:add("-end", pokemon, "move: Bide")
                    target = self.effectState.lastDamageSource
                    if (not target) or (not self.effectState.totalDamage) then
                        self:attrLastMove("[still]")
                        self:add("-fail", pokemon)
                        return false
                    end
                    if not target.isActive then
                        local possibleTarget = self:getRandomTarget(
                            pokemon,
                            self.dex.moves:get("pound")
                        )
                        if not possibleTarget then
                            self:add("-miss", pokemon)
                            return false
                        end
                        target = possibleTarget
                    end
                    local moveData = {id = "bide", name = "Bide", accuracy = true, damage = self.effectState.totalDamage * 2, category = "Physical", priority = 1, flags = {contact = 1, protect = 1}, effectType = "Move", type = "Normal"}
                    self.actions:tryMoveHit(target, pokemon, moveData)
                    pokemon:removeVolatile("bide")
                    return false
                end
                self:add("-activate", pokemon, "move: Bide")
            end,
            onMoveAborted = function(self, pokemon)
                pokemon:removeVolatile("bide")
            end,
            onEnd = function(self, pokemon)
                self:add("-end", pokemon, "move: Bide", "[silent]")
            end
        },
        secondary = nil,
        target = "self",
        type = "Normal",
        contestType = "Tough"
    },
    bind = {num = 20, accuracy = 85, basePower = 15, category = "Physical", name = "Bind", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, volatileStatus = "partiallytrapped", secondary = nil, target = "normal", type = "Normal", contestType = "Tough"},
    bite = {num = 44, accuracy = 100, basePower = 60, category = "Physical", name = "Bite", pp = 25, priority = 0, flags = {bite = 1, contact = 1, protect = 1, mirror = 1}, secondary = {chance = 30, volatileStatus = "flinch"}, target = "normal", type = "Dark", contestType = "Tough"},
    blackholeeclipse = {num = 654, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Black Hole Eclipse", pp = 1, priority = 0, flags = {}, isZ = "darkiniumz", secondary = nil, target = "normal", type = "Dark", contestType = "Cool"},
    blastburn = {num = 307, accuracy = 90, basePower = 150, category = "Special", name = "Blast Burn", pp = 5, priority = 0, flags = {recharge = 1, protect = 1, mirror = 1}, self = {volatileStatus = "mustrecharge"}, secondary = nil, target = "normal", type = "Fire", contestType = "Beautiful"},
    blazekick = {num = 299, accuracy = 90, basePower = 85, category = "Physical", name = "Blaze Kick", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, critRatio = 2, secondary = {chance = 10, status = "brn"}, target = "normal", type = "Fire", contestType = "Cool"},
    blizzard = {
        num = 59,
        accuracy = 70,
        basePower = 110,
        category = "Special",
        name = "Blizzard",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onModifyMove = function(self, move)
            if self.field:isWeather("hail") then
                move.accuracy = true
            end
        end,
        secondary = {chance = 10, status = "frz"},
        target = "allAdjacentFoes",
        type = "Ice",
        contestType = "Beautiful"
    },
    block = {
        num = 335,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Block",
        pp = 5,
        priority = 0,
        flags = {reflectable = 1, mirror = 1},
        onHit = function(self, target, source, move)
            return target:addVolatile("trapped", source, move, "trapper")
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {def = 1}},
        contestType = "Cute"
    },
    bloomdoom = {num = 644, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Bloom Doom", pp = 1, priority = 0, flags = {}, isZ = "grassiumz", secondary = nil, target = "normal", type = "Grass", contestType = "Cool"},
    blueflare = {num = 551, accuracy = 85, basePower = 130, category = "Special", name = "Blue Flare", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 20, status = "brn"}, target = "normal", type = "Fire", contestType = "Beautiful"},
    bodypress = {num = 776, accuracy = 100, basePower = 80, category = "Physical", name = "Body Press", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, useSourceDefensiveAsOffensive = true, secondary = nil, target = "normal", type = "Fighting"},
    bodyslam = {num = 34, accuracy = 100, basePower = 85, category = "Physical", name = "Body Slam", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, nonsky = 1}, secondary = {chance = 30, status = "par"}, target = "normal", type = "Normal", contestType = "Tough"},
    boltbeak = {
        num = 754,
        accuracy = 100,
        basePower = 85,
        basePowerCallback = function(self, pokemon, target, move)
            if target.newlySwitched or self.queue:willMove(target) then
                self:debug("Bolt Beak damage boost")
                return move.basePower * 2
            end
            self:debug("Bolt Beak NOT boosted")
            return move.basePower
        end,
        category = "Physical",
        name = "Bolt Beak",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Electric"
    },
    boltstrike = {num = 550, accuracy = 85, basePower = 130, category = "Physical", name = "Bolt Strike", pp = 5, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 20, status = "par"}, target = "normal", type = "Electric", contestType = "Beautiful"},
    boneclub = {num = 125, accuracy = 85, basePower = 65, category = "Physical", isNonstandard = "Past", name = "Bone Club", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, volatileStatus = "flinch"}, target = "normal", type = "Ground", contestType = "Tough"},
    bonemerang = {num = 155, accuracy = 90, basePower = 50, category = "Physical", name = "Bonemerang", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, multihit = 2, secondary = nil, target = "normal", type = "Ground", maxMove = {basePower = 130}, contestType = "Tough"},
    bonerush = {num = 198, accuracy = 90, basePower = 25, category = "Physical", name = "Bone Rush", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, multihit = {2, 5}, secondary = nil, target = "normal", type = "Ground", zMove = {basePower = 140}, maxMove = {basePower = 130}, contestType = "Tough"},
    boomburst = {num = 586, accuracy = 100, basePower = 140, category = "Special", name = "Boomburst", pp = 10, priority = 0, flags = {protect = 1, mirror = 1, sound = 1, authentic = 1}, secondary = nil, target = "allAdjacent", type = "Normal", contestType = "Tough"},
    bounce = {
        num = 340,
        accuracy = 85,
        basePower = 85,
        category = "Physical",
        name = "Bounce",
        pp = 5,
        priority = 0,
        flags = {contact = 1, charge = 1, protect = 1, mirror = 1, gravity = 1, distance = 1},
        onTryMove = function(self, attacker, defender, move)
            if attacker:removeVolatile(move.id) then
                return
            end
            self:add("-prepare", attacker, move.name)
            if not self:runEvent("ChargeMove", attacker, defender, move) then
                return
            end
            attacker:addVolatile("twoturnmove", defender)
            return nil
        end,
        condition = {
            duration = 2,
            onInvulnerability = function(self, target, source, move)
                if ({"gust", "twister", "skyuppercut", "thunder", "hurricane", "smackdown", "thousandarrows"}):includes(move.id) then
                    return
                end
                return false
            end,
            onSourceBasePower = function(self, basePower, target, source, move)
                if (move.id == "gust") or (move.id == "twister") then
                    return self:chainModify(2)
                end
            end
        },
        secondary = {chance = 30, status = "par"},
        target = "any",
        type = "Flying",
        contestType = "Cute"
    },
    bouncybubble = {num = 733, accuracy = 100, basePower = 60, category = "Special", isNonstandard = "LGPE", name = "Bouncy Bubble", pp = 20, priority = 0, flags = {protect = 1, heal = 1}, drain = {1, 2}, secondary = nil, target = "normal", type = "Water", contestType = "Clever"},
    branchpoke = {num = 785, accuracy = 100, basePower = 40, category = "Physical", name = "Branch Poke", pp = 40, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Grass"},
    bravebird = {num = 413, accuracy = 100, basePower = 120, category = "Physical", name = "Brave Bird", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, distance = 1}, recoil = {33, 100}, secondary = nil, target = "any", type = "Flying", contestType = "Cool"},
    breakingswipe = {num = 784, accuracy = 100, basePower = 60, category = "Physical", name = "Breaking Swipe", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {atk = -1}}, target = "allAdjacentFoes", type = "Dragon"},
    breakneckblitz = {num = 622, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Breakneck Blitz", pp = 1, priority = 0, flags = {}, isZ = "normaliumz", secondary = nil, target = "normal", type = "Normal", contestType = "Cool"},
    brickbreak = {
        num = 280,
        accuracy = 100,
        basePower = 75,
        category = "Physical",
        name = "Brick Break",
        pp = 15,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onTryHit = function(self, pokemon)
            pokemon.side:removeSideCondition("reflect")
            pokemon.side:removeSideCondition("lightscreen")
            pokemon.side:removeSideCondition("auroraveil")
        end,
        secondary = nil,
        target = "normal",
        type = "Fighting",
        contestType = "Cool"
    },
    brine = {
        num = 362,
        accuracy = 100,
        basePower = 65,
        category = "Special",
        name = "Brine",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onBasePower = function(self, basePower, pokemon, target)
            if (target.hp * 2) <= target.maxhp then
                return self:chainModify(2)
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Water",
        contestType = "Tough"
    },
    brutalswing = {num = 693, accuracy = 100, basePower = 60, category = "Physical", name = "Brutal Swing", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "allAdjacent", type = "Dark", contestType = "Tough"},
    bubble = {num = 145, accuracy = 100, basePower = 40, category = "Special", isNonstandard = "Past", name = "Bubble", pp = 30, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, boosts = {spe = -1}}, target = "allAdjacentFoes", type = "Water", contestType = "Cute"},
    bubblebeam = {num = 61, accuracy = 100, basePower = 65, category = "Special", name = "Bubble Beam", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, boosts = {spe = -1}}, target = "normal", type = "Water", contestType = "Beautiful"},
    bugbite = {
        num = 450,
        accuracy = 100,
        basePower = 60,
        category = "Physical",
        name = "Bug Bite",
        pp = 20,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onHit = function(self, target, source)
            local item = target:getItem()
            if (source.hp and item.isBerry) and target:takeItem(source) then
                self:add(
                    "-enditem",
                    target,
                    item.name,
                    "[from] stealeat",
                    "[move] Bug Bite",
                    "[of] " .. tostring(source)
                )
                if self:singleEvent("Eat", item, nil, source, nil, nil) then
                    self:runEvent("EatItem", source, nil, nil, item)
                    if item.id == "leppaberry" then
                        target.staleness = "external"
                    end
                end
                if item.onEat then
                    source.ateBerry = true
                end
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Bug",
        contestType = "Cute"
    },
    bugbuzz = {num = 405, accuracy = 100, basePower = 90, category = "Special", name = "Bug Buzz", pp = 10, priority = 0, flags = {protect = 1, mirror = 1, sound = 1, authentic = 1}, secondary = {chance = 10, boosts = {spd = -1}}, target = "normal", type = "Bug", contestType = "Beautiful"},
    bulkup = {num = 339, accuracy = true, basePower = 0, category = "Status", name = "Bulk Up", pp = 20, priority = 0, flags = {snatch = 1}, boosts = {atk = 1, def = 1}, secondary = nil, target = "self", type = "Fighting", zMove = {boost = {atk = 1}}, contestType = "Cool"},
    bulldoze = {num = 523, accuracy = 100, basePower = 60, category = "Physical", name = "Bulldoze", pp = 20, priority = 0, flags = {protect = 1, mirror = 1, nonsky = 1}, secondary = {chance = 100, boosts = {spe = -1}}, target = "allAdjacent", type = "Ground", contestType = "Tough"},
    bulletpunch = {num = 418, accuracy = 100, basePower = 40, category = "Physical", name = "Bullet Punch", pp = 30, priority = 1, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, secondary = nil, target = "normal", type = "Steel", contestType = "Tough"},
    bulletseed = {num = 331, accuracy = 100, basePower = 25, category = "Physical", name = "Bullet Seed", pp = 30, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, multihit = {2, 5}, secondary = nil, target = "normal", type = "Grass", zMove = {basePower = 140}, maxMove = {basePower = 130}, contestType = "Cool"},
    burningjealousy = {
        num = 807,
        accuracy = 100,
        basePower = 70,
        category = "Special",
        name = "Burning Jealousy",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        secondary = {
            chance = 100,
            onHit = function(self, target, source, move)
                if target.statsRaisedThisTurn then
                    target:trySetStatus("brn", source, move)
                end
            end
        },
        target = "allAdjacentFoes",
        type = "Fire",
        contestType = "Tough"
    },
    burnup = {
        num = 682,
        accuracy = 100,
        basePower = 130,
        category = "Special",
        name = "Burn Up",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1, defrost = 1},
        onTryMove = function(self, pokemon, target, move)
            if pokemon:hasType("Fire") then
                return
            end
            self:add("-fail", pokemon, "move: Burn Up")
            self:attrLastMove("[still]")
            return nil
        end,
        self = {
            onHit = function(self, pokemon)
                pokemon:setType(
                    pokemon:getTypes(true):map(
                        function(____, ____type) return ((____type == "Fire") and "???") or ____type end
                    )
                )
                self:add(
                    "-start",
                    pokemon,
                    "typechange",
                    pokemon.types:join("/"),
                    "[from] move: Burn Up"
                )
            end
        },
        secondary = nil,
        target = "normal",
        type = "Fire",
        contestType = "Clever"
    },
    buzzybuzz = {num = 734, accuracy = 100, basePower = 60, category = "Special", isNonstandard = "LGPE", name = "Buzzy Buzz", pp = 20, priority = 0, flags = {protect = 1}, secondary = {chance = 100, status = "par"}, target = "normal", type = "Electric", contestType = "Clever"},
    calmmind = {num = 347, accuracy = true, basePower = 0, category = "Status", name = "Calm Mind", pp = 20, priority = 0, flags = {snatch = 1}, boosts = {spa = 1, spd = 1}, secondary = nil, target = "self", type = "Psychic", zMove = {effect = "clearnegativeboost"}, contestType = "Clever"},
    camouflage = {
        num = 293,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Camouflage",
        pp = 20,
        priority = 0,
        flags = {snatch = 1},
        onHit = function(self, target)
            local newType = "Normal"
            if self.field:isTerrain("electricterrain") then
                newType = "Electric"
            elseif self.field:isTerrain("grassyterrain") then
                newType = "Grass"
            elseif self.field:isTerrain("mistyterrain") then
                newType = "Fairy"
            elseif self.field:isTerrain("psychicterrain") then
                newType = "Psychic"
            end
            if (target:getTypes():join() == newType) or (not target:setType(newType)) then
                return false
            end
            self:add("-start", target, "typechange", newType)
        end,
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {boost = {evasion = 1}},
        contestType = "Clever"
    },
    captivate = {
        num = 445,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Captivate",
        pp = 20,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1},
        onTryImmunity = function(self, pokemon, source)
            return ((pokemon.gender == "M") and (source.gender == "F")) or ((pokemon.gender == "F") and (source.gender == "M"))
        end,
        boosts = {spa = -2},
        secondary = nil,
        target = "allAdjacentFoes",
        type = "Normal",
        zMove = {boost = {spd = 2}},
        contestType = "Cute"
    },
    catastropika = {num = 658, accuracy = true, basePower = 210, category = "Physical", isNonstandard = "Past", name = "Catastropika", pp = 1, priority = 0, flags = {contact = 1}, isZ = "pikaniumz", secondary = nil, target = "normal", type = "Electric", contestType = "Cool"},
    celebrate = {
        num = 606,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Celebrate",
        pp = 40,
        priority = 0,
        flags = {},
        onTryHit = function(self, target, source)
            self:add("-activate", target, "move: Celebrate")
        end,
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {boost = {atk = 1, def = 1, spa = 1, spd = 1, spe = 1}},
        contestType = "Cute"
    },
    charge = {
        num = 268,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Charge",
        pp = 20,
        priority = 0,
        flags = {snatch = 1},
        volatileStatus = "charge",
        onHit = function(self, pokemon)
            self:add("-activate", pokemon, "move: Charge")
        end,
        condition = {
            duration = 2,
            onRestart = function(self, pokemon)
                self.effectState.duration = 2
            end,
            onBasePowerPriority = 9,
            onBasePower = function(self, basePower, attacker, defender, move)
                if move.type == "Electric" then
                    self:debug("charge boost")
                    return self:chainModify(2)
                end
            end
        },
        boosts = {spd = 1},
        secondary = nil,
        target = "self",
        type = "Electric",
        zMove = {boost = {spd = 1}},
        contestType = "Clever"
    },
    chargebeam = {num = 451, accuracy = 90, basePower = 50, category = "Special", name = "Charge Beam", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 70, self = {boosts = {spa = 1}}}, target = "normal", type = "Electric", contestType = "Beautiful"},
    charm = {num = 204, accuracy = 100, basePower = 0, category = "Status", name = "Charm", pp = 20, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1}, boosts = {atk = -2}, secondary = nil, target = "normal", type = "Fairy", zMove = {boost = {def = 1}}, contestType = "Cute"},
    chatter = {num = 448, accuracy = 100, basePower = 65, category = "Special", isNonstandard = "Past", name = "Chatter", pp = 20, priority = 0, flags = {protect = 1, mirror = 1, sound = 1, distance = 1, authentic = 1}, noSketch = true, secondary = {chance = 100, volatileStatus = "confusion"}, target = "any", type = "Flying", contestType = "Cute"},
    chipaway = {num = 498, accuracy = 100, basePower = 70, category = "Physical", isNonstandard = "Past", name = "Chip Away", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, ignoreDefensive = true, ignoreEvasion = true, secondary = nil, target = "normal", type = "Normal", contestType = "Tough"},
    circlethrow = {num = 509, accuracy = 90, basePower = 60, category = "Physical", name = "Circle Throw", pp = 10, priority = -6, flags = {contact = 1, protect = 1, mirror = 1}, forceSwitch = true, target = "normal", type = "Fighting", contestType = "Cool"},
    clamp = {num = 128, accuracy = 85, basePower = 35, category = "Physical", isNonstandard = "Past", name = "Clamp", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, volatileStatus = "partiallytrapped", secondary = nil, target = "normal", type = "Water", contestType = "Tough"},
    clangingscales = {num = 691, accuracy = 100, basePower = 110, category = "Special", name = "Clanging Scales", pp = 5, priority = 0, flags = {protect = 1, mirror = 1, sound = 1, authentic = 1}, selfBoost = {boosts = {def = -1}}, secondary = nil, target = "allAdjacentFoes", type = "Dragon", contestType = "Tough"},
    clangoroussoul = {
        num = 775,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Clangorous Soul",
        pp = 5,
        priority = 0,
        flags = {snatch = 1, sound = 1, dance = 1},
        onTry = function(self, source)
            if (source.hp <= ((source.maxhp * 33) / 100)) or (source.maxhp == 1) then
                return false
            end
        end,
        onTryHit = function(self, pokemon, target, move)
            if not self:boost(move.boosts) then
                return nil
            end
            __TS__Delete(move, "boosts")
        end,
        onHit = function(self, pokemon)
            self:directDamage((pokemon.maxhp * 33) / 100)
        end,
        boosts = {atk = 1, def = 1, spa = 1, spd = 1, spe = 1},
        secondary = nil,
        target = "self",
        type = "Dragon"
    },
    clangoroussoulblaze = {num = 728, accuracy = true, basePower = 185, category = "Special", isNonstandard = "Past", name = "Clangorous Soulblaze", pp = 1, priority = 0, flags = {sound = 1, authentic = 1}, selfBoost = {boosts = {atk = 1, def = 1, spa = 1, spd = 1, spe = 1}}, isZ = "kommoniumz", secondary = {}, target = "allAdjacentFoes", type = "Dragon", contestType = "Cool"},
    clearsmog = {
        num = 499,
        accuracy = true,
        basePower = 50,
        category = "Special",
        name = "Clear Smog",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onHit = function(self, target)
            target:clearBoosts()
            self:add("-clearboost", target)
        end,
        secondary = nil,
        target = "normal",
        type = "Poison",
        contestType = "Beautiful"
    },
    closecombat = {num = 370, accuracy = 100, basePower = 120, category = "Physical", name = "Close Combat", pp = 5, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, self = {boosts = {def = -1, spd = -1}}, secondary = nil, target = "normal", type = "Fighting", contestType = "Tough"},
    coaching = {num = 811, accuracy = true, basePower = 0, category = "Status", name = "Coaching", pp = 10, priority = 0, flags = {authentic = 1}, secondary = nil, boosts = {atk = 1, def = 1}, target = "adjacentAlly", type = "Fighting"},
    coil = {num = 489, accuracy = true, basePower = 0, category = "Status", name = "Coil", pp = 20, priority = 0, flags = {snatch = 1}, boosts = {atk = 1, def = 1, accuracy = 1}, secondary = nil, target = "self", type = "Poison", zMove = {effect = "clearnegativeboost"}, contestType = "Tough"},
    cometpunch = {num = 4, accuracy = 85, basePower = 18, category = "Physical", isNonstandard = "Past", name = "Comet Punch", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, multihit = {2, 5}, secondary = nil, target = "normal", type = "Normal", maxMove = {basePower = 100}, contestType = "Tough"},
    confide = {num = 590, accuracy = true, basePower = 0, category = "Status", name = "Confide", pp = 20, priority = 0, flags = {reflectable = 1, mirror = 1, sound = 1, authentic = 1}, boosts = {spa = -1}, secondary = nil, target = "normal", type = "Normal", zMove = {boost = {spd = 1}}, contestType = "Cute"},
    confuseray = {num = 109, accuracy = 100, basePower = 0, category = "Status", name = "Confuse Ray", pp = 10, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, volatileStatus = "confusion", secondary = nil, target = "normal", type = "Ghost", zMove = {boost = {spa = 1}}, contestType = "Clever"},
    confusion = {num = 93, accuracy = 100, basePower = 50, category = "Special", name = "Confusion", pp = 25, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, volatileStatus = "confusion"}, target = "normal", type = "Psychic", contestType = "Clever"},
    constrict = {num = 132, accuracy = 100, basePower = 10, category = "Physical", isNonstandard = "Past", name = "Constrict", pp = 35, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 10, boosts = {spe = -1}}, target = "normal", type = "Normal", contestType = "Tough"},
    continentalcrush = {num = 632, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Continental Crush", pp = 1, priority = 0, flags = {}, isZ = "rockiumz", secondary = nil, target = "normal", type = "Rock", contestType = "Cool"},
    conversion = {
        num = 160,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Conversion",
        pp = 30,
        priority = 0,
        flags = {snatch = 1},
        onHit = function(self, target)
            local ____type = self.dex.moves:get(target.moveSlots[0].id).type
            if target:hasType(____type) or (not target:setType(____type)) then
                return false
            end
            self:add("-start", target, "typechange", ____type)
        end,
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {boost = {atk = 1, def = 1, spa = 1, spd = 1, spe = 1}},
        contestType = "Beautiful"
    },
    conversion2 = {
        num = 176,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Conversion 2",
        pp = 30,
        priority = 0,
        flags = {authentic = 1},
        onHit = function(self, target, source)
            if not target.lastMoveUsed then
                return false
            end
            local possibleTypes = {}
            local attackType = target.lastMoveUsed.type
            for ____, ____type in __TS__Iterator(
                self.dex.types:names()
            ) do
                do
                    if source:hasType(____type) then
                        goto __continue159
                    end
                    local typeCheck = self.dex.types:get(____type).damageTaken[attackType]
                    if (typeCheck == 2) or (typeCheck == 3) then
                        __TS__ArrayPush(possibleTypes, ____type)
                    end
                end
                ::__continue159::
            end
            if not #possibleTypes then
                return false
            end
            local randomType = self:sample(possibleTypes)
            if not source:setType(randomType) then
                return false
            end
            self:add("-start", source, "typechange", randomType)
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {effect = "heal"},
        contestType = "Beautiful"
    },
    copycat = {
        num = 383,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Copycat",
        pp = 20,
        priority = 0,
        flags = {},
        onHit = function(self, pokemon)
            local noCopycat = {"assist", "banefulbunker", "beakblast", "behemothbash", "behemothblade", "belch", "bestow", "celebrate", "chatter", "circlethrow", "copycat", "counter", "covet", "craftyshield", "destinybond", "detect", "dragontail", "dynamaxcannon", "endure", "feint", "focuspunch", "followme", "helpinghand", "holdhands", "kingsshield", "matblock", "mefirst", "metronome", "mimic", "mirrorcoat", "mirrormove", "naturepower", "obstruct", "protect", "ragepowder", "roar", "shelltrap", "sketch", "sleeptalk", "snatch", "spikyshield", "spotlight", "struggle", "switcheroo", "thief", "transform", "trick", "whirlwind"}
            local move = self.lastMove
            if not move then
                return
            end
            if move.isMax and move.baseMove then
                move = self.dex.moves:get(move.baseMove)
            end
            if (noCopycat:includes(move.id) or move.isZ) or move.isMax then
                return false
            end
            self.actions:useMove(move.id, pokemon)
        end,
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {boost = {accuracy = 1}},
        contestType = "Cute"
    },
    coreenforcer = {
        num = 687,
        accuracy = 100,
        basePower = 100,
        category = "Special",
        name = "Core Enforcer",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onHit = function(self, target)
            if target:getAbility().isPermanent then
                return
            end
            if target.newlySwitched or self.queue:willMove(target) then
                return
            end
            target:addVolatile("gastroacid")
        end,
        onAfterSubDamage = function(self, damage, target)
            if target:getAbility().isPermanent then
                return
            end
            if target.newlySwitched or self.queue:willMove(target) then
                return
            end
            target:addVolatile("gastroacid")
        end,
        secondary = nil,
        target = "allAdjacentFoes",
        type = "Dragon",
        zMove = {basePower = 140},
        contestType = "Tough"
    },
    corkscrewcrash = {num = 638, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Corkscrew Crash", pp = 1, priority = 0, flags = {}, isZ = "steeliumz", secondary = nil, target = "normal", type = "Steel", contestType = "Cool"},
    corrosivegas = {
        num = 810,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Corrosive Gas",
        pp = 40,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1},
        onHit = function(self, target, source)
            local item = target:takeItem(source)
            if item then
                self:add(
                    "-enditem",
                    target,
                    item.name,
                    "[from] move: Corrosive Gas",
                    "[of] " .. tostring(source)
                )
            else
                self:add("-fail", target, "move: Corrosive Gas")
            end
        end,
        secondary = nil,
        target = "allAdjacent",
        type = "Poison"
    },
    cosmicpower = {num = 322, accuracy = true, basePower = 0, category = "Status", name = "Cosmic Power", pp = 20, priority = 0, flags = {snatch = 1}, boosts = {def = 1, spd = 1}, secondary = nil, target = "self", type = "Psychic", zMove = {boost = {spd = 1}}, contestType = "Beautiful"},
    cottonguard = {num = 538, accuracy = true, basePower = 0, category = "Status", name = "Cotton Guard", pp = 10, priority = 0, flags = {snatch = 1}, boosts = {def = 3}, secondary = nil, target = "self", type = "Grass", zMove = {effect = "clearnegativeboost"}, contestType = "Cute"},
    cottonspore = {num = 178, accuracy = 100, basePower = 0, category = "Status", name = "Cotton Spore", pp = 40, priority = 0, flags = {powder = 1, protect = 1, reflectable = 1, mirror = 1}, boosts = {spe = -2}, secondary = nil, target = "allAdjacentFoes", type = "Grass", zMove = {effect = "clearnegativeboost"}, contestType = "Beautiful"},
    counter = {
        num = 68,
        accuracy = 100,
        basePower = 0,
        damageCallback = function(self, pokemon)
            if not pokemon.volatiles.counter then
                return 0
            end
            return pokemon.volatiles.counter.damage or 1
        end,
        category = "Physical",
        name = "Counter",
        pp = 20,
        priority = -5,
        flags = {contact = 1, protect = 1},
        beforeTurnCallback = function(self, pokemon)
            pokemon:addVolatile("counter")
        end,
        onTryHit = function(self, target, source, move)
            if not source.volatiles.counter then
                return false
            end
            if source.volatiles.counter.slot == nil then
                return false
            end
        end,
        condition = {
            duration = 1,
            noCopy = true,
            onStart = function(self, target, source, move)
                self.effectState.slot = nil
                self.effectState.damage = 0
            end,
            onRedirectTargetPriority = -1,
            onRedirectTarget = function(self, target, source, source2, move)
                if move.id ~= "counter" then
                    return
                end
                if (source ~= self.effectState.target) or (not self.effectState.slot) then
                    return
                end
                return self:getAtSlot(self.effectState.slot)
            end,
            onDamagingHit = function(self, damage, target, source, move)
                if (not source:isAlly(target)) and (self:getCategory(move) == "Physical") then
                    self.effectState.slot = source:getSlot()
                    self.effectState.damage = 2 * damage
                end
            end
        },
        secondary = nil,
        target = "scripted",
        type = "Fighting",
        maxMove = {basePower = 75},
        contestType = "Tough"
    },
    courtchange = {
        num = 756,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Court Change",
        pp = 10,
        priority = 0,
        flags = {mirror = 1},
        onHitField = function(self, target, source)
            local sideConditions = {"mist", "lightscreen", "reflect", "spikes", "safeguard", "tailwind", "toxicspikes", "stealthrock", "waterpledge", "firepledge", "grasspledge", "stickyweb", "auroraveil", "gmaxsteelsurge", "gmaxcannonade", "gmaxvinelash", "gmaxwildfire"}
            local success = false
            if self.gameType == "freeforall" then
                local offset = self:random(3) + 1
                local sides = {self.sides[0], self.sides[2], self.sides[1], self.sides[3]}
                for ____, id in ipairs(sideConditions) do
                    do
                        local effectName = self.dex.conditions:get(id).name
                        local rotatedSides = {}
                        local someCondition = false
                        do
                            local i = 0
                            while i < 4 do
                                local sourceSide = sides[i + 1]
                                local targetSide = sides[((i + offset) % 4) + 1]
                                __TS__ArrayPush(rotatedSides, targetSide.sideConditions[id])
                                if sourceSide.sideConditions[id] then
                                    self:add("-sideend", sourceSide, effectName, "[silent]")
                                    someCondition = true
                                end
                                i = i + 1
                            end
                        end
                        if not someCondition then
                            goto __continue191
                        end
                        sides[1].sideConditions[id], sides[2].sideConditions[id], sides[3].sideConditions[id], sides[4].sideConditions[id] = __TS__Unpack(
                            {
                                __TS__Unpack(rotatedSides)
                            }
                        )
                        for ____, side in ipairs(sides) do
                            if side.sideConditions[id] then
                                local layers = side.sideConditions[id].layers or 1
                                do
                                    while layers > 0 do
                                        self:add("-sidestart", side, effectName, "[silent]")
                                        layers = layers - 1
                                    end
                                end
                            else
                                __TS__Delete(side.sideConditions, id)
                            end
                        end
                        success = true
                    end
                    ::__continue191::
                end
            else
                local sourceSide = source.side
                local targetSide = source.side.foe
                for ____, id in ipairs(sideConditions) do
                    do
                        local effectName = self.dex.conditions:get(id).name
                        if sourceSide.sideConditions[id] and targetSide.sideConditions[id] then
                            sourceSide.sideConditions[id], targetSide.sideConditions[id] = __TS__Unpack({targetSide.sideConditions[id], sourceSide.sideConditions[id]})
                            self:add("-sideend", sourceSide, effectName, "[silent]")
                            self:add("-sideend", targetSide, effectName, "[silent]")
                        elseif sourceSide.sideConditions[id] and (not targetSide.sideConditions[id]) then
                            targetSide.sideConditions[id] = sourceSide.sideConditions[id]
                            __TS__Delete(sourceSide.sideConditions, id)
                            self:add("-sideend", sourceSide, effectName, "[silent]")
                        elseif targetSide.sideConditions[id] and (not sourceSide.sideConditions[id]) then
                            sourceSide.sideConditions[id] = targetSide.sideConditions[id]
                            __TS__Delete(targetSide.sideConditions, id)
                            self:add("-sideend", targetSide, effectName, "[silent]")
                        else
                            goto __continue200
                        end
                        local sourceLayers = ((sourceSide.sideConditions[id] and (function() return sourceSide.sideConditions[id].layers or 1 end)) or (function() return 0 end))()
                        local targetLayers = ((targetSide.sideConditions[id] and (function() return targetSide.sideConditions[id].layers or 1 end)) or (function() return 0 end))()
                        do
                            while sourceLayers > 0 do
                                self:add("-sidestart", sourceSide, effectName, "[silent]")
                                sourceLayers = sourceLayers - 1
                            end
                        end
                        do
                            while targetLayers > 0 do
                                self:add("-sidestart", targetSide, effectName, "[silent]")
                                targetLayers = targetLayers - 1
                            end
                        end
                        success = true
                    end
                    ::__continue200::
                end
            end
            if not success then
                return false
            end
            self:add("-activate", source, "move: Court Change")
        end,
        secondary = nil,
        target = "all",
        type = "Normal"
    },
    covet = {
        num = 343,
        accuracy = 100,
        basePower = 60,
        category = "Physical",
        name = "Covet",
        pp = 25,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onAfterHit = function(self, target, source, move)
            if source.item or source.volatiles.gem then
                return
            end
            local yourItem = target:takeItem(source)
            if not yourItem then
                return
            end
            if (not self:singleEvent("TakeItem", yourItem, target.itemState, source, target, move, yourItem)) or (not source:setItem(yourItem)) then
                target.item = yourItem.id
                return
            end
            self:add(
                "-item",
                source,
                yourItem,
                "[from] move: Covet",
                "[of] " .. tostring(target)
            )
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Cute"
    },
    crabhammer = {num = 152, accuracy = 90, basePower = 100, category = "Physical", name = "Crabhammer", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, critRatio = 2, secondary = nil, target = "normal", type = "Water", contestType = "Tough"},
    craftyshield = {
        num = 578,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Crafty Shield",
        pp = 10,
        priority = 3,
        flags = {},
        sideCondition = "craftyshield",
        onTry = function(self)
            return not (not self.queue:willAct())
        end,
        condition = {
            duration = 1,
            onSideStart = function(self, target, source)
                self:add("-singleturn", source, "Crafty Shield")
            end,
            onTryHitPriority = 3,
            onTryHit = function(self, target, source, move)
                if ({"self", "all"}):includes(move.target) or (move.category ~= "Status") then
                    return
                end
                self:add("-activate", target, "move: Crafty Shield")
                return self.NOT_FAIL
            end
        },
        secondary = nil,
        target = "allySide",
        type = "Fairy",
        zMove = {boost = {spd = 1}},
        contestType = "Clever"
    },
    crosschop = {num = 238, accuracy = 80, basePower = 100, category = "Physical", name = "Cross Chop", pp = 5, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, critRatio = 2, secondary = nil, target = "normal", type = "Fighting", contestType = "Cool"},
    crosspoison = {num = 440, accuracy = 100, basePower = 70, category = "Physical", name = "Cross Poison", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 10, status = "psn"}, critRatio = 2, target = "normal", type = "Poison", contestType = "Cool"},
    crunch = {num = 242, accuracy = 100, basePower = 80, category = "Physical", name = "Crunch", pp = 15, priority = 0, flags = {bite = 1, contact = 1, protect = 1, mirror = 1}, secondary = {chance = 20, boosts = {def = -1}}, target = "normal", type = "Dark", contestType = "Tough"},
    crushclaw = {num = 306, accuracy = 95, basePower = 75, category = "Physical", name = "Crush Claw", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 50, boosts = {def = -1}}, target = "normal", type = "Normal", contestType = "Cool"},
    crushgrip = {
        num = 462,
        accuracy = 100,
        basePower = 0,
        basePowerCallback = function(self, pokemon, target)
            return math.floor(
                math.floor(
                    (((120 * (100 * math.floor((target.hp * 4096) / target.maxhp))) + 2048) - 1) / 4096
                ) / 100
            ) or 1
        end,
        category = "Physical",
        name = "Crush Grip",
        pp = 5,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {basePower = 190},
        maxMove = {basePower = 140},
        contestType = "Tough"
    },
    curse = {
        num = 174,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Curse",
        pp = 10,
        priority = 0,
        flags = {authentic = 1},
        volatileStatus = "curse",
        onModifyMove = function(self, move, source, target)
            if not source:hasType("Ghost") then
                move.target = move.nonGhostTarget
            end
        end,
        onTryHit = function(self, target, source, move)
            if not source:hasType("Ghost") then
                __TS__Delete(move, "volatileStatus")
                __TS__Delete(move, "onHit")
                move.self = {boosts = {spe = -1, atk = 1, def = 1}}
            elseif move.volatileStatus and target.volatiles.curse then
                return false
            end
        end,
        onHit = function(self, target, source)
            self:directDamage(source.maxhp / 2, source, source)
        end,
        condition = {
            onStart = function(self, pokemon, source)
                self:add(
                    "-start",
                    pokemon,
                    "Curse",
                    "[of] " .. tostring(source)
                )
            end,
            onResidualOrder = 12,
            onResidual = function(self, pokemon)
                self:damage(pokemon.baseMaxhp / 4)
            end
        },
        secondary = nil,
        target = "randomNormal",
        nonGhostTarget = "self",
        type = "Ghost",
        zMove = {effect = "curse"},
        contestType = "Tough"
    },
    cut = {num = 15, accuracy = 95, basePower = 50, category = "Physical", name = "Cut", pp = 30, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Normal", contestType = "Cool"},
    darkestlariat = {num = 663, accuracy = 100, basePower = 85, category = "Physical", name = "Darkest Lariat", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, ignoreEvasion = true, ignoreDefensive = true, secondary = nil, target = "normal", type = "Dark", contestType = "Cool"},
    darkpulse = {num = 399, accuracy = 100, basePower = 80, category = "Special", name = "Dark Pulse", pp = 15, priority = 0, flags = {protect = 1, pulse = 1, mirror = 1, distance = 1}, secondary = {chance = 20, volatileStatus = "flinch"}, target = "any", type = "Dark", contestType = "Cool"},
    darkvoid = {
        num = 464,
        accuracy = 50,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Dark Void",
        pp = 10,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1},
        status = "slp",
        onTry = function(self, source, target, move)
            if (source.species.name == "Darkrai") or move.hasBounced then
                return
            end
            self:add("-fail", source, "move: Dark Void")
            self:hint("Only a Pokemon whose form is Darkrai can use this move.")
            return nil
        end,
        secondary = nil,
        target = "allAdjacentFoes",
        type = "Dark",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Clever"
    },
    dazzlinggleam = {num = 605, accuracy = 100, basePower = 80, category = "Special", name = "Dazzling Gleam", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "allAdjacentFoes", type = "Fairy", contestType = "Beautiful"},
    decorate = {num = 777, accuracy = true, basePower = 0, category = "Status", name = "Decorate", pp = 15, priority = 0, flags = {mystery = 1}, secondary = nil, boosts = {atk = 2, spa = 2}, target = "normal", type = "Fairy"},
    defendorder = {num = 455, accuracy = true, basePower = 0, category = "Status", name = "Defend Order", pp = 10, priority = 0, flags = {snatch = 1}, boosts = {def = 1, spd = 1}, secondary = nil, target = "self", type = "Bug", zMove = {boost = {def = 1}}, contestType = "Clever"},
    defensecurl = {num = 111, accuracy = true, basePower = 0, category = "Status", name = "Defense Curl", pp = 40, priority = 0, flags = {snatch = 1}, boosts = {def = 1}, volatileStatus = "defensecurl", condition = {noCopy = true}, secondary = nil, target = "self", type = "Normal", zMove = {boost = {accuracy = 1}}, contestType = "Cute"},
    defog = {
        num = 432,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Defog",
        pp = 15,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, authentic = 1},
        onHit = function(self, target, source, move)
            local success = false
            if (not target.volatiles.substitute) or move.infiltrates then
                success = not (not self:boost({evasion = -1}))
            end
            local removeTarget = {"reflect", "lightscreen", "auroraveil", "safeguard", "mist", "spikes", "toxicspikes", "stealthrock", "stickyweb", "gmaxsteelsurge"}
            local removeAll = {"spikes", "toxicspikes", "stealthrock", "stickyweb", "gmaxsteelsurge"}
            for ____, targetCondition in ipairs(removeTarget) do
                do
                    if target.side:removeSideCondition(targetCondition) then
                        if not removeAll:includes(targetCondition) then
                            goto __continue229
                        end
                        self:add(
                            "-sideend",
                            target.side,
                            self.dex.conditions:get(targetCondition).name,
                            "[from] move: Defog",
                            "[of] " .. tostring(source)
                        )
                        success = true
                    end
                end
                ::__continue229::
            end
            for ____, sideCondition in ipairs(removeAll) do
                if source.side:removeSideCondition(sideCondition) then
                    self:add(
                        "-sideend",
                        source.side,
                        self.dex.conditions:get(sideCondition).name,
                        "[from] move: Defog",
                        "[of] " .. tostring(source)
                    )
                    success = true
                end
            end
            self.field:clearTerrain()
            return success
        end,
        secondary = nil,
        target = "normal",
        type = "Flying",
        zMove = {boost = {accuracy = 1}},
        contestType = "Cool"
    },
    destinybond = {
        num = 194,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Destiny Bond",
        pp = 5,
        priority = 0,
        flags = {authentic = 1},
        volatileStatus = "destinybond",
        onPrepareHit = function(self, pokemon)
            return not pokemon:removeVolatile("destinybond")
        end,
        condition = {
            onStart = function(self, pokemon)
                self:add("-singlemove", pokemon, "Destiny Bond")
            end,
            onFaint = function(self, target, source, effect)
                if ((not source) or (not effect)) or target:isAlly(source) then
                    return
                end
                if (effect.effectType == "Move") and (not effect.isFutureMove) then
                    if source.volatiles.dynamax then
                        self:add("-hint", "Dynamaxed Pokémon are immune to Destiny Bond.")
                        return
                    end
                    self:add("-activate", target, "move: Destiny Bond")
                    source:faint()
                end
            end,
            onBeforeMovePriority = -1,
            onBeforeMove = function(self, pokemon, target, move)
                if move.id == "destinybond" then
                    return
                end
                self:debug("removing Destiny Bond before attack")
                pokemon:removeVolatile("destinybond")
            end,
            onMoveAborted = function(self, pokemon, target, move)
                pokemon:removeVolatile("destinybond")
            end
        },
        secondary = nil,
        target = "self",
        type = "Ghost",
        zMove = {effect = "redirect"},
        contestType = "Clever"
    },
    detect = {
        num = 197,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Detect",
        pp = 5,
        priority = 4,
        flags = {},
        stallingMove = true,
        volatileStatus = "protect",
        onPrepareHit = function(self, pokemon)
            return (not (not self.queue:willAct())) and self:runEvent("StallMove", pokemon)
        end,
        onHit = function(self, pokemon)
            pokemon:addVolatile("stall")
        end,
        secondary = nil,
        target = "self",
        type = "Fighting",
        zMove = {boost = {evasion = 1}},
        contestType = "Cool"
    },
    devastatingdrake = {num = 652, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Devastating Drake", pp = 1, priority = 0, flags = {}, isZ = "dragoniumz", secondary = nil, target = "normal", type = "Dragon", contestType = "Cool"},
    diamondstorm = {num = 591, accuracy = 95, basePower = 100, category = "Physical", name = "Diamond Storm", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, self = {chance = 50, boosts = {def = 2}}, secondary = {}, target = "allAdjacentFoes", type = "Rock", contestType = "Beautiful"},
    dig = {
        num = 91,
        accuracy = 100,
        basePower = 80,
        category = "Physical",
        name = "Dig",
        pp = 10,
        priority = 0,
        flags = {contact = 1, charge = 1, protect = 1, mirror = 1, nonsky = 1},
        onTryMove = function(self, attacker, defender, move)
            if attacker:removeVolatile(move.id) then
                return
            end
            self:add("-prepare", attacker, move.name)
            if not self:runEvent("ChargeMove", attacker, defender, move) then
                return
            end
            attacker:addVolatile("twoturnmove", defender)
            return nil
        end,
        condition = {
            duration = 2,
            onImmunity = function(self, ____type, pokemon)
                if (____type == "sandstorm") or (____type == "hail") then
                    return false
                end
            end,
            onInvulnerability = function(self, target, source, move)
                if ({"earthquake", "magnitude"}):includes(move.id) then
                    return
                end
                return false
            end,
            onSourceModifyDamage = function(self, damage, source, target, move)
                if (move.id == "earthquake") or (move.id == "magnitude") then
                    return self:chainModify(2)
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Ground",
        contestType = "Tough"
    },
    disable = {
        num = 50,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Disable",
        pp = 20,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, authentic = 1},
        volatileStatus = "disable",
        onTryHit = function(self, target)
            if (((not target.lastMove) or target.lastMove.isZ) or target.lastMove.isMax) or (target.lastMove.id == "struggle") then
                return false
            end
        end,
        condition = {
            duration = 5,
            noCopy = true,
            onStart = function(self, pokemon, source, effect)
                if self.queue:willMove(pokemon) or (((pokemon == self.activePokemon) and self.activeMove) and (not self.activeMove.isExternal)) then
                    local ____obj, ____index = self.effectState, "duration"
                    ____obj[____index] = ____obj[____index] - 1
                end
                if not pokemon.lastMove then
                    self:debug("Pokemon hasn't moved yet")
                    return false
                end
                for ____, moveSlot in __TS__Iterator(pokemon.moveSlots) do
                    if moveSlot.id == pokemon.lastMove.id then
                        if not moveSlot.pp then
                            self:debug("Move out of PP")
                            return false
                        end
                    end
                end
                if effect.effectType == "Ability" then
                    self:add(
                        "-start",
                        pokemon,
                        "Disable",
                        pokemon.lastMove.name,
                        "[from] ability: Cursed Body",
                        "[of] " .. tostring(source)
                    )
                else
                    self:add("-start", pokemon, "Disable", pokemon.lastMove.name)
                end
                self.effectState.move = pokemon.lastMove.id
            end,
            onResidualOrder = 17,
            onEnd = function(self, pokemon)
                self:add("-end", pokemon, "Disable")
            end,
            onBeforeMovePriority = 7,
            onBeforeMove = function(self, attacker, defender, move)
                if (not move.isZ) and (move.id == self.effectState.move) then
                    self:add("cant", attacker, "Disable", move)
                    return false
                end
            end,
            onDisableMove = function(self, pokemon)
                for ____, moveSlot in __TS__Iterator(pokemon.moveSlots) do
                    if moveSlot.id == self.effectState.move then
                        pokemon:disableMove(moveSlot.id)
                    end
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Clever"
    },
    disarmingvoice = {num = 574, accuracy = true, basePower = 40, category = "Special", name = "Disarming Voice", pp = 15, priority = 0, flags = {protect = 1, mirror = 1, sound = 1, authentic = 1}, secondary = nil, target = "allAdjacentFoes", type = "Fairy", contestType = "Cute"},
    discharge = {num = 435, accuracy = 100, basePower = 80, category = "Special", name = "Discharge", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 30, status = "par"}, target = "allAdjacent", type = "Electric", contestType = "Beautiful"},
    dive = {
        num = 291,
        accuracy = 100,
        basePower = 80,
        category = "Physical",
        name = "Dive",
        pp = 10,
        priority = 0,
        flags = {contact = 1, charge = 1, protect = 1, mirror = 1, nonsky = 1},
        onTryMove = function(self, attacker, defender, move)
            if attacker:removeVolatile(move.id) then
                return
            end
            if (attacker:hasAbility("gulpmissile") and (attacker.species.name == "Cramorant")) and (not attacker.transformed) then
                local forme = ((attacker.hp <= (attacker.maxhp / 2)) and "cramorantgorging") or "cramorantgulping"
                attacker:formeChange(forme, move)
            end
            self:add("-prepare", attacker, move.name)
            if not self:runEvent("ChargeMove", attacker, defender, move) then
                return
            end
            attacker:addVolatile("twoturnmove", defender)
            return nil
        end,
        condition = {
            duration = 2,
            onImmunity = function(self, ____type, pokemon)
                if (____type == "sandstorm") or (____type == "hail") then
                    return false
                end
            end,
            onInvulnerability = function(self, target, source, move)
                if ({"surf", "whirlpool"}):includes(move.id) then
                    return
                end
                return false
            end,
            onSourceModifyDamage = function(self, damage, source, target, move)
                if (move.id == "surf") or (move.id == "whirlpool") then
                    return self:chainModify(2)
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Water",
        contestType = "Beautiful"
    },
    dizzypunch = {num = 146, accuracy = 100, basePower = 70, category = "Physical", isNonstandard = "Past", name = "Dizzy Punch", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, secondary = {chance = 20, volatileStatus = "confusion"}, target = "normal", type = "Normal", contestType = "Cute"},
    doomdesire = {
        num = 353,
        accuracy = 100,
        basePower = 140,
        category = "Special",
        name = "Doom Desire",
        pp = 5,
        priority = 0,
        flags = {},
        isFutureMove = true,
        onTry = function(self, source, target)
            if not target.side:addSlotCondition(target, "futuremove") then
                return false
            end
            __TS__ObjectAssign(target.side.slotConditions[target.position].futuremove, {move = "doomdesire", source = source, moveData = {id = "doomdesire", name = "Doom Desire", accuracy = 100, basePower = 140, category = "Special", priority = 0, flags = {}, effectType = "Move", isFutureMove = true, type = "Steel"}})
            self:add("-start", source, "Doom Desire")
            return self.NOT_FAIL
        end,
        secondary = nil,
        target = "normal",
        type = "Steel",
        contestType = "Beautiful"
    },
    doubleedge = {num = 38, accuracy = 100, basePower = 120, category = "Physical", name = "Double-Edge", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, recoil = {33, 100}, secondary = nil, target = "normal", type = "Normal", contestType = "Tough"},
    doublehit = {num = 458, accuracy = 90, basePower = 35, category = "Physical", name = "Double Hit", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, multihit = 2, secondary = nil, target = "normal", type = "Normal", zMove = {basePower = 140}, maxMove = {basePower = 120}, contestType = "Cool"},
    doubleironbash = {num = 742, accuracy = 100, basePower = 60, category = "Physical", name = "Double Iron Bash", pp = 5, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, multihit = 2, secondary = {chance = 30, volatileStatus = "flinch"}, target = "normal", type = "Steel", zMove = {basePower = 180}, maxMove = {basePower = 140}, contestType = "Clever"},
    doublekick = {num = 24, accuracy = 100, basePower = 30, category = "Physical", name = "Double Kick", pp = 30, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, multihit = 2, secondary = nil, target = "normal", type = "Fighting", maxMove = {basePower = 80}, contestType = "Cool"},
    doubleslap = {num = 3, accuracy = 85, basePower = 15, category = "Physical", isNonstandard = "Past", name = "Double Slap", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, multihit = {2, 5}, secondary = nil, target = "normal", type = "Normal", contestType = "Cute"},
    doubleteam = {num = 104, accuracy = true, basePower = 0, category = "Status", name = "Double Team", pp = 15, priority = 0, flags = {snatch = 1}, boosts = {evasion = 1}, secondary = nil, target = "self", type = "Normal", zMove = {effect = "clearnegativeboost"}, contestType = "Cool"},
    dracometeor = {num = 434, accuracy = 90, basePower = 130, category = "Special", name = "Draco Meteor", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, self = {boosts = {spa = -2}}, secondary = nil, target = "normal", type = "Dragon", contestType = "Beautiful"},
    dragonascent = {num = 620, accuracy = 100, basePower = 120, category = "Physical", name = "Dragon Ascent", pp = 5, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, distance = 1}, self = {boosts = {def = -1, spd = -1}}, target = "any", type = "Flying", contestType = "Beautiful"},
    dragonbreath = {num = 225, accuracy = 100, basePower = 60, category = "Special", name = "Dragon Breath", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 30, status = "par"}, target = "normal", type = "Dragon", contestType = "Cool"},
    dragonclaw = {num = 337, accuracy = 100, basePower = 80, category = "Physical", name = "Dragon Claw", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Dragon", contestType = "Cool"},
    dragondance = {num = 349, accuracy = true, basePower = 0, category = "Status", name = "Dragon Dance", pp = 20, priority = 0, flags = {snatch = 1, dance = 1}, boosts = {atk = 1, spe = 1}, secondary = nil, target = "self", type = "Dragon", zMove = {effect = "clearnegativeboost"}, contestType = "Cool"},
    dragondarts = {num = 751, accuracy = 100, basePower = 50, category = "Physical", name = "Dragon Darts", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, multihit = 2, smartTarget = true, secondary = nil, target = "normal", type = "Dragon", maxMove = {basePower = 130}},
    dragonenergy = {
        num = 820,
        accuracy = 100,
        basePower = 150,
        basePowerCallback = function(self, pokemon, target, move)
            return (move.basePower * pokemon.hp) / pokemon.maxhp
        end,
        category = "Special",
        name = "Dragon Energy",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        secondary = nil,
        target = "allAdjacentFoes",
        type = "Dragon"
    },
    dragonhammer = {num = 692, accuracy = 100, basePower = 90, category = "Physical", name = "Dragon Hammer", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Dragon", contestType = "Tough"},
    dragonpulse = {num = 406, accuracy = 100, basePower = 85, category = "Special", name = "Dragon Pulse", pp = 10, priority = 0, flags = {protect = 1, pulse = 1, mirror = 1, distance = 1}, secondary = nil, target = "any", type = "Dragon", contestType = "Beautiful"},
    dragonrage = {num = 82, accuracy = 100, basePower = 0, damage = 40, category = "Special", isNonstandard = "Past", name = "Dragon Rage", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Dragon", contestType = "Cool"},
    dragonrush = {num = 407, accuracy = 75, basePower = 100, category = "Physical", name = "Dragon Rush", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 20, volatileStatus = "flinch"}, target = "normal", type = "Dragon", contestType = "Tough"},
    dragontail = {num = 525, accuracy = 90, basePower = 60, category = "Physical", name = "Dragon Tail", pp = 10, priority = -6, flags = {contact = 1, protect = 1, mirror = 1}, forceSwitch = true, target = "normal", type = "Dragon", contestType = "Tough"},
    drainingkiss = {num = 577, accuracy = 100, basePower = 50, category = "Special", name = "Draining Kiss", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, heal = 1}, drain = {3, 4}, secondary = nil, target = "normal", type = "Fairy", contestType = "Cute"},
    drainpunch = {num = 409, accuracy = 100, basePower = 75, category = "Physical", name = "Drain Punch", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1, heal = 1}, drain = {1, 2}, secondary = nil, target = "normal", type = "Fighting", contestType = "Tough"},
    dreameater = {
        num = 138,
        accuracy = 100,
        basePower = 100,
        category = "Special",
        name = "Dream Eater",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1, heal = 1},
        drain = {1, 2},
        onTryImmunity = function(self, target)
            return (target.status == "slp") or target:hasAbility("comatose")
        end,
        secondary = nil,
        target = "normal",
        type = "Psychic",
        contestType = "Clever"
    },
    drillpeck = {num = 65, accuracy = 100, basePower = 80, category = "Physical", name = "Drill Peck", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, distance = 1}, secondary = nil, target = "any", type = "Flying", contestType = "Cool"},
    drillrun = {num = 529, accuracy = 95, basePower = 80, category = "Physical", name = "Drill Run", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, critRatio = 2, secondary = nil, target = "normal", type = "Ground", contestType = "Tough"},
    drumbeating = {num = 778, accuracy = 100, basePower = 80, category = "Physical", name = "Drum Beating", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {spe = -1}}, target = "normal", type = "Grass"},
    dualchop = {num = 530, accuracy = 90, basePower = 40, category = "Physical", name = "Dual Chop", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, multihit = 2, secondary = nil, target = "normal", type = "Dragon", maxMove = {basePower = 130}, contestType = "Tough"},
    dualwingbeat = {num = 814, accuracy = 90, basePower = 40, category = "Physical", name = "Dual Wingbeat", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, multihit = 2, secondary = nil, target = "normal", type = "Flying", maxMove = {basePower = 130}},
    dynamaxcannon = {num = 744, accuracy = 100, basePower = 100, category = "Special", name = "Dynamax Cannon", pp = 5, priority = 0, flags = {protect = 1}, secondary = nil, target = "normal", type = "Dragon"},
    dynamicpunch = {num = 223, accuracy = 50, basePower = 100, category = "Physical", name = "Dynamic Punch", pp = 5, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, secondary = {chance = 100, volatileStatus = "confusion"}, target = "normal", type = "Fighting", contestType = "Cool"},
    earthpower = {num = 414, accuracy = 100, basePower = 90, category = "Special", name = "Earth Power", pp = 10, priority = 0, flags = {protect = 1, mirror = 1, nonsky = 1}, secondary = {chance = 10, boosts = {spd = -1}}, target = "normal", type = "Ground", contestType = "Beautiful"},
    earthquake = {num = 89, accuracy = 100, basePower = 100, category = "Physical", name = "Earthquake", pp = 10, priority = 0, flags = {protect = 1, mirror = 1, nonsky = 1}, secondary = nil, target = "allAdjacent", type = "Ground", contestType = "Tough"},
    echoedvoice = {
        num = 497,
        accuracy = 100,
        basePower = 40,
        basePowerCallback = function(self)
            if self.field.pseudoWeather.echoedvoice then
                return 40 * self.field.pseudoWeather.echoedvoice.multiplier
            end
            return 40
        end,
        category = "Special",
        name = "Echoed Voice",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1, sound = 1, authentic = 1},
        onTry = function(self)
            self.field:addPseudoWeather("echoedvoice")
        end,
        condition = {
            duration = 2,
            onFieldStart = function(self)
                self.effectState.multiplier = 1
            end,
            onFieldRestart = function(self)
                if self.effectState.duration ~= 2 then
                    self.effectState.duration = 2
                    if self.effectState.multiplier < 5 then
                        local ____obj, ____index = self.effectState, "multiplier"
                        ____obj[____index] = ____obj[____index] + 1
                    end
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Beautiful"
    },
    eerieimpulse = {num = 598, accuracy = 100, basePower = 0, category = "Status", name = "Eerie Impulse", pp = 15, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, boosts = {spa = -2}, secondary = nil, target = "normal", type = "Electric", zMove = {boost = {spd = 1}}, contestType = "Clever"},
    eeriespell = {
        num = 826,
        accuracy = 100,
        basePower = 80,
        category = "Special",
        name = "Eerie Spell",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1, sound = 1, authentic = 1},
        secondary = {
            chance = 100,
            onHit = function(self, target)
                if not target.hp then
                    return
                end
                local move = target.lastMove
                if (not move) or move.isZ then
                    return
                end
                if move.isMax and move.baseMove then
                    move = self.dex.moves:get(move.baseMove)
                end
                local ppDeducted = target:deductPP(move.id, 3)
                if not ppDeducted then
                    return
                end
                self:add("-activate", target, "move: Eerie Spell", move.name, ppDeducted)
            end
        },
        target = "normal",
        type = "Psychic"
    },
    eggbomb = {num = 121, accuracy = 75, basePower = 100, category = "Physical", isNonstandard = "Past", name = "Egg Bomb", pp = 10, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Normal", contestType = "Cute"},
    electricterrain = {
        num = 604,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Electric Terrain",
        pp = 10,
        priority = 0,
        flags = {nonsky = 1},
        terrain = "electricterrain",
        condition = {
            duration = 5,
            durationCallback = function(self, source, effect)
                if source:hasItem("terrainextender") then
                    return 8
                end
                return 5
            end,
            onSetStatus = function(self, status, target, source, effect)
                if ((status.id == "slp") and target:isGrounded()) and (not target:isSemiInvulnerable()) then
                    if (effect.id == "yawn") or ((effect.effectType == "Move") and (not effect.secondaries)) then
                        self:add("-activate", target, "move: Electric Terrain")
                    end
                    return false
                end
            end,
            onTryAddVolatile = function(self, status, target)
                if (not target:isGrounded()) or target:isSemiInvulnerable() then
                    return
                end
                if status.id == "yawn" then
                    self:add("-activate", target, "move: Electric Terrain")
                    return nil
                end
            end,
            onBasePowerPriority = 6,
            onBasePower = function(self, basePower, attacker, defender, move)
                if ((move.type == "Electric") and attacker:isGrounded()) and (not attacker:isSemiInvulnerable()) then
                    self:debug("electric terrain boost")
                    return self:chainModify({5325, 4096})
                end
            end,
            onFieldStart = function(self, field, source, effect)
                if effect.effectType == "Ability" then
                    self:add(
                        "-fieldstart",
                        "move: Electric Terrain",
                        "[from] ability: " .. tostring(effect),
                        "[of] " .. tostring(source)
                    )
                else
                    self:add("-fieldstart", "move: Electric Terrain")
                end
            end,
            onFieldResidualOrder = 27,
            onFieldResidualSubOrder = 7,
            onFieldEnd = function(self)
                self:add("-fieldend", "move: Electric Terrain")
            end
        },
        secondary = nil,
        target = "all",
        type = "Electric",
        zMove = {boost = {spe = 1}},
        contestType = "Clever"
    },
    electrify = {
        num = 582,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Electrify",
        pp = 20,
        priority = 0,
        flags = {protect = 1, mirror = 1, mystery = 1},
        volatileStatus = "electrify",
        onTryHit = function(self, target)
            if (not self.queue:willMove(target)) and target.activeTurns then
                return false
            end
        end,
        condition = {
            duration = 1,
            onStart = function(self, target)
                self:add("-singleturn", target, "move: Electrify")
            end,
            onModifyTypePriority = -2,
            onModifyType = function(self, move)
                if move.id ~= "struggle" then
                    self:debug("Electrify making move type electric")
                    move.type = "Electric"
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Electric",
        zMove = {boost = {spa = 1}},
        contestType = "Clever"
    },
    electroball = {
        num = 486,
        accuracy = 100,
        basePower = 0,
        basePowerCallback = function(self, pokemon, target)
            local ratio = math.floor(
                pokemon:getStat("spe") / target:getStat("spe")
            )
            if not __TS__NumberIsFinite(
                __TS__Number(ratio)
            ) then
                ratio = 0
            end
            local bp = ({40, 60, 80, 120, 150})[math.min(ratio, 4) + 1]
            self:debug(
                tostring(bp) .. " bp"
            )
            return bp
        end,
        category = "Special",
        name = "Electro Ball",
        pp = 10,
        priority = 0,
        flags = {bullet = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Electric",
        zMove = {basePower = 160},
        maxMove = {basePower = 130},
        contestType = "Cool"
    },
    electroweb = {num = 527, accuracy = 95, basePower = 55, category = "Special", name = "Electroweb", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {spe = -1}}, target = "allAdjacentFoes", type = "Electric", contestType = "Beautiful"},
    embargo = {
        num = 373,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Embargo",
        pp = 15,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1},
        volatileStatus = "embargo",
        condition = {
            duration = 5,
            onStart = function(self, pokemon)
                self:add("-start", pokemon, "Embargo")
            end,
            onResidualOrder = 21,
            onEnd = function(self, pokemon)
                self:add("-end", pokemon, "Embargo")
            end
        },
        secondary = nil,
        target = "normal",
        type = "Dark",
        zMove = {boost = {spa = 1}},
        contestType = "Clever"
    },
    ember = {num = 52, accuracy = 100, basePower = 40, category = "Special", name = "Ember", pp = 25, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, status = "brn"}, target = "normal", type = "Fire", contestType = "Cute"},
    encore = {
        num = 227,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Encore",
        pp = 5,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, authentic = 1},
        volatileStatus = "encore",
        condition = {
            duration = 3,
            noCopy = true,
            onStart = function(self, target)
                local noEncore = {"assist", "copycat", "encore", "mefirst", "metronome", "mimic", "mirrormove", "naturepower", "sketch", "sleeptalk", "struggle", "transform"}
                local move = target.lastMove
                if (not move) or target.volatiles.dynamax then
                    return false
                end
                if move.isMax and move.baseMove then
                    move = self.dex.moves:get(move.baseMove)
                end
                local moveIndex = target.moves:indexOf(move.id)
                if ((move.isZ or noEncore:includes(move.id)) or (not target.moveSlots[moveIndex])) or (target.moveSlots[moveIndex].pp <= 0) then
                    return false
                end
                self.effectState.move = move.id
                self:add("-start", target, "Encore")
                if not self.queue:willMove(target) then
                    local ____obj, ____index = self.effectState, "duration"
                    ____obj[____index] = ____obj[____index] + 1
                end
            end,
            onOverrideAction = function(self, pokemon, target, move)
                if move.id ~= self.effectState.move then
                    return self.effectState.move
                end
            end,
            onResidualOrder = 16,
            onResidual = function(self, target)
                if target.moves:includes(self.effectState.move) and (target.moveSlots[target.moves:indexOf(self.effectState.move)].pp <= 0) then
                    target:removeVolatile("encore")
                end
            end,
            onEnd = function(self, target)
                self:add("-end", target, "Encore")
            end,
            onDisableMove = function(self, pokemon)
                if (not self.effectState.move) or (not pokemon:hasMove(self.effectState.move)) then
                    return
                end
                for ____, moveSlot in __TS__Iterator(pokemon.moveSlots) do
                    if moveSlot.id ~= self.effectState.move then
                        pokemon:disableMove(moveSlot.id)
                    end
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {spe = 1}},
        contestType = "Cute"
    },
    endeavor = {
        num = 283,
        accuracy = 100,
        basePower = 0,
        damageCallback = function(self, pokemon, target)
            return target:getUndynamaxedHP() - pokemon.hp
        end,
        category = "Physical",
        name = "Endeavor",
        pp = 5,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onTryImmunity = function(self, target, pokemon)
            return pokemon.hp < target.hp
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {basePower = 160},
        maxMove = {basePower = 130},
        contestType = "Tough"
    },
    endure = {
        num = 203,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Endure",
        pp = 10,
        priority = 4,
        flags = {},
        stallingMove = true,
        volatileStatus = "endure",
        onPrepareHit = function(self, pokemon)
            return (not (not self.queue:willAct())) and self:runEvent("StallMove", pokemon)
        end,
        onHit = function(self, pokemon)
            pokemon:addVolatile("stall")
        end,
        condition = {
            duration = 1,
            onStart = function(self, target)
                self:add("-singleturn", target, "move: Endure")
            end,
            onDamagePriority = -10,
            onDamage = function(self, damage, target, source, effect)
                if (effect.effectType == "Move") and (damage >= target.hp) then
                    self:add("-activate", target, "move: Endure")
                    return target.hp - 1
                end
            end
        },
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Tough"
    },
    energyball = {num = 412, accuracy = 100, basePower = 90, category = "Special", name = "Energy Ball", pp = 10, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, secondary = {chance = 10, boosts = {spd = -1}}, target = "normal", type = "Grass", contestType = "Beautiful"},
    entrainment = {
        num = 494,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Entrainment",
        pp = 15,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1},
        onTryHit = function(self, target, source)
            if (target == source) or target.volatiles.dynamax then
                return false
            end
            local additionalBannedSourceAbilities = {"flowergift", "forecast", "hungerswitch", "illusion", "imposter", "neutralizinggas", "powerofalchemy", "receiver", "trace", "zenmode"}
            if ((((target.ability == source.ability) or target:getAbility().isPermanent) or (target.ability == "truant")) or source:getAbility().isPermanent) or additionalBannedSourceAbilities:includes(source.ability) then
                return false
            end
        end,
        onHit = function(self, target, source)
            local oldAbility = target:setAbility(source.ability)
            if oldAbility then
                self:add(
                    "-ability",
                    target,
                    target:getAbility().name,
                    "[from] move: Entrainment"
                )
                if not target:isAlly(source) then
                    target.volatileStaleness = "external"
                end
                return
            end
            return false
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {spd = 1}},
        contestType = "Cute"
    },
    eruption = {
        num = 284,
        accuracy = 100,
        basePower = 150,
        basePowerCallback = function(self, pokemon, target, move)
            return (move.basePower * pokemon.hp) / pokemon.maxhp
        end,
        category = "Special",
        name = "Eruption",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        secondary = nil,
        target = "allAdjacentFoes",
        type = "Fire",
        contestType = "Beautiful"
    },
    eternabeam = {num = 795, accuracy = 90, basePower = 160, category = "Special", name = "Eternabeam", pp = 5, priority = 0, flags = {recharge = 1, protect = 1, mirror = 1}, self = {volatileStatus = "mustrecharge"}, secondary = nil, target = "normal", type = "Dragon"},
    expandingforce = {
        num = 797,
        accuracy = 100,
        basePower = 80,
        category = "Special",
        name = "Expanding Force",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onBasePower = function(self, basePower, source)
            if self.field:isTerrain("psychicterrain") and source:isGrounded() then
                self:debug("terrain buff")
                return self:chainModify(1.5)
            end
        end,
        onModifyMove = function(self, move, source, target)
            if self.field:isTerrain("psychicterrain") and source:isGrounded() then
                move.target = "allAdjacentFoes"
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Psychic"
    },
    explosion = {num = 153, accuracy = 100, basePower = 250, category = "Physical", name = "Explosion", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, selfdestruct = "always", secondary = nil, target = "allAdjacent", type = "Normal", contestType = "Beautiful"},
    extrasensory = {num = 326, accuracy = 100, basePower = 80, category = "Special", name = "Extrasensory", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, volatileStatus = "flinch"}, target = "normal", type = "Psychic", contestType = "Cool"},
    extremeevoboost = {num = 702, accuracy = true, basePower = 0, category = "Status", isNonstandard = "Past", name = "Extreme Evoboost", pp = 1, priority = 0, flags = {}, isZ = "eeviumz", boosts = {atk = 2, def = 2, spa = 2, spd = 2, spe = 2}, secondary = nil, target = "self", type = "Normal", contestType = "Beautiful"},
    extremespeed = {num = 245, accuracy = 100, basePower = 80, category = "Physical", name = "Extreme Speed", pp = 5, priority = 2, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Normal", contestType = "Cool"},
    facade = {
        num = 263,
        accuracy = 100,
        basePower = 70,
        category = "Physical",
        name = "Facade",
        pp = 20,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onBasePower = function(self, basePower, pokemon)
            if pokemon.status and (pokemon.status ~= "slp") then
                return self:chainModify(2)
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Cute"
    },
    fairylock = {
        num = 587,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Fairy Lock",
        pp = 10,
        priority = 0,
        flags = {mirror = 1, authentic = 1},
        pseudoWeather = "fairylock",
        condition = {
            duration = 2,
            onStart = function(self, target)
                self:add("-fieldactivate", "move: Fairy Lock")
            end,
            onTrapPokemon = function(self, pokemon)
                pokemon:tryTrap()
            end
        },
        secondary = nil,
        target = "all",
        type = "Fairy",
        zMove = {boost = {def = 1}},
        contestType = "Clever"
    },
    fairywind = {num = 584, accuracy = 100, basePower = 40, category = "Special", name = "Fairy Wind", pp = 30, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Fairy", contestType = "Beautiful"},
    fakeout = {
        num = 252,
        accuracy = 100,
        basePower = 40,
        category = "Physical",
        name = "Fake Out",
        pp = 10,
        priority = 3,
        flags = {contact = 1, protect = 1, mirror = 1},
        onTry = function(self, source)
            if source.activeMoveActions > 1 then
                self:hint("Fake Out only works on your first turn out.")
                return false
            end
        end,
        secondary = {chance = 100, volatileStatus = "flinch"},
        target = "normal",
        type = "Normal",
        contestType = "Cute"
    },
    faketears = {num = 313, accuracy = 100, basePower = 0, category = "Status", name = "Fake Tears", pp = 20, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1}, boosts = {spd = -2}, secondary = nil, target = "normal", type = "Dark", zMove = {boost = {spa = 1}}, contestType = "Cute"},
    falsesurrender = {num = 793, accuracy = true, basePower = 80, category = "Physical", name = "False Surrender", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Dark"},
    falseswipe = {
        num = 206,
        accuracy = 100,
        basePower = 40,
        category = "Physical",
        name = "False Swipe",
        pp = 40,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onDamagePriority = -20,
        onDamage = function(self, damage, target, source, effect)
            if damage >= target.hp then
                return target.hp - 1
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Cool"
    },
    featherdance = {num = 297, accuracy = 100, basePower = 0, category = "Status", name = "Feather Dance", pp = 15, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1, dance = 1}, boosts = {atk = -2}, secondary = nil, target = "normal", type = "Flying", zMove = {boost = {def = 1}}, contestType = "Beautiful"},
    feint = {num = 364, accuracy = 100, basePower = 30, category = "Physical", name = "Feint", pp = 10, priority = 2, flags = {mirror = 1}, breaksProtect = true, secondary = nil, target = "normal", type = "Normal", contestType = "Clever"},
    feintattack = {num = 185, accuracy = true, basePower = 60, category = "Physical", isNonstandard = "Past", name = "Feint Attack", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Dark", contestType = "Clever"},
    fellstinger = {
        num = 565,
        accuracy = 100,
        basePower = 50,
        category = "Physical",
        name = "Fell Stinger",
        pp = 25,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onAfterMoveSecondarySelf = function(self, pokemon, target, move)
            if ((not target) or target.fainted) or (target.hp <= 0) then
                self:boost({atk = 3}, pokemon, pokemon, move)
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Bug",
        contestType = "Cool"
    },
    fierydance = {num = 552, accuracy = 100, basePower = 80, category = "Special", name = "Fiery Dance", pp = 10, priority = 0, flags = {protect = 1, mirror = 1, dance = 1}, secondary = {chance = 50, self = {boosts = {spa = 1}}}, target = "normal", type = "Fire", contestType = "Beautiful"},
    fierywrath = {num = 822, accuracy = 100, basePower = 90, category = "Special", name = "Fiery Wrath", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 20, volatileStatus = "flinch"}, target = "allAdjacentFoes", type = "Dark"},
    finalgambit = {
        num = 515,
        accuracy = 100,
        basePower = 0,
        damageCallback = function(self, pokemon)
            local damage = pokemon.hp
            pokemon:faint()
            return damage
        end,
        category = "Special",
        name = "Final Gambit",
        pp = 5,
        priority = 0,
        flags = {protect = 1},
        selfdestruct = "ifHit",
        secondary = nil,
        target = "normal",
        type = "Fighting",
        zMove = {basePower = 180},
        contestType = "Tough"
    },
    fireblast = {num = 126, accuracy = 85, basePower = 110, category = "Special", name = "Fire Blast", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, status = "brn"}, target = "normal", type = "Fire", contestType = "Beautiful"},
    firefang = {num = 424, accuracy = 95, basePower = 65, category = "Physical", name = "Fire Fang", pp = 15, priority = 0, flags = {bite = 1, contact = 1, protect = 1, mirror = 1}, secondaries = {{chance = 10, status = "brn"}, {chance = 10, volatileStatus = "flinch"}}, target = "normal", type = "Fire", contestType = "Cool"},
    firelash = {num = 680, accuracy = 100, basePower = 80, category = "Physical", name = "Fire Lash", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {def = -1}}, target = "normal", type = "Fire", contestType = "Cute"},
    firepledge = {
        num = 519,
        accuracy = 100,
        basePower = 80,
        basePowerCallback = function(self, target, source, move)
            if ({"grasspledge", "waterpledge"}):includes(move.sourceEffect) then
                self:add("-combine")
                return 150
            end
            return 80
        end,
        category = "Special",
        name = "Fire Pledge",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, nonsky = 1},
        onPrepareHit = function(self, target, source, move)
            for ____, action in ipairs(self.queue.list) do
                do
                    if ((((not action.move) or (not action.pokemon.isActive)) or action.pokemon.fainted) or action.maxMove) or action.zmove then
                        goto __continue365
                    end
                    if action.pokemon:isAlly(source) and ({"grasspledge", "waterpledge"}):includes(action.move.id) then
                        self.queue:prioritizeAction(action, move)
                        self:add("-waiting", source, action.pokemon)
                        return nil
                    end
                end
                ::__continue365::
            end
        end,
        onModifyMove = function(self, move)
            if move.sourceEffect == "waterpledge" then
                move.type = "Water"
                move.forceSTAB = true
                move.self = {sideCondition = "waterpledge"}
            end
            if move.sourceEffect == "grasspledge" then
                move.type = "Fire"
                move.forceSTAB = true
                move.sideCondition = "firepledge"
            end
        end,
        condition = {
            duration = 4,
            onSideStart = function(self, targetSide)
                self:add("-sidestart", targetSide, "Fire Pledge")
            end,
            onResidualOrder = 5,
            onResidualSubOrder = 1,
            onResidual = function(self, pokemon)
                if not pokemon:hasType("Fire") then
                    self:damage(pokemon.baseMaxhp / 8, pokemon)
                end
            end,
            onSideResidualOrder = 26,
            onSideResidualSubOrder = 8,
            onSideEnd = function(self, targetSide)
                self:add("-sideend", targetSide, "Fire Pledge")
            end
        },
        secondary = nil,
        target = "normal",
        type = "Fire",
        contestType = "Beautiful"
    },
    firepunch = {num = 7, accuracy = 100, basePower = 75, category = "Physical", name = "Fire Punch", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, secondary = {chance = 10, status = "brn"}, target = "normal", type = "Fire", contestType = "Tough"},
    firespin = {num = 83, accuracy = 85, basePower = 35, category = "Special", name = "Fire Spin", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, volatileStatus = "partiallytrapped", secondary = nil, target = "normal", type = "Fire", contestType = "Beautiful"},
    firstimpression = {
        num = 660,
        accuracy = 100,
        basePower = 90,
        category = "Physical",
        name = "First Impression",
        pp = 10,
        priority = 2,
        flags = {contact = 1, protect = 1, mirror = 1},
        onTry = function(self, source)
            if source.activeMoveActions > 1 then
                self:hint("First Impression only works on your first turn out.")
                return false
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Bug",
        contestType = "Cute"
    },
    fishiousrend = {
        num = 755,
        accuracy = 100,
        basePower = 85,
        basePowerCallback = function(self, pokemon, target, move)
            if target.newlySwitched or self.queue:willMove(target) then
                self:debug("Fishious Rend damage boost")
                return move.basePower * 2
            end
            self:debug("Fishious Rend NOT boosted")
            return move.basePower
        end,
        category = "Physical",
        name = "Fishious Rend",
        pp = 10,
        priority = 0,
        flags = {bite = 1, contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Water"
    },
    fissure = {num = 90, accuracy = 30, basePower = 0, category = "Physical", name = "Fissure", pp = 5, priority = 0, flags = {protect = 1, mirror = 1, nonsky = 1}, ohko = true, secondary = nil, target = "normal", type = "Ground", zMove = {basePower = 180}, maxMove = {basePower = 130}, contestType = "Tough"},
    flail = {
        num = 175,
        accuracy = 100,
        basePower = 0,
        basePowerCallback = function(self, pokemon, target)
            local ratio = (pokemon.hp * 48) / pokemon.maxhp
            if ratio < 2 then
                return 200
            end
            if ratio < 5 then
                return 150
            end
            if ratio < 10 then
                return 100
            end
            if ratio < 17 then
                return 80
            end
            if ratio < 33 then
                return 40
            end
            return 20
        end,
        category = "Physical",
        name = "Flail",
        pp = 15,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {basePower = 160},
        maxMove = {basePower = 130},
        contestType = "Cute"
    },
    flameburst = {
        num = 481,
        accuracy = 100,
        basePower = 70,
        category = "Special",
        isNonstandard = "Past",
        name = "Flame Burst",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onHit = function(self, target, source, move)
            for ____, ally in __TS__Iterator(
                target:adjacentAllies()
            ) do
                self:damage(
                    ally.baseMaxhp / 16,
                    ally,
                    source,
                    self.dex.conditions:get("Flame Burst")
                )
            end
        end,
        onAfterSubDamage = function(self, damage, target, source, move)
            for ____, ally in __TS__Iterator(
                target:adjacentAllies()
            ) do
                self:damage(
                    ally.baseMaxhp / 16,
                    ally,
                    source,
                    self.dex.conditions:get("Flame Burst")
                )
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Fire",
        contestType = "Beautiful"
    },
    flamecharge = {num = 488, accuracy = 100, basePower = 50, category = "Physical", name = "Flame Charge", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 100, self = {boosts = {spe = 1}}}, target = "normal", type = "Fire", contestType = "Cool"},
    flamewheel = {num = 172, accuracy = 100, basePower = 60, category = "Physical", name = "Flame Wheel", pp = 25, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, defrost = 1}, secondary = {chance = 10, status = "brn"}, target = "normal", type = "Fire", contestType = "Beautiful"},
    flamethrower = {num = 53, accuracy = 100, basePower = 90, category = "Special", name = "Flamethrower", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, status = "brn"}, target = "normal", type = "Fire", contestType = "Beautiful"},
    flareblitz = {num = 394, accuracy = 100, basePower = 120, category = "Physical", name = "Flare Blitz", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, defrost = 1}, recoil = {33, 100}, secondary = {chance = 10, status = "brn"}, target = "normal", type = "Fire", contestType = "Cool"},
    flash = {num = 148, accuracy = 100, basePower = 0, category = "Status", isNonstandard = "Past", name = "Flash", pp = 20, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, boosts = {accuracy = -1}, secondary = nil, target = "normal", type = "Normal", zMove = {boost = {evasion = 1}}, contestType = "Beautiful"},
    flashcannon = {num = 430, accuracy = 100, basePower = 80, category = "Special", name = "Flash Cannon", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, boosts = {spd = -1}}, target = "normal", type = "Steel", contestType = "Beautiful"},
    flatter = {num = 260, accuracy = 100, basePower = 0, category = "Status", name = "Flatter", pp = 15, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1}, volatileStatus = "confusion", boosts = {spa = 1}, secondary = nil, target = "normal", type = "Dark", zMove = {boost = {spd = 1}}, contestType = "Clever"},
    fleurcannon = {num = 705, accuracy = 90, basePower = 130, category = "Special", name = "Fleur Cannon", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, self = {boosts = {spa = -2}}, secondary = nil, target = "normal", type = "Fairy", contestType = "Beautiful"},
    fling = {
        num = 374,
        accuracy = 100,
        basePower = 0,
        category = "Physical",
        name = "Fling",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, mystery = 1},
        onPrepareHit = function(self, target, source, move)
            if source:ignoringItem() then
                return false
            end
            local item = source:getItem()
            if not self:singleEvent("TakeItem", item, source.itemState, source, source, move, item) then
                return false
            end
            if not item.fling then
                return false
            end
            move.basePower = item.fling.basePower
            if item.isBerry then
                move.onHit = function(self, foe)
                    if self:singleEvent("Eat", item, nil, foe, nil, nil) then
                        self:runEvent("EatItem", foe, nil, nil, item)
                        if item.id == "leppaberry" then
                            foe.staleness = "external"
                        end
                    end
                    if item.onEat then
                        foe.ateBerry = true
                    end
                end
            elseif item.fling.effect then
                move.onHit = item.fling.effect
            else
                if not move.secondaries then
                    move.secondaries = {}
                end
                if item.fling.status then
                    move.secondaries:push({status = item.fling.status})
                elseif item.fling.volatileStatus then
                    move.secondaries:push({volatileStatus = item.fling.volatileStatus})
                end
            end
            source:addVolatile("fling")
        end,
        condition = {
            onUpdate = function(self, pokemon)
                local item = pokemon:getItem()
                pokemon:setItem("")
                pokemon.lastItem = item.id
                pokemon.usedItemThisTurn = true
                self:add("-enditem", pokemon, item.name, "[from] move: Fling")
                self:runEvent("AfterUseItem", pokemon, nil, nil, item)
                pokemon:removeVolatile("fling")
            end
        },
        secondary = nil,
        target = "normal",
        type = "Dark",
        contestType = "Cute"
    },
    flipturn = {num = 812, accuracy = 100, basePower = 60, category = "Physical", name = "Flip Turn", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, selfSwitch = true, secondary = nil, target = "normal", type = "Water"},
    floatyfall = {num = 731, accuracy = 95, basePower = 90, category = "Physical", isNonstandard = "LGPE", name = "Floaty Fall", pp = 15, priority = 0, flags = {contact = 1, protect = 1, gravity = 1}, secondary = {chance = 30, volatileStatus = "flinch"}, target = "normal", type = "Flying", contestType = "Cool"},
    floralhealing = {
        num = 666,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Floral Healing",
        pp = 10,
        priority = 0,
        flags = {protect = 1, reflectable = 1, heal = 1, mystery = 1},
        onHit = function(self, target, source)
            local success = false
            if self.field:isTerrain("grassyterrain") then
                success = not (not self:heal(
                    self:modify(target.baseMaxhp, 0.667)
                ))
            else
                success = not (not self:heal(
                    math.ceil(target.baseMaxhp * 0.5)
                ))
            end
            if success and (not target:isAlly(source)) then
                target.staleness = "external"
            end
            return success
        end,
        secondary = nil,
        target = "normal",
        type = "Fairy",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Beautiful"
    },
    flowershield = {
        num = 579,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Flower Shield",
        pp = 10,
        priority = 0,
        flags = {distance = 1},
        onHitField = function(self, t, source, move)
            local targets = {}
            for ____, pokemon in __TS__Iterator(
                self:getAllActive()
            ) do
                if pokemon:hasType("Grass") and ((not pokemon.volatiles.maxguard) or self:runEvent("TryHit", pokemon, source, move)) then
                    __TS__ArrayPush(targets, pokemon)
                end
            end
            local success = false
            for ____, target in ipairs(targets) do
                success = self:boost({def = 1}, target, source, move) or success
            end
            return success
        end,
        secondary = nil,
        target = "all",
        type = "Fairy",
        zMove = {boost = {def = 1}},
        contestType = "Beautiful"
    },
    fly = {
        num = 19,
        accuracy = 95,
        basePower = 90,
        category = "Physical",
        name = "Fly",
        pp = 15,
        priority = 0,
        flags = {contact = 1, charge = 1, protect = 1, mirror = 1, gravity = 1, distance = 1},
        onTryMove = function(self, attacker, defender, move)
            if attacker:removeVolatile(move.id) then
                return
            end
            self:add("-prepare", attacker, move.name)
            if not self:runEvent("ChargeMove", attacker, defender, move) then
                return
            end
            attacker:addVolatile("twoturnmove", defender)
            return nil
        end,
        condition = {
            duration = 2,
            onInvulnerability = function(self, target, source, move)
                if ({"gust", "twister", "skyuppercut", "thunder", "hurricane", "smackdown", "thousandarrows"}):includes(move.id) then
                    return
                end
                return false
            end,
            onSourceModifyDamage = function(self, damage, source, target, move)
                if (move.id == "gust") or (move.id == "twister") then
                    return self:chainModify(2)
                end
            end
        },
        secondary = nil,
        target = "any",
        type = "Flying",
        contestType = "Clever"
    },
    flyingpress = {
        num = 560,
        accuracy = 95,
        basePower = 100,
        category = "Physical",
        name = "Flying Press",
        pp = 10,
        flags = {contact = 1, protect = 1, mirror = 1, gravity = 1, distance = 1, nonsky = 1},
        onEffectiveness = function(self, typeMod, target, ____type, move)
            return typeMod + self.dex:getEffectiveness("Flying", ____type)
        end,
        priority = 0,
        secondary = nil,
        target = "any",
        type = "Fighting",
        zMove = {basePower = 170},
        contestType = "Tough"
    },
    focusblast = {num = 411, accuracy = 70, basePower = 120, category = "Special", name = "Focus Blast", pp = 5, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, secondary = {chance = 10, boosts = {spd = -1}}, target = "normal", type = "Fighting", contestType = "Cool"},
    focusenergy = {
        num = 116,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Focus Energy",
        pp = 30,
        priority = 0,
        flags = {snatch = 1},
        volatileStatus = "focusenergy",
        condition = {
            onStart = function(self, target, source, effect)
                if effect.id == "zpower" then
                    self:add("-start", target, "move: Focus Energy", "[zeffect]")
                elseif effect and ({"imposter", "psychup", "transform"}):includes(effect.id) then
                    self:add("-start", target, "move: Focus Energy", "[silent]")
                else
                    self:add("-start", target, "move: Focus Energy")
                end
            end,
            onModifyCritRatio = function(self, critRatio)
                return critRatio + 2
            end
        },
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {boost = {accuracy = 1}},
        contestType = "Cool"
    },
    focuspunch = {
        num = 264,
        accuracy = 100,
        basePower = 150,
        category = "Physical",
        name = "Focus Punch",
        pp = 20,
        priority = -3,
        flags = {contact = 1, protect = 1, punch = 1},
        beforeTurnCallback = function(self, pokemon)
            pokemon:addVolatile("focuspunch")
        end,
        beforeMoveCallback = function(self, pokemon)
            if pokemon.volatiles.focuspunch and pokemon.volatiles.focuspunch.lostFocus then
                self:add("cant", pokemon, "Focus Punch", "Focus Punch")
                return true
            end
        end,
        condition = {
            duration = 1,
            onStart = function(self, pokemon)
                self:add("-singleturn", pokemon, "move: Focus Punch")
            end,
            onHit = function(self, pokemon, source, move)
                if move.category ~= "Status" then
                    pokemon.volatiles.focuspunch.lostFocus = true
                end
            end,
            onTryAddVolatile = function(self, status, pokemon)
                if status.id == "flinch" then
                    return nil
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Fighting",
        contestType = "Tough"
    },
    followme = {
        num = 266,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Follow Me",
        pp = 20,
        priority = 2,
        flags = {},
        volatileStatus = "followme",
        onTry = function(self, source)
            return self.activePerHalf > 1
        end,
        condition = {
            duration = 1,
            onStart = function(self, target, source, effect)
                if effect.id == "zpower" then
                    self:add("-singleturn", target, "move: Follow Me", "[zeffect]")
                else
                    self:add("-singleturn", target, "move: Follow Me")
                end
            end,
            onFoeRedirectTargetPriority = 1,
            onFoeRedirectTarget = function(self, target, source, source2, move)
                if (not self.effectState.target:isSkyDropped()) and self:validTarget(self.effectState.target, source, move.target) then
                    if move.smartTarget then
                        move.smartTarget = false
                    end
                    self:debug("Follow Me redirected target of move")
                    return self.effectState.target
                end
            end
        },
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Cute"
    },
    forcepalm = {num = 395, accuracy = 100, basePower = 60, category = "Physical", name = "Force Palm", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 30, status = "par"}, target = "normal", type = "Fighting", contestType = "Cool"},
    foresight = {
        num = 193,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Foresight",
        pp = 40,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, authentic = 1},
        volatileStatus = "foresight",
        onTryHit = function(self, target)
            if target.volatiles.miracleeye then
                return false
            end
        end,
        condition = {
            noCopy = true,
            onStart = function(self, pokemon)
                self:add("-start", pokemon, "Foresight")
            end,
            onNegateImmunity = function(self, pokemon, ____type)
                if pokemon:hasType("Ghost") and ({"Normal", "Fighting"}):includes(____type) then
                    return false
                end
            end,
            onModifyBoost = function(self, boosts)
                if boosts.evasion and (boosts.evasion > 0) then
                    boosts.evasion = 0
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {effect = "crit2"},
        contestType = "Clever"
    },
    forestscurse = {
        num = 571,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Forest's Curse",
        pp = 20,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1},
        onHit = function(self, target)
            if target:hasType("Grass") then
                return false
            end
            if not target:addType("Grass") then
                return false
            end
            self:add("-start", target, "typeadd", "Grass", "[from] move: Forest's Curse")
        end,
        secondary = nil,
        target = "normal",
        type = "Grass",
        zMove = {boost = {atk = 1, def = 1, spa = 1, spd = 1, spe = 1}},
        contestType = "Clever"
    },
    foulplay = {num = 492, accuracy = 100, basePower = 95, category = "Physical", name = "Foul Play", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, useTargetOffensive = true, secondary = nil, target = "normal", type = "Dark", contestType = "Clever"},
    freezedry = {
        num = 573,
        accuracy = 100,
        basePower = 70,
        category = "Special",
        name = "Freeze-Dry",
        pp = 20,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onEffectiveness = function(self, typeMod, target, ____type)
            if ____type == "Water" then
                return 1
            end
        end,
        secondary = {chance = 10, status = "frz"},
        target = "normal",
        type = "Ice",
        contestType = "Beautiful"
    },
    freezeshock = {
        num = 553,
        accuracy = 90,
        basePower = 140,
        category = "Physical",
        name = "Freeze Shock",
        pp = 5,
        priority = 0,
        flags = {charge = 1, protect = 1, mirror = 1},
        onTryMove = function(self, attacker, defender, move)
            if attacker:removeVolatile(move.id) then
                return
            end
            self:add("-prepare", attacker, move.name)
            if not self:runEvent("ChargeMove", attacker, defender, move) then
                return
            end
            attacker:addVolatile("twoturnmove", defender)
            return nil
        end,
        secondary = {chance = 30, status = "par"},
        target = "normal",
        type = "Ice",
        contestType = "Beautiful"
    },
    freezingglare = {num = 821, accuracy = 100, basePower = 90, category = "Special", name = "Freezing Glare", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, status = "frz"}, target = "normal", type = "Psychic"},
    freezyfrost = {
        num = 739,
        accuracy = 90,
        basePower = 100,
        category = "Special",
        isNonstandard = "LGPE",
        name = "Freezy Frost",
        pp = 10,
        priority = 0,
        flags = {protect = 1},
        onHit = function(self)
            self:add("-clearallboost")
            for ____, pokemon in __TS__Iterator(
                self:getAllActive()
            ) do
                pokemon:clearBoosts()
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Ice",
        contestType = "Clever"
    },
    frenzyplant = {num = 338, accuracy = 90, basePower = 150, category = "Special", name = "Frenzy Plant", pp = 5, priority = 0, flags = {recharge = 1, protect = 1, mirror = 1, nonsky = 1}, self = {volatileStatus = "mustrecharge"}, secondary = nil, target = "normal", type = "Grass", contestType = "Cool"},
    frostbreath = {num = 524, accuracy = 90, basePower = 60, category = "Special", name = "Frost Breath", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, willCrit = true, secondary = nil, target = "normal", type = "Ice", contestType = "Beautiful"},
    frustration = {
        num = 218,
        accuracy = 100,
        basePower = 0,
        basePowerCallback = function(self, pokemon)
            return math.floor(((255 - pokemon.happiness) * 10) / 25) or 1
        end,
        category = "Physical",
        isNonstandard = "Past",
        name = "Frustration",
        pp = 20,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {basePower = 160},
        maxMove = {basePower = 130},
        contestType = "Cute"
    },
    furyattack = {num = 31, accuracy = 85, basePower = 15, category = "Physical", name = "Fury Attack", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, multihit = {2, 5}, secondary = nil, target = "normal", type = "Normal", contestType = "Cool"},
    furycutter = {
        num = 210,
        accuracy = 95,
        basePower = 40,
        basePowerCallback = function(self, pokemon, target, move)
            if (not pokemon.volatiles.furycutter) or (move.hit == 1) then
                pokemon:addVolatile("furycutter")
            end
            return self:clampIntRange(move.basePower * pokemon.volatiles.furycutter.multiplier, 1, 160)
        end,
        category = "Physical",
        name = "Fury Cutter",
        pp = 20,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        condition = {
            duration = 2,
            onStart = function(self)
                self.effectState.multiplier = 1
            end,
            onRestart = function(self)
                if self.effectState.multiplier < 4 then
                    local ____obj, ____index = self.effectState, "multiplier"
                    ____obj[____index] = bit.lshift(____obj[____index], 1)
                end
                self.effectState.duration = 2
            end
        },
        secondary = nil,
        target = "normal",
        type = "Bug",
        contestType = "Cool"
    },
    furyswipes = {num = 154, accuracy = 80, basePower = 18, category = "Physical", name = "Fury Swipes", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, multihit = {2, 5}, secondary = nil, target = "normal", type = "Normal", maxMove = {basePower = 100}, contestType = "Tough"},
    fusionbolt = {
        num = 559,
        accuracy = 100,
        basePower = 100,
        category = "Physical",
        name = "Fusion Bolt",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onBasePower = function(self, basePower, pokemon)
            if self.lastSuccessfulMoveThisTurn == "fusionflare" then
                self:debug("double power")
                return self:chainModify(2)
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Electric",
        contestType = "Cool"
    },
    fusionflare = {
        num = 558,
        accuracy = 100,
        basePower = 100,
        category = "Special",
        name = "Fusion Flare",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1, defrost = 1},
        onBasePower = function(self, basePower, pokemon)
            if self.lastSuccessfulMoveThisTurn == "fusionbolt" then
                self:debug("double power")
                return self:chainModify(2)
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Fire",
        contestType = "Beautiful"
    },
    futuresight = {
        num = 248,
        accuracy = 100,
        basePower = 120,
        category = "Special",
        name = "Future Sight",
        pp = 10,
        priority = 0,
        flags = {},
        ignoreImmunity = true,
        isFutureMove = true,
        onTry = function(self, source, target)
            if not target.side:addSlotCondition(target, "futuremove") then
                return false
            end
            __TS__ObjectAssign(target.side.slotConditions[target.position].futuremove, {duration = 3, move = "futuresight", source = source, moveData = {id = "futuresight", name = "Future Sight", accuracy = 100, basePower = 120, category = "Special", priority = 0, flags = {}, ignoreImmunity = false, effectType = "Move", isFutureMove = true, type = "Psychic"}})
            self:add("-start", source, "move: Future Sight")
            return self.NOT_FAIL
        end,
        secondary = nil,
        target = "normal",
        type = "Psychic",
        contestType = "Clever"
    },
    gastroacid = {
        num = 380,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Gastro Acid",
        pp = 10,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1},
        volatileStatus = "gastroacid",
        onTryHit = function(self, target)
            if target:getAbility().isPermanent then
                return false
            end
        end,
        condition = {
            onStart = function(self, pokemon)
                self:add("-endability", pokemon)
                self:singleEvent(
                    "End",
                    pokemon:getAbility(),
                    pokemon.abilityState,
                    pokemon,
                    pokemon,
                    "gastroacid"
                )
            end,
            onCopy = function(self, pokemon)
                if pokemon:getAbility().isPermanent then
                    pokemon:removeVolatile("gastroacid")
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Poison",
        zMove = {boost = {spe = 1}},
        contestType = "Tough"
    },
    geargrind = {num = 544, accuracy = 85, basePower = 50, category = "Physical", name = "Gear Grind", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, multihit = 2, secondary = nil, target = "normal", type = "Steel", zMove = {basePower = 180}, maxMove = {basePower = 130}, contestType = "Clever"},
    gearup = {
        num = 674,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Gear Up",
        pp = 20,
        priority = 0,
        flags = {snatch = 1, authentic = 1},
        onHitSide = function(self, side, source, move)
            local targets = side:allies():filter(
                function(____, target) return target:hasAbility({"plus", "minus"}) and ((not target.volatiles.maxguard) or self:runEvent("TryHit", target, source, move)) end
            )
            if not targets.length then
                return false
            end
            local didSomething = false
            for ____, target in __TS__Iterator(targets) do
                didSomething = self:boost({atk = 1, spa = 1}, target, source, move, false, true) or didSomething
            end
            return didSomething
        end,
        secondary = nil,
        target = "allySide",
        type = "Steel",
        zMove = {boost = {spa = 1}},
        contestType = "Clever"
    },
    genesissupernova = {
        num = 703,
        accuracy = true,
        basePower = 185,
        category = "Special",
        isNonstandard = "Past",
        name = "Genesis Supernova",
        pp = 1,
        priority = 0,
        flags = {},
        isZ = "mewniumz",
        secondary = {
            chance = 100,
            self = {
                onHit = function(self)
                    self.field:setTerrain("psychicterrain")
                end
            }
        },
        target = "normal",
        type = "Psychic",
        contestType = "Cool"
    },
    geomancy = {
        num = 601,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Geomancy",
        pp = 10,
        priority = 0,
        flags = {charge = 1, nonsky = 1},
        onTryMove = function(self, attacker, defender, move)
            if attacker:removeVolatile(move.id) then
                return
            end
            self:add("-prepare", attacker, move.name)
            if not self:runEvent("ChargeMove", attacker, defender, move) then
                return
            end
            attacker:addVolatile("twoturnmove", defender)
            return nil
        end,
        boosts = {spa = 2, spd = 2, spe = 2},
        secondary = nil,
        target = "self",
        type = "Fairy",
        zMove = {boost = {atk = 1, def = 1, spa = 1, spd = 1, spe = 1}},
        contestType = "Beautiful"
    },
    gigadrain = {num = 202, accuracy = 100, basePower = 75, category = "Special", name = "Giga Drain", pp = 10, priority = 0, flags = {protect = 1, mirror = 1, heal = 1}, drain = {1, 2}, secondary = nil, target = "normal", type = "Grass", contestType = "Clever"},
    gigaimpact = {num = 416, accuracy = 90, basePower = 150, category = "Physical", name = "Giga Impact", pp = 5, priority = 0, flags = {contact = 1, recharge = 1, protect = 1, mirror = 1}, self = {volatileStatus = "mustrecharge"}, secondary = nil, target = "normal", type = "Normal", contestType = "Tough"},
    gigavolthavoc = {num = 646, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Gigavolt Havoc", pp = 1, priority = 0, flags = {}, isZ = "electriumz", secondary = nil, target = "normal", type = "Electric", contestType = "Cool"},
    glaciallance = {num = 824, accuracy = 100, basePower = 130, category = "Physical", name = "Glacial Lance", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "allAdjacentFoes", type = "Ice"},
    glaciate = {num = 549, accuracy = 95, basePower = 65, category = "Special", name = "Glaciate", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {spe = -1}}, target = "allAdjacentFoes", type = "Ice", contestType = "Beautiful"},
    glare = {num = 137, accuracy = 100, basePower = 0, category = "Status", name = "Glare", pp = 30, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, status = "par", secondary = nil, target = "normal", type = "Normal", zMove = {boost = {spd = 1}}, contestType = "Tough"},
    glitzyglow = {num = 736, accuracy = 95, basePower = 80, category = "Special", isNonstandard = "LGPE", name = "Glitzy Glow", pp = 15, priority = 0, flags = {protect = 1}, self = {sideCondition = "lightscreen"}, secondary = nil, target = "normal", type = "Psychic", contestType = "Clever"},
    gmaxbefuddle = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Befuddle",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Butterfree",
        self = {
            onHit = function(self, source)
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    local result = self:random(3)
                    if result == 0 then
                        pokemon:trySetStatus("slp", source)
                    elseif result == 1 then
                        pokemon:trySetStatus("par", source)
                    else
                        pokemon:trySetStatus("psn", source)
                    end
                end
            end
        },
        target = "adjacentFoe",
        type = "Bug",
        contestType = "Cool"
    },
    gmaxcannonade = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Cannonade",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = "Blastoise",
        self = {
            onHit = function(self, source)
                for ____, side in __TS__Iterator(
                    source.side:foeSidesWithConditions()
                ) do
                    side:addSideCondition("gmaxcannonade")
                end
            end
        },
        condition = {
            duration = 4,
            onSideStart = function(self, targetSide)
                self:add("-sidestart", targetSide, "G-Max Cannonade")
            end,
            onResidualOrder = 5,
            onResidualSubOrder = 1,
            onResidual = function(self, target)
                if not target:hasType("Water") then
                    self:damage(target.baseMaxhp / 6, target)
                end
            end,
            onSideResidualOrder = 26,
            onSideResidualSubOrder = 11,
            onSideEnd = function(self, targetSide)
                self:add("-sideend", targetSide, "G-Max Cannonade")
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Water",
        contestType = "Cool"
    },
    gmaxcentiferno = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Centiferno",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Centiskorch",
        self = {
            onHit = function(self, source)
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    pokemon:addVolatile(
                        "partiallytrapped",
                        source,
                        self.dex:getActiveMove("G-Max Centiferno")
                    )
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Fire",
        contestType = "Cool"
    },
    gmaxchistrike = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Chi Strike",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Machamp",
        self = {
            onHit = function(self, source)
                for ____, pokemon in __TS__Iterator(
                    source:alliesAndSelf()
                ) do
                    pokemon:addVolatile("gmaxchistrike")
                end
            end
        },
        condition = {
            noCopy = true,
            onStart = function(self, target, source, effect)
                self.effectState.layers = 1
                if not ({"imposter", "psychup", "transform"}):includes(effect.id) then
                    self:add("-start", target, "move: G-Max Chi Strike")
                end
            end,
            onRestart = function(self, target, source, effect)
                if self.effectState.layers >= 3 then
                    return false
                end
                local ____obj, ____index = self.effectState, "layers"
                ____obj[____index] = ____obj[____index] + 1
                if not ({"imposter", "psychup", "transform"}):includes(effect.id) then
                    self:add("-start", target, "move: G-Max Chi Strike")
                end
            end,
            onModifyCritRatio = function(self, critRatio)
                return critRatio + self.effectState.layers
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Fighting",
        contestType = "Cool"
    },
    gmaxcuddle = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Cuddle",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Eevee",
        self = {
            onHit = function(self, source)
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    pokemon:addVolatile("attract")
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Normal",
        contestType = "Cool"
    },
    gmaxdepletion = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Depletion",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Duraludon",
        self = {
            onHit = function(self, source)
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    do
                        local move = pokemon.lastMove
                        if (not move) or move.isZ then
                            goto __continue506
                        end
                        if move.isMax and move.baseMove then
                            move = self.dex.moves:get(move.baseMove)
                        end
                        local ppDeducted = pokemon:deductPP(move.id, 2)
                        if ppDeducted then
                            self:add("-activate", pokemon, "move: G-Max Depletion", move.name, ppDeducted)
                        end
                    end
                    ::__continue506::
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Dragon",
        contestType = "Cool"
    },
    gmaxdrumsolo = {num = 1000, accuracy = true, basePower = 160, category = "Physical", isNonstandard = "Gigantamax", name = "G-Max Drum Solo", pp = 5, priority = 0, flags = {}, isMax = "Rillaboom", ignoreAbility = true, secondary = nil, target = "adjacentFoe", type = "Grass", contestType = "Cool"},
    gmaxfinale = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Finale",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Alcremie",
        self = {
            onHit = function(self, target, source, move)
                for ____, pokemon in __TS__Iterator(
                    source:alliesAndSelf()
                ) do
                    self:heal(pokemon.maxhp / 6, pokemon, source, move)
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Fairy",
        contestType = "Cool"
    },
    gmaxfireball = {num = 1000, accuracy = true, basePower = 160, category = "Physical", isNonstandard = "Gigantamax", name = "G-Max Fireball", pp = 5, priority = 0, flags = {}, isMax = "Cinderace", ignoreAbility = true, secondary = nil, target = "adjacentFoe", type = "Fire", contestType = "Cool"},
    gmaxfoamburst = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Foam Burst",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Kingler",
        self = {
            onHit = function(self, source)
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    self:boost({spe = -2}, pokemon)
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Water",
        contestType = "Cool"
    },
    gmaxgoldrush = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Gold Rush",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Meowth",
        self = {
            onHit = function(self, source)
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    pokemon:addVolatile("confusion")
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Normal",
        contestType = "Cool"
    },
    gmaxgravitas = {num = 1000, accuracy = true, basePower = 10, category = "Physical", isNonstandard = "Gigantamax", name = "G-Max Gravitas", pp = 5, priority = 0, flags = {}, isMax = "Orbeetle", self = {pseudoWeather = "gravity"}, target = "adjacentFoe", type = "Psychic", contestType = "Cool"},
    gmaxhydrosnipe = {num = 1000, accuracy = true, basePower = 160, category = "Physical", isNonstandard = "Gigantamax", name = "G-Max Hydrosnipe", pp = 5, priority = 0, flags = {}, isMax = "Inteleon", ignoreAbility = true, secondary = nil, target = "adjacentFoe", type = "Water", contestType = "Cool"},
    gmaxmalodor = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Malodor",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Garbodor",
        self = {
            onHit = function(self, source)
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    pokemon:trySetStatus("psn", source)
                end
            end
        },
        target = "adjacentFoe",
        type = "Poison",
        contestType = "Cool"
    },
    gmaxmeltdown = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Meltdown",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Melmetal",
        self = {
            onHit = function(self, source)
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    if not pokemon.volatiles.dynamax then
                        pokemon:addVolatile("torment")
                    end
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Steel",
        contestType = "Cool"
    },
    gmaxoneblow = {num = 1000, accuracy = true, basePower = 10, category = "Physical", isNonstandard = "Gigantamax", name = "G-Max One Blow", pp = 5, priority = 0, flags = {}, isMax = "Urshifu", secondary = nil, target = "adjacentFoe", type = "Dark", contestType = "Cool"},
    gmaxrapidflow = {num = 1000, accuracy = true, basePower = 10, category = "Physical", isNonstandard = "Gigantamax", name = "G-Max Rapid Flow", pp = 5, priority = 0, flags = {}, isMax = "Urshifu-Rapid-Strike", secondary = nil, target = "adjacentFoe", type = "Water", contestType = "Cool"},
    gmaxreplenish = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Replenish",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Snorlax",
        self = {
            onHit = function(self, source)
                if self:random(2) == 0 then
                    return
                end
                for ____, pokemon in __TS__Iterator(
                    source:alliesAndSelf()
                ) do
                    do
                        if pokemon.item then
                            goto __continue523
                        end
                        if pokemon.lastItem and self.dex.items:get(pokemon.lastItem).isBerry then
                            local item = pokemon.lastItem
                            pokemon.lastItem = ""
                            self:add(
                                "-item",
                                pokemon,
                                self.dex.items:get(item),
                                "[from] move: G-Max Replenish"
                            )
                            pokemon:setItem(item)
                        end
                    end
                    ::__continue523::
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Normal",
        contestType = "Cool"
    },
    gmaxresonance = {num = 1000, accuracy = true, basePower = 10, category = "Physical", isNonstandard = "Gigantamax", name = "G-Max Resonance", pp = 5, priority = 0, flags = {}, isMax = "Lapras", self = {sideCondition = "auroraveil"}, secondary = nil, target = "adjacentFoe", type = "Ice", contestType = "Cool"},
    gmaxsandblast = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Sandblast",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Sandaconda",
        self = {
            onHit = function(self, source)
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    pokemon:addVolatile(
                        "partiallytrapped",
                        source,
                        self.dex:getActiveMove("G-Max Sandblast")
                    )
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Ground",
        contestType = "Cool"
    },
    gmaxsmite = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Smite",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Hatterene",
        self = {
            onHit = function(self, source)
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    pokemon:addVolatile("confusion", source)
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Fairy",
        contestType = "Cool"
    },
    gmaxsnooze = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Snooze",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Grimmsnarl",
        onHit = function(self, target)
            if target.status or (not target:runStatusImmunity("slp")) then
                return
            end
            if self:random(2) == 0 then
                return
            end
            target:addVolatile("yawn")
        end,
        onAfterSubDamage = function(self, damage, target)
            if target.status or (not target:runStatusImmunity("slp")) then
                return
            end
            if self:random(2) == 0 then
                return
            end
            target:addVolatile("yawn")
        end,
        secondary = nil,
        target = "adjacentFoe",
        type = "Dark",
        contestType = "Cool"
    },
    gmaxsteelsurge = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Steelsurge",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Copperajah",
        self = {
            onHit = function(self, source)
                for ____, side in __TS__Iterator(
                    source.side:foeSidesWithConditions()
                ) do
                    side:addSideCondition("gmaxsteelsurge")
                end
            end
        },
        condition = {
            onSideStart = function(self, side)
                self:add("-sidestart", side, "move: G-Max Steelsurge")
            end,
            onSwitchIn = function(self, pokemon)
                if pokemon:hasItem("heavydutyboots") then
                    return
                end
                local steelHazard = self.dex:getActiveMove("Stealth Rock")
                steelHazard.type = "Steel"
                local typeMod = self:clampIntRange(
                    pokemon:runEffectiveness(steelHazard),
                    -6,
                    6
                )
                self:damage(
                    (pokemon.maxhp * math.pow(2, typeMod)) / 8
                )
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Steel",
        contestType = "Cool"
    },
    gmaxstonesurge = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Stonesurge",
        pp = 5,
        priority = 0,
        flags = {},
        isMax = "Drednaw",
        self = {
            onHit = function(self, source)
                for ____, side in __TS__Iterator(
                    source.side:foeSidesWithConditions()
                ) do
                    side:addSideCondition("stealthrock")
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Water",
        contestType = "Cool"
    },
    gmaxstunshock = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Stun Shock",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = "Toxtricity",
        self = {
            onHit = function(self, source)
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    local result = self:random(2)
                    if result == 0 then
                        pokemon:trySetStatus("par", source)
                    else
                        pokemon:trySetStatus("psn", source)
                    end
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Electric",
        contestType = "Cool"
    },
    gmaxsweetness = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Sweetness",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = "Appletun",
        self = {
            onHit = function(self, source)
                for ____, ally in __TS__Iterator(source.side.pokemon) do
                    ally:cureStatus()
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Grass",
        contestType = "Cool"
    },
    gmaxtartness = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Tartness",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = "Flapple",
        self = {
            onHit = function(self, source)
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    self:boost({evasion = -1}, pokemon)
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Grass",
        contestType = "Cool"
    },
    gmaxterror = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Terror",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = "Gengar",
        self = {
            onHit = function(self, source)
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    pokemon:addVolatile("trapped", source, nil, "trapper")
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Ghost",
        contestType = "Cool"
    },
    gmaxvinelash = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Vine Lash",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = "Venusaur",
        self = {
            onHit = function(self, source)
                for ____, side in __TS__Iterator(
                    source.side:foeSidesWithConditions()
                ) do
                    side:addSideCondition("gmaxvinelash")
                end
            end
        },
        condition = {
            duration = 4,
            onSideStart = function(self, targetSide)
                self:add("-sidestart", targetSide, "G-Max Vine Lash")
            end,
            onResidualOrder = 5,
            onResidualSubOrder = 1,
            onResidual = function(self, target)
                if not target:hasType("Grass") then
                    self:damage(target.baseMaxhp / 6, target)
                end
            end,
            onSideResidualOrder = 26,
            onSideResidualSubOrder = 11,
            onSideEnd = function(self, targetSide)
                self:add("-sideend", targetSide, "G-Max Vine Lash")
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Grass",
        contestType = "Cool"
    },
    gmaxvolcalith = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Volcalith",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = "Coalossal",
        self = {
            onHit = function(self, source)
                for ____, side in __TS__Iterator(
                    source.side:foeSidesWithConditions()
                ) do
                    side:addSideCondition("gmaxvolcalith")
                end
            end
        },
        condition = {
            duration = 4,
            onSideStart = function(self, targetSide)
                self:add("-sidestart", targetSide, "G-Max Volcalith")
            end,
            onResidualOrder = 5,
            onResidualSubOrder = 1,
            onResidual = function(self, target)
                if not target:hasType("Rock") then
                    self:damage(target.baseMaxhp / 6, target)
                end
            end,
            onSideResidualOrder = 26,
            onSideResidualSubOrder = 11,
            onSideEnd = function(self, targetSide)
                self:add("-sideend", targetSide, "G-Max Volcalith")
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Rock",
        contestType = "Cool"
    },
    gmaxvoltcrash = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Volt Crash",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = "Pikachu",
        self = {
            onHit = function(self, source)
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    pokemon:trySetStatus("par", source)
                end
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Electric",
        contestType = "Cool"
    },
    gmaxwildfire = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Wildfire",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = "Charizard",
        self = {
            onHit = function(self, source)
                for ____, side in __TS__Iterator(
                    source.side:foeSidesWithConditions()
                ) do
                    side:addSideCondition("gmaxwildfire")
                end
            end
        },
        condition = {
            duration = 4,
            onSideStart = function(self, targetSide)
                self:add("-sidestart", targetSide, "G-Max Wildfire")
            end,
            onResidualOrder = 5,
            onResidualSubOrder = 1,
            onResidual = function(self, target)
                if not target:hasType("Fire") then
                    self:damage(target.baseMaxhp / 6, target)
                end
            end,
            onSideResidualOrder = 26,
            onSideResidualSubOrder = 11,
            onSideEnd = function(self, targetSide)
                self:add("-sideend", targetSide, "G-Max Wildfire")
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Fire",
        contestType = "Cool"
    },
    gmaxwindrage = {
        num = 1000,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        isNonstandard = "Gigantamax",
        name = "G-Max Wind Rage",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = "Corviknight",
        self = {
            onHit = function(self, source)
                local success = false
                local removeTarget = {"reflect", "lightscreen", "auroraveil", "safeguard", "mist", "spikes", "toxicspikes", "stealthrock", "stickyweb"}
                local removeAll = {"spikes", "toxicspikes", "stealthrock", "stickyweb", "gmaxsteelsurge"}
                for ____, targetCondition in ipairs(removeTarget) do
                    do
                        if source.side.foe:removeSideCondition(targetCondition) then
                            if not removeAll:includes(targetCondition) then
                                goto __continue574
                            end
                            self:add(
                                "-sideend",
                                source.side.foe,
                                self.dex.conditions:get(targetCondition).name,
                                "[from] move: G-Max Wind Rage",
                                "[of] " .. tostring(source)
                            )
                            success = true
                        end
                    end
                    ::__continue574::
                end
                for ____, sideCondition in ipairs(removeAll) do
                    if source.side:removeSideCondition(sideCondition) then
                        self:add(
                            "-sideend",
                            source.side,
                            self.dex.conditions:get(sideCondition).name,
                            "[from] move: G-Max Wind Rage",
                            "[of] " .. tostring(source)
                        )
                        success = true
                    end
                end
                self.field:clearTerrain()
                return success
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Flying",
        contestType = "Cool"
    },
    grassknot = {
        num = 447,
        accuracy = 100,
        basePower = 0,
        basePowerCallback = function(self, pokemon, target)
            local targetWeight = target:getWeight()
            if targetWeight >= 2000 then
                self:debug("120 bp")
                return 120
            end
            if targetWeight >= 1000 then
                self:debug("100 bp")
                return 100
            end
            if targetWeight >= 500 then
                self:debug("80 bp")
                return 80
            end
            if targetWeight >= 250 then
                self:debug("60 bp")
                return 60
            end
            if targetWeight >= 100 then
                self:debug("40 bp")
                return 40
            end
            self:debug("20 bp")
            return 20
        end,
        category = "Special",
        name = "Grass Knot",
        pp = 20,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1, nonsky = 1},
        onTryHit = function(self, target, source, move)
            if target.volatiles.dynamax then
                self:add("-fail", source, "move: Grass Knot", "[from] Dynamax")
                self:attrLastMove("[still]")
                return nil
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Grass",
        zMove = {basePower = 160},
        maxMove = {basePower = 130},
        contestType = "Cute"
    },
    grasspledge = {
        num = 520,
        accuracy = 100,
        basePower = 80,
        basePowerCallback = function(self, target, source, move)
            if ({"waterpledge", "firepledge"}):includes(move.sourceEffect) then
                self:add("-combine")
                return 150
            end
            return 80
        end,
        category = "Special",
        name = "Grass Pledge",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, nonsky = 1},
        onPrepareHit = function(self, target, source, move)
            for ____, action in ipairs(self.queue.list) do
                do
                    if ((((not action.move) or (not action.pokemon.isActive)) or action.pokemon.fainted) or action.maxMove) or action.zmove then
                        goto __continue590
                    end
                    if action.pokemon:isAlly(source) and ({"waterpledge", "firepledge"}):includes(action.move.id) then
                        self.queue:prioritizeAction(action, move)
                        self:add("-waiting", source, action.pokemon)
                        return nil
                    end
                end
                ::__continue590::
            end
        end,
        onModifyMove = function(self, move)
            if move.sourceEffect == "waterpledge" then
                move.type = "Grass"
                move.forceSTAB = true
                move.sideCondition = "grasspledge"
            end
            if move.sourceEffect == "firepledge" then
                move.type = "Fire"
                move.forceSTAB = true
                move.sideCondition = "firepledge"
            end
        end,
        condition = {
            duration = 4,
            onSideStart = function(self, targetSide)
                self:add("-sidestart", targetSide, "Grass Pledge")
            end,
            onSideResidualOrder = 26,
            onSideResidualSubOrder = 9,
            onSideEnd = function(self, targetSide)
                self:add("-sideend", targetSide, "Grass Pledge")
            end,
            onModifySpe = function(self, spe, pokemon)
                return self:chainModify(0.25)
            end
        },
        secondary = nil,
        target = "normal",
        type = "Grass",
        contestType = "Beautiful"
    },
    grasswhistle = {num = 320, accuracy = 55, basePower = 0, category = "Status", isNonstandard = "Past", name = "Grass Whistle", pp = 15, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1, sound = 1, authentic = 1}, status = "slp", secondary = nil, target = "normal", type = "Grass", zMove = {boost = {spe = 1}}, contestType = "Clever"},
    grassyglide = {
        num = 803,
        accuracy = 100,
        basePower = 70,
        category = "Physical",
        name = "Grassy Glide",
        pp = 20,
        priority = 0,
        flags = {contact = 1, protect = 1, mystery = 1},
        onModifyPriority = function(self, priority, source, target, move)
            if self.field:isTerrain("grassyterrain") and source:isGrounded() then
                return priority + 1
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Grass",
        contestType = "Cool"
    },
    grassyterrain = {
        num = 580,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Grassy Terrain",
        pp = 10,
        priority = 0,
        flags = {nonsky = 1},
        terrain = "grassyterrain",
        condition = {
            duration = 5,
            durationCallback = function(self, source, effect)
                if source:hasItem("terrainextender") then
                    return 8
                end
                return 5
            end,
            onBasePowerPriority = 6,
            onBasePower = function(self, basePower, attacker, defender, move)
                local weakenedMoves = {"earthquake", "bulldoze", "magnitude"}
                if (weakenedMoves:includes(move.id) and defender:isGrounded()) and (not defender:isSemiInvulnerable()) then
                    self:debug("move weakened by grassy terrain")
                    return self:chainModify(0.5)
                end
                if (move.type == "Grass") and attacker:isGrounded() then
                    self:debug("grassy terrain boost")
                    return self:chainModify({5325, 4096})
                end
            end,
            onFieldStart = function(self, field, source, effect)
                if effect.effectType == "Ability" then
                    self:add(
                        "-fieldstart",
                        "move: Grassy Terrain",
                        "[from] ability: " .. tostring(effect),
                        "[of] " .. tostring(source)
                    )
                else
                    self:add("-fieldstart", "move: Grassy Terrain")
                end
            end,
            onResidualOrder = 5,
            onResidualSubOrder = 2,
            onResidual = function(self, pokemon)
                if pokemon:isGrounded() and (not pokemon:isSemiInvulnerable()) then
                    self:heal(pokemon.baseMaxhp / 16, pokemon, pokemon)
                else
                    self:debug("Pokemon semi-invuln or not grounded; Grassy Terrain skipped")
                end
            end,
            onFieldResidualOrder = 27,
            onFieldResidualSubOrder = 7,
            onFieldEnd = function(self)
                self:add("-fieldend", "move: Grassy Terrain")
            end
        },
        secondary = nil,
        target = "all",
        type = "Grass",
        zMove = {boost = {def = 1}},
        contestType = "Beautiful"
    },
    gravapple = {
        num = 788,
        accuracy = 100,
        basePower = 80,
        category = "Physical",
        name = "Grav Apple",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onBasePower = function(self, basePower)
            if self.field:getPseudoWeather("gravity") then
                return self:chainModify(1.5)
            end
        end,
        secondary = {chance = 100, boosts = {def = -1}},
        target = "normal",
        type = "Grass"
    },
    gravity = {
        num = 356,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Gravity",
        pp = 5,
        priority = 0,
        flags = {nonsky = 1},
        pseudoWeather = "gravity",
        condition = {
            duration = 5,
            durationCallback = function(self, source, effect)
                if source:hasAbility("persistent") then
                    self:add("-activate", source, "ability: Persistent", effect)
                    return 7
                end
                return 5
            end,
            onFieldStart = function(self)
                self:add("-fieldstart", "move: Gravity")
                for ____, pokemon in __TS__Iterator(
                    self:getAllActive()
                ) do
                    local applies = false
                    if pokemon:removeVolatile("bounce") or pokemon:removeVolatile("fly") then
                        applies = true
                        self.queue:cancelMove(pokemon)
                        pokemon:removeVolatile("twoturnmove")
                    end
                    if pokemon.volatiles.skydrop then
                        applies = true
                        self.queue:cancelMove(pokemon)
                        if pokemon.volatiles.skydrop.source then
                            self:add("-end", pokemon.volatiles.twoturnmove.source, "Sky Drop", "[interrupt]")
                        end
                        pokemon:removeVolatile("skydrop")
                        pokemon:removeVolatile("twoturnmove")
                    end
                    if pokemon.volatiles.magnetrise then
                        applies = true
                        __TS__Delete(pokemon.volatiles, "magnetrise")
                    end
                    if pokemon.volatiles.telekinesis then
                        applies = true
                        __TS__Delete(pokemon.volatiles, "telekinesis")
                    end
                    if applies then
                        self:add("-activate", pokemon, "move: Gravity")
                    end
                end
            end,
            onModifyAccuracy = function(self, accuracy)
                if type(accuracy) ~= "number" then
                    return
                end
                return self:chainModify({6840, 4096})
            end,
            onDisableMove = function(self, pokemon)
                for ____, moveSlot in __TS__Iterator(pokemon.moveSlots) do
                    if self.dex.moves:get(moveSlot.id).flags.gravity then
                        pokemon:disableMove(moveSlot.id)
                    end
                end
            end,
            onBeforeMovePriority = 6,
            onBeforeMove = function(self, pokemon, target, move)
                if move.flags.gravity and (not move.isZ) then
                    self:add("cant", pokemon, "move: Gravity", move)
                    return false
                end
            end,
            onModifyMove = function(self, move, pokemon, target)
                if move.flags.gravity and (not move.isZ) then
                    self:add("cant", pokemon, "move: Gravity", move)
                    return false
                end
            end,
            onFieldResidualOrder = 27,
            onFieldResidualSubOrder = 2,
            onFieldEnd = function(self)
                self:add("-fieldend", "move: Gravity")
            end
        },
        secondary = nil,
        target = "all",
        type = "Psychic",
        zMove = {boost = {spa = 1}},
        contestType = "Clever"
    },
    growl = {num = 45, accuracy = 100, basePower = 0, category = "Status", name = "Growl", pp = 40, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1, sound = 1, authentic = 1}, boosts = {atk = -1}, secondary = nil, target = "allAdjacentFoes", type = "Normal", zMove = {boost = {def = 1}}, contestType = "Cute"},
    growth = {
        num = 74,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Growth",
        pp = 20,
        priority = 0,
        flags = {snatch = 1},
        onModifyMove = function(self, move, pokemon)
            if ({"sunnyday", "desolateland"}):includes(
                pokemon:effectiveWeather()
            ) then
                move.boosts = {atk = 2, spa = 2}
            end
        end,
        boosts = {atk = 1, spa = 1},
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {boost = {spa = 1}},
        contestType = "Beautiful"
    },
    grudge = {
        num = 288,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Grudge",
        pp = 5,
        priority = 0,
        flags = {authentic = 1},
        volatileStatus = "grudge",
        condition = {
            onStart = function(self, pokemon)
                self:add("-singlemove", pokemon, "Grudge")
            end,
            onFaint = function(self, target, source, effect)
                if ((not source) or source.fainted) or (not effect) then
                    return
                end
                if ((effect.effectType == "Move") and (not effect.isFutureMove)) and source.lastMove then
                    local move = source.lastMove
                    if move.isMax and move.baseMove then
                        move = self.dex.moves:get(move.baseMove)
                    end
                    for ____, moveSlot in __TS__Iterator(source.moveSlots) do
                        if moveSlot.id == move.id then
                            moveSlot.pp = 0
                            self:add("-activate", source, "move: Grudge", move.name)
                        end
                    end
                end
            end,
            onBeforeMovePriority = 100,
            onBeforeMove = function(self, pokemon)
                self:debug("removing Grudge before attack")
                pokemon:removeVolatile("grudge")
            end
        },
        secondary = nil,
        target = "self",
        type = "Ghost",
        zMove = {effect = "redirect"},
        contestType = "Tough"
    },
    guardianofalola = {
        num = 698,
        accuracy = true,
        basePower = 0,
        damageCallback = function(self, pokemon, target)
            local hp75 = math.floor(
                (target:getUndynamaxedHP() * 3) / 4
            )
            if (((target.volatiles.protect or target.volatiles.banefulbunker) or target.volatiles.kingsshield) or target.volatiles.spikyshield) or target.side:getSideCondition("matblock") then
                self:add("-zbroken", target)
                return self:clampIntRange(
                    math.ceil((hp75 / 4) - 0.5),
                    1
                )
            end
            return self:clampIntRange(hp75, 1)
        end,
        category = "Special",
        isNonstandard = "Past",
        name = "Guardian of Alola",
        pp = 1,
        priority = 0,
        flags = {},
        isZ = "tapuniumz",
        secondary = nil,
        target = "normal",
        type = "Fairy",
        contestType = "Tough"
    },
    guardsplit = {
        num = 470,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Guard Split",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mystery = 1},
        onHit = function(self, target, source)
            local newdef = math.floor((target.storedStats.def + source.storedStats.def) / 2)
            target.storedStats.def = newdef
            source.storedStats.def = newdef
            local newspd = math.floor((target.storedStats.spd + source.storedStats.spd) / 2)
            target.storedStats.spd = newspd
            source.storedStats.spd = newspd
            self:add(
                "-activate",
                source,
                "move: Guard Split",
                "[of] " .. tostring(target)
            )
        end,
        secondary = nil,
        target = "normal",
        type = "Psychic",
        zMove = {boost = {spe = 1}},
        contestType = "Clever"
    },
    guardswap = {
        num = 385,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Guard Swap",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, authentic = 1, mystery = 1},
        onHit = function(self, target, source)
            local targetBoosts = {}
            local sourceBoosts = {}
            local defSpd = {"def", "spd"}
            for ____, stat in ipairs(defSpd) do
                targetBoosts[stat] = target.boosts[stat]
                sourceBoosts[stat] = source.boosts[stat]
            end
            source:setBoost(targetBoosts)
            target:setBoost(sourceBoosts)
            self:add("-swapboost", source, target, "def, spd", "[from] move: Guard Swap")
        end,
        secondary = nil,
        target = "normal",
        type = "Psychic",
        zMove = {boost = {spe = 1}},
        contestType = "Clever"
    },
    guillotine = {num = 12, accuracy = 30, basePower = 0, category = "Physical", name = "Guillotine", pp = 5, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, ohko = true, secondary = nil, target = "normal", type = "Normal", zMove = {basePower = 180}, maxMove = {basePower = 130}, contestType = "Cool"},
    gunkshot = {num = 441, accuracy = 80, basePower = 120, category = "Physical", name = "Gunk Shot", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 30, status = "psn"}, target = "normal", type = "Poison", contestType = "Tough"},
    gust = {num = 16, accuracy = 100, basePower = 40, category = "Special", name = "Gust", pp = 35, priority = 0, flags = {protect = 1, mirror = 1, distance = 1}, secondary = nil, target = "any", type = "Flying", contestType = "Clever"},
    gyroball = {
        num = 360,
        accuracy = 100,
        basePower = 0,
        basePowerCallback = function(self, pokemon, target)
            local power = math.floor(
                (25 * target:getStat("spe")) / pokemon:getStat("spe")
            ) + 1
            if not __TS__NumberIsFinite(
                __TS__Number(power)
            ) then
                power = 1
            end
            if power > 150 then
                power = 150
            end
            self:debug(
                tostring(power) .. " bp"
            )
            return power
        end,
        category = "Physical",
        name = "Gyro Ball",
        pp = 5,
        priority = 0,
        flags = {bullet = 1, contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Steel",
        zMove = {basePower = 160},
        maxMove = {basePower = 130},
        contestType = "Cool"
    },
    hail = {num = 258, accuracy = true, basePower = 0, category = "Status", name = "Hail", pp = 10, priority = 0, flags = {}, weather = "hail", secondary = nil, target = "all", type = "Ice", zMove = {boost = {spe = 1}}, contestType = "Beautiful"},
    hammerarm = {num = 359, accuracy = 90, basePower = 100, category = "Physical", name = "Hammer Arm", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, self = {boosts = {spe = -1}}, secondary = nil, target = "normal", type = "Fighting", contestType = "Tough"},
    happyhour = {
        num = 603,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Happy Hour",
        pp = 30,
        priority = 0,
        flags = {},
        onTryHit = function(self, target, source)
            self:add("-activate", target, "move: Happy Hour")
        end,
        secondary = nil,
        target = "allySide",
        type = "Normal",
        zMove = {boost = {atk = 1, def = 1, spa = 1, spd = 1, spe = 1}},
        contestType = "Cute"
    },
    harden = {num = 106, accuracy = true, basePower = 0, category = "Status", name = "Harden", pp = 30, priority = 0, flags = {snatch = 1}, boosts = {def = 1}, secondary = nil, target = "self", type = "Normal", zMove = {boost = {def = 1}}, contestType = "Tough"},
    haze = {
        num = 114,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Haze",
        pp = 30,
        priority = 0,
        flags = {authentic = 1},
        onHitField = function(self)
            self:add("-clearallboost")
            for ____, pokemon in __TS__Iterator(
                self:getAllActive()
            ) do
                pokemon:clearBoosts()
            end
        end,
        secondary = nil,
        target = "all",
        type = "Ice",
        zMove = {effect = "heal"},
        contestType = "Beautiful"
    },
    headbutt = {num = 29, accuracy = 100, basePower = 70, category = "Physical", name = "Headbutt", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 30, volatileStatus = "flinch"}, target = "normal", type = "Normal", contestType = "Tough"},
    headcharge = {num = 543, accuracy = 100, basePower = 120, category = "Physical", name = "Head Charge", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, recoil = {1, 4}, secondary = nil, target = "normal", type = "Normal", contestType = "Tough"},
    headsmash = {num = 457, accuracy = 80, basePower = 150, category = "Physical", name = "Head Smash", pp = 5, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, recoil = {1, 2}, secondary = nil, target = "normal", type = "Rock", contestType = "Tough"},
    healbell = {
        num = 215,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Heal Bell",
        pp = 5,
        priority = 0,
        flags = {snatch = 1, sound = 1, distance = 1, authentic = 1},
        onHit = function(self, pokemon, source)
            self:add("-activate", source, "move: Heal Bell")
            local side = pokemon.side
            local success = false
            for ____, ally in __TS__Iterator(side.pokemon) do
                do
                    if (ally ~= source) and ally:hasAbility("soundproof") then
                        goto __continue657
                    end
                    if ally:cureStatus() then
                        success = true
                    end
                end
                ::__continue657::
            end
            return success
        end,
        target = "allyTeam",
        type = "Normal",
        zMove = {effect = "heal"},
        contestType = "Beautiful"
    },
    healblock = {
        num = 377,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Heal Block",
        pp = 15,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1},
        volatileStatus = "healblock",
        condition = {
            duration = 5,
            durationCallback = function(self, target, source, effect)
                if source:hasAbility("persistent") then
                    self:add("-activate", source, "ability: Persistent", effect)
                    return 7
                end
                return 5
            end,
            onStart = function(self, pokemon, source)
                self:add("-start", pokemon, "move: Heal Block")
                source.moveThisTurnResult = true
            end,
            onDisableMove = function(self, pokemon)
                for ____, moveSlot in __TS__Iterator(pokemon.moveSlots) do
                    if self.dex.moves:get(moveSlot.id).flags.heal then
                        pokemon:disableMove(moveSlot.id)
                    end
                end
            end,
            onBeforeMovePriority = 6,
            onBeforeMove = function(self, pokemon, target, move)
                if (move.flags.heal and (not move.isZ)) and (not move.isMax) then
                    self:add("cant", pokemon, "move: Heal Block", move)
                    return false
                end
            end,
            onModifyMove = function(self, move, pokemon, target)
                if (move.flags.heal and (not move.isZ)) and (not move.isMax) then
                    self:add("cant", pokemon, "move: Heal Block", move)
                    return false
                end
            end,
            onResidualOrder = 20,
            onEnd = function(self, pokemon)
                self:add("-end", pokemon, "move: Heal Block")
            end,
            onTryHeal = function(self, damage, target, source, effect)
                if (effect.id == "zpower") or self.effectState.isZ then
                    return damage
                end
                return false
            end,
            onRestart = function(self, target, source)
                self:add("-fail", target, "move: Heal Block")
                if not source.moveThisTurnResult then
                    source.moveThisTurnResult = false
                end
            end
        },
        secondary = nil,
        target = "allAdjacentFoes",
        type = "Psychic",
        zMove = {boost = {spa = 2}},
        contestType = "Clever"
    },
    healingwish = {
        num = 361,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Healing Wish",
        pp = 10,
        priority = 0,
        flags = {snatch = 1, heal = 1},
        onTryHit = function(self, pokemon, target, move)
            if not self:canSwitch(pokemon.side) then
                __TS__Delete(move, "selfdestruct")
                return false
            end
        end,
        selfdestruct = "ifHit",
        slotCondition = "healingwish",
        condition = {
            onSwap = function(self, target)
                if (not target.fainted) and ((target.hp < target.maxhp) or target.status) then
                    target:heal(target.maxhp)
                    target:setStatus("")
                    self:add("-heal", target, target.getHealth, "[from] move: Healing Wish")
                    target.side:removeSlotCondition(target, "healingwish")
                end
            end
        },
        secondary = nil,
        target = "self",
        type = "Psychic",
        contestType = "Beautiful"
    },
    healorder = {num = 456, accuracy = true, basePower = 0, category = "Status", isNonstandard = "Past", name = "Heal Order", pp = 10, priority = 0, flags = {snatch = 1, heal = 1}, heal = {1, 2}, secondary = nil, target = "self", type = "Bug", zMove = {effect = "clearnegativeboost"}, contestType = "Clever"},
    healpulse = {
        num = 505,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Heal Pulse",
        pp = 10,
        priority = 0,
        flags = {protect = 1, pulse = 1, reflectable = 1, distance = 1, heal = 1, mystery = 1},
        onHit = function(self, target, source)
            local success = false
            if source:hasAbility("megalauncher") then
                success = not (not self:heal(
                    self:modify(target.baseMaxhp, 0.75)
                ))
            else
                success = not (not self:heal(
                    math.ceil(target.baseMaxhp * 0.5)
                ))
            end
            if success and (not target:isAlly(source)) then
                target.staleness = "external"
            end
            return success
        end,
        secondary = nil,
        target = "any",
        type = "Psychic",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Beautiful"
    },
    heartstamp = {num = 531, accuracy = 100, basePower = 60, category = "Physical", isNonstandard = "Past", name = "Heart Stamp", pp = 25, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 30, volatileStatus = "flinch"}, target = "normal", type = "Psychic", contestType = "Cute"},
    heartswap = {
        num = 391,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Heart Swap",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, authentic = 1, mystery = 1},
        onHit = function(self, target, source)
            local targetBoosts = {}
            local sourceBoosts = {}
            local i
            for ____value in pairs(target.boosts) do
                i = ____value
                targetBoosts[i] = target.boosts[i]
                sourceBoosts[i] = source.boosts[i]
            end
            target:setBoost(sourceBoosts)
            source:setBoost(targetBoosts)
            self:add("-swapboost", source, target, "[from] move: Heart Swap")
        end,
        secondary = nil,
        target = "normal",
        type = "Psychic",
        zMove = {effect = "crit2"},
        contestType = "Clever"
    },
    heatcrash = {
        num = 535,
        accuracy = 100,
        basePower = 0,
        basePowerCallback = function(self, pokemon, target)
            local targetWeight = target:getWeight()
            local pokemonWeight = pokemon:getWeight()
            if pokemonWeight >= (targetWeight * 5) then
                return 120
            end
            if pokemonWeight >= (targetWeight * 4) then
                return 100
            end
            if pokemonWeight >= (targetWeight * 3) then
                return 80
            end
            if pokemonWeight >= (targetWeight * 2) then
                return 60
            end
            return 40
        end,
        category = "Physical",
        name = "Heat Crash",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1, nonsky = 1},
        onTryHit = function(self, target, pokemon, move)
            if target.volatiles.dynamax then
                self:add("-fail", pokemon, "Dynamax")
                self:attrLastMove("[still]")
                return nil
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Fire",
        zMove = {basePower = 160},
        maxMove = {basePower = 130},
        contestType = "Tough"
    },
    heatwave = {num = 257, accuracy = 90, basePower = 95, category = "Special", name = "Heat Wave", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, status = "brn"}, target = "allAdjacentFoes", type = "Fire", contestType = "Beautiful"},
    heavyslam = {
        num = 484,
        accuracy = 100,
        basePower = 0,
        basePowerCallback = function(self, pokemon, target)
            local targetWeight = target:getWeight()
            local pokemonWeight = pokemon:getWeight()
            if pokemonWeight >= (targetWeight * 5) then
                return 120
            end
            if pokemonWeight >= (targetWeight * 4) then
                return 100
            end
            if pokemonWeight >= (targetWeight * 3) then
                return 80
            end
            if pokemonWeight >= (targetWeight * 2) then
                return 60
            end
            return 40
        end,
        category = "Physical",
        name = "Heavy Slam",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1, nonsky = 1},
        onTryHit = function(self, target, pokemon, move)
            if target.volatiles.dynamax then
                self:add("-fail", pokemon, "Dynamax")
                self:attrLastMove("[still]")
                return nil
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Steel",
        zMove = {basePower = 160},
        maxMove = {basePower = 130},
        contestType = "Tough"
    },
    helpinghand = {
        num = 270,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Helping Hand",
        pp = 20,
        priority = 5,
        flags = {authentic = 1},
        volatileStatus = "helpinghand",
        onTryHit = function(self, target)
            if (not target.newlySwitched) and (not self.queue:willMove(target)) then
                return false
            end
        end,
        condition = {
            duration = 1,
            onStart = function(self, target, source)
                self.effectState.multiplier = 1.5
                self:add(
                    "-singleturn",
                    target,
                    "Helping Hand",
                    "[of] " .. tostring(source)
                )
            end,
            onRestart = function(self, target, source)
                local ____obj, ____index = self.effectState, "multiplier"
                ____obj[____index] = ____obj[____index] * 1.5
                self:add(
                    "-singleturn",
                    target,
                    "Helping Hand",
                    "[of] " .. tostring(source)
                )
            end,
            onBasePowerPriority = 10,
            onBasePower = function(self, basePower)
                self:debug(
                    "Boosting from Helping Hand: " .. tostring(self.effectState.multiplier)
                )
                return self:chainModify(self.effectState.multiplier)
            end
        },
        secondary = nil,
        target = "adjacentAlly",
        type = "Normal",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Clever"
    },
    hex = {
        num = 506,
        accuracy = 100,
        basePower = 65,
        basePowerCallback = function(self, pokemon, target, move)
            if target.status or target:hasAbility("comatose") then
                return move.basePower * 2
            end
            return move.basePower
        end,
        category = "Special",
        name = "Hex",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Ghost",
        zMove = {basePower = 160},
        contestType = "Clever"
    },
    hiddenpower = {
        num = 237,
        accuracy = 100,
        basePower = 60,
        category = "Special",
        isNonstandard = "Past",
        name = "Hidden Power",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onModifyType = function(self, move, pokemon)
            move.type = pokemon.hpType or "Dark"
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Clever"
    },
    hiddenpowerbug = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Bug", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Bug", contestType = "Clever"},
    hiddenpowerdark = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Dark", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Dark", contestType = "Clever"},
    hiddenpowerdragon = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Dragon", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Dragon", contestType = "Clever"},
    hiddenpowerelectric = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Electric", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Electric", contestType = "Clever"},
    hiddenpowerfighting = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Fighting", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Fighting", contestType = "Clever"},
    hiddenpowerfire = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Fire", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Fire", contestType = "Clever"},
    hiddenpowerflying = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Flying", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Flying", contestType = "Clever"},
    hiddenpowerghost = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Ghost", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Ghost", contestType = "Clever"},
    hiddenpowergrass = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Grass", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Grass", contestType = "Clever"},
    hiddenpowerground = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Ground", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Ground", contestType = "Clever"},
    hiddenpowerice = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Ice", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Ice", contestType = "Clever"},
    hiddenpowerpoison = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Poison", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Poison", contestType = "Clever"},
    hiddenpowerpsychic = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Psychic", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Psychic", contestType = "Clever"},
    hiddenpowerrock = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Rock", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Rock", contestType = "Clever"},
    hiddenpowersteel = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Steel", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Steel", contestType = "Clever"},
    hiddenpowerwater = {num = 237, accuracy = 100, basePower = 60, category = "Special", realMove = "Hidden Power", isNonstandard = "Past", name = "Hidden Power Water", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Water", contestType = "Clever"},
    highhorsepower = {num = 667, accuracy = 95, basePower = 95, category = "Physical", name = "High Horsepower", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Ground", contestType = "Tough"},
    highjumpkick = {
        num = 136,
        accuracy = 90,
        basePower = 130,
        category = "Physical",
        name = "High Jump Kick",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1, gravity = 1},
        hasCrashDamage = true,
        onMoveFail = function(self, target, source, move)
            self:damage(
                source.baseMaxhp / 2,
                source,
                source,
                self.dex.conditions:get("High Jump Kick")
            )
        end,
        secondary = nil,
        target = "normal",
        type = "Fighting",
        contestType = "Cool"
    },
    holdback = {
        num = 610,
        accuracy = 100,
        basePower = 40,
        category = "Physical",
        name = "Hold Back",
        pp = 40,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onDamagePriority = -20,
        onDamage = function(self, damage, target, source, effect)
            if damage >= target.hp then
                return target.hp - 1
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Cool"
    },
    holdhands = {num = 607, accuracy = true, basePower = 0, category = "Status", name = "Hold Hands", pp = 40, priority = 0, flags = {authentic = 1}, secondary = nil, target = "adjacentAlly", type = "Normal", zMove = {boost = {atk = 1, def = 1, spa = 1, spd = 1, spe = 1}}, contestType = "Cute"},
    honeclaws = {num = 468, accuracy = true, basePower = 0, category = "Status", name = "Hone Claws", pp = 15, priority = 0, flags = {snatch = 1}, boosts = {atk = 1, accuracy = 1}, secondary = nil, target = "self", type = "Dark", zMove = {boost = {atk = 1}}, contestType = "Cute"},
    hornattack = {num = 30, accuracy = 100, basePower = 65, category = "Physical", name = "Horn Attack", pp = 25, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Normal", contestType = "Cool"},
    horndrill = {num = 32, accuracy = 30, basePower = 0, category = "Physical", name = "Horn Drill", pp = 5, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, ohko = true, secondary = nil, target = "normal", type = "Normal", zMove = {basePower = 180}, maxMove = {basePower = 130}, contestType = "Cool"},
    hornleech = {num = 532, accuracy = 100, basePower = 75, category = "Physical", name = "Horn Leech", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, heal = 1}, drain = {1, 2}, secondary = nil, target = "normal", type = "Grass", contestType = "Tough"},
    howl = {num = 336, accuracy = true, basePower = 0, category = "Status", name = "Howl", pp = 40, priority = 0, flags = {snatch = 1, sound = 1}, boosts = {atk = 1}, secondary = nil, target = "allies", type = "Normal", zMove = {boost = {atk = 1}}, contestType = "Cool"},
    hurricane = {
        num = 542,
        accuracy = 70,
        basePower = 110,
        category = "Special",
        name = "Hurricane",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, distance = 1},
        onModifyMove = function(self, move, pokemon, target)
            local ____switch711 = target:effectiveWeather()
            if ____switch711 == "raindance" then
                goto ____switch711_case_0
            elseif ____switch711 == "primordialsea" then
                goto ____switch711_case_1
            elseif ____switch711 == "sunnyday" then
                goto ____switch711_case_2
            elseif ____switch711 == "desolateland" then
                goto ____switch711_case_3
            end
            goto ____switch711_end
            ::____switch711_case_0::
            do
            end
            ::____switch711_case_1::
            do
                move.accuracy = true
                goto ____switch711_end
            end
            ::____switch711_case_2::
            do
            end
            ::____switch711_case_3::
            do
                move.accuracy = 50
                goto ____switch711_end
            end
            ::____switch711_end::
        end,
        secondary = {chance = 30, volatileStatus = "confusion"},
        target = "any",
        type = "Flying",
        contestType = "Tough"
    },
    hydrocannon = {num = 308, accuracy = 90, basePower = 150, category = "Special", name = "Hydro Cannon", pp = 5, priority = 0, flags = {recharge = 1, protect = 1, mirror = 1}, self = {volatileStatus = "mustrecharge"}, secondary = nil, target = "normal", type = "Water", contestType = "Beautiful"},
    hydropump = {num = 56, accuracy = 80, basePower = 110, category = "Special", name = "Hydro Pump", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Water", contestType = "Beautiful"},
    hydrovortex = {num = 642, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Hydro Vortex", pp = 1, priority = 0, flags = {}, isZ = "wateriumz", secondary = nil, target = "normal", type = "Water", contestType = "Cool"},
    hyperbeam = {num = 63, accuracy = 90, basePower = 150, category = "Special", name = "Hyper Beam", pp = 5, priority = 0, flags = {recharge = 1, protect = 1, mirror = 1}, self = {volatileStatus = "mustrecharge"}, secondary = nil, target = "normal", type = "Normal", contestType = "Cool"},
    hyperfang = {num = 158, accuracy = 90, basePower = 80, category = "Physical", isNonstandard = "Past", name = "Hyper Fang", pp = 15, priority = 0, flags = {bite = 1, contact = 1, protect = 1, mirror = 1}, secondary = {chance = 10, volatileStatus = "flinch"}, target = "normal", type = "Normal", contestType = "Cool"},
    hyperspacefury = {
        num = 621,
        accuracy = true,
        basePower = 100,
        category = "Physical",
        isNonstandard = "Past",
        name = "Hyperspace Fury",
        pp = 5,
        priority = 0,
        flags = {mirror = 1, authentic = 1},
        breaksProtect = true,
        onTry = function(self, source)
            if source.species.name == "Hoopa-Unbound" then
                return
            end
            self:hint("Only a Pokemon whose form is Hoopa Unbound can use this move.")
            if source.species.name == "Hoopa" then
                self:attrLastMove("[still]")
                self:add("-fail", source, "move: Hyperspace Fury", "[forme]")
                return nil
            end
            self:attrLastMove("[still]")
            self:add("-fail", source, "move: Hyperspace Fury")
            return nil
        end,
        self = {boosts = {def = -1}},
        secondary = nil,
        target = "normal",
        type = "Dark",
        contestType = "Tough"
    },
    hyperspacehole = {num = 593, accuracy = true, basePower = 80, category = "Special", isNonstandard = "Past", name = "Hyperspace Hole", pp = 5, priority = 0, flags = {mirror = 1, authentic = 1}, breaksProtect = true, secondary = nil, target = "normal", type = "Psychic", contestType = "Clever"},
    hypervoice = {num = 304, accuracy = 100, basePower = 90, category = "Special", name = "Hyper Voice", pp = 10, priority = 0, flags = {protect = 1, mirror = 1, sound = 1, authentic = 1}, secondary = nil, target = "allAdjacentFoes", type = "Normal", contestType = "Cool"},
    hypnosis = {num = 95, accuracy = 60, basePower = 0, category = "Status", name = "Hypnosis", pp = 20, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, status = "slp", secondary = nil, target = "normal", type = "Psychic", zMove = {boost = {spe = 1}}, contestType = "Clever"},
    iceball = {
        num = 301,
        accuracy = 90,
        basePower = 30,
        basePowerCallback = function(self, pokemon, target, move)
            local bp = move.basePower
            if pokemon.volatiles.iceball and pokemon.volatiles.iceball.hitCount then
                bp = bp * math.pow(2, pokemon.volatiles.iceball.hitCount)
            end
            if pokemon.status ~= "slp" then
                pokemon:addVolatile("iceball")
            end
            if pokemon.volatiles.defensecurl then
                bp = bp * 2
            end
            self:debug(
                "Ice Ball bp: " .. tostring(bp)
            )
            return bp
        end,
        category = "Physical",
        isNonstandard = "Past",
        name = "Ice Ball",
        pp = 20,
        priority = 0,
        flags = {bullet = 1, contact = 1, protect = 1, mirror = 1},
        condition = {
            duration = 2,
            onLockMove = "iceball",
            onStart = function(self)
                self.effectState.hitCount = 1
            end,
            onRestart = function(self)
                local ____obj, ____index = self.effectState, "hitCount"
                ____obj[____index] = ____obj[____index] + 1
                if self.effectState.hitCount < 5 then
                    self.effectState.duration = 2
                end
            end,
            onResidual = function(self, target)
                if target.lastMove and (target.lastMove.id == "struggle") then
                    __TS__Delete(target.volatiles, "iceball")
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Ice",
        contestType = "Beautiful"
    },
    icebeam = {num = 58, accuracy = 100, basePower = 90, category = "Special", name = "Ice Beam", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, status = "frz"}, target = "normal", type = "Ice", contestType = "Beautiful"},
    iceburn = {
        num = 554,
        accuracy = 90,
        basePower = 140,
        category = "Special",
        name = "Ice Burn",
        pp = 5,
        priority = 0,
        flags = {charge = 1, protect = 1, mirror = 1},
        onTryMove = function(self, attacker, defender, move)
            if attacker:removeVolatile(move.id) then
                return
            end
            self:add("-prepare", attacker, move.name)
            if not self:runEvent("ChargeMove", attacker, defender, move) then
                return
            end
            attacker:addVolatile("twoturnmove", defender)
            return nil
        end,
        secondary = {chance = 30, status = "brn"},
        target = "normal",
        type = "Ice",
        contestType = "Beautiful"
    },
    icefang = {num = 423, accuracy = 95, basePower = 65, category = "Physical", name = "Ice Fang", pp = 15, priority = 0, flags = {bite = 1, contact = 1, protect = 1, mirror = 1}, secondaries = {{chance = 10, status = "frz"}, {chance = 10, volatileStatus = "flinch"}}, target = "normal", type = "Ice", contestType = "Cool"},
    icehammer = {num = 665, accuracy = 90, basePower = 100, category = "Physical", isNonstandard = "Past", name = "Ice Hammer", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, self = {boosts = {spe = -1}}, secondary = nil, target = "normal", type = "Ice", contestType = "Tough"},
    icepunch = {num = 8, accuracy = 100, basePower = 75, category = "Physical", name = "Ice Punch", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, secondary = {chance = 10, status = "frz"}, target = "normal", type = "Ice", contestType = "Beautiful"},
    iceshard = {num = 420, accuracy = 100, basePower = 40, category = "Physical", name = "Ice Shard", pp = 30, priority = 1, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Ice", contestType = "Beautiful"},
    iciclecrash = {num = 556, accuracy = 90, basePower = 85, category = "Physical", name = "Icicle Crash", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 30, volatileStatus = "flinch"}, target = "normal", type = "Ice", contestType = "Beautiful"},
    iciclespear = {num = 333, accuracy = 100, basePower = 25, category = "Physical", name = "Icicle Spear", pp = 30, priority = 0, flags = {protect = 1, mirror = 1}, multihit = {2, 5}, secondary = nil, target = "normal", type = "Ice", zMove = {basePower = 140}, maxMove = {basePower = 130}, contestType = "Beautiful"},
    icywind = {num = 196, accuracy = 95, basePower = 55, category = "Special", name = "Icy Wind", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {spe = -1}}, target = "allAdjacentFoes", type = "Ice", contestType = "Beautiful"},
    imprison = {
        num = 286,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Imprison",
        pp = 10,
        priority = 0,
        flags = {snatch = 1, authentic = 1},
        volatileStatus = "imprison",
        condition = {
            noCopy = true,
            onStart = function(self, target)
                self:add("-start", target, "move: Imprison")
            end,
            onFoeDisableMove = function(self, pokemon)
                for ____, moveSlot in __TS__Iterator(self.effectState.source.moveSlots) do
                    do
                        if moveSlot.id == "struggle" then
                            goto __continue729
                        end
                        pokemon:disableMove(moveSlot.id, "hidden")
                    end
                    ::__continue729::
                end
                pokemon.maybeDisabled = true
            end,
            onFoeBeforeMovePriority = 4,
            onFoeBeforeMove = function(self, attacker, defender, move)
                if (((move.id ~= "struggle") and self.effectState.source:hasMove(move.id)) and (not move.isZ)) and (not move.isMax) then
                    self:add("cant", attacker, "move: Imprison", move)
                    return false
                end
            end
        },
        secondary = nil,
        pressureTarget = "foeSide",
        target = "self",
        type = "Psychic",
        zMove = {boost = {spd = 2}},
        contestType = "Clever"
    },
    incinerate = {
        num = 510,
        accuracy = 100,
        basePower = 60,
        category = "Special",
        name = "Incinerate",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onHit = function(self, pokemon, source)
            local item = pokemon:getItem()
            if (item.isBerry or item.isGem) and pokemon:takeItem(source) then
                self:add("-enditem", pokemon, item.name, "[from] move: Incinerate")
            end
        end,
        secondary = nil,
        target = "allAdjacentFoes",
        type = "Fire",
        contestType = "Tough"
    },
    inferno = {num = 517, accuracy = 50, basePower = 100, category = "Special", name = "Inferno", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 100, status = "brn"}, target = "normal", type = "Fire", contestType = "Beautiful"},
    infernooverdrive = {num = 640, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Inferno Overdrive", pp = 1, priority = 0, flags = {}, isZ = "firiumz", secondary = nil, target = "normal", type = "Fire", contestType = "Cool"},
    infestation = {num = 611, accuracy = 100, basePower = 20, category = "Special", name = "Infestation", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, volatileStatus = "partiallytrapped", secondary = nil, target = "normal", type = "Bug", contestType = "Cute"},
    ingrain = {
        num = 275,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Ingrain",
        pp = 20,
        priority = 0,
        flags = {snatch = 1, nonsky = 1},
        volatileStatus = "ingrain",
        condition = {
            onStart = function(self, pokemon)
                self:add("-start", pokemon, "move: Ingrain")
            end,
            onResidualOrder = 7,
            onResidual = function(self, pokemon)
                self:heal(pokemon.baseMaxhp / 16)
            end,
            onTrapPokemon = function(self, pokemon)
                pokemon:tryTrap()
            end,
            onDragOut = function(self, pokemon)
                self:add("-activate", pokemon, "move: Ingrain")
                return nil
            end
        },
        secondary = nil,
        target = "self",
        type = "Grass",
        zMove = {boost = {spd = 1}},
        contestType = "Clever"
    },
    instruct = {
        num = 689,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Instruct",
        pp = 15,
        priority = 0,
        flags = {protect = 1, authentic = 1, mystery = 1},
        onHit = function(self, target, source)
            if (not target.lastMove) or target.volatiles.dynamax then
                return false
            end
            local lastMove = target.lastMove
            local moveIndex = target.moves:indexOf(lastMove.id)
            local noInstruct = {"assist", "beakblast", "belch", "bide", "celebrate", "copycat", "dynamaxcannon", "focuspunch", "iceball", "instruct", "kingsshield", "mefirst", "metronome", "mimic", "mirrormove", "naturepower", "obstruct", "outrage", "petaldance", "rollout", "shelltrap", "sketch", "sleeptalk", "struggle", "thrash", "transform", "uproar"}
            if (((((((noInstruct:includes(lastMove.id) or lastMove.isZ) or lastMove.isMax) or lastMove.flags.charge) or lastMove.flags.recharge) or target.volatiles.beakblast) or target.volatiles.focuspunch) or target.volatiles.shelltrap) or (target.moveSlots[moveIndex] and (target.moveSlots[moveIndex].pp <= 0)) then
                return false
            end
            self:add(
                "-singleturn",
                target,
                "move: Instruct",
                "[of] " .. tostring(source)
            )
            self.actions:runMove(target.lastMove.id, target, target.lastMoveTargetLoc)
        end,
        secondary = nil,
        target = "normal",
        type = "Psychic",
        zMove = {boost = {spa = 1}},
        contestType = "Clever"
    },
    iondeluge = {
        num = 569,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Ion Deluge",
        pp = 25,
        priority = 1,
        flags = {},
        pseudoWeather = "iondeluge",
        condition = {
            duration = 1,
            onStart = function(self, target, source, sourceEffect)
                self:add("-fieldactivate", "move: Ion Deluge")
                self:hint(
                    ("Normal-type moves become Electric-type after using " .. tostring(sourceEffect)) .. "."
                )
            end,
            onModifyTypePriority = -2,
            onModifyType = function(self, move)
                if move.type == "Normal" then
                    move.type = "Electric"
                    self:debug(
                        tostring(move.name) .. "'s type changed to Electric"
                    )
                end
            end
        },
        secondary = nil,
        target = "all",
        type = "Electric",
        zMove = {boost = {spa = 1}},
        contestType = "Beautiful"
    },
    irondefense = {num = 334, accuracy = true, basePower = 0, category = "Status", name = "Iron Defense", pp = 15, priority = 0, flags = {snatch = 1}, boosts = {def = 2}, secondary = nil, target = "self", type = "Steel", zMove = {effect = "clearnegativeboost"}, contestType = "Tough"},
    ironhead = {num = 442, accuracy = 100, basePower = 80, category = "Physical", name = "Iron Head", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 30, volatileStatus = "flinch"}, target = "normal", type = "Steel", contestType = "Tough"},
    irontail = {num = 231, accuracy = 75, basePower = 100, category = "Physical", name = "Iron Tail", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 30, boosts = {def = -1}}, target = "normal", type = "Steel", contestType = "Cool"},
    jawlock = {
        num = 746,
        accuracy = 100,
        basePower = 80,
        category = "Physical",
        name = "Jaw Lock",
        pp = 10,
        priority = 0,
        flags = {bite = 1, contact = 1, protect = 1, mirror = 1},
        onHit = function(self, target, source, move)
            source:addVolatile("trapped", target, move, "trapper")
            target:addVolatile("trapped", source, move, "trapper")
        end,
        secondary = nil,
        target = "normal",
        type = "Dark"
    },
    judgment = {
        num = 449,
        accuracy = 100,
        basePower = 100,
        category = "Special",
        isNonstandard = "Past",
        name = "Judgment",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onModifyType = function(self, move, pokemon)
            if pokemon:ignoringItem() then
                return
            end
            local item = pokemon:getItem()
            if (item.id and item.onPlate) and (not item.zMove) then
                move.type = item.onPlate
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Beautiful"
    },
    jumpkick = {
        num = 26,
        accuracy = 95,
        basePower = 100,
        category = "Physical",
        isNonstandard = "Past",
        name = "Jump Kick",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1, gravity = 1},
        hasCrashDamage = true,
        onMoveFail = function(self, target, source, move)
            self:damage(
                source.baseMaxhp / 2,
                source,
                source,
                self.dex.conditions:get("Jump Kick")
            )
        end,
        secondary = nil,
        target = "normal",
        type = "Fighting",
        contestType = "Cool"
    },
    junglehealing = {
        num = 816,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Jungle Healing",
        pp = 10,
        priority = 0,
        flags = {heal = 1, authentic = 1, mystery = 1},
        onHit = function(self, pokemon)
            local success = not (not self:heal(
                self:modify(pokemon.maxhp, 0.25)
            ))
            return pokemon:cureStatus() or success
        end,
        secondary = nil,
        target = "allies",
        type = "Grass"
    },
    karatechop = {num = 2, accuracy = 100, basePower = 50, category = "Physical", isNonstandard = "Past", name = "Karate Chop", pp = 25, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, critRatio = 2, secondary = nil, target = "normal", type = "Fighting", contestType = "Tough"},
    kinesis = {num = 134, accuracy = 80, basePower = 0, category = "Status", name = "Kinesis", pp = 15, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, boosts = {accuracy = -1}, secondary = nil, target = "normal", type = "Psychic", zMove = {boost = {evasion = 1}}, contestType = "Clever"},
    kingsshield = {
        num = 588,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "King's Shield",
        pp = 10,
        priority = 4,
        flags = {},
        stallingMove = true,
        volatileStatus = "kingsshield",
        onPrepareHit = function(self, pokemon)
            return (not (not self.queue:willAct())) and self:runEvent("StallMove", pokemon)
        end,
        onHit = function(self, pokemon)
            pokemon:addVolatile("stall")
        end,
        condition = {
            duration = 1,
            onStart = function(self, target)
                self:add("-singleturn", target, "Protect")
            end,
            onTryHitPriority = 3,
            onTryHit = function(self, target, source, move)
                if (not move.flags.protect) or (move.category == "Status") then
                    if ({"gmaxoneblow", "gmaxrapidflow"}):includes(move.id) then
                        return
                    end
                    if move.isZ or move.isMax then
                        target:getMoveHitData(move).zBrokeProtect = true
                    end
                    return
                end
                if move.smartTarget then
                    move.smartTarget = false
                else
                    self:add("-activate", target, "move: Protect")
                end
                local lockedmove = source:getVolatile("lockedmove")
                if lockedmove then
                    if source.volatiles.lockedmove.duration == 2 then
                        __TS__Delete(source.volatiles, "lockedmove")
                    end
                end
                if self:checkMoveMakesContact(move, source, target) then
                    self:boost(
                        {atk = -1},
                        source,
                        target,
                        self.dex:getActiveMove("King's Shield")
                    )
                end
                return self.NOT_FAIL
            end,
            onHit = function(self, target, source, move)
                if move.isZOrMaxPowered and self:checkMoveMakesContact(move, source, target) then
                    self:boost(
                        {atk = -1},
                        source,
                        target,
                        self.dex:getActiveMove("King's Shield")
                    )
                end
            end
        },
        secondary = nil,
        target = "self",
        type = "Steel",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Cool"
    },
    knockoff = {
        num = 282,
        accuracy = 100,
        basePower = 65,
        category = "Physical",
        name = "Knock Off",
        pp = 20,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onBasePower = function(self, basePower, source, target, move)
            local item = target:getItem()
            if not self:singleEvent("TakeItem", item, target.itemState, target, target, move, item) then
                return
            end
            if item.id then
                return self:chainModify(1.5)
            end
        end,
        onAfterHit = function(self, target, source)
            if source.hp then
                local item = target:takeItem()
                if item then
                    self:add(
                        "-enditem",
                        target,
                        item.name,
                        "[from] move: Knock Off",
                        "[of] " .. tostring(source)
                    )
                end
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Dark",
        contestType = "Clever"
    },
    landswrath = {num = 616, accuracy = 100, basePower = 90, category = "Physical", name = "Land's Wrath", pp = 10, priority = 0, flags = {protect = 1, mirror = 1, nonsky = 1}, secondary = nil, target = "allAdjacentFoes", type = "Ground", zMove = {basePower = 185}, contestType = "Beautiful"},
    laserfocus = {
        num = 673,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Laser Focus",
        pp = 30,
        priority = 0,
        flags = {snatch = 1},
        volatileStatus = "laserfocus",
        condition = {
            duration = 2,
            onStart = function(self, pokemon, source, effect)
                if effect and ({"imposter", "psychup", "transform"}):includes(effect.id) then
                    self:add("-start", pokemon, "move: Laser Focus", "[silent]")
                else
                    self:add("-start", pokemon, "move: Laser Focus")
                end
            end,
            onRestart = function(self, pokemon)
                self.effectState.duration = 2
                self:add("-start", pokemon, "move: Laser Focus")
            end,
            onModifyCritRatio = function(self, critRatio)
                return 5
            end,
            onEnd = function(self, pokemon)
                self:add("-end", pokemon, "move: Laser Focus", "[silent]")
            end
        },
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {boost = {atk = 1}},
        contestType = "Cool"
    },
    lashout = {
        num = 808,
        accuracy = 100,
        basePower = 75,
        category = "Physical",
        name = "Lash Out",
        pp = 5,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onBasePower = function(self, basePower, source)
            if source.statsLoweredThisTurn then
                self:debug("lashout buff")
                return self:chainModify(2)
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Dark"
    },
    lastresort = {
        num = 387,
        accuracy = 100,
        basePower = 140,
        category = "Physical",
        name = "Last Resort",
        pp = 5,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onTry = function(self, source)
            if source.moveSlots.length < 2 then
                return false
            end
            local hasLastResort = false
            for ____, moveSlot in __TS__Iterator(source.moveSlots) do
                do
                    if moveSlot.id == "lastresort" then
                        hasLastResort = true
                        goto __continue781
                    end
                    if not moveSlot.used then
                        return false
                    end
                end
                ::__continue781::
            end
            return hasLastResort
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Cute"
    },
    lavaplume = {num = 436, accuracy = 100, basePower = 80, category = "Special", name = "Lava Plume", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 30, status = "brn"}, target = "allAdjacent", type = "Fire", contestType = "Tough"},
    leafage = {num = 670, accuracy = 100, basePower = 40, category = "Physical", name = "Leafage", pp = 40, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Grass", contestType = "Tough"},
    leafblade = {num = 348, accuracy = 100, basePower = 90, category = "Physical", name = "Leaf Blade", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, critRatio = 2, secondary = nil, target = "normal", type = "Grass", contestType = "Cool"},
    leafstorm = {num = 437, accuracy = 90, basePower = 130, category = "Special", name = "Leaf Storm", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, self = {boosts = {spa = -2}}, secondary = nil, target = "normal", type = "Grass", contestType = "Beautiful"},
    leaftornado = {num = 536, accuracy = 90, basePower = 65, category = "Special", name = "Leaf Tornado", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 50, boosts = {accuracy = -1}}, target = "normal", type = "Grass", contestType = "Cool"},
    leechlife = {num = 141, accuracy = 100, basePower = 80, category = "Physical", name = "Leech Life", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, heal = 1}, drain = {1, 2}, secondary = nil, target = "normal", type = "Bug", contestType = "Clever"},
    leechseed = {
        num = 73,
        accuracy = 90,
        basePower = 0,
        category = "Status",
        name = "Leech Seed",
        pp = 10,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1},
        volatileStatus = "leechseed",
        condition = {
            onStart = function(self, target)
                self:add("-start", target, "move: Leech Seed")
            end,
            onResidualOrder = 8,
            onResidual = function(self, pokemon)
                local target = self:getAtSlot(pokemon.volatiles.leechseed.sourceSlot)
                if ((not target) or target.fainted) or (target.hp <= 0) then
                    self:debug("Nothing to leech into")
                    return
                end
                local damage = self:damage(pokemon.baseMaxhp / 8, pokemon, target)
                if damage then
                    self:heal(damage, target, pokemon)
                end
            end
        },
        onTryImmunity = function(self, target)
            return not target:hasType("Grass")
        end,
        secondary = nil,
        target = "normal",
        type = "Grass",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Clever"
    },
    leer = {num = 43, accuracy = 100, basePower = 0, category = "Status", name = "Leer", pp = 30, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, boosts = {def = -1}, secondary = nil, target = "allAdjacentFoes", type = "Normal", zMove = {boost = {atk = 1}}, contestType = "Cool"},
    letssnuggleforever = {num = 726, accuracy = true, basePower = 190, category = "Physical", isNonstandard = "Past", name = "Let's Snuggle Forever", pp = 1, priority = 0, flags = {contact = 1}, isZ = "mimikiumz", secondary = nil, target = "normal", type = "Fairy", contestType = "Cool"},
    lick = {num = 122, accuracy = 100, basePower = 30, category = "Physical", name = "Lick", pp = 30, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 30, status = "par"}, target = "normal", type = "Ghost", contestType = "Cute"},
    lifedew = {num = 791, accuracy = true, basePower = 0, category = "Status", name = "Life Dew", pp = 10, priority = 0, flags = {snatch = 1, heal = 1, authentic = 1}, heal = {1, 4}, secondary = nil, target = "allies", type = "Water"},
    lightofruin = {num = 617, accuracy = 90, basePower = 140, category = "Special", isNonstandard = "Past", name = "Light of Ruin", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, recoil = {1, 2}, secondary = nil, target = "normal", type = "Fairy", contestType = "Beautiful"},
    lightscreen = {
        num = 113,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Light Screen",
        pp = 30,
        priority = 0,
        flags = {snatch = 1},
        sideCondition = "lightscreen",
        condition = {
            duration = 5,
            durationCallback = function(self, target, source, effect)
                if source:hasItem("lightclay") then
                    return 8
                end
                return 5
            end,
            onAnyModifyDamage = function(self, damage, source, target, move)
                if ((target ~= source) and self.effectState.target:hasAlly(target)) and (self:getCategory(move) == "Special") then
                    if (not target:getMoveHitData(move).crit) and (not move.infiltrates) then
                        self:debug("Light Screen weaken")
                        if self.activePerHalf > 1 then
                            return self:chainModify({2732, 4096})
                        end
                        return self:chainModify(0.5)
                    end
                end
            end,
            onSideStart = function(self, side)
                self:add("-sidestart", side, "move: Light Screen")
            end,
            onSideResidualOrder = 26,
            onSideResidualSubOrder = 2,
            onSideEnd = function(self, side)
                self:add("-sideend", side, "move: Light Screen")
            end
        },
        secondary = nil,
        target = "allySide",
        type = "Psychic",
        zMove = {boost = {spd = 1}},
        contestType = "Beautiful"
    },
    lightthatburnsthesky = {
        num = 723,
        accuracy = true,
        basePower = 200,
        category = "Special",
        isNonstandard = "Past",
        name = "Light That Burns the Sky",
        pp = 1,
        priority = 0,
        flags = {},
        onModifyMove = function(self, move, pokemon)
            if pokemon:getStat("atk", false, true) > pokemon:getStat("spa", false, true) then
                move.category = "Physical"
            end
        end,
        ignoreAbility = true,
        isZ = "ultranecroziumz",
        secondary = nil,
        target = "normal",
        type = "Psychic",
        contestType = "Cool"
    },
    liquidation = {num = 710, accuracy = 100, basePower = 85, category = "Physical", name = "Liquidation", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 20, boosts = {def = -1}}, target = "normal", type = "Water", contestType = "Cool"},
    lockon = {
        num = 199,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Lock-On",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onTryHit = function(self, target, source)
            if source.volatiles.lockon then
                return false
            end
        end,
        onHit = function(self, target, source)
            source:addVolatile("lockon", target)
            self:add(
                "-activate",
                source,
                "move: Lock-On",
                "[of] " .. tostring(target)
            )
        end,
        condition = {
            noCopy = true,
            duration = 2,
            onSourceInvulnerabilityPriority = 1,
            onSourceInvulnerability = function(self, target, source, move)
                if (move and (source == self.effectState.target)) and (target == self.effectState.source) then
                    return 0
                end
            end,
            onSourceAccuracy = function(self, accuracy, target, source, move)
                if (move and (source == self.effectState.target)) and (target == self.effectState.source) then
                    return true
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {spe = 1}},
        contestType = "Clever"
    },
    lovelykiss = {num = 142, accuracy = 75, basePower = 0, category = "Status", name = "Lovely Kiss", pp = 10, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, status = "slp", secondary = nil, target = "normal", type = "Normal", zMove = {boost = {spe = 1}}, contestType = "Beautiful"},
    lowkick = {
        num = 67,
        accuracy = 100,
        basePower = 0,
        basePowerCallback = function(self, pokemon, target)
            local targetWeight = target:getWeight()
            if targetWeight >= 2000 then
                return 120
            end
            if targetWeight >= 1000 then
                return 100
            end
            if targetWeight >= 500 then
                return 80
            end
            if targetWeight >= 250 then
                return 60
            end
            if targetWeight >= 100 then
                return 40
            end
            return 20
        end,
        category = "Physical",
        name = "Low Kick",
        pp = 20,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onTryHit = function(self, target, pokemon, move)
            if target.volatiles.dynamax then
                self:add("-fail", pokemon, "Dynamax")
                self:attrLastMove("[still]")
                return nil
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Fighting",
        zMove = {basePower = 160},
        contestType = "Tough"
    },
    lowsweep = {num = 490, accuracy = 100, basePower = 65, category = "Physical", name = "Low Sweep", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {spe = -1}}, target = "normal", type = "Fighting", contestType = "Clever"},
    luckychant = {
        num = 381,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Lucky Chant",
        pp = 30,
        priority = 0,
        flags = {snatch = 1},
        sideCondition = "luckychant",
        condition = {
            duration = 5,
            onSideStart = function(self, side)
                self:add("-sidestart", side, "move: Lucky Chant")
            end,
            onCriticalHit = false,
            onSideResidualOrder = 26,
            onSideResidualSubOrder = 6,
            onSideEnd = function(self, side)
                self:add("-sideend", side, "move: Lucky Chant")
            end
        },
        secondary = nil,
        target = "allySide",
        type = "Normal",
        zMove = {boost = {evasion = 1}},
        contestType = "Cute"
    },
    lunardance = {
        num = 461,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Lunar Dance",
        pp = 10,
        priority = 0,
        flags = {snatch = 1, heal = 1, dance = 1},
        onTryHit = function(self, pokemon, target, move)
            if not self:canSwitch(pokemon.side) then
                __TS__Delete(move, "selfdestruct")
                return false
            end
        end,
        selfdestruct = "ifHit",
        slotCondition = "lunardance",
        condition = {
            onSwap = function(self, target)
                if (not target.fainted) and (((target.hp < target.maxhp) or target.status) or target.moveSlots:some(
                    function(____, moveSlot) return moveSlot.pp < moveSlot.maxpp end
                )) then
                    target:heal(target.maxhp)
                    target:setStatus("")
                    for ____, moveSlot in __TS__Iterator(target.moveSlots) do
                        moveSlot.pp = moveSlot.maxpp
                    end
                    self:add("-heal", target, target.getHealth, "[from] move: Lunar Dance")
                    target.side:removeSlotCondition(target, "lunardance")
                end
            end
        },
        secondary = nil,
        target = "self",
        type = "Psychic",
        contestType = "Beautiful"
    },
    lunge = {num = 679, accuracy = 100, basePower = 80, category = "Physical", name = "Lunge", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {atk = -1}}, target = "normal", type = "Bug", contestType = "Cute"},
    lusterpurge = {num = 295, accuracy = 100, basePower = 70, category = "Special", name = "Luster Purge", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 50, boosts = {spd = -1}}, target = "normal", type = "Psychic", contestType = "Clever"},
    machpunch = {num = 183, accuracy = 100, basePower = 40, category = "Physical", name = "Mach Punch", pp = 30, priority = 1, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, secondary = nil, target = "normal", type = "Fighting", contestType = "Cool"},
    magicalleaf = {num = 345, accuracy = true, basePower = 60, category = "Special", name = "Magical Leaf", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Grass", contestType = "Beautiful"},
    magiccoat = {
        num = 277,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Magic Coat",
        pp = 15,
        priority = 4,
        flags = {},
        volatileStatus = "magiccoat",
        condition = {
            duration = 1,
            onStart = function(self, target, source, effect)
                self:add("-singleturn", target, "move: Magic Coat")
                if effect.effectType == "Move" then
                    self.effectState.pranksterBoosted = effect.pranksterBoosted
                end
            end,
            onTryHitPriority = 2,
            onTryHit = function(self, target, source, move)
                if ((target == source) or move.hasBounced) or (not move.flags.reflectable) then
                    return
                end
                local newMove = self.dex:getActiveMove(move.id)
                newMove.hasBounced = true
                newMove.pranksterBoosted = self.effectState.pranksterBoosted
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
            end
        },
        secondary = nil,
        target = "self",
        type = "Psychic",
        zMove = {boost = {spd = 2}},
        contestType = "Beautiful"
    },
    magicpowder = {
        num = 750,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Magic Powder",
        pp = 20,
        priority = 0,
        flags = {powder = 1, protect = 1, reflectable = 1, mirror = 1, mystery = 1},
        onHit = function(self, target)
            if (target:getTypes():join() == "Psychic") or (not target:setType("Psychic")) then
                return false
            end
            self:add("-start", target, "typechange", "Psychic")
        end,
        secondary = nil,
        target = "normal",
        type = "Psychic"
    },
    magicroom = {
        num = 478,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Magic Room",
        pp = 10,
        priority = 0,
        flags = {mirror = 1},
        pseudoWeather = "magicroom",
        condition = {
            duration = 5,
            durationCallback = function(self, source, effect)
                if source:hasAbility("persistent") then
                    self:add("-activate", source, "ability: Persistent", effect)
                    return 7
                end
                return 5
            end,
            onFieldStart = function(self, target, source)
                self:add(
                    "-fieldstart",
                    "move: Magic Room",
                    "[of] " .. tostring(source)
                )
            end,
            onFieldRestart = function(self, target, source)
                self.field:removePseudoWeather("magicroom")
            end,
            onFieldResidualOrder = 27,
            onFieldResidualSubOrder = 6,
            onFieldEnd = function(self)
                self:add(
                    "-fieldend",
                    "move: Magic Room",
                    "[of] " .. tostring(self.effectState.source)
                )
            end
        },
        secondary = nil,
        target = "all",
        type = "Psychic",
        zMove = {boost = {spd = 1}},
        contestType = "Clever"
    },
    magmastorm = {num = 463, accuracy = 75, basePower = 100, category = "Special", name = "Magma Storm", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, volatileStatus = "partiallytrapped", secondary = nil, target = "normal", type = "Fire", contestType = "Tough"},
    magnetbomb = {num = 443, accuracy = true, basePower = 60, category = "Physical", isNonstandard = "Past", name = "Magnet Bomb", pp = 20, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Steel", contestType = "Cool"},
    magneticflux = {
        num = 602,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Magnetic Flux",
        pp = 20,
        priority = 0,
        flags = {snatch = 1, distance = 1, authentic = 1},
        onHitSide = function(self, side, source, move)
            local targets = side:allies():filter(
                function(____, ally) return ally:hasAbility({"plus", "minus"}) and ((not ally.volatiles.maxguard) or self:runEvent("TryHit", ally, source, move)) end
            )
            if not targets.length then
                return false
            end
            local didSomething = false
            for ____, target in __TS__Iterator(targets) do
                didSomething = self:boost({def = 1, spd = 1}, target, source, move, false, true) or didSomething
            end
            return didSomething
        end,
        secondary = nil,
        target = "allySide",
        type = "Electric",
        zMove = {boost = {spd = 1}},
        contestType = "Clever"
    },
    magnetrise = {
        num = 393,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Magnet Rise",
        pp = 10,
        priority = 0,
        flags = {snatch = 1, gravity = 1},
        volatileStatus = "magnetrise",
        onTry = function(self, source, target, move)
            if target.volatiles.smackdown or target.volatiles.ingrain then
                return false
            end
            if self.field:getPseudoWeather("Gravity") then
                self:add("cant", source, "move: Gravity", move)
                return nil
            end
        end,
        condition = {
            duration = 5,
            onStart = function(self, target)
                self:add("-start", target, "Magnet Rise")
            end,
            onImmunity = function(self, ____type)
                if ____type == "Ground" then
                    return false
                end
            end,
            onResidualOrder = 18,
            onEnd = function(self, target)
                self:add("-end", target, "Magnet Rise")
            end
        },
        secondary = nil,
        target = "self",
        type = "Electric",
        zMove = {boost = {evasion = 1}},
        contestType = "Clever"
    },
    magnitude = {
        num = 222,
        accuracy = 100,
        basePower = 0,
        category = "Physical",
        isNonstandard = "Past",
        name = "Magnitude",
        pp = 30,
        priority = 0,
        flags = {protect = 1, mirror = 1, nonsky = 1},
        onModifyMove = function(self, move, pokemon)
            local i = self:random(100)
            if i < 5 then
                move.magnitude = 4
                move.basePower = 10
            elseif i < 15 then
                move.magnitude = 5
                move.basePower = 30
            elseif i < 35 then
                move.magnitude = 6
                move.basePower = 50
            elseif i < 65 then
                move.magnitude = 7
                move.basePower = 70
            elseif i < 85 then
                move.magnitude = 8
                move.basePower = 90
            elseif i < 95 then
                move.magnitude = 9
                move.basePower = 110
            else
                move.magnitude = 10
                move.basePower = 150
            end
        end,
        onUseMoveMessage = function(self, pokemon, target, move)
            self:add("-activate", pokemon, "move: Magnitude", move.magnitude)
        end,
        secondary = nil,
        target = "allAdjacent",
        type = "Ground",
        zMove = {basePower = 140},
        maxMove = {basePower = 140},
        contestType = "Tough"
    },
    maliciousmoonsault = {num = 696, accuracy = true, basePower = 180, category = "Physical", isNonstandard = "Past", name = "Malicious Moonsault", pp = 1, priority = 0, flags = {contact = 1}, isZ = "inciniumz", secondary = nil, target = "normal", type = "Dark", contestType = "Cool"},
    matblock = {
        num = 561,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Mat Block",
        pp = 10,
        priority = 0,
        flags = {snatch = 1, nonsky = 1},
        stallingMove = true,
        sideCondition = "matblock",
        onTry = function(self, source)
            if source.activeMoveActions > 1 then
                self:hint("Mat Block only works on your first turn out.")
                return false
            end
            return not (not self.queue:willAct())
        end,
        condition = {
            duration = 1,
            onSideStart = function(self, target, source)
                self:add("-singleturn", source, "Mat Block")
            end,
            onTryHitPriority = 3,
            onTryHit = function(self, target, source, move)
                if not move.flags.protect then
                    if ({"gmaxoneblow", "gmaxrapidflow"}):includes(move.id) then
                        return
                    end
                    if move.isZ or move.isMax then
                        target:getMoveHitData(move).zBrokeProtect = true
                    end
                    return
                end
                if move and ((move.target == "self") or (move.category == "Status")) then
                    return
                end
                self:add("-activate", target, "move: Mat Block", move.name)
                local lockedmove = source:getVolatile("lockedmove")
                if lockedmove then
                    if source.volatiles.lockedmove.duration == 2 then
                        __TS__Delete(source.volatiles, "lockedmove")
                    end
                end
                return self.NOT_FAIL
            end
        },
        secondary = nil,
        target = "allySide",
        type = "Fighting",
        zMove = {boost = {def = 1}},
        contestType = "Cool"
    },
    maxairstream = {
        num = 766,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Airstream",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                for ____, pokemon in __TS__Iterator(
                    source:alliesAndSelf()
                ) do
                    self:boost({spe = 1}, pokemon)
                end
            end
        },
        target = "adjacentFoe",
        type = "Flying",
        contestType = "Cool"
    },
    maxdarkness = {
        num = 772,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Darkness",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    self:boost({spd = -1}, pokemon)
                end
            end
        },
        target = "adjacentFoe",
        type = "Dark",
        contestType = "Cool"
    },
    maxflare = {
        num = 757,
        accuracy = true,
        basePower = 100,
        category = "Physical",
        name = "Max Flare",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                self.field:setWeather("sunnyday")
            end
        },
        target = "adjacentFoe",
        type = "Fire",
        contestType = "Cool"
    },
    maxflutterby = {
        num = 758,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Flutterby",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    self:boost({spa = -1}, pokemon)
                end
            end
        },
        target = "adjacentFoe",
        type = "Bug",
        contestType = "Cool"
    },
    maxgeyser = {
        num = 765,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Geyser",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                self.field:setWeather("raindance")
            end
        },
        target = "adjacentFoe",
        type = "Water",
        contestType = "Cool"
    },
    maxguard = {
        num = 743,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Max Guard",
        pp = 10,
        priority = 4,
        flags = {},
        isMax = true,
        stallingMove = true,
        volatileStatus = "maxguard",
        onPrepareHit = function(self, pokemon)
            return (not (not self.queue:willAct())) and self:runEvent("StallMove", pokemon)
        end,
        onHit = function(self, pokemon)
            pokemon:addVolatile("stall")
        end,
        condition = {
            duration = 1,
            onStart = function(self, target)
                self:add("-singleturn", target, "Max Guard")
            end,
            onTryHitPriority = 3,
            onTryHit = function(self, target, source, move)
                if ({"gmaxoneblow", "gmaxrapidflow"}):includes(move.id) then
                    return
                end
                local overrideBypassProtect = {"block", "flowershield", "gearup", "magneticflux", "phantomforce", "psychup", "shadowforce", "teatime", "transform"}
                local blockedByMaxGuard = ((self.dex.moves:get(move.id).flags.protect or move.isZ) or move.isMax) or overrideBypassProtect:includes(move.id)
                if not blockedByMaxGuard then
                    return
                end
                if move.smartTarget then
                    move.smartTarget = false
                else
                    self:add("-activate", target, "move: Max Guard")
                end
                local lockedmove = source:getVolatile("lockedmove")
                if lockedmove then
                    if source.volatiles.lockedmove.duration == 2 then
                        __TS__Delete(source.volatiles, "lockedmove")
                    end
                end
                return self.NOT_FAIL
            end
        },
        secondary = nil,
        target = "self",
        type = "Normal",
        contestType = "Cool"
    },
    maxhailstorm = {
        num = 763,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Hailstorm",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                self.field:setWeather("hail")
            end
        },
        target = "adjacentFoe",
        type = "Ice",
        contestType = "Cool"
    },
    maxknuckle = {
        num = 761,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Knuckle",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                for ____, pokemon in __TS__Iterator(
                    source:alliesAndSelf()
                ) do
                    self:boost({atk = 1}, pokemon)
                end
            end
        },
        target = "adjacentFoe",
        type = "Fighting",
        contestType = "Cool"
    },
    maxlightning = {
        num = 759,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Lightning",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                self.field:setTerrain("electricterrain")
            end
        },
        target = "adjacentFoe",
        type = "Electric",
        contestType = "Cool"
    },
    maxmindstorm = {
        num = 769,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Mindstorm",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                self.field:setTerrain("psychicterrain")
            end
        },
        target = "adjacentFoe",
        type = "Psychic",
        contestType = "Cool"
    },
    maxooze = {
        num = 764,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Ooze",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                for ____, pokemon in __TS__Iterator(
                    source:alliesAndSelf()
                ) do
                    self:boost({spa = 1}, pokemon)
                end
            end
        },
        target = "adjacentFoe",
        type = "Poison",
        contestType = "Cool"
    },
    maxovergrowth = {
        num = 773,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Overgrowth",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                self.field:setTerrain("grassyterrain")
            end
        },
        target = "adjacentFoe",
        type = "Grass",
        contestType = "Cool"
    },
    maxphantasm = {
        num = 762,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Phantasm",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    self:boost({def = -1}, pokemon)
                end
            end
        },
        target = "adjacentFoe",
        type = "Ghost",
        contestType = "Cool"
    },
    maxquake = {
        num = 771,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Quake",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                for ____, pokemon in __TS__Iterator(
                    source:alliesAndSelf()
                ) do
                    self:boost({spd = 1}, pokemon)
                end
            end
        },
        target = "adjacentFoe",
        type = "Ground",
        contestType = "Cool"
    },
    maxrockfall = {
        num = 770,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Rockfall",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                self.field:setWeather("sandstorm")
            end
        },
        target = "adjacentFoe",
        type = "Rock",
        contestType = "Cool"
    },
    maxstarfall = {
        num = 767,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Starfall",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                self.field:setTerrain("mistyterrain")
            end
        },
        target = "adjacentFoe",
        type = "Fairy",
        contestType = "Cool"
    },
    maxsteelspike = {
        num = 774,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Steelspike",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                for ____, pokemon in __TS__Iterator(
                    source:alliesAndSelf()
                ) do
                    self:boost({def = 1}, pokemon)
                end
            end
        },
        target = "adjacentFoe",
        type = "Steel",
        contestType = "Cool"
    },
    maxstrike = {
        num = 760,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Strike",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    self:boost({spe = -1}, pokemon)
                end
            end
        },
        target = "adjacentFoe",
        type = "Normal",
        contestType = "Cool"
    },
    maxwyrmwind = {
        num = 768,
        accuracy = true,
        basePower = 10,
        category = "Physical",
        name = "Max Wyrmwind",
        pp = 10,
        priority = 0,
        flags = {},
        isMax = true,
        self = {
            onHit = function(self, source)
                if not source.volatiles.dynamax then
                    return
                end
                for ____, pokemon in __TS__Iterator(
                    source:foes()
                ) do
                    self:boost({atk = -1}, pokemon)
                end
            end
        },
        target = "adjacentFoe",
        type = "Dragon",
        contestType = "Cool"
    },
    meanlook = {
        num = 212,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Mean Look",
        pp = 5,
        priority = 0,
        flags = {reflectable = 1, mirror = 1},
        onHit = function(self, target, source, move)
            return target:addVolatile("trapped", source, move, "trapper")
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {spd = 1}},
        contestType = "Beautiful"
    },
    meditate = {num = 96, accuracy = true, basePower = 0, category = "Status", isNonstandard = "Past", name = "Meditate", pp = 40, priority = 0, flags = {snatch = 1}, boosts = {atk = 1}, secondary = nil, target = "self", type = "Psychic", zMove = {boost = {atk = 1}}, contestType = "Beautiful"},
    mefirst = {
        num = 382,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Me First",
        pp = 20,
        priority = 0,
        flags = {protect = 1, authentic = 1},
        onTryHit = function(self, target, pokemon)
            local action = self.queue:willMove(target)
            if not action then
                return false
            end
            local noMeFirst = {"beakblast", "chatter", "counter", "covet", "focuspunch", "mefirst", "metalburst", "mirrorcoat", "shelltrap", "struggle", "thief"}
            local move = self.dex:getActiveMove(action.move.id)
            if (action.zmove or move.isZ) or move.isMax then
                return false
            end
            if target.volatiles.mustrecharge then
                return false
            end
            if (move.category == "Status") or noMeFirst:includes(move.id) then
                return false
            end
            pokemon:addVolatile("mefirst")
            self.actions:useMove(move, pokemon, target)
            return nil
        end,
        condition = {
            duration = 1,
            onBasePowerPriority = 12,
            onBasePower = function(self, basePower)
                return self:chainModify(1.5)
            end
        },
        secondary = nil,
        target = "adjacentFoe",
        type = "Normal",
        zMove = {boost = {spe = 2}},
        contestType = "Clever"
    },
    megadrain = {num = 72, accuracy = 100, basePower = 40, category = "Special", name = "Mega Drain", pp = 15, priority = 0, flags = {protect = 1, mirror = 1, heal = 1}, drain = {1, 2}, secondary = nil, target = "normal", type = "Grass", zMove = {basePower = 120}, contestType = "Clever"},
    megahorn = {num = 224, accuracy = 85, basePower = 120, category = "Physical", name = "Megahorn", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Bug", contestType = "Cool"},
    megakick = {num = 25, accuracy = 75, basePower = 120, category = "Physical", name = "Mega Kick", pp = 5, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Normal", contestType = "Cool"},
    megapunch = {num = 5, accuracy = 85, basePower = 80, category = "Physical", name = "Mega Punch", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, secondary = nil, target = "normal", type = "Normal", contestType = "Tough"},
    memento = {num = 262, accuracy = 100, basePower = 0, category = "Status", name = "Memento", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, boosts = {atk = -2, spa = -2}, selfdestruct = "ifHit", secondary = nil, target = "normal", type = "Dark", zMove = {effect = "healreplacement"}, contestType = "Tough"},
    menacingmoonrazemaelstrom = {num = 725, accuracy = true, basePower = 200, category = "Special", isNonstandard = "Past", name = "Menacing Moonraze Maelstrom", pp = 1, priority = 0, flags = {}, isZ = "lunaliumz", ignoreAbility = true, secondary = nil, target = "normal", type = "Ghost", contestType = "Cool"},
    metalburst = {
        num = 368,
        accuracy = 100,
        basePower = 0,
        damageCallback = function(self, pokemon)
            local lastDamagedBy = pokemon:getLastDamagedBy(true)
            if lastDamagedBy ~= nil then
                return (lastDamagedBy.damage * 1.5) or 1
            end
            return 0
        end,
        category = "Physical",
        name = "Metal Burst",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onTryHit = function(self, target, source, move)
            local lastDamagedBy = source:getLastDamagedBy(true)
            if (lastDamagedBy == nil) or (not lastDamagedBy.thisTurn) then
                return false
            end
        end,
        onModifyTarget = function(self, targetRelayVar, source, target, move)
            local lastDamagedBy = source:getLastDamagedBy(true)
            if lastDamagedBy then
                targetRelayVar.target = self:getAtSlot(lastDamagedBy.slot)
            end
        end,
        secondary = nil,
        target = "scripted",
        type = "Steel",
        contestType = "Cool"
    },
    metalclaw = {num = 232, accuracy = 95, basePower = 50, category = "Physical", name = "Metal Claw", pp = 35, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 10, self = {boosts = {atk = 1}}}, target = "normal", type = "Steel", contestType = "Cool"},
    metalsound = {num = 319, accuracy = 85, basePower = 0, category = "Status", name = "Metal Sound", pp = 40, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1, sound = 1, authentic = 1, mystery = 1}, boosts = {spd = -2}, secondary = nil, target = "normal", type = "Steel", zMove = {boost = {spa = 1}}, contestType = "Clever"},
    meteorassault = {num = 794, accuracy = 100, basePower = 150, category = "Physical", name = "Meteor Assault", pp = 5, priority = 0, flags = {protect = 1, recharge = 1, mirror = 1}, self = {volatileStatus = "mustrecharge"}, secondary = nil, target = "normal", type = "Fighting"},
    meteorbeam = {
        num = 800,
        accuracy = 90,
        basePower = 120,
        category = "Special",
        name = "Meteor Beam",
        pp = 10,
        priority = 0,
        flags = {charge = 1, protect = 1, mirror = 1},
        onTryMove = function(self, attacker, defender, move)
            if attacker:removeVolatile(move.id) then
                return
            end
            self:add("-prepare", attacker, move.name)
            self:boost({spa = 1}, attacker, attacker, move)
            if not self:runEvent("ChargeMove", attacker, defender, move) then
                return
            end
            attacker:addVolatile("twoturnmove", defender)
            return nil
        end,
        secondary = nil,
        target = "normal",
        type = "Rock"
    },
    meteormash = {num = 309, accuracy = 90, basePower = 90, category = "Physical", name = "Meteor Mash", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, secondary = {chance = 20, self = {boosts = {atk = 1}}}, target = "normal", type = "Steel", contestType = "Cool"},
    metronome = {
        num = 118,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Metronome",
        pp = 10,
        priority = 0,
        flags = {},
        noMetronome = {"After You", "Apple Acid", "Assist", "Astral Barrage", "Aura Wheel", "Baneful Bunker", "Beak Blast", "Behemoth Bash", "Behemoth Blade", "Belch", "Bestow", "Body Press", "Branch Poke", "Breaking Swipe", "Celebrate", "Chatter", "Clangorous Soul", "Copycat", "Counter", "Covet", "Crafty Shield", "Decorate", "Destiny Bond", "Detect", "Diamond Storm", "Double Iron Bash", "Dragon Ascent", "Dragon Energy", "Drum Beating", "Dynamax Cannon", "Endure", "Eternabeam", "False Surrender", "Feint", "Fiery Wrath", "Fleur Cannon", "Focus Punch", "Follow Me", "Freeze Shock", "Freezing Glare", "Glacial Lance", "Grav Apple", "Helping Hand", "Hold Hands", "Hyperspace Fury", "Hyperspace Hole", "Ice Burn", "Instruct", "Jungle Healing", "King's Shield", "Life Dew", "Light of Ruin", "Mat Block", "Me First", "Meteor Assault", "Metronome", "Mimic", "Mind Blown", "Mirror Coat", "Mirror Move", "Moongeist Beam", "Nature Power", "Nature's Madness", "Obstruct", "Origin Pulse", "Overdrive", "Photon Geyser", "Plasma Fists", "Precipice Blades", "Protect", "Pyro Ball", "Quash", "Quick Guard", "Rage Powder", "Relic Song", "Secret Sword", "Shell Trap", "Sketch", "Sleep Talk", "Snap Trap", "Snarl", "Snatch", "Snore", "Spectral Thief", "Spiky Shield", "Spirit Break", "Spotlight", "Steam Eruption", "Steel Beam", "Strange Steam", "Struggle", "Sunsteel Strike", "Surging Strikes", "Switcheroo", "Techno Blast", "Thief", "Thousand Arrows", "Thousand Waves", "Thunder Cage", "Thunderous Kick", "Transform", "Trick", "V-create", "Wicked Blow", "Wide Guard"},
        onHit = function(self, target, source, effect)
            local moves = {}
            for id in pairs(____exports.Moves) do
                do
                    local move = ____exports.Moves[id]
                    if move.realMove then
                        goto __continue938
                    end
                    if (move.isZ or move.isMax) or move.isNonstandard then
                        goto __continue938
                    end
                    if effect.noMetronome:includes(move.name) then
                        goto __continue938
                    end
                    if self.dex.moves:get(id).gen > self.gen then
                        goto __continue938
                    end
                    __TS__ArrayPush(moves, move)
                end
                ::__continue938::
            end
            local randomMove = ""
            if #moves then
                __TS__ArraySort(
                    moves,
                    function(____, a, b) return a.num - b.num end
                )
                randomMove = self:sample(moves).name
            end
            if not randomMove then
                return false
            end
            self.actions:useMove(randomMove, target)
        end,
        secondary = nil,
        target = "self",
        type = "Normal",
        contestType = "Cute"
    },
    milkdrink = {num = 208, accuracy = true, basePower = 0, category = "Status", name = "Milk Drink", pp = 10, priority = 0, flags = {snatch = 1, heal = 1}, heal = {1, 2}, secondary = nil, target = "self", type = "Normal", zMove = {effect = "clearnegativeboost"}, contestType = "Cute"},
    mimic = {
        num = 102,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Mimic",
        pp = 10,
        priority = 0,
        flags = {protect = 1, authentic = 1, mystery = 1},
        onHit = function(self, target, source)
            local disallowedMoves = {"chatter", "mimic", "sketch", "struggle", "transform"}
            local move = target.lastMove
            if ((source.transformed or (not move)) or disallowedMoves:includes(move.id)) or source.moves:includes(move.id) then
                return false
            end
            if move.isZ or move.isMax then
                return false
            end
            local mimicIndex = source.moves:indexOf("mimic")
            if mimicIndex < 0 then
                return false
            end
            source.moveSlots[mimicIndex] = {move = move.name, id = move.id, pp = move.pp, maxpp = move.pp, target = move.target, disabled = false, used = false, virtual = true}
            self:add("-start", source, "Mimic", move.name)
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {accuracy = 1}},
        contestType = "Cute"
    },
    mindblown = {
        num = 720,
        accuracy = 100,
        basePower = 150,
        category = "Special",
        name = "Mind Blown",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        mindBlownRecoil = true,
        onAfterMove = function(self, pokemon, target, move)
            if move.mindBlownRecoil and (not move.multihit) then
                self:damage(
                    math.floor((pokemon.maxhp / 2) + 0.5),
                    pokemon,
                    pokemon,
                    self.dex.conditions:get("Mind Blown"),
                    true
                )
            end
        end,
        secondary = nil,
        target = "allAdjacent",
        type = "Fire",
        contestType = "Cool"
    },
    mindreader = {
        num = 170,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Mind Reader",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onTryHit = function(self, target, source)
            if source.volatiles.lockon then
                return false
            end
        end,
        onHit = function(self, target, source)
            source:addVolatile("lockon", target)
            self:add(
                "-activate",
                source,
                "move: Mind Reader",
                "[of] " .. tostring(target)
            )
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {spa = 1}},
        contestType = "Clever"
    },
    minimize = {
        num = 107,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Minimize",
        pp = 10,
        priority = 0,
        flags = {snatch = 1},
        volatileStatus = "minimize",
        condition = {
            noCopy = true,
            onSourceModifyDamage = function(self, damage, source, target, move)
                local boostedMoves = {"stomp", "steamroller", "bodyslam", "flyingpress", "dragonrush", "heatcrash", "heavyslam", "maliciousmoonsault"}
                if boostedMoves:includes(move.id) then
                    return self:chainModify(2)
                end
            end,
            onAccuracy = function(self, accuracy, target, source, move)
                local boostedMoves = {"stomp", "steamroller", "bodyslam", "flyingpress", "dragonrush", "heatcrash", "heavyslam", "maliciousmoonsault"}
                if boostedMoves:includes(move.id) then
                    return true
                end
                return accuracy
            end
        },
        boosts = {evasion = 2},
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Cute"
    },
    miracleeye = {
        num = 357,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Miracle Eye",
        pp = 40,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, authentic = 1},
        volatileStatus = "miracleeye",
        onTryHit = function(self, target)
            if target.volatiles.foresight then
                return false
            end
        end,
        condition = {
            noCopy = true,
            onStart = function(self, pokemon)
                self:add("-start", pokemon, "Miracle Eye")
            end,
            onNegateImmunity = function(self, pokemon, ____type)
                if pokemon:hasType("Dark") and (____type == "Psychic") then
                    return false
                end
            end,
            onModifyBoost = function(self, boosts)
                if boosts.evasion and (boosts.evasion > 0) then
                    boosts.evasion = 0
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Psychic",
        zMove = {boost = {spa = 1}},
        contestType = "Clever"
    },
    mirrorcoat = {
        num = 243,
        accuracy = 100,
        basePower = 0,
        damageCallback = function(self, pokemon)
            if not pokemon.volatiles.mirrorcoat then
                return 0
            end
            return pokemon.volatiles.mirrorcoat.damage or 1
        end,
        category = "Special",
        name = "Mirror Coat",
        pp = 20,
        priority = -5,
        flags = {protect = 1},
        beforeTurnCallback = function(self, pokemon)
            pokemon:addVolatile("mirrorcoat")
        end,
        onTryHit = function(self, target, source, move)
            if not source.volatiles.mirrorcoat then
                return false
            end
            if source.volatiles.mirrorcoat.slot == nil then
                return false
            end
        end,
        condition = {
            duration = 1,
            noCopy = true,
            onStart = function(self, target, source, move)
                self.effectState.slot = nil
                self.effectState.damage = 0
            end,
            onRedirectTargetPriority = -1,
            onRedirectTarget = function(self, target, source, source2, move)
                if move.id ~= "mirrorcoat" then
                    return
                end
                if (source ~= self.effectState.target) or (not self.effectState.slot) then
                    return
                end
                return self:getAtSlot(self.effectState.slot)
            end,
            onDamagingHit = function(self, damage, target, source, move)
                if (not source:isAlly(target)) and (self:getCategory(move) == "Special") then
                    self.effectState.slot = source:getSlot()
                    self.effectState.damage = 2 * damage
                end
            end
        },
        secondary = nil,
        target = "scripted",
        type = "Psychic",
        contestType = "Beautiful"
    },
    mirrormove = {
        num = 119,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Mirror Move",
        pp = 20,
        priority = 0,
        flags = {},
        onTryHit = function(self, target, pokemon)
            local move = target.lastMove
            if ((not move.flags.mirror) or move.isZ) or move.isMax then
                return false
            end
            self.actions:useMove(move.id, pokemon, target)
            return nil
        end,
        secondary = nil,
        target = "normal",
        type = "Flying",
        zMove = {boost = {atk = 2}},
        contestType = "Clever"
    },
    mirrorshot = {num = 429, accuracy = 85, basePower = 65, category = "Special", isNonstandard = "Past", name = "Mirror Shot", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 30, boosts = {accuracy = -1}}, target = "normal", type = "Steel", contestType = "Beautiful"},
    mist = {
        num = 54,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Mist",
        pp = 30,
        priority = 0,
        flags = {snatch = 1},
        sideCondition = "mist",
        condition = {
            duration = 5,
            onBoost = function(self, boost, target, source, effect)
                if ((effect.effectType == "Move") and effect.infiltrates) and (not target:isAlly(source)) then
                    return
                end
                if source and (target ~= source) then
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
                        self:add("-activate", target, "move: Mist")
                    end
                end
            end,
            onSideStart = function(self, side)
                self:add("-sidestart", side, "Mist")
            end,
            onSideResidualOrder = 26,
            onSideResidualSubOrder = 4,
            onSideEnd = function(self, side)
                self:add("-sideend", side, "Mist")
            end
        },
        secondary = nil,
        target = "allySide",
        type = "Ice",
        zMove = {effect = "heal"},
        contestType = "Beautiful"
    },
    mistball = {num = 296, accuracy = 100, basePower = 70, category = "Special", name = "Mist Ball", pp = 5, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, secondary = {chance = 50, boosts = {spa = -1}}, target = "normal", type = "Psychic", contestType = "Clever"},
    mistyexplosion = {
        num = 802,
        accuracy = 100,
        basePower = 100,
        category = "Special",
        name = "Misty Explosion",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        selfdestruct = "always",
        onBasePower = function(self, basePower, source)
            if self.field:isTerrain("mistyterrain") and source:isGrounded() then
                self:debug("misty terrain boost")
                return self:chainModify(1.5)
            end
        end,
        secondary = nil,
        target = "allAdjacent",
        type = "Fairy"
    },
    mistyterrain = {
        num = 581,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Misty Terrain",
        pp = 10,
        priority = 0,
        flags = {nonsky = 1},
        terrain = "mistyterrain",
        condition = {
            duration = 5,
            durationCallback = function(self, source, effect)
                if source:hasItem("terrainextender") then
                    return 8
                end
                return 5
            end,
            onSetStatus = function(self, status, target, source, effect)
                if (not target:isGrounded()) or target:isSemiInvulnerable() then
                    return
                end
                if effect and (effect.status or (effect.id == "yawn")) then
                    self:add("-activate", target, "move: Misty Terrain")
                end
                return false
            end,
            onTryAddVolatile = function(self, status, target, source, effect)
                if (not target:isGrounded()) or target:isSemiInvulnerable() then
                    return
                end
                if status.id == "confusion" then
                    if (effect.effectType == "Move") and (not effect.secondaries) then
                        self:add("-activate", target, "move: Misty Terrain")
                    end
                    return nil
                end
            end,
            onBasePowerPriority = 6,
            onBasePower = function(self, basePower, attacker, defender, move)
                if ((move.type == "Dragon") and defender:isGrounded()) and (not defender:isSemiInvulnerable()) then
                    self:debug("misty terrain weaken")
                    return self:chainModify(0.5)
                end
            end,
            onFieldStart = function(self, field, source, effect)
                if effect.effectType == "Ability" then
                    self:add(
                        "-fieldstart",
                        "move: Misty Terrain",
                        "[from] ability: " .. tostring(effect),
                        "[of] " .. tostring(source)
                    )
                else
                    self:add("-fieldstart", "move: Misty Terrain")
                end
            end,
            onFieldResidualOrder = 27,
            onFieldResidualSubOrder = 7,
            onFieldEnd = function(self)
                self:add("-fieldend", "Misty Terrain")
            end
        },
        secondary = nil,
        target = "all",
        type = "Fairy",
        zMove = {boost = {spd = 1}},
        contestType = "Beautiful"
    },
    moonblast = {num = 585, accuracy = 100, basePower = 95, category = "Special", name = "Moonblast", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 30, boosts = {spa = -1}}, target = "normal", type = "Fairy", contestType = "Beautiful"},
    moongeistbeam = {num = 714, accuracy = 100, basePower = 100, category = "Special", name = "Moongeist Beam", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, ignoreAbility = true, secondary = nil, target = "normal", type = "Ghost", contestType = "Cool"},
    moonlight = {
        num = 236,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Moonlight",
        pp = 5,
        priority = 0,
        flags = {snatch = 1, heal = 1},
        onHit = function(self, pokemon)
            local factor = 0.5
            local ____switch1006 = pokemon:effectiveWeather()
            if ____switch1006 == "sunnyday" then
                goto ____switch1006_case_0
            elseif ____switch1006 == "desolateland" then
                goto ____switch1006_case_1
            elseif ____switch1006 == "raindance" then
                goto ____switch1006_case_2
            elseif ____switch1006 == "primordialsea" then
                goto ____switch1006_case_3
            elseif ____switch1006 == "sandstorm" then
                goto ____switch1006_case_4
            elseif ____switch1006 == "hail" then
                goto ____switch1006_case_5
            end
            goto ____switch1006_end
            ::____switch1006_case_0::
            do
            end
            ::____switch1006_case_1::
            do
                factor = 0.667
                goto ____switch1006_end
            end
            ::____switch1006_case_2::
            do
            end
            ::____switch1006_case_3::
            do
            end
            ::____switch1006_case_4::
            do
            end
            ::____switch1006_case_5::
            do
                factor = 0.25
                goto ____switch1006_end
            end
            ::____switch1006_end::
            return not (not self:heal(
                self:modify(pokemon.maxhp, factor)
            ))
        end,
        secondary = nil,
        target = "self",
        type = "Fairy",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Beautiful"
    },
    morningsun = {
        num = 234,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Morning Sun",
        pp = 5,
        priority = 0,
        flags = {snatch = 1, heal = 1},
        onHit = function(self, pokemon)
            local factor = 0.5
            local ____switch1008 = pokemon:effectiveWeather()
            if ____switch1008 == "sunnyday" then
                goto ____switch1008_case_0
            elseif ____switch1008 == "desolateland" then
                goto ____switch1008_case_1
            elseif ____switch1008 == "raindance" then
                goto ____switch1008_case_2
            elseif ____switch1008 == "primordialsea" then
                goto ____switch1008_case_3
            elseif ____switch1008 == "sandstorm" then
                goto ____switch1008_case_4
            elseif ____switch1008 == "hail" then
                goto ____switch1008_case_5
            end
            goto ____switch1008_end
            ::____switch1008_case_0::
            do
            end
            ::____switch1008_case_1::
            do
                factor = 0.667
                goto ____switch1008_end
            end
            ::____switch1008_case_2::
            do
            end
            ::____switch1008_case_3::
            do
            end
            ::____switch1008_case_4::
            do
            end
            ::____switch1008_case_5::
            do
                factor = 0.25
                goto ____switch1008_end
            end
            ::____switch1008_end::
            return not (not self:heal(
                self:modify(pokemon.maxhp, factor)
            ))
        end,
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Beautiful"
    },
    mudbomb = {num = 426, accuracy = 85, basePower = 65, category = "Special", isNonstandard = "Past", name = "Mud Bomb", pp = 10, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, secondary = {chance = 30, boosts = {accuracy = -1}}, target = "normal", type = "Ground", contestType = "Cute"},
    mudshot = {num = 341, accuracy = 95, basePower = 55, category = "Special", name = "Mud Shot", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {spe = -1}}, target = "normal", type = "Ground", contestType = "Tough"},
    mudslap = {num = 189, accuracy = 100, basePower = 20, category = "Special", name = "Mud-Slap", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {accuracy = -1}}, target = "normal", type = "Ground", contestType = "Cute"},
    mudsport = {
        num = 300,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Mud Sport",
        pp = 15,
        priority = 0,
        flags = {nonsky = 1},
        pseudoWeather = "mudsport",
        condition = {
            duration = 5,
            onFieldStart = function(self, field, source)
                self:add(
                    "-fieldstart",
                    "move: Mud Sport",
                    "[of] " .. tostring(source)
                )
            end,
            onBasePowerPriority = 1,
            onBasePower = function(self, basePower, attacker, defender, move)
                if move.type == "Electric" then
                    self:debug("mud sport weaken")
                    return self:chainModify({1352, 4096})
                end
            end,
            onFieldResidualOrder = 27,
            onFieldResidualSubOrder = 4,
            onFieldEnd = function(self)
                self:add("-fieldend", "move: Mud Sport")
            end
        },
        secondary = nil,
        target = "all",
        type = "Ground",
        zMove = {boost = {spd = 1}},
        contestType = "Cute"
    },
    muddywater = {num = 330, accuracy = 85, basePower = 90, category = "Special", name = "Muddy Water", pp = 10, priority = 0, flags = {protect = 1, mirror = 1, nonsky = 1}, secondary = {chance = 30, boosts = {accuracy = -1}}, target = "allAdjacentFoes", type = "Water", contestType = "Tough"},
    multiattack = {
        num = 718,
        accuracy = 100,
        basePower = 120,
        category = "Physical",
        name = "Multi-Attack",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onModifyType = function(self, move, pokemon)
            if pokemon:ignoringItem() then
                return
            end
            move.type = self:runEvent("Memory", pokemon, nil, move, "Normal")
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {basePower = 185},
        maxMove = {basePower = 95},
        contestType = "Tough"
    },
    mysticalfire = {num = 595, accuracy = 100, basePower = 75, category = "Special", name = "Mystical Fire", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {spa = -1}}, target = "normal", type = "Fire", contestType = "Beautiful"},
    nastyplot = {num = 417, accuracy = true, basePower = 0, category = "Status", name = "Nasty Plot", pp = 20, priority = 0, flags = {snatch = 1}, boosts = {spa = 2}, secondary = nil, target = "self", type = "Dark", zMove = {effect = "clearnegativeboost"}, contestType = "Clever"},
    naturalgift = {
        num = 363,
        accuracy = 100,
        basePower = 0,
        category = "Physical",
        isNonstandard = "Past",
        name = "Natural Gift",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onModifyType = function(self, move, pokemon)
            if pokemon:ignoringItem() then
                return
            end
            local item = pokemon:getItem()
            if not item.naturalGift then
                return
            end
            move.type = item.naturalGift.type
        end,
        onPrepareHit = function(self, target, pokemon, move)
            if pokemon:ignoringItem() then
                return false
            end
            local item = pokemon:getItem()
            if not item.naturalGift then
                return false
            end
            move.basePower = item.naturalGift.basePower
            pokemon:setItem("")
            pokemon.lastItem = item.id
            pokemon.usedItemThisTurn = true
            self:runEvent("AfterUseItem", pokemon, nil, nil, item)
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {basePower = 160},
        maxMove = {basePower = 130},
        contestType = "Clever"
    },
    naturepower = {
        num = 267,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Nature Power",
        pp = 20,
        priority = 0,
        flags = {},
        onTryHit = function(self, target, pokemon)
            local move = "triattack"
            if self.field:isTerrain("electricterrain") then
                move = "thunderbolt"
            elseif self.field:isTerrain("grassyterrain") then
                move = "energyball"
            elseif self.field:isTerrain("mistyterrain") then
                move = "moonblast"
            elseif self.field:isTerrain("psychicterrain") then
                move = "psychic"
            end
            self.actions:useMove(move, pokemon, target)
            return nil
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Beautiful"
    },
    naturesmadness = {
        num = 717,
        accuracy = 90,
        basePower = 0,
        damageCallback = function(self, pokemon, target)
            return self:clampIntRange(
                math.floor(
                    target:getUndynamaxedHP() / 2
                ),
                1
            )
        end,
        category = "Special",
        name = "Nature's Madness",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Fairy",
        contestType = "Tough"
    },
    needlearm = {num = 302, accuracy = 100, basePower = 60, category = "Physical", isNonstandard = "Past", name = "Needle Arm", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 30, volatileStatus = "flinch"}, target = "normal", type = "Grass", contestType = "Clever"},
    neverendingnightmare = {num = 636, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Never-Ending Nightmare", pp = 1, priority = 0, flags = {}, isZ = "ghostiumz", secondary = nil, target = "normal", type = "Ghost", contestType = "Cool"},
    nightdaze = {num = 539, accuracy = 95, basePower = 85, category = "Special", name = "Night Daze", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 40, boosts = {accuracy = -1}}, target = "normal", type = "Dark", contestType = "Cool"},
    nightmare = {
        num = 171,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Nightmare",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        volatileStatus = "nightmare",
        condition = {
            noCopy = true,
            onStart = function(self, pokemon)
                if (pokemon.status ~= "slp") and (not pokemon:hasAbility("comatose")) then
                    return false
                end
                self:add("-start", pokemon, "Nightmare")
            end,
            onResidualOrder = 11,
            onResidual = function(self, pokemon)
                self:damage(pokemon.baseMaxhp / 4)
            end
        },
        secondary = nil,
        target = "normal",
        type = "Ghost",
        zMove = {boost = {spa = 1}},
        contestType = "Clever"
    },
    nightshade = {num = 101, accuracy = 100, basePower = 0, damage = "level", category = "Special", name = "Night Shade", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Ghost", contestType = "Clever"},
    nightslash = {num = 400, accuracy = 100, basePower = 70, category = "Physical", name = "Night Slash", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, critRatio = 2, secondary = nil, target = "normal", type = "Dark", contestType = "Cool"},
    nobleroar = {num = 568, accuracy = 100, basePower = 0, category = "Status", name = "Noble Roar", pp = 30, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1, sound = 1, authentic = 1}, boosts = {atk = -1, spa = -1}, secondary = nil, target = "normal", type = "Normal", zMove = {boost = {def = 1}}, contestType = "Tough"},
    noretreat = {
        num = 748,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "No Retreat",
        pp = 5,
        priority = 0,
        flags = {snatch = 1},
        volatileStatus = "noretreat",
        onTry = function(self, source, target, move)
            if source.volatiles.noretreat then
                return false
            end
            if source.volatiles.trapped then
                __TS__Delete(move, "volatileStatus")
            end
        end,
        condition = {
            onStart = function(self, pokemon)
                self:add("-start", pokemon, "move: No Retreat")
            end,
            onTrapPokemon = function(self, pokemon)
                pokemon:tryTrap()
            end
        },
        boosts = {atk = 1, def = 1, spa = 1, spd = 1, spe = 1},
        secondary = nil,
        target = "self",
        type = "Fighting"
    },
    nuzzle = {num = 609, accuracy = 100, basePower = 20, category = "Physical", name = "Nuzzle", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 100, status = "par"}, target = "normal", type = "Electric", contestType = "Cute"},
    oblivionwing = {num = 613, accuracy = 100, basePower = 80, category = "Special", name = "Oblivion Wing", pp = 10, priority = 0, flags = {protect = 1, mirror = 1, distance = 1, heal = 1}, drain = {3, 4}, secondary = nil, target = "any", type = "Flying", contestType = "Cool"},
    obstruct = {
        num = 792,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Obstruct",
        pp = 10,
        priority = 4,
        flags = {},
        stallingMove = true,
        volatileStatus = "obstruct",
        onPrepareHit = function(self, pokemon)
            return (not (not self.queue:willAct())) and self:runEvent("StallMove", pokemon)
        end,
        onHit = function(self, pokemon)
            pokemon:addVolatile("stall")
        end,
        condition = {
            duration = 1,
            onStart = function(self, target)
                self:add("-singleturn", target, "Protect")
            end,
            onTryHitPriority = 3,
            onTryHit = function(self, target, source, move)
                if (not move.flags.protect) or (move.category == "Status") then
                    if ({"gmaxoneblow", "gmaxrapidflow"}):includes(move.id) then
                        return
                    end
                    if move.isZ or move.isMax then
                        target:getMoveHitData(move).zBrokeProtect = true
                    end
                    return
                end
                if move.smartTarget then
                    move.smartTarget = false
                else
                    self:add("-activate", target, "move: Protect")
                end
                local lockedmove = source:getVolatile("lockedmove")
                if lockedmove then
                    if source.volatiles.lockedmove.duration == 2 then
                        __TS__Delete(source.volatiles, "lockedmove")
                    end
                end
                if self:checkMoveMakesContact(move, source, target) then
                    self:boost(
                        {def = -2},
                        source,
                        target,
                        self.dex:getActiveMove("Obstruct")
                    )
                end
                return self.NOT_FAIL
            end,
            onHit = function(self, target, source, move)
                if move.isZOrMaxPowered and self:checkMoveMakesContact(move, source, target) then
                    self:boost(
                        {def = -2},
                        source,
                        target,
                        self.dex:getActiveMove("Obstruct")
                    )
                end
            end
        },
        secondary = nil,
        target = "self",
        type = "Dark"
    },
    oceanicoperetta = {num = 697, accuracy = true, basePower = 195, category = "Special", isNonstandard = "Past", name = "Oceanic Operetta", pp = 1, priority = 0, flags = {}, isZ = "primariumz", secondary = nil, target = "normal", type = "Water", contestType = "Cool"},
    octazooka = {num = 190, accuracy = 85, basePower = 65, category = "Special", name = "Octazooka", pp = 10, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, secondary = {chance = 50, boosts = {accuracy = -1}}, target = "normal", type = "Water", contestType = "Tough"},
    octolock = {
        num = 753,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Octolock",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onTryImmunity = function(self, target)
            return self.dex:getImmunity("trapped", target)
        end,
        volatileStatus = "octolock",
        condition = {
            onStart = function(self, pokemon, source)
                self:add(
                    "-start",
                    pokemon,
                    "move: Octolock",
                    "[of] " .. tostring(source)
                )
            end,
            onResidualOrder = 14,
            onResidual = function(self, pokemon)
                local source = self.effectState.source
                if source and (((not source.isActive) or (source.hp <= 0)) or (not source.activeTurns)) then
                    __TS__Delete(pokemon.volatiles, "octolock")
                    self:add("-end", pokemon, "Octolock", "[partiallytrapped]", "[silent]")
                    return
                end
                self:boost(
                    {def = -1, spd = -1},
                    pokemon,
                    source,
                    self.dex:getActiveMove("octolock")
                )
            end,
            onTrapPokemon = function(self, pokemon)
                if self.effectState.source and self.effectState.source.isActive then
                    pokemon:tryTrap()
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Fighting"
    },
    odorsleuth = {
        num = 316,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Odor Sleuth",
        pp = 40,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, authentic = 1, mystery = 1},
        volatileStatus = "foresight",
        onTryHit = function(self, target)
            if target.volatiles.miracleeye then
                return false
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {atk = 1}},
        contestType = "Clever"
    },
    ominouswind = {num = 466, accuracy = 100, basePower = 60, category = "Special", isNonstandard = "Past", name = "Ominous Wind", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, self = {boosts = {atk = 1, def = 1, spa = 1, spd = 1, spe = 1}}}, target = "normal", type = "Ghost", contestType = "Beautiful"},
    originpulse = {num = 618, accuracy = 85, basePower = 110, category = "Special", name = "Origin Pulse", pp = 10, priority = 0, flags = {protect = 1, pulse = 1, mirror = 1}, target = "allAdjacentFoes", type = "Water", contestType = "Beautiful"},
    outrage = {
        num = 200,
        accuracy = 100,
        basePower = 120,
        category = "Physical",
        name = "Outrage",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        self = {volatileStatus = "lockedmove"},
        onAfterMove = function(self, pokemon)
            if pokemon.volatiles.lockedmove and (pokemon.volatiles.lockedmove.duration == 1) then
                pokemon:removeVolatile("lockedmove")
            end
        end,
        secondary = nil,
        target = "randomNormal",
        type = "Dragon",
        contestType = "Cool"
    },
    overdrive = {num = 786, accuracy = 100, basePower = 80, category = "Special", name = "Overdrive", pp = 10, priority = 0, flags = {protect = 1, mirror = 1, sound = 1, authentic = 1}, secondary = nil, target = "allAdjacentFoes", type = "Electric"},
    overheat = {num = 315, accuracy = 90, basePower = 130, category = "Special", name = "Overheat", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, self = {boosts = {spa = -2}}, secondary = nil, target = "normal", type = "Fire", contestType = "Beautiful"},
    painsplit = {
        num = 220,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Pain Split",
        pp = 20,
        priority = 0,
        flags = {protect = 1, mirror = 1, mystery = 1},
        onHit = function(self, target, pokemon)
            local targetHP = target:getUndynamaxedHP()
            local averagehp = math.floor((targetHP + pokemon.hp) / 2) or 1
            local targetChange = targetHP - averagehp
            target:sethp(target.hp - targetChange)
            self:add("-sethp", target, target.getHealth, "[from] move: Pain Split", "[silent]")
            pokemon:sethp(averagehp)
            self:add("-sethp", pokemon, pokemon.getHealth, "[from] move: Pain Split")
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {def = 1}},
        contestType = "Clever"
    },
    paleowave = {num = 0, accuracy = 100, basePower = 85, category = "Special", isNonstandard = "CAP", name = "Paleo Wave", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 20, boosts = {atk = -1}}, target = "normal", type = "Rock", contestType = "Beautiful"},
    paraboliccharge = {num = 570, accuracy = 100, basePower = 65, category = "Special", name = "Parabolic Charge", pp = 20, priority = 0, flags = {protect = 1, mirror = 1, heal = 1}, drain = {1, 2}, secondary = nil, target = "allAdjacent", type = "Electric", contestType = "Clever"},
    partingshot = {
        num = 575,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Parting Shot",
        pp = 20,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, sound = 1, authentic = 1},
        onHit = function(self, target, source, move)
            local success = self:boost({atk = -1, spa = -1}, target, source)
            if (not success) and (not target:hasAbility("mirrorarmor")) then
                __TS__Delete(move, "selfSwitch")
            end
        end,
        selfSwitch = true,
        secondary = nil,
        target = "normal",
        type = "Dark",
        zMove = {effect = "healreplacement"},
        contestType = "Cool"
    },
    payback = {
        num = 371,
        accuracy = 100,
        basePower = 50,
        basePowerCallback = function(self, pokemon, target, move)
            if target.newlySwitched or self.queue:willMove(target) then
                self:debug("Payback NOT boosted")
                return move.basePower
            end
            self:debug("Payback damage boost")
            return move.basePower * 2
        end,
        category = "Physical",
        name = "Payback",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Dark",
        contestType = "Tough"
    },
    payday = {
        num = 6,
        accuracy = 100,
        basePower = 40,
        category = "Physical",
        name = "Pay Day",
        pp = 20,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onHit = function(self)
            self:add("-fieldactivate", "move: Pay Day")
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Clever"
    },
    peck = {num = 64, accuracy = 100, basePower = 35, category = "Physical", name = "Peck", pp = 35, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, distance = 1}, secondary = nil, target = "any", type = "Flying", contestType = "Cool"},
    perishsong = {
        num = 195,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Perish Song",
        pp = 5,
        priority = 0,
        flags = {sound = 1, distance = 1, authentic = 1},
        onHitField = function(self, target, source, move)
            local result = false
            local message = false
            for ____, pokemon in __TS__Iterator(
                self:getAllActive()
            ) do
                if self:runEvent("Invulnerability", pokemon, source, move) == false then
                    self:add("-miss", source, pokemon)
                    result = true
                elseif self:runEvent("TryHit", pokemon, source, move) == nil then
                    result = true
                elseif not pokemon.volatiles.perishsong then
                    pokemon:addVolatile("perishsong")
                    self:add("-start", pokemon, "perish3", "[silent]")
                    result = true
                    message = true
                end
            end
            if not result then
                return false
            end
            if message then
                self:add("-fieldactivate", "move: Perish Song")
            end
        end,
        condition = {
            duration = 4,
            onEnd = function(self, target)
                self:add("-start", target, "perish0")
                target:faint()
            end,
            onResidualOrder = 24,
            onResidual = function(self, pokemon)
                local duration = pokemon.volatiles.perishsong.duration
                self:add(
                    "-start",
                    pokemon,
                    "perish" .. tostring(duration)
                )
            end
        },
        secondary = nil,
        target = "all",
        type = "Normal",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Beautiful"
    },
    petalblizzard = {num = 572, accuracy = 100, basePower = 90, category = "Physical", name = "Petal Blizzard", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "allAdjacent", type = "Grass", contestType = "Beautiful"},
    petaldance = {
        num = 80,
        accuracy = 100,
        basePower = 120,
        category = "Special",
        name = "Petal Dance",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1, dance = 1},
        self = {volatileStatus = "lockedmove"},
        onAfterMove = function(self, pokemon)
            if pokemon.volatiles.lockedmove and (pokemon.volatiles.lockedmove.duration == 1) then
                pokemon:removeVolatile("lockedmove")
            end
        end,
        secondary = nil,
        target = "randomNormal",
        type = "Grass",
        contestType = "Beautiful"
    },
    phantomforce = {
        num = 566,
        accuracy = 100,
        basePower = 90,
        category = "Physical",
        name = "Phantom Force",
        pp = 10,
        priority = 0,
        flags = {contact = 1, charge = 1, mirror = 1},
        breaksProtect = true,
        onTryMove = function(self, attacker, defender, move)
            if attacker:removeVolatile(move.id) then
                return
            end
            self:add("-prepare", attacker, move.name)
            if not self:runEvent("ChargeMove", attacker, defender, move) then
                return
            end
            attacker:addVolatile("twoturnmove", defender)
            return nil
        end,
        condition = {duration = 2, onInvulnerability = false},
        secondary = nil,
        target = "normal",
        type = "Ghost",
        contestType = "Cool"
    },
    photongeyser = {
        num = 722,
        accuracy = 100,
        basePower = 100,
        category = "Special",
        name = "Photon Geyser",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onModifyMove = function(self, move, pokemon)
            if pokemon:getStat("atk", false, true) > pokemon:getStat("spa", false, true) then
                move.category = "Physical"
            end
        end,
        ignoreAbility = true,
        secondary = nil,
        target = "normal",
        type = "Psychic",
        contestType = "Cool"
    },
    pikapapow = {
        num = 732,
        accuracy = true,
        basePower = 0,
        basePowerCallback = function(self, pokemon)
            return math.floor((pokemon.happiness * 10) / 25) or 1
        end,
        category = "Special",
        isNonstandard = "LGPE",
        name = "Pika Papow",
        pp = 20,
        priority = 0,
        flags = {protect = 1},
        secondary = nil,
        target = "normal",
        type = "Electric",
        contestType = "Cute"
    },
    pinmissile = {num = 42, accuracy = 95, basePower = 25, category = "Physical", name = "Pin Missile", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, multihit = {2, 5}, secondary = nil, target = "normal", type = "Bug", zMove = {basePower = 140}, maxMove = {basePower = 130}, contestType = "Cool"},
    plasmafists = {num = 721, accuracy = 100, basePower = 100, category = "Physical", name = "Plasma Fists", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, pseudoWeather = "iondeluge", secondary = nil, target = "normal", type = "Electric", contestType = "Cool"},
    playnice = {num = 589, accuracy = true, basePower = 0, category = "Status", name = "Play Nice", pp = 20, priority = 0, flags = {reflectable = 1, mirror = 1, authentic = 1}, boosts = {atk = -1}, secondary = nil, target = "normal", type = "Normal", zMove = {boost = {def = 1}}, contestType = "Cute"},
    playrough = {num = 583, accuracy = 90, basePower = 90, category = "Physical", name = "Play Rough", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 10, boosts = {atk = -1}}, target = "normal", type = "Fairy", contestType = "Cute"},
    pluck = {
        num = 365,
        accuracy = 100,
        basePower = 60,
        category = "Physical",
        name = "Pluck",
        pp = 20,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1, distance = 1},
        onHit = function(self, target, source)
            local item = target:getItem()
            if (source.hp and item.isBerry) and target:takeItem(source) then
                self:add(
                    "-enditem",
                    target,
                    item.name,
                    "[from] stealeat",
                    "[move] Pluck",
                    "[of] " .. tostring(source)
                )
                if self:singleEvent("Eat", item, nil, source, nil, nil) then
                    self:runEvent("EatItem", source, nil, nil, item)
                    if item.id == "leppaberry" then
                        target.staleness = "external"
                    end
                end
                if item.onEat then
                    source.ateBerry = true
                end
            end
        end,
        secondary = nil,
        target = "any",
        type = "Flying",
        contestType = "Cute"
    },
    poisonfang = {num = 305, accuracy = 100, basePower = 50, category = "Physical", name = "Poison Fang", pp = 15, priority = 0, flags = {bite = 1, contact = 1, protect = 1, mirror = 1}, secondary = {chance = 50, status = "tox"}, target = "normal", type = "Poison", contestType = "Clever"},
    poisongas = {num = 139, accuracy = 90, basePower = 0, category = "Status", name = "Poison Gas", pp = 40, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, status = "psn", secondary = nil, target = "allAdjacentFoes", type = "Poison", zMove = {boost = {def = 1}}, contestType = "Clever"},
    poisonjab = {num = 398, accuracy = 100, basePower = 80, category = "Physical", name = "Poison Jab", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 30, status = "psn"}, target = "normal", type = "Poison", contestType = "Tough"},
    poisonpowder = {num = 77, accuracy = 75, basePower = 0, category = "Status", name = "Poison Powder", pp = 35, priority = 0, flags = {powder = 1, protect = 1, reflectable = 1, mirror = 1}, status = "psn", secondary = nil, target = "normal", type = "Poison", zMove = {boost = {def = 1}}, contestType = "Clever"},
    poisonsting = {num = 40, accuracy = 100, basePower = 15, category = "Physical", name = "Poison Sting", pp = 35, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 30, status = "psn"}, target = "normal", type = "Poison", contestType = "Clever"},
    poisontail = {num = 342, accuracy = 100, basePower = 50, category = "Physical", name = "Poison Tail", pp = 25, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, critRatio = 2, secondary = {chance = 10, status = "psn"}, target = "normal", type = "Poison", contestType = "Clever"},
    pollenpuff = {
        num = 676,
        accuracy = 100,
        basePower = 90,
        category = "Special",
        name = "Pollen Puff",
        pp = 15,
        priority = 0,
        flags = {bullet = 1, protect = 1, mirror = 1},
        onTryHit = function(self, target, source, move)
            if source:isAlly(target) then
                move.basePower = 0
                move.infiltrates = true
            end
        end,
        onHit = function(self, target, source)
            if source:isAlly(target) then
                if not self:heal(
                    math.floor(target.baseMaxhp * 0.5)
                ) then
                    self:add("-immune", target)
                end
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Bug",
        contestType = "Cute"
    },
    poltergeist = {
        num = 809,
        accuracy = 90,
        basePower = 110,
        category = "Physical",
        name = "Poltergeist",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onTry = function(self, source, target)
            return not (not target.item)
        end,
        onTryHit = function(self, target, source, move)
            self:add(
                "-activate",
                target,
                "move: Poltergeist",
                self.dex.items:get(target.item).name
            )
        end,
        secondary = nil,
        target = "normal",
        type = "Ghost"
    },
    pound = {num = 1, accuracy = 100, basePower = 40, category = "Physical", name = "Pound", pp = 35, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Normal", contestType = "Tough"},
    powder = {
        num = 600,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Powder",
        pp = 20,
        priority = 1,
        flags = {powder = 1, protect = 1, reflectable = 1, mirror = 1, authentic = 1},
        volatileStatus = "powder",
        condition = {
            duration = 1,
            onStart = function(self, target)
                self:add("-singleturn", target, "Powder")
            end,
            onTryMovePriority = -1,
            onTryMove = function(self, pokemon, target, move)
                if move.type == "Fire" then
                    self:add("-activate", pokemon, "move: Powder")
                    self:damage(
                        self:clampIntRange(
                            math.floor((pokemon.maxhp / 4) + 0.5),
                            1
                        )
                    )
                    return false
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Bug",
        zMove = {boost = {spd = 2}},
        contestType = "Clever"
    },
    powdersnow = {num = 181, accuracy = 100, basePower = 40, category = "Special", name = "Powder Snow", pp = 25, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, status = "frz"}, target = "allAdjacentFoes", type = "Ice", contestType = "Beautiful"},
    powergem = {num = 408, accuracy = 100, basePower = 80, category = "Special", name = "Power Gem", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Rock", contestType = "Beautiful"},
    powersplit = {
        num = 471,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Power Split",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mystery = 1},
        onHit = function(self, target, source)
            local newatk = math.floor((target.storedStats.atk + source.storedStats.atk) / 2)
            target.storedStats.atk = newatk
            source.storedStats.atk = newatk
            local newspa = math.floor((target.storedStats.spa + source.storedStats.spa) / 2)
            target.storedStats.spa = newspa
            source.storedStats.spa = newspa
            self:add(
                "-activate",
                source,
                "move: Power Split",
                "[of] " .. tostring(target)
            )
        end,
        secondary = nil,
        target = "normal",
        type = "Psychic",
        zMove = {boost = {spe = 1}},
        contestType = "Clever"
    },
    powerswap = {
        num = 384,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Power Swap",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, authentic = 1, mystery = 1},
        onHit = function(self, target, source)
            local targetBoosts = {}
            local sourceBoosts = {}
            local atkSpa = {"atk", "spa"}
            for ____, stat in ipairs(atkSpa) do
                targetBoosts[stat] = target.boosts[stat]
                sourceBoosts[stat] = source.boosts[stat]
            end
            source:setBoost(targetBoosts)
            target:setBoost(sourceBoosts)
            self:add("-swapboost", source, target, "atk, spa", "[from] move: Power Swap")
        end,
        secondary = nil,
        target = "normal",
        type = "Psychic",
        zMove = {boost = {spe = 1}},
        contestType = "Clever"
    },
    powertrick = {
        num = 379,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Power Trick",
        pp = 10,
        priority = 0,
        flags = {snatch = 1},
        volatileStatus = "powertrick",
        condition = {
            onStart = function(self, pokemon)
                self:add("-start", pokemon, "Power Trick")
                local newatk = pokemon.storedStats.def
                local newdef = pokemon.storedStats.atk
                pokemon.storedStats.atk = newatk
                pokemon.storedStats.def = newdef
            end,
            onCopy = function(self, pokemon)
                local newatk = pokemon.storedStats.def
                local newdef = pokemon.storedStats.atk
                pokemon.storedStats.atk = newatk
                pokemon.storedStats.def = newdef
            end,
            onEnd = function(self, pokemon)
                self:add("-end", pokemon, "Power Trick")
                local newatk = pokemon.storedStats.def
                local newdef = pokemon.storedStats.atk
                pokemon.storedStats.atk = newatk
                pokemon.storedStats.def = newdef
            end,
            onRestart = function(self, pokemon)
                pokemon:removeVolatile("Power Trick")
            end
        },
        secondary = nil,
        target = "self",
        type = "Psychic",
        zMove = {boost = {atk = 1}},
        contestType = "Clever"
    },
    powertrip = {
        num = 681,
        accuracy = 100,
        basePower = 20,
        basePowerCallback = function(self, pokemon, target, move)
            return move.basePower + (20 * pokemon:positiveBoosts())
        end,
        category = "Physical",
        name = "Power Trip",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Dark",
        zMove = {basePower = 160},
        maxMove = {basePower = 130},
        contestType = "Clever"
    },
    poweruppunch = {num = 612, accuracy = 100, basePower = 40, category = "Physical", name = "Power-Up Punch", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, secondary = {chance = 100, self = {boosts = {atk = 1}}}, target = "normal", type = "Fighting", contestType = "Tough"},
    powerwhip = {num = 438, accuracy = 85, basePower = 120, category = "Physical", name = "Power Whip", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Grass", contestType = "Tough"},
    precipiceblades = {num = 619, accuracy = 85, basePower = 120, category = "Physical", name = "Precipice Blades", pp = 10, priority = 0, flags = {protect = 1, mirror = 1, nonsky = 1}, target = "allAdjacentFoes", type = "Ground", contestType = "Cool"},
    present = {
        num = 217,
        accuracy = 90,
        basePower = 0,
        category = "Physical",
        name = "Present",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onModifyMove = function(self, move, pokemon, target)
            local rand = self:random(10)
            if rand < 2 then
                move.heal = {1, 4}
                move.infiltrates = true
            elseif rand < 6 then
                move.basePower = 40
            elseif rand < 9 then
                move.basePower = 80
            else
                move.basePower = 120
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Cute"
    },
    prismaticlaser = {num = 711, accuracy = 100, basePower = 160, category = "Special", name = "Prismatic Laser", pp = 10, priority = 0, flags = {recharge = 1, protect = 1, mirror = 1}, self = {volatileStatus = "mustrecharge"}, secondary = nil, target = "normal", type = "Psychic", contestType = "Cool"},
    protect = {
        num = 182,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Protect",
        pp = 10,
        priority = 4,
        flags = {},
        stallingMove = true,
        volatileStatus = "protect",
        onPrepareHit = function(self, pokemon)
            return (not (not self.queue:willAct())) and self:runEvent("StallMove", pokemon)
        end,
        onHit = function(self, pokemon)
            pokemon:addVolatile("stall")
        end,
        condition = {
            duration = 1,
            onStart = function(self, target)
                self:add("-singleturn", target, "Protect")
            end,
            onTryHitPriority = 3,
            onTryHit = function(self, target, source, move)
                if not move.flags.protect then
                    if ({"gmaxoneblow", "gmaxrapidflow"}):includes(move.id) then
                        return
                    end
                    if move.isZ or move.isMax then
                        target:getMoveHitData(move).zBrokeProtect = true
                    end
                    return
                end
                if move.smartTarget then
                    move.smartTarget = false
                else
                    self:add("-activate", target, "move: Protect")
                end
                local lockedmove = source:getVolatile("lockedmove")
                if lockedmove then
                    if source.volatiles.lockedmove.duration == 2 then
                        __TS__Delete(source.volatiles, "lockedmove")
                    end
                end
                return self.NOT_FAIL
            end
        },
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Cute"
    },
    psybeam = {num = 60, accuracy = 100, basePower = 65, category = "Special", name = "Psybeam", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, volatileStatus = "confusion"}, target = "normal", type = "Psychic", contestType = "Beautiful"},
    psychup = {
        num = 244,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Psych Up",
        pp = 10,
        priority = 0,
        flags = {authentic = 1, mystery = 1},
        onHit = function(self, target, source)
            local i
            for ____value in pairs(target.boosts) do
                i = ____value
                source.boosts[i] = target.boosts[i]
            end
            local volatilesToCopy = {"focusenergy", "gmaxchistrike", "laserfocus"}
            for ____, volatile in ipairs(volatilesToCopy) do
                if target.volatiles[volatile] then
                    source:addVolatile(volatile)
                    if volatile == "gmaxchistrike" then
                        source.volatiles[volatile].layers = target.volatiles[volatile].layers
                    end
                else
                    source:removeVolatile(volatile)
                end
            end
            self:add("-copyboost", source, target, "[from] move: Psych Up")
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {effect = "heal"},
        contestType = "Clever"
    },
    psychic = {num = 94, accuracy = 100, basePower = 90, category = "Special", name = "Psychic", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, boosts = {spd = -1}}, target = "normal", type = "Psychic", contestType = "Clever"},
    psychicfangs = {
        num = 706,
        accuracy = 100,
        basePower = 85,
        category = "Physical",
        name = "Psychic Fangs",
        pp = 10,
        priority = 0,
        flags = {bite = 1, contact = 1, protect = 1, mirror = 1},
        onTryHit = function(self, pokemon)
            pokemon.side:removeSideCondition("reflect")
            pokemon.side:removeSideCondition("lightscreen")
            pokemon.side:removeSideCondition("auroraveil")
        end,
        secondary = nil,
        target = "normal",
        type = "Psychic",
        contestType = "Clever"
    },
    psychicterrain = {
        num = 678,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Psychic Terrain",
        pp = 10,
        priority = 0,
        flags = {nonsky = 1},
        terrain = "psychicterrain",
        condition = {
            duration = 5,
            durationCallback = function(self, source, effect)
                if source:hasItem("terrainextender") then
                    return 8
                end
                return 5
            end,
            onTryHitPriority = 4,
            onTryHit = function(self, target, source, effect)
                if effect and ((effect.priority <= 0.1) or (effect.target == "self")) then
                    return
                end
                if target:isSemiInvulnerable() or target:isAlly(source) then
                    return
                end
                if not target:isGrounded() then
                    local baseMove = self.dex.moves:get(effect.id)
                    if baseMove.priority > 0 then
                        self:hint("Psychic Terrain doesn't affect Pokémon immune to Ground.")
                    end
                    return
                end
                self:add("-activate", target, "move: Psychic Terrain")
                return nil
            end,
            onBasePowerPriority = 6,
            onBasePower = function(self, basePower, attacker, defender, move)
                if ((move.type == "Psychic") and attacker:isGrounded()) and (not attacker:isSemiInvulnerable()) then
                    self:debug("psychic terrain boost")
                    return self:chainModify({5325, 4096})
                end
            end,
            onFieldStart = function(self, field, source, effect)
                if effect.effectType == "Ability" then
                    self:add(
                        "-fieldstart",
                        "move: Psychic Terrain",
                        "[from] ability: " .. tostring(effect),
                        "[of] " .. tostring(source)
                    )
                else
                    self:add("-fieldstart", "move: Psychic Terrain")
                end
            end,
            onFieldResidualOrder = 27,
            onFieldResidualSubOrder = 7,
            onFieldEnd = function(self)
                self:add("-fieldend", "move: Psychic Terrain")
            end
        },
        secondary = nil,
        target = "all",
        type = "Psychic",
        zMove = {boost = {spa = 1}},
        contestType = "Clever"
    },
    psychoboost = {num = 354, accuracy = 90, basePower = 140, category = "Special", isNonstandard = "Past", name = "Psycho Boost", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, self = {boosts = {spa = -2}}, secondary = nil, target = "normal", type = "Psychic", contestType = "Clever"},
    psychocut = {num = 427, accuracy = 100, basePower = 70, category = "Physical", name = "Psycho Cut", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, critRatio = 2, secondary = nil, target = "normal", type = "Psychic", contestType = "Cool"},
    psychoshift = {
        num = 375,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Psycho Shift",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onTryHit = function(self, target, source, move)
            if not source.status then
                return false
            end
            move.status = source.status
        end,
        self = {
            onHit = function(self, pokemon)
                pokemon:cureStatus()
            end
        },
        secondary = nil,
        target = "normal",
        type = "Psychic",
        zMove = {boost = {spa = 2}},
        contestType = "Clever"
    },
    psyshock = {num = 473, accuracy = 100, basePower = 80, category = "Special", defensiveCategory = "Physical", name = "Psyshock", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Psychic", contestType = "Beautiful"},
    psystrike = {num = 540, accuracy = 100, basePower = 100, category = "Special", defensiveCategory = "Physical", name = "Psystrike", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Psychic", contestType = "Cool"},
    psywave = {
        num = 149,
        accuracy = 100,
        basePower = 0,
        damageCallback = function(self, pokemon)
            return (self:random(50, 151) * pokemon.level) / 100
        end,
        category = "Special",
        isNonstandard = "Past",
        name = "Psywave",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Psychic",
        contestType = "Clever"
    },
    pulverizingpancake = {num = 701, accuracy = true, basePower = 210, category = "Physical", isNonstandard = "Past", name = "Pulverizing Pancake", pp = 1, priority = 0, flags = {contact = 1}, isZ = "snorliumz", secondary = nil, target = "normal", type = "Normal", contestType = "Cool"},
    punishment = {
        num = 386,
        accuracy = 100,
        basePower = 0,
        basePowerCallback = function(self, pokemon, target)
            local power = 60 + (20 * target:positiveBoosts())
            if power > 200 then
                power = 200
            end
            return power
        end,
        category = "Physical",
        isNonstandard = "Past",
        name = "Punishment",
        pp = 5,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Dark",
        zMove = {basePower = 160},
        maxMove = {basePower = 130},
        contestType = "Cool"
    },
    purify = {
        num = 685,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Purify",
        pp = 20,
        priority = 0,
        flags = {protect = 1, reflectable = 1, heal = 1},
        onHit = function(self, target, source)
            if not target:cureStatus() then
                return false
            end
            self:heal(
                math.ceil(source.maxhp * 0.5),
                source
            )
        end,
        secondary = nil,
        target = "normal",
        type = "Poison",
        zMove = {boost = {atk = 1, def = 1, spa = 1, spd = 1, spe = 1}},
        contestType = "Beautiful"
    },
    pursuit = {
        num = 228,
        accuracy = 100,
        basePower = 40,
        basePowerCallback = function(self, pokemon, target, move)
            if target.beingCalledBack or target.switchFlag then
                self:debug("Pursuit damage boost")
                return move.basePower * 2
            end
            return move.basePower
        end,
        category = "Physical",
        isNonstandard = "Past",
        name = "Pursuit",
        pp = 20,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        beforeTurnCallback = function(self, pokemon)
            for ____, side in __TS__Iterator(self.sides) do
                do
                    if side:hasAlly(pokemon) then
                        goto __continue1152
                    end
                    side:addSideCondition("pursuit", pokemon)
                    local data = side:getSideConditionData("pursuit")
                    if not data.sources then
                        data.sources = {}
                    end
                    data.sources:push(pokemon)
                end
                ::__continue1152::
            end
        end,
        onModifyMove = function(self, move, source, target)
            if target.beingCalledBack or target.switchFlag then
                move.accuracy = true
            end
        end,
        onTryHit = function(self, target, pokemon)
            target.side:removeSideCondition("pursuit")
        end,
        condition = {
            duration = 1,
            onBeforeSwitchOut = function(self, pokemon)
                self:debug("Pursuit start")
                local alreadyAdded = false
                pokemon:removeVolatile("destinybond")
                for ____, source in __TS__Iterator(self.effectState.sources) do
                    do
                        if (not self.queue:cancelMove(source)) or (not source.hp) then
                            goto __continue1159
                        end
                        if not alreadyAdded then
                            self:add("-activate", pokemon, "move: Pursuit")
                            alreadyAdded = true
                        end
                        if source.canMegaEvo or source.canUltraBurst then
                            for ____, ____value in __TS__Iterator(
                                self.queue:entries()
                            ) do
                                local actionIndex
                                actionIndex = ____value[1]
                                local action
                                action = ____value[2]
                                if (action.pokemon == source) and (action.choice == "megaEvo") then
                                    self.actions:runMegaEvo(source)
                                    self.queue.list:splice(actionIndex, 1)
                                    break
                                end
                            end
                        end
                        self.actions:runMove(
                            "pursuit",
                            source,
                            source:getLocOf(pokemon)
                        )
                    end
                    ::__continue1159::
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Dark",
        contestType = "Clever"
    },
    pyroball = {num = 780, accuracy = 90, basePower = 120, category = "Physical", name = "Pyro Ball", pp = 5, priority = 0, flags = {protect = 1, mirror = 1, defrost = 1, bullet = 1}, secondary = {chance = 10, status = "brn"}, target = "normal", type = "Fire"},
    quash = {
        num = 511,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Quash",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onHit = function(self, target)
            if self.activePerHalf == 1 then
                return false
            end
            local action = self.queue:willMove(target)
            if not action then
                return false
            end
            action.order = 201
            self:add("-activate", target, "move: Quash")
        end,
        secondary = nil,
        target = "normal",
        type = "Dark",
        zMove = {boost = {spe = 1}},
        contestType = "Clever"
    },
    quickattack = {num = 98, accuracy = 100, basePower = 40, category = "Physical", name = "Quick Attack", pp = 30, priority = 1, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Normal", contestType = "Cool"},
    quickguard = {
        num = 501,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Quick Guard",
        pp = 15,
        priority = 3,
        flags = {snatch = 1},
        sideCondition = "quickguard",
        onTry = function(self)
            return not (not self.queue:willAct())
        end,
        onHitSide = function(self, side, source)
            source:addVolatile("stall")
        end,
        condition = {
            duration = 1,
            onSideStart = function(self, target, source)
                self:add("-singleturn", source, "Quick Guard")
            end,
            onTryHitPriority = 4,
            onTryHit = function(self, target, source, move)
                if move.priority <= 0.1 then
                    return
                end
                if not move.flags.protect then
                    if ({"gmaxoneblow", "gmaxrapidflow"}):includes(move.id) then
                        return
                    end
                    if move.isZ or move.isMax then
                        target:getMoveHitData(move).zBrokeProtect = true
                    end
                    return
                end
                self:add("-activate", target, "move: Quick Guard")
                local lockedmove = source:getVolatile("lockedmove")
                if lockedmove then
                    if source.volatiles.lockedmove.duration == 2 then
                        __TS__Delete(source.volatiles, "lockedmove")
                    end
                end
                return self.NOT_FAIL
            end
        },
        secondary = nil,
        target = "allySide",
        type = "Fighting",
        zMove = {boost = {def = 1}},
        contestType = "Cool"
    },
    quiverdance = {num = 483, accuracy = true, basePower = 0, category = "Status", name = "Quiver Dance", pp = 20, priority = 0, flags = {snatch = 1, dance = 1}, boosts = {spa = 1, spd = 1, spe = 1}, secondary = nil, target = "self", type = "Bug", zMove = {effect = "clearnegativeboost"}, contestType = "Beautiful"},
    rage = {
        num = 99,
        accuracy = 100,
        basePower = 20,
        category = "Physical",
        isNonstandard = "Past",
        name = "Rage",
        pp = 20,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        self = {volatileStatus = "rage"},
        condition = {
            onStart = function(self, pokemon)
                self:add("-singlemove", pokemon, "Rage")
            end,
            onHit = function(self, target, source, move)
                if (target ~= source) and (move.category ~= "Status") then
                    self:boost({atk = 1})
                end
            end,
            onBeforeMovePriority = 100,
            onBeforeMove = function(self, pokemon)
                self:debug("removing Rage before attack")
                pokemon:removeVolatile("rage")
            end
        },
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Tough"
    },
    ragepowder = {
        num = 476,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Rage Powder",
        pp = 20,
        priority = 2,
        flags = {powder = 1},
        volatileStatus = "ragepowder",
        onTry = function(self, source)
            return self.activePerHalf > 1
        end,
        condition = {
            duration = 1,
            onStart = function(self, pokemon)
                self:add("-singleturn", pokemon, "move: Rage Powder")
            end,
            onFoeRedirectTargetPriority = 1,
            onFoeRedirectTarget = function(self, target, source, source2, move)
                local ragePowderUser = self.effectState.target
                if ragePowderUser:isSkyDropped() then
                    return
                end
                if source:runStatusImmunity("powder") and self:validTarget(ragePowderUser, source, move.target) then
                    if move.smartTarget then
                        move.smartTarget = false
                    end
                    self:debug("Rage Powder redirected target of move")
                    return ragePowderUser
                end
            end
        },
        secondary = nil,
        target = "self",
        type = "Bug",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Clever"
    },
    raindance = {num = 240, accuracy = true, basePower = 0, category = "Status", name = "Rain Dance", pp = 5, priority = 0, flags = {}, weather = "RainDance", secondary = nil, target = "all", type = "Water", zMove = {boost = {spe = 1}}, contestType = "Beautiful"},
    rapidspin = {
        num = 229,
        accuracy = 100,
        basePower = 50,
        category = "Physical",
        name = "Rapid Spin",
        pp = 40,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onAfterHit = function(self, target, pokemon)
            if pokemon.hp and pokemon:removeVolatile("leechseed") then
                self:add(
                    "-end",
                    pokemon,
                    "Leech Seed",
                    "[from] move: Rapid Spin",
                    "[of] " .. tostring(pokemon)
                )
            end
            local sideConditions = {"spikes", "toxicspikes", "stealthrock", "stickyweb", "gmaxsteelsurge"}
            for ____, condition in ipairs(sideConditions) do
                if pokemon.hp and pokemon.side:removeSideCondition(condition) then
                    self:add(
                        "-sideend",
                        pokemon.side,
                        self.dex.conditions:get(condition).name,
                        "[from] move: Rapid Spin",
                        "[of] " .. tostring(pokemon)
                    )
                end
            end
            if pokemon.hp and pokemon.volatiles.partiallytrapped then
                pokemon:removeVolatile("partiallytrapped")
            end
        end,
        onAfterSubDamage = function(self, damage, target, pokemon)
            if pokemon.hp and pokemon:removeVolatile("leechseed") then
                self:add(
                    "-end",
                    pokemon,
                    "Leech Seed",
                    "[from] move: Rapid Spin",
                    "[of] " .. tostring(pokemon)
                )
            end
            local sideConditions = {"spikes", "toxicspikes", "stealthrock", "stickyweb", "gmaxsteelsurge"}
            for ____, condition in ipairs(sideConditions) do
                if pokemon.hp and pokemon.side:removeSideCondition(condition) then
                    self:add(
                        "-sideend",
                        pokemon.side,
                        self.dex.conditions:get(condition).name,
                        "[from] move: Rapid Spin",
                        "[of] " .. tostring(pokemon)
                    )
                end
            end
            if pokemon.hp and pokemon.volatiles.partiallytrapped then
                pokemon:removeVolatile("partiallytrapped")
            end
        end,
        secondary = {chance = 100, self = {boosts = {spe = 1}}},
        target = "normal",
        type = "Normal",
        contestType = "Cool"
    },
    razorleaf = {num = 75, accuracy = 95, basePower = 55, category = "Physical", name = "Razor Leaf", pp = 25, priority = 0, flags = {protect = 1, mirror = 1}, critRatio = 2, secondary = nil, target = "allAdjacentFoes", type = "Grass", contestType = "Cool"},
    razorshell = {num = 534, accuracy = 95, basePower = 75, category = "Physical", name = "Razor Shell", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 50, boosts = {def = -1}}, target = "normal", type = "Water", contestType = "Cool"},
    razorwind = {
        num = 13,
        accuracy = 100,
        basePower = 80,
        category = "Special",
        isNonstandard = "Past",
        name = "Razor Wind",
        pp = 10,
        priority = 0,
        flags = {charge = 1, protect = 1, mirror = 1},
        onTryMove = function(self, attacker, defender, move)
            if attacker:removeVolatile(move.id) then
                return
            end
            self:add("-prepare", attacker, move.name)
            if not self:runEvent("ChargeMove", attacker, defender, move) then
                return
            end
            attacker:addVolatile("twoturnmove", defender)
            return nil
        end,
        critRatio = 2,
        secondary = nil,
        target = "allAdjacentFoes",
        type = "Normal",
        contestType = "Cool"
    },
    recover = {num = 105, accuracy = true, basePower = 0, category = "Status", name = "Recover", pp = 10, priority = 0, flags = {snatch = 1, heal = 1}, heal = {1, 2}, secondary = nil, target = "self", type = "Normal", zMove = {effect = "clearnegativeboost"}, contestType = "Clever"},
    recycle = {
        num = 278,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Recycle",
        pp = 10,
        priority = 0,
        flags = {snatch = 1},
        onHit = function(self, pokemon)
            if pokemon.item or (not pokemon.lastItem) then
                return false
            end
            local item = pokemon.lastItem
            pokemon.lastItem = ""
            self:add(
                "-item",
                pokemon,
                self.dex.items:get(item),
                "[from] move: Recycle"
            )
            pokemon:setItem(item)
        end,
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {boost = {spe = 2}},
        contestType = "Clever"
    },
    reflect = {
        num = 115,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Reflect",
        pp = 20,
        priority = 0,
        flags = {snatch = 1},
        sideCondition = "reflect",
        condition = {
            duration = 5,
            durationCallback = function(self, target, source, effect)
                if source:hasItem("lightclay") then
                    return 8
                end
                return 5
            end,
            onAnyModifyDamage = function(self, damage, source, target, move)
                if ((target ~= source) and self.effectState.target:hasAlly(target)) and (self:getCategory(move) == "Physical") then
                    if (not target:getMoveHitData(move).crit) and (not move.infiltrates) then
                        self:debug("Reflect weaken")
                        if self.activePerHalf > 1 then
                            return self:chainModify({2732, 4096})
                        end
                        return self:chainModify(0.5)
                    end
                end
            end,
            onSideStart = function(self, side)
                self:add("-sidestart", side, "Reflect")
            end,
            onSideResidualOrder = 26,
            onSideResidualSubOrder = 1,
            onSideEnd = function(self, side)
                self:add("-sideend", side, "Reflect")
            end
        },
        secondary = nil,
        target = "allySide",
        type = "Psychic",
        zMove = {boost = {def = 1}},
        contestType = "Clever"
    },
    reflecttype = {
        num = 513,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Reflect Type",
        pp = 15,
        priority = 0,
        flags = {protect = 1, authentic = 1, mystery = 1},
        onHit = function(self, target, source)
            if source.species and ((source.species.num == 493) or (source.species.num == 773)) then
                return false
            end
            local newBaseTypes = target:getTypes(true):filter(
                function(____, ____type) return ____type ~= "???" end
            )
            if not newBaseTypes.length then
                if target.addedType then
                    newBaseTypes = {"Normal"}
                else
                    return false
                end
            end
            self:add(
                "-start",
                source,
                "typechange",
                "[from] move: Reflect Type",
                "[of] " .. tostring(target)
            )
            source:setType(newBaseTypes)
            source.addedType = target.addedType
            source.knownType = target:isAlly(source) and target.knownType
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {spa = 1}},
        contestType = "Clever"
    },
    refresh = {
        num = 287,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Refresh",
        pp = 20,
        priority = 0,
        flags = {snatch = 1},
        onHit = function(self, pokemon)
            if ({"", "slp", "frz"}):includes(pokemon.status) then
                return false
            end
            pokemon:cureStatus()
        end,
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {effect = "heal"},
        contestType = "Cute"
    },
    relicsong = {
        num = 547,
        accuracy = 100,
        basePower = 75,
        category = "Special",
        isNonstandard = "Past",
        name = "Relic Song",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, sound = 1, authentic = 1},
        secondary = {chance = 10, status = "slp"},
        onHit = function(self, target, pokemon, move)
            if (pokemon.baseSpecies.baseSpecies == "Meloetta") and (not pokemon.transformed) then
                move.willChangeForme = true
            end
        end,
        onAfterMoveSecondarySelf = function(self, pokemon, target, move)
            if move.willChangeForme then
                local meloettaForme = ((pokemon.species.id == "meloettapirouette") and "") or "-Pirouette"
                pokemon:formeChange(
                    "Meloetta" .. tostring(meloettaForme),
                    self.effect,
                    false,
                    "[msg]"
                )
            end
        end,
        target = "allAdjacentFoes",
        type = "Normal",
        contestType = "Beautiful"
    },
    rest = {
        num = 156,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Rest",
        pp = 10,
        priority = 0,
        flags = {snatch = 1, heal = 1},
        onTry = function(self, source)
            if (source.status == "slp") or source:hasAbility("comatose") then
                return false
            end
            if source.hp == source.maxhp then
                self:add("-fail", source, "heal")
                return nil
            end
            if source:hasAbility({"insomnia", "vitalspirit"}) then
                self:add(
                    "-fail",
                    source,
                    "[from] ability: " .. tostring(
                        source:getAbility().name
                    ),
                    "[of] " .. tostring(source)
                )
                return nil
            end
        end,
        onHit = function(self, target, source, move)
            if not target:setStatus("slp", source, move) then
                return false
            end
            target.statusState.time = 3
            target.statusState.startTime = 3
            self:heal(target.maxhp)
        end,
        secondary = nil,
        target = "self",
        type = "Psychic",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Cute"
    },
    retaliate = {
        num = 514,
        accuracy = 100,
        basePower = 70,
        category = "Physical",
        name = "Retaliate",
        pp = 5,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onBasePower = function(self, basePower, pokemon)
            if pokemon.side.faintedLastTurn then
                self:debug("Boosted for a faint last turn")
                return self:chainModify(2)
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Cool"
    },
    ["return"] = {
        num = 216,
        accuracy = 100,
        basePower = 0,
        basePowerCallback = function(self, pokemon)
            return math.floor((pokemon.happiness * 10) / 25) or 1
        end,
        category = "Physical",
        isNonstandard = "Past",
        name = "Return",
        pp = 20,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {basePower = 160},
        maxMove = {basePower = 130},
        contestType = "Cute"
    },
    revelationdance = {
        num = 686,
        accuracy = 100,
        basePower = 90,
        category = "Special",
        isNonstandard = "Past",
        name = "Revelation Dance",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1, dance = 1},
        onModifyType = function(self, move, pokemon)
            local ____type = pokemon:getTypes()[0]
            if ____type == "Bird" then
                ____type = "???"
            end
            move.type = ____type
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Beautiful"
    },
    revenge = {
        num = 279,
        accuracy = 100,
        basePower = 60,
        basePowerCallback = function(self, pokemon, target, move)
            local damagedByTarget = pokemon.attackedBy:some(
                function(____, p) return ((p.source == target) and (p.damage > 0)) and p.thisTurn end
            )
            if damagedByTarget then
                self:debug(
                    "Boosted for getting hit by " .. tostring(target)
                )
                return move.basePower * 2
            end
            return move.basePower
        end,
        category = "Physical",
        name = "Revenge",
        pp = 10,
        priority = -4,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Fighting",
        contestType = "Tough"
    },
    reversal = {
        num = 179,
        accuracy = 100,
        basePower = 0,
        basePowerCallback = function(self, pokemon, target)
            local ratio = (pokemon.hp * 48) / pokemon.maxhp
            if ratio < 2 then
                return 200
            end
            if ratio < 5 then
                return 150
            end
            if ratio < 10 then
                return 100
            end
            if ratio < 17 then
                return 80
            end
            if ratio < 33 then
                return 40
            end
            return 20
        end,
        category = "Physical",
        name = "Reversal",
        pp = 15,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Fighting",
        zMove = {basePower = 160},
        contestType = "Cool"
    },
    risingvoltage = {
        num = 804,
        accuracy = 100,
        basePower = 70,
        category = "Special",
        name = "Rising Voltage",
        pp = 20,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onBasePower = function(self, basePower, pokemon, target)
            if self.field:isTerrain("electricterrain") and target:isGrounded() then
                self:debug("terrain buff")
                return self:chainModify(2)
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Electric",
        maxMove = {basePower = 140}
    },
    roar = {num = 46, accuracy = true, basePower = 0, category = "Status", name = "Roar", pp = 20, priority = -6, flags = {reflectable = 1, mirror = 1, sound = 1, authentic = 1, mystery = 1}, forceSwitch = true, secondary = nil, target = "normal", type = "Normal", zMove = {boost = {def = 1}}, contestType = "Cool"},
    roaroftime = {num = 459, accuracy = 90, basePower = 150, category = "Special", name = "Roar of Time", pp = 5, priority = 0, flags = {recharge = 1, protect = 1, mirror = 1}, self = {volatileStatus = "mustrecharge"}, secondary = nil, target = "normal", type = "Dragon", contestType = "Beautiful"},
    rockblast = {num = 350, accuracy = 90, basePower = 25, category = "Physical", name = "Rock Blast", pp = 10, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, multihit = {2, 5}, secondary = nil, target = "normal", type = "Rock", zMove = {basePower = 140}, maxMove = {basePower = 130}, contestType = "Tough"},
    rockclimb = {num = 431, accuracy = 85, basePower = 90, category = "Physical", isNonstandard = "Past", name = "Rock Climb", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 20, volatileStatus = "confusion"}, target = "normal", type = "Normal", contestType = "Tough"},
    rockpolish = {num = 397, accuracy = true, basePower = 0, category = "Status", name = "Rock Polish", pp = 20, priority = 0, flags = {snatch = 1}, boosts = {spe = 2}, secondary = nil, target = "self", type = "Rock", zMove = {effect = "clearnegativeboost"}, contestType = "Tough"},
    rockslide = {num = 157, accuracy = 90, basePower = 75, category = "Physical", name = "Rock Slide", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 30, volatileStatus = "flinch"}, target = "allAdjacentFoes", type = "Rock", contestType = "Tough"},
    rocksmash = {num = 249, accuracy = 100, basePower = 40, category = "Physical", name = "Rock Smash", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 50, boosts = {def = -1}}, target = "normal", type = "Fighting", contestType = "Tough"},
    rockthrow = {num = 88, accuracy = 90, basePower = 50, category = "Physical", name = "Rock Throw", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Rock", contestType = "Tough"},
    rocktomb = {num = 317, accuracy = 95, basePower = 60, category = "Physical", name = "Rock Tomb", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {spe = -1}}, target = "normal", type = "Rock", contestType = "Clever"},
    rockwrecker = {num = 439, accuracy = 90, basePower = 150, category = "Physical", name = "Rock Wrecker", pp = 5, priority = 0, flags = {bullet = 1, recharge = 1, protect = 1, mirror = 1}, self = {volatileStatus = "mustrecharge"}, secondary = nil, target = "normal", type = "Rock", contestType = "Tough"},
    roleplay = {
        num = 272,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Role Play",
        pp = 10,
        priority = 0,
        flags = {authentic = 1, mystery = 1},
        onTryHit = function(self, target, source)
            if target.ability == source.ability then
                return false
            end
            local additionalBannedTargetAbilities = {"flowergift", "forecast", "hungerswitch", "illusion", "imposter", "neutralizinggas", "powerofalchemy", "receiver", "trace", "wonderguard", "zenmode"}
            if (target:getAbility().isPermanent or additionalBannedTargetAbilities:includes(target.ability)) or source:getAbility().isPermanent then
                return false
            end
        end,
        onHit = function(self, target, source)
            local oldAbility = source:setAbility(target.ability)
            if oldAbility then
                self:add(
                    "-ability",
                    source,
                    source:getAbility().name,
                    "[from] move: Role Play",
                    "[of] " .. tostring(target)
                )
                return
            end
            return false
        end,
        secondary = nil,
        target = "normal",
        type = "Psychic",
        zMove = {boost = {spe = 1}},
        contestType = "Cute"
    },
    rollingkick = {num = 27, accuracy = 85, basePower = 60, category = "Physical", isNonstandard = "Past", name = "Rolling Kick", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 30, volatileStatus = "flinch"}, target = "normal", type = "Fighting", contestType = "Cool"},
    rollout = {
        num = 205,
        accuracy = 90,
        basePower = 30,
        basePowerCallback = function(self, pokemon, target, move)
            local bp = move.basePower
            if pokemon.volatiles.rollout and pokemon.volatiles.rollout.hitCount then
                bp = bp * math.pow(2, pokemon.volatiles.rollout.hitCount)
            end
            if pokemon.status ~= "slp" then
                pokemon:addVolatile("rollout")
            end
            if pokemon.volatiles.defensecurl then
                bp = bp * 2
            end
            self:debug(
                "Rollout bp: " .. tostring(bp)
            )
            return bp
        end,
        category = "Physical",
        name = "Rollout",
        pp = 20,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        condition = {
            duration = 2,
            onLockMove = "rollout",
            onStart = function(self)
                self.effectState.hitCount = 1
            end,
            onRestart = function(self)
                local ____obj, ____index = self.effectState, "hitCount"
                ____obj[____index] = ____obj[____index] + 1
                if self.effectState.hitCount < 5 then
                    self.effectState.duration = 2
                end
            end,
            onResidual = function(self, target)
                if target.lastMove and (target.lastMove.id == "struggle") then
                    __TS__Delete(target.volatiles, "rollout")
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Rock",
        contestType = "Cute"
    },
    roost = {
        num = 355,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Roost",
        pp = 10,
        priority = 0,
        flags = {snatch = 1, heal = 1},
        heal = {1, 2},
        self = {volatileStatus = "roost"},
        condition = {
            duration = 1,
            onResidualOrder = 25,
            onStart = function(self, target)
                self:add("-singleturn", target, "move: Roost")
            end,
            onTypePriority = -1,
            onType = function(self, types, pokemon)
                self.effectState.typeWas = types
                return types:filter(
                    function(____, ____type) return ____type ~= "Flying" end
                )
            end
        },
        secondary = nil,
        target = "self",
        type = "Flying",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Clever"
    },
    rototiller = {
        num = 563,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Rototiller",
        pp = 10,
        priority = 0,
        flags = {distance = 1, nonsky = 1},
        onHitField = function(self, target, source)
            local targets = {}
            local anyAirborne = false
            for ____, pokemon in __TS__Iterator(
                self:getAllActive()
            ) do
                do
                    if not pokemon:runImmunity("Ground") then
                        self:add("-immune", pokemon)
                        anyAirborne = true
                        goto __continue1263
                    end
                    if pokemon:hasType("Grass") then
                        __TS__ArrayPush(targets, pokemon)
                    end
                end
                ::__continue1263::
            end
            if (not #targets) and (not anyAirborne) then
                return false
            end
            for ____, pokemon in ipairs(targets) do
                self:boost({atk = 1, spa = 1}, pokemon, source)
            end
        end,
        secondary = nil,
        target = "all",
        type = "Ground",
        zMove = {boost = {atk = 1}},
        contestType = "Tough"
    },
    round = {
        num = 496,
        accuracy = 100,
        basePower = 60,
        basePowerCallback = function(self, target, source, move)
            if move.sourceEffect == "round" then
                return move.basePower * 2
            end
            return move.basePower
        end,
        category = "Special",
        name = "Round",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1, sound = 1, authentic = 1},
        onTry = function(self, source, target, move)
            for ____, action in ipairs(self.queue.list) do
                do
                    if (((not action.pokemon) or (not action.move)) or action.maxMove) or action.zmove then
                        goto __continue1271
                    end
                    if action.move.id == "round" then
                        self.queue:prioritizeAction(action, move)
                        return
                    end
                end
                ::__continue1271::
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Beautiful"
    },
    sacredfire = {num = 221, accuracy = 95, basePower = 100, category = "Physical", name = "Sacred Fire", pp = 5, priority = 0, flags = {protect = 1, mirror = 1, defrost = 1}, secondary = {chance = 50, status = "brn"}, target = "normal", type = "Fire", contestType = "Beautiful"},
    sacredsword = {num = 533, accuracy = 100, basePower = 90, category = "Physical", name = "Sacred Sword", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, ignoreEvasion = true, ignoreDefensive = true, secondary = nil, target = "normal", type = "Fighting", contestType = "Cool"},
    safeguard = {
        num = 219,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Safeguard",
        pp = 25,
        priority = 0,
        flags = {snatch = 1},
        sideCondition = "safeguard",
        condition = {
            duration = 5,
            durationCallback = function(self, target, source, effect)
                if source:hasAbility("persistent") then
                    self:add("-activate", source, "ability: Persistent", effect)
                    return 7
                end
                return 5
            end,
            onSetStatus = function(self, status, target, source, effect)
                if (not effect) or (not source) then
                    return
                end
                if effect.id == "yawn" then
                    return
                end
                if ((effect.effectType == "Move") and effect.infiltrates) and (not target:isAlly(source)) then
                    return
                end
                if target ~= source then
                    self:debug("interrupting setStatus")
                    if (effect.id == "synchronize") or ((effect.effectType == "Move") and (not effect.secondaries)) then
                        self:add("-activate", target, "move: Safeguard")
                    end
                    return nil
                end
            end,
            onTryAddVolatile = function(self, status, target, source, effect)
                if (not effect) or (not source) then
                    return
                end
                if ((effect.effectType == "Move") and effect.infiltrates) and (not target:isAlly(source)) then
                    return
                end
                if ((status.id == "confusion") or (status.id == "yawn")) and (target ~= source) then
                    if (effect.effectType == "Move") and (not effect.secondaries) then
                        self:add("-activate", target, "move: Safeguard")
                    end
                    return nil
                end
            end,
            onSideStart = function(self, side)
                self:add("-sidestart", side, "Safeguard")
            end,
            onSideResidualOrder = 26,
            onSideResidualSubOrder = 3,
            onSideEnd = function(self, side)
                self:add("-sideend", side, "Safeguard")
            end
        },
        secondary = nil,
        target = "allySide",
        type = "Normal",
        zMove = {boost = {spe = 1}},
        contestType = "Beautiful"
    },
    sandattack = {num = 28, accuracy = 100, basePower = 0, category = "Status", name = "Sand Attack", pp = 15, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, boosts = {accuracy = -1}, secondary = nil, target = "normal", type = "Ground", zMove = {boost = {evasion = 1}}, contestType = "Cute"},
    sandstorm = {num = 201, accuracy = true, basePower = 0, category = "Status", name = "Sandstorm", pp = 10, priority = 0, flags = {}, weather = "Sandstorm", secondary = nil, target = "all", type = "Rock", zMove = {boost = {spe = 1}}, contestType = "Tough"},
    sandtomb = {num = 328, accuracy = 85, basePower = 35, category = "Physical", name = "Sand Tomb", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, volatileStatus = "partiallytrapped", secondary = nil, target = "normal", type = "Ground", contestType = "Clever"},
    sappyseed = {
        num = 738,
        accuracy = 90,
        basePower = 100,
        category = "Physical",
        isNonstandard = "LGPE",
        name = "Sappy Seed",
        pp = 10,
        priority = 0,
        flags = {protect = 1, reflectable = 1},
        onHit = function(self, target, source)
            if target:hasType("Grass") then
                return nil
            end
            target:addVolatile("leechseed", source)
        end,
        secondary = nil,
        target = "normal",
        type = "Grass",
        contestType = "Clever"
    },
    savagespinout = {num = 634, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Savage Spin-Out", pp = 1, priority = 0, flags = {}, isZ = "buginiumz", secondary = nil, target = "normal", type = "Bug", contestType = "Cool"},
    scald = {num = 503, accuracy = 100, basePower = 80, category = "Special", name = "Scald", pp = 15, priority = 0, flags = {protect = 1, mirror = 1, defrost = 1}, thawsTarget = true, secondary = {chance = 30, status = "brn"}, target = "normal", type = "Water", contestType = "Tough"},
    scaleshot = {num = 799, accuracy = 90, basePower = 25, category = "Physical", name = "Scale Shot", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, multihit = {2, 5}, selfBoost = {boosts = {def = -1, spe = 1}}, secondary = nil, target = "normal", type = "Dragon", zMove = {basePower = 140}, maxMove = {basePower = 130}},
    scaryface = {num = 184, accuracy = 100, basePower = 0, category = "Status", name = "Scary Face", pp = 10, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1}, boosts = {spe = -2}, secondary = nil, target = "normal", type = "Normal", zMove = {boost = {spe = 1}}, contestType = "Tough"},
    scorchingsands = {num = 815, accuracy = 100, basePower = 70, category = "Special", name = "Scorching Sands", pp = 10, priority = 0, flags = {protect = 1, mirror = 1, defrost = 1}, thawsTarget = true, secondary = {chance = 30, status = "brn"}, target = "normal", type = "Ground"},
    scratch = {num = 10, accuracy = 100, basePower = 40, category = "Physical", name = "Scratch", pp = 35, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Normal", contestType = "Tough"},
    screech = {num = 103, accuracy = 85, basePower = 0, category = "Status", name = "Screech", pp = 40, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1, sound = 1, authentic = 1, mystery = 1}, boosts = {def = -2}, secondary = nil, target = "normal", type = "Normal", zMove = {boost = {atk = 1}}, contestType = "Clever"},
    searingshot = {num = 545, accuracy = 100, basePower = 100, category = "Special", name = "Searing Shot", pp = 5, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, secondary = {chance = 30, status = "brn"}, target = "allAdjacent", type = "Fire", contestType = "Cool"},
    searingsunrazesmash = {num = 724, accuracy = true, basePower = 200, category = "Physical", isNonstandard = "Past", name = "Searing Sunraze Smash", pp = 1, priority = 0, flags = {contact = 1}, isZ = "solganiumz", ignoreAbility = true, secondary = nil, target = "normal", type = "Steel", contestType = "Cool"},
    secretpower = {
        num = 290,
        accuracy = 100,
        basePower = 70,
        category = "Physical",
        isNonstandard = "Past",
        name = "Secret Power",
        pp = 20,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onModifyMove = function(self, move, pokemon)
            if self.field:isTerrain("") then
                return
            end
            move.secondaries = {}
            if self.field:isTerrain("electricterrain") then
                move.secondaries:push({chance = 30, status = "par"})
            elseif self.field:isTerrain("grassyterrain") then
                move.secondaries:push({chance = 30, status = "slp"})
            elseif self.field:isTerrain("mistyterrain") then
                move.secondaries:push({chance = 30, boosts = {spa = -1}})
            elseif self.field:isTerrain("psychicterrain") then
                move.secondaries:push({chance = 30, boosts = {spe = -1}})
            end
        end,
        secondary = {chance = 30, status = "par"},
        target = "normal",
        type = "Normal",
        contestType = "Clever"
    },
    secretsword = {num = 548, accuracy = 100, basePower = 85, category = "Special", defensiveCategory = "Physical", name = "Secret Sword", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Fighting", contestType = "Beautiful"},
    seedbomb = {num = 402, accuracy = 100, basePower = 80, category = "Physical", name = "Seed Bomb", pp = 15, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Grass", contestType = "Tough"},
    seedflare = {num = 465, accuracy = 85, basePower = 120, category = "Special", isNonstandard = "Past", name = "Seed Flare", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 40, boosts = {spd = -2}}, target = "normal", type = "Grass", contestType = "Beautiful"},
    seismictoss = {num = 69, accuracy = 100, basePower = 0, damage = "level", category = "Physical", name = "Seismic Toss", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, nonsky = 1}, secondary = nil, target = "normal", type = "Fighting", maxMove = {basePower = 75}, contestType = "Tough"},
    selfdestruct = {num = 120, accuracy = 100, basePower = 200, category = "Physical", name = "Self-Destruct", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, selfdestruct = "always", secondary = nil, target = "allAdjacent", type = "Normal", contestType = "Beautiful"},
    shadowball = {num = 247, accuracy = 100, basePower = 80, category = "Special", name = "Shadow Ball", pp = 15, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, secondary = {chance = 20, boosts = {spd = -1}}, target = "normal", type = "Ghost", contestType = "Clever"},
    shadowbone = {num = 708, accuracy = 100, basePower = 85, category = "Physical", name = "Shadow Bone", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 20, boosts = {def = -1}}, target = "normal", type = "Ghost", contestType = "Cool"},
    shadowclaw = {num = 421, accuracy = 100, basePower = 70, category = "Physical", name = "Shadow Claw", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, critRatio = 2, secondary = nil, target = "normal", type = "Ghost", contestType = "Cool"},
    shadowforce = {
        num = 467,
        accuracy = 100,
        basePower = 120,
        category = "Physical",
        name = "Shadow Force",
        pp = 5,
        priority = 0,
        flags = {contact = 1, charge = 1, mirror = 1},
        breaksProtect = true,
        onTryMove = function(self, attacker, defender, move)
            if attacker:removeVolatile(move.id) then
                return
            end
            self:add("-prepare", attacker, move.name)
            if not self:runEvent("ChargeMove", attacker, defender, move) then
                return
            end
            attacker:addVolatile("twoturnmove", defender)
            return nil
        end,
        condition = {duration = 2, onInvulnerability = false},
        secondary = nil,
        target = "normal",
        type = "Ghost",
        contestType = "Cool"
    },
    shadowpunch = {num = 325, accuracy = true, basePower = 60, category = "Physical", name = "Shadow Punch", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, secondary = nil, target = "normal", type = "Ghost", contestType = "Clever"},
    shadowsneak = {num = 425, accuracy = 100, basePower = 40, category = "Physical", name = "Shadow Sneak", pp = 30, priority = 1, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Ghost", contestType = "Clever"},
    shadowstrike = {num = 0, accuracy = 95, basePower = 80, category = "Physical", isNonstandard = "CAP", name = "Shadow Strike", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 50, boosts = {def = -1}}, target = "normal", type = "Ghost", contestType = "Clever"},
    sharpen = {num = 159, accuracy = true, basePower = 0, category = "Status", isNonstandard = "Past", name = "Sharpen", pp = 30, priority = 0, flags = {snatch = 1}, boosts = {atk = 1}, secondary = nil, target = "self", type = "Normal", zMove = {boost = {atk = 1}}, contestType = "Cute"},
    shatteredpsyche = {num = 648, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Shattered Psyche", pp = 1, priority = 0, flags = {}, isZ = "psychiumz", secondary = nil, target = "normal", type = "Psychic", contestType = "Cool"},
    sheercold = {num = 329, accuracy = 30, basePower = 0, category = "Special", name = "Sheer Cold", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, ohko = "Ice", target = "normal", type = "Ice", zMove = {basePower = 180}, maxMove = {basePower = 130}, contestType = "Beautiful"},
    shellsidearm = {
        num = 801,
        accuracy = 100,
        basePower = 90,
        category = "Special",
        name = "Shell Side Arm",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onPrepareHit = function(self, target, source, move)
            if not source:isAlly(target) then
                self:attrLastMove(
                    "[anim] Shell Side Arm " .. tostring(move.category)
                )
            end
        end,
        onModifyMove = function(self, move, pokemon, target)
            if not target then
                return
            end
            local atk = pokemon:getStat("atk", false, true)
            local spa = pokemon:getStat("spa", false, true)
            local def = target:getStat("def", false, true)
            local spd = target:getStat("spd", false, true)
            local physical = math.floor(
                math.floor(
                    math.floor(
                        (math.floor(((2 * pokemon.level) / 5) + 2) * 90) * atk
                    ) / def
                ) / 50
            )
            local special = math.floor(
                math.floor(
                    math.floor(
                        (math.floor(((2 * pokemon.level) / 5) + 2) * 90) * spa
                    ) / spd
                ) / 50
            )
            if (physical > special) or ((physical == special) and (self:random(2) == 0)) then
                move.category = "Physical"
                move.flags.contact = 1
            end
        end,
        onHit = function(self, target, source, move)
            if not source:isAlly(target) then
                self:hint(
                    tostring(move.category) .. " Shell Side Arm"
                )
            end
        end,
        onAfterSubDamage = function(self, damage, target, source, move)
            if not source:isAlly(target) then
                self:hint(
                    tostring(move.category) .. " Shell Side Arm"
                )
            end
        end,
        secondary = {chance = 20, status = "psn"},
        target = "normal",
        type = "Poison"
    },
    shellsmash = {num = 504, accuracy = true, basePower = 0, category = "Status", name = "Shell Smash", pp = 15, priority = 0, flags = {snatch = 1}, boosts = {def = -1, spd = -1, atk = 2, spa = 2, spe = 2}, secondary = nil, target = "self", type = "Normal", zMove = {effect = "clearnegativeboost"}, contestType = "Tough"},
    shelltrap = {
        num = 704,
        accuracy = 100,
        basePower = 150,
        category = "Special",
        name = "Shell Trap",
        pp = 5,
        priority = -3,
        flags = {protect = 1},
        beforeTurnCallback = function(self, pokemon)
            pokemon:addVolatile("shelltrap")
        end,
        onTryMove = function(self, pokemon)
            if not pokemon.volatiles.shelltrap.gotHit then
                self:attrLastMove("[still]")
                self:add("cant", pokemon, "Shell Trap", "Shell Trap")
                return nil
            end
        end,
        condition = {
            duration = 1,
            onStart = function(self, pokemon)
                self:add("-singleturn", pokemon, "move: Shell Trap")
            end,
            onHit = function(self, pokemon, source, move)
                if (not pokemon:isAlly(source)) and (move.category == "Physical") then
                    pokemon.volatiles.shelltrap.gotHit = true
                    local action = self.queue:willMove(pokemon)
                    if action then
                        self.queue:prioritizeAction(action)
                    end
                end
            end
        },
        secondary = nil,
        target = "allAdjacentFoes",
        type = "Fire",
        contestType = "Tough"
    },
    shiftgear = {num = 508, accuracy = true, basePower = 0, category = "Status", name = "Shift Gear", pp = 10, priority = 0, flags = {snatch = 1}, boosts = {spe = 2, atk = 1}, secondary = nil, target = "self", type = "Steel", zMove = {effect = "clearnegativeboost"}, contestType = "Clever"},
    shockwave = {num = 351, accuracy = true, basePower = 60, category = "Special", name = "Shock Wave", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Electric", contestType = "Cool"},
    shoreup = {
        num = 659,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Shore Up",
        pp = 10,
        priority = 0,
        flags = {snatch = 1, heal = 1},
        onHit = function(self, pokemon)
            local factor = 0.5
            if self.field:isWeather("sandstorm") then
                factor = 0.667
            end
            return not (not self:heal(
                self:modify(pokemon.maxhp, factor)
            ))
        end,
        secondary = nil,
        target = "self",
        type = "Ground",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Beautiful"
    },
    signalbeam = {num = 324, accuracy = 100, basePower = 75, category = "Special", isNonstandard = "Past", name = "Signal Beam", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, volatileStatus = "confusion"}, target = "normal", type = "Bug", contestType = "Beautiful"},
    silverwind = {num = 318, accuracy = 100, basePower = 60, category = "Special", isNonstandard = "Past", name = "Silver Wind", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, self = {boosts = {atk = 1, def = 1, spa = 1, spd = 1, spe = 1}}}, target = "normal", type = "Bug", contestType = "Beautiful"},
    simplebeam = {
        num = 493,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Simple Beam",
        pp = 15,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1},
        onTryHit = function(self, target)
            if (target:getAbility().isPermanent or (target.ability == "simple")) or (target.ability == "truant") then
                return false
            end
        end,
        onHit = function(self, pokemon)
            local oldAbility = pokemon:setAbility("simple")
            if oldAbility then
                self:add("-ability", pokemon, "Simple", "[from] move: Simple Beam")
                return
            end
            return false
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {spa = 1}},
        contestType = "Cute"
    },
    sing = {num = 47, accuracy = 55, basePower = 0, category = "Status", name = "Sing", pp = 15, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1, sound = 1, authentic = 1}, status = "slp", secondary = nil, target = "normal", type = "Normal", zMove = {boost = {spe = 1}}, contestType = "Cute"},
    sinisterarrowraid = {num = 695, accuracy = true, basePower = 180, category = "Physical", isNonstandard = "Past", name = "Sinister Arrow Raid", pp = 1, priority = 0, flags = {}, isZ = "decidiumz", secondary = nil, target = "normal", type = "Ghost", contestType = "Cool"},
    sizzlyslide = {num = 735, accuracy = 100, basePower = 60, category = "Physical", isNonstandard = "LGPE", name = "Sizzly Slide", pp = 20, priority = 0, flags = {contact = 1, protect = 1, defrost = 1}, secondary = {chance = 100, status = "brn"}, target = "normal", type = "Fire", contestType = "Clever"},
    sketch = {
        num = 166,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Sketch",
        pp = 1,
        noPPBoosts = true,
        priority = 0,
        flags = {authentic = 1, mystery = 1},
        onHit = function(self, target, source)
            local disallowedMoves = {"chatter", "sketch", "struggle"}
            local move = target.lastMove
            if (source.transformed or (not move)) or source.moves:includes(move.id) then
                return false
            end
            if (disallowedMoves:includes(move.id) or move.isZ) or move.isMax then
                return false
            end
            local sketchIndex = source.moves:indexOf("sketch")
            if sketchIndex < 0 then
                return false
            end
            local sketchedMove = {move = move.name, id = move.id, pp = move.pp, maxpp = move.pp, target = move.target, disabled = false, used = false}
            source.moveSlots[sketchIndex] = sketchedMove
            source.baseMoveSlots[sketchIndex] = sketchedMove
            self:add("-activate", source, "move: Sketch", move.name)
        end,
        noSketch = true,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {atk = 1, def = 1, spa = 1, spd = 1, spe = 1}},
        contestType = "Clever"
    },
    skillswap = {
        num = 285,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Skill Swap",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, authentic = 1, mystery = 1},
        onTryHit = function(self, target, source)
            local additionalBannedAbilities = {"hungerswitch", "illusion", "neutralizinggas", "wonderguard"}
            if (((target.volatiles.dynamax or target:getAbility().isPermanent) or source:getAbility().isPermanent) or additionalBannedAbilities:includes(target.ability)) or additionalBannedAbilities:includes(source.ability) then
                return false
            end
        end,
        onHit = function(self, target, source, move)
            local targetAbility = target:getAbility()
            local sourceAbility = source:getAbility()
            if target:isAlly(source) then
                self:add(
                    "-activate",
                    source,
                    "move: Skill Swap",
                    "",
                    "",
                    "[of] " .. tostring(target)
                )
            else
                self:add(
                    "-activate",
                    source,
                    "move: Skill Swap",
                    targetAbility,
                    sourceAbility,
                    "[of] " .. tostring(target)
                )
            end
            self:singleEvent("End", sourceAbility, source.abilityState, source)
            self:singleEvent("End", targetAbility, target.abilityState, target)
            source.ability = targetAbility.id
            target.ability = sourceAbility.id
            source.abilityState = {
                id = self:toID(source.ability),
                target = source
            }
            target.abilityState = {
                id = self:toID(target.ability),
                target = target
            }
            if not target:isAlly(source) then
                target.volatileStaleness = "external"
            end
            self:singleEvent("Start", targetAbility, source.abilityState, source)
            self:singleEvent("Start", sourceAbility, target.abilityState, target)
        end,
        secondary = nil,
        target = "normal",
        type = "Psychic",
        zMove = {boost = {spe = 1}},
        contestType = "Clever"
    },
    skittersmack = {num = 806, accuracy = 90, basePower = 70, category = "Physical", name = "Skitter Smack", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {spa = -1}}, target = "normal", type = "Bug"},
    skullbash = {
        num = 130,
        accuracy = 100,
        basePower = 130,
        category = "Physical",
        name = "Skull Bash",
        pp = 10,
        priority = 0,
        flags = {contact = 1, charge = 1, protect = 1, mirror = 1},
        onTryMove = function(self, attacker, defender, move)
            if attacker:removeVolatile(move.id) then
                return
            end
            self:add("-prepare", attacker, move.name)
            self:boost({def = 1}, attacker, attacker, move)
            if not self:runEvent("ChargeMove", attacker, defender, move) then
                return
            end
            attacker:addVolatile("twoturnmove", defender)
            return nil
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Tough"
    },
    skyattack = {
        num = 143,
        accuracy = 90,
        basePower = 140,
        category = "Physical",
        name = "Sky Attack",
        pp = 5,
        priority = 0,
        flags = {charge = 1, protect = 1, mirror = 1, distance = 1},
        critRatio = 2,
        onTryMove = function(self, attacker, defender, move)
            if attacker:removeVolatile(move.id) then
                return
            end
            self:add("-prepare", attacker, move.name)
            if not self:runEvent("ChargeMove", attacker, defender, move) then
                return
            end
            attacker:addVolatile("twoturnmove", defender)
            return nil
        end,
        secondary = {chance = 30, volatileStatus = "flinch"},
        target = "any",
        type = "Flying",
        contestType = "Cool"
    },
    skydrop = {
        num = 507,
        accuracy = 100,
        basePower = 60,
        category = "Physical",
        isNonstandard = "Past",
        name = "Sky Drop",
        pp = 10,
        priority = 0,
        flags = {contact = 1, charge = 1, protect = 1, mirror = 1, gravity = 1, distance = 1},
        onModifyMove = function(self, move, source)
            if not source.volatiles.skydrop then
                move.accuracy = true
                move.flags.contact = 0
            end
        end,
        onMoveFail = function(self, target, source)
            if source.volatiles.twoturnmove and (source.volatiles.twoturnmove.duration == 1) then
                source:removeVolatile("skydrop")
                source:removeVolatile("twoturnmove")
                if target == self.effectState.target then
                    self:add("-end", target, "Sky Drop", "[interrupt]")
                end
            end
        end,
        onTry = function(self, source, target)
            return not target.fainted
        end,
        onTryHit = function(self, target, source, move)
            if source:removeVolatile(move.id) then
                if target ~= source.volatiles.twoturnmove.source then
                    return false
                end
                if target:hasType("Flying") then
                    self:add("-immune", target)
                    return nil
                end
            else
                if target.volatiles.substitute or target:isAlly(source) then
                    return false
                end
                if target:getWeight() >= 2000 then
                    self:add("-fail", target, "move: Sky Drop", "[heavy]")
                    return nil
                end
                self:add("-prepare", source, move.name, target)
                source:addVolatile("twoturnmove", target)
                return nil
            end
        end,
        onHit = function(self, target, source)
            if target.hp then
                self:add("-end", target, "Sky Drop")
            end
        end,
        condition = {
            duration = 2,
            onAnyDragOut = function(self, pokemon)
                if (pokemon == self.effectState.target) or (pokemon == self.effectState.source) then
                    return false
                end
            end,
            onFoeTrapPokemonPriority = -15,
            onFoeTrapPokemon = function(self, defender)
                if defender ~= self.effectState.source then
                    return
                end
                defender.trapped = true
            end,
            onFoeBeforeMovePriority = 12,
            onFoeBeforeMove = function(self, attacker, defender, move)
                if attacker == self.effectState.source then
                    attacker.activeMoveActions = attacker.activeMoveActions - 1
                    self:debug("Sky drop nullifying.")
                    return nil
                end
            end,
            onRedirectTargetPriority = 99,
            onRedirectTarget = function(self, target, source, source2)
                if source ~= self.effectState.target then
                    return
                end
                if self.effectState.source.fainted then
                    return
                end
                return self.effectState.source
            end,
            onAnyInvulnerability = function(self, target, source, move)
                if (target ~= self.effectState.target) and (target ~= self.effectState.source) then
                    return
                end
                if (source == self.effectState.target) and (target == self.effectState.source) then
                    return
                end
                if ({"gust", "twister", "skyuppercut", "thunder", "hurricane", "smackdown", "thousandarrows"}):includes(move.id) then
                    return
                end
                return false
            end,
            onAnyBasePower = function(self, basePower, target, source, move)
                if (target ~= self.effectState.target) and (target ~= self.effectState.source) then
                    return
                end
                if (source == self.effectState.target) and (target == self.effectState.source) then
                    return
                end
                if (move.id == "gust") or (move.id == "twister") then
                    return self:chainModify(2)
                end
            end,
            onFaint = function(self, target)
                if target.volatiles.skydrop and target.volatiles.twoturnmove.source then
                    self:add("-end", target.volatiles.twoturnmove.source, "Sky Drop", "[interrupt]")
                end
            end
        },
        secondary = nil,
        target = "any",
        type = "Flying",
        contestType = "Tough"
    },
    skyuppercut = {num = 327, accuracy = 90, basePower = 85, category = "Physical", isNonstandard = "Past", name = "Sky Uppercut", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, secondary = nil, target = "normal", type = "Fighting", contestType = "Cool"},
    slackoff = {num = 303, accuracy = true, basePower = 0, category = "Status", name = "Slack Off", pp = 10, priority = 0, flags = {snatch = 1, heal = 1}, heal = {1, 2}, secondary = nil, target = "self", type = "Normal", zMove = {effect = "clearnegativeboost"}, contestType = "Cute"},
    slam = {num = 21, accuracy = 75, basePower = 80, category = "Physical", name = "Slam", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, nonsky = 1}, secondary = nil, target = "normal", type = "Normal", contestType = "Tough"},
    slash = {num = 163, accuracy = 100, basePower = 70, category = "Physical", name = "Slash", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, critRatio = 2, secondary = nil, target = "normal", type = "Normal", contestType = "Cool"},
    sleeppowder = {num = 79, accuracy = 75, basePower = 0, category = "Status", name = "Sleep Powder", pp = 15, priority = 0, flags = {powder = 1, protect = 1, reflectable = 1, mirror = 1}, status = "slp", secondary = nil, target = "normal", type = "Grass", zMove = {boost = {spe = 1}}, contestType = "Clever"},
    sleeptalk = {
        num = 214,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Sleep Talk",
        pp = 10,
        priority = 0,
        flags = {},
        sleepUsable = true,
        onTry = function(self, source)
            return (source.status == "slp") or source:hasAbility("comatose")
        end,
        onHit = function(self, pokemon)
            local noSleepTalk = {"assist", "beakblast", "belch", "bide", "celebrate", "chatter", "copycat", "dynamaxcannon", "focuspunch", "mefirst", "metronome", "mimic", "mirrormove", "naturepower", "shelltrap", "sketch", "sleeptalk", "uproar"}
            local moves = {}
            for ____, moveSlot in __TS__Iterator(pokemon.moveSlots) do
                do
                    local moveid = moveSlot.id
                    if not moveid then
                        goto __continue1374
                    end
                    local move = self.dex.moves:get(moveid)
                    if (noSleepTalk:includes(moveid) or move.flags.charge) or (move.isZ and (move.basePower ~= 1)) then
                        goto __continue1374
                    end
                    __TS__ArrayPush(moves, moveid)
                end
                ::__continue1374::
            end
            local randomMove = ""
            if #moves then
                randomMove = self:sample(moves)
            end
            if not randomMove then
                return false
            end
            self.actions:useMove(randomMove, pokemon)
        end,
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {effect = "crit2"},
        contestType = "Cute"
    },
    sludge = {num = 124, accuracy = 100, basePower = 65, category = "Special", name = "Sludge", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 30, status = "psn"}, target = "normal", type = "Poison", contestType = "Tough"},
    sludgebomb = {num = 188, accuracy = 100, basePower = 90, category = "Special", name = "Sludge Bomb", pp = 10, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, secondary = {chance = 30, status = "psn"}, target = "normal", type = "Poison", contestType = "Tough"},
    sludgewave = {num = 482, accuracy = 100, basePower = 95, category = "Special", name = "Sludge Wave", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, status = "psn"}, target = "allAdjacent", type = "Poison", contestType = "Tough"},
    smackdown = {
        num = 479,
        accuracy = 100,
        basePower = 50,
        category = "Physical",
        name = "Smack Down",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1, nonsky = 1},
        volatileStatus = "smackdown",
        condition = {
            noCopy = true,
            onStart = function(self, pokemon)
                local applies = false
                if pokemon:hasType("Flying") or pokemon:hasAbility("levitate") then
                    applies = true
                end
                if (pokemon:hasItem("ironball") or pokemon.volatiles.ingrain) or self.field:getPseudoWeather("gravity") then
                    applies = false
                end
                if pokemon:removeVolatile("fly") or pokemon:removeVolatile("bounce") then
                    applies = true
                    self.queue:cancelMove(pokemon)
                    pokemon:removeVolatile("twoturnmove")
                end
                if pokemon.volatiles.magnetrise then
                    applies = true
                    __TS__Delete(pokemon.volatiles, "magnetrise")
                end
                if pokemon.volatiles.telekinesis then
                    applies = true
                    __TS__Delete(pokemon.volatiles, "telekinesis")
                end
                if not applies then
                    return false
                end
                self:add("-start", pokemon, "Smack Down")
            end,
            onRestart = function(self, pokemon)
                if pokemon:removeVolatile("fly") or pokemon:removeVolatile("bounce") then
                    self.queue:cancelMove(pokemon)
                    self:add("-start", pokemon, "Smack Down")
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Rock",
        contestType = "Tough"
    },
    smartstrike = {num = 684, accuracy = true, basePower = 70, category = "Physical", name = "Smart Strike", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Steel", contestType = "Cool"},
    smellingsalts = {
        num = 265,
        accuracy = 100,
        basePower = 70,
        basePowerCallback = function(self, pokemon, target, move)
            if target.status == "par" then
                return move.basePower * 2
            end
            return move.basePower
        end,
        category = "Physical",
        isNonstandard = "Past",
        name = "Smelling Salts",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onHit = function(self, target)
            if target.status == "par" then
                target:cureStatus()
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Tough"
    },
    smog = {num = 123, accuracy = 70, basePower = 30, category = "Special", name = "Smog", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 40, status = "psn"}, target = "normal", type = "Poison", contestType = "Tough"},
    smokescreen = {num = 108, accuracy = 100, basePower = 0, category = "Status", name = "Smokescreen", pp = 20, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, boosts = {accuracy = -1}, secondary = nil, target = "normal", type = "Normal", zMove = {boost = {evasion = 1}}, contestType = "Clever"},
    snaptrap = {num = 779, accuracy = 100, basePower = 35, category = "Physical", name = "Snap Trap", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, volatileStatus = "partiallytrapped", secondary = nil, target = "normal", type = "Grass"},
    snarl = {num = 555, accuracy = 95, basePower = 55, category = "Special", name = "Snarl", pp = 15, priority = 0, flags = {protect = 1, mirror = 1, sound = 1, authentic = 1}, secondary = {chance = 100, boosts = {spa = -1}}, target = "allAdjacentFoes", type = "Dark", contestType = "Tough"},
    snatch = {
        num = 289,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Snatch",
        pp = 10,
        priority = 4,
        flags = {authentic = 1},
        volatileStatus = "snatch",
        condition = {
            duration = 1,
            onStart = function(self, pokemon)
                self:add("-singleturn", pokemon, "Snatch")
            end,
            onAnyPrepareHitPriority = -1,
            onAnyPrepareHit = function(self, source, target, move)
                local snatchUser = self.effectState.source
                if snatchUser:isSkyDropped() then
                    return
                end
                if ((((not move) or move.isZ) or move.isMax) or (not move.flags.snatch)) or (move.sourceEffect == "snatch") then
                    return
                end
                snatchUser:removeVolatile("snatch")
                self:add(
                    "-activate",
                    snatchUser,
                    "move: Snatch",
                    "[of] " .. tostring(source)
                )
                self.actions:useMove(move.id, snatchUser)
                return nil
            end
        },
        secondary = nil,
        pressureTarget = "foeSide",
        target = "self",
        type = "Dark",
        zMove = {boost = {spe = 2}},
        contestType = "Clever"
    },
    snipeshot = {num = 745, accuracy = 100, basePower = 80, category = "Special", name = "Snipe Shot", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, critRatio = 2, tracksTarget = true, secondary = nil, target = "normal", type = "Water"},
    snore = {
        num = 173,
        accuracy = 100,
        basePower = 50,
        category = "Special",
        name = "Snore",
        pp = 15,
        priority = 0,
        flags = {protect = 1, mirror = 1, sound = 1, authentic = 1},
        sleepUsable = true,
        onTry = function(self, source)
            return (source.status == "slp") or source:hasAbility("comatose")
        end,
        secondary = {chance = 30, volatileStatus = "flinch"},
        target = "normal",
        type = "Normal",
        contestType = "Cute"
    },
    soak = {
        num = 487,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Soak",
        pp = 20,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1},
        onHit = function(self, target)
            if (target:getTypes():join() == "Water") or (not target:setType("Water")) then
                self:add("-fail", target)
                return nil
            end
            self:add("-start", target, "typechange", "Water")
        end,
        secondary = nil,
        target = "normal",
        type = "Water",
        zMove = {boost = {spa = 1}},
        contestType = "Cute"
    },
    softboiled = {num = 135, accuracy = true, basePower = 0, category = "Status", name = "Soft-Boiled", pp = 10, priority = 0, flags = {snatch = 1, heal = 1}, heal = {1, 2}, secondary = nil, target = "self", type = "Normal", zMove = {effect = "clearnegativeboost"}, contestType = "Cute"},
    solarbeam = {
        num = 76,
        accuracy = 100,
        basePower = 120,
        category = "Special",
        name = "Solar Beam",
        pp = 10,
        priority = 0,
        flags = {charge = 1, protect = 1, mirror = 1},
        onTryMove = function(self, attacker, defender, move)
            if attacker:removeVolatile(move.id) then
                return
            end
            self:add("-prepare", attacker, move.name)
            if ({"sunnyday", "desolateland"}):includes(
                attacker:effectiveWeather()
            ) then
                self:attrLastMove("[still]")
                self:addMove("-anim", attacker, move.name, defender)
                return
            end
            if not self:runEvent("ChargeMove", attacker, defender, move) then
                return
            end
            attacker:addVolatile("twoturnmove", defender)
            return nil
        end,
        onBasePower = function(self, basePower, pokemon, target)
            if ({"raindance", "primordialsea", "sandstorm", "hail"}):includes(
                pokemon:effectiveWeather()
            ) then
                self:debug("weakened by weather")
                return self:chainModify(0.5)
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Grass",
        contestType = "Cool"
    },
    solarblade = {
        num = 669,
        accuracy = 100,
        basePower = 125,
        category = "Physical",
        name = "Solar Blade",
        pp = 10,
        priority = 0,
        flags = {contact = 1, charge = 1, protect = 1, mirror = 1},
        onTryMove = function(self, attacker, defender, move)
            if attacker:removeVolatile(move.id) then
                return
            end
            self:add("-prepare", attacker, move.name)
            if ({"sunnyday", "desolateland"}):includes(
                attacker:effectiveWeather()
            ) then
                self:attrLastMove("[still]")
                self:addMove("-anim", attacker, move.name, defender)
                return
            end
            if not self:runEvent("ChargeMove", attacker, defender, move) then
                return
            end
            attacker:addVolatile("twoturnmove", defender)
            return nil
        end,
        onBasePower = function(self, basePower, pokemon, target)
            if ({"raindance", "primordialsea", "sandstorm", "hail"}):includes(
                pokemon:effectiveWeather()
            ) then
                self:debug("weakened by weather")
                return self:chainModify(0.5)
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Grass",
        contestType = "Cool"
    },
    sonicboom = {num = 49, accuracy = 90, basePower = 0, damage = 20, category = "Special", isNonstandard = "Past", name = "Sonic Boom", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Normal", contestType = "Cool"},
    soulstealing7starstrike = {num = 699, accuracy = true, basePower = 195, category = "Physical", isNonstandard = "Past", name = "Soul-Stealing 7-Star Strike", pp = 1, priority = 0, flags = {contact = 1}, isZ = "marshadiumz", secondary = nil, target = "normal", type = "Ghost", contestType = "Cool"},
    spacialrend = {num = 460, accuracy = 95, basePower = 100, category = "Special", name = "Spacial Rend", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, critRatio = 2, secondary = nil, target = "normal", type = "Dragon", contestType = "Beautiful"},
    spark = {num = 209, accuracy = 100, basePower = 65, category = "Physical", name = "Spark", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 30, status = "par"}, target = "normal", type = "Electric", contestType = "Cool"},
    sparklingaria = {
        num = 664,
        accuracy = 100,
        basePower = 90,
        category = "Special",
        name = "Sparkling Aria",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, sound = 1, authentic = 1},
        secondary = {
            dustproof = true,
            chance = 100,
            onHit = function(self, target)
                if target.status == "brn" then
                    target:cureStatus()
                end
            end
        },
        target = "allAdjacent",
        type = "Water",
        contestType = "Tough"
    },
    sparklyswirl = {
        num = 740,
        accuracy = 85,
        basePower = 120,
        category = "Special",
        isNonstandard = "LGPE",
        name = "Sparkly Swirl",
        pp = 5,
        priority = 0,
        flags = {protect = 1},
        self = {
            onHit = function(self, pokemon, source, move)
                self:add("-activate", source, "move: Aromatherapy")
                for ____, ally in __TS__Iterator(source.side.pokemon) do
                    do
                        if (ally ~= source) and (ally.volatiles.substitute and (not move.infiltrates)) then
                            goto __continue1414
                        end
                        ally:cureStatus()
                    end
                    ::__continue1414::
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Fairy",
        contestType = "Clever"
    },
    spectralthief = {num = 712, accuracy = 100, basePower = 90, category = "Physical", name = "Spectral Thief", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, authentic = 1}, stealsBoosts = true, secondary = nil, target = "normal", type = "Ghost", contestType = "Cool"},
    speedswap = {
        num = 683,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Speed Swap",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, authentic = 1, mystery = 1},
        onHit = function(self, target, source)
            local targetSpe = target.storedStats.spe
            target.storedStats.spe = source.storedStats.spe
            source.storedStats.spe = targetSpe
            self:add(
                "-activate",
                source,
                "move: Speed Swap",
                "[of] " .. tostring(target)
            )
        end,
        secondary = nil,
        target = "normal",
        type = "Psychic",
        zMove = {boost = {spe = 1}},
        contestType = "Clever"
    },
    spiderweb = {
        num = 169,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Spider Web",
        pp = 10,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1},
        onHit = function(self, target, source, move)
            return target:addVolatile("trapped", source, move, "trapper")
        end,
        secondary = nil,
        target = "normal",
        type = "Bug",
        zMove = {boost = {def = 1}},
        contestType = "Clever"
    },
    spikecannon = {num = 131, accuracy = 100, basePower = 20, category = "Physical", isNonstandard = "Past", name = "Spike Cannon", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, multihit = {2, 5}, secondary = nil, target = "normal", type = "Normal", maxMove = {basePower = 120}, contestType = "Cool"},
    spikes = {
        num = 191,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Spikes",
        pp = 20,
        priority = 0,
        flags = {reflectable = 1, nonsky = 1},
        sideCondition = "spikes",
        condition = {
            onSideStart = function(self, side)
                self:add("-sidestart", side, "Spikes")
                self.effectState.layers = 1
            end,
            onSideRestart = function(self, side)
                if self.effectState.layers >= 3 then
                    return false
                end
                self:add("-sidestart", side, "Spikes")
                local ____obj, ____index = self.effectState, "layers"
                ____obj[____index] = ____obj[____index] + 1
            end,
            onSwitchIn = function(self, pokemon)
                if not pokemon:isGrounded() then
                    return
                end
                if pokemon:hasItem("heavydutyboots") then
                    return
                end
                local damageAmounts = {0, 3, 4, 6}
                self:damage((damageAmounts[self.effectState.layers] * pokemon.maxhp) / 24)
            end
        },
        secondary = nil,
        target = "foeSide",
        type = "Ground",
        zMove = {boost = {def = 1}},
        contestType = "Clever"
    },
    spikyshield = {
        num = 596,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Spiky Shield",
        pp = 10,
        priority = 4,
        flags = {},
        stallingMove = true,
        volatileStatus = "spikyshield",
        onPrepareHit = function(self, pokemon)
            return (not (not self.queue:willAct())) and self:runEvent("StallMove", pokemon)
        end,
        onHit = function(self, pokemon)
            pokemon:addVolatile("stall")
        end,
        condition = {
            duration = 1,
            onStart = function(self, target)
                self:add("-singleturn", target, "move: Protect")
            end,
            onTryHitPriority = 3,
            onTryHit = function(self, target, source, move)
                if not move.flags.protect then
                    if ({"gmaxoneblow", "gmaxrapidflow"}):includes(move.id) then
                        return
                    end
                    if move.isZ or move.isMax then
                        target:getMoveHitData(move).zBrokeProtect = true
                    end
                    return
                end
                if move.smartTarget then
                    move.smartTarget = false
                else
                    self:add("-activate", target, "move: Protect")
                end
                local lockedmove = source:getVolatile("lockedmove")
                if lockedmove then
                    if source.volatiles.lockedmove.duration == 2 then
                        __TS__Delete(source.volatiles, "lockedmove")
                    end
                end
                if self:checkMoveMakesContact(move, source, target) then
                    self:damage(source.baseMaxhp / 8, source, target)
                end
                return self.NOT_FAIL
            end,
            onHit = function(self, target, source, move)
                if move.isZOrMaxPowered and self:checkMoveMakesContact(move, source, target) then
                    self:damage(source.baseMaxhp / 8, source, target)
                end
            end
        },
        secondary = nil,
        target = "self",
        type = "Grass",
        zMove = {boost = {def = 1}},
        contestType = "Tough"
    },
    spiritbreak = {num = 789, accuracy = 100, basePower = 75, category = "Physical", name = "Spirit Break", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {spa = -1}}, target = "normal", type = "Fairy"},
    spiritshackle = {
        num = 662,
        accuracy = 100,
        basePower = 80,
        category = "Physical",
        name = "Spirit Shackle",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        secondary = {
            chance = 100,
            onHit = function(self, target, source, move)
                if source.isActive then
                    target:addVolatile("trapped", source, move, "trapper")
                end
            end
        },
        target = "normal",
        type = "Ghost",
        contestType = "Tough"
    },
    spitup = {
        num = 255,
        accuracy = 100,
        basePower = 0,
        basePowerCallback = function(self, pokemon)
            if not pokemon.volatiles.stockpile.layers then
                return false
            end
            return pokemon.volatiles.stockpile.layers * 100
        end,
        category = "Special",
        name = "Spit Up",
        pp = 10,
        priority = 0,
        flags = {protect = 1},
        onTry = function(self, source)
            return not (not source.volatiles.stockpile)
        end,
        onAfterMove = function(self, pokemon)
            pokemon:removeVolatile("stockpile")
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Tough"
    },
    spite = {
        num = 180,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Spite",
        pp = 10,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, authentic = 1},
        onHit = function(self, target)
            local move = target.lastMove
            if (not move) or move.isZ then
                return false
            end
            if move.isMax and move.baseMove then
                move = self.dex.moves:get(move.baseMove)
            end
            local ppDeducted = target:deductPP(move.id, 4)
            if not ppDeducted then
                return false
            end
            self:add("-activate", target, "move: Spite", move.name, ppDeducted)
        end,
        secondary = nil,
        target = "normal",
        type = "Ghost",
        zMove = {effect = "heal"},
        contestType = "Tough"
    },
    splash = {
        num = 150,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Splash",
        pp = 40,
        priority = 0,
        flags = {gravity = 1},
        onTry = function(self, source, target, move)
            if self.field:getPseudoWeather("Gravity") then
                self:add("cant", source, "move: Gravity", move)
                return nil
            end
        end,
        onTryHit = function(self, target, source)
            self:add("-nothing")
        end,
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {boost = {atk = 3}},
        contestType = "Cute"
    },
    splinteredstormshards = {
        num = 727,
        accuracy = true,
        basePower = 190,
        category = "Physical",
        isNonstandard = "Past",
        name = "Splintered Stormshards",
        pp = 1,
        priority = 0,
        flags = {},
        onHit = function(self)
            self.field:clearTerrain()
        end,
        isZ = "lycaniumz",
        secondary = nil,
        target = "normal",
        type = "Rock",
        contestType = "Cool"
    },
    splishysplash = {num = 730, accuracy = 100, basePower = 90, category = "Special", isNonstandard = "LGPE", name = "Splishy Splash", pp = 15, priority = 0, flags = {protect = 1}, secondary = {chance = 30, status = "par"}, target = "allAdjacentFoes", type = "Water", contestType = "Cool"},
    spore = {num = 147, accuracy = 100, basePower = 0, category = "Status", name = "Spore", pp = 15, priority = 0, flags = {powder = 1, protect = 1, reflectable = 1, mirror = 1}, status = "slp", secondary = nil, target = "normal", type = "Grass", zMove = {effect = "clearnegativeboost"}, contestType = "Beautiful"},
    spotlight = {
        num = 671,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Spotlight",
        pp = 15,
        priority = 3,
        flags = {protect = 1, reflectable = 1, mystery = 1},
        volatileStatus = "spotlight",
        onTryHit = function(self, target)
            if self.activePerHalf == 1 then
                return false
            end
        end,
        condition = {
            duration = 1,
            onStart = function(self, pokemon)
                self:add("-singleturn", pokemon, "move: Spotlight")
            end,
            onFoeRedirectTargetPriority = 2,
            onFoeRedirectTarget = function(self, target, source, source2, move)
                if self:validTarget(self.effectState.target, source, move.target) then
                    self:debug("Spotlight redirected target of move")
                    return self.effectState.target
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {spd = 1}},
        contestType = "Cute"
    },
    stealthrock = {
        num = 446,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Stealth Rock",
        pp = 20,
        priority = 0,
        flags = {reflectable = 1},
        sideCondition = "stealthrock",
        condition = {
            onSideStart = function(self, side)
                self:add("-sidestart", side, "move: Stealth Rock")
            end,
            onSwitchIn = function(self, pokemon)
                if pokemon:hasItem("heavydutyboots") then
                    return
                end
                local typeMod = self:clampIntRange(
                    pokemon:runEffectiveness(
                        self.dex:getActiveMove("stealthrock")
                    ),
                    -6,
                    6
                )
                self:damage(
                    (pokemon.maxhp * math.pow(2, typeMod)) / 8
                )
            end
        },
        secondary = nil,
        target = "foeSide",
        type = "Rock",
        zMove = {boost = {def = 1}},
        contestType = "Cool"
    },
    steameruption = {num = 592, accuracy = 95, basePower = 110, category = "Special", name = "Steam Eruption", pp = 5, priority = 0, flags = {protect = 1, mirror = 1, defrost = 1}, thawsTarget = true, secondary = {chance = 30, status = "brn"}, target = "normal", type = "Water", contestType = "Beautiful"},
    steamroller = {num = 537, accuracy = 100, basePower = 65, category = "Physical", isNonstandard = "Past", name = "Steamroller", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 30, volatileStatus = "flinch"}, target = "normal", type = "Bug", contestType = "Tough"},
    steelbeam = {
        num = 796,
        accuracy = 95,
        basePower = 140,
        category = "Special",
        name = "Steel Beam",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        mindBlownRecoil = true,
        onAfterMove = function(self, pokemon, target, move)
            if move.mindBlownRecoil and (not move.multihit) then
                self:damage(
                    math.floor((pokemon.maxhp / 2) + 0.5),
                    pokemon,
                    pokemon,
                    self.dex.conditions:get("Steel Beam"),
                    true
                )
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Steel"
    },
    steelroller = {
        num = 798,
        accuracy = 100,
        basePower = 130,
        category = "Physical",
        name = "Steel Roller",
        pp = 5,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onTry = function(self)
            return not self.field:isTerrain("")
        end,
        onHit = function(self)
            self.field:clearTerrain()
        end,
        secondary = nil,
        target = "normal",
        type = "Steel"
    },
    steelwing = {num = 211, accuracy = 90, basePower = 70, category = "Physical", name = "Steel Wing", pp = 25, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 10, self = {boosts = {def = 1}}}, target = "normal", type = "Steel", contestType = "Cool"},
    stickyweb = {
        num = 564,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Sticky Web",
        pp = 20,
        priority = 0,
        flags = {reflectable = 1},
        sideCondition = "stickyweb",
        condition = {
            onSideStart = function(self, side)
                self:add("-sidestart", side, "move: Sticky Web")
            end,
            onSwitchIn = function(self, pokemon)
                if not pokemon:isGrounded() then
                    return
                end
                if pokemon:hasItem("heavydutyboots") then
                    return
                end
                self:add("-activate", pokemon, "move: Sticky Web")
                self:boost(
                    {spe = -1},
                    pokemon,
                    self.effectState.source,
                    self.dex:getActiveMove("stickyweb")
                )
            end
        },
        secondary = nil,
        pressureTarget = "self",
        target = "foeSide",
        type = "Bug",
        zMove = {boost = {spe = 1}},
        contestType = "Tough"
    },
    stockpile = {
        num = 254,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Stockpile",
        pp = 20,
        priority = 0,
        flags = {snatch = 1},
        onTry = function(self, source)
            if source.volatiles.stockpile and (source.volatiles.stockpile.layers >= 3) then
                return false
            end
        end,
        volatileStatus = "stockpile",
        condition = {
            noCopy = true,
            onStart = function(self, target)
                self.effectState.layers = 1
                self.effectState.def = 0
                self.effectState.spd = 0
                self:add(
                    "-start",
                    target,
                    "stockpile" .. tostring(self.effectState.layers)
                )
                local curDef, curSpD = target.boosts.def, target.boosts.spd
                self:boost({def = 1, spd = 1}, target, target)
                if curDef ~= target.boosts.def then
                    local ____obj, ____index = self.effectState, "def"
                    ____obj[____index] = ____obj[____index] - 1
                end
                if curSpD ~= target.boosts.spd then
                    local ____obj, ____index = self.effectState, "spd"
                    ____obj[____index] = ____obj[____index] - 1
                end
            end,
            onRestart = function(self, target)
                if self.effectState.layers >= 3 then
                    return false
                end
                local ____obj, ____index = self.effectState, "layers"
                ____obj[____index] = ____obj[____index] + 1
                self:add(
                    "-start",
                    target,
                    "stockpile" .. tostring(self.effectState.layers)
                )
                local curDef = target.boosts.def
                local curSpD = target.boosts.spd
                self:boost({def = 1, spd = 1}, target, target)
                if curDef ~= target.boosts.def then
                    local ____obj, ____index = self.effectState, "def"
                    ____obj[____index] = ____obj[____index] - 1
                end
                if curSpD ~= target.boosts.spd then
                    local ____obj, ____index = self.effectState, "spd"
                    ____obj[____index] = ____obj[____index] - 1
                end
            end,
            onEnd = function(self, target)
                if self.effectState.def or self.effectState.spd then
                    local boosts = {}
                    if self.effectState.def then
                        boosts.def = self.effectState.def
                    end
                    if self.effectState.spd then
                        boosts.spd = self.effectState.spd
                    end
                    self:boost(boosts, target, target)
                end
                self:add("-end", target, "Stockpile")
                if (self.effectState.def ~= (self.effectState.layers * -1)) or (self.effectState.spd ~= (self.effectState.layers * -1)) then
                    self:hint("In Gen 7, Stockpile keeps track of how many times it successfully altered each stat individually.")
                end
            end
        },
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {effect = "heal"},
        contestType = "Tough"
    },
    stokedsparksurfer = {num = 700, accuracy = true, basePower = 175, category = "Special", isNonstandard = "Past", name = "Stoked Sparksurfer", pp = 1, priority = 0, flags = {}, isZ = "aloraichiumz", secondary = {chance = 100, status = "par"}, target = "normal", type = "Electric", contestType = "Cool"},
    stomp = {num = 23, accuracy = 100, basePower = 65, category = "Physical", name = "Stomp", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, nonsky = 1}, secondary = {chance = 30, volatileStatus = "flinch"}, target = "normal", type = "Normal", contestType = "Tough"},
    stompingtantrum = {
        num = 707,
        accuracy = 100,
        basePower = 75,
        basePowerCallback = function(self, pokemon, target, move)
            if pokemon.moveLastTurnResult == false then
                self:debug("doubling Stomping Tantrum BP due to previous move failure")
                return move.basePower * 2
            end
            return move.basePower
        end,
        category = "Physical",
        name = "Stomping Tantrum",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Ground",
        contestType = "Tough"
    },
    stoneedge = {num = 444, accuracy = 80, basePower = 100, category = "Physical", name = "Stone Edge", pp = 5, priority = 0, flags = {protect = 1, mirror = 1}, critRatio = 2, secondary = nil, target = "normal", type = "Rock", contestType = "Tough"},
    storedpower = {
        num = 500,
        accuracy = 100,
        basePower = 20,
        basePowerCallback = function(self, pokemon, target, move)
            return move.basePower + (20 * pokemon:positiveBoosts())
        end,
        category = "Special",
        name = "Stored Power",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Psychic",
        zMove = {basePower = 160},
        maxMove = {basePower = 130},
        contestType = "Clever"
    },
    stormthrow = {num = 480, accuracy = 100, basePower = 60, category = "Physical", name = "Storm Throw", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, willCrit = true, secondary = nil, target = "normal", type = "Fighting", contestType = "Cool"},
    strangesteam = {num = 790, accuracy = 95, basePower = 90, category = "Special", name = "Strange Steam", pp = 10, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 20, volatileStatus = "confusion"}, target = "normal", type = "Fairy"},
    strength = {num = 70, accuracy = 100, basePower = 80, category = "Physical", name = "Strength", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Normal", contestType = "Tough"},
    strengthsap = {
        num = 668,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Strength Sap",
        pp = 10,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, heal = 1},
        onHit = function(self, target, source)
            if target.boosts.atk == -6 then
                return false
            end
            local atk = target:getStat("atk", false, true)
            local success = self:boost({atk = -1}, target, source, nil, false, true)
            return not (not (self:heal(atk, source, target) or success))
        end,
        secondary = nil,
        target = "normal",
        type = "Grass",
        zMove = {boost = {def = 1}},
        contestType = "Cute"
    },
    stringshot = {num = 81, accuracy = 95, basePower = 0, category = "Status", name = "String Shot", pp = 40, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, boosts = {spe = -2}, secondary = nil, target = "allAdjacentFoes", type = "Bug", zMove = {boost = {spe = 1}}, contestType = "Clever"},
    struggle = {
        num = 165,
        accuracy = true,
        basePower = 50,
        category = "Physical",
        name = "Struggle",
        pp = 1,
        noPPBoosts = true,
        priority = 0,
        flags = {contact = 1, protect = 1},
        noSketch = true,
        onModifyMove = function(self, move, pokemon, target)
            move.type = "???"
            self:add("-activate", pokemon, "move: Struggle")
        end,
        struggleRecoil = true,
        secondary = nil,
        target = "randomNormal",
        type = "Normal",
        contestType = "Tough"
    },
    strugglebug = {num = 522, accuracy = 100, basePower = 50, category = "Special", name = "Struggle Bug", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {spa = -1}}, target = "allAdjacentFoes", type = "Bug", contestType = "Cute"},
    stuffcheeks = {
        num = 747,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Stuff Cheeks",
        pp = 10,
        priority = 0,
        flags = {snatch = 1},
        onTry = function(self, source)
            local item = source:getItem()
            if item.isBerry and source:eatItem(true) then
                self:boost({def = 2}, source, nil, nil, false, true)
            else
                return false
            end
        end,
        secondary = nil,
        target = "self",
        type = "Normal"
    },
    stunspore = {num = 78, accuracy = 75, basePower = 0, category = "Status", name = "Stun Spore", pp = 30, priority = 0, flags = {powder = 1, protect = 1, reflectable = 1, mirror = 1}, status = "par", secondary = nil, target = "normal", type = "Grass", zMove = {boost = {spd = 1}}, contestType = "Clever"},
    submission = {num = 66, accuracy = 80, basePower = 80, category = "Physical", name = "Submission", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, recoil = {1, 4}, secondary = nil, target = "normal", type = "Fighting", contestType = "Cool"},
    substitute = {
        num = 164,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Substitute",
        pp = 10,
        priority = 0,
        flags = {snatch = 1, nonsky = 1},
        volatileStatus = "substitute",
        onTryHit = function(self, target)
            if target.volatiles.substitute then
                self:add("-fail", target, "move: Substitute")
                return nil
            end
            if (target.hp <= (target.maxhp / 4)) or (target.maxhp == 1) then
                self:add("-fail", target, "move: Substitute", "[weak]")
                return nil
            end
        end,
        onHit = function(self, target)
            self:directDamage(target.maxhp / 4)
        end,
        condition = {
            onStart = function(self, target)
                self:add("-start", target, "Substitute")
                self.effectState.hp = math.floor(target.maxhp / 4)
                if target.volatiles.partiallytrapped then
                    self:add("-end", target, target.volatiles.partiallytrapped.sourceEffect, "[partiallytrapped]", "[silent]")
                    __TS__Delete(target.volatiles, "partiallytrapped")
                end
            end,
            onTryPrimaryHitPriority = -1,
            onTryPrimaryHit = function(self, target, source, move)
                if ((target == source) or move.flags.authentic) or move.infiltrates then
                    return
                end
                local damage = self.actions:getDamage(source, target, move)
                if (not damage) and (damage ~= 0) then
                    self:add("-fail", source)
                    self:attrLastMove("[still]")
                    return nil
                end
                damage = self:runEvent("SubDamage", target, source, move, damage)
                if not damage then
                    return damage
                end
                if damage > target.volatiles.substitute.hp then
                    damage = target.volatiles.substitute.hp
                end
                local ____obj, ____index = target.volatiles.substitute, "hp"
                ____obj[____index] = ____obj[____index] - damage
                source.lastDamage = damage
                if target.volatiles.substitute.hp <= 0 then
                    if move.ohko then
                        self:add("-ohko")
                    end
                    target:removeVolatile("substitute")
                else
                    self:add("-activate", target, "move: Substitute", "[damage]")
                end
                if move.recoil then
                    self:damage(
                        self.actions:calcRecoilDamage(damage, move),
                        source,
                        target,
                        "recoil"
                    )
                end
                if move.drain then
                    self:heal(
                        math.ceil((damage * move.drain[0]) / move.drain[1]),
                        source,
                        target,
                        "drain"
                    )
                end
                self:singleEvent("AfterSubDamage", move, nil, target, source, move, damage)
                self:runEvent("AfterSubDamage", target, source, move, damage)
                return self.HIT_SUBSTITUTE
            end,
            onEnd = function(self, target)
                self:add("-end", target, "Substitute")
            end
        },
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Cute"
    },
    subzeroslammer = {num = 650, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Subzero Slammer", pp = 1, priority = 0, flags = {}, isZ = "iciumz", secondary = nil, target = "normal", type = "Ice", contestType = "Cool"},
    suckerpunch = {
        num = 389,
        accuracy = 100,
        basePower = 70,
        category = "Physical",
        name = "Sucker Punch",
        pp = 5,
        priority = 1,
        flags = {contact = 1, protect = 1, mirror = 1},
        onTry = function(self, source, target)
            local action = self.queue:willMove(target)
            local move = (((action.choice == "move") and (function() return action.move end)) or (function() return nil end))()
            if ((not move) or ((move.category == "Status") and (move.id ~= "mefirst"))) or target.volatiles.mustrecharge then
                return false
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Dark",
        contestType = "Clever"
    },
    sunnyday = {num = 241, accuracy = true, basePower = 0, category = "Status", name = "Sunny Day", pp = 5, priority = 0, flags = {}, weather = "sunnyday", secondary = nil, target = "all", type = "Fire", zMove = {boost = {spe = 1}}, contestType = "Beautiful"},
    sunsteelstrike = {num = 713, accuracy = 100, basePower = 100, category = "Physical", name = "Sunsteel Strike", pp = 5, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, ignoreAbility = true, secondary = nil, target = "normal", type = "Steel", contestType = "Cool"},
    superfang = {
        num = 162,
        accuracy = 90,
        basePower = 0,
        damageCallback = function(self, pokemon, target)
            return self:clampIntRange(
                target:getUndynamaxedHP() / 2,
                1
            )
        end,
        category = "Physical",
        name = "Super Fang",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Tough"
    },
    superpower = {num = 276, accuracy = 100, basePower = 120, category = "Physical", name = "Superpower", pp = 5, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, self = {boosts = {atk = -1, def = -1}}, secondary = nil, target = "normal", type = "Fighting", contestType = "Tough"},
    supersonic = {num = 48, accuracy = 55, basePower = 0, category = "Status", name = "Supersonic", pp = 20, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1, sound = 1, authentic = 1}, volatileStatus = "confusion", secondary = nil, target = "normal", type = "Normal", zMove = {boost = {spe = 1}}, contestType = "Clever"},
    supersonicskystrike = {num = 626, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Supersonic Skystrike", pp = 1, priority = 0, flags = {}, isZ = "flyiniumz", secondary = nil, target = "normal", type = "Flying", contestType = "Cool"},
    surf = {num = 57, accuracy = 100, basePower = 90, category = "Special", name = "Surf", pp = 15, priority = 0, flags = {protect = 1, mirror = 1, nonsky = 1}, secondary = nil, target = "allAdjacent", type = "Water", contestType = "Beautiful"},
    surgingstrikes = {num = 818, accuracy = 100, basePower = 25, category = "Physical", name = "Surging Strikes", pp = 5, priority = 0, flags = {contact = 1, protect = 1, punch = 1, mirror = 1}, willCrit = true, multihit = 3, secondary = nil, target = "normal", type = "Water", zMove = {basePower = 140}, maxMove = {basePower = 130}},
    swagger = {num = 207, accuracy = 85, basePower = 0, category = "Status", name = "Swagger", pp = 15, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1}, volatileStatus = "confusion", boosts = {atk = 2}, secondary = nil, target = "normal", type = "Normal", zMove = {effect = "clearnegativeboost"}, contestType = "Cute"},
    swallow = {
        num = 256,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Swallow",
        pp = 10,
        priority = 0,
        flags = {snatch = 1, heal = 1},
        onTry = function(self, source)
            return not (not source.volatiles.stockpile)
        end,
        onHit = function(self, pokemon)
            local healAmount = {0.25, 0.5, 1}
            local healedBy = self:heal(
                self:modify(pokemon.maxhp, healAmount[pokemon.volatiles.stockpile.layers])
            )
            pokemon:removeVolatile("stockpile")
            return not (not healedBy)
        end,
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Tough"
    },
    sweetkiss = {num = 186, accuracy = 75, basePower = 0, category = "Status", name = "Sweet Kiss", pp = 10, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, volatileStatus = "confusion", secondary = nil, target = "normal", type = "Fairy", zMove = {boost = {spa = 1}}, contestType = "Cute"},
    sweetscent = {num = 230, accuracy = 100, basePower = 0, category = "Status", name = "Sweet Scent", pp = 20, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, boosts = {evasion = -2}, secondary = nil, target = "allAdjacentFoes", type = "Normal", zMove = {boost = {accuracy = 1}}, contestType = "Cute"},
    swift = {num = 129, accuracy = true, basePower = 60, category = "Special", name = "Swift", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "allAdjacentFoes", type = "Normal", contestType = "Cool"},
    switcheroo = {
        num = 415,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Switcheroo",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, mystery = 1},
        onTryImmunity = function(self, target)
            return not target:hasAbility("stickyhold")
        end,
        onHit = function(self, target, source, move)
            local yourItem = target:takeItem(source)
            local myItem = source:takeItem()
            if (target.item or source.item) or ((not yourItem) and (not myItem)) then
                if yourItem then
                    target.item = yourItem.id
                end
                if myItem then
                    source.item = myItem.id
                end
                return false
            end
            if (myItem and (not self:singleEvent("TakeItem", myItem, source.itemState, target, source, move, myItem))) or (yourItem and (not self:singleEvent("TakeItem", yourItem, target.itemState, source, target, move, yourItem))) then
                if yourItem then
                    target.item = yourItem.id
                end
                if myItem then
                    source.item = myItem.id
                end
                return false
            end
            self:add(
                "-activate",
                source,
                "move: Trick",
                "[of] " .. tostring(target)
            )
            if myItem then
                target:setItem(myItem)
                self:add("-item", target, myItem, "[from] move: Switcheroo")
            else
                self:add("-enditem", target, yourItem, "[silent]", "[from] move: Switcheroo")
            end
            if yourItem then
                source:setItem(yourItem)
                self:add("-item", source, yourItem, "[from] move: Switcheroo")
            else
                self:add("-enditem", source, myItem, "[silent]", "[from] move: Switcheroo")
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Dark",
        zMove = {boost = {spe = 2}},
        contestType = "Clever"
    },
    swordsdance = {num = 14, accuracy = true, basePower = 0, category = "Status", name = "Swords Dance", pp = 20, priority = 0, flags = {snatch = 1, dance = 1}, boosts = {atk = 2}, secondary = nil, target = "self", type = "Normal", zMove = {effect = "clearnegativeboost"}, contestType = "Beautiful"},
    synchronoise = {
        num = 485,
        accuracy = 100,
        basePower = 120,
        category = "Special",
        isNonstandard = "Past",
        name = "Synchronoise",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onTryImmunity = function(self, target, source)
            return target:hasType(
                source:getTypes()
            )
        end,
        secondary = nil,
        target = "allAdjacent",
        type = "Psychic",
        contestType = "Clever"
    },
    synthesis = {
        num = 235,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Synthesis",
        pp = 5,
        priority = 0,
        flags = {snatch = 1, heal = 1},
        onHit = function(self, pokemon)
            local factor = 0.5
            local ____switch1527 = pokemon:effectiveWeather()
            if ____switch1527 == "sunnyday" then
                goto ____switch1527_case_0
            elseif ____switch1527 == "desolateland" then
                goto ____switch1527_case_1
            elseif ____switch1527 == "raindance" then
                goto ____switch1527_case_2
            elseif ____switch1527 == "primordialsea" then
                goto ____switch1527_case_3
            elseif ____switch1527 == "sandstorm" then
                goto ____switch1527_case_4
            elseif ____switch1527 == "hail" then
                goto ____switch1527_case_5
            end
            goto ____switch1527_end
            ::____switch1527_case_0::
            do
            end
            ::____switch1527_case_1::
            do
                factor = 0.667
                goto ____switch1527_end
            end
            ::____switch1527_case_2::
            do
            end
            ::____switch1527_case_3::
            do
            end
            ::____switch1527_case_4::
            do
            end
            ::____switch1527_case_5::
            do
                factor = 0.25
                goto ____switch1527_end
            end
            ::____switch1527_end::
            return not (not self:heal(
                self:modify(pokemon.maxhp, factor)
            ))
        end,
        secondary = nil,
        target = "self",
        type = "Grass",
        zMove = {effect = "clearnegativeboost"},
        contestType = "Clever"
    },
    tackle = {num = 33, accuracy = 100, basePower = 40, category = "Physical", name = "Tackle", pp = 35, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Normal", contestType = "Tough"},
    tailglow = {num = 294, accuracy = true, basePower = 0, category = "Status", isNonstandard = "Past", name = "Tail Glow", pp = 20, priority = 0, flags = {snatch = 1}, boosts = {spa = 3}, secondary = nil, target = "self", type = "Bug", zMove = {effect = "clearnegativeboost"}, contestType = "Beautiful"},
    tailslap = {num = 541, accuracy = 85, basePower = 25, category = "Physical", name = "Tail Slap", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, multihit = {2, 5}, secondary = nil, target = "normal", type = "Normal", zMove = {basePower = 140}, maxMove = {basePower = 130}, contestType = "Cute"},
    tailwhip = {num = 39, accuracy = 100, basePower = 0, category = "Status", name = "Tail Whip", pp = 30, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, boosts = {def = -1}, secondary = nil, target = "allAdjacentFoes", type = "Normal", zMove = {boost = {atk = 1}}, contestType = "Cute"},
    tailwind = {
        num = 366,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Tailwind",
        pp = 15,
        priority = 0,
        flags = {snatch = 1},
        sideCondition = "tailwind",
        condition = {
            duration = 4,
            durationCallback = function(self, target, source, effect)
                if source:hasAbility("persistent") then
                    self:add("-activate", source, "ability: Persistent", effect)
                    return 6
                end
                return 4
            end,
            onSideStart = function(self, side)
                self:add("-sidestart", side, "move: Tailwind")
            end,
            onModifySpe = function(self, spe, pokemon)
                return self:chainModify(2)
            end,
            onSideResidualOrder = 26,
            onSideResidualSubOrder = 5,
            onSideEnd = function(self, side)
                self:add("-sideend", side, "move: Tailwind")
            end
        },
        secondary = nil,
        target = "allySide",
        type = "Flying",
        zMove = {effect = "crit2"},
        contestType = "Cool"
    },
    takedown = {num = 36, accuracy = 85, basePower = 90, category = "Physical", name = "Take Down", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, recoil = {1, 4}, secondary = nil, target = "normal", type = "Normal", contestType = "Tough"},
    tarshot = {
        num = 749,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Tar Shot",
        pp = 15,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1},
        volatileStatus = "tarshot",
        condition = {
            onStart = function(self, pokemon)
                self:add("-start", pokemon, "Tar Shot")
            end,
            onEffectivenessPriority = -2,
            onEffectiveness = function(self, typeMod, target, ____type, move)
                if move.type ~= "Fire" then
                    return
                end
                if not target then
                    return
                end
                if ____type ~= target:getTypes()[0] then
                    return
                end
                return typeMod + 1
            end
        },
        boosts = {spe = -1},
        secondary = nil,
        target = "normal",
        type = "Rock"
    },
    taunt = {
        num = 269,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Taunt",
        pp = 20,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, authentic = 1},
        volatileStatus = "taunt",
        condition = {
            duration = 3,
            onStart = function(self, target)
                if target.activeTurns and (not self.queue:willMove(target)) then
                    local ____obj, ____index = self.effectState, "duration"
                    ____obj[____index] = ____obj[____index] + 1
                end
                self:add("-start", target, "move: Taunt")
            end,
            onResidualOrder = 15,
            onEnd = function(self, target)
                self:add("-end", target, "move: Taunt")
            end,
            onDisableMove = function(self, pokemon)
                for ____, moveSlot in __TS__Iterator(pokemon.moveSlots) do
                    local move = self.dex.moves:get(moveSlot.id)
                    if (move.category == "Status") and (move.id ~= "mefirst") then
                        pokemon:disableMove(moveSlot.id)
                    end
                end
            end,
            onBeforeMovePriority = 5,
            onBeforeMove = function(self, attacker, defender, move)
                if (((not move.isZ) and (not move.isMax)) and (move.category == "Status")) and (move.id ~= "mefirst") then
                    self:add("cant", attacker, "move: Taunt", move)
                    return false
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Dark",
        zMove = {boost = {atk = 1}},
        contestType = "Clever"
    },
    tearfullook = {num = 715, accuracy = true, basePower = 0, category = "Status", name = "Tearful Look", pp = 20, priority = 0, flags = {reflectable = 1, mirror = 1}, boosts = {atk = -1, spa = -1}, secondary = nil, target = "normal", type = "Normal", zMove = {boost = {def = 1}}, contestType = "Cute"},
    teatime = {
        num = 752,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Teatime",
        pp = 10,
        priority = 0,
        flags = {authentic = 1},
        onHitField = function(self, target, source, move)
            local result = false
            for ____, active in __TS__Iterator(
                self:getAllActive()
            ) do
                if self:runEvent("Invulnerability", active, source, move) == false then
                    self:add("-miss", source, active)
                    result = true
                elseif self:runEvent("TryHit", active, source, move) then
                    local item = active:getItem()
                    if active.hp and item.isBerry then
                        active:eatItem(true)
                        result = true
                    end
                end
            end
            return result
        end,
        secondary = nil,
        target = "all",
        type = "Normal"
    },
    technoblast = {
        num = 546,
        accuracy = 100,
        basePower = 120,
        category = "Special",
        name = "Techno Blast",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onModifyType = function(self, move, pokemon)
            if pokemon:ignoringItem() then
                return
            end
            move.type = self:runEvent("Drive", pokemon, nil, move, "Normal")
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Cool"
    },
    tectonicrage = {num = 630, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Tectonic Rage", pp = 1, priority = 0, flags = {}, isZ = "groundiumz", secondary = nil, target = "normal", type = "Ground", contestType = "Cool"},
    teeterdance = {num = 298, accuracy = 100, basePower = 0, category = "Status", name = "Teeter Dance", pp = 20, priority = 0, flags = {protect = 1, mirror = 1, dance = 1}, volatileStatus = "confusion", secondary = nil, target = "allAdjacent", type = "Normal", zMove = {boost = {spa = 1}}, contestType = "Cute"},
    telekinesis = {
        num = 477,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Telekinesis",
        pp = 15,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, gravity = 1, mystery = 1},
        volatileStatus = "telekinesis",
        onTry = function(self, source, target, move)
            if self.field:getPseudoWeather("Gravity") then
                self:attrLastMove("[still]")
                self:add("cant", source, "move: Gravity", move)
                return nil
            end
        end,
        condition = {
            duration = 3,
            onStart = function(self, target)
                if ({"Diglett", "Dugtrio", "Palossand", "Sandygast"}):includes(target.baseSpecies.baseSpecies) or (target.baseSpecies.name == "Gengar-Mega") then
                    self:add("-immune", target)
                    return nil
                end
                if target.volatiles.smackdown or target.volatiles.ingrain then
                    return false
                end
                self:add("-start", target, "Telekinesis")
            end,
            onAccuracyPriority = -1,
            onAccuracy = function(self, accuracy, target, source, move)
                if move and (not move.ohko) then
                    return true
                end
            end,
            onImmunity = function(self, ____type)
                if ____type == "Ground" then
                    return false
                end
            end,
            onUpdate = function(self, pokemon)
                if pokemon.baseSpecies.name == "Gengar-Mega" then
                    __TS__Delete(pokemon.volatiles, "telekinesis")
                    self:add("-end", pokemon, "Telekinesis", "[silent]")
                end
            end,
            onResidualOrder = 19,
            onEnd = function(self, target)
                self:add("-end", target, "Telekinesis")
            end
        },
        secondary = nil,
        target = "normal",
        type = "Psychic",
        zMove = {boost = {spa = 1}},
        contestType = "Clever"
    },
    teleport = {num = 100, accuracy = true, basePower = 0, category = "Status", name = "Teleport", pp = 20, priority = -6, flags = {}, selfSwitch = true, onTryHit = true, secondary = nil, target = "self", type = "Psychic", zMove = {effect = "heal"}, contestType = "Cool"},
    terrainpulse = {
        num = 805,
        accuracy = 100,
        basePower = 50,
        category = "Special",
        name = "Terrain Pulse",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, pulse = 1},
        onModifyType = function(self, move, pokemon)
            if not pokemon:isGrounded() then
                return
            end
            local ____switch1567 = self.field.terrain
            if ____switch1567 == "electricterrain" then
                goto ____switch1567_case_0
            elseif ____switch1567 == "grassyterrain" then
                goto ____switch1567_case_1
            elseif ____switch1567 == "mistyterrain" then
                goto ____switch1567_case_2
            elseif ____switch1567 == "psychicterrain" then
                goto ____switch1567_case_3
            end
            goto ____switch1567_end
            ::____switch1567_case_0::
            do
                move.type = "Electric"
                goto ____switch1567_end
            end
            ::____switch1567_case_1::
            do
                move.type = "Grass"
                goto ____switch1567_end
            end
            ::____switch1567_case_2::
            do
                move.type = "Fairy"
                goto ____switch1567_end
            end
            ::____switch1567_case_3::
            do
                move.type = "Psychic"
                goto ____switch1567_end
            end
            ::____switch1567_end::
        end,
        onModifyMove = function(self, move, pokemon)
            if self.field.terrain and pokemon:isGrounded() then
                move.basePower = move.basePower * 2
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {basePower = 160},
        maxMove = {basePower = 130}
    },
    thief = {
        num = 168,
        accuracy = 100,
        basePower = 60,
        category = "Physical",
        name = "Thief",
        pp = 25,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onAfterHit = function(self, target, source, move)
            if source.item or source.volatiles.gem then
                return
            end
            local yourItem = target:takeItem(source)
            if not yourItem then
                return
            end
            if (not self:singleEvent("TakeItem", yourItem, target.itemState, source, target, move, yourItem)) or (not source:setItem(yourItem)) then
                target.item = yourItem.id
                return
            end
            self:add(
                "-enditem",
                target,
                yourItem,
                "[silent]",
                "[from] move: Thief",
                "[of] " .. tostring(source)
            )
            self:add(
                "-item",
                source,
                yourItem,
                "[from] move: Thief",
                "[of] " .. tostring(target)
            )
        end,
        secondary = nil,
        target = "normal",
        type = "Dark",
        contestType = "Tough"
    },
    thousandarrows = {
        num = 614,
        accuracy = 100,
        basePower = 90,
        category = "Physical",
        name = "Thousand Arrows",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, nonsky = 1},
        onEffectiveness = function(self, typeMod, target, ____type, move)
            if move.type ~= "Ground" then
                return
            end
            if not target then
                return
            end
            if not target:runImmunity("Ground") then
                if target:hasType("Flying") then
                    return 0
                end
            end
        end,
        volatileStatus = "smackdown",
        ignoreImmunity = {Ground = true},
        secondary = nil,
        target = "allAdjacentFoes",
        type = "Ground",
        zMove = {basePower = 180},
        contestType = "Beautiful"
    },
    thousandwaves = {
        num = 615,
        accuracy = 100,
        basePower = 90,
        category = "Physical",
        name = "Thousand Waves",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, nonsky = 1},
        onHit = function(self, target, source, move)
            if source.isActive then
                target:addVolatile("trapped", source, move, "trapper")
            end
        end,
        secondary = nil,
        target = "allAdjacentFoes",
        type = "Ground",
        contestType = "Tough"
    },
    thrash = {
        num = 37,
        accuracy = 100,
        basePower = 120,
        category = "Physical",
        name = "Thrash",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        self = {volatileStatus = "lockedmove"},
        onAfterMove = function(self, pokemon)
            if pokemon.volatiles.lockedmove and (pokemon.volatiles.lockedmove.duration == 1) then
                pokemon:removeVolatile("lockedmove")
            end
        end,
        secondary = nil,
        target = "randomNormal",
        type = "Normal",
        contestType = "Tough"
    },
    throatchop = {
        num = 675,
        accuracy = 100,
        basePower = 80,
        category = "Physical",
        name = "Throat Chop",
        pp = 15,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        condition = {
            duration = 2,
            onStart = function(self, target)
                self:add("-start", target, "Throat Chop", "[silent]")
            end,
            onDisableMove = function(self, pokemon)
                for ____, moveSlot in __TS__Iterator(pokemon.moveSlots) do
                    if self.dex.moves:get(moveSlot.id).flags.sound then
                        pokemon:disableMove(moveSlot.id)
                    end
                end
            end,
            onBeforeMovePriority = 6,
            onBeforeMove = function(self, pokemon, target, move)
                if ((not move.isZ) and (not move.isMax)) and move.flags.sound then
                    self:add("cant", pokemon, "move: Throat Chop")
                    return false
                end
            end,
            onModifyMove = function(self, move, pokemon, target)
                if ((not move.isZ) and (not move.isMax)) and move.flags.sound then
                    self:add("cant", pokemon, "move: Throat Chop")
                    return false
                end
            end,
            onResidualOrder = 22,
            onEnd = function(self, target)
                self:add("-end", target, "Throat Chop", "[silent]")
            end
        },
        secondary = {
            chance = 100,
            onHit = function(self, target)
                target:addVolatile("throatchop")
            end
        },
        target = "normal",
        type = "Dark",
        contestType = "Clever"
    },
    thunder = {
        num = 87,
        accuracy = 70,
        basePower = 110,
        category = "Special",
        name = "Thunder",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onModifyMove = function(self, move, pokemon, target)
            local ____switch1594 = target:effectiveWeather()
            if ____switch1594 == "raindance" then
                goto ____switch1594_case_0
            elseif ____switch1594 == "primordialsea" then
                goto ____switch1594_case_1
            elseif ____switch1594 == "sunnyday" then
                goto ____switch1594_case_2
            elseif ____switch1594 == "desolateland" then
                goto ____switch1594_case_3
            end
            goto ____switch1594_end
            ::____switch1594_case_0::
            do
            end
            ::____switch1594_case_1::
            do
                move.accuracy = true
                goto ____switch1594_end
            end
            ::____switch1594_case_2::
            do
            end
            ::____switch1594_case_3::
            do
                move.accuracy = 50
                goto ____switch1594_end
            end
            ::____switch1594_end::
        end,
        secondary = {chance = 30, status = "par"},
        target = "normal",
        type = "Electric",
        contestType = "Cool"
    },
    thunderbolt = {num = 85, accuracy = 100, basePower = 90, category = "Special", name = "Thunderbolt", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, status = "par"}, target = "normal", type = "Electric", contestType = "Cool"},
    thundercage = {num = 819, accuracy = 90, basePower = 80, category = "Special", name = "Thunder Cage", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, volatileStatus = "partiallytrapped", secondary = nil, target = "normal", type = "Electric"},
    thunderfang = {num = 422, accuracy = 95, basePower = 65, category = "Physical", name = "Thunder Fang", pp = 15, priority = 0, flags = {bite = 1, contact = 1, protect = 1, mirror = 1}, secondaries = {{chance = 10, status = "par"}, {chance = 10, volatileStatus = "flinch"}}, target = "normal", type = "Electric", contestType = "Cool"},
    thunderouskick = {num = 823, accuracy = 100, basePower = 90, category = "Physical", name = "Thunderous Kick", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {def = -1}}, target = "normal", type = "Fighting"},
    thunderpunch = {num = 9, accuracy = 100, basePower = 75, category = "Physical", name = "Thunder Punch", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, punch = 1}, secondary = {chance = 10, status = "par"}, target = "normal", type = "Electric", contestType = "Cool"},
    thundershock = {num = 84, accuracy = 100, basePower = 40, category = "Special", name = "Thunder Shock", pp = 30, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 10, status = "par"}, target = "normal", type = "Electric", contestType = "Cool"},
    thunderwave = {num = 86, accuracy = 90, basePower = 0, category = "Status", name = "Thunder Wave", pp = 20, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, status = "par", ignoreImmunity = false, secondary = nil, target = "normal", type = "Electric", zMove = {boost = {spd = 1}}, contestType = "Cool"},
    tickle = {num = 321, accuracy = 100, basePower = 0, category = "Status", name = "Tickle", pp = 20, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1}, boosts = {atk = -1, def = -1}, secondary = nil, target = "normal", type = "Normal", zMove = {boost = {def = 1}}, contestType = "Cute"},
    topsyturvy = {
        num = 576,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Topsy-Turvy",
        pp = 20,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1},
        onHit = function(self, target)
            local success = false
            local i
            for ____value in pairs(target.boosts) do
                i = ____value
                do
                    if target.boosts[i] == 0 then
                        goto __continue1596
                    end
                    target.boosts[i] = -target.boosts[i]
                    success = true
                end
                ::__continue1596::
            end
            if not success then
                return false
            end
            self:add("-invertboost", target, "[from] move: Topsy-Turvy")
        end,
        secondary = nil,
        target = "normal",
        type = "Dark",
        zMove = {boost = {atk = 1}},
        contestType = "Clever"
    },
    torment = {
        num = 259,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Torment",
        pp = 15,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, authentic = 1},
        volatileStatus = "torment",
        condition = {
            noCopy = true,
            onStart = function(self, pokemon)
                if pokemon.volatiles.dynamax then
                    __TS__Delete(pokemon.volatiles, "torment")
                    return false
                end
                self:add("-start", pokemon, "Torment")
            end,
            onEnd = function(self, pokemon)
                self:add("-end", pokemon, "Torment")
            end,
            onDisableMove = function(self, pokemon)
                if pokemon.lastMove and (pokemon.lastMove.id ~= "struggle") then
                    pokemon:disableMove(pokemon.lastMove.id)
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Dark",
        zMove = {boost = {def = 1}},
        contestType = "Tough"
    },
    toxic = {num = 92, accuracy = 90, basePower = 0, category = "Status", name = "Toxic", pp = 10, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, status = "tox", secondary = nil, target = "normal", type = "Poison", zMove = {boost = {def = 1}}, contestType = "Clever"},
    toxicspikes = {
        num = 390,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Toxic Spikes",
        pp = 20,
        priority = 0,
        flags = {reflectable = 1, nonsky = 1},
        sideCondition = "toxicspikes",
        condition = {
            onSideStart = function(self, side)
                self:add("-sidestart", side, "move: Toxic Spikes")
                self.effectState.layers = 1
            end,
            onSideRestart = function(self, side)
                if self.effectState.layers >= 2 then
                    return false
                end
                self:add("-sidestart", side, "move: Toxic Spikes")
                local ____obj, ____index = self.effectState, "layers"
                ____obj[____index] = ____obj[____index] + 1
            end,
            onSwitchIn = function(self, pokemon)
                if not pokemon:isGrounded() then
                    return
                end
                if pokemon:hasType("Poison") then
                    self:add(
                        "-sideend",
                        pokemon.side,
                        "move: Toxic Spikes",
                        "[of] " .. tostring(pokemon)
                    )
                    pokemon.side:removeSideCondition("toxicspikes")
                elseif pokemon:hasType("Steel") or pokemon:hasItem("heavydutyboots") then
                    return
                elseif self.effectState.layers >= 2 then
                    pokemon:trySetStatus("tox", pokemon.side.foe.active[0])
                else
                    pokemon:trySetStatus("psn", pokemon.side.foe.active[0])
                end
            end
        },
        secondary = nil,
        target = "foeSide",
        type = "Poison",
        zMove = {boost = {def = 1}},
        contestType = "Clever"
    },
    toxicthread = {num = 672, accuracy = 100, basePower = 0, category = "Status", isNonstandard = "Past", name = "Toxic Thread", pp = 20, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, status = "psn", boosts = {spe = -1}, secondary = nil, target = "normal", type = "Poison", zMove = {boost = {spe = 1}}, contestType = "Tough"},
    transform = {
        num = 144,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Transform",
        pp = 10,
        priority = 0,
        flags = {mystery = 1},
        onHit = function(self, target, pokemon)
            if not pokemon:transformInto(target) then
                return false
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {effect = "heal"},
        contestType = "Clever"
    },
    triattack = {
        num = 161,
        accuracy = 100,
        basePower = 80,
        category = "Special",
        name = "Tri Attack",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        secondary = {
            chance = 20,
            onHit = function(self, target, source)
                local result = self:random(3)
                if result == 0 then
                    target:trySetStatus("brn", source)
                elseif result == 1 then
                    target:trySetStatus("par", source)
                else
                    target:trySetStatus("frz", source)
                end
            end
        },
        target = "normal",
        type = "Normal",
        contestType = "Beautiful"
    },
    trick = {
        num = 271,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Trick",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, mystery = 1},
        onTryImmunity = function(self, target)
            return not target:hasAbility("stickyhold")
        end,
        onHit = function(self, target, source, move)
            local yourItem = target:takeItem(source)
            local myItem = source:takeItem()
            if (target.item or source.item) or ((not yourItem) and (not myItem)) then
                if yourItem then
                    target.item = yourItem.id
                end
                if myItem then
                    source.item = myItem.id
                end
                return false
            end
            if (myItem and (not self:singleEvent("TakeItem", myItem, source.itemState, target, source, move, myItem))) or (yourItem and (not self:singleEvent("TakeItem", yourItem, target.itemState, source, target, move, yourItem))) then
                if yourItem then
                    target.item = yourItem.id
                end
                if myItem then
                    source.item = myItem.id
                end
                return false
            end
            self:add(
                "-activate",
                source,
                "move: Trick",
                "[of] " .. tostring(target)
            )
            if myItem then
                target:setItem(myItem)
                self:add("-item", target, myItem, "[from] move: Trick")
            else
                self:add("-enditem", target, yourItem, "[silent]", "[from] move: Trick")
            end
            if yourItem then
                source:setItem(yourItem)
                self:add("-item", source, yourItem, "[from] move: Trick")
            else
                self:add("-enditem", source, myItem, "[silent]", "[from] move: Trick")
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Psychic",
        zMove = {boost = {spe = 2}},
        contestType = "Clever"
    },
    trickortreat = {
        num = 567,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Trick-or-Treat",
        pp = 20,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1},
        onHit = function(self, target)
            if target:hasType("Ghost") then
                return false
            end
            if not target:addType("Ghost") then
                return false
            end
            self:add("-start", target, "typeadd", "Ghost", "[from] move: Trick-or-Treat")
            if (target.side.active.length == 2) and (target.position == 1) then
                local action = self.queue:willMove(target)
                if action and (action.move.id == "curse") then
                    action.targetLoc = -1
                end
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Ghost",
        zMove = {boost = {atk = 1, def = 1, spa = 1, spd = 1, spe = 1}},
        contestType = "Cute"
    },
    trickroom = {
        num = 433,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Trick Room",
        pp = 5,
        priority = -7,
        flags = {mirror = 1},
        pseudoWeather = "trickroom",
        condition = {
            duration = 5,
            durationCallback = function(self, source, effect)
                if source:hasAbility("persistent") then
                    self:add("-activate", source, "ability: Persistent", effect)
                    return 7
                end
                return 5
            end,
            onFieldStart = function(self, target, source)
                self:add(
                    "-fieldstart",
                    "move: Trick Room",
                    "[of] " .. tostring(source)
                )
            end,
            onFieldRestart = function(self, target, source)
                self.field:removePseudoWeather("trickroom")
            end,
            onFieldResidualOrder = 27,
            onFieldResidualSubOrder = 1,
            onFieldEnd = function(self)
                self:add("-fieldend", "move: Trick Room")
            end
        },
        secondary = nil,
        target = "all",
        type = "Psychic",
        zMove = {boost = {accuracy = 1}},
        contestType = "Clever"
    },
    tripleaxel = {
        num = 813,
        accuracy = 90,
        basePower = 20,
        basePowerCallback = function(self, pokemon, target, move)
            return 20 * move.hit
        end,
        category = "Physical",
        name = "Triple Axel",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        multihit = 3,
        multiaccuracy = true,
        secondary = nil,
        target = "normal",
        type = "Ice",
        zMove = {basePower = 120},
        maxMove = {basePower = 140}
    },
    triplekick = {
        num = 167,
        accuracy = 90,
        basePower = 10,
        basePowerCallback = function(self, pokemon, target, move)
            return 10 * move.hit
        end,
        category = "Physical",
        name = "Triple Kick",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        multihit = 3,
        multiaccuracy = true,
        secondary = nil,
        target = "normal",
        type = "Fighting",
        zMove = {basePower = 120},
        maxMove = {basePower = 80},
        contestType = "Cool"
    },
    tropkick = {num = 688, accuracy = 100, basePower = 70, category = "Physical", name = "Trop Kick", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 100, boosts = {atk = -1}}, target = "normal", type = "Grass", contestType = "Cute"},
    trumpcard = {
        num = 376,
        accuracy = true,
        basePower = 0,
        basePowerCallback = function(self, source, target, move)
            local callerMoveId = move.sourceEffect or move.id
            local moveSlot = (((callerMoveId == "instruct") and (function() return source:getMoveData(move.id) end)) or (function() return source:getMoveData(callerMoveId) end))()
            if not moveSlot then
                return 40
            end
            local ____switch1645 = moveSlot.pp
            if ____switch1645 == 0 then
                goto ____switch1645_case_0
            elseif ____switch1645 == 1 then
                goto ____switch1645_case_1
            elseif ____switch1645 == 2 then
                goto ____switch1645_case_2
            elseif ____switch1645 == 3 then
                goto ____switch1645_case_3
            end
            goto ____switch1645_case_default
            ::____switch1645_case_0::
            do
                return 200
            end
            ::____switch1645_case_1::
            do
                return 80
            end
            ::____switch1645_case_2::
            do
                return 60
            end
            ::____switch1645_case_3::
            do
                return 50
            end
            ::____switch1645_case_default::
            do
                return 40
            end
            ::____switch1645_end::
        end,
        category = "Special",
        isNonstandard = "Past",
        name = "Trump Card",
        pp = 5,
        noPPBoosts = true,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {basePower = 160},
        maxMove = {basePower = 130},
        contestType = "Cool"
    },
    twineedle = {num = 41, accuracy = 100, basePower = 25, category = "Physical", isNonstandard = "Past", name = "Twineedle", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, multihit = 2, secondary = {chance = 20, status = "psn"}, target = "normal", type = "Bug", maxMove = {basePower = 100}, contestType = "Cool"},
    twinkletackle = {num = 656, accuracy = true, basePower = 1, category = "Physical", isNonstandard = "Past", name = "Twinkle Tackle", pp = 1, priority = 0, flags = {}, isZ = "fairiumz", secondary = nil, target = "normal", type = "Fairy", contestType = "Cool"},
    twister = {num = 239, accuracy = 100, basePower = 40, category = "Special", name = "Twister", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, secondary = {chance = 20, volatileStatus = "flinch"}, target = "allAdjacentFoes", type = "Dragon", contestType = "Cool"},
    uturn = {num = 369, accuracy = 100, basePower = 70, category = "Physical", name = "U-turn", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, selfSwitch = true, secondary = nil, target = "normal", type = "Bug", contestType = "Cute"},
    uproar = {
        num = 253,
        accuracy = 100,
        basePower = 90,
        category = "Special",
        name = "Uproar",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, sound = 1, authentic = 1},
        self = {volatileStatus = "uproar"},
        onTryHit = function(self, target)
            local activeTeam = target.side:activeTeam()
            local foeActiveTeam = target.side.foe:activeTeam()
            for ____, ____value in __TS__Iterator(
                activeTeam:entries()
            ) do
                local i
                i = ____value[1]
                local allyActive
                allyActive = ____value[2]
                if allyActive and (allyActive.status == "slp") then
                    allyActive:cureStatus()
                end
                local foeActive = foeActiveTeam[i]
                if foeActive and (foeActive.status == "slp") then
                    foeActive:cureStatus()
                end
            end
        end,
        condition = {
            duration = 3,
            onStart = function(self, target)
                self:add("-start", target, "Uproar")
            end,
            onResidual = function(self, target)
                if target.volatiles.throatchop then
                    target:removeVolatile("uproar")
                    return
                end
                if target.lastMove and (target.lastMove.id == "struggle") then
                    __TS__Delete(target.volatiles, "uproar")
                end
                self:add("-start", target, "Uproar", "[upkeep]")
            end,
            onResidualOrder = 28,
            onResidualSubOrder = 1,
            onEnd = function(self, target)
                self:add("-end", target, "Uproar")
            end,
            onLockMove = "uproar",
            onAnySetStatus = function(self, status, pokemon)
                if status.id == "slp" then
                    if pokemon == self.effectState.target then
                        self:add("-fail", pokemon, "slp", "[from] Uproar", "[msg]")
                    else
                        self:add("-fail", pokemon, "slp", "[from] Uproar")
                    end
                    return nil
                end
            end
        },
        secondary = nil,
        target = "randomNormal",
        type = "Normal",
        contestType = "Cute"
    },
    vacuumwave = {num = 410, accuracy = 100, basePower = 40, category = "Special", name = "Vacuum Wave", pp = 30, priority = 1, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Fighting", contestType = "Cool"},
    vcreate = {num = 557, accuracy = 95, basePower = 180, category = "Physical", name = "V-create", pp = 5, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, self = {boosts = {spe = -1, def = -1, spd = -1}}, secondary = nil, target = "normal", type = "Fire", zMove = {basePower = 220}, contestType = "Cool"},
    veeveevolley = {
        num = 741,
        accuracy = true,
        basePower = 0,
        basePowerCallback = function(self, pokemon)
            return math.floor((pokemon.happiness * 10) / 25) or 1
        end,
        category = "Physical",
        isNonstandard = "LGPE",
        name = "Veevee Volley",
        pp = 20,
        priority = 0,
        flags = {contact = 1, protect = 1},
        secondary = nil,
        target = "normal",
        type = "Normal",
        contestType = "Cute"
    },
    venomdrench = {
        num = 599,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Venom Drench",
        pp = 20,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1},
        onHit = function(self, target, source, move)
            if (target.status == "psn") or (target.status == "tox") then
                return not (not self:boost({atk = -1, spa = -1, spe = -1}, target, source, move))
            end
            return false
        end,
        secondary = nil,
        target = "allAdjacentFoes",
        type = "Poison",
        zMove = {boost = {def = 1}},
        contestType = "Clever"
    },
    venoshock = {
        num = 474,
        accuracy = 100,
        basePower = 65,
        category = "Special",
        name = "Venoshock",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        onBasePower = function(self, basePower, pokemon, target)
            if (target.status == "psn") or (target.status == "tox") then
                return self:chainModify(2)
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Poison",
        contestType = "Beautiful"
    },
    vinewhip = {num = 22, accuracy = 100, basePower = 45, category = "Physical", name = "Vine Whip", pp = 25, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Grass", contestType = "Cool"},
    visegrip = {num = 11, accuracy = 100, basePower = 55, category = "Physical", name = "Vise Grip", pp = 30, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Normal", contestType = "Tough"},
    vitalthrow = {num = 233, accuracy = true, basePower = 70, category = "Physical", name = "Vital Throw", pp = 10, priority = -1, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Fighting", contestType = "Cool"},
    voltswitch = {num = 521, accuracy = 100, basePower = 70, category = "Special", name = "Volt Switch", pp = 20, priority = 0, flags = {protect = 1, mirror = 1}, selfSwitch = true, secondary = nil, target = "normal", type = "Electric", contestType = "Cool"},
    volttackle = {num = 344, accuracy = 100, basePower = 120, category = "Physical", name = "Volt Tackle", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, recoil = {33, 100}, secondary = {chance = 10, status = "par"}, target = "normal", type = "Electric", contestType = "Cool"},
    wakeupslap = {
        num = 358,
        accuracy = 100,
        basePower = 70,
        basePowerCallback = function(self, pokemon, target, move)
            if (target.status == "slp") or target:hasAbility("comatose") then
                return move.basePower * 2
            end
            return move.basePower
        end,
        category = "Physical",
        isNonstandard = "Past",
        name = "Wake-Up Slap",
        pp = 10,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        onHit = function(self, target)
            if target.status == "slp" then
                target:cureStatus()
            end
        end,
        secondary = nil,
        target = "normal",
        type = "Fighting",
        contestType = "Tough"
    },
    waterfall = {num = 127, accuracy = 100, basePower = 80, category = "Physical", name = "Waterfall", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 20, volatileStatus = "flinch"}, target = "normal", type = "Water", contestType = "Tough"},
    watergun = {num = 55, accuracy = 100, basePower = 40, category = "Special", name = "Water Gun", pp = 25, priority = 0, flags = {protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Water", contestType = "Cute"},
    waterpledge = {
        num = 518,
        accuracy = 100,
        basePower = 80,
        basePowerCallback = function(self, target, source, move)
            if ({"firepledge", "grasspledge"}):includes(move.sourceEffect) then
                self:add("-combine")
                return 150
            end
            return 80
        end,
        category = "Special",
        name = "Water Pledge",
        pp = 10,
        priority = 0,
        flags = {protect = 1, mirror = 1, nonsky = 1},
        onPrepareHit = function(self, target, source, move)
            for ____, action in __TS__Iterator(self.queue) do
                do
                    if action.choice ~= "move" then
                        goto __continue1671
                    end
                    local otherMove = action.move
                    local otherMoveUser = action.pokemon
                    if (((((not otherMove) or (not action.pokemon)) or (not otherMoveUser.isActive)) or otherMoveUser.fainted) or action.maxMove) or action.zmove then
                        goto __continue1671
                    end
                    if otherMoveUser:isAlly(source) and ({"firepledge", "grasspledge"}):includes(otherMove.id) then
                        self.queue:prioritizeAction(action, move)
                        self:add("-waiting", source, otherMoveUser)
                        return nil
                    end
                end
                ::__continue1671::
            end
        end,
        onModifyMove = function(self, move)
            if move.sourceEffect == "grasspledge" then
                move.type = "Grass"
                move.forceSTAB = true
                move.sideCondition = "grasspledge"
            end
            if move.sourceEffect == "firepledge" then
                move.type = "Water"
                move.forceSTAB = true
                move.self = {sideCondition = "waterpledge"}
            end
        end,
        condition = {
            duration = 4,
            onSideStart = function(self, targetSide)
                self:add("-sidestart", targetSide, "Water Pledge")
            end,
            onSideResidualOrder = 26,
            onSideResidualSubOrder = 7,
            onSideEnd = function(self, targetSide)
                self:add("-sideend", targetSide, "Water Pledge")
            end,
            onModifyMove = function(self, move, pokemon)
                if move.secondaries and (move.id ~= "secretpower") then
                    self:debug("doubling secondary chance")
                    for ____, secondary in __TS__Iterator(move.secondaries) do
                        do
                            if pokemon:hasAbility("serenegrace") and (secondary.volatileStatus == "flinch") then
                                goto __continue1682
                            end
                            if secondary.chance then
                                secondary.chance = secondary.chance * 2
                            end
                        end
                        ::__continue1682::
                    end
                    if move.self.chance then
                        local ____obj, ____index = move.self, "chance"
                        ____obj[____index] = ____obj[____index] * 2
                    end
                end
            end
        },
        secondary = nil,
        target = "normal",
        type = "Water",
        contestType = "Beautiful"
    },
    waterpulse = {num = 352, accuracy = 100, basePower = 60, category = "Special", name = "Water Pulse", pp = 20, priority = 0, flags = {protect = 1, pulse = 1, mirror = 1, distance = 1}, secondary = {chance = 20, volatileStatus = "confusion"}, target = "any", type = "Water", contestType = "Beautiful"},
    watershuriken = {
        num = 594,
        accuracy = 100,
        basePower = 15,
        basePowerCallback = function(self, pokemon, target, move)
            if (pokemon.species.name == "Greninja-Ash") and pokemon:hasAbility("battlebond") then
                return move.basePower + 5
            end
            return move.basePower
        end,
        category = "Special",
        name = "Water Shuriken",
        pp = 20,
        priority = 1,
        flags = {protect = 1, mirror = 1},
        multihit = {2, 5},
        secondary = nil,
        target = "normal",
        type = "Water",
        contestType = "Cool"
    },
    watersport = {
        num = 346,
        accuracy = true,
        basePower = 0,
        category = "Status",
        isNonstandard = "Past",
        name = "Water Sport",
        pp = 15,
        priority = 0,
        flags = {nonsky = 1},
        pseudoWeather = "watersport",
        condition = {
            duration = 5,
            onFieldStart = function(self, field, source)
                self:add(
                    "-fieldstart",
                    "move: Water Sport",
                    "[of] " .. tostring(source)
                )
            end,
            onBasePowerPriority = 1,
            onBasePower = function(self, basePower, attacker, defender, move)
                if move.type == "Fire" then
                    self:debug("water sport weaken")
                    return self:chainModify({1352, 4096})
                end
            end,
            onFieldResidualOrder = 27,
            onFieldResidualSubOrder = 3,
            onFieldEnd = function(self)
                self:add("-fieldend", "move: Water Sport")
            end
        },
        secondary = nil,
        target = "all",
        type = "Water",
        zMove = {boost = {spd = 1}},
        contestType = "Cute"
    },
    waterspout = {
        num = 323,
        accuracy = 100,
        basePower = 150,
        basePowerCallback = function(self, pokemon, target, move)
            return (move.basePower * pokemon.hp) / pokemon.maxhp
        end,
        category = "Special",
        name = "Water Spout",
        pp = 5,
        priority = 0,
        flags = {protect = 1, mirror = 1},
        secondary = nil,
        target = "allAdjacentFoes",
        type = "Water",
        contestType = "Beautiful"
    },
    weatherball = {
        num = 311,
        accuracy = 100,
        basePower = 50,
        category = "Special",
        name = "Weather Ball",
        pp = 10,
        priority = 0,
        flags = {bullet = 1, protect = 1, mirror = 1},
        onModifyType = function(self, move, pokemon)
            local ____switch1694 = pokemon:effectiveWeather()
            if ____switch1694 == "sunnyday" then
                goto ____switch1694_case_0
            elseif ____switch1694 == "desolateland" then
                goto ____switch1694_case_1
            elseif ____switch1694 == "raindance" then
                goto ____switch1694_case_2
            elseif ____switch1694 == "primordialsea" then
                goto ____switch1694_case_3
            elseif ____switch1694 == "sandstorm" then
                goto ____switch1694_case_4
            elseif ____switch1694 == "hail" then
                goto ____switch1694_case_5
            end
            goto ____switch1694_end
            ::____switch1694_case_0::
            do
            end
            ::____switch1694_case_1::
            do
                move.type = "Fire"
                goto ____switch1694_end
            end
            ::____switch1694_case_2::
            do
            end
            ::____switch1694_case_3::
            do
                move.type = "Water"
                goto ____switch1694_end
            end
            ::____switch1694_case_4::
            do
                move.type = "Rock"
                goto ____switch1694_end
            end
            ::____switch1694_case_5::
            do
                move.type = "Ice"
                goto ____switch1694_end
            end
            ::____switch1694_end::
        end,
        onModifyMove = function(self, move, pokemon)
            local ____switch1696 = pokemon:effectiveWeather()
            if ____switch1696 == "sunnyday" then
                goto ____switch1696_case_0
            elseif ____switch1696 == "desolateland" then
                goto ____switch1696_case_1
            elseif ____switch1696 == "raindance" then
                goto ____switch1696_case_2
            elseif ____switch1696 == "primordialsea" then
                goto ____switch1696_case_3
            elseif ____switch1696 == "sandstorm" then
                goto ____switch1696_case_4
            elseif ____switch1696 == "hail" then
                goto ____switch1696_case_5
            end
            goto ____switch1696_end
            ::____switch1696_case_0::
            do
            end
            ::____switch1696_case_1::
            do
                move.basePower = move.basePower * 2
                goto ____switch1696_end
            end
            ::____switch1696_case_2::
            do
            end
            ::____switch1696_case_3::
            do
                move.basePower = move.basePower * 2
                goto ____switch1696_end
            end
            ::____switch1696_case_4::
            do
                move.basePower = move.basePower * 2
                goto ____switch1696_end
            end
            ::____switch1696_case_5::
            do
                move.basePower = move.basePower * 2
                goto ____switch1696_end
            end
            ::____switch1696_end::
        end,
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {basePower = 160},
        maxMove = {basePower = 130},
        contestType = "Beautiful"
    },
    whirlpool = {num = 250, accuracy = 85, basePower = 35, category = "Special", name = "Whirlpool", pp = 15, priority = 0, flags = {protect = 1, mirror = 1}, volatileStatus = "partiallytrapped", secondary = nil, target = "normal", type = "Water", contestType = "Beautiful"},
    whirlwind = {num = 18, accuracy = true, basePower = 0, category = "Status", name = "Whirlwind", pp = 20, priority = -6, flags = {reflectable = 1, mirror = 1, authentic = 1, mystery = 1}, forceSwitch = true, secondary = nil, target = "normal", type = "Normal", zMove = {boost = {spd = 1}}, contestType = "Clever"},
    wickedblow = {num = 817, accuracy = 100, basePower = 80, category = "Physical", name = "Wicked Blow", pp = 5, priority = 0, flags = {contact = 1, protect = 1, punch = 1, mirror = 1}, willCrit = true, secondary = nil, target = "normal", type = "Dark"},
    wideguard = {
        num = 469,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Wide Guard",
        pp = 10,
        priority = 3,
        flags = {snatch = 1},
        sideCondition = "wideguard",
        onTry = function(self)
            return not (not self.queue:willAct())
        end,
        onHitSide = function(self, side, source)
            source:addVolatile("stall")
        end,
        condition = {
            duration = 1,
            onSideStart = function(self, target, source)
                self:add("-singleturn", source, "Wide Guard")
            end,
            onTryHitPriority = 4,
            onTryHit = function(self, target, source, move)
                if (move.target ~= "allAdjacent") and (move.target ~= "allAdjacentFoes") then
                    return
                end
                if move.isZ or move.isMax then
                    if ({"gmaxoneblow", "gmaxrapidflow"}):includes(move.id) then
                        return
                    end
                    target:getMoveHitData(move).zBrokeProtect = true
                    return
                end
                self:add("-activate", target, "move: Wide Guard")
                local lockedmove = source:getVolatile("lockedmove")
                if lockedmove then
                    if source.volatiles.lockedmove.duration == 2 then
                        __TS__Delete(source.volatiles, "lockedmove")
                    end
                end
                return self.NOT_FAIL
            end
        },
        secondary = nil,
        target = "allySide",
        type = "Rock",
        zMove = {boost = {def = 1}},
        contestType = "Tough"
    },
    wildcharge = {num = 528, accuracy = 100, basePower = 90, category = "Physical", name = "Wild Charge", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, recoil = {1, 4}, secondary = nil, target = "normal", type = "Electric", contestType = "Tough"},
    willowisp = {num = 261, accuracy = 85, basePower = 0, category = "Status", name = "Will-O-Wisp", pp = 15, priority = 0, flags = {protect = 1, reflectable = 1, mirror = 1}, status = "brn", secondary = nil, target = "normal", type = "Fire", zMove = {boost = {atk = 1}}, contestType = "Beautiful"},
    wingattack = {num = 17, accuracy = 100, basePower = 60, category = "Physical", name = "Wing Attack", pp = 35, priority = 0, flags = {contact = 1, protect = 1, mirror = 1, distance = 1}, secondary = nil, target = "any", type = "Flying", contestType = "Cool"},
    wish = {
        num = 273,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Wish",
        pp = 10,
        priority = 0,
        flags = {snatch = 1, heal = 1},
        slotCondition = "Wish",
        condition = {
            duration = 2,
            onStart = function(self, pokemon, source)
                self.effectState.hp = source.maxhp / 2
            end,
            onResidualOrder = 4,
            onEnd = function(self, target)
                if target and (not target.fainted) then
                    local damage = self:heal(self.effectState.hp, target, target)
                    if damage then
                        self:add(
                            "-heal",
                            target,
                            target.getHealth,
                            "[from] move: Wish",
                            "[wisher] " .. tostring(self.effectState.source.name)
                        )
                    end
                end
            end
        },
        secondary = nil,
        target = "self",
        type = "Normal",
        zMove = {boost = {spd = 1}},
        contestType = "Cute"
    },
    withdraw = {num = 110, accuracy = true, basePower = 0, category = "Status", name = "Withdraw", pp = 40, priority = 0, flags = {snatch = 1}, boosts = {def = 1}, secondary = nil, target = "self", type = "Water", zMove = {boost = {def = 1}}, contestType = "Cute"},
    wonderroom = {
        num = 472,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Wonder Room",
        pp = 10,
        priority = 0,
        flags = {mirror = 1},
        pseudoWeather = "wonderroom",
        condition = {
            duration = 5,
            durationCallback = function(self, source, effect)
                if source:hasAbility("persistent") then
                    self:add("-activate", source, "ability: Persistent", effect)
                    return 7
                end
                return 5
            end,
            onFieldStart = function(self, field, source)
                self:add(
                    "-fieldstart",
                    "move: Wonder Room",
                    "[of] " .. tostring(source)
                )
            end,
            onFieldRestart = function(self, target, source)
                self.field:removePseudoWeather("wonderroom")
            end,
            onFieldResidualOrder = 27,
            onFieldResidualSubOrder = 5,
            onFieldEnd = function(self)
                self:add("-fieldend", "move: Wonder Room")
            end
        },
        secondary = nil,
        target = "all",
        type = "Psychic",
        zMove = {boost = {spd = 1}},
        contestType = "Clever"
    },
    woodhammer = {num = 452, accuracy = 100, basePower = 120, category = "Physical", name = "Wood Hammer", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, recoil = {33, 100}, secondary = nil, target = "normal", type = "Grass", contestType = "Tough"},
    workup = {num = 526, accuracy = true, basePower = 0, category = "Status", name = "Work Up", pp = 30, priority = 0, flags = {snatch = 1}, boosts = {atk = 1, spa = 1}, secondary = nil, target = "self", type = "Normal", zMove = {boost = {atk = 1}}, contestType = "Tough"},
    worryseed = {
        num = 388,
        accuracy = 100,
        basePower = 0,
        category = "Status",
        name = "Worry Seed",
        pp = 10,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1, mystery = 1},
        onTryImmunity = function(self, target)
            if (target.ability == "truant") or (target.ability == "insomnia") then
                return false
            end
        end,
        onTryHit = function(self, target)
            if target:getAbility().isPermanent then
                return false
            end
        end,
        onHit = function(self, pokemon)
            local oldAbility = pokemon:setAbility("insomnia")
            if oldAbility then
                self:add("-ability", pokemon, "Insomnia", "[from] move: Worry Seed")
                if pokemon.status == "slp" then
                    pokemon:cureStatus()
                end
                return
            end
            return false
        end,
        secondary = nil,
        target = "normal",
        type = "Grass",
        zMove = {boost = {spe = 1}},
        contestType = "Clever"
    },
    wrap = {num = 35, accuracy = 90, basePower = 15, category = "Physical", name = "Wrap", pp = 20, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, volatileStatus = "partiallytrapped", secondary = nil, target = "normal", type = "Normal", contestType = "Tough"},
    wringout = {
        num = 378,
        accuracy = 100,
        basePower = 0,
        basePowerCallback = function(self, pokemon, target)
            return math.floor(
                math.floor(
                    (((120 * (100 * math.floor((target.hp * 4096) / target.maxhp))) + 2048) - 1) / 4096
                ) / 100
            ) or 1
        end,
        category = "Special",
        isNonstandard = "Past",
        name = "Wring Out",
        pp = 5,
        priority = 0,
        flags = {contact = 1, protect = 1, mirror = 1},
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {basePower = 190},
        maxMove = {basePower = 140},
        contestType = "Tough"
    },
    xscissor = {num = 404, accuracy = 100, basePower = 80, category = "Physical", name = "X-Scissor", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = nil, target = "normal", type = "Bug", contestType = "Cool"},
    yawn = {
        num = 281,
        accuracy = true,
        basePower = 0,
        category = "Status",
        name = "Yawn",
        pp = 10,
        priority = 0,
        flags = {protect = 1, reflectable = 1, mirror = 1},
        volatileStatus = "yawn",
        onTryHit = function(self, target)
            if target.status or (not target:runStatusImmunity("slp")) then
                return false
            end
        end,
        condition = {
            noCopy = true,
            duration = 2,
            onStart = function(self, target, source)
                self:add(
                    "-start",
                    target,
                    "move: Yawn",
                    "[of] " .. tostring(source)
                )
            end,
            onResidualOrder = 23,
            onEnd = function(self, target)
                self:add("-end", target, "move: Yawn", "[silent]")
                target:trySetStatus("slp", self.effectState.source)
            end
        },
        secondary = nil,
        target = "normal",
        type = "Normal",
        zMove = {boost = {spe = 1}},
        contestType = "Cute"
    },
    zapcannon = {num = 192, accuracy = 50, basePower = 120, category = "Special", name = "Zap Cannon", pp = 5, priority = 0, flags = {bullet = 1, protect = 1, mirror = 1}, secondary = {chance = 100, status = "par"}, target = "normal", type = "Electric", contestType = "Cool"},
    zenheadbutt = {num = 428, accuracy = 90, basePower = 80, category = "Physical", name = "Zen Headbutt", pp = 15, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 20, volatileStatus = "flinch"}, target = "normal", type = "Psychic", contestType = "Clever"},
    zingzap = {num = 716, accuracy = 100, basePower = 80, category = "Physical", name = "Zing Zap", pp = 10, priority = 0, flags = {contact = 1, protect = 1, mirror = 1}, secondary = {chance = 30, volatileStatus = "flinch"}, target = "normal", type = "Electric", contestType = "Cool"},
    zippyzap = {num = 729, accuracy = 100, basePower = 80, category = "Physical", isNonstandard = "LGPE", name = "Zippy Zap", pp = 10, priority = 2, flags = {contact = 1, protect = 1}, secondary = {chance = 100, self = {boosts = {evasion = 1}}}, target = "normal", type = "Electric", contestType = "Cool"}
}

return ____exports
