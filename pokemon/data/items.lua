--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");

local ____exports = {}

____exports.Items = {
    abomasite = {
        name = "Abomasite",
        spritenum = 575,
        megaStone = "Abomasnow-Mega",
        megaEvolves = "Abomasnow",
        itemUser = {"Abomasnow"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 674,
        gen = 6,
        isNonstandard = "Past"
    },
    absolite = {
        name = "Absolite",
        spritenum = 576,
        megaStone = "Absol-Mega",
        megaEvolves = "Absol",
        itemUser = {"Absol"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 677,
        gen = 6,
        isNonstandard = "Past"
    },
    absorbbulb = {
        name = "Absorb Bulb",
        spritenum = 2,
        fling = {basePower = 30},
        onDamagingHit = function(self, damage, target, source, move)
            if move.type == "Water" then
                target:useItem()
            end
        end,
        boosts = {spa = 1},
        num = 545,
        gen = 5
    },
    adamantorb = {
        name = "Adamant Orb",
        spritenum = 4,
        fling = {basePower = 60},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if (move and (user.baseSpecies.name == "Dialga")) and ((move.type == "Steel") or (move.type == "Dragon")) then
                return self:chainModify({4915, 4096})
            end
        end,
        itemUser = {"Dialga"},
        num = 135,
        gen = 4
    },
    adrenalineorb = {
        name = "Adrenaline Orb",
        spritenum = 660,
        fling = {basePower = 30},
        onBoostPriority = 1,
        onBoost = function(self, boost, target)
            target.itemState.lastAtk = target.boosts.atk
        end,
        onAfterBoost = function(self, boost, target, source, effect)
            local noAtkChange = ((boost.atk < 0) and (target.boosts.atk == -6)) and (target.itemState.lastAtk == -6)
            local noContraryAtkChange = ((boost.atk > 0) and (target.boosts.atk == 6)) and (target.itemState.lastAtk == 6)
            if ((target.boosts.spe == 6) or noAtkChange) or noContraryAtkChange then
                return
            end
            if effect.id == "intimidate" then
                target:useItem()
            end
        end,
        boosts = {spe = 1},
        num = 846,
        gen = 7
    },
    aerodactylite = {
        name = "Aerodactylite",
        spritenum = 577,
        megaStone = "Aerodactyl-Mega",
        megaEvolves = "Aerodactyl",
        itemUser = {"Aerodactyl"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 672,
        gen = 6,
        isNonstandard = "Past"
    },
    aggronite = {
        name = "Aggronite",
        spritenum = 578,
        megaStone = "Aggron-Mega",
        megaEvolves = "Aggron",
        itemUser = {"Aggron"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 667,
        gen = 6,
        isNonstandard = "Past"
    },
    aguavberry = {
        name = "Aguav Berry",
        spritenum = 5,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Dragon"},
        onUpdate = function(self, pokemon)
            if (pokemon.hp <= (pokemon.maxhp / 4)) or ((pokemon.hp <= (pokemon.maxhp / 2)) and pokemon:hasAbility("gluttony")) then
                pokemon:eatItem()
            end
        end,
        onTryEatItem = function(self, item, pokemon)
            if not self:runEvent("TryHeal", pokemon) then
                return false
            end
        end,
        onEat = function(self, pokemon)
            self:heal(pokemon.baseMaxhp * 0.33)
            if pokemon:getNature().minus == "spd" then
                pokemon:addVolatile("confusion")
            end
        end,
        num = 162,
        gen = 3
    },
    airballoon = {
        name = "Air Balloon",
        spritenum = 6,
        fling = {basePower = 10},
        onStart = function(self, target)
            if (not target:ignoringItem()) and (not self.field:getPseudoWeather("gravity")) then
                self:add("-item", target, "Air Balloon")
            end
        end,
        onDamagingHit = function(self, damage, target, source, move)
            self:add("-enditem", target, "Air Balloon")
            target.item = ""
            target.itemState = {id = "", target = target}
            self:runEvent(
                "AfterUseItem",
                target,
                nil,
                nil,
                self.dex.items:get("airballoon")
            )
        end,
        onAfterSubDamage = function(self, damage, target, source, effect)
            self:debug(
                "effect: " .. tostring(effect.id)
            )
            if effect.effectType == "Move" then
                self:add("-enditem", target, "Air Balloon")
                target.item = ""
                target.itemState = {id = "", target = target}
                self:runEvent(
                    "AfterUseItem",
                    target,
                    nil,
                    nil,
                    self.dex.items:get("airballoon")
                )
            end
        end,
        num = 541,
        gen = 5
    },
    alakazite = {
        name = "Alakazite",
        spritenum = 579,
        megaStone = "Alakazam-Mega",
        megaEvolves = "Alakazam",
        itemUser = {"Alakazam"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 679,
        gen = 6,
        isNonstandard = "Past"
    },
    aloraichiumz = {name = "Aloraichium Z", spritenum = 655, onTakeItem = false, zMove = "Stoked Sparksurfer", zMoveFrom = "Thunderbolt", itemUser = {"Raichu-Alola"}, num = 803, gen = 7, isNonstandard = "Past"},
    altarianite = {
        name = "Altarianite",
        spritenum = 615,
        megaStone = "Altaria-Mega",
        megaEvolves = "Altaria",
        itemUser = {"Altaria"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 755,
        gen = 6,
        isNonstandard = "Past"
    },
    ampharosite = {
        name = "Ampharosite",
        spritenum = 580,
        megaStone = "Ampharos-Mega",
        megaEvolves = "Ampharos",
        itemUser = {"Ampharos"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 658,
        gen = 6,
        isNonstandard = "Past"
    },
    apicotberry = {
        name = "Apicot Berry",
        spritenum = 10,
        isBerry = true,
        naturalGift = {basePower = 100, type = "Ground"},
        onUpdate = function(self, pokemon)
            if (pokemon.hp <= (pokemon.maxhp / 4)) or ((pokemon.hp <= (pokemon.maxhp / 2)) and pokemon:hasAbility("gluttony")) then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            self:boost({spd = 1})
        end,
        num = 205,
        gen = 3
    },
    armorfossil = {name = "Armor Fossil", spritenum = 12, fling = {basePower = 100}, num = 104, gen = 4, isNonstandard = "Past"},
    aspearberry = {
        name = "Aspear Berry",
        spritenum = 13,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Ice"},
        onUpdate = function(self, pokemon)
            if pokemon.status == "frz" then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            if pokemon.status == "frz" then
                pokemon:cureStatus()
            end
        end,
        num = 153,
        gen = 3
    },
    assaultvest = {
        name = "Assault Vest",
        spritenum = 581,
        fling = {basePower = 80},
        onModifySpDPriority = 1,
        onModifySpD = function(self, spd)
            return self:chainModify(1.5)
        end,
        onDisableMove = function(self, pokemon)
            for ____, moveSlot in __TS__Iterator(pokemon.moveSlots) do
                if self.dex.moves:get(moveSlot.move).category == "Status" then
                    pokemon:disableMove(moveSlot.id)
                end
            end
        end,
        num = 640,
        gen = 6
    },
    audinite = {
        name = "Audinite",
        spritenum = 617,
        megaStone = "Audino-Mega",
        megaEvolves = "Audino",
        itemUser = {"Audino"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 757,
        gen = 6,
        isNonstandard = "Past"
    },
    babiriberry = {
        name = "Babiri Berry",
        spritenum = 17,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Steel"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Steel") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 199,
        gen = 4
    },
    banettite = {
        name = "Banettite",
        spritenum = 582,
        megaStone = "Banette-Mega",
        megaEvolves = "Banette",
        itemUser = {"Banette"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 668,
        gen = 6,
        isNonstandard = "Past"
    },
    beastball = {name = "Beast Ball", spritenum = 661, num = 851, gen = 7, isPokeball = true},
    beedrillite = {
        name = "Beedrillite",
        spritenum = 628,
        megaStone = "Beedrill-Mega",
        megaEvolves = "Beedrill",
        itemUser = {"Beedrill"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 770,
        gen = 6,
        isNonstandard = "Past"
    },
    belueberry = {name = "Belue Berry", spritenum = 21, isBerry = true, naturalGift = {basePower = 100, type = "Electric"}, onEat = false, num = 183, gen = 3, isNonstandard = "Past"},
    berryjuice = {
        name = "Berry Juice",
        spritenum = 22,
        fling = {basePower = 30},
        onUpdate = function(self, pokemon)
            if pokemon.hp <= (pokemon.maxhp / 2) then
                if self:runEvent("TryHeal", pokemon) and pokemon:useItem() then
                    self:heal(20)
                end
            end
        end,
        num = 43,
        gen = 2
    },
    berrysweet = {name = "Berry Sweet", spritenum = 706, fling = {basePower = 10}, num = 1111, gen = 8},
    bigroot = {
        name = "Big Root",
        spritenum = 29,
        fling = {basePower = 10},
        onTryHealPriority = 1,
        onTryHeal = function(self, damage, target, source, effect)
            local heals = {"drain", "leechseed", "ingrain", "aquaring", "strengthsap"}
            if heals:includes(effect.id) then
                return self:chainModify({5324, 4096})
            end
        end,
        num = 296,
        gen = 4
    },
    bindingband = {name = "Binding Band", spritenum = 31, fling = {basePower = 30}, num = 544, gen = 5},
    blackbelt = {
        name = "Black Belt",
        spritenum = 32,
        fling = {basePower = 30},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move and (move.type == "Fighting") then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 241,
        gen = 2
    },
    blacksludge = {
        name = "Black Sludge",
        spritenum = 34,
        fling = {basePower = 30},
        onResidualOrder = 5,
        onResidualSubOrder = 4,
        onResidual = function(self, pokemon)
            if pokemon:hasType("Poison") then
                self:heal(pokemon.baseMaxhp / 16)
            else
                self:damage(pokemon.baseMaxhp / 8)
            end
        end,
        num = 281,
        gen = 4
    },
    blackglasses = {
        name = "Black Glasses",
        spritenum = 35,
        fling = {basePower = 30},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move and (move.type == "Dark") then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 240,
        gen = 2
    },
    blastoisinite = {
        name = "Blastoisinite",
        spritenum = 583,
        megaStone = "Blastoise-Mega",
        megaEvolves = "Blastoise",
        itemUser = {"Blastoise"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 661,
        gen = 6,
        isNonstandard = "Past"
    },
    blazikenite = {
        name = "Blazikenite",
        spritenum = 584,
        megaStone = "Blaziken-Mega",
        megaEvolves = "Blaziken",
        itemUser = {"Blaziken"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 664,
        gen = 6,
        isNonstandard = "Past"
    },
    blueorb = {
        name = "Blue Orb",
        spritenum = 41,
        onSwitchIn = function(self, pokemon)
            if pokemon.isActive and (pokemon.baseSpecies.name == "Kyogre") then
                self.queue:insertChoice({choice = "runPrimal", pokemon = pokemon})
            end
        end,
        onPrimal = function(self, pokemon)
            pokemon:formeChange("Kyogre-Primal", self.effect, true)
        end,
        onTakeItem = function(self, item, source)
            if source.baseSpecies.baseSpecies == "Kyogre" then
                return false
            end
            return true
        end,
        itemUser = {"Kyogre"},
        num = 535,
        gen = 6,
        isNonstandard = "Past"
    },
    blukberry = {name = "Bluk Berry", spritenum = 44, isBerry = true, naturalGift = {basePower = 90, type = "Fire"}, onEat = false, num = 165, gen = 3},
    blunderpolicy = {name = "Blunder Policy", spritenum = 716, fling = {basePower = 80}, num = 1121, gen = 8},
    bottlecap = {name = "Bottle Cap", spritenum = 696, fling = {basePower = 30}, num = 795, gen = 7},
    brightpowder = {
        name = "Bright Powder",
        spritenum = 51,
        fling = {basePower = 10},
        onModifyAccuracyPriority = -2,
        onModifyAccuracy = function(self, accuracy)
            if type(accuracy) ~= "number" then
                return
            end
            self:debug("brightpowder - decreasing accuracy")
            return self:chainModify({3686, 4096})
        end,
        num = 213,
        gen = 2
    },
    buggem = {
        name = "Bug Gem",
        spritenum = 53,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            if (target == source) or (move.category == "Status") then
                return
            end
            if (move.type == "Bug") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 558,
        gen = 5,
        isNonstandard = "Past"
    },
    bugmemory = {
        name = "Bug Memory",
        spritenum = 673,
        onMemory = "Bug",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Bug",
        itemUser = {"Silvally-Bug"},
        num = 909,
        gen = 7
    },
    buginiumz = {name = "Buginium Z", spritenum = 642, onPlate = "Bug", onTakeItem = false, zMove = true, zMoveType = "Bug", forcedForme = "Arceus-Bug", num = 787, gen = 7, isNonstandard = "Past"},
    burndrive = {
        name = "Burn Drive",
        spritenum = 54,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 649)) or (pokemon.baseSpecies.num == 649) then
                return false
            end
            return true
        end,
        onDrive = "Fire",
        forcedForme = "Genesect-Burn",
        itemUser = {"Genesect-Burn"},
        num = 118,
        gen = 5
    },
    cameruptite = {
        name = "Cameruptite",
        spritenum = 625,
        megaStone = "Camerupt-Mega",
        megaEvolves = "Camerupt",
        itemUser = {"Camerupt"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 767,
        gen = 6,
        isNonstandard = "Past"
    },
    cellbattery = {
        name = "Cell Battery",
        spritenum = 60,
        fling = {basePower = 30},
        onDamagingHit = function(self, damage, target, source, move)
            if move.type == "Electric" then
                target:useItem()
            end
        end,
        boosts = {atk = 1},
        num = 546,
        gen = 5
    },
    charcoal = {
        name = "Charcoal",
        spritenum = 61,
        fling = {basePower = 30},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move and (move.type == "Fire") then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 249,
        gen = 2
    },
    charizarditex = {
        name = "Charizardite X",
        spritenum = 585,
        megaStone = "Charizard-Mega-X",
        megaEvolves = "Charizard",
        itemUser = {"Charizard"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 660,
        gen = 6,
        isNonstandard = "Past"
    },
    charizarditey = {
        name = "Charizardite Y",
        spritenum = 586,
        megaStone = "Charizard-Mega-Y",
        megaEvolves = "Charizard",
        itemUser = {"Charizard"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 678,
        gen = 6,
        isNonstandard = "Past"
    },
    chartiberry = {
        name = "Charti Berry",
        spritenum = 62,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Rock"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Rock") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 195,
        gen = 4
    },
    cheriberry = {
        name = "Cheri Berry",
        spritenum = 63,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Fire"},
        onUpdate = function(self, pokemon)
            if pokemon.status == "par" then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            if pokemon.status == "par" then
                pokemon:cureStatus()
            end
        end,
        num = 149,
        gen = 3
    },
    cherishball = {name = "Cherish Ball", spritenum = 64, num = 16, gen = 4, isPokeball = true},
    chestoberry = {
        name = "Chesto Berry",
        spritenum = 65,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Water"},
        onUpdate = function(self, pokemon)
            if pokemon.status == "slp" then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            if pokemon.status == "slp" then
                pokemon:cureStatus()
            end
        end,
        num = 150,
        gen = 3
    },
    chilanberry = {
        name = "Chilan Berry",
        spritenum = 66,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Normal"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Normal") and (((not target.volatiles.substitute) or move.flags.authentic) or (move.infiltrates and (self.gen >= 6))) then
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 200,
        gen = 4
    },
    chilldrive = {
        name = "Chill Drive",
        spritenum = 67,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 649)) or (pokemon.baseSpecies.num == 649) then
                return false
            end
            return true
        end,
        onDrive = "Ice",
        forcedForme = "Genesect-Chill",
        itemUser = {"Genesect-Chill"},
        num = 119,
        gen = 5
    },
    chippedpot = {name = "Chipped Pot", spritenum = 720, fling = {basePower = 80}, num = 1254, gen = 8},
    choiceband = {
        name = "Choice Band",
        spritenum = 68,
        fling = {basePower = 10},
        onStart = function(self, pokemon)
            if pokemon.volatiles.choicelock then
                self:debug(
                    "removing choicelock: " .. tostring(pokemon.volatiles.choicelock)
                )
            end
            pokemon:removeVolatile("choicelock")
        end,
        onModifyMove = function(self, move, pokemon)
            pokemon:addVolatile("choicelock")
        end,
        onModifyAtkPriority = 1,
        onModifyAtk = function(self, atk, pokemon)
            if pokemon.volatiles.dynamax then
                return
            end
            return self:chainModify(1.5)
        end,
        isChoice = true,
        num = 220,
        gen = 3
    },
    choicescarf = {
        name = "Choice Scarf",
        spritenum = 69,
        fling = {basePower = 10},
        onStart = function(self, pokemon)
            if pokemon.volatiles.choicelock then
                self:debug(
                    "removing choicelock: " .. tostring(pokemon.volatiles.choicelock)
                )
            end
            pokemon:removeVolatile("choicelock")
        end,
        onModifyMove = function(self, move, pokemon)
            pokemon:addVolatile("choicelock")
        end,
        onModifySpe = function(self, spe, pokemon)
            if pokemon.volatiles.dynamax then
                return
            end
            return self:chainModify(1.5)
        end,
        isChoice = true,
        num = 287,
        gen = 4
    },
    choicespecs = {
        name = "Choice Specs",
        spritenum = 70,
        fling = {basePower = 10},
        onStart = function(self, pokemon)
            if pokemon.volatiles.choicelock then
                self:debug(
                    "removing choicelock: " .. tostring(pokemon.volatiles.choicelock)
                )
            end
            pokemon:removeVolatile("choicelock")
        end,
        onModifyMove = function(self, move, pokemon)
            pokemon:addVolatile("choicelock")
        end,
        onModifySpAPriority = 1,
        onModifySpA = function(self, spa, pokemon)
            if pokemon.volatiles.dynamax then
                return
            end
            return self:chainModify(1.5)
        end,
        isChoice = true,
        num = 297,
        gen = 4
    },
    chopleberry = {
        name = "Chople Berry",
        spritenum = 71,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Fighting"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Fighting") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 189,
        gen = 4
    },
    clawfossil = {name = "Claw Fossil", spritenum = 72, fling = {basePower = 100}, num = 100, gen = 3, isNonstandard = "Past"},
    cloversweet = {name = "Clover Sweet", spritenum = 707, fling = {basePower = 10}, num = 1112, gen = 8},
    cobaberry = {
        name = "Coba Berry",
        spritenum = 76,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Flying"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Flying") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 192,
        gen = 4
    },
    colburberry = {
        name = "Colbur Berry",
        spritenum = 78,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Dark"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Dark") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 198,
        gen = 4
    },
    cornnberry = {name = "Cornn Berry", spritenum = 81, isBerry = true, naturalGift = {basePower = 90, type = "Bug"}, onEat = false, num = 175, gen = 3, isNonstandard = "Past"},
    coverfossil = {name = "Cover Fossil", spritenum = 85, fling = {basePower = 100}, num = 572, gen = 5, isNonstandard = "Past"},
    crackedpot = {name = "Cracked Pot", spritenum = 719, fling = {basePower = 80}, num = 1253, gen = 8},
    custapberry = {
        name = "Custap Berry",
        spritenum = 86,
        isBerry = true,
        naturalGift = {basePower = 100, type = "Ghost"},
        onFractionalPriorityPriority = -2,
        onFractionalPriority = function(self, priority, pokemon)
            if (priority <= 0) and ((pokemon.hp <= (pokemon.maxhp / 4)) or ((pokemon.hp <= (pokemon.maxhp / 2)) and pokemon:hasAbility("gluttony"))) then
                if pokemon:eatItem() then
                    self:add("-activate", pokemon, "item: Custap Berry", "[consumed]")
                    return 0.1
                end
            end
        end,
        onEat = function(self)
        end,
        num = 210,
        gen = 4
    },
    damprock = {name = "Damp Rock", spritenum = 88, fling = {basePower = 60}, num = 285, gen = 4},
    darkgem = {
        name = "Dark Gem",
        spritenum = 89,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            if (target == source) or (move.category == "Status") then
                return
            end
            if (move.type == "Dark") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 562,
        gen = 5,
        isNonstandard = "Past"
    },
    darkmemory = {
        name = "Dark Memory",
        spritenum = 683,
        onMemory = "Dark",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Dark",
        itemUser = {"Silvally-Dark"},
        num = 919,
        gen = 7
    },
    darkiniumz = {name = "Darkinium Z", spritenum = 646, onPlate = "Dark", onTakeItem = false, zMove = true, zMoveType = "Dark", forcedForme = "Arceus-Dark", num = 791, gen = 7, isNonstandard = "Past"},
    dawnstone = {name = "Dawn Stone", spritenum = 92, fling = {basePower = 80}, num = 109, gen = 4},
    decidiumz = {name = "Decidium Z", spritenum = 650, onTakeItem = false, zMove = "Sinister Arrow Raid", zMoveFrom = "Spirit Shackle", itemUser = {"Decidueye"}, num = 798, gen = 7, isNonstandard = "Past"},
    deepseascale = {
        name = "Deep Sea Scale",
        spritenum = 93,
        fling = {basePower = 30},
        onModifySpDPriority = 2,
        onModifySpD = function(self, spd, pokemon)
            if pokemon.baseSpecies.name == "Clamperl" then
                return self:chainModify(2)
            end
        end,
        itemUser = {"Clamperl"},
        num = 227,
        gen = 3
    },
    deepseatooth = {
        name = "Deep Sea Tooth",
        spritenum = 94,
        fling = {basePower = 90},
        onModifySpAPriority = 1,
        onModifySpA = function(self, spa, pokemon)
            if pokemon.baseSpecies.name == "Clamperl" then
                return self:chainModify(2)
            end
        end,
        itemUser = {"Clamperl"},
        num = 226,
        gen = 3
    },
    destinyknot = {
        name = "Destiny Knot",
        spritenum = 95,
        fling = {basePower = 10},
        onAttractPriority = -100,
        onAttract = function(self, target, source)
            self:debug(
                (("attract intercepted: " .. tostring(target)) .. " from ") .. tostring(source)
            )
            if (not source) or (source == target) then
                return
            end
            if not source.volatiles.attract then
                source:addVolatile("attract", target)
            end
        end,
        num = 280,
        gen = 4
    },
    diancite = {
        name = "Diancite",
        spritenum = 624,
        megaStone = "Diancie-Mega",
        megaEvolves = "Diancie",
        itemUser = {"Diancie"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 764,
        gen = 6,
        isNonstandard = "Past"
    },
    diveball = {name = "Dive Ball", spritenum = 101, num = 7, gen = 3, isPokeball = true},
    domefossil = {name = "Dome Fossil", spritenum = 102, fling = {basePower = 100}, num = 102, gen = 3, isNonstandard = "Past"},
    dousedrive = {
        name = "Douse Drive",
        spritenum = 103,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 649)) or (pokemon.baseSpecies.num == 649) then
                return false
            end
            return true
        end,
        onDrive = "Water",
        forcedForme = "Genesect-Douse",
        itemUser = {"Genesect-Douse"},
        num = 116,
        gen = 5
    },
    dracoplate = {
        name = "Draco Plate",
        spritenum = 105,
        onPlate = "Dragon",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move and (move.type == "Dragon") then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Dragon",
        num = 311,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    dragonfang = {
        name = "Dragon Fang",
        spritenum = 106,
        fling = {basePower = 70},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move and (move.type == "Dragon") then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 250,
        gen = 2
    },
    dragongem = {
        name = "Dragon Gem",
        spritenum = 107,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            if (target == source) or (move.category == "Status") then
                return
            end
            if (move.type == "Dragon") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 561,
        gen = 5,
        isNonstandard = "Past"
    },
    dragonmemory = {
        name = "Dragon Memory",
        spritenum = 682,
        onMemory = "Dragon",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Dragon",
        itemUser = {"Silvally-Dragon"},
        num = 918,
        gen = 7
    },
    dragonscale = {name = "Dragon Scale", spritenum = 108, fling = {basePower = 30}, num = 250, gen = 2},
    dragoniumz = {name = "Dragonium Z", spritenum = 645, onPlate = "Dragon", onTakeItem = false, zMove = true, zMoveType = "Dragon", forcedForme = "Arceus-Dragon", num = 790, gen = 7, isNonstandard = "Past"},
    dreadplate = {
        name = "Dread Plate",
        spritenum = 110,
        onPlate = "Dark",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move and (move.type == "Dark") then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Dark",
        num = 312,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    dreamball = {name = "Dream Ball", spritenum = 111, num = 576, gen = 5, isPokeball = true},
    dubiousdisc = {name = "Dubious Disc", spritenum = 113, fling = {basePower = 50}, num = 324, gen = 4},
    durinberry = {name = "Durin Berry", spritenum = 114, isBerry = true, naturalGift = {basePower = 100, type = "Water"}, onEat = false, num = 182, gen = 3, isNonstandard = "Past"},
    duskball = {name = "Dusk Ball", spritenum = 115, num = 13, gen = 4, isPokeball = true},
    duskstone = {name = "Dusk Stone", spritenum = 116, fling = {basePower = 80}, num = 108, gen = 4},
    earthplate = {
        name = "Earth Plate",
        spritenum = 117,
        onPlate = "Ground",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move and (move.type == "Ground") then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Ground",
        num = 305,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    eeviumz = {name = "Eevium Z", spritenum = 657, onTakeItem = false, zMove = "Extreme Evoboost", zMoveFrom = "Last Resort", itemUser = {"Eevee"}, num = 805, gen = 7, isNonstandard = "Past"},
    ejectbutton = {
        name = "Eject Button",
        spritenum = 118,
        fling = {basePower = 30},
        onAfterMoveSecondaryPriority = 2,
        onAfterMoveSecondary = function(self, target, source, move)
            if ((((source and (source ~= target)) and target.hp) and move) and (move.category ~= "Status")) and (not move.isFutureMove) then
                if ((not self:canSwitch(target.side)) or target.forceSwitchFlag) or target.beingCalledBack then
                    return
                end
                for ____, pokemon in __TS__Iterator(
                    self:getAllActive()
                ) do
                    if pokemon.switchFlag == true then
                        return
                    end
                end
                target.switchFlag = true
                if target:useItem() then
                    source.switchFlag = false
                else
                    target.switchFlag = false
                end
            end
        end,
        num = 547,
        gen = 5
    },
    ejectpack = {
        name = "Eject Pack",
        spritenum = 714,
        fling = {basePower = 50},
        onAfterBoost = function(self, boost, target, source, effect)
            if self.activeMove.id == "partingshot" then
                return
            end
            local eject = false
            local i
            for ____value in pairs(boost) do
                i = ____value
                if boost[i] < 0 then
                    eject = true
                end
            end
            if eject then
                if target.hp then
                    if not self:canSwitch(target.side) then
                        return
                    end
                    for ____, pokemon in __TS__Iterator(
                        self:getAllActive()
                    ) do
                        if pokemon.switchFlag == true then
                            return
                        end
                    end
                    if target:useItem() then
                        target.switchFlag = true
                    end
                end
            end
        end,
        num = 1119,
        gen = 8
    },
    electirizer = {name = "Electirizer", spritenum = 119, fling = {basePower = 80}, num = 322, gen = 4},
    electricgem = {
        name = "Electric Gem",
        spritenum = 120,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            local pledges = {"firepledge", "grasspledge", "waterpledge"}
            if ((target == source) or (move.category == "Status")) or pledges:includes(move.id) then
                return
            end
            if (move.type == "Electric") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 550,
        gen = 5,
        isNonstandard = "Past"
    },
    electricmemory = {
        name = "Electric Memory",
        spritenum = 679,
        onMemory = "Electric",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Electric",
        itemUser = {"Silvally-Electric"},
        num = 915,
        gen = 7
    },
    electricseed = {
        name = "Electric Seed",
        spritenum = 664,
        fling = {basePower = 10},
        onStart = function(self, pokemon)
            if (not pokemon:ignoringItem()) and self.field:isTerrain("electricterrain") then
                pokemon:useItem()
            end
        end,
        onAnyTerrainStart = function(self)
            local pokemon = self.effectState.target
            if self.field:isTerrain("electricterrain") then
                pokemon:useItem()
            end
        end,
        boosts = {def = 1},
        num = 881,
        gen = 7
    },
    electriumz = {name = "Electrium Z", spritenum = 634, onPlate = "Electric", onTakeItem = false, zMove = true, zMoveType = "Electric", forcedForme = "Arceus-Electric", num = 779, gen = 7, isNonstandard = "Past"},
    energypowder = {name = "Energy Powder", spritenum = 123, fling = {basePower = 30}, num = 34, gen = 2},
    enigmaberry = {
        name = "Enigma Berry",
        spritenum = 124,
        isBerry = true,
        naturalGift = {basePower = 100, type = "Bug"},
        onHit = function(self, target, source, move)
            if move and (target:getMoveHitData(move).typeMod > 0) then
                if target:eatItem() then
                    self:heal(target.baseMaxhp / 4)
                end
            end
        end,
        onTryEatItem = function(self, item, pokemon)
            if not self:runEvent("TryHeal", pokemon) then
                return false
            end
        end,
        onEat = function(self)
        end,
        num = 208,
        gen = 3
    },
    eviolite = {
        name = "Eviolite",
        spritenum = 130,
        fling = {basePower = 40},
        onModifyDefPriority = 2,
        onModifyDef = function(self, def, pokemon)
            if pokemon.baseSpecies.nfe then
                return self:chainModify(1.5)
            end
        end,
        onModifySpDPriority = 2,
        onModifySpD = function(self, spd, pokemon)
            if pokemon.baseSpecies.nfe then
                return self:chainModify(1.5)
            end
        end,
        num = 538,
        gen = 5
    },
    expertbelt = {
        name = "Expert Belt",
        spritenum = 132,
        fling = {basePower = 10},
        onModifyDamage = function(self, damage, source, target, move)
            if move and (target:getMoveHitData(move).typeMod > 0) then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 268,
        gen = 4
    },
    fairiumz = {name = "Fairium Z", spritenum = 648, onPlate = "Fairy", onTakeItem = false, zMove = true, zMoveType = "Fairy", forcedForme = "Arceus-Fairy", num = 793, gen = 7, isNonstandard = "Past"},
    fairygem = {
        name = "Fairy Gem",
        spritenum = 611,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            if (target == source) or (move.category == "Status") then
                return
            end
            if (move.type == "Fairy") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 715,
        gen = 6,
        isNonstandard = "Past"
    },
    fairymemory = {
        name = "Fairy Memory",
        spritenum = 684,
        onMemory = "Fairy",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Fairy",
        itemUser = {"Silvally-Fairy"},
        num = 920,
        gen = 7
    },
    fastball = {name = "Fast Ball", spritenum = 137, num = 492, gen = 2, isPokeball = true},
    fightinggem = {
        name = "Fighting Gem",
        spritenum = 139,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            if (target == source) or (move.category == "Status") then
                return
            end
            if (move.type == "Fighting") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 553,
        gen = 5,
        isNonstandard = "Past"
    },
    fightingmemory = {
        name = "Fighting Memory",
        spritenum = 668,
        onMemory = "Fighting",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Fighting",
        itemUser = {"Silvally-Fighting"},
        num = 904,
        gen = 7
    },
    fightiniumz = {name = "Fightinium Z", spritenum = 637, onPlate = "Fighting", onTakeItem = false, zMove = true, zMoveType = "Fighting", forcedForme = "Arceus-Fighting", num = 782, gen = 7, isNonstandard = "Past"},
    figyberry = {
        name = "Figy Berry",
        spritenum = 140,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Bug"},
        onUpdate = function(self, pokemon)
            if (pokemon.hp <= (pokemon.maxhp / 4)) or ((pokemon.hp <= (pokemon.maxhp / 2)) and pokemon:hasAbility("gluttony")) then
                pokemon:eatItem()
            end
        end,
        onTryEatItem = function(self, item, pokemon)
            if not self:runEvent("TryHeal", pokemon) then
                return false
            end
        end,
        onEat = function(self, pokemon)
            self:heal(pokemon.baseMaxhp * 0.33)
            if pokemon:getNature().minus == "atk" then
                pokemon:addVolatile("confusion")
            end
        end,
        num = 159,
        gen = 3
    },
    firegem = {
        name = "Fire Gem",
        spritenum = 141,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            local pledges = {"firepledge", "grasspledge", "waterpledge"}
            if ((target == source) or (move.category == "Status")) or pledges:includes(move.id) then
                return
            end
            if (move.type == "Fire") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 548,
        gen = 5,
        isNonstandard = "Past"
    },
    firememory = {
        name = "Fire Memory",
        spritenum = 676,
        onMemory = "Fire",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Fire",
        itemUser = {"Silvally-Fire"},
        num = 912,
        gen = 7
    },
    firestone = {name = "Fire Stone", spritenum = 142, fling = {basePower = 30}, num = 82, gen = 1},
    firiumz = {name = "Firium Z", spritenum = 632, onPlate = "Fire", onTakeItem = false, zMove = true, zMoveType = "Fire", forcedForme = "Arceus-Fire", num = 777, gen = 7, isNonstandard = "Past"},
    fistplate = {
        name = "Fist Plate",
        spritenum = 143,
        onPlate = "Fighting",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move and (move.type == "Fighting") then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Fighting",
        num = 303,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    flameorb = {
        name = "Flame Orb",
        spritenum = 145,
        fling = {basePower = 30, status = "brn"},
        onResidualOrder = 28,
        onResidualSubOrder = 3,
        onResidual = function(self, pokemon)
            pokemon:trySetStatus("brn", pokemon)
        end,
        num = 273,
        gen = 4
    },
    flameplate = {
        name = "Flame Plate",
        spritenum = 146,
        onPlate = "Fire",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move and (move.type == "Fire") then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Fire",
        num = 298,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    floatstone = {
        name = "Float Stone",
        spritenum = 147,
        fling = {basePower = 30},
        onModifyWeight = function(self, weighthg)
            return self:trunc(weighthg / 2)
        end,
        num = 539,
        gen = 5
    },
    flowersweet = {name = "Flower Sweet", spritenum = 708, fling = {basePower = 0}, num = 1113, gen = 8},
    flyinggem = {
        name = "Flying Gem",
        spritenum = 149,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            if (target == source) or (move.category == "Status") then
                return
            end
            if (move.type == "Flying") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 556,
        gen = 5,
        isNonstandard = "Past"
    },
    flyingmemory = {
        name = "Flying Memory",
        spritenum = 669,
        onMemory = "Flying",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Flying",
        itemUser = {"Silvally-Flying"},
        num = 905,
        gen = 7
    },
    flyiniumz = {name = "Flyinium Z", spritenum = 640, onPlate = "Flying", onTakeItem = false, zMove = true, zMoveType = "Flying", forcedForme = "Arceus-Flying", num = 785, gen = 7, isNonstandard = "Past"},
    focusband = {
        name = "Focus Band",
        spritenum = 150,
        fling = {basePower = 10},
        onDamagePriority = -40,
        onDamage = function(self, damage, target, source, effect)
            if ((self:randomChance(1, 10) and (damage >= target.hp)) and effect) and (effect.effectType == "Move") then
                self:add("-activate", target, "item: Focus Band")
                return target.hp - 1
            end
        end,
        num = 230,
        gen = 2
    },
    focussash = {
        name = "Focus Sash",
        spritenum = 151,
        fling = {basePower = 10},
        onDamagePriority = -40,
        onDamage = function(self, damage, target, source, effect)
            if (((target.hp == target.maxhp) and (damage >= target.hp)) and effect) and (effect.effectType == "Move") then
                if target:useItem() then
                    return target.hp - 1
                end
            end
        end,
        num = 275,
        gen = 4
    },
    fossilizedbird = {name = "Fossilized Bird", spritenum = 700, fling = {basePower = 100}, num = 1105, gen = 8},
    fossilizeddino = {name = "Fossilized Dino", spritenum = 703, fling = {basePower = 100}, num = 1108, gen = 8},
    fossilizeddrake = {name = "Fossilized Drake", spritenum = 702, fling = {basePower = 100}, num = 1107, gen = 8},
    fossilizedfish = {name = "Fossilized Fish", spritenum = 701, fling = {basePower = 100}, num = 1106, gen = 8},
    friendball = {name = "Friend Ball", spritenum = 153, num = 497, gen = 2, isPokeball = true},
    fullincense = {name = "Full Incense", spritenum = 155, fling = {basePower = 10}, onFractionalPriority = -0.1, num = 316, gen = 4},
    galaricacuff = {name = "Galarica Cuff", spritenum = 739, fling = {basePower = 30}, num = 1582, gen = 8},
    galaricawreath = {name = "Galarica Wreath", spritenum = 740, fling = {basePower = 30}, num = 1592, gen = 8},
    galladite = {
        name = "Galladite",
        spritenum = 616,
        megaStone = "Gallade-Mega",
        megaEvolves = "Gallade",
        itemUser = {"Gallade"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 756,
        gen = 6,
        isNonstandard = "Past"
    },
    ganlonberry = {
        name = "Ganlon Berry",
        spritenum = 158,
        isBerry = true,
        naturalGift = {basePower = 100, type = "Ice"},
        onUpdate = function(self, pokemon)
            if (pokemon.hp <= (pokemon.maxhp / 4)) or ((pokemon.hp <= (pokemon.maxhp / 2)) and pokemon:hasAbility("gluttony")) then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            self:boost({def = 1})
        end,
        num = 202,
        gen = 3
    },
    garchompite = {
        name = "Garchompite",
        spritenum = 589,
        megaStone = "Garchomp-Mega",
        megaEvolves = "Garchomp",
        itemUser = {"Garchomp"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 683,
        gen = 6,
        isNonstandard = "Past"
    },
    gardevoirite = {
        name = "Gardevoirite",
        spritenum = 587,
        megaStone = "Gardevoir-Mega",
        megaEvolves = "Gardevoir",
        itemUser = {"Gardevoir"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 657,
        gen = 6,
        isNonstandard = "Past"
    },
    gengarite = {
        name = "Gengarite",
        spritenum = 588,
        megaStone = "Gengar-Mega",
        megaEvolves = "Gengar",
        itemUser = {"Gengar"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 656,
        gen = 6,
        isNonstandard = "Past"
    },
    ghostgem = {
        name = "Ghost Gem",
        spritenum = 161,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            if (target == source) or (move.category == "Status") then
                return
            end
            if (move.type == "Ghost") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 560,
        gen = 5,
        isNonstandard = "Past"
    },
    ghostmemory = {
        name = "Ghost Memory",
        spritenum = 674,
        onMemory = "Ghost",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Ghost",
        itemUser = {"Silvally-Ghost"},
        num = 910,
        gen = 7
    },
    ghostiumz = {name = "Ghostium Z", spritenum = 644, onPlate = "Ghost", onTakeItem = false, zMove = true, zMoveType = "Ghost", forcedForme = "Arceus-Ghost", num = 789, gen = 7, isNonstandard = "Past"},
    glalitite = {
        name = "Glalitite",
        spritenum = 623,
        megaStone = "Glalie-Mega",
        megaEvolves = "Glalie",
        itemUser = {"Glalie"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 763,
        gen = 6,
        isNonstandard = "Past"
    },
    goldbottlecap = {name = "Gold Bottle Cap", spritenum = 697, fling = {basePower = 30}, num = 796, gen = 7},
    grassgem = {
        name = "Grass Gem",
        spritenum = 172,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            local pledges = {"firepledge", "grasspledge", "waterpledge"}
            if ((target == source) or (move.category == "Status")) or pledges:includes(move.id) then
                return
            end
            if (move.type == "Grass") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 551,
        gen = 5,
        isNonstandard = "Past"
    },
    grassmemory = {
        name = "Grass Memory",
        spritenum = 678,
        onMemory = "Grass",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Grass",
        itemUser = {"Silvally-Grass"},
        num = 914,
        gen = 7
    },
    grassiumz = {name = "Grassium Z", spritenum = 635, onPlate = "Grass", onTakeItem = false, zMove = true, zMoveType = "Grass", forcedForme = "Arceus-Grass", num = 780, gen = 7, isNonstandard = "Past"},
    grassyseed = {
        name = "Grassy Seed",
        spritenum = 667,
        fling = {basePower = 10},
        onStart = function(self, pokemon)
            if (not pokemon:ignoringItem()) and self.field:isTerrain("grassyterrain") then
                pokemon:useItem()
            end
        end,
        onAnyTerrainStart = function(self)
            local pokemon = self.effectState.target
            if self.field:isTerrain("grassyterrain") then
                pokemon:useItem()
            end
        end,
        boosts = {def = 1},
        num = 884,
        gen = 7
    },
    greatball = {name = "Great Ball", spritenum = 174, num = 3, gen = 1, isPokeball = true},
    grepaberry = {name = "Grepa Berry", spritenum = 178, isBerry = true, naturalGift = {basePower = 90, type = "Flying"}, onEat = false, num = 173, gen = 3},
    gripclaw = {name = "Grip Claw", spritenum = 179, fling = {basePower = 90}, num = 286, gen = 4},
    griseousorb = {
        name = "Griseous Orb",
        spritenum = 180,
        fling = {basePower = 60},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if (user.baseSpecies.num == 487) and ((move.type == "Ghost") or (move.type == "Dragon")) then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 487)) or (pokemon.baseSpecies.num == 487) then
                return false
            end
            return true
        end,
        forcedForme = "Giratina-Origin",
        itemUser = {"Giratina-Origin"},
        num = 112,
        gen = 4
    },
    groundgem = {
        name = "Ground Gem",
        spritenum = 182,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            if (target == source) or (move.category == "Status") then
                return
            end
            if (move.type == "Ground") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 555,
        gen = 5,
        isNonstandard = "Past"
    },
    groundmemory = {
        name = "Ground Memory",
        spritenum = 671,
        onMemory = "Ground",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Ground",
        itemUser = {"Silvally-Ground"},
        num = 907,
        gen = 7
    },
    groundiumz = {name = "Groundium Z", spritenum = 639, onPlate = "Ground", onTakeItem = false, zMove = true, zMoveType = "Ground", forcedForme = "Arceus-Ground", num = 784, gen = 7, isNonstandard = "Past"},
    gyaradosite = {
        name = "Gyaradosite",
        spritenum = 589,
        megaStone = "Gyarados-Mega",
        megaEvolves = "Gyarados",
        itemUser = {"Gyarados"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 676,
        gen = 6,
        isNonstandard = "Past"
    },
    habanberry = {
        name = "Haban Berry",
        spritenum = 185,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Dragon"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Dragon") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 197,
        gen = 4
    },
    hardstone = {
        name = "Hard Stone",
        spritenum = 187,
        fling = {basePower = 100},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move and (move.type == "Rock") then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 238,
        gen = 2
    },
    healball = {name = "Heal Ball", spritenum = 188, num = 14, gen = 4, isPokeball = true},
    heatrock = {name = "Heat Rock", spritenum = 193, fling = {basePower = 60}, num = 284, gen = 4},
    heavyball = {name = "Heavy Ball", spritenum = 194, num = 495, gen = 2, isPokeball = true},
    heavydutyboots = {name = "Heavy-Duty Boots", spritenum = 715, fling = {basePower = 80}, num = 1120, gen = 8},
    helixfossil = {name = "Helix Fossil", spritenum = 195, fling = {basePower = 100}, num = 101, gen = 3, isNonstandard = "Past"},
    heracronite = {
        name = "Heracronite",
        spritenum = 590,
        megaStone = "Heracross-Mega",
        megaEvolves = "Heracross",
        itemUser = {"Heracross"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 680,
        gen = 6,
        isNonstandard = "Past"
    },
    hondewberry = {name = "Hondew Berry", spritenum = 213, isBerry = true, naturalGift = {basePower = 90, type = "Ground"}, onEat = false, num = 172, gen = 3},
    houndoominite = {
        name = "Houndoominite",
        spritenum = 591,
        megaStone = "Houndoom-Mega",
        megaEvolves = "Houndoom",
        itemUser = {"Houndoom"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 666,
        gen = 6,
        isNonstandard = "Past"
    },
    iapapaberry = {
        name = "Iapapa Berry",
        spritenum = 217,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Dark"},
        onUpdate = function(self, pokemon)
            if (pokemon.hp <= (pokemon.maxhp / 4)) or ((pokemon.hp <= (pokemon.maxhp / 2)) and pokemon:hasAbility("gluttony")) then
                pokemon:eatItem()
            end
        end,
        onTryEatItem = function(self, item, pokemon)
            if not self:runEvent("TryHeal", pokemon) then
                return false
            end
        end,
        onEat = function(self, pokemon)
            self:heal(pokemon.baseMaxhp * 0.33)
            if pokemon:getNature().minus == "def" then
                pokemon:addVolatile("confusion")
            end
        end,
        num = 163,
        gen = 3
    },
    icegem = {
        name = "Ice Gem",
        spritenum = 218,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            if (target == source) or (move.category == "Status") then
                return
            end
            if (move.type == "Ice") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 552,
        gen = 5,
        isNonstandard = "Past"
    },
    icememory = {
        name = "Ice Memory",
        spritenum = 681,
        onMemory = "Ice",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Ice",
        itemUser = {"Silvally-Ice"},
        num = 917,
        gen = 7
    },
    icestone = {name = "Ice Stone", spritenum = 693, fling = {basePower = 30}, num = 849, gen = 7},
    icicleplate = {
        name = "Icicle Plate",
        spritenum = 220,
        onPlate = "Ice",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Ice" then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Ice",
        num = 302,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    iciumz = {name = "Icium Z", spritenum = 636, onPlate = "Ice", onTakeItem = false, zMove = true, zMoveType = "Ice", forcedForme = "Arceus-Ice", num = 781, gen = 7, isNonstandard = "Past"},
    icyrock = {name = "Icy Rock", spritenum = 221, fling = {basePower = 40}, num = 282, gen = 4},
    inciniumz = {name = "Incinium Z", spritenum = 651, onTakeItem = false, zMove = "Malicious Moonsault", zMoveFrom = "Darkest Lariat", itemUser = {"Incineroar"}, num = 799, gen = 7, isNonstandard = "Past"},
    insectplate = {
        name = "Insect Plate",
        spritenum = 223,
        onPlate = "Bug",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Bug" then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Bug",
        num = 308,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    ironball = {
        name = "Iron Ball",
        spritenum = 224,
        fling = {basePower = 130},
        onEffectiveness = function(self, typeMod, target, ____type, move)
            if not target then
                return
            end
            if (target.volatiles.ingrain or target.volatiles.smackdown) or self.field:getPseudoWeather("gravity") then
                return
            end
            if (move.type == "Ground") and target:hasType("Flying") then
                return 0
            end
        end,
        onModifySpe = function(self, spe)
            return self:chainModify(0.5)
        end,
        num = 278,
        gen = 4
    },
    ironplate = {
        name = "Iron Plate",
        spritenum = 225,
        onPlate = "Steel",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Steel" then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Steel",
        num = 313,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    jabocaberry = {
        name = "Jaboca Berry",
        spritenum = 230,
        isBerry = true,
        naturalGift = {basePower = 100, type = "Dragon"},
        onDamagingHit = function(self, damage, target, source, move)
            if ((move.category == "Physical") and source.hp) and source.isActive then
                if target:eatItem() then
                    self:damage(
                        source.baseMaxhp / ((target:hasAbility("ripen") and 4) or 8),
                        source,
                        target
                    )
                end
            end
        end,
        onEat = function(self)
        end,
        num = 211,
        gen = 4
    },
    jawfossil = {name = "Jaw Fossil", spritenum = 694, fling = {basePower = 100}, num = 710, gen = 6, isNonstandard = "Past"},
    kasibberry = {
        name = "Kasib Berry",
        spritenum = 233,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Ghost"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Ghost") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 196,
        gen = 4
    },
    kebiaberry = {
        name = "Kebia Berry",
        spritenum = 234,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Poison"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Poison") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 190,
        gen = 4
    },
    keeberry = {
        name = "Kee Berry",
        spritenum = 593,
        isBerry = true,
        naturalGift = {basePower = 100, type = "Fairy"},
        onAfterMoveSecondary = function(self, target, source, move)
            if move.category == "Physical" then
                if (move.id == "present") and move.heal then
                    return
                end
                target:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            self:boost({def = 1})
        end,
        num = 687,
        gen = 6
    },
    kelpsyberry = {name = "Kelpsy Berry", spritenum = 235, isBerry = true, naturalGift = {basePower = 90, type = "Fighting"}, onEat = false, num = 170, gen = 3},
    kangaskhanite = {
        name = "Kangaskhanite",
        spritenum = 592,
        megaStone = "Kangaskhan-Mega",
        megaEvolves = "Kangaskhan",
        itemUser = {"Kangaskhan"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 675,
        gen = 6,
        isNonstandard = "Past"
    },
    kingsrock = {
        name = "King's Rock",
        spritenum = 236,
        fling = {basePower = 30, volatileStatus = "flinch"},
        onModifyMovePriority = -1,
        onModifyMove = function(self, move)
            if move.category ~= "Status" then
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
        num = 221,
        gen = 2
    },
    kommoniumz = {name = "Kommonium Z", spritenum = 690, onTakeItem = false, zMove = "Clangorous Soulblaze", zMoveFrom = "Clanging Scales", itemUser = {"Kommo-o", "Kommo-o-Totem"}, num = 926, gen = 7, isNonstandard = "Past"},
    laggingtail = {name = "Lagging Tail", spritenum = 237, fling = {basePower = 10}, onFractionalPriority = -0.1, num = 279, gen = 4},
    lansatberry = {
        name = "Lansat Berry",
        spritenum = 238,
        isBerry = true,
        naturalGift = {basePower = 100, type = "Flying"},
        onUpdate = function(self, pokemon)
            if (pokemon.hp <= (pokemon.maxhp / 4)) or ((pokemon.hp <= (pokemon.maxhp / 2)) and pokemon:hasAbility("gluttony")) then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            pokemon:addVolatile("focusenergy")
        end,
        num = 206,
        gen = 3
    },
    latiasite = {
        name = "Latiasite",
        spritenum = 629,
        megaStone = "Latias-Mega",
        megaEvolves = "Latias",
        itemUser = {"Latias"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 684,
        gen = 6,
        isNonstandard = "Past"
    },
    latiosite = {
        name = "Latiosite",
        spritenum = 630,
        megaStone = "Latios-Mega",
        megaEvolves = "Latios",
        itemUser = {"Latios"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 685,
        gen = 6,
        isNonstandard = "Past"
    },
    laxincense = {
        name = "Lax Incense",
        spritenum = 240,
        fling = {basePower = 10},
        onModifyAccuracyPriority = -2,
        onModifyAccuracy = function(self, accuracy)
            if type(accuracy) ~= "number" then
                return
            end
            self:debug("lax incense - decreasing accuracy")
            return self:chainModify({3686, 4096})
        end,
        num = 255,
        gen = 3
    },
    leafstone = {name = "Leaf Stone", spritenum = 241, fling = {basePower = 30}, num = 85, gen = 1},
    leek = {
        name = "Leek",
        fling = {basePower = 60},
        spritenum = 475,
        onModifyCritRatio = function(self, critRatio, user)
            if ({"farfetchd", "sirfetchd"}):includes(
                self:toID(user.baseSpecies.baseSpecies)
            ) then
                return critRatio + 2
            end
        end,
        itemUser = {"Farfetch’d", "Sirfetch’d"},
        num = 259,
        gen = 8
    },
    leftovers = {
        name = "Leftovers",
        spritenum = 242,
        fling = {basePower = 10},
        onResidualOrder = 5,
        onResidualSubOrder = 4,
        onResidual = function(self, pokemon)
            self:heal(pokemon.baseMaxhp / 16)
        end,
        num = 234,
        gen = 2
    },
    leppaberry = {
        name = "Leppa Berry",
        spritenum = 244,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Fighting"},
        onUpdate = function(self, pokemon)
            if not pokemon.hp then
                return
            end
            if pokemon.moveSlots:some(
                function(____, move) return move.pp == 0 end
            ) then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            local moveSlot = pokemon.moveSlots:find(
                function(____, move) return move.pp == 0 end
            ) or pokemon.moveSlots:find(
                function(____, move) return move.pp < move.maxpp end
            )
            if not moveSlot then
                return
            end
            moveSlot.pp = moveSlot.pp + 10
            if moveSlot.pp > moveSlot.maxpp then
                moveSlot.pp = moveSlot.maxpp
            end
            self:add("-activate", pokemon, "item: Leppa Berry", moveSlot.move, "[consumed]")
        end,
        num = 154,
        gen = 3
    },
    levelball = {name = "Level Ball", spritenum = 246, num = 493, gen = 2, isPokeball = true},
    liechiberry = {
        name = "Liechi Berry",
        spritenum = 248,
        isBerry = true,
        naturalGift = {basePower = 100, type = "Grass"},
        onUpdate = function(self, pokemon)
            if (pokemon.hp <= (pokemon.maxhp / 4)) or ((pokemon.hp <= (pokemon.maxhp / 2)) and pokemon:hasAbility("gluttony")) then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            self:boost({atk = 1})
        end,
        num = 201,
        gen = 3
    },
    lifeorb = {
        name = "Life Orb",
        spritenum = 249,
        fling = {basePower = 30},
        onModifyDamage = function(self, damage, source, target, move)
            return self:chainModify({5324, 4096})
        end,
        onAfterMoveSecondarySelf = function(self, source, target, move)
            if ((source and (source ~= target)) and move) and (move.category ~= "Status") then
                self:damage(
                    source.baseMaxhp / 10,
                    source,
                    source,
                    self.dex.items:get("lifeorb")
                )
            end
        end,
        num = 270,
        gen = 4
    },
    lightball = {
        name = "Light Ball",
        spritenum = 251,
        fling = {basePower = 30, status = "par"},
        onModifyAtkPriority = 1,
        onModifyAtk = function(self, atk, pokemon)
            if pokemon.baseSpecies.baseSpecies == "Pikachu" then
                return self:chainModify(2)
            end
        end,
        onModifySpAPriority = 1,
        onModifySpA = function(self, spa, pokemon)
            if pokemon.baseSpecies.baseSpecies == "Pikachu" then
                return self:chainModify(2)
            end
        end,
        itemUser = {"Pikachu"},
        num = 236,
        gen = 2
    },
    lightclay = {name = "Light Clay", spritenum = 252, fling = {basePower = 30}, num = 269, gen = 4},
    lopunnite = {
        name = "Lopunnite",
        spritenum = 626,
        megaStone = "Lopunny-Mega",
        megaEvolves = "Lopunny",
        itemUser = {"Lopunny"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 768,
        gen = 6,
        isNonstandard = "Past"
    },
    loveball = {name = "Love Ball", spritenum = 258, num = 496, gen = 2, isPokeball = true},
    lovesweet = {name = "Love Sweet", spritenum = 705, fling = {basePower = 10}, num = 1110, gen = 8},
    lucarionite = {
        name = "Lucarionite",
        spritenum = 594,
        megaStone = "Lucario-Mega",
        megaEvolves = "Lucario",
        itemUser = {"Lucario"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 673,
        gen = 6,
        isNonstandard = "Past"
    },
    luckypunch = {
        name = "Lucky Punch",
        spritenum = 261,
        fling = {basePower = 40},
        onModifyCritRatio = function(self, critRatio, user)
            if user.baseSpecies.name == "Chansey" then
                return critRatio + 2
            end
        end,
        itemUser = {"Chansey"},
        num = 256,
        gen = 2,
        isNonstandard = "Past"
    },
    lumberry = {
        name = "Lum Berry",
        spritenum = 262,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Flying"},
        onAfterSetStatusPriority = -1,
        onAfterSetStatus = function(self, status, pokemon)
            pokemon:eatItem()
        end,
        onUpdate = function(self, pokemon)
            if pokemon.status or pokemon.volatiles.confusion then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            pokemon:cureStatus()
            pokemon:removeVolatile("confusion")
        end,
        num = 157,
        gen = 3
    },
    luminousmoss = {
        name = "Luminous Moss",
        spritenum = 595,
        fling = {basePower = 30},
        onDamagingHit = function(self, damage, target, source, move)
            if move.type == "Water" then
                target:useItem()
            end
        end,
        boosts = {spd = 1},
        num = 648,
        gen = 6
    },
    lunaliumz = {name = "Lunalium Z", spritenum = 686, onTakeItem = false, zMove = "Menacing Moonraze Maelstrom", zMoveFrom = "Moongeist Beam", itemUser = {"Lunala", "Necrozma-Dawn-Wings"}, num = 922, gen = 7, isNonstandard = "Past"},
    lureball = {name = "Lure Ball", spritenum = 264, num = 494, gen = 2, isPokeball = true},
    lustrousorb = {
        name = "Lustrous Orb",
        spritenum = 265,
        fling = {basePower = 60},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if (move and (user.baseSpecies.name == "Palkia")) and ((move.type == "Water") or (move.type == "Dragon")) then
                return self:chainModify({4915, 4096})
            end
        end,
        itemUser = {"Palkia"},
        num = 136,
        gen = 4
    },
    luxuryball = {name = "Luxury Ball", spritenum = 266, num = 11, gen = 3, isPokeball = true},
    lycaniumz = {name = "Lycanium Z", spritenum = 689, onTakeItem = false, zMove = "Splintered Stormshards", zMoveFrom = "Stone Edge", itemUser = {"Lycanroc", "Lycanroc-Midnight", "Lycanroc-Dusk"}, num = 925, gen = 7, isNonstandard = "Past"},
    machobrace = {
        name = "Macho Brace",
        spritenum = 269,
        ignoreKlutz = true,
        fling = {basePower = 60},
        onModifySpe = function(self, spe)
            return self:chainModify(0.5)
        end,
        num = 215,
        gen = 3
    },
    magmarizer = {name = "Magmarizer", spritenum = 272, fling = {basePower = 80}, num = 323, gen = 4},
    magnet = {
        name = "Magnet",
        spritenum = 273,
        fling = {basePower = 30},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Electric" then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 242,
        gen = 2
    },
    magoberry = {
        name = "Mago Berry",
        spritenum = 274,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Ghost"},
        onUpdate = function(self, pokemon)
            if (pokemon.hp <= (pokemon.maxhp / 4)) or ((pokemon.hp <= (pokemon.maxhp / 2)) and pokemon:hasAbility("gluttony")) then
                pokemon:eatItem()
            end
        end,
        onTryEatItem = function(self, item, pokemon)
            if not self:runEvent("TryHeal", pokemon) then
                return false
            end
        end,
        onEat = function(self, pokemon)
            self:heal(pokemon.baseMaxhp * 0.33)
            if pokemon:getNature().minus == "spe" then
                pokemon:addVolatile("confusion")
            end
        end,
        num = 161,
        gen = 3
    },
    magostberry = {name = "Magost Berry", spritenum = 275, isBerry = true, naturalGift = {basePower = 90, type = "Rock"}, onEat = false, num = 176, gen = 3, isNonstandard = "Past"},
    mail = {
        name = "Mail",
        spritenum = 403,
        onTakeItem = function(self, item, source)
            if not self.activeMove then
                return false
            end
            if ((self.activeMove.id ~= "knockoff") and (self.activeMove.id ~= "thief")) and (self.activeMove.id ~= "covet") then
                return false
            end
        end,
        num = 0,
        gen = 2,
        isNonstandard = "Past"
    },
    manectite = {
        name = "Manectite",
        spritenum = 596,
        megaStone = "Manectric-Mega",
        megaEvolves = "Manectric",
        itemUser = {"Manectric"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 682,
        gen = 6,
        isNonstandard = "Past"
    },
    marangaberry = {
        name = "Maranga Berry",
        spritenum = 597,
        isBerry = true,
        naturalGift = {basePower = 100, type = "Dark"},
        onAfterMoveSecondary = function(self, target, source, move)
            if move.category == "Special" then
                target:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            self:boost({spd = 1})
        end,
        num = 688,
        gen = 6
    },
    marshadiumz = {name = "Marshadium Z", spritenum = 654, onTakeItem = false, zMove = "Soul-Stealing 7-Star Strike", zMoveFrom = "Spectral Thief", itemUser = {"Marshadow"}, num = 802, gen = 7, isNonstandard = "Past"},
    masterball = {name = "Master Ball", spritenum = 276, num = 1, gen = 1, isPokeball = true},
    mawilite = {
        name = "Mawilite",
        spritenum = 598,
        megaStone = "Mawile-Mega",
        megaEvolves = "Mawile",
        itemUser = {"Mawile"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 681,
        gen = 6,
        isNonstandard = "Past"
    },
    meadowplate = {
        name = "Meadow Plate",
        spritenum = 282,
        onPlate = "Grass",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Grass" then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Grass",
        num = 301,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    medichamite = {
        name = "Medichamite",
        spritenum = 599,
        megaStone = "Medicham-Mega",
        megaEvolves = "Medicham",
        itemUser = {"Medicham"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 665,
        gen = 6,
        isNonstandard = "Past"
    },
    mentalherb = {
        name = "Mental Herb",
        spritenum = 285,
        fling = {
            basePower = 10,
            effect = function(self, pokemon)
                local conditions = {"attract", "taunt", "encore", "torment", "disable", "healblock"}
                for ____, firstCondition in ipairs(conditions) do
                    if pokemon.volatiles[firstCondition] then
                        for ____, secondCondition in ipairs(conditions) do
                            pokemon:removeVolatile(secondCondition)
                            if (firstCondition == "attract") and (secondCondition == "attract") then
                                self:add("-end", pokemon, "move: Attract", "[from] item: Mental Herb")
                            end
                        end
                        return
                    end
                end
            end
        },
        onUpdate = function(self, pokemon)
            local conditions = {"attract", "taunt", "encore", "torment", "disable", "healblock"}
            for ____, firstCondition in ipairs(conditions) do
                if pokemon.volatiles[firstCondition] then
                    if not pokemon:useItem() then
                        return
                    end
                    for ____, secondCondition in ipairs(conditions) do
                        pokemon:removeVolatile(secondCondition)
                        if (firstCondition == "attract") and (secondCondition == "attract") then
                            self:add("-end", pokemon, "move: Attract", "[from] item: Mental Herb")
                        end
                    end
                    return
                end
            end
        end,
        num = 219,
        gen = 3
    },
    metagrossite = {
        name = "Metagrossite",
        spritenum = 618,
        megaStone = "Metagross-Mega",
        megaEvolves = "Metagross",
        itemUser = {"Metagross"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 758,
        gen = 6,
        isNonstandard = "Past"
    },
    metalcoat = {
        name = "Metal Coat",
        spritenum = 286,
        fling = {basePower = 30},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Steel" then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 233,
        gen = 2
    },
    metalpowder = {
        name = "Metal Powder",
        fling = {basePower = 10},
        spritenum = 287,
        onModifyDefPriority = 2,
        onModifyDef = function(self, def, pokemon)
            if (pokemon.species.name == "Ditto") and (not pokemon.transformed) then
                return self:chainModify(2)
            end
        end,
        itemUser = {"Ditto"},
        num = 257,
        gen = 2
    },
    metronome = {
        name = "Metronome",
        spritenum = 289,
        fling = {basePower = 30},
        onStart = function(self, pokemon)
            pokemon:addVolatile("metronome")
        end,
        condition = {
            onStart = function(self, pokemon)
                self.effectState.lastMove = ""
                self.effectState.numConsecutive = 0
            end,
            onTryMovePriority = -2,
            onTryMove = function(self, pokemon, target, move)
                if not pokemon:hasItem("metronome") then
                    pokemon:removeVolatile("metronome")
                    return
                end
                if (self.effectState.lastMove == move.id) and pokemon.moveLastTurnResult then
                    local ____obj, ____index = self.effectState, "numConsecutive"
                    ____obj[____index] = ____obj[____index] + 1
                elseif pokemon.volatiles.twoturnmove and (self.effectState.lastMove ~= move.id) then
                    self.effectState.numConsecutive = 1
                else
                    self.effectState.numConsecutive = 0
                end
                self.effectState.lastMove = move.id
            end,
            onModifyDamage = function(self, damage, source, target, move)
                local dmgMod = {4096, 4915, 5734, 6553, 7372, 8192}
                local numConsecutive = ((self.effectState.numConsecutive > 5) and 5) or self.effectState.numConsecutive
                self:debug(
                    ("Current Metronome boost: " .. tostring(dmgMod[numConsecutive])) .. "/4096"
                )
                return self:chainModify({dmgMod[numConsecutive], 4096})
            end
        },
        num = 277,
        gen = 4
    },
    mewniumz = {name = "Mewnium Z", spritenum = 658, onTakeItem = false, zMove = "Genesis Supernova", zMoveFrom = "Psychic", itemUser = {"Mew"}, num = 806, gen = 7, isNonstandard = "Past"},
    mewtwonitex = {
        name = "Mewtwonite X",
        spritenum = 600,
        megaStone = "Mewtwo-Mega-X",
        megaEvolves = "Mewtwo",
        itemUser = {"Mewtwo"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 662,
        gen = 6,
        isNonstandard = "Past"
    },
    mewtwonitey = {
        name = "Mewtwonite Y",
        spritenum = 601,
        megaStone = "Mewtwo-Mega-Y",
        megaEvolves = "Mewtwo",
        itemUser = {"Mewtwo"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 663,
        gen = 6,
        isNonstandard = "Past"
    },
    micleberry = {
        name = "Micle Berry",
        spritenum = 290,
        isBerry = true,
        naturalGift = {basePower = 100, type = "Rock"},
        onResidual = function(self, pokemon)
            if (pokemon.hp <= (pokemon.maxhp / 4)) or ((pokemon.hp <= (pokemon.maxhp / 2)) and pokemon:hasAbility("gluttony")) then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            pokemon:addVolatile("micleberry")
        end,
        condition = {
            duration = 2,
            onSourceAccuracy = function(self, accuracy, target, source, move)
                if not move.ohko then
                    self:add("-enditem", source, "Micle Berry")
                    source:removeVolatile("micleberry")
                    if type(accuracy) == "number" then
                        return self:chainModify({4915, 4096})
                    end
                end
            end
        },
        num = 209,
        gen = 4
    },
    mimikiumz = {name = "Mimikium Z", spritenum = 688, onTakeItem = false, zMove = "Let's Snuggle Forever", zMoveFrom = "Play Rough", itemUser = {"Mimikyu", "Mimikyu-Busted", "Mimikyu-Totem", "Mimikyu-Busted-Totem"}, num = 924, isNonstandard = "Past", gen = 7},
    mindplate = {
        name = "Mind Plate",
        spritenum = 291,
        onPlate = "Psychic",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Psychic" then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Psychic",
        num = 307,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    miracleseed = {
        name = "Miracle Seed",
        fling = {basePower = 30},
        spritenum = 292,
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Grass" then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 239,
        gen = 2
    },
    mistyseed = {
        name = "Misty Seed",
        spritenum = 666,
        fling = {basePower = 10},
        onStart = function(self, pokemon)
            if (not pokemon:ignoringItem()) and self.field:isTerrain("mistyterrain") then
                pokemon:useItem()
            end
        end,
        onAnyTerrainStart = function(self)
            local pokemon = self.effectState.target
            if self.field:isTerrain("mistyterrain") then
                pokemon:useItem()
            end
        end,
        boosts = {spd = 1},
        num = 883,
        gen = 7
    },
    moonball = {name = "Moon Ball", spritenum = 294, num = 498, gen = 2, isPokeball = true},
    moonstone = {name = "Moon Stone", spritenum = 295, fling = {basePower = 30}, num = 81, gen = 1},
    muscleband = {
        name = "Muscle Band",
        spritenum = 297,
        fling = {basePower = 10},
        onBasePowerPriority = 16,
        onBasePower = function(self, basePower, user, target, move)
            if move.category == "Physical" then
                return self:chainModify({4505, 4096})
            end
        end,
        num = 266,
        gen = 4
    },
    mysticwater = {
        name = "Mystic Water",
        spritenum = 300,
        fling = {basePower = 30},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Water" then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 243,
        gen = 2
    },
    nanabberry = {name = "Nanab Berry", spritenum = 302, isBerry = true, naturalGift = {basePower = 90, type = "Water"}, onEat = false, num = 166, gen = 3, isNonstandard = "Past"},
    nestball = {name = "Nest Ball", spritenum = 303, num = 8, gen = 3, isPokeball = true},
    netball = {name = "Net Ball", spritenum = 304, num = 6, gen = 3, isPokeball = true},
    nevermeltice = {
        name = "Never-Melt Ice",
        spritenum = 305,
        fling = {basePower = 30},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Ice" then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 246,
        gen = 2
    },
    nomelberry = {name = "Nomel Berry", spritenum = 306, isBerry = true, naturalGift = {basePower = 90, type = "Dragon"}, onEat = false, num = 178, gen = 3, isNonstandard = "Past"},
    normalgem = {
        name = "Normal Gem",
        spritenum = 307,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            local pledges = {"firepledge", "grasspledge", "waterpledge"}
            if ((target == source) or (move.category == "Status")) or pledges:includes(move.id) then
                return
            end
            if (move.type == "Normal") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 564,
        gen = 5
    },
    normaliumz = {name = "Normalium Z", spritenum = 631, onTakeItem = false, zMove = true, zMoveType = "Normal", num = 776, gen = 7, isNonstandard = "Past"},
    occaberry = {
        name = "Occa Berry",
        spritenum = 311,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Fire"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Fire") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 184,
        gen = 4
    },
    oddincense = {
        name = "Odd Incense",
        spritenum = 312,
        fling = {basePower = 10},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Psychic" then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 314,
        gen = 4
    },
    oldamber = {name = "Old Amber", spritenum = 314, fling = {basePower = 100}, num = 103, gen = 3, isNonstandard = "Past"},
    oranberry = {
        name = "Oran Berry",
        spritenum = 319,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Poison"},
        onUpdate = function(self, pokemon)
            if pokemon.hp <= (pokemon.maxhp / 2) then
                pokemon:eatItem()
            end
        end,
        onTryEatItem = function(self, item, pokemon)
            if not self:runEvent("TryHeal", pokemon) then
                return false
            end
        end,
        onEat = function(self, pokemon)
            self:heal(10)
        end,
        num = 155,
        gen = 3
    },
    ovalstone = {name = "Oval Stone", spritenum = 321, fling = {basePower = 80}, num = 110, gen = 4},
    pamtreberry = {name = "Pamtre Berry", spritenum = 323, isBerry = true, naturalGift = {basePower = 90, type = "Steel"}, onEat = false, num = 180, gen = 3, isNonstandard = "Past"},
    parkball = {name = "Park Ball", spritenum = 325, num = 500, gen = 4, isPokeball = true},
    passhoberry = {
        name = "Passho Berry",
        spritenum = 329,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Water"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Water") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 185,
        gen = 4
    },
    payapaberry = {
        name = "Payapa Berry",
        spritenum = 330,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Psychic"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Psychic") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 193,
        gen = 4
    },
    pechaberry = {
        name = "Pecha Berry",
        spritenum = 333,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Electric"},
        onUpdate = function(self, pokemon)
            if (pokemon.status == "psn") or (pokemon.status == "tox") then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            if (pokemon.status == "psn") or (pokemon.status == "tox") then
                pokemon:cureStatus()
            end
        end,
        num = 151,
        gen = 3
    },
    persimberry = {
        name = "Persim Berry",
        spritenum = 334,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Ground"},
        onUpdate = function(self, pokemon)
            if pokemon.volatiles.confusion then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            pokemon:removeVolatile("confusion")
        end,
        num = 156,
        gen = 3
    },
    petayaberry = {
        name = "Petaya Berry",
        spritenum = 335,
        isBerry = true,
        naturalGift = {basePower = 100, type = "Poison"},
        onUpdate = function(self, pokemon)
            if (pokemon.hp <= (pokemon.maxhp / 4)) or ((pokemon.hp <= (pokemon.maxhp / 2)) and pokemon:hasAbility("gluttony")) then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            self:boost({spa = 1})
        end,
        num = 204,
        gen = 3
    },
    pidgeotite = {
        name = "Pidgeotite",
        spritenum = 622,
        megaStone = "Pidgeot-Mega",
        megaEvolves = "Pidgeot",
        itemUser = {"Pidgeot"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 762,
        gen = 6,
        isNonstandard = "Past"
    },
    pikaniumz = {name = "Pikanium Z", spritenum = 649, onTakeItem = false, zMove = "Catastropika", zMoveFrom = "Volt Tackle", itemUser = {"Pikachu"}, num = 794, gen = 7, isNonstandard = "Past"},
    pikashuniumz = {name = "Pikashunium Z", spritenum = 659, onTakeItem = false, zMove = "10,000,000 Volt Thunderbolt", zMoveFrom = "Thunderbolt", itemUser = {"Pikachu-Original", "Pikachu-Hoenn", "Pikachu-Sinnoh", "Pikachu-Unova", "Pikachu-Kalos", "Pikachu-Alola", "Pikachu-Partner"}, num = 836, isNonstandard = "Past", gen = 7},
    pinapberry = {name = "Pinap Berry", spritenum = 337, isBerry = true, naturalGift = {basePower = 90, type = "Grass"}, onEat = false, num = 168, gen = 3},
    pinsirite = {
        name = "Pinsirite",
        spritenum = 602,
        megaStone = "Pinsir-Mega",
        megaEvolves = "Pinsir",
        itemUser = {"Pinsir"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 671,
        gen = 6,
        isNonstandard = "Past"
    },
    pixieplate = {
        name = "Pixie Plate",
        spritenum = 610,
        onPlate = "Fairy",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move and (move.type == "Fairy") then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Fairy",
        num = 644,
        gen = 6
    },
    plumefossil = {name = "Plume Fossil", spritenum = 339, fling = {basePower = 100}, num = 573, gen = 5, isNonstandard = "Past"},
    poisonbarb = {
        name = "Poison Barb",
        spritenum = 343,
        fling = {basePower = 70, status = "psn"},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Poison" then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 245,
        gen = 2
    },
    poisongem = {
        name = "Poison Gem",
        spritenum = 344,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            if (target == source) or (move.category == "Status") then
                return
            end
            if (move.type == "Poison") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 554,
        gen = 5,
        isNonstandard = "Past"
    },
    poisonmemory = {
        name = "Poison Memory",
        spritenum = 670,
        onMemory = "Poison",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Poison",
        itemUser = {"Silvally-Poison"},
        num = 906,
        gen = 7
    },
    poisoniumz = {name = "Poisonium Z", spritenum = 638, onPlate = "Poison", onTakeItem = false, zMove = true, zMoveType = "Poison", forcedForme = "Arceus-Poison", num = 783, gen = 7, isNonstandard = "Past"},
    pokeball = {name = "Poke Ball", spritenum = 345, num = 4, gen = 1, isPokeball = true},
    pomegberry = {name = "Pomeg Berry", spritenum = 351, isBerry = true, naturalGift = {basePower = 90, type = "Ice"}, onEat = false, num = 169, gen = 3},
    poweranklet = {
        name = "Power Anklet",
        spritenum = 354,
        ignoreKlutz = true,
        fling = {basePower = 70},
        onModifySpe = function(self, spe)
            return self:chainModify(0.5)
        end,
        num = 293,
        gen = 4
    },
    powerband = {
        name = "Power Band",
        spritenum = 355,
        ignoreKlutz = true,
        fling = {basePower = 70},
        onModifySpe = function(self, spe)
            return self:chainModify(0.5)
        end,
        num = 292,
        gen = 4
    },
    powerbelt = {
        name = "Power Belt",
        spritenum = 356,
        ignoreKlutz = true,
        fling = {basePower = 70},
        onModifySpe = function(self, spe)
            return self:chainModify(0.5)
        end,
        num = 290,
        gen = 4
    },
    powerbracer = {
        name = "Power Bracer",
        spritenum = 357,
        ignoreKlutz = true,
        fling = {basePower = 70},
        onModifySpe = function(self, spe)
            return self:chainModify(0.5)
        end,
        num = 289,
        gen = 4
    },
    powerherb = {
        onChargeMove = function(self, pokemon, target, move)
            if pokemon:useItem() then
                self:debug(
                    "power herb - remove charge turn for " .. tostring(move.id)
                )
                self:attrLastMove("[still]")
                self:addMove("-anim", pokemon, move.name, target)
                return false
            end
        end,
        name = "Power Herb",
        spritenum = 358,
        fling = {basePower = 10},
        num = 271,
        gen = 4
    },
    powerlens = {
        name = "Power Lens",
        spritenum = 359,
        ignoreKlutz = true,
        fling = {basePower = 70},
        onModifySpe = function(self, spe)
            return self:chainModify(0.5)
        end,
        num = 291,
        gen = 4
    },
    powerweight = {
        name = "Power Weight",
        spritenum = 360,
        ignoreKlutz = true,
        fling = {basePower = 70},
        onModifySpe = function(self, spe)
            return self:chainModify(0.5)
        end,
        num = 294,
        gen = 4
    },
    premierball = {name = "Premier Ball", spritenum = 363, num = 12, gen = 3, isPokeball = true},
    primariumz = {name = "Primarium Z", spritenum = 652, onTakeItem = false, zMove = "Oceanic Operetta", zMoveFrom = "Sparkling Aria", itemUser = {"Primarina"}, num = 800, gen = 7, isNonstandard = "Past"},
    prismscale = {name = "Prism Scale", spritenum = 365, fling = {basePower = 30}, num = 537, gen = 5},
    protectivepads = {name = "Protective Pads", spritenum = 663, fling = {basePower = 30}, num = 880, gen = 7},
    protector = {name = "Protector", spritenum = 367, fling = {basePower = 80}, num = 321, gen = 4},
    psychicgem = {
        name = "Psychic Gem",
        spritenum = 369,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            if (target == source) or (move.category == "Status") then
                return
            end
            if (move.type == "Psychic") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 557,
        gen = 5,
        isNonstandard = "Past"
    },
    psychicmemory = {
        name = "Psychic Memory",
        spritenum = 680,
        onMemory = "Psychic",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Psychic",
        itemUser = {"Silvally-Psychic"},
        num = 916,
        gen = 7
    },
    psychicseed = {
        name = "Psychic Seed",
        spritenum = 665,
        fling = {basePower = 10},
        onStart = function(self, pokemon)
            if (not pokemon:ignoringItem()) and self.field:isTerrain("psychicterrain") then
                pokemon:useItem()
            end
        end,
        onAnyTerrainStart = function(self)
            local pokemon = self.effectState.target
            if self.field:isTerrain("psychicterrain") then
                pokemon:useItem()
            end
        end,
        boosts = {spd = 1},
        num = 882,
        gen = 7
    },
    psychiumz = {name = "Psychium Z", spritenum = 641, onPlate = "Psychic", onTakeItem = false, zMove = true, zMoveType = "Psychic", forcedForme = "Arceus-Psychic", num = 786, gen = 7, isNonstandard = "Past"},
    qualotberry = {name = "Qualot Berry", spritenum = 371, isBerry = true, naturalGift = {basePower = 90, type = "Poison"}, onEat = false, num = 171, gen = 3},
    quickball = {name = "Quick Ball", spritenum = 372, num = 15, gen = 4, isPokeball = true},
    quickclaw = {
        onFractionalPriorityPriority = -2,
        onFractionalPriority = function(self, priority, pokemon)
            if (priority <= 0) and self:randomChance(1, 5) then
                self:add("-activate", pokemon, "item: Quick Claw")
                return 0.1
            end
        end,
        name = "Quick Claw",
        spritenum = 373,
        fling = {basePower = 80},
        num = 217,
        gen = 2
    },
    quickpowder = {
        name = "Quick Powder",
        spritenum = 374,
        fling = {basePower = 10},
        onModifySpe = function(self, spe, pokemon)
            if (pokemon.species.name == "Ditto") and (not pokemon.transformed) then
                return self:chainModify(2)
            end
        end,
        itemUser = {"Ditto"},
        num = 274,
        gen = 4
    },
    rabutaberry = {name = "Rabuta Berry", spritenum = 375, isBerry = true, naturalGift = {basePower = 90, type = "Ghost"}, onEat = false, num = 177, gen = 3, isNonstandard = "Past"},
    rarebone = {name = "Rare Bone", spritenum = 379, fling = {basePower = 100}, num = 106, gen = 4},
    rawstberry = {
        name = "Rawst Berry",
        spritenum = 381,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Grass"},
        onUpdate = function(self, pokemon)
            if pokemon.status == "brn" then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            if pokemon.status == "brn" then
                pokemon:cureStatus()
            end
        end,
        num = 152,
        gen = 3
    },
    razorclaw = {
        name = "Razor Claw",
        spritenum = 382,
        fling = {basePower = 80},
        onModifyCritRatio = function(self, critRatio)
            return critRatio + 1
        end,
        num = 326,
        gen = 4
    },
    razorfang = {
        name = "Razor Fang",
        spritenum = 383,
        fling = {basePower = 30, volatileStatus = "flinch"},
        onModifyMovePriority = -1,
        onModifyMove = function(self, move)
            if move.category ~= "Status" then
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
        num = 327,
        gen = 4,
        isNonstandard = "Past"
    },
    razzberry = {name = "Razz Berry", spritenum = 384, isBerry = true, naturalGift = {basePower = 80, type = "Steel"}, onEat = false, num = 164, gen = 3, isNonstandard = "Past"},
    reapercloth = {name = "Reaper Cloth", spritenum = 385, fling = {basePower = 10}, num = 325, gen = 4},
    redcard = {
        name = "Red Card",
        spritenum = 387,
        fling = {basePower = 10},
        onAfterMoveSecondary = function(self, target, source, move)
            if ((((source and (source ~= target)) and source.hp) and target.hp) and move) and (move.category ~= "Status") then
                if (((not source.isActive) or (not self:canSwitch(source.side))) or source.forceSwitchFlag) or target.forceSwitchFlag then
                    return
                end
                if target:useItem(source) then
                    if self:runEvent("DragOut", source, target, move) then
                        source.forceSwitchFlag = true
                    end
                end
            end
        end,
        num = 542,
        gen = 5
    },
    redorb = {
        name = "Red Orb",
        spritenum = 390,
        onSwitchIn = function(self, pokemon)
            if pokemon.isActive and (pokemon.baseSpecies.name == "Groudon") then
                self.queue:insertChoice({choice = "runPrimal", pokemon = pokemon})
            end
        end,
        onPrimal = function(self, pokemon)
            pokemon:formeChange("Groudon-Primal", self.effect, true)
        end,
        onTakeItem = function(self, item, source)
            if source.baseSpecies.baseSpecies == "Groudon" then
                return false
            end
            return true
        end,
        itemUser = {"Groudon"},
        num = 534,
        gen = 6,
        isNonstandard = "Past"
    },
    repeatball = {name = "Repeat Ball", spritenum = 401, num = 9, gen = 3, isPokeball = true},
    ribbonsweet = {name = "Ribbon Sweet", spritenum = 710, fling = {basePower = 10}, num = 1115, gen = 8},
    rindoberry = {
        name = "Rindo Berry",
        spritenum = 409,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Grass"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Grass") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 187,
        gen = 4
    },
    ringtarget = {name = "Ring Target", spritenum = 410, fling = {basePower = 10}, onNegateImmunity = false, num = 543, gen = 5},
    rockgem = {
        name = "Rock Gem",
        spritenum = 415,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            if (target == source) or (move.category == "Status") then
                return
            end
            if (move.type == "Rock") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 559,
        gen = 5,
        isNonstandard = "Past"
    },
    rockincense = {
        name = "Rock Incense",
        spritenum = 416,
        fling = {basePower = 10},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Rock" then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 315,
        gen = 4
    },
    rockmemory = {
        name = "Rock Memory",
        spritenum = 672,
        onMemory = "Rock",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Rock",
        itemUser = {"Silvally-Rock"},
        num = 908,
        gen = 7
    },
    rockiumz = {name = "Rockium Z", spritenum = 643, onPlate = "Rock", onTakeItem = false, zMove = true, zMoveType = "Rock", forcedForme = "Arceus-Rock", num = 788, gen = 7, isNonstandard = "Past"},
    rockyhelmet = {
        name = "Rocky Helmet",
        spritenum = 417,
        fling = {basePower = 60},
        onDamagingHitOrder = 2,
        onDamagingHit = function(self, damage, target, source, move)
            if self:checkMoveMakesContact(move, source, target) then
                self:damage(source.baseMaxhp / 6, source, target)
            end
        end,
        num = 540,
        gen = 5
    },
    roomservice = {
        name = "Room Service",
        spritenum = 717,
        fling = {basePower = 100},
        onUpdate = function(self, pokemon)
            if self.field:getPseudoWeather("trickroom") then
                pokemon:useItem()
            end
        end,
        boosts = {spe = -1},
        num = 1122,
        gen = 8
    },
    rootfossil = {name = "Root Fossil", spritenum = 418, fling = {basePower = 100}, num = 99, gen = 3, isNonstandard = "Past"},
    roseincense = {
        name = "Rose Incense",
        spritenum = 419,
        fling = {basePower = 10},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Grass" then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 318,
        gen = 4
    },
    roseliberry = {
        name = "Roseli Berry",
        spritenum = 603,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Fairy"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Fairy") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 686,
        gen = 6
    },
    rowapberry = {
        name = "Rowap Berry",
        spritenum = 420,
        isBerry = true,
        naturalGift = {basePower = 100, type = "Dark"},
        onDamagingHit = function(self, damage, target, source, move)
            if ((move.category == "Special") and source.hp) and source.isActive then
                if target:eatItem() then
                    self:damage(
                        source.baseMaxhp / ((target:hasAbility("ripen") and 4) or 8),
                        source,
                        target
                    )
                end
            end
        end,
        onEat = function(self)
        end,
        num = 212,
        gen = 4
    },
    rustedshield = {
        name = "Rusted Shield",
        spritenum = 699,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 889)) or (pokemon.baseSpecies.num == 889) then
                return false
            end
            return true
        end,
        forcedForme = "Zamazenta-Crowned",
        itemUser = {"Zamazenta-Crowned"},
        num = 1104,
        gen = 8
    },
    rustedsword = {
        name = "Rusted Sword",
        spritenum = 698,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 888)) or (pokemon.baseSpecies.num == 888) then
                return false
            end
            return true
        end,
        forcedForme = "Zacian-Crowned",
        itemUser = {"Zacian-Crowned"},
        num = 1103,
        gen = 8
    },
    sablenite = {
        name = "Sablenite",
        spritenum = 614,
        megaStone = "Sableye-Mega",
        megaEvolves = "Sableye",
        itemUser = {"Sableye"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 754,
        gen = 6,
        isNonstandard = "Past"
    },
    sachet = {name = "Sachet", spritenum = 691, fling = {basePower = 80}, num = 647, gen = 6},
    safariball = {name = "Safari Ball", spritenum = 425, num = 5, gen = 1, isPokeball = true},
    safetygoggles = {
        name = "Safety Goggles",
        spritenum = 604,
        fling = {basePower = 80},
        onImmunity = function(self, ____type, pokemon)
            if ((____type == "sandstorm") or (____type == "hail")) or (____type == "powder") then
                return false
            end
        end,
        onTryHit = function(self, pokemon, source, move)
            if (move.flags.powder and (pokemon ~= source)) and self.dex:getImmunity("powder", pokemon) then
                self:add("-activate", pokemon, "item: Safety Goggles", move.name)
                return nil
            end
        end,
        num = 650,
        gen = 6
    },
    sailfossil = {name = "Sail Fossil", spritenum = 695, fling = {basePower = 100}, num = 711, gen = 6, isNonstandard = "Past"},
    salacberry = {
        name = "Salac Berry",
        spritenum = 426,
        isBerry = true,
        naturalGift = {basePower = 100, type = "Fighting"},
        onUpdate = function(self, pokemon)
            if (pokemon.hp <= (pokemon.maxhp / 4)) or ((pokemon.hp <= (pokemon.maxhp / 2)) and pokemon:hasAbility("gluttony")) then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            self:boost({spe = 1})
        end,
        num = 203,
        gen = 3
    },
    salamencite = {
        name = "Salamencite",
        spritenum = 627,
        megaStone = "Salamence-Mega",
        megaEvolves = "Salamence",
        itemUser = {"Salamence"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 769,
        gen = 6,
        isNonstandard = "Past"
    },
    sceptilite = {
        name = "Sceptilite",
        spritenum = 613,
        megaStone = "Sceptile-Mega",
        megaEvolves = "Sceptile",
        itemUser = {"Sceptile"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 753,
        gen = 6,
        isNonstandard = "Past"
    },
    scizorite = {
        name = "Scizorite",
        spritenum = 605,
        megaStone = "Scizor-Mega",
        megaEvolves = "Scizor",
        itemUser = {"Scizor"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 670,
        gen = 6,
        isNonstandard = "Past"
    },
    scopelens = {
        name = "Scope Lens",
        spritenum = 429,
        fling = {basePower = 30},
        onModifyCritRatio = function(self, critRatio)
            return critRatio + 1
        end,
        num = 232,
        gen = 2
    },
    seaincense = {
        name = "Sea Incense",
        spritenum = 430,
        fling = {basePower = 10},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move and (move.type == "Water") then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 254,
        gen = 3
    },
    sharpbeak = {
        name = "Sharp Beak",
        spritenum = 436,
        fling = {basePower = 50},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move and (move.type == "Flying") then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 244,
        gen = 2
    },
    sharpedonite = {
        name = "Sharpedonite",
        spritenum = 619,
        megaStone = "Sharpedo-Mega",
        megaEvolves = "Sharpedo",
        itemUser = {"Sharpedo"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 759,
        gen = 6,
        isNonstandard = "Past"
    },
    shedshell = {
        name = "Shed Shell",
        spritenum = 437,
        fling = {basePower = 10},
        onTrapPokemonPriority = -10,
        onTrapPokemon = function(self, pokemon)
            pokemon.trapped = (function(o, i, v)
                o[i] = v
                return v
            end)(pokemon, "maybeTrapped", false)
        end,
        num = 295,
        gen = 4
    },
    shellbell = {
        name = "Shell Bell",
        spritenum = 438,
        fling = {basePower = 30},
        onAfterMoveSecondarySelfPriority = -1,
        onAfterMoveSecondarySelf = function(self, pokemon, target, move)
            if move.totalDamage then
                self:heal(move.totalDamage / 8, pokemon)
            end
        end,
        num = 253,
        gen = 3
    },
    shinystone = {name = "Shiny Stone", spritenum = 439, fling = {basePower = 80}, num = 107, gen = 4},
    shockdrive = {
        name = "Shock Drive",
        spritenum = 442,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 649)) or (pokemon.baseSpecies.num == 649) then
                return false
            end
            return true
        end,
        onDrive = "Electric",
        forcedForme = "Genesect-Shock",
        itemUser = {"Genesect-Shock"},
        num = 117,
        gen = 5
    },
    shucaberry = {
        name = "Shuca Berry",
        spritenum = 443,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Ground"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Ground") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 191,
        gen = 4
    },
    silkscarf = {
        name = "Silk Scarf",
        spritenum = 444,
        fling = {basePower = 10},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Normal" then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 251,
        gen = 3
    },
    silverpowder = {
        name = "Silver Powder",
        spritenum = 447,
        fling = {basePower = 10},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Bug" then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 222,
        gen = 2
    },
    sitrusberry = {
        name = "Sitrus Berry",
        spritenum = 448,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Psychic"},
        onUpdate = function(self, pokemon)
            if pokemon.hp <= (pokemon.maxhp / 2) then
                pokemon:eatItem()
            end
        end,
        onTryEatItem = function(self, item, pokemon)
            if not self:runEvent("TryHeal", pokemon) then
                return false
            end
        end,
        onEat = function(self, pokemon)
            self:heal(pokemon.baseMaxhp / 4)
        end,
        num = 158,
        gen = 3
    },
    skullfossil = {name = "Skull Fossil", spritenum = 449, fling = {basePower = 100}, num = 105, gen = 4, isNonstandard = "Past"},
    skyplate = {
        name = "Sky Plate",
        spritenum = 450,
        onPlate = "Flying",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Flying" then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Flying",
        num = 306,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    slowbronite = {
        name = "Slowbronite",
        spritenum = 620,
        megaStone = "Slowbro-Mega",
        megaEvolves = "Slowbro",
        itemUser = {"Slowbro"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 760,
        gen = 6,
        isNonstandard = "Past"
    },
    smoothrock = {name = "Smooth Rock", spritenum = 453, fling = {basePower = 10}, num = 283, gen = 4},
    snorliumz = {name = "Snorlium Z", spritenum = 656, onTakeItem = false, zMove = "Pulverizing Pancake", zMoveFrom = "Giga Impact", itemUser = {"Snorlax"}, num = 804, gen = 7, isNonstandard = "Past"},
    snowball = {
        name = "Snowball",
        spritenum = 606,
        fling = {basePower = 30},
        onDamagingHit = function(self, damage, target, source, move)
            if move.type == "Ice" then
                target:useItem()
            end
        end,
        boosts = {atk = 1},
        num = 649,
        gen = 6
    },
    softsand = {
        name = "Soft Sand",
        spritenum = 456,
        fling = {basePower = 10},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Ground" then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 237,
        gen = 2
    },
    solganiumz = {name = "Solganium Z", spritenum = 685, onTakeItem = false, zMove = "Searing Sunraze Smash", zMoveFrom = "Sunsteel Strike", itemUser = {"Solgaleo", "Necrozma-Dusk-Mane"}, num = 921, gen = 7, isNonstandard = "Past"},
    souldew = {
        name = "Soul Dew",
        spritenum = 459,
        fling = {basePower = 30},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if (move and ((user.baseSpecies.num == 380) or (user.baseSpecies.num == 381))) and ((move.type == "Psychic") or (move.type == "Dragon")) then
                return self:chainModify({4915, 4096})
            end
        end,
        itemUser = {"Latios", "Latias"},
        num = 225,
        gen = 3
    },
    spelltag = {
        name = "Spell Tag",
        spritenum = 461,
        fling = {basePower = 30},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Ghost" then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 247,
        gen = 2
    },
    spelonberry = {name = "Spelon Berry", spritenum = 462, isBerry = true, naturalGift = {basePower = 90, type = "Dark"}, onEat = false, num = 179, gen = 3, isNonstandard = "Past"},
    splashplate = {
        name = "Splash Plate",
        spritenum = 463,
        onPlate = "Water",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Water" then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Water",
        num = 299,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    spookyplate = {
        name = "Spooky Plate",
        spritenum = 464,
        onPlate = "Ghost",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Ghost" then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Ghost",
        num = 310,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    sportball = {name = "Sport Ball", spritenum = 465, num = 499, gen = 2, isPokeball = true},
    starfberry = {
        name = "Starf Berry",
        spritenum = 472,
        isBerry = true,
        naturalGift = {basePower = 100, type = "Psychic"},
        onUpdate = function(self, pokemon)
            if (pokemon.hp <= (pokemon.maxhp / 4)) or ((pokemon.hp <= (pokemon.maxhp / 2)) and pokemon:hasAbility("gluttony")) then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            local stats = {}
            local stat
            for ____value in pairs(pokemon.boosts) do
                stat = ____value
                if ((stat ~= "accuracy") and (stat ~= "evasion")) and (pokemon.boosts[stat] < 6) then
                    __TS__ArrayPush(stats, stat)
                end
            end
            if #stats then
                local randomStat = self:sample(stats)
                local boost = {}
                boost[randomStat] = 2
                self:boost(boost)
            end
        end,
        num = 207,
        gen = 3
    },
    starsweet = {name = "Star Sweet", spritenum = 709, fling = {basePower = 10}, num = 1114, gen = 8},
    steelixite = {
        name = "Steelixite",
        spritenum = 621,
        megaStone = "Steelix-Mega",
        megaEvolves = "Steelix",
        itemUser = {"Steelix"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 761,
        gen = 6,
        isNonstandard = "Past"
    },
    steelgem = {
        name = "Steel Gem",
        spritenum = 473,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            if (target == source) or (move.category == "Status") then
                return
            end
            if (move.type == "Steel") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 563,
        gen = 5,
        isNonstandard = "Past"
    },
    steelmemory = {
        name = "Steel Memory",
        spritenum = 675,
        onMemory = "Steel",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Steel",
        itemUser = {"Silvally-Steel"},
        num = 911,
        gen = 7
    },
    steeliumz = {name = "Steelium Z", spritenum = 647, onPlate = "Steel", onTakeItem = false, zMove = true, zMoveType = "Steel", forcedForme = "Arceus-Steel", num = 792, gen = 7, isNonstandard = "Past"},
    stick = {
        name = "Stick",
        fling = {basePower = 60},
        spritenum = 475,
        onModifyCritRatio = function(self, critRatio, user)
            if self:toID(user.baseSpecies.baseSpecies) == "farfetchd" then
                return critRatio + 2
            end
        end,
        itemUser = {"Farfetch’d"},
        num = 259,
        gen = 2,
        isNonstandard = "Past"
    },
    stickybarb = {
        name = "Sticky Barb",
        spritenum = 476,
        fling = {basePower = 80},
        onResidualOrder = 28,
        onResidualSubOrder = 3,
        onResidual = function(self, pokemon)
            self:damage(pokemon.baseMaxhp / 8)
        end,
        onHit = function(self, target, source, move)
            if (((source and (source ~= target)) and (not source.item)) and move) and self:checkMoveMakesContact(move, source, target) then
                local barb = target:takeItem()
                if not barb then
                    return
                end
                source:setItem(barb)
            end
        end,
        num = 288,
        gen = 4
    },
    stoneplate = {
        name = "Stone Plate",
        spritenum = 477,
        onPlate = "Rock",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Rock" then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Rock",
        num = 309,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    strawberrysweet = {name = "Strawberry Sweet", spritenum = 704, fling = {basePower = 10}, num = 1109, gen = 8},
    sunstone = {name = "Sun Stone", spritenum = 480, fling = {basePower = 30}, num = 80, gen = 2},
    swampertite = {
        name = "Swampertite",
        spritenum = 612,
        megaStone = "Swampert-Mega",
        megaEvolves = "Swampert",
        itemUser = {"Swampert"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 752,
        gen = 6,
        isNonstandard = "Past"
    },
    sweetapple = {name = "Sweet Apple", spritenum = 711, fling = {basePower = 30}, num = 1116, gen = 8},
    tamatoberry = {name = "Tamato Berry", spritenum = 486, isBerry = true, naturalGift = {basePower = 90, type = "Psychic"}, onEat = false, num = 174, gen = 3},
    tangaberry = {
        name = "Tanga Berry",
        spritenum = 487,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Bug"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Bug") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 194,
        gen = 4
    },
    tapuniumz = {name = "Tapunium Z", spritenum = 653, onTakeItem = false, zMove = "Guardian of Alola", zMoveFrom = "Nature's Madness", itemUser = {"Tapu Koko", "Tapu Lele", "Tapu Bulu", "Tapu Fini"}, num = 801, gen = 7, isNonstandard = "Past"},
    tartapple = {name = "Tart Apple", spritenum = 712, fling = {basePower = 30}, num = 1117, gen = 8},
    terrainextender = {name = "Terrain Extender", spritenum = 662, fling = {basePower = 60}, num = 879, gen = 7},
    thickclub = {
        name = "Thick Club",
        spritenum = 491,
        fling = {basePower = 90},
        onModifyAtkPriority = 1,
        onModifyAtk = function(self, atk, pokemon)
            if (pokemon.baseSpecies.baseSpecies == "Cubone") or (pokemon.baseSpecies.baseSpecies == "Marowak") then
                return self:chainModify(2)
            end
        end,
        itemUser = {"Marowak", "Cubone"},
        num = 258,
        gen = 2
    },
    throatspray = {
        name = "Throat Spray",
        spritenum = 713,
        fling = {basePower = 30},
        onAfterMoveSecondarySelf = function(self, target, source, move)
            if move.flags.sound then
                target:useItem()
            end
        end,
        boosts = {spa = 1},
        num = 1118,
        gen = 8
    },
    thunderstone = {name = "Thunder Stone", spritenum = 492, fling = {basePower = 30}, num = 83, gen = 1},
    timerball = {name = "Timer Ball", spritenum = 494, num = 10, gen = 3, isPokeball = true},
    toxicorb = {
        name = "Toxic Orb",
        spritenum = 515,
        fling = {basePower = 30, status = "tox"},
        onResidualOrder = 28,
        onResidualSubOrder = 3,
        onResidual = function(self, pokemon)
            pokemon:trySetStatus("tox", pokemon)
        end,
        num = 272,
        gen = 4
    },
    toxicplate = {
        name = "Toxic Plate",
        spritenum = 516,
        onPlate = "Poison",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Poison" then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Poison",
        num = 304,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    tr00 = {name = "TR00", fling = {basePower = 10}, spritenum = 721, num = 1130, gen = 8},
    tr01 = {name = "TR01", fling = {basePower = 85}, spritenum = 721, num = 1131, gen = 8},
    tr02 = {name = "TR02", fling = {basePower = 90}, spritenum = 730, num = 1132, gen = 8},
    tr03 = {name = "TR03", fling = {basePower = 110}, spritenum = 731, num = 1133, gen = 8},
    tr04 = {name = "TR04", fling = {basePower = 90}, spritenum = 731, num = 1134, gen = 8},
    tr05 = {name = "TR05", fling = {basePower = 90}, spritenum = 735, num = 1135, gen = 8},
    tr06 = {name = "TR06", fling = {basePower = 110}, spritenum = 735, num = 1136, gen = 8},
    tr07 = {name = "TR07", fling = {basePower = 10}, spritenum = 722, num = 1137, gen = 8},
    tr08 = {name = "TR08", fling = {basePower = 90}, spritenum = 733, num = 1138, gen = 8},
    tr09 = {name = "TR09", fling = {basePower = 110}, spritenum = 733, num = 1139, gen = 8},
    tr10 = {name = "TR10", fling = {basePower = 100}, spritenum = 725, num = 1140, gen = 8},
    tr11 = {name = "TR11", fling = {basePower = 90}, spritenum = 734, num = 1141, gen = 8},
    tr12 = {name = "TR12", fling = {basePower = 10}, spritenum = 734, num = 1142, gen = 8},
    tr13 = {name = "TR13", fling = {basePower = 10}, spritenum = 721, num = 1143, gen = 8},
    tr14 = {name = "TR14", fling = {basePower = 10}, spritenum = 721, num = 1144, gen = 8},
    tr15 = {name = "TR15", fling = {basePower = 110}, spritenum = 730, num = 1145, gen = 8},
    tr16 = {name = "TR16", fling = {basePower = 80}, spritenum = 731, num = 1146, gen = 8},
    tr17 = {name = "TR17", fling = {basePower = 10}, spritenum = 734, num = 1147, gen = 8},
    tr18 = {name = "TR18", fling = {basePower = 80}, spritenum = 727, num = 1148, gen = 8},
    tr19 = {name = "TR19", fling = {basePower = 80}, spritenum = 721, num = 1149, gen = 8},
    tr20 = {name = "TR20", fling = {basePower = 10}, spritenum = 721, num = 1150, gen = 8},
    tr21 = {name = "TR21", fling = {basePower = 10}, spritenum = 722, num = 1151, gen = 8},
    tr22 = {name = "TR22", fling = {basePower = 90}, spritenum = 724, num = 1152, gen = 8},
    tr23 = {name = "TR23", fling = {basePower = 10}, spritenum = 725, num = 1153, gen = 8},
    tr24 = {name = "TR24", fling = {basePower = 120}, spritenum = 736, num = 1154, gen = 8},
    tr25 = {name = "TR25", fling = {basePower = 80}, spritenum = 734, num = 1155, gen = 8},
    tr26 = {name = "TR26", fling = {basePower = 10}, spritenum = 721, num = 1156, gen = 8},
    tr27 = {name = "TR27", fling = {basePower = 10}, spritenum = 721, num = 1157, gen = 8},
    tr28 = {name = "TR28", fling = {basePower = 120}, spritenum = 727, num = 1158, gen = 8},
    tr29 = {name = "TR29", fling = {basePower = 10}, spritenum = 721, num = 1159, gen = 8},
    tr30 = {name = "TR30", fling = {basePower = 10}, spritenum = 721, num = 1160, gen = 8},
    tr31 = {name = "TR31", fling = {basePower = 100}, spritenum = 729, num = 1161, gen = 8},
    tr32 = {name = "TR32", fling = {basePower = 80}, spritenum = 737, num = 1162, gen = 8},
    tr33 = {name = "TR33", fling = {basePower = 80}, spritenum = 728, num = 1163, gen = 8},
    tr34 = {name = "TR34", fling = {basePower = 120}, spritenum = 734, num = 1164, gen = 8},
    tr35 = {name = "TR35", fling = {basePower = 90}, spritenum = 721, num = 1165, gen = 8},
    tr36 = {name = "TR36", fling = {basePower = 95}, spritenum = 730, num = 1166, gen = 8},
    tr37 = {name = "TR37", fling = {basePower = 10}, spritenum = 737, num = 1167, gen = 8},
    tr38 = {name = "TR38", fling = {basePower = 10}, spritenum = 734, num = 1168, gen = 8},
    tr39 = {name = "TR39", fling = {basePower = 120}, spritenum = 722, num = 1169, gen = 8},
    tr40 = {name = "TR40", fling = {basePower = 10}, spritenum = 734, num = 1170, gen = 8},
    tr41 = {name = "TR41", fling = {basePower = 85}, spritenum = 730, num = 1171, gen = 8},
    tr42 = {name = "TR42", fling = {basePower = 90}, spritenum = 721, num = 1172, gen = 8},
    tr43 = {name = "TR43", fling = {basePower = 130}, spritenum = 730, num = 1173, gen = 8},
    tr44 = {name = "TR44", fling = {basePower = 10}, spritenum = 734, num = 1174, gen = 8},
    tr45 = {name = "TR45", fling = {basePower = 90}, spritenum = 731, num = 1175, gen = 8},
    tr46 = {name = "TR46", fling = {basePower = 10}, spritenum = 729, num = 1176, gen = 8},
    tr47 = {name = "TR47", fling = {basePower = 80}, spritenum = 736, num = 1177, gen = 8},
    tr48 = {name = "TR48", fling = {basePower = 10}, spritenum = 722, num = 1178, gen = 8},
    tr49 = {name = "TR49", fling = {basePower = 10}, spritenum = 734, num = 1179, gen = 8},
    tr50 = {name = "TR50", fling = {basePower = 90}, spritenum = 732, num = 1180, gen = 8},
    tr51 = {name = "TR51", fling = {basePower = 10}, spritenum = 736, num = 1181, gen = 8},
    tr52 = {name = "TR52", fling = {basePower = 10}, spritenum = 729, num = 1182, gen = 8},
    tr53 = {name = "TR53", fling = {basePower = 120}, spritenum = 722, num = 1183, gen = 8},
    tr54 = {name = "TR54", fling = {basePower = 10}, spritenum = 724, num = 1184, gen = 8},
    tr55 = {name = "TR55", fling = {basePower = 120}, spritenum = 730, num = 1185, gen = 8},
    tr56 = {name = "TR56", fling = {basePower = 80}, spritenum = 722, num = 1186, gen = 8},
    tr57 = {name = "TR57", fling = {basePower = 80}, spritenum = 724, num = 1187, gen = 8},
    tr58 = {name = "TR58", fling = {basePower = 80}, spritenum = 737, num = 1188, gen = 8},
    tr59 = {name = "TR59", fling = {basePower = 80}, spritenum = 732, num = 1189, gen = 8},
    tr60 = {name = "TR60", fling = {basePower = 80}, spritenum = 727, num = 1190, gen = 8},
    tr61 = {name = "TR61", fling = {basePower = 90}, spritenum = 727, num = 1191, gen = 8},
    tr62 = {name = "TR62", fling = {basePower = 85}, spritenum = 736, num = 1192, gen = 8},
    tr63 = {name = "TR63", fling = {basePower = 80}, spritenum = 726, num = 1193, gen = 8},
    tr64 = {name = "TR64", fling = {basePower = 120}, spritenum = 722, num = 1194, gen = 8},
    tr65 = {name = "TR65", fling = {basePower = 90}, spritenum = 732, num = 1195, gen = 8},
    tr66 = {name = "TR66", fling = {basePower = 120}, spritenum = 723, num = 1196, gen = 8},
    tr67 = {name = "TR67", fling = {basePower = 90}, spritenum = 725, num = 1197, gen = 8},
    tr68 = {name = "TR68", fling = {basePower = 10}, spritenum = 737, num = 1198, gen = 8},
    tr69 = {name = "TR69", fling = {basePower = 80}, spritenum = 734, num = 1199, gen = 8},
    tr70 = {name = "TR70", fling = {basePower = 80}, spritenum = 729, num = 1200, gen = 8},
    tr71 = {name = "TR71", fling = {basePower = 130}, spritenum = 732, num = 1201, gen = 8},
    tr72 = {name = "TR72", fling = {basePower = 120}, spritenum = 732, num = 1202, gen = 8},
    tr73 = {name = "TR73", fling = {basePower = 120}, spritenum = 724, num = 1203, gen = 8},
    tr74 = {name = "TR74", fling = {basePower = 80}, spritenum = 729, num = 1204, gen = 8},
    tr75 = {name = "TR75", fling = {basePower = 100}, spritenum = 726, num = 1205, gen = 8},
    tr76 = {name = "TR76", fling = {basePower = 10}, spritenum = 726, num = 1206, gen = 8},
    tr77 = {name = "TR77", fling = {basePower = 10}, spritenum = 732, num = 1207, gen = 8},
    tr78 = {name = "TR78", fling = {basePower = 95}, spritenum = 724, num = 1208, gen = 8},
    tr79 = {name = "TR79", fling = {basePower = 10}, spritenum = 729, num = 1209, gen = 8},
    tr80 = {name = "TR80", fling = {basePower = 10}, spritenum = 733, num = 1210, gen = 8},
    tr81 = {name = "TR81", fling = {basePower = 95}, spritenum = 737, num = 1211, gen = 8},
    tr82 = {name = "TR82", fling = {basePower = 20}, spritenum = 734, num = 1212, gen = 8},
    tr83 = {name = "TR83", fling = {basePower = 10}, spritenum = 734, num = 1213, gen = 8},
    tr84 = {name = "TR84", fling = {basePower = 80}, spritenum = 731, num = 1214, gen = 8},
    tr85 = {name = "TR85", fling = {basePower = 10}, spritenum = 721, num = 1215, gen = 8},
    tr86 = {name = "TR86", fling = {basePower = 90}, spritenum = 733, num = 1216, gen = 8},
    tr87 = {name = "TR87", fling = {basePower = 80}, spritenum = 725, num = 1217, gen = 8},
    tr88 = {name = "TR88", fling = {basePower = 10}, spritenum = 730, num = 1218, gen = 8},
    tr89 = {name = "TR89", fling = {basePower = 110}, spritenum = 723, num = 1219, gen = 8},
    tr90 = {name = "TR90", fling = {basePower = 90}, spritenum = 738, num = 1220, gen = 8},
    tr91 = {name = "TR91", fling = {basePower = 10}, spritenum = 724, num = 1221, gen = 8},
    tr92 = {name = "TR92", fling = {basePower = 80}, spritenum = 738, num = 1222, gen = 8},
    tr93 = {name = "TR93", fling = {basePower = 85}, spritenum = 737, num = 1223, gen = 8},
    tr94 = {name = "TR94", fling = {basePower = 95}, spritenum = 725, num = 1224, gen = 8},
    tr95 = {name = "TR95", fling = {basePower = 80}, spritenum = 737, num = 1225, gen = 8},
    tr96 = {name = "TR96", fling = {basePower = 90}, spritenum = 727, num = 1226, gen = 8},
    tr97 = {name = "TR97", fling = {basePower = 85}, spritenum = 734, num = 1227, gen = 8},
    tr98 = {name = "TR98", fling = {basePower = 85}, spritenum = 731, num = 1228, gen = 8},
    tr99 = {name = "TR99", fling = {basePower = 80}, spritenum = 722, num = 1229, gen = 8},
    twistedspoon = {
        name = "Twisted Spoon",
        spritenum = 520,
        fling = {basePower = 30},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Psychic" then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 248,
        gen = 2
    },
    tyranitarite = {
        name = "Tyranitarite",
        spritenum = 607,
        megaStone = "Tyranitar-Mega",
        megaEvolves = "Tyranitar",
        itemUser = {"Tyranitar"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 669,
        gen = 6,
        isNonstandard = "Past"
    },
    ultraball = {name = "Ultra Ball", spritenum = 521, num = 2, gen = 1, isPokeball = true},
    ultranecroziumz = {name = "Ultranecrozium Z", spritenum = 687, onTakeItem = false, zMove = "Light That Burns the Sky", zMoveFrom = "Photon Geyser", itemUser = {"Necrozma-Ultra"}, num = 923, gen = 7, isNonstandard = "Past"},
    upgrade = {name = "Up-Grade", spritenum = 523, fling = {basePower = 30}, num = 252, gen = 2},
    utilityumbrella = {name = "Utility Umbrella", spritenum = 718, fling = {basePower = 60}, num = 1123, gen = 8},
    venusaurite = {
        name = "Venusaurite",
        spritenum = 608,
        megaStone = "Venusaur-Mega",
        megaEvolves = "Venusaur",
        itemUser = {"Venusaur"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = 659,
        gen = 6,
        isNonstandard = "Past"
    },
    wacanberry = {
        name = "Wacan Berry",
        spritenum = 526,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Electric"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Electric") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 186,
        gen = 4
    },
    watergem = {
        name = "Water Gem",
        spritenum = 528,
        isGem = true,
        onSourceTryPrimaryHit = function(self, target, source, move)
            local pledges = {"firepledge", "grasspledge", "waterpledge"}
            if ((target == source) or (move.category == "Status")) or pledges:includes(move.id) then
                return
            end
            if (move.type == "Water") and source:useItem() then
                source:addVolatile("gem")
            end
        end,
        num = 549,
        gen = 5,
        isNonstandard = "Past"
    },
    watermemory = {
        name = "Water Memory",
        spritenum = 677,
        onMemory = "Water",
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 773)) or (pokemon.baseSpecies.num == 773) then
                return false
            end
            return true
        end,
        forcedForme = "Silvally-Water",
        itemUser = {"Silvally-Water"},
        num = 913,
        gen = 7
    },
    waterstone = {name = "Water Stone", spritenum = 529, fling = {basePower = 30}, num = 84, gen = 1},
    wateriumz = {name = "Waterium Z", spritenum = 633, onPlate = "Water", onTakeItem = false, zMove = true, zMoveType = "Water", forcedForme = "Arceus-Water", num = 778, gen = 7, isNonstandard = "Past"},
    watmelberry = {name = "Watmel Berry", spritenum = 530, isBerry = true, naturalGift = {basePower = 100, type = "Fire"}, onEat = false, num = 181, gen = 3, isNonstandard = "Past"},
    waveincense = {
        name = "Wave Incense",
        spritenum = 531,
        fling = {basePower = 10},
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Water" then
                return self:chainModify({4915, 4096})
            end
        end,
        num = 317,
        gen = 4
    },
    weaknesspolicy = {
        name = "Weakness Policy",
        spritenum = 609,
        fling = {basePower = 80},
        onDamagingHit = function(self, damage, target, source, move)
            if ((not move.damage) and (not move.damageCallback)) and (target:getMoveHitData(move).typeMod > 0) then
                target:useItem()
            end
        end,
        boosts = {atk = 2, spa = 2},
        num = 639,
        gen = 6
    },
    wepearberry = {name = "Wepear Berry", spritenum = 533, isBerry = true, naturalGift = {basePower = 90, type = "Electric"}, onEat = false, num = 167, gen = 3, isNonstandard = "Past"},
    whippeddream = {name = "Whipped Dream", spritenum = 692, fling = {basePower = 80}, num = 646, gen = 6},
    whiteherb = {
        name = "White Herb",
        spritenum = 535,
        fling = {
            basePower = 10,
            effect = function(self, pokemon)
                local activate = false
                local boosts = {}
                local i
                for ____value in pairs(pokemon.boosts) do
                    i = ____value
                    if pokemon.boosts[i] < 0 then
                        activate = true
                        boosts[i] = 0
                    end
                end
                if activate then
                    pokemon:setBoost(boosts)
                    self:add("-clearnegativeboost", pokemon, "[silent]")
                end
            end
        },
        onUpdate = function(self, pokemon)
            local activate = false
            local boosts = {}
            local i
            for ____value in pairs(pokemon.boosts) do
                i = ____value
                if pokemon.boosts[i] < 0 then
                    activate = true
                    boosts[i] = 0
                end
            end
            if activate and pokemon:useItem() then
                pokemon:setBoost(boosts)
                self:add("-clearnegativeboost", pokemon, "[silent]")
            end
        end,
        num = 214,
        gen = 3
    },
    widelens = {
        name = "Wide Lens",
        spritenum = 537,
        fling = {basePower = 10},
        onSourceModifyAccuracyPriority = -2,
        onSourceModifyAccuracy = function(self, accuracy)
            if type(accuracy) == "number" then
                return self:chainModify({4505, 4096})
            end
        end,
        num = 265,
        gen = 4
    },
    wikiberry = {
        name = "Wiki Berry",
        spritenum = 538,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Rock"},
        onUpdate = function(self, pokemon)
            if (pokemon.hp <= (pokemon.maxhp / 4)) or ((pokemon.hp <= (pokemon.maxhp / 2)) and pokemon:hasAbility("gluttony")) then
                pokemon:eatItem()
            end
        end,
        onTryEatItem = function(self, item, pokemon)
            if not self:runEvent("TryHeal", pokemon) then
                return false
            end
        end,
        onEat = function(self, pokemon)
            self:heal(pokemon.baseMaxhp * 0.33)
            if pokemon:getNature().minus == "spa" then
                pokemon:addVolatile("confusion")
            end
        end,
        num = 160,
        gen = 3
    },
    wiseglasses = {
        name = "Wise Glasses",
        spritenum = 539,
        fling = {basePower = 10},
        onBasePowerPriority = 16,
        onBasePower = function(self, basePower, user, target, move)
            if move.category == "Special" then
                return self:chainModify({4505, 4096})
            end
        end,
        num = 267,
        gen = 4
    },
    yacheberry = {
        name = "Yache Berry",
        spritenum = 567,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Ice"},
        onSourceModifyDamage = function(self, damage, source, target, move)
            if (move.type == "Ice") and (target:getMoveHitData(move).typeMod > 0) then
                local hitSub = (target.volatiles.substitute and (not move.flags.authentic)) and (not (move.infiltrates and (self.gen >= 6)))
                if hitSub then
                    return
                end
                if target:eatItem() then
                    self:debug("-50% reduction")
                    self:add("-enditem", target, self.effect, "[weaken]")
                    return self:chainModify(0.5)
                end
            end
        end,
        onEat = function(self)
        end,
        num = 188,
        gen = 4
    },
    zapplate = {
        name = "Zap Plate",
        spritenum = 572,
        onPlate = "Electric",
        onBasePowerPriority = 15,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Electric" then
                return self:chainModify({4915, 4096})
            end
        end,
        onTakeItem = function(self, item, pokemon, source)
            if (source and (source.baseSpecies.num == 493)) or (pokemon.baseSpecies.num == 493) then
                return false
            end
            return true
        end,
        forcedForme = "Arceus-Electric",
        num = 300,
        gen = 4,
        isNonstandard = "Unobtainable"
    },
    zoomlens = {
        name = "Zoom Lens",
        spritenum = 574,
        fling = {basePower = 10},
        onSourceModifyAccuracyPriority = -2,
        onSourceModifyAccuracy = function(self, accuracy, target)
            if (type(accuracy) == "number") and (not self.queue:willMove(target)) then
                self:debug("Zoom Lens boosting accuracy")
                return self:chainModify({4915, 4096})
            end
        end,
        num = 276,
        gen = 4
    },
    berserkgene = {
        name = "Berserk Gene",
        spritenum = 388,
        onUpdate = function(self, pokemon)
            self:boost({atk = 2})
            pokemon:addVolatile("confusion")
            pokemon:setItem("")
        end,
        num = 0,
        gen = 2,
        isNonstandard = "Past"
    },
    berry = {
        name = "Berry",
        spritenum = 319,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Poison"},
        onResidualOrder = 5,
        onResidual = function(self, pokemon)
            if pokemon.hp <= (pokemon.maxhp / 2) then
                pokemon:eatItem()
            end
        end,
        onTryEatItem = function(self, item, pokemon)
            if not self:runEvent("TryHeal", pokemon) then
                return false
            end
        end,
        onEat = function(self, pokemon)
            self:heal(10)
        end,
        num = 155,
        gen = 2,
        isNonstandard = "Past"
    },
    bitterberry = {
        name = "Bitter Berry",
        spritenum = 334,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Ground"},
        onUpdate = function(self, pokemon)
            if pokemon.volatiles.confusion then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            pokemon:removeVolatile("confusion")
        end,
        num = 156,
        gen = 2,
        isNonstandard = "Past"
    },
    burntberry = {
        name = "Burnt Berry",
        spritenum = 13,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Ice"},
        onUpdate = function(self, pokemon)
            if pokemon.status == "frz" then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            if pokemon.status == "frz" then
                pokemon:cureStatus()
            end
        end,
        num = 153,
        gen = 2,
        isNonstandard = "Past"
    },
    goldberry = {
        name = "Gold Berry",
        spritenum = 448,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Psychic"},
        onResidualOrder = 5,
        onResidual = function(self, pokemon)
            if pokemon.hp <= (pokemon.maxhp / 2) then
                pokemon:eatItem()
            end
        end,
        onTryEatItem = function(self, item, pokemon)
            if not self:runEvent("TryHeal", pokemon) then
                return false
            end
        end,
        onEat = function(self, pokemon)
            self:heal(30)
        end,
        num = 158,
        gen = 2,
        isNonstandard = "Past"
    },
    iceberry = {
        name = "Ice Berry",
        spritenum = 381,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Grass"},
        onUpdate = function(self, pokemon)
            if pokemon.status == "brn" then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            if pokemon.status == "brn" then
                pokemon:cureStatus()
            end
        end,
        num = 152,
        gen = 2,
        isNonstandard = "Past"
    },
    mintberry = {
        name = "Mint Berry",
        spritenum = 65,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Water"},
        onUpdate = function(self, pokemon)
            if pokemon.status == "slp" then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            if pokemon.status == "slp" then
                pokemon:cureStatus()
            end
        end,
        num = 150,
        gen = 2,
        isNonstandard = "Past"
    },
    miracleberry = {
        name = "Miracle Berry",
        spritenum = 262,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Flying"},
        onUpdate = function(self, pokemon)
            if pokemon.status or pokemon.volatiles.confusion then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            pokemon:cureStatus()
            pokemon:removeVolatile("confusion")
        end,
        num = 157,
        gen = 2,
        isNonstandard = "Past"
    },
    mysteryberry = {
        name = "Mystery Berry",
        spritenum = 244,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Fighting"},
        onUpdate = function(self, pokemon)
            if not pokemon.hp then
                return
            end
            local moveSlot = pokemon.lastMove and pokemon:getMoveData(pokemon.lastMove.id)
            if moveSlot and (moveSlot.pp == 0) then
                pokemon:addVolatile("leppaberry")
                pokemon.volatiles.leppaberry.moveSlot = moveSlot
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            local moveSlot
            if pokemon.volatiles.leppaberry then
                moveSlot = pokemon.volatiles.leppaberry.moveSlot
                pokemon:removeVolatile("leppaberry")
            else
                local pp = 99
                for ____, possibleMoveSlot in __TS__Iterator(pokemon.moveSlots) do
                    if possibleMoveSlot.pp < pp then
                        moveSlot = possibleMoveSlot
                        pp = moveSlot.pp
                    end
                end
            end
            moveSlot.pp = moveSlot.pp + 5
            if moveSlot.pp > moveSlot.maxpp then
                moveSlot.pp = moveSlot.maxpp
            end
            self:add("-activate", pokemon, "item: Mystery Berry", moveSlot.move)
        end,
        num = 154,
        gen = 2,
        isNonstandard = "Past"
    },
    pinkbow = {
        name = "Pink Bow",
        spritenum = 444,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Normal" then
                return basePower * 1.1
            end
        end,
        num = 251,
        gen = 2,
        isNonstandard = "Past"
    },
    polkadotbow = {
        name = "Polkadot Bow",
        spritenum = 444,
        onBasePower = function(self, basePower, user, target, move)
            if move.type == "Normal" then
                return basePower * 1.1
            end
        end,
        num = 251,
        gen = 2,
        isNonstandard = "Past"
    },
    przcureberry = {
        name = "PRZ Cure Berry",
        spritenum = 63,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Fire"},
        onUpdate = function(self, pokemon)
            if pokemon.status == "par" then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            if pokemon.status == "par" then
                pokemon:cureStatus()
            end
        end,
        num = 149,
        gen = 2,
        isNonstandard = "Past"
    },
    psncureberry = {
        name = "PSN Cure Berry",
        spritenum = 333,
        isBerry = true,
        naturalGift = {basePower = 80, type = "Electric"},
        onUpdate = function(self, pokemon)
            if (pokemon.status == "psn") or (pokemon.status == "tox") then
                pokemon:eatItem()
            end
        end,
        onEat = function(self, pokemon)
            if (pokemon.status == "psn") or (pokemon.status == "tox") then
                pokemon:cureStatus()
            end
        end,
        num = 151,
        gen = 2,
        isNonstandard = "Past"
    }
}

____exports.CAPitems = {
    crucibellite = {
        name = "Crucibellite",
        spritenum = 577,
        megaStone = "Crucibelle-Mega",
        megaEvolves = "Crucibelle",
        itemUser = {"Crucibelle"},
        onTakeItem = function(self, item, source)
            if item.megaEvolves == source.baseSpecies.baseSpecies then
                return false
            end
            return true
        end,
        num = -1,
        gen = 6,
        isNonstandard = "CAP"
    }
}

return ____exports
