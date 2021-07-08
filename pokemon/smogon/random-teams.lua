--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____dex = require("sim.dex")
local Dex = ____dex.Dex
local toID = ____dex.toID
local ____lib = require("lib.index")
local Utils = ____lib.Utils
local ____prng = require("sim.prng")
local PRNG = ____prng.PRNG
____exports.MoveCounter = __TS__Class()
local MoveCounter = ____exports.MoveCounter
MoveCounter.name = "MoveCounter"
__TS__ClassExtends(MoveCounter, Utils.Multiset)
function MoveCounter.prototype.____constructor(self)
    MoveCounter.____super.prototype.____constructor(self)
    self.damagingMoves = __TS__New(Set)
    self.setupType = ""
end
function MoveCounter.prototype.get(self, key)
    return MoveCounter.____super.prototype.get(self, key) or 0
end
local RecoveryMove = {"healorder", "milkdrink", "moonlight", "morningsun", "recover", "roost", "shoreup", "slackoff", "softboiled", "strengthsap", "synthesis"}
local ContraryMoves = {"closecombat", "leafstorm", "overheat", "superpower", "vcreate"}
local PhysicalSetup = {"bellydrum", "bulkup", "coil", "curse", "dragondance", "honeclaws", "howl", "poweruppunch", "swordsdance"}
local SpecialSetup = {"calmmind", "chargebeam", "geomancy", "nastyplot", "quiverdance", "tailglow"}
local MixedSetup = {"clangoroussoul", "growth", "happyhour", "holdhands", "noretreat", "shellsmash", "workup"}
local SpeedSetup = {"agility", "autotomize", "flamecharge", "rockpolish"}
local NoStab = {"accelerock", "aquajet", "beakblast", "bounce", "breakingswipe", "chatter", "clearsmog", "dragontail", "eruption", "explosion", "fakeout", "firstimpression", "flamecharge", "flipturn", "iceshard", "icywind", "incinerate", "machpunch", "meteorbeam", "pluck", "pursuit", "quickattack", "reversal", "selfdestruct", "skydrop", "snarl", "suckerpunch", "uturn", "watershuriken", "vacuumwave", "voltswitch", "waterspout"}
local Hazards = {"spikes", "stealthrock", "stickyweb", "toxicspikes"}
____exports.RandomTeams = __TS__Class()
local RandomTeams = ____exports.RandomTeams
RandomTeams.name = "RandomTeams"
function RandomTeams.prototype.____constructor(self, format, prng)
    self.randomCAP1v1Sets = require(_G, "./cap-1v1-sets.json")
    self.randomBSSFactorySets = require(_G, "./bss-factory-sets.json")
    format = Dex.formats:get(format)
    self.dex = Dex:forFormat(format)
    self.gen = self.dex.gen
    local ruleTable = Dex.formats:getRuleTable(format)
    self.maxTeamSize = ruleTable.maxTeamSize
    self.forceMonotype = ruleTable.valueRules:get("forcemonotype")
    self.factoryTier = ""
    self.format = format
    self.prng = (((prng and (not __TS__ArrayIsArray(prng))) and (function() return prng end)) or (function() return __TS__New(PRNG, prng) end))()
    self.moveEnforcementCheckers = {
        screens = function(____, movePool, moves, abilities, types, counter, species, teamDetails)
            if teamDetails.screens then
                return false
            end
            return (moves:has("lightscreen") and movePool:includes("reflect")) or (moves:has("reflect") and movePool:includes("lightscreen"))
        end,
        recovery = function(____, movePool, moves, abilities, types, counter, species, teamDetails) return (((not (not counter:get("Status"))) and (not counter.setupType)) and __TS__ArraySome(
            {"morningsun", "recover", "roost", "slackoff", "softboiled"},
            function(____, moveid) return movePool:includes(moveid) end
        )) and __TS__ArrayEvery(
            {"healingwish", "switcheroo", "trick", "trickroom"},
            function(____, moveid) return not moves:has(moveid) end
        ) end,
        misc = function(____, movePool, moves, abilities, types, counter, species, teamDetails)
            if movePool:includes("milkdrink") or movePool:includes("quiverdance") then
                return true
            end
            return (movePool:includes("stickyweb") and (not counter.setupType)) and (not teamDetails.stickyWeb)
        end,
        lead = function(____, movePool, moves, abilities, types, counter) return (((movePool:includes("stealthrock") and (not (not counter:get("Status")))) and (not counter.setupType)) and (not counter:get("speedsetup"))) and (not moves:has("substitute")) end,
        leechseed = function(____, movePool, moves) return (not moves:has("calmmind")) and __TS__ArraySome(
            {"protect", "substitute", "spikyshield"},
            function(____, m) return movePool:includes(m) end
        ) end,
        Bug = function(____, movePool) return movePool:includes("megahorn") end,
        Dark = function(____, movePool, moves, abilities, types, counter)
            if not counter:get("Dark") then
                return true
            end
            return moves:has("suckerpunch") and (movePool:includes("knockoff") or movePool:includes("wickedblow"))
        end,
        Dragon = function(____, movePool, moves, abilities, types, counter) return (((not counter:get("Dragon")) and (not moves:has("dragonascent"))) and (not moves:has("substitute"))) and (not (moves:has("rest") and moves:has("sleeptalk"))) end,
        Electric = function(____, movePool, moves, abilities, types, counter) return (not counter:get("Electric")) or movePool:includes("thunder") end,
        Fairy = function(____, movePool, moves, abilities, types, counter) return (not counter:get("Fairy")) and __TS__ArraySome(
            {"dazzlinggleam", "moonblast", "fleurcannon", "playrough", "strangesteam"},
            function(____, moveid) return movePool:includes(moveid) end
        ) end,
        Fighting = function(____, movePool, moves, abilities, types, counter) return (not counter:get("Fighting")) or (not counter:get("stab")) end,
        Fire = function(____, movePool, moves, abilities, types, counter, species)
            local enteiException = moves:has("extremespeed") and (species.id == "entei")
            return (not moves:has("bellydrum")) and ((not counter:get("Fire")) or ((not enteiException) and movePool:includes("flareblitz")))
        end,
        Flying = function(____, movePool, moves, abilities, types, counter) return ((not counter:get("Flying")) and (not types:has("Dragon"))) and __TS__ArraySome(
            {"airslash", "bravebird", "dualwingbeat", "oblivionwing"},
            function(____, moveid) return movePool:includes(moveid) end
        ) end,
        Ghost = function(____, movePool, moves, abilities, types, counter)
            if (not counter:get("Ghost")) and (not types:has("Dark")) then
                return true
            end
            if movePool:includes("poltergeist") then
                return true
            end
            return movePool:includes("spectralthief") and (not counter:get("Dark"))
        end,
        Grass = function(____, movePool, moves, abilities, types, counter, species)
            if movePool:includes("leafstorm") or movePool:includes("grassyglide") then
                return true
            end
            return (not counter:get("Grass")) and (species.baseStats.atk >= 100)
        end,
        Ground = function(____, movePool, moves, abilities, types, counter) return not counter:get("Ground") end,
        Ice = function(____, movePool, moves, abilities, types, counter)
            if not counter:get("Ice") then
                return true
            end
            if movePool:includes("iciclecrash") then
                return true
            end
            return abilities:has("Snow Warning") and movePool:includes("blizzard")
        end,
        Normal = function(____, movePool, moves, abilities, types, counter) return (abilities:has("Guts") and movePool:includes("facade")) or (abilities:has("Pixilate") and (not counter:get("Normal"))) end,
        Poison = function(____, movePool, moves, abilities, types, counter)
            if counter:get("Poison") then
                return false
            end
            return ((types:has("Ground") or types:has("Psychic")) or (not (not counter.setupType))) or movePool:includes("gunkshot")
        end,
        Psychic = function(____, movePool, moves, abilities, types, counter)
            if counter:get("Psychic") then
                return false
            end
            if types:has("Ghost") or types:has("Steel") then
                return false
            end
            return (abilities:has("Psychic Surge") or (not (not counter.setupType))) or movePool:includes("psychicfangs")
        end,
        Rock = function(____, movePool, moves, abilities, types, counter, species) return (not counter:get("Rock")) and (species.baseStats.atk >= 80) end,
        Steel = function(____, movePool, moves, abilities, types, counter, species)
            if species.baseStats.atk < 95 then
                return false
            end
            if movePool:includes("meteormash") then
                return true
            end
            return not counter:get("Steel")
        end,
        Water = function(____, movePool, moves, abilities, types, counter, species)
            if (not counter:get("Water")) and (not moves:has("hypervoice")) then
                return true
            end
            if movePool:includes("hypervoice") or movePool:includes("liquidation") then
                return true
            end
            return abilities:has("Huge Power") and movePool:includes("aquajet")
        end
    }
end
function RandomTeams.prototype.setSeed(self, prng)
    self.prng = (((prng and (not __TS__ArrayIsArray(prng))) and (function() return prng end)) or (function() return __TS__New(PRNG, prng) end))()
end
function RandomTeams.prototype.getTeam(self, options)
    local generatorName = ((((type(self.format.team) == "string") and self.format.team:startsWith("random")) and (function() return tostring(self.format.team) .. "Team" end)) or (function() return "" end))()
    return self[generatorName or "randomTeam"](self, options)
end
function RandomTeams.prototype.randomChance(self, numerator, denominator)
    return self.prng:randomChance(numerator, denominator)
end
function RandomTeams.prototype.sample(self, items)
    return self.prng:sample(items)
end
function RandomTeams.prototype.sampleIfArray(self, item)
    if __TS__ArrayIsArray(item) then
        return self:sample(item)
    end
    return item
end
function RandomTeams.prototype.random(self, m, n)
    return self.prng:next(m, n)
end
function RandomTeams.prototype.fastPop(self, list, index)
    local length = #list
    if (index < 0) or (index >= #list) then
        error(
            __TS__New(
                Error,
                ("Index " .. tostring(index)) .. " out of bounds for given array"
            ),
            0
        )
    end
    local element = list[index + 1]
    list[index + 1] = list[length]
    table.remove(list)
    return element
end
function RandomTeams.prototype.sampleNoReplace(self, list)
    local length = #list
    local index = self:random(length)
    return self:fastPop(list, index)
end
function RandomTeams.prototype.multipleSamplesNoReplace(self, list, n)
    local samples = {}
    while (#samples < n) and #list do
        __TS__ArrayPush(
            samples,
            self:sampleNoReplace(list)
        )
    end
    return samples
end
function RandomTeams.prototype.unrejectableMovesInSingles(self, move)
    return ((move.category ~= "Status") or (not move.flags.heal)) and (not ({"facade", "leechseed", "lightscreen", "reflect", "sleeptalk", "spore", "substitute", "switcheroo", "teleport", "toxic", "trick"}):includes(move.id))
end
function RandomTeams.prototype.unrejectableMovesInDoubles(self, move)
    return move.id ~= "bodypress"
end
function RandomTeams.prototype.randomCCTeam(self)
    local dex = self.dex
    local team = {}
    local natures = __TS__ObjectKeys(self.dex.data.Natures)
    local items = __TS__ObjectKeys(self.dex.data.Items)
    local randomN = self:randomNPokemon(self.maxTeamSize, self.forceMonotype)
    for ____, forme in ipairs(randomN) do
        local species = dex.species:get(forme)
        if species.isNonstandard then
            species = dex.species:get(species.baseSpecies)
        end
        local item = ""
        if self.gen >= 2 then
            repeat
                do
                    item = self:sample(items)
                end
            until not ((self.dex.items:get(item).gen > self.gen) or self.dex.data.Items[item].isNonstandard)
        end
        if species.battleOnly then
            if type(species.battleOnly) == "string" then
                species = dex.species:get(species.battleOnly)
            else
                species = dex.species:get(
                    self:sample(species.battleOnly)
                )
            end
            forme = species.name
        elseif species.requiredItems and (not species.requiredItems:some(
            function(____, req) return toID(_G, req) == item end
        )) then
            if not species.changesFrom then
                error(
                    __TS__New(
                        Error,
                        tostring(species.name) .. " needs a changesFrom value"
                    ),
                    0
                )
            end
            species = dex.species:get(species.changesFrom)
            forme = species.name
        end
        local itemData = self.dex.items:get(item)
        if itemData.forcedForme and (forme == self.dex.species:get(itemData.forcedForme).baseSpecies) then
            repeat
                do
                    item = self:sample(items)
                    itemData = self.dex.items:get(item)
                end
            until not (((itemData.gen > self.gen) or itemData.isNonstandard) or (itemData.forcedForme and (forme == self.dex.species:get(itemData.forcedForme).baseSpecies)))
        end
        local abilities = __TS__ObjectValues(species.abilities):filter(
            function(____, a) return self.dex.abilities:get(a).gen <= self.gen end
        )
        local ability = ((self.gen <= 2) and "None") or self:sample(abilities)
        local pool = {"struggle"}
        if forme == "Smeargle" then
            pool = __TS__ArrayFilter(
                __TS__ObjectKeys(self.dex.data.Moves),
                function(____, moveid)
                    local move = self.dex.data.Moves[moveid]
                    return not (((move.isNonstandard or move.isZ) or move.isMax) or move.realMove)
                end
            )
        else
            local formes = {"gastrodoneast", "pumpkaboosuper", "zygarde10"}
            local learnset = (((self.dex.data.Learnsets[species.id].learnset and (not formes:includes(species.id))) and (function() return self.dex.data.Learnsets[species.id].learnset end)) or (function() return self.dex.data.Learnsets[self.dex.species:get(species.baseSpecies).id].learnset end))()
            if learnset then
                pool = __TS__ArrayFilter(
                    __TS__ObjectKeys(learnset),
                    function(____, moveid) return learnset[moveid]:find(
                        function(____, learned) return learned:startsWith(
                            String(_G, self.gen)
                        ) end
                    ) end
                )
            end
            if species.changesFrom then
                learnset = self.dex.data.Learnsets[toID(_G, species.changesFrom)].learnset
                local basePool = __TS__ArrayFilter(
                    __TS__ObjectKeys(learnset),
                    function(____, moveid) return learnset[moveid]:find(
                        function(____, learned) return learned:startsWith(
                            String(_G, self.gen)
                        ) end
                    ) end
                )
                pool = {
                    __TS__Spread(
                        __TS__New(
                            Set,
                            __TS__ArrayConcat(pool, basePool)
                        )
                    )
                }
            end
        end
        local moves = self:multipleSamplesNoReplace(pool, 4)
        local evs = {hp = 0, atk = 0, def = 0, spa = 0, spd = 0, spe = 0}
        local s = {"hp", "atk", "def", "spa", "spd", "spe"}
        local evpool = 510
        repeat
            do
                local x = self:sample(s)
                local y = self:random(
                    math.min(256 - evs[x], evpool + 1)
                )
                evs[x] = evs[x] + y
                evpool = evpool - y
            end
        until not (evpool > 0)
        local ivs = {
            hp = self:random(32),
            atk = self:random(32),
            def = self:random(32),
            spa = self:random(32),
            spd = self:random(32),
            spe = self:random(32)
        }
        local nature = self:sample(natures)
        local mbstmin = 1307
        local stats = species.baseStats
        if species.baseSpecies == "Wishiwashi" then
            stats = Dex.species:get("wishiwashischool").baseStats
        end
        local mbst = ((((stats.hp * 2) + 31) + 21) + 100) + 10
        mbst = mbst + (((((stats.atk * 2) + 31) + 21) + 100) + 5)
        mbst = mbst + (((((stats.def * 2) + 31) + 21) + 100) + 5)
        mbst = mbst + (((((stats.spa * 2) + 31) + 21) + 100) + 5)
        mbst = mbst + (((((stats.spd * 2) + 31) + 21) + 100) + 5)
        mbst = mbst + (((((stats.spe * 2) + 31) + 21) + 100) + 5)
        local level = math.floor((100 * mbstmin) / mbst)
        while level < 100 do
            mbst = math.floor(((((((stats.hp * 2) + 31) + 21) + 100) * level) / 100) + 10)
            mbst = mbst + math.floor(((((((((stats.atk * 2) + 31) + 21) + 100) * level) / 100) + 5) * level) / 100)
            mbst = mbst + math.floor(((((((stats.def * 2) + 31) + 21) + 100) * level) / 100) + 5)
            mbst = mbst + math.floor(((((((((stats.spa * 2) + 31) + 21) + 100) * level) / 100) + 5) * level) / 100)
            mbst = mbst + math.floor(((((((stats.spd * 2) + 31) + 21) + 100) * level) / 100) + 5)
            mbst = mbst + math.floor(((((((stats.spe * 2) + 31) + 21) + 100) * level) / 100) + 5)
            if mbst >= mbstmin then
                break
            end
            level = level + 1
        end
        local happiness = self:random(256)
        local shiny = self:randomChance(1, 1024)
        __TS__ArrayPush(team, {name = species.baseSpecies, species = species.name, gender = species.gender, item = item, ability = ability, moves = moves, evs = evs, ivs = ivs, nature = nature, level = level, happiness = happiness, shiny = shiny})
    end
    return team
end
function RandomTeams.prototype.randomNPokemon(self, n, requiredType, minSourceGen)
    local last = ({0, 151, 251, 386, 493, 649, 721, 807, 890})[self.gen + 1]
    if (n <= 0) or (n > last) then
        error(
            __TS__New(
                Error,
                ((("n must be a number between 1 and " .. tostring(last)) .. " (got ") .. tostring(n)) .. ")"
            ),
            0
        )
    end
    if requiredType and (not self.dex.types:get(requiredType).exists) then
        error(
            __TS__New(Error, ("\"" .. requiredType) .. "\" is not a valid type."),
            0
        )
    end
    local pool = {}
    for id in pairs(self.dex.data.FormatsData) do
        do
            if (not self.dex.data.Pokedex[id]) or (self.dex.data.FormatsData[id].isNonstandard and (self.dex.data.FormatsData[id].isNonstandard ~= "Unobtainable")) then
                goto __continue92
            end
            if requiredType and (not self.dex.data.Pokedex[id].types:includes(requiredType)) then
                goto __continue92
            end
            if minSourceGen and ((self.dex.data.Pokedex[id].gen or 8) < minSourceGen) then
                goto __continue92
            end
            local num = self.dex.data.Pokedex[id].num
            if (num <= 0) or pool:includes(num) then
                goto __continue92
            end
            if num > last then
                break
            end
            __TS__ArrayPush(pool, num)
        end
        ::__continue92::
    end
    local hasDexNumber = {}
    do
        local i = 0
        while i < n do
            local num = self:sampleNoReplace(pool)
            hasDexNumber[num] = i
            i = i + 1
        end
    end
    local formes = {}
    for id in pairs(self.dex.data.Pokedex) do
        do
            if not (hasDexNumber[self.dex.data.Pokedex[id].num] ~= nil) then
                goto __continue99
            end
            local species = self.dex.species:get(id)
            if (species.gen <= self.gen) and ((not species.isNonstandard) or (species.isNonstandard == "Unobtainable")) then
                if not formes[hasDexNumber[species.num] + 1] then
                    formes[hasDexNumber[species.num] + 1] = {}
                end
                __TS__ArrayPush(formes[hasDexNumber[species.num] + 1], species.name)
            end
        end
        ::__continue99::
    end
    local nPokemon = {}
    do
        local i = 0
        while i < n do
            if not #formes[i + 1] then
                error(
                    __TS__New(
                        Error,
                        (((("Invalid pokemon gen " .. tostring(self.gen)) .. ": ") .. JSON:stringify(formes)) .. " numbers ") .. JSON:stringify(hasDexNumber)
                    ),
                    0
                )
            end
            __TS__ArrayPush(
                nPokemon,
                self:sample(formes[i + 1])
            )
            i = i + 1
        end
    end
    return nPokemon
end
function RandomTeams.prototype.randomHCTeam(self)
    local team = {}
    local itemPool = __TS__ObjectKeys(self.dex.data.Items)
    local abilityPool = __TS__ObjectKeys(self.dex.data.Abilities)
    local movePool = __TS__ObjectKeys(self.dex.data.Moves)
    local naturePool = __TS__ObjectKeys(self.dex.data.Natures)
    local randomN = self:randomNPokemon(self.maxTeamSize, self.forceMonotype)
    for ____, forme in ipairs(randomN) do
        local species = self.dex.species:get(forme)
        local item = ""
        if self.gen >= 2 then
            repeat
                do
                    item = self:sampleNoReplace(itemPool)
                end
            until not ((self.dex.items:get(item).gen > self.gen) or self.dex.data.Items[item].isNonstandard)
        end
        local ability = "None"
        if self.gen >= 3 then
            repeat
                do
                    ability = self:sampleNoReplace(abilityPool)
                end
            until not ((self.dex.abilities:get(ability).gen > self.gen) or self.dex.data.Abilities[ability].isNonstandard)
        end
        local m = {}
        repeat
            do
                local moveid = self:sampleNoReplace(movePool)
                local move = self.dex.moves:get(moveid)
                if ((move.gen <= self.gen) and (not move.isNonstandard)) and (not move.name:startsWith("Hidden Power ")) then
                    __TS__ArrayPush(m, moveid)
                end
            end
        until not (#m < 4)
        local evs = {hp = 0, atk = 0, def = 0, spa = 0, spd = 0, spe = 0}
        if self.gen == 6 then
            local evpool = 510
            repeat
                do
                    local x = self:sample(
                        Dex.stats:ids()
                    )
                    local y = self:random(
                        math.min(256 - evs[x], evpool + 1)
                    )
                    evs[x] = evs[x] + y
                    evpool = evpool - y
                end
            until not (evpool > 0)
        else
            for ____, x in ipairs(
                Dex.stats:ids()
            ) do
                evs[x] = self:random(256)
            end
        end
        local ivs = {
            hp = self:random(32),
            atk = self:random(32),
            def = self:random(32),
            spa = self:random(32),
            spd = self:random(32),
            spe = self:random(32)
        }
        local nature = self:sample(naturePool)
        local mbstmin = 1307
        local stats = species.baseStats
        local mbst = ((((stats.hp * 2) + 31) + 21) + 100) + 10
        mbst = mbst + (((((stats.atk * 2) + 31) + 21) + 100) + 5)
        mbst = mbst + (((((stats.def * 2) + 31) + 21) + 100) + 5)
        mbst = mbst + (((((stats.spa * 2) + 31) + 21) + 100) + 5)
        mbst = mbst + (((((stats.spd * 2) + 31) + 21) + 100) + 5)
        mbst = mbst + (((((stats.spe * 2) + 31) + 21) + 100) + 5)
        local level = math.floor((100 * mbstmin) / mbst)
        while level < 100 do
            mbst = math.floor(((((((stats.hp * 2) + 31) + 21) + 100) * level) / 100) + 10)
            mbst = mbst + math.floor(((((((((stats.atk * 2) + 31) + 21) + 100) * level) / 100) + 5) * level) / 100)
            mbst = mbst + math.floor(((((((stats.def * 2) + 31) + 21) + 100) * level) / 100) + 5)
            mbst = mbst + math.floor(((((((((stats.spa * 2) + 31) + 21) + 100) * level) / 100) + 5) * level) / 100)
            mbst = mbst + math.floor(((((((stats.spd * 2) + 31) + 21) + 100) * level) / 100) + 5)
            mbst = mbst + math.floor(((((((stats.spe * 2) + 31) + 21) + 100) * level) / 100) + 5)
            if mbst >= mbstmin then
                break
            end
            level = level + 1
        end
        local happiness = self:random(256)
        local shiny = self:randomChance(1, 1024)
        __TS__ArrayPush(team, {name = species.baseSpecies, species = species.name, gender = species.gender, item = item, ability = ability, moves = m, evs = evs, ivs = ivs, nature = nature, level = level, happiness = happiness, shiny = shiny})
    end
    return team
end
function RandomTeams.prototype.queryMoves(self, moves, types, abilities, movePool)
    if abilities == nil then
        abilities = __TS__New(Set)
    end
    if movePool == nil then
        movePool = {}
    end
    local counter = __TS__New(____exports.MoveCounter)
    if not moves.size then
        return counter
    end
    local categories = {Physical = 0, Special = 0, Status = 0}
    for ____, moveid in __TS__Iterator(moves) do
        local move = self.dex.moves:get(moveid)
        if move.id == "naturepower" then
            if self.gen == 5 then
                move = self.dex.moves:get("earthquake")
            end
        end
        local moveType = move.type
        if ({"judgment", "multiattack", "revelationdance"}):includes(moveid) then
            moveType = types[1]
        end
        if move.damage or move.damageCallback then
            counter:add("damage")
            counter.damagingMoves:add(move)
        else
            local ____obj, ____index = categories, move.category
            ____obj[____index] = ____obj[____index] + 1
        end
        if (moveid == "lowkick") or ((move.basePower and (move.basePower <= 60)) and (moveid ~= "rapidspin")) then
            counter:add("technician")
        end
        if (move.multihit and __TS__ArrayIsArray(move.multihit)) and (move.multihit[1] == 5) then
            counter:add("skilllink")
        end
        if move.recoil or move.hasCrashDamage then
            counter:add("recoil")
        end
        if move.drain then
            counter:add("drain")
        end
        if (((move.basePower > 30) or move.multihit) or move.basePowerCallback) or (moveid == "infestation") then
            counter:add(moveType)
            if types:includes(moveType) then
                if (not NoStab:includes(moveid)) and ((not moveid:startsWith("hiddenpower")) or (#types == 1)) then
                    counter:add("stab")
                    local ____obj, ____index = categories, move.category
                    ____obj[____index] = ____obj[____index] + 0.1
                end
            elseif (((moveType == "Normal") and __TS__ArraySome(
                {"Aerilate", "Galvanize", "Pixilate", "Refrigerate"},
                function(____, abil) return abilities:has(abil) end
            )) or (((move.priority == 0) and (abilities:has("Libero") or abilities:has("Protean"))) and (not NoStab:includes(moveid)))) or ((moveType == "Steel") and abilities:has("Steelworker")) then
                counter:add("stab")
            end
            if move.flags.bite then
                counter:add("strongjaw")
            end
            if move.flags.punch then
                counter:add("ironfist")
            end
            if move.flags.sound then
                counter:add("sound")
            end
            if (move.priority ~= 0) or ((moveid == "grassyglide") and abilities:has("Grassy Surge")) then
                counter:add("priority")
            end
            counter.damagingMoves:add(move)
        end
        if move.secondary then
            counter:add("sheerforce")
            if (move.secondary.chance and (move.secondary.chance >= 20)) and (move.secondary.chance < 100) then
                counter:add("serenegrace")
            end
        end
        if (move.accuracy and (move.accuracy ~= true)) and (move.accuracy < 90) then
            counter:add("inaccurate")
        end
        if RecoveryMove:includes(moveid) then
            counter:add("recovery")
        end
        if ContraryMoves:includes(moveid) then
            counter:add("contrary")
        end
        if PhysicalSetup:includes(moveid) then
            counter:add("physicalsetup")
            counter.setupType = "Physical"
        elseif SpecialSetup:includes(moveid) then
            counter:add("specialsetup")
            counter.setupType = "Special"
        end
        if MixedSetup:includes(moveid) then
            counter:add("mixedsetup")
        end
        if SpeedSetup:includes(moveid) then
            counter:add("speedsetup")
        end
        if Hazards:includes(moveid) then
            counter:add("hazards")
        end
    end
    for ____, moveid in ipairs(movePool) do
        do
            local move = self.dex.moves:get(moveid)
            if move.damageCallback then
                goto __continue150
            end
            if move.category == "Physical" then
                counter:add("physicalpool")
            end
            if move.category == "Special" then
                counter:add("specialpool")
            end
        end
        ::__continue150::
    end
    if counter:get("mixedsetup") then
        counter.setupType = "Mixed"
    elseif counter:get("physicalsetup") and counter:get("specialsetup") then
        local pool = {
            Physical = categories.Physical + counter:get("physicalpool"),
            Special = categories.Special + counter:get("specialpool")
        }
        if pool.Physical == pool.Special then
            if categories.Physical > categories.Special then
                counter.setupType = "Physical"
            end
            if categories.Special > categories.Physical then
                counter.setupType = "Special"
            end
        else
            counter.setupType = ((pool.Physical > pool.Special) and "Physical") or "Special"
        end
    elseif counter.setupType == "Physical" then
        if ((categories.Physical < 2) and ((not counter:get("stab")) or (not counter:get("physicalpool")))) and (not (moves:has("rest") and moves:has("sleeptalk"))) then
            counter.setupType = ""
        end
    elseif counter.setupType == "Special" then
        if (((categories.Special < 2) and ((not counter:get("stab")) or (not counter:get("specialpool")))) and (not (moves:has("rest") and moves:has("sleeptalk")))) and (not (moves:has("wish") and moves:has("protect"))) then
            counter.setupType = ""
        end
    end
    counter:set(
        "Physical",
        math.floor(categories.Physical)
    )
    counter:set(
        "Special",
        math.floor(categories.Special)
    )
    counter:set("Status", categories.Status)
    return counter
end
function RandomTeams.prototype.shouldCullMove(self, move, types, moves, abilities, counter, movePool, teamDetails, species, isLead, isDoubles, isNoDynamax)
    if (isDoubles and (species.baseStats.def >= 140)) and movePool:includes("bodypress") then
        return {cull = true}
    end
    if ((((species.id == "doublade") and movePool:includes("swordsdance")) or ((species.id == "entei") and movePool:includes("extremespeed"))) or ((species.id == "genesectdouse") and movePool:includes("technoblast"))) or (((species.id == "golisopod") and movePool:includes("leechlife")) and movePool:includes("firstimpression")) then
        return {cull = true}
    end
    local hasRestTalk = moves:has("rest") and moves:has("sleeptalk")
    local ____switch167 = move.id
    local bulkySetup, webs, substituteCullCondition, preferHJKOverCCCullCondition, setup, sneakIncompatible, cullInDoubles, bugSwordsDanceCase, otherMoves, diggersbyCull, otherFireMoves, celebiPreferLeafStorm, leafBladePossible, betterIceMove, preferThunderWave, turtonatorPressCull, pressIncompatible, doublesCull, turtQuakeCull, subToxicPossible, noctowlCase, alcremieCase, sylveonCase, gutsCullCondition, rockSlidePlusStatusPossible, otherRockMove, pulseIncompatible, shiftryCase, toxicCullCondition, moveBasedCull, doublesGourgeist, calmMindCullCondition, eiscue
    if ____switch167 == "acrobatics" then
        goto ____switch167_case_0
    elseif ____switch167 == "junglehealing" then
        goto ____switch167_case_1
    elseif ____switch167 == "dualwingbeat" then
        goto ____switch167_case_2
    elseif ____switch167 == "fly" then
        goto ____switch167_case_3
    elseif ____switch167 == "healbell" then
        goto ____switch167_case_4
    elseif ____switch167 == "fireblast" then
        goto ____switch167_case_5
    elseif ____switch167 == "firepunch" then
        goto ____switch167_case_6
    elseif ____switch167 == "flamecharge" then
        goto ____switch167_case_7
    elseif ____switch167 == "hypervoice" then
        goto ____switch167_case_8
    elseif ____switch167 == "payback" then
        goto ____switch167_case_9
    elseif ____switch167 == "psychocut" then
        goto ____switch167_case_10
    elseif ____switch167 == "rest" then
        goto ____switch167_case_11
    elseif ____switch167 == "sleeptalk" then
        goto ____switch167_case_12
    elseif ____switch167 == "storedpower" then
        goto ____switch167_case_13
    elseif ____switch167 == "switcheroo" then
        goto ____switch167_case_14
    elseif ____switch167 == "trick" then
        goto ____switch167_case_15
    elseif ____switch167 == "trickroom" then
        goto ____switch167_case_16
    elseif ____switch167 == "zenheadbutt" then
        goto ____switch167_case_17
    elseif ____switch167 == "bellydrum" then
        goto ____switch167_case_18
    elseif ____switch167 == "bulkup" then
        goto ____switch167_case_19
    elseif ____switch167 == "coil" then
        goto ____switch167_case_20
    elseif ____switch167 == "curse" then
        goto ____switch167_case_21
    elseif ____switch167 == "dragondance" then
        goto ____switch167_case_22
    elseif ____switch167 == "honeclaws" then
        goto ____switch167_case_23
    elseif ____switch167 == "swordsdance" then
        goto ____switch167_case_24
    elseif ____switch167 == "calmmind" then
        goto ____switch167_case_25
    elseif ____switch167 == "nastyplot" then
        goto ____switch167_case_26
    elseif ____switch167 == "quiverdance" then
        goto ____switch167_case_27
    elseif ____switch167 == "clangoroussoul" then
        goto ____switch167_case_28
    elseif ____switch167 == "shellsmash" then
        goto ____switch167_case_29
    elseif ____switch167 == "workup" then
        goto ____switch167_case_30
    elseif ____switch167 == "agility" then
        goto ____switch167_case_31
    elseif ____switch167 == "autotomize" then
        goto ____switch167_case_32
    elseif ____switch167 == "rockpolish" then
        goto ____switch167_case_33
    elseif ____switch167 == "shiftgear" then
        goto ____switch167_case_34
    elseif ____switch167 == "coaching" then
        goto ____switch167_case_35
    elseif ____switch167 == "counter" then
        goto ____switch167_case_36
    elseif ____switch167 == "reversal" then
        goto ____switch167_case_37
    elseif ____switch167 == "bulletpunch" then
        goto ____switch167_case_38
    elseif ____switch167 == "extremespeed" then
        goto ____switch167_case_39
    elseif ____switch167 == "rockblast" then
        goto ____switch167_case_40
    elseif ____switch167 == "closecombat" then
        goto ____switch167_case_41
    elseif ____switch167 == "flashcannon" then
        goto ____switch167_case_42
    elseif ____switch167 == "pollenpuff" then
        goto ____switch167_case_43
    elseif ____switch167 == "defog" then
        goto ____switch167_case_44
    elseif ____switch167 == "fakeout" then
        goto ____switch167_case_45
    elseif ____switch167 == "firstimpression" then
        goto ____switch167_case_46
    elseif ____switch167 == "glare" then
        goto ____switch167_case_47
    elseif ____switch167 == "icywind" then
        goto ____switch167_case_48
    elseif ____switch167 == "tailwind" then
        goto ____switch167_case_49
    elseif ____switch167 == "waterspout" then
        goto ____switch167_case_50
    elseif ____switch167 == "healingwish" then
        goto ____switch167_case_51
    elseif ____switch167 == "memento" then
        goto ____switch167_case_52
    elseif ____switch167 == "highjumpkick" then
        goto ____switch167_case_53
    elseif ____switch167 == "partingshot" then
        goto ____switch167_case_54
    elseif ____switch167 == "protect" then
        goto ____switch167_case_55
    elseif ____switch167 == "rapidspin" then
        goto ____switch167_case_56
    elseif ____switch167 == "shadowsneak" then
        goto ____switch167_case_57
    elseif ____switch167 == "spikes" then
        goto ____switch167_case_58
    elseif ____switch167 == "stealthrock" then
        goto ____switch167_case_59
    elseif ____switch167 == "stickyweb" then
        goto ____switch167_case_60
    elseif ____switch167 == "taunt" then
        goto ____switch167_case_61
    elseif ____switch167 == "thunderwave" then
        goto ____switch167_case_62
    elseif ____switch167 == "voltswitch" then
        goto ____switch167_case_63
    elseif ____switch167 == "toxic" then
        goto ____switch167_case_64
    elseif ____switch167 == "toxicspikes" then
        goto ____switch167_case_65
    elseif ____switch167 == "uturn" then
        goto ____switch167_case_66
    elseif ____switch167 == "explosion" then
        goto ____switch167_case_67
    elseif ____switch167 == "facade" then
        goto ____switch167_case_68
    elseif ____switch167 == "quickattack" then
        goto ____switch167_case_69
    elseif ____switch167 == "blazekick" then
        goto ____switch167_case_70
    elseif ____switch167 == "blueflare" then
        goto ____switch167_case_71
    elseif ____switch167 == "firefang" then
        goto ____switch167_case_72
    elseif ____switch167 == "flamethrower" then
        goto ____switch167_case_73
    elseif ____switch167 == "flareblitz" then
        goto ____switch167_case_74
    elseif ____switch167 == "overheat" then
        goto ____switch167_case_75
    elseif ____switch167 == "aquatail" then
        goto ____switch167_case_76
    elseif ____switch167 == "flipturn" then
        goto ____switch167_case_77
    elseif ____switch167 == "retaliate" then
        goto ____switch167_case_78
    elseif ____switch167 == "hydropump" then
        goto ____switch167_case_79
    elseif ____switch167 == "scald" then
        goto ____switch167_case_80
    elseif ____switch167 == "thunderbolt" then
        goto ____switch167_case_81
    elseif ____switch167 == "energyball" then
        goto ____switch167_case_82
    elseif ____switch167 == "gigadrain" then
        goto ____switch167_case_83
    elseif ____switch167 == "leafblade" then
        goto ____switch167_case_84
    elseif ____switch167 == "leafstorm" then
        goto ____switch167_case_85
    elseif ____switch167 == "powerwhip" then
        goto ____switch167_case_86
    elseif ____switch167 == "woodhammer" then
        goto ____switch167_case_87
    elseif ____switch167 == "freezedry" then
        goto ____switch167_case_88
    elseif ____switch167 == "bodypress" then
        goto ____switch167_case_89
    elseif ____switch167 == "circlethrow" then
        goto ____switch167_case_90
    elseif ____switch167 == "drainpunch" then
        goto ____switch167_case_91
    elseif ____switch167 == "dynamicpunch" then
        goto ____switch167_case_92
    elseif ____switch167 == "thunderouskick" then
        goto ____switch167_case_93
    elseif ____switch167 == "focusblast" then
        goto ____switch167_case_94
    elseif ____switch167 == "hammerarm" then
        goto ____switch167_case_95
    elseif ____switch167 == "stormthrow" then
        goto ____switch167_case_96
    elseif ____switch167 == "superpower" then
        goto ____switch167_case_97
    elseif ____switch167 == "poisonjab" then
        goto ____switch167_case_98
    elseif ____switch167 == "earthquake" then
        goto ____switch167_case_99
    elseif ____switch167 == "scorchingsands" then
        goto ____switch167_case_100
    elseif ____switch167 == "airslash" then
        goto ____switch167_case_101
    elseif ____switch167 == "bravebird" then
        goto ____switch167_case_102
    elseif ____switch167 == "hurricane" then
        goto ____switch167_case_103
    elseif ____switch167 == "futuresight" then
        goto ____switch167_case_104
    elseif ____switch167 == "photongeyser" then
        goto ____switch167_case_105
    elseif ____switch167 == "psychic" then
        goto ____switch167_case_106
    elseif ____switch167 == "psychicfangs" then
        goto ____switch167_case_107
    elseif ____switch167 == "psyshock" then
        goto ____switch167_case_108
    elseif ____switch167 == "bugbuzz" then
        goto ____switch167_case_109
    elseif ____switch167 == "leechlife" then
        goto ____switch167_case_110
    elseif ____switch167 == "stoneedge" then
        goto ____switch167_case_111
    elseif ____switch167 == "poltergeist" then
        goto ____switch167_case_112
    elseif ____switch167 == "shadowball" then
        goto ____switch167_case_113
    elseif ____switch167 == "shadowclaw" then
        goto ____switch167_case_114
    elseif ____switch167 == "dragonpulse" then
        goto ____switch167_case_115
    elseif ____switch167 == "spacialrend" then
        goto ____switch167_case_116
    elseif ____switch167 == "darkpulse" then
        goto ____switch167_case_117
    elseif ____switch167 == "suckerpunch" then
        goto ____switch167_case_118
    elseif ____switch167 == "dazzlinggleam" then
        goto ____switch167_case_119
    elseif ____switch167 == "bodyslam" then
        goto ____switch167_case_120
    elseif ____switch167 == "clearsmog" then
        goto ____switch167_case_121
    elseif ____switch167 == "haze" then
        goto ____switch167_case_122
    elseif ____switch167 == "hypnosis" then
        goto ____switch167_case_123
    elseif ____switch167 == "willowisp" then
        goto ____switch167_case_124
    elseif ____switch167 == "yawn" then
        goto ____switch167_case_125
    elseif ____switch167 == "painsplit" then
        goto ____switch167_case_126
    elseif ____switch167 == "recover" then
        goto ____switch167_case_127
    elseif ____switch167 == "synthesis" then
        goto ____switch167_case_128
    elseif ____switch167 == "roost" then
        goto ____switch167_case_129
    elseif ____switch167 == "reflect" then
        goto ____switch167_case_130
    elseif ____switch167 == "lightscreen" then
        goto ____switch167_case_131
    elseif ____switch167 == "slackoff" then
        goto ____switch167_case_132
    elseif ____switch167 == "substitute" then
        goto ____switch167_case_133
    elseif ____switch167 == "helpinghand" then
        goto ____switch167_case_134
    elseif ____switch167 == "wideguard" then
        goto ____switch167_case_135
    elseif ____switch167 == "grassknot" then
        goto ____switch167_case_136
    elseif ____switch167 == "icepunch" then
        goto ____switch167_case_137
    elseif ____switch167 == "leechseed" then
        goto ____switch167_case_138
    end
    goto ____switch167_end
    ::____switch167_case_0::
    do
    end
    ::____switch167_case_1::
    do
        return {
            cull = (species.id:startsWith("rillaboom") and isLead) or ((not isDoubles) and (not counter.setupType))
        }
    end
    ::____switch167_case_2::
    do
    end
    ::____switch167_case_3::
    do
        return {
            cull = ((not types:has(move.type)) and (not counter.setupType)) and (not (not counter:get("Status")))
        }
    end
    ::____switch167_case_4::
    do
        return {
            cull = movePool:includes("protect") or movePool:includes("wish")
        }
    end
    ::____switch167_case_5::
    do
        return {
            cull = abilities:has("Serene Grace") and ((not moves:has("trick")) or (counter:get("Status") > 1))
        }
    end
    ::____switch167_case_6::
    do
        return {
            cull = movePool:includes("bellydrum") or (moves:has("earthquake") and movePool:includes("substitute"))
        }
    end
    ::____switch167_case_7::
    do
        return {
            cull = movePool:includes("swordsdance")
        }
    end
    ::____switch167_case_8::
    do
        return {
            cull = types:has("Electric") and movePool:includes("thunderbolt")
        }
    end
    ::____switch167_case_9::
    do
    end
    ::____switch167_case_10::
    do
        return {
            cull = (not counter:get("Status")) or hasRestTalk
        }
    end
    ::____switch167_case_11::
    do
        bulkySetup = (not moves:has("sleeptalk")) and __TS__ArraySome(
            {"bulkup", "calmmind", "coil", "curse"},
            function(____, m) return movePool:includes(m) end
        )
        return {
            cull = (species.id ~= "registeel") and (movePool:includes("sleeptalk") or bulkySetup)
        }
    end
    ::____switch167_case_12::
    do
        if not moves:has("rest") then
            return {cull = true}
        end
        if (#movePool > 1) and (not abilities:has("Contrary")) then
            local rest = __TS__ArrayIndexOf(movePool, "rest")
            if rest >= 0 then
                self:fastPop(movePool, rest)
            end
        end
        goto ____switch167_end
    end
    ::____switch167_case_13::
    do
        return {cull = not counter.setupType}
    end
    ::____switch167_case_14::
    do
    end
    ::____switch167_case_15::
    do
        return {
            cull = ((counter:get("Physical") + counter:get("Special")) < 3) or moves:has("rapidspin")
        }
    end
    ::____switch167_case_16::
    do
        webs = not (not teamDetails.stickyWeb)
        return {
            cull = (((isLead or webs) or (not (not counter:get("speedsetup")))) or (counter.damagingMoves.size < 2)) or movePool:includes("nastyplot")
        }
    end
    ::____switch167_case_17::
    do
        return {
            cull = movePool:includes("boltstrike") or ((species.id == "eiscue") and moves:has("substitute"))
        }
    end
    ::____switch167_case_18::
    do
    end
    ::____switch167_case_19::
    do
    end
    ::____switch167_case_20::
    do
    end
    ::____switch167_case_21::
    do
    end
    ::____switch167_case_22::
    do
    end
    ::____switch167_case_23::
    do
    end
    ::____switch167_case_24::
    do
        if counter.setupType ~= "Physical" then
            return {cull = true}
        end
        if ((counter:get("Physical") + counter:get("physicalpool")) < 2) and (not hasRestTalk) then
            return {cull = true}
        end
        if isDoubles and moves:has("firstimpression") then
            return {cull = true}
        end
        if (move.id == "swordsdance") and moves:has("dragondance") then
            return {cull = true}
        end
        return {cull = false, isSetup = true}
    end
    ::____switch167_case_25::
    do
    end
    ::____switch167_case_26::
    do
        if counter.setupType ~= "Special" then
            return {cull = true}
        end
        if (((counter:get("Special") + counter:get("specialpool")) < 2) and (not hasRestTalk)) and (not (moves:has("wish") and moves:has("protect"))) then
            return {cull = true}
        end
        if moves:has("healpulse") or ((move.id == "calmmind") and moves:has("trickroom")) then
            return {cull = true}
        end
        return {cull = false, isSetup = true}
    end
    ::____switch167_case_27::
    do
        return {cull = false, isSetup = true}
    end
    ::____switch167_case_28::
    do
    end
    ::____switch167_case_29::
    do
    end
    ::____switch167_case_30::
    do
        if counter.setupType ~= "Mixed" then
            return {cull = true}
        end
        if ((counter.damagingMoves.size + counter:get("physicalpool")) + counter:get("specialpool")) < 2 then
            return {cull = true}
        end
        return {cull = false, isSetup = true}
    end
    ::____switch167_case_31::
    do
    end
    ::____switch167_case_32::
    do
    end
    ::____switch167_case_33::
    do
    end
    ::____switch167_case_34::
    do
        if (counter.damagingMoves.size < 2) or moves:has("rest") then
            return {cull = true}
        end
        if movePool:includes("calmmind") or movePool:includes("nastyplot") then
            return {cull = true}
        end
        return {cull = false, isSetup = not counter.setupType}
    end
    ::____switch167_case_35::
    do
    end
    ::____switch167_case_36::
    do
    end
    ::____switch167_case_37::
    do
        return {cull = not (not counter.setupType)}
    end
    ::____switch167_case_38::
    do
    end
    ::____switch167_case_39::
    do
    end
    ::____switch167_case_40::
    do
        return {
            cull = ((not (not counter:get("speedsetup"))) or ((not isDoubles) and moves:has("dragondance"))) or (counter.damagingMoves.size < 2)
        }
    end
    ::____switch167_case_41::
    do
    end
    ::____switch167_case_42::
    do
    end
    ::____switch167_case_43::
    do
        substituteCullCondition = (moves:has("substitute") and (not types:has("Fighting"))) or (moves:has("toxic") and movePool:includes("substitute"))
        preferHJKOverCCCullCondition = ((move.id == "closecombat") and (not counter.setupType)) and (moves:has("highjumpkick") or movePool:includes("highjumpkick"))
        return {cull = substituteCullCondition or preferHJKOverCCCullCondition}
    end
    ::____switch167_case_44::
    do
        return {
            cull = (((not (not counter.setupType)) or moves:has("healbell")) or moves:has("toxicspikes")) or (not (not teamDetails.defog))
        }
    end
    ::____switch167_case_45::
    do
        return {
            cull = (not (not counter.setupType)) or __TS__ArraySome(
                {"protect", "rapidspin", "substitute", "uturn"},
                function(____, m) return moves:has(m) end
            )
        }
    end
    ::____switch167_case_46::
    do
    end
    ::____switch167_case_47::
    do
    end
    ::____switch167_case_48::
    do
    end
    ::____switch167_case_49::
    do
    end
    ::____switch167_case_50::
    do
        return {
            cull = ((not (not counter.setupType)) or (not (not counter:get("speedsetup")))) or moves:has("rest")
        }
    end
    ::____switch167_case_51::
    do
    end
    ::____switch167_case_52::
    do
        return {
            cull = (((not (not counter.setupType)) or (not (not counter:get("recovery")))) or moves:has("substitute")) or moves:has("uturn")
        }
    end
    ::____switch167_case_53::
    do
        return {
            cull = moves:has("curse")
        }
    end
    ::____switch167_case_54::
    do
        return {
            cull = ((not (not counter:get("speedsetup"))) or moves:has("bulkup")) or moves:has("uturn")
        }
    end
    ::____switch167_case_55::
    do
        if (not isDoubles) and ((counter.setupType and (not moves:has("wish"))) or moves:has("rest")) then
            return {cull = true}
        end
        if ((not isDoubles) and (counter:get("Status") < 2)) and __TS__ArrayEvery(
            {"Hunger Switch", "Speed Boost", "Moody"},
            function(____, m) return not abilities:has(m) end
        ) then
            return {cull = true}
        end
        if movePool:includes("leechseed") or (movePool:includes("toxic") and (not moves:has("wish"))) then
            return {cull = true}
        end
        if isDoubles and ((__TS__ArraySome(
            {"bellydrum", "fakeout", "shellsmash", "spore"},
            function(____, m) return movePool:includes(m) end
        ) or moves:has("tailwind")) or moves:has("waterspout")) then
            return {cull = true}
        end
        return {cull = false}
    end
    ::____switch167_case_56::
    do
        setup = __TS__ArraySome(
            {"curse", "nastyplot", "shellsmash"},
            function(____, m) return moves:has(m) end
        )
        return {
            cull = ((not (not teamDetails.rapidSpin)) or setup) or ((not (not counter.setupType)) and (counter:get("Fighting") >= 2))
        }
    end
    ::____switch167_case_57::
    do
        sneakIncompatible = __TS__ArraySome(
            {"substitute", "trickroom", "dualwingbeat", "toxic"},
            function(____, m) return moves:has(m) end
        )
        return {cull = (hasRestTalk or sneakIncompatible) or (counter.setupType == "Special")}
    end
    ::____switch167_case_58::
    do
        return {cull = (not (not counter.setupType)) or ((not (not teamDetails.spikes)) and (teamDetails.spikes > 1))}
    end
    ::____switch167_case_59::
    do
        return {
            cull = (((not (not counter.setupType)) or (not (not counter:get("speedsetup")))) or (not (not teamDetails.stealthRock))) or __TS__ArraySome(
                {"rest", "substitute", "trickroom", "teleport"},
                function(____, m) return moves:has(m) end
            )
        }
    end
    ::____switch167_case_60::
    do
        return {cull = (counter.setupType == "Special") or (not (not teamDetails.stickyWeb))}
    end
    ::____switch167_case_61::
    do
        return {
            cull = (moves:has("encore") or moves:has("nastyplot")) or moves:has("swordsdance")
        }
    end
    ::____switch167_case_62::
    do
    end
    ::____switch167_case_63::
    do
        cullInDoubles = isDoubles and (moves:has("electroweb") or moves:has("nuzzle"))
        return {
            cull = ((((not (not counter.setupType)) or (not (not counter:get("speedsetup")))) or moves:has("shiftgear")) or moves:has("raindance")) or cullInDoubles
        }
    end
    ::____switch167_case_64::
    do
        return {
            cull = (not (not counter.setupType)) or __TS__ArraySome(
                {"sludgewave", "thunderwave", "willowisp"},
                function(____, m) return moves:has(m) end
            )
        }
    end
    ::____switch167_case_65::
    do
        return {cull = (not (not counter.setupType)) or (not (not teamDetails.toxicSpikes))}
    end
    ::____switch167_case_66::
    do
        bugSwordsDanceCase = (types:has("Bug") and counter:get("recovery")) and moves:has("swordsdance")
        return {
            cull = ((not (not counter:get("speedsetup"))) or (counter.setupType and (not bugSwordsDanceCase))) or (isDoubles and moves:has("leechlife"))
        }
    end
    ::____switch167_case_67::
    do
        otherMoves = __TS__ArraySome(
            {"curse", "stompingtantrum", "rockblast", "painsplit", "wish"},
            function(____, m) return moves:has(m) end
        )
        return {
            cull = ((not (not counter:get("speedsetup"))) or (not (not counter:get("recovery")))) or otherMoves
        }
    end
    ::____switch167_case_68::
    do
        return {
            cull = (not (not counter:get("recovery"))) or movePool:includes("doubleedge")
        }
    end
    ::____switch167_case_69::
    do
        diggersbyCull = (counter:get("Physical") > 3) and movePool:includes("uturn")
        return {
            cull = ((not (not counter:get("speedsetup"))) or (types:has("Rock") and (not (not counter:get("Status"))))) or diggersbyCull
        }
    end
    ::____switch167_case_70::
    do
        return {
            cull = (species.id == "genesect") and (counter:get("Special") >= 1)
        }
    end
    ::____switch167_case_71::
    do
        return {
            cull = moves:has("vcreate")
        }
    end
    ::____switch167_case_72::
    do
    end
    ::____switch167_case_73::
    do
        otherFireMoves = __TS__ArraySome(
            {"heatwave", "overheat"},
            function(____, m) return moves:has(m) end
        )
        return {
            cull = (moves:has("fireblast") and (counter.setupType ~= "Physical")) or otherFireMoves
        }
    end
    ::____switch167_case_74::
    do
        return {
            cull = (species.id == "solgaleo") and moves:has("flamecharge")
        }
    end
    ::____switch167_case_75::
    do
        return {
            cull = moves:has("flareblitz") or (isDoubles and moves:has("calmmind"))
        }
    end
    ::____switch167_case_76::
    do
    end
    ::____switch167_case_77::
    do
    end
    ::____switch167_case_78::
    do
        return {
            cull = moves:has("aquajet") or (not (not counter:get("Status")))
        }
    end
    ::____switch167_case_79::
    do
        return {
            cull = moves:has("scald") and (((counter:get("Special") < 4) and (not moves:has("uturn"))) or ((species.types.length > 1) and (counter:get("stab") < 3)))
        }
    end
    ::____switch167_case_80::
    do
        return {
            cull = moves:has("waterpulse")
        }
    end
    ::____switch167_case_81::
    do
        return {
            cull = moves:has("powerwhip")
        }
    end
    ::____switch167_case_82::
    do
        return {
            cull = (species.id == "shiinotic") and (not moves:has("moonblast"))
        }
    end
    ::____switch167_case_83::
    do
        celebiPreferLeafStorm = ((species.id == "celebi") and (not counter.setupType)) and moves:has("uturn")
        return {
            cull = celebiPreferLeafStorm or (types:has("Poison") and (not counter:get("Poison")))
        }
    end
    ::____switch167_case_84::
    do
        return {
            cull = (moves:has("leafstorm") or movePool:includes("leafstorm")) and (counter.setupType ~= "Physical")
        }
    end
    ::____switch167_case_85::
    do
        leafBladePossible = movePool:includes("leafblade") or moves:has("leafblade")
        return {
            cull = (((counter.setupType == "Physical") and ((species.id == "virizion") or leafBladePossible)) or (moves:has("gigadrain") and (not (not counter:get("Status"))))) or (isDoubles and moves:has("energyball"))
        }
    end
    ::____switch167_case_86::
    do
        return {
            cull = moves:has("leechlife")
        }
    end
    ::____switch167_case_87::
    do
        return {
            cull = moves:has("hornleech") and (counter:get("Physical") < 4)
        }
    end
    ::____switch167_case_88::
    do
        betterIceMove = (moves:has("blizzard") and (not (not counter.setupType))) or (moves:has("icebeam") and (counter:get("Special") < 4))
        preferThunderWave = movePool:includes("thunderwave") and types:has("Electric")
        return {
            cull = (betterIceMove or preferThunderWave) or movePool:includes("bodyslam")
        }
    end
    ::____switch167_case_89::
    do
        turtonatorPressCull = ((species.id == "turtonator") and moves:has("earthquake")) and movePool:includes("shellsmash")
        pressIncompatible = __TS__ArraySome(
            {"shellsmash", "mirrorcoat", "whirlwind"},
            function(____, m) return moves:has(m) end
        )
        return {cull = (turtonatorPressCull or pressIncompatible) or (counter.setupType == "Special")}
    end
    ::____switch167_case_90::
    do
        return {
            cull = moves:has("stormthrow") and (not moves:has("rest"))
        }
    end
    ::____switch167_case_91::
    do
        return {
            cull = moves:has("closecombat") or ((not types:has("Fighting")) and movePool:includes("swordsdance"))
        }
    end
    ::____switch167_case_92::
    do
    end
    ::____switch167_case_93::
    do
        return {
            cull = moves:has("closecombat") or moves:has("facade")
        }
    end
    ::____switch167_case_94::
    do
        return {
            cull = movePool:includes("shellsmash") or hasRestTalk
        }
    end
    ::____switch167_case_95::
    do
        return {
            cull = moves:has("fakeout")
        }
    end
    ::____switch167_case_96::
    do
        return {cull = hasRestTalk}
    end
    ::____switch167_case_97::
    do
        return {
            cull = (moves:has("hydropump") or ((counter:get("Physical") >= 4) and movePool:includes("uturn"))) or (moves:has("substitute") and (not abilities:has("Contrary"))),
            isSetup = abilities:has("Contrary")
        }
    end
    ::____switch167_case_98::
    do
        return {
            cull = (not types:has("Poison")) and (counter:get("Status") >= 2)
        }
    end
    ::____switch167_case_99::
    do
        doublesCull = moves:has("earthpower") or moves:has("highhorsepower")
        turtQuakeCull = ((species.id == "turtonator") and movePool:includes("bodypress")) and movePool:includes("shellsmash")
        subToxicPossible = moves:has("substitute") and movePool:includes("toxic")
        return {
            cull = ((turtQuakeCull or (isDoubles and doublesCull)) or subToxicPossible) or moves:has("bonemerang")
        }
    end
    ::____switch167_case_100::
    do
        return {
            cull = (moves:has("willowisp") or moves:has("earthpower")) or (moves:has("toxic") and movePool:includes("earthpower"))
        }
    end
    ::____switch167_case_101::
    do
        return {
            cull = (((((species.id == "naganadel") and moves:has("nastyplot")) or ((species.id == "noctowl") and (not counter.setupType))) or hasRestTalk) or (abilities:has("Simple") and (not (not counter:get("recovery"))))) or (counter.setupType == "Physical")
        }
    end
    ::____switch167_case_102::
    do
        return {
            cull = moves:has("dragondance")
        }
    end
    ::____switch167_case_103::
    do
        noctowlCase = (((not isNoDynamax) and (not isDoubles)) and (species.id == "noctowl")) and (not (not counter.setupType))
        return {cull = (counter.setupType == "Physical") or noctowlCase}
    end
    ::____switch167_case_104::
    do
        return {
            cull = (moves:has("psyshock") or moves:has("trick")) or movePool:includes("teleport")
        }
    end
    ::____switch167_case_105::
    do
        return {
            cull = moves:has("morningsun")
        }
    end
    ::____switch167_case_106::
    do
        alcremieCase = (species.id == "alcremiegmax") and (counter:get("Status") < 2)
        return {
            cull = alcremieCase or (moves:has("psyshock") and ((not (not counter.setupType)) or isDoubles))
        }
    end
    ::____switch167_case_107::
    do
        return {
            cull = moves:has("rapidspin")
        }
    end
    ::____switch167_case_108::
    do
        sylveonCase = abilities:has("Pixilate") and (counter:get("Special") < 4)
        return {
            cull = (moves:has("psychic") or ((not counter.setupType) and sylveonCase)) or (isDoubles and moves:has("psychic"))
        }
    end
    ::____switch167_case_109::
    do
        return {
            cull = moves:has("uturn") and (not counter.setupType)
        }
    end
    ::____switch167_case_110::
    do
        return {
            cull = ((isDoubles and moves:has("lunge")) or (moves:has("uturn") and (not counter.setupType))) or movePool:includes("spikes")
        }
    end
    ::____switch167_case_111::
    do
        gutsCullCondition = abilities:has("Guts") and ((not moves:has("dynamicpunch")) or moves:has("spikes"))
        rockSlidePlusStatusPossible = counter:get("Status") and movePool:includes("rockslide")
        otherRockMove = moves:has("rockblast") or moves:has("rockslide")
        return {cull = (gutsCullCondition or ((not isDoubles) and rockSlidePlusStatusPossible)) or otherRockMove}
    end
    ::____switch167_case_112::
    do
        return {
            cull = moves:has("knockoff")
        }
    end
    ::____switch167_case_113::
    do
        return {
            cull = ((isDoubles and moves:has("phantomforce")) or (abilities:has("Pixilate") and ((not (not counter.setupType)) or (counter:get("Status") > 1)))) or ((not types:has("Ghost")) and movePool:includes("focusblast"))
        }
    end
    ::____switch167_case_114::
    do
        return {
            cull = (types:has("Steel") and moves:has("shadowsneak")) and (counter:get("Physical") < 4)
        }
    end
    ::____switch167_case_115::
    do
    end
    ::____switch167_case_116::
    do
        return {
            cull = moves:has("dracometeor") and (counter:get("Special") < 4)
        }
    end
    ::____switch167_case_117::
    do
        pulseIncompatible = __TS__ArraySome(
            {"foulplay", "knockoff"},
            function(____, m) return moves:has(m) end
        ) or ((species.id == "shiftry") and (moves:has("defog") or moves:has("suckerpunch")))
        shiftryCase = movePool:includes("nastyplot") and (not moves:has("defog"))
        return {cull = (pulseIncompatible and (not shiftryCase)) and (counter.setupType ~= "Special")}
    end
    ::____switch167_case_118::
    do
        return {
            cull = (((((isNoDynamax and (species.id == "shiftry")) and moves:has("defog")) or moves:has("rest")) or (counter.damagingMoves.size < 2)) or (counter.setupType == "Special")) or ((counter:get("Dark") > 1) and (not types:has("Dark")))
        }
    end
    ::____switch167_case_119::
    do
        return {
            cull = __TS__ArraySome(
                {"fleurcannon", "moonblast", "petaldance"},
                function(____, m) return moves:has(m) end
            )
        }
    end
    ::____switch167_case_120::
    do
    end
    ::____switch167_case_121::
    do
        toxicCullCondition = moves:has("toxic") and (not types:has("Normal"))
        return {
            cull = ((moves:has("sludgebomb") or moves:has("trick")) or movePool:includes("recover")) or toxicCullCondition
        }
    end
    ::____switch167_case_122::
    do
        return {
            cull = (not teamDetails.stealthRock) and (moves:has("stealthrock") or movePool:includes("stealthrock"))
        }
    end
    ::____switch167_case_123::
    do
        return {
            cull = moves:has("voltswitch")
        }
    end
    ::____switch167_case_124::
    do
    end
    ::____switch167_case_125::
    do
        return {
            cull = (moves:has("thunderwave") or moves:has("toxic")) or moves:has("swordsdance")
        }
    end
    ::____switch167_case_126::
    do
    end
    ::____switch167_case_127::
    do
    end
    ::____switch167_case_128::
    do
        return {
            cull = (moves:has("rest") or moves:has("wish")) or ((move.id == "synthesis") and moves:has("gigadrain"))
        }
    end
    ::____switch167_case_129::
    do
        return {
            cull = (moves:has("throatchop") or (moves:has("stoneedge") and (species.id == "hawlucha"))) or (moves:has("dualwingbeat") and (moves:has("outrage") or (species.id == "scizor")))
        }
    end
    ::____switch167_case_130::
    do
    end
    ::____switch167_case_131::
    do
        return {cull = not (not teamDetails.screens)}
    end
    ::____switch167_case_132::
    do
        return {
            cull = (species.id == "slowking") and (not moves:has("scald"))
        }
    end
    ::____switch167_case_133::
    do
        moveBasedCull = __TS__ArraySome(
            {"bulkup", "nastyplot", "painsplit", "roost", "swordsdance"},
            function(____, m) return movePool:includes(m) end
        )
        doublesGourgeist = isDoubles and movePool:includes("powerwhip")
        calmMindCullCondition = ((not counter:get("recovery")) and movePool:includes("calmmind")) and (species.id ~= "calyrex")
        eiscue = (species.id == "eiscue") and moves:has("zenheadbutt")
        return {
            cull = (((moves:has("rest") or moveBasedCull) or doublesGourgeist) or calmMindCullCondition) or eiscue
        }
    end
    ::____switch167_case_134::
    do
        return {
            cull = moves:has("acupressure")
        }
    end
    ::____switch167_case_135::
    do
        return {
            cull = moves:has("protect")
        }
    end
    ::____switch167_case_136::
    do
        return {
            cull = moves:has("surf")
        }
    end
    ::____switch167_case_137::
    do
        return {
            cull = moves:has("rocktomb") or ((species.id == "lucario") and (not (not counter.setupType)))
        }
    end
    ::____switch167_case_138::
    do
        return {cull = not (not counter.setupType)}
    end
    ::____switch167_end::
    return {cull = false}
end
function RandomTeams.prototype.shouldCullAbility(self, ability, types, moves, abilities, counter, movePool, teamDetails, species, isDoubles, isNoDynamax)
    if ({"Flare Boost", "Hydration", "Ice Body", "Innards Out", "Insomnia", "Misty Surge", "Quick Feet", "Rain Dish", "Snow Cloak", "Steadfast", "Steam Engine"}):includes(ability) then
        return true
    end
    local ____switch202 = ability
    if ____switch202 == "Contrary" then
        goto ____switch202_case_0
    elseif ____switch202 == "Serene Grace" then
        goto ____switch202_case_1
    elseif ____switch202 == "Skill Link" then
        goto ____switch202_case_2
    elseif ____switch202 == "Strong Jaw" then
        goto ____switch202_case_3
    elseif ____switch202 == "Analytic" then
        goto ____switch202_case_4
    elseif ____switch202 == "Blaze" then
        goto ____switch202_case_5
    elseif ____switch202 == "Bulletproof" then
        goto ____switch202_case_6
    elseif ____switch202 == "Overcoat" then
        goto ____switch202_case_7
    elseif ____switch202 == "Chlorophyll" then
        goto ____switch202_case_8
    elseif ____switch202 == "Cloud Nine" then
        goto ____switch202_case_9
    elseif ____switch202 == "Competitive" then
        goto ____switch202_case_10
    elseif ____switch202 == "Compound Eyes" then
        goto ____switch202_case_11
    elseif ____switch202 == "No Guard" then
        goto ____switch202_case_12
    elseif ____switch202 == "Cursed Body" then
        goto ____switch202_case_13
    elseif ____switch202 == "Defiant" then
        goto ____switch202_case_14
    elseif ____switch202 == "Download" then
        goto ____switch202_case_15
    elseif ____switch202 == "Early Bird" then
        goto ____switch202_case_16
    elseif ____switch202 == "Flash Fire" then
        goto ____switch202_case_17
    elseif ____switch202 == "Gluttony" then
        goto ____switch202_case_18
    elseif ____switch202 == "Guts" then
        goto ____switch202_case_19
    elseif ____switch202 == "Harvest" then
        goto ____switch202_case_20
    elseif ____switch202 == "Hustle" then
        goto ____switch202_case_21
    elseif ____switch202 == "Inner Focus" then
        goto ____switch202_case_22
    elseif ____switch202 == "Infiltrator" then
        goto ____switch202_case_23
    elseif ____switch202 == "Intimidate" then
        goto ____switch202_case_24
    elseif ____switch202 == "Iron Fist" then
        goto ____switch202_case_25
    elseif ____switch202 == "Justified" then
        goto ____switch202_case_26
    elseif ____switch202 == "Lightning Rod" then
        goto ____switch202_case_27
    elseif ____switch202 == "Limber" then
        goto ____switch202_case_28
    elseif ____switch202 == "Liquid Voice" then
        goto ____switch202_case_29
    elseif ____switch202 == "Magic Guard" then
        goto ____switch202_case_30
    elseif ____switch202 == "Mold Breaker" then
        goto ____switch202_case_31
    elseif ____switch202 == "Moxie" then
        goto ____switch202_case_32
    elseif ____switch202 == "Overgrow" then
        goto ____switch202_case_33
    elseif ____switch202 == "Own Tempo" then
        goto ____switch202_case_34
    elseif ____switch202 == "Power Construct" then
        goto ____switch202_case_35
    elseif ____switch202 == "Prankster" then
        goto ____switch202_case_36
    elseif ____switch202 == "Pressure" then
        goto ____switch202_case_37
    elseif ____switch202 == "Refrigerate" then
        goto ____switch202_case_38
    elseif ____switch202 == "Regenerator" then
        goto ____switch202_case_39
    elseif ____switch202 == "Reckless" then
        goto ____switch202_case_40
    elseif ____switch202 == "Rock Head" then
        goto ____switch202_case_41
    elseif ____switch202 == "Sand Force" then
        goto ____switch202_case_42
    elseif ____switch202 == "Sand Veil" then
        goto ____switch202_case_43
    elseif ____switch202 == "Sand Rush" then
        goto ____switch202_case_44
    elseif ____switch202 == "Sap Sipper" then
        goto ____switch202_case_45
    elseif ____switch202 == "Scrappy" then
        goto ____switch202_case_46
    elseif ____switch202 == "Screen Cleaner" then
        goto ____switch202_case_47
    elseif ____switch202 == "Shed Skin" then
        goto ____switch202_case_48
    elseif ____switch202 == "Sheer Force" then
        goto ____switch202_case_49
    elseif ____switch202 == "Shell Armor" then
        goto ____switch202_case_50
    elseif ____switch202 == "Slush Rush" then
        goto ____switch202_case_51
    elseif ____switch202 == "Sniper" then
        goto ____switch202_case_52
    elseif ____switch202 == "Solar Power" then
        goto ____switch202_case_53
    elseif ____switch202 == "Speed Boost" then
        goto ____switch202_case_54
    elseif ____switch202 == "Steely Spirit" then
        goto ____switch202_case_55
    elseif ____switch202 == "Sturdy" then
        goto ____switch202_case_56
    elseif ____switch202 == "Swarm" then
        goto ____switch202_case_57
    elseif ____switch202 == "Sweet Veil" then
        goto ____switch202_case_58
    elseif ____switch202 == "Swift Swim" then
        goto ____switch202_case_59
    elseif ____switch202 == "Synchronize" then
        goto ____switch202_case_60
    elseif ____switch202 == "Technician" then
        goto ____switch202_case_61
    elseif ____switch202 == "Tinted Lens" then
        goto ____switch202_case_62
    elseif ____switch202 == "Torrent" then
        goto ____switch202_case_63
    elseif ____switch202 == "Tough Claws" then
        goto ____switch202_case_64
    elseif ____switch202 == "Unaware" then
        goto ____switch202_case_65
    elseif ____switch202 == "Unburden" then
        goto ____switch202_case_66
    elseif ____switch202 == "Volt Absorb" then
        goto ____switch202_case_67
    elseif ____switch202 == "Water Absorb" then
        goto ____switch202_case_68
    elseif ____switch202 == "Weak Armor" then
        goto ____switch202_case_69
    end
    goto ____switch202_end
    ::____switch202_case_0::
    do
    end
    ::____switch202_case_1::
    do
    end
    ::____switch202_case_2::
    do
    end
    ::____switch202_case_3::
    do
        return not counter:get(
            toID(_G, ability)
        )
    end
    ::____switch202_case_4::
    do
        return (moves:has("rapidspin") or species.nfe) or isDoubles
    end
    ::____switch202_case_5::
    do
        return (isDoubles and abilities:has("Solar Power")) or (((not isDoubles) and (not isNoDynamax)) and (species.id == "charizard"))
    end
    ::____switch202_case_6::
    do
    end
    ::____switch202_case_7::
    do
        return (not (not counter.setupType)) and abilities:has("Soundproof")
    end
    ::____switch202_case_8::
    do
        return (species.baseStats.spe > 100) or (((not counter:get("Fire")) and (not moves:has("sunnyday"))) and (not teamDetails.sun))
    end
    ::____switch202_case_9::
    do
        return (not isNoDynamax) or (species.id ~= "golduck")
    end
    ::____switch202_case_10::
    do
        return (counter:get("Special") < 2) or (moves:has("rest") and moves:has("sleeptalk"))
    end
    ::____switch202_case_11::
    do
    end
    ::____switch202_case_12::
    do
        return not counter:get("inaccurate")
    end
    ::____switch202_case_13::
    do
        return abilities:has("Infiltrator")
    end
    ::____switch202_case_14::
    do
        return not counter:get("Physical")
    end
    ::____switch202_case_15::
    do
        return (counter.damagingMoves.size < 3) or moves:has("trick")
    end
    ::____switch202_case_16::
    do
        return types:has("Grass") and isDoubles
    end
    ::____switch202_case_17::
    do
        return (self.dex:getEffectiveness("Fire", species) < -1) or abilities:has("Drought")
    end
    ::____switch202_case_18::
    do
        return not moves:has("bellydrum")
    end
    ::____switch202_case_19::
    do
        return ((not moves:has("facade")) and (not moves:has("sleeptalk"))) and (not species.nfe)
    end
    ::____switch202_case_20::
    do
        return abilities:has("Frisk") and (not isDoubles)
    end
    ::____switch202_case_21::
    do
    end
    ::____switch202_case_22::
    do
        return (counter:get("Physical") < 2) or abilities:has("Iron Fist")
    end
    ::____switch202_case_23::
    do
        return (moves:has("rest") and moves:has("sleeptalk")) or (isDoubles and abilities:has("Clear Body"))
    end
    ::____switch202_case_24::
    do
        if (species.id == "salamence") and moves:has("dragondance") then
            return true
        end
        return __TS__ArraySome(
            {"bodyslam", "bounce", "tripleaxel"},
            function(____, m) return moves:has(m) end
        )
    end
    ::____switch202_case_25::
    do
        return (counter:get("ironfist") < 2) or moves:has("dynamicpunch")
    end
    ::____switch202_case_26::
    do
        return isDoubles and abilities:has("Inner Focus")
    end
    ::____switch202_case_27::
    do
        return species.types:includes("Ground") or ((not isNoDynamax) and (counter.setupType == "Physical"))
    end
    ::____switch202_case_28::
    do
        return species.types:includes("Electric") or moves:has("facade")
    end
    ::____switch202_case_29::
    do
        return not moves:has("hypervoice")
    end
    ::____switch202_case_30::
    do
        return (abilities:has("Tinted Lens") and (not counter:get("Status"))) and (not isDoubles)
    end
    ::____switch202_case_31::
    do
        return ((abilities:has("Adaptability") or abilities:has("Scrappy")) or (abilities:has("Unburden") and (not (not counter.setupType)))) or (abilities:has("Sheer Force") and (not (not counter:get("sheerforce"))))
    end
    ::____switch202_case_32::
    do
        return ((counter:get("Physical") < 2) or moves:has("stealthrock")) or moves:has("defog")
    end
    ::____switch202_case_33::
    do
        return not counter:get("Grass")
    end
    ::____switch202_case_34::
    do
        return not moves:has("petaldance")
    end
    ::____switch202_case_35::
    do
        return (species.forme == "10%") and (not isDoubles)
    end
    ::____switch202_case_36::
    do
        return not counter:get("Status")
    end
    ::____switch202_case_37::
    do
        return ((not (not counter.setupType)) or (counter:get("Status") < 2)) or isDoubles
    end
    ::____switch202_case_38::
    do
        return not counter:get("Normal")
    end
    ::____switch202_case_39::
    do
        return abilities:has("Magic Guard")
    end
    ::____switch202_case_40::
    do
        return (not counter:get("recoil")) or moves:has("curse")
    end
    ::____switch202_case_41::
    do
        return not counter:get("recoil")
    end
    ::____switch202_case_42::
    do
    end
    ::____switch202_case_43::
    do
        return not teamDetails.sand
    end
    ::____switch202_case_44::
    do
        return (not teamDetails.sand) and (((isNoDynamax or (not counter.setupType)) or (not counter:get("Rock"))) or moves:has("rapidspin"))
    end
    ::____switch202_case_45::
    do
        return moves:has("roost")
    end
    ::____switch202_case_46::
    do
        return moves:has("earthquake") and (species.id == "miltank")
    end
    ::____switch202_case_47::
    do
        return not (not teamDetails.screens)
    end
    ::____switch202_case_48::
    do
        return moves:has("dragondance")
    end
    ::____switch202_case_49::
    do
        return (not counter:get("sheerforce")) or abilities:has("Guts")
    end
    ::____switch202_case_50::
    do
        return (species.id == "omastar") and (moves:has("spikes") or moves:has("stealthrock"))
    end
    ::____switch202_case_51::
    do
        return (not teamDetails.hail) and (not abilities:has("Swift Swim"))
    end
    ::____switch202_case_52::
    do
        return (species.name == "Inteleon") or ((counter:get("Water") > 1) and (not moves:has("focusenergy")))
    end
    ::____switch202_case_53::
    do
        return isNoDynamax and (not teamDetails.sun)
    end
    ::____switch202_case_54::
    do
        return isNoDynamax and (species.id == "ninjask")
    end
    ::____switch202_case_55::
    do
        return moves:has("fakeout") and (not isDoubles)
    end
    ::____switch202_case_56::
    do
        return (moves:has("bulkup") or (not (not counter:get("recoil")))) or ((not isNoDynamax) and abilities:has("Solid Rock"))
    end
    ::____switch202_case_57::
    do
        return (not counter:get("Bug")) or (not (not counter:get("recovery")))
    end
    ::____switch202_case_58::
    do
        return types:has("Grass")
    end
    ::____switch202_case_59::
    do
        if isNoDynamax then
            local neverWantsSwim = (not moves:has("raindance")) and __TS__ArraySome(
                {"Intimidate", "Rock Head", "Water Absorb"},
                function(____, m) return abilities:has(m) end
            )
            local noSwimIfNoRain = (not moves:has("raindance")) and __TS__ArraySome(
                {"Cloud Nine", "Lightning Rod", "Intimidate", "Rock Head", "Sturdy", "Water Absorb", "Weak Armor"},
                function(____, m) return abilities:has(m) end
            )
            return ((teamDetails.rain and (function() return neverWantsSwim end)) or (function() return noSwimIfNoRain end))()
        end
        return (not moves:has("raindance")) and (__TS__ArraySome(
            {"Intimidate", "Rock Head", "Slush Rush", "Water Absorb"},
            function(____, abil) return abilities:has(abil) end
        ) or (abilities:has("Lightning Rod") and (not counter.setupType)))
    end
    ::____switch202_case_60::
    do
        return counter:get("Status") < 3
    end
    ::____switch202_case_61::
    do
        return (((not counter:get("technician")) or moves:has("tailslap")) or abilities:has("Punk Rock")) or movePool:includes("snarl")
    end
    ::____switch202_case_62::
    do
        return (moves:has("defog") or (moves:has("hurricane") and abilities:has("Compound Eyes"))) or ((counter:get("Status") > 2) and (not counter.setupType))
    end
    ::____switch202_case_63::
    do
        return moves:has("focusenergy") or moves:has("hypervoice")
    end
    ::____switch202_case_64::
    do
        return types:has("Steel") and (not moves:has("fakeout"))
    end
    ::____switch202_case_65::
    do
        return (not (not counter.setupType)) or moves:has("fireblast")
    end
    ::____switch202_case_66::
    do
        return abilities:has("Prankster") or ((not counter.setupType) and (not isDoubles))
    end
    ::____switch202_case_67::
    do
        return self.dex:getEffectiveness("Electric", species) < -1
    end
    ::____switch202_case_68::
    do
        return moves:has("raindance") or __TS__ArraySome(
            {"Drizzle", "Strong Jaw", "Unaware", "Volt Absorb"},
            function(____, abil) return abilities:has(abil) end
        )
    end
    ::____switch202_case_69::
    do
        return ((((not isNoDynamax) and (species.baseStats.spe > 50)) or (species.id == "skarmory")) or moves:has("shellsmash")) or moves:has("rapidspin")
    end
    ::____switch202_end::
    return false
end
function RandomTeams.prototype.getHighPriorityItem(self, ability, types, moves, counter, teamDetails, species, isLead, isDoubles)
    if moves:has("acrobatics") and (ability ~= "Ripen") then
        return ((ability == "Grassy Surge") and "Grassy Seed") or ""
    end
    if moves:has("geomancy") or moves:has("meteorbeam") then
        return "Power Herb"
    end
    if moves:has("shellsmash") then
        if ((ability == "Sturdy") and (not isLead)) and (not isDoubles) then
            return "Heavy-Duty Boots"
        end
        if ability == "Solid Rock" then
            return "Weakness Policy"
        end
        return "White Herb"
    end
    if moves:has("technoblast") then
        return "Douse Drive"
    end
    if ((({"Corsola", "Garchomp", "Tangrowth"}):includes(species.name) and counter:get("Status")) and (not counter.setupType)) and (not isDoubles) then
        return "Rocky Helmet"
    end
    if (species.name == "Eternatus") and (counter:get("Status") < 2) then
        return "Metronome"
    end
    if species.name == "Farfetch’d" then
        return "Leek"
    end
    if (species.name == "Froslass") and (not isDoubles) then
        return "Wide Lens"
    end
    if ((species.name == "Latios") and (counter:get("Special") == 2)) and (not isDoubles) then
        return "Soul Dew"
    end
    if species.name == "Lopunny" then
        return (isDoubles and "Iron Ball") or "Toxic Orb"
    end
    if species.baseSpecies == "Marowak" then
        return "Thick Club"
    end
    if species.baseSpecies == "Pikachu" then
        return "Light Ball"
    end
    if (species.name == "Regieleki") and (not isDoubles) then
        return "Magnet"
    end
    if species.name == "Shedinja" then
        local noSash = ((not teamDetails.defog) and (not teamDetails.rapidSpin)) and (not isDoubles)
        return (noSash and "Heavy-Duty Boots") or "Focus Sash"
    end
    if (species.name == "Shuckle") and moves:has("stickyweb") then
        return "Mental Herb"
    end
    if (species.name == "Unfezant") or moves:has("focusenergy") then
        return "Scope Lens"
    end
    if species.name == "Pincurchin" then
        return "Shuca Berry"
    end
    if (species.name == "Wobbuffet") and moves:has("destinybond") then
        return "Custap Berry"
    end
    if (species.name == "Scyther") and (counter.damagingMoves.size > 3) then
        return "Choice Band"
    end
    if moves:has("bellydrum") and moves:has("substitute") then
        return "Salac Berry"
    end
    if species.evos.length then
        return "Eviolite"
    end
    if (species.name == "Wobbuffet") or ({"Cheek Pouch", "Harvest", "Ripen"}):includes(ability) then
        return "Sitrus Berry"
    end
    if ability == "Gluttony" then
        return tostring(
            self:sample({"Aguav", "Figy", "Iapapa", "Mago", "Wiki"})
        ) .. " Berry"
    end
    if (ability == "Imposter") or (((ability == "Magnet Pull") and moves:has("bodypress")) and (not isDoubles)) then
        return "Choice Scarf"
    end
    if (ability == "Guts") and ((counter:get("Physical") > 2) or isDoubles) then
        return (types:has("Fire") and "Toxic Orb") or "Flame Orb"
    end
    if (ability == "Magic Guard") and (counter.damagingMoves.size > 1) then
        return (moves:has("counter") and "Focus Sash") or "Life Orb"
    end
    if (ability == "Sheer Force") and counter:get("sheerforce") then
        return "Life Orb"
    end
    if ability == "Unburden" then
        return ((moves:has("closecombat") or moves:has("curse")) and "White Herb") or "Sitrus Berry"
    end
    if (moves:has("trick") or (moves:has("switcheroo") and (not isDoubles))) or (ability == "Gorilla Tactics") then
        if (((species.baseStats.spe >= 60) and (species.baseStats.spe <= 108)) and (not counter:get("priority"))) and (ability ~= "Triage") then
            return "Choice Scarf"
        else
            return ((counter:get("Physical") > counter:get("Special")) and "Choice Band") or "Choice Specs"
        end
    end
    if moves:has("auroraveil") or (moves:has("lightscreen") and moves:has("reflect")) then
        return "Light Clay"
    end
    if (moves:has("rest") and (not moves:has("sleeptalk"))) and (ability ~= "Shed Skin") then
        return "Chesto Berry"
    end
    if moves:has("hypnosis") and (ability == "Beast Boost") then
        return "Blunder Policy"
    end
    if moves:has("bellydrum") then
        return "Sitrus Berry"
    end
    if (self.dex:getEffectiveness("Rock", species) >= 2) and (not isDoubles) then
        return "Heavy-Duty Boots"
    end
end
function RandomTeams.prototype.getDoublesItem(self, ability, types, moves, abilities, counter, teamDetails, species)
    local defensiveStatTotal = (species.baseStats.hp + species.baseStats.def) + species.baseStats.spd
    if __TS__ArraySome(
        {"dragonenergy", "eruption", "waterspout"},
        function(____, m) return moves:has(m) end
    ) and (counter.damagingMoves.size >= 4) then
        return "Choice Scarf"
    end
    if (moves:has("blizzard") and (ability ~= "Snow Warning")) and (not teamDetails.hail) then
        return "Blunder Policy"
    end
    if (self.dex:getEffectiveness("Rock", species) >= 2) and (not types:has("Flying")) then
        return "Heavy-Duty Boots"
    end
    if ((counter:get("Physical") >= 4) and __TS__ArrayEvery(
        {"fakeout", "feint", "rapidspin", "suckerpunch"},
        function(____, m) return not moves:has(m) end
    )) and ((((types:has("Dragon") or types:has("Fighting")) or types:has("Rock")) or moves:has("flipturn")) or moves:has("uturn")) then
        return ((((((not counter:get("priority")) and (not abilities:has("Speed Boost"))) and (species.baseStats.spe >= 60)) and (species.baseStats.spe <= 100)) and self:randomChance(1, 2)) and "Choice Scarf") or "Choice Band"
    end
    if ((counter:get("Special") >= 4) and (((types:has("Dragon") or types:has("Fighting")) or types:has("Rock")) or moves:has("voltswitch"))) or ((((counter:get("Special") >= 3) and (moves:has("flipturn") or moves:has("uturn"))) and (not moves:has("acidspray"))) and (not moves:has("electroweb"))) then
        return ((((species.baseStats.spe >= 60) and (species.baseStats.spe <= 100)) and self:randomChance(1, 2)) and "Choice Scarf") or "Choice Specs"
    end
    if (counter.damagingMoves.size >= 4) and (defensiveStatTotal >= 280) then
        return "Assault Vest"
    end
    if ((((counter.damagingMoves.size >= 3) and (species.baseStats.spe >= 60)) and (ability ~= "Multiscale")) and (ability ~= "Sturdy")) and __TS__ArrayEvery(
        {"acidspray", "clearsmog", "electroweb", "fakeout", "feint", "icywind", "incinerate", "naturesmadness", "rapidspin", "snarl", "uturn"},
        function(____, m) return not moves:has(m) end
    ) then
        return (((ability == "Defeatist") or (defensiveStatTotal >= 275)) and "Sitrus Berry") or "Life Orb"
    end
end
function RandomTeams.prototype.getMediumPriorityItem(self, ability, moves, counter, species, isLead, isDoubles, isNoDynamax)
    local defensiveStatTotal = (species.baseStats.hp + species.baseStats.def) + species.baseStats.spd
    if ((((not isDoubles) and (counter:get("Physical") >= 4)) and (ability ~= "Serene Grace")) and __TS__ArrayEvery(
        {"fakeout", "flamecharge", "rapidspin"},
        function(____, m) return not moves:has(m) end
    )) and ((not moves:has("tailslap")) or moves:has("uturn")) then
        local scarfReqs = ((((((species.baseStats.atk >= 100) or (ability == "Huge Power")) and (species.baseStats.spe >= 60)) and (species.baseStats.spe <= 108)) and (ability ~= "Speed Boost")) and (not counter:get("priority"))) and (isNoDynamax or __TS__ArrayEvery(
            {"bounce", "dualwingbeat"},
            function(____, m) return not moves:has(m) end
        ))
        return ((scarfReqs and self:randomChance(2, 3)) and "Choice Scarf") or "Choice Band"
    end
    if (not isDoubles) and (((counter:get("Special") >= 4) and (not moves:has("futuresight"))) or ((counter:get("Special") >= 3) and __TS__ArraySome(
        {"flipturn", "partingshot", "uturn"},
        function(____, m) return moves:has(m) end
    ))) then
        local scarfReqs = ((((species.baseStats.spa >= 100) and (species.baseStats.spe >= 60)) and (species.baseStats.spe <= 108)) and (ability ~= "Tinted Lens")) and (not counter:get("Physical"))
        return ((scarfReqs and self:randomChance(2, 3)) and "Choice Scarf") or "Choice Specs"
    end
    if (((not isDoubles) and (counter:get("Physical") >= 3)) and (not moves:has("rapidspin"))) and __TS__ArraySome(
        {"copycat", "memento", "partingshot"},
        function(____, m) return moves:has(m) end
    ) then
        return "Choice Band"
    end
    if (((not isDoubles) and (((counter:get("Physical") >= 3) and moves:has("defog")) or ((counter:get("Special") >= 3) and moves:has("healingwish")))) and (not counter:get("priority"))) and (not moves:has("uturn")) then
        return "Choice Scarf"
    end
    if ((moves:has("raindance") or moves:has("sunnyday")) or ((ability == "Speed Boost") and (not counter:get("hazards")))) or ((ability == "Stance Change") and (counter.damagingMoves.size >= 3)) then
        return "Life Orb"
    end
    if ((not isDoubles) and (self.dex:getEffectiveness("Rock", species) >= 1)) and (({"Defeatist", "Emergency Exit", "Multiscale"}):includes(ability) or __TS__ArraySome(
        {"courtchange", "defog", "rapidspin"},
        function(____, m) return moves:has(m) end
    )) then
        return "Heavy-Duty Boots"
    end
    if (species.name == "Necrozma-Dusk-Mane") or ((((self.dex:getEffectiveness("Ground", species) < 2) and counter:get("speedsetup")) and (counter.damagingMoves.size >= 3)) and (defensiveStatTotal >= 300)) then
        return "Weakness Policy"
    end
    if (counter.damagingMoves.size >= 4) and (defensiveStatTotal >= 235) then
        return "Assault Vest"
    end
    if __TS__ArraySome(
        {"clearsmog", "curse", "haze", "healbell", "protect", "sleeptalk", "strangesteam"},
        function(____, m) return moves:has(m) end
    ) and ((ability == "Moody") or (not isDoubles)) then
        return "Leftovers"
    end
end
function RandomTeams.prototype.getLowPriorityItem(self, ability, types, moves, abilities, counter, teamDetails, species, isLead, isDoubles, isNoDynamax)
    local defensiveStatTotal = (species.baseStats.hp + species.baseStats.def) + species.baseStats.spd
    if ((((((isLead and (not isDoubles)) and (not ({"Disguise", "Sturdy"}):includes(ability))) and (not moves:has("substitute"))) and (not counter:get("drain"))) and (not counter:get("recoil"))) and (not counter:get("recovery"))) and (defensiveStatTotal < 255) then
        return "Focus Sash"
    end
    if (not isDoubles) and (ability == "Water Bubble") then
        return "Mystic Water"
    end
    if moves:has("clangoroussoul") or (moves:has("boomburst") and Array:from(moves):some(
        function(____, m) return Dex.moves:get(m).boosts.spe end
    )) then
        return "Throat Spray"
    end
    local rockWeaknessCase = (self.dex:getEffectiveness("Rock", species) >= 1) and ((((not teamDetails.defog) or (ability == "Intimidate")) or moves:has("uturn")) or moves:has("voltswitch"))
    local spinnerCase = moves:has("rapidspin") and ((ability == "Regenerator") or (not (not counter:get("recovery"))))
    if ((not isDoubles) and (rockWeaknessCase or spinnerCase)) and (species.id ~= "glalie") then
        return "Heavy-Duty Boots"
    end
    if ((((not isDoubles) and (self.dex:getEffectiveness("Ground", species) >= 2)) and (not types:has("Poison"))) and (ability ~= "Levitate")) and (not abilities:has("Iron Barbs")) then
        return "Air Balloon"
    end
    if ((((((not isDoubles) and (counter.damagingMoves.size >= 3)) and (not counter:get("damage"))) and (ability ~= "Sturdy")) and ((species.baseStats.spe >= 90) or (not moves:has("voltswitch")))) and __TS__ArrayEvery(
        {"foulplay", "rapidspin", "substitute", "uturn"},
        function(____, m) return not moves:has(m) end
    )) and ((((counter:get("speedsetup") or (counter:get("drain") and (((not isNoDynamax) or (species.id ~= "buzzwole")) or moves:has("roost")))) or moves:has("trickroom")) or moves:has("psystrike")) or ((species.baseStats.spe > 40) and (defensiveStatTotal < 275))) then
        return "Life Orb"
    end
    if (((not isDoubles) and (counter.damagingMoves.size >= 4)) and (not counter:get("Dragon"))) and (not counter:get("Normal")) then
        return "Expert Belt"
    end
    if (((not isDoubles) and (not moves:has("substitute"))) and (moves:has("dragondance") or moves:has("swordsdance"))) and (moves:has("outrage") or (__TS__ArrayEvery(
        {"Bug", "Fire", "Ground", "Normal", "Poison"},
        function(____, ____type) return not types:has(____type) end
    ) and (not ({"Pastel Veil", "Storm Drain"}):includes(ability)))) then
        return "Lum Berry"
    end
end
function RandomTeams.prototype.randomSet(self, species, teamDetails, isLead, isDoubles, isNoDynamax)
    if teamDetails == nil then
        teamDetails = {}
    end
    if isLead == nil then
        isLead = false
    end
    if isDoubles == nil then
        isDoubles = false
    end
    if isNoDynamax == nil then
        isNoDynamax = false
    end
    species = self.dex.species:get(species)
    local forme = species.name
    local gmax = false
    if type(species.battleOnly) == "string" then
        forme = species.battleOnly
    end
    if species.cosmeticFormes then
        forme = self:sample(
            __TS__ArrayConcat({species.name}, species.cosmeticFormes)
        )
    end
    if species.name:endsWith("-Gmax") then
        forme = species.name:slice(0, -5)
        gmax = true
    end
    local randMoves = ((isDoubles and species.randomDoubleBattleMoves) or (isNoDynamax and species.randomBattleNoDynamaxMoves)) or species.randomBattleMoves
    local movePool = (randMoves or __TS__ObjectKeys(self.dex.data.Learnsets[species.id].learnset)):slice()
    if (self.format.gameType == "multi") or (self.format.gameType == "freeforall") then
        local allySwitch = movePool:indexOf("allyswitch")
        if allySwitch > -1 then
            if movePool.length > 4 then
                self:fastPop(movePool, allySwitch)
            else
                movePool[allySwitch] = "sleeptalk"
            end
        end
    end
    local rejectedPool = {}
    local ability = ""
    local item = nil
    local evs = {hp = 85, atk = 85, def = 85, spa = 85, spd = 85, spe = 85}
    local ivs = {hp = 31, atk = 31, def = 31, spa = 31, spd = 31, spe = 31}
    local types = __TS__New(Set, species.types)
    local abilities = __TS__New(
        Set,
        __TS__ObjectValues(species.abilities)
    )
    if species.unreleasedHidden then
        abilities:delete(species.abilities.H)
    end
    local moves = __TS__New(Set)
    local counter
    repeat
        do
            local pool = ((movePool.length and (function() return movePool end)) or (function() return rejectedPool end))()
            while (moves.size < 4) and pool.length do
                local moveid = self:sampleNoReplace(pool)
                moves:add(moveid)
            end
            counter = self:queryMoves(moves, species.types, abilities, movePool)
            local function runEnforcementChecker(____, checkerName)
                return (function()
                    local ____self = self.moveEnforcementCheckers
                    return ____self[checkerName](____self, movePool, moves, abilities, types, counter, species, teamDetails)
                end)()
            end
            for ____, moveid in __TS__Iterator(moves) do
                local move = self.dex.moves:get(moveid)
                local ____ = self:shouldCullMove(move, types, moves, abilities, counter, movePool, teamDetails, species, isLead, isDoubles, isNoDynamax)
                local cull = ____.cull
                local isSetup = ____.isSetup
                if (move.id ~= "photongeyser") and (((move.category == "Physical") and (counter.setupType == "Special")) or ((move.category == "Special") and (counter.setupType == "Physical"))) then
                    local stabs = counter:get(species.types[0]) + ((species.types[1] and (function() return counter:get(species.types[1]) end)) or (function() return 0 end))()
                    if ((not types:has(move.type)) or (stabs > 1)) or (counter:get(move.category) < 2) then
                        cull = true
                    end
                end
                local isLowBP = move.basePower and (move.basePower < 50)
                local moveIsRejectable = (not ((species.id == "genesectdouse") and (move.id == "technoblast"))) and (((move.category == "Status") or (not types:has(move.type))) or ((isLowBP and (not move.multihit)) and (not abilities:has("Technician"))))
                local notImportantSetup = (((not counter.setupType) or (counter.setupType == "Mixed")) or (((counter:get(counter.setupType) + counter:get("Status")) > 3) and (not counter:get("hazards")))) or ((move.category ~= counter.setupType) and (move.category ~= "Status"))
                if moveIsRejectable and (((((((not cull) and (not isSetup)) and (not move.weather)) and (not move.stallingMove)) and notImportantSetup) and (not move.damage)) and ((isDoubles and (function() return self:unrejectableMovesInDoubles(move) end)) or (function() return self:unrejectableMovesInSingles(move) end))()) then
                    if (((((((((not counter:get("stab")) and ((counter:get("physicalpool") + counter:get("specialpool")) > 0)) and (move.id ~= "stickyweb")) or ((moves:has("swordsdance") and (species.id == "mew")) and runEnforcementChecker(_G, "Flying"))) or (abilities:has("Steelworker") and runEnforcementChecker(_G, "Steel"))) or (((not isDoubles) and runEnforcementChecker(_G, "recovery")) and (move.id ~= "stickyweb"))) or runEnforcementChecker(_G, "screens")) or runEnforcementChecker(_G, "misc")) or (isLead and runEnforcementChecker(_G, "lead"))) or (moves:has("leechseed") and runEnforcementChecker(_G, "leechseed")) then
                        cull = true
                    elseif move.id ~= "stickyweb" then
                        for ____, ____type in __TS__Iterator(types) do
                            if runEnforcementChecker(_G, ____type) then
                                cull = true
                            end
                        end
                    end
                end
                if (move.id == "rest") and cull then
                    local sleeptalk = movePool:indexOf("sleeptalk")
                    if sleeptalk >= 0 then
                        if movePool.length < 2 then
                            cull = false
                        else
                            self:fastPop(movePool, sleeptalk)
                        end
                    end
                end
                if cull and movePool.length then
                    if (move.category ~= "Status") and (not move.damage) then
                        __TS__ArrayPush(rejectedPool, moveid)
                    end
                    moves:delete(moveid)
                    break
                end
                if cull and #rejectedPool then
                    moves:delete(moveid)
                    break
                end
            end
        end
    until not ((moves.size < 4) and (movePool.length or #rejectedPool))
    local abilityData = Array:from(abilities):map(
        function(____, a) return self.dex.abilities:get(a) end
    )
    Utils:sortBy(
        abilityData,
        function(____, abil) return -abil.rating end
    )
    if abilityData[1] then
        if (abilityData[2] and (abilityData[1].rating <= abilityData[2].rating)) and self:randomChance(1, 2) then
            abilityData[1], abilityData[2] = __TS__Unpack({abilityData[2], abilityData[1]})
        end
        if abilityData[0].rating <= abilityData[1].rating then
            if self:randomChance(1, 2) then
                abilityData[0], abilityData[1] = __TS__Unpack({abilityData[1], abilityData[0]})
            end
        elseif (abilityData[0].rating - 0.6) <= abilityData[1].rating then
            if self:randomChance(2, 3) then
                abilityData[0], abilityData[1] = __TS__Unpack({abilityData[1], abilityData[0]})
            end
        end
        ability = abilityData[0].name
        local rejectAbility = false
        repeat
            do
                rejectAbility = self:shouldCullAbility(ability, types, moves, abilities, counter, movePool, teamDetails, species, isDoubles, isNoDynamax)
                if rejectAbility then
                    local limberFacade = moves:has("facade") and (ability == "Limber")
                    if (ability == abilityData[0].name) and ((abilityData[1].rating >= 1) or limberFacade) then
                        ability = abilityData[1].name
                    elseif ((ability == abilityData[1].name) and abilityData[2]) and ((abilityData[2].rating >= 1) or limberFacade) then
                        ability = abilityData[2].name
                    else
                        ability = abilityData[0].name
                        rejectAbility = false
                    end
                end
            end
        until not rejectAbility
        if (forme == "Copperajah") and gmax then
            ability = "Heavy Metal"
        elseif abilities:has("Guts") and ((((species.id == "gurdurr") or (species.id == "throh")) or moves:has("facade")) or (moves:has("rest") and moves:has("sleeptalk"))) then
            ability = "Guts"
        elseif (abilities:has("Moxie") and ((counter:get("Physical") > 3) or moves:has("bounce"))) and (not isDoubles) then
            ability = "Moxie"
        elseif isDoubles then
            if (abilities:has("Competitive") and (ability ~= "Shadow Tag")) and (ability ~= "Strong Jaw") then
                ability = "Competitive"
            end
            if abilities:has("Friend Guard") then
                ability = "Friend Guard"
            end
            if abilities:has("Gluttony") and moves:has("recycle") then
                ability = "Gluttony"
            end
            if abilities:has("Guts") then
                ability = "Guts"
            end
            if abilities:has("Harvest") then
                ability = "Harvest"
            end
            if abilities:has("Healer") and (abilities:has("Natural Cure") or (abilities:has("Aroma Veil") and self:randomChance(1, 2))) then
                ability = "Healer"
            end
            if abilities:has("Intimidate") then
                ability = "Intimidate"
            end
            if abilities:has("Klutz") and (ability == "Limber") then
                ability = "Klutz"
            end
            if (abilities:has("Magic Guard") and (ability ~= "Friend Guard")) and (ability ~= "Unaware") then
                ability = "Magic Guard"
            end
            if abilities:has("Ripen") then
                ability = "Ripen"
            end
            if abilities:has("Stalwart") then
                ability = "Stalwart"
            end
            if abilities:has("Storm Drain") then
                ability = "Storm Drain"
            end
            if abilities:has("Telepathy") and ((ability == "Pressure") or abilities:has("Analytic")) then
                ability = "Telepathy"
            end
        end
    else
        ability = abilityData[0].name
    end
    if species.requiredItems then
        item = self:sample(species.requiredItems)
    else
        item = self:getHighPriorityItem(ability, types, moves, counter, teamDetails, species, isLead, isDoubles)
        if (item == nil) and isDoubles then
            item = self:getDoublesItem(ability, types, moves, abilities, counter, teamDetails, species)
        end
        if item == nil then
            item = self:getMediumPriorityItem(ability, moves, counter, species, isLead, isDoubles, isNoDynamax)
        end
        if item == nil then
            item = self:getLowPriorityItem(ability, types, moves, abilities, counter, teamDetails, species, isLead, isDoubles, isNoDynamax)
        end
        if item == nil then
            item = (isDoubles and "Sitrus Berry") or "Leftovers"
        end
    end
    if (item == "Leftovers") and types:has("Poison") then
        item = "Black Sludge"
    end
    if (species.baseSpecies == "Pikachu") and (not gmax) then
        forme = "Pikachu" .. tostring(
            self:sample({"", "-Original", "-Hoenn", "-Sinnoh", "-Unova", "-Kalos", "-Alola", "-Partner", "-World"})
        )
    end
    local level
    if isDoubles and species.randomDoubleBattleLevel then
        level = species.randomDoubleBattleLevel
    elseif isNoDynamax then
        local tier = ((species.name:endsWith("-Gmax") and (function() return self.dex.species:get(species.changesFrom).tier end)) or (function() return species.tier end))()
        local tierScale = {Uber = 76, OU = 80, UUBL = 81, UU = 82, RUBL = 83, RU = 84, NUBL = 85, NU = 86, PUBL = 87, PU = 88, ["(PU)"] = 88, NFE = 88}
        local customScale = {zaciancrowned = 65, calyrexshadow = 68, xerneas = 70, necrozmaduskmane = 72, zacian = 72, kyogre = 73, eternatus = 73, zekrom = 74, marshadow = 75, glalie = 78, urshifurapidstrike = 79, haxorus = 80, inteleon = 80, cresselia = 83, octillery = 84, jolteon = 84, swoobat = 84, dugtrio = 84, slurpuff = 84, polteageist = 84, wobbuffet = 86, scrafty = 86, delibird = 100, vespiquen = 96, pikachu = 92, shedinja = 92, solrock = 90, arctozolt = 88, reuniclus = 87, decidueye = 87, noivern = 85, magnezone = 82, slowking = 81}
        level = customScale[species.id] or tierScale[tier]
    elseif species.randomBattleLevel then
        level = species.randomBattleLevel
    else
        level = 80
    end
    local srImmunity = (ability == "Magic Guard") or (item == "Heavy-Duty Boots")
    local srWeakness = (srImmunity and 0) or self.dex:getEffectiveness("Rock", species)
    while evs.hp > 1 do
        local hp = math.floor(
            ((math.floor(
                (((2 * species.baseStats.hp) + ivs.hp) + math.floor(evs.hp / 4)) + 100
            ) * level) / 100) + 10
        )
        local multipleOfFourNecessary = moves:has("substitute") and (((item == "Sitrus Berry") or (item == "Salac Berry")) or (ability == "Power Construct"))
        if multipleOfFourNecessary then
            if (hp % 4) == 0 then
                break
            end
        elseif moves:has("bellydrum") and ((item == "Sitrus Berry") or (ability == "Gluttony")) then
            if (hp % 2) == 0 then
                break
            end
        elseif moves:has("substitute") and moves:has("reversal") then
            if (hp % 4) > 0 then
                break
            end
        else
            if (srWeakness <= 0) or ((hp % (4 / srWeakness)) > 0) then
                break
            end
        end
        evs.hp = evs.hp - 4
    end
    if moves:has("shellsidearm") and (item == "Choice Specs") then
        evs.atk = evs.atk - 4
    end
    if ((not counter:get("Physical")) and (not moves:has("transform"))) and ((not moves:has("shellsidearm")) or (not counter:get("Status"))) then
        evs.atk = 0
        ivs.atk = 0
    end
    if forme == "Nihilego" then
        evs.spd = evs.spd - 32
    end
    if moves:has("gyroball") or moves:has("trickroom") then
        evs.spe = 0
        ivs.spe = 0
    end
    return {
        name = species.baseSpecies,
        species = forme,
        gender = species.gender,
        shiny = self:randomChance(1, 1024),
        gigantamax = gmax,
        level = level,
        moves = Array:from(moves),
        ability = ability,
        evs = evs,
        ivs = ivs,
        item = item
    }
end
function RandomTeams.prototype.getPokemonPool(self, ____type, pokemonToExclude, isMonotype)
    if pokemonToExclude == nil then
        pokemonToExclude = {}
    end
    if isMonotype == nil then
        isMonotype = false
    end
    local exclude = __TS__ArrayMap(
        pokemonToExclude,
        function(____, p) return toID(_G, p.species) end
    )
    local pokemonPool = {}
    for id in pairs(self.dex.data.FormatsData) do
        do
            local species = self.dex.species:get(id)
            if (species.gen > self.gen) or exclude:includes(species.id) then
                goto __continue374
            end
            if isMonotype then
                if not species.types:includes(____type) then
                    goto __continue374
                end
                if type(species.battleOnly) == "string" then
                    species = self.dex.species:get(species.battleOnly)
                    if not species.types:includes(____type) then
                        goto __continue374
                    end
                end
            end
            __TS__ArrayPush(pokemonPool, id)
        end
        ::__continue374::
    end
    return pokemonPool
end
function RandomTeams.prototype.randomTeam(self)
    local seed = self.prng.seed
    local ruleTable = self.dex.formats:getRuleTable(self.format)
    local pokemon = {}
    local isMonotype = (not (not self.forceMonotype)) or ruleTable:has("sametypeclause")
    local typePool = self.dex.types:names()
    local ____type = self.forceMonotype or self:sample(typePool)
    local usePotD = (global.Config and Config.potd) and ruleTable:has("potd")
    local potd = ((usePotD and (function() return self.dex.species:get(Config.potd) end)) or (function() return nil end))()
    local baseFormes = {}
    local tierCount = {}
    local typeCount = {}
    local typeComboCount = {}
    local teamDetails = {}
    local pokemonPool = self:getPokemonPool(____type, pokemon, isMonotype)
    while #pokemonPool and (#pokemon < self.maxTeamSize) do
        do
            local species = self.dex.species:get(
                self:sampleNoReplace(pokemonPool)
            )
            if not species.exists then
                goto __continue381
            end
            if self.format.gameType == "singles" then
                if not species.randomBattleMoves then
                    goto __continue381
                end
            else
                if not species.randomDoubleBattleMoves then
                    goto __continue381
                end
            end
            if baseFormes[species.baseSpecies] then
                goto __continue381
            end
            local ____switch388 = species.baseSpecies
            if ____switch388 == "Arceus" then
                goto ____switch388_case_0
            elseif ____switch388 == "Silvally" then
                goto ____switch388_case_1
            elseif ____switch388 == "Aegislash" then
                goto ____switch388_case_2
            elseif ____switch388 == "Basculin" then
                goto ____switch388_case_3
            elseif ____switch388 == "Gourgeist" then
                goto ____switch388_case_4
            elseif ____switch388 == "Meloetta" then
                goto ____switch388_case_5
            elseif ____switch388 == "Greninja" then
                goto ____switch388_case_6
            elseif ____switch388 == "Darmanitan" then
                goto ____switch388_case_7
            elseif ____switch388 == "Necrozma" then
                goto ____switch388_case_8
            elseif ____switch388 == "Calyrex" then
                goto ____switch388_case_9
            elseif ____switch388 == "Magearna" then
                goto ____switch388_case_10
            elseif ____switch388 == "Toxtricity" then
                goto ____switch388_case_11
            elseif ____switch388 == "Zacian" then
                goto ____switch388_case_12
            elseif ____switch388 == "Zamazenta" then
                goto ____switch388_case_13
            elseif ____switch388 == "Zarude" then
                goto ____switch388_case_14
            elseif ____switch388 == "Appletun" then
                goto ____switch388_case_15
            elseif ____switch388 == "Blastoise" then
                goto ____switch388_case_16
            elseif ____switch388 == "Butterfree" then
                goto ____switch388_case_17
            elseif ____switch388 == "Copperajah" then
                goto ____switch388_case_18
            elseif ____switch388 == "Grimmsnarl" then
                goto ____switch388_case_19
            elseif ____switch388 == "Inteleon" then
                goto ____switch388_case_20
            elseif ____switch388 == "Rillaboom" then
                goto ____switch388_case_21
            elseif ____switch388 == "Snorlax" then
                goto ____switch388_case_22
            elseif ____switch388 == "Urshifu" then
                goto ____switch388_case_23
            elseif ____switch388 == "Giratina" then
                goto ____switch388_case_24
            elseif ____switch388 == "Genesect" then
                goto ____switch388_case_25
            end
            goto ____switch388_end
            ::____switch388_case_0::
            do
            end
            ::____switch388_case_1::
            do
                if self:randomChance(8, 9) and (not isMonotype) then
                    goto __continue381
                end
                goto ____switch388_end
            end
            ::____switch388_case_2::
            do
            end
            ::____switch388_case_3::
            do
            end
            ::____switch388_case_4::
            do
            end
            ::____switch388_case_5::
            do
                if self:randomChance(1, 2) then
                    goto __continue381
                end
                goto ____switch388_end
            end
            ::____switch388_case_6::
            do
                if (self.gen >= 7) and self:randomChance(1, 2) then
                    goto __continue381
                end
                goto ____switch388_end
            end
            ::____switch388_case_7::
            do
                if (species.gen == 8) and self:randomChance(1, 2) then
                    goto __continue381
                end
                goto ____switch388_end
            end
            ::____switch388_case_8::
            do
            end
            ::____switch388_case_9::
            do
                if self:randomChance(2, 3) then
                    goto __continue381
                end
                goto ____switch388_end
            end
            ::____switch388_case_10::
            do
            end
            ::____switch388_case_11::
            do
            end
            ::____switch388_case_12::
            do
            end
            ::____switch388_case_13::
            do
            end
            ::____switch388_case_14::
            do
            end
            ::____switch388_case_15::
            do
            end
            ::____switch388_case_16::
            do
            end
            ::____switch388_case_17::
            do
            end
            ::____switch388_case_18::
            do
            end
            ::____switch388_case_19::
            do
            end
            ::____switch388_case_20::
            do
            end
            ::____switch388_case_21::
            do
            end
            ::____switch388_case_22::
            do
            end
            ::____switch388_case_23::
            do
            end
            ::____switch388_case_24::
            do
            end
            ::____switch388_case_25::
            do
                if (self.gen >= 8) and self:randomChance(1, 2) then
                    goto __continue381
                end
                goto ____switch388_end
            end
            ::____switch388_end::
            if (species.name == "Zoroark") and (#pokemon >= (self.maxTeamSize - 1)) then
                goto __continue381
            end
            if __TS__ArraySome(
                pokemon,
                function(____, pkmn) return pkmn.species == "Zoroark" end
            ) and ({"Zacian", "Zacian-Crowned", "Zamazenta", "Zamazenta-Crowned", "Eternatus"}):includes(species.name) then
                goto __continue381
            end
            local tier = species.tier
            local types = species.types
            local typeCombo = types:slice():sort():join()
            local limitFactor = math.floor((self.maxTeamSize / 6) + 0.5) or 1
            if (tierCount[tier] >= ((((self.forceMonotype or isMonotype) and 2) or 1) * limitFactor)) and (not self:randomChance(
                1,
                math.pow(5, tierCount[tier])
            )) then
                goto __continue381
            end
            if (not isMonotype) and (not self.forceMonotype) then
                local skip = false
                for ____, typeName in __TS__Iterator(types) do
                    if typeCount[typeName] >= (2 * limitFactor) then
                        skip = true
                        break
                    end
                end
                if skip then
                    goto __continue381
                end
            end
            if (not self.forceMonotype) and (typeComboCount[typeCombo] >= (((isMonotype and 2) or 1) * limitFactor)) then
                goto __continue381
            end
            if potd.exists and ((#pokemon == 1) or (self.maxTeamSize == 1)) then
                species = potd
            end
            local set = self:randomSet(
                species,
                teamDetails,
                #pokemon == 0,
                self.format.gameType ~= "singles",
                self.dex.formats:getRuleTable(self.format):has("dynamaxclause")
            )
            __TS__ArrayPush(pokemon, set)
            if #pokemon == self.maxTeamSize then
                local illusion = teamDetails.illusion
                if illusion then
                    pokemon[illusion].level = pokemon[self.maxTeamSize].level
                end
                break
            end
            baseFormes[species.baseSpecies] = 1
            if tierCount[tier] then
                tierCount[tier] = tierCount[tier] + 1
            else
                tierCount[tier] = 1
            end
            for ____, typeName in __TS__Iterator(types) do
                if typeCount[typeName] ~= nil then
                    typeCount[typeName] = typeCount[typeName] + 1
                else
                    typeCount[typeName] = 1
                end
            end
            if typeComboCount[typeCombo] ~= nil then
                typeComboCount[typeCombo] = typeComboCount[typeCombo] + 1
            else
                typeComboCount[typeCombo] = 1
            end
            if (set.ability == "Drizzle") or set.moves:includes("raindance") then
                teamDetails.rain = 1
            end
            if (set.ability == "Drought") or set.moves:includes("sunnyday") then
                teamDetails.sun = 1
            end
            if set.ability == "Sand Stream" then
                teamDetails.sand = 1
            end
            if set.ability == "Snow Warning" then
                teamDetails.hail = 1
            end
            if set.moves:includes("spikes") then
                teamDetails.spikes = (teamDetails.spikes or 0) + 1
            end
            if set.moves:includes("stealthrock") then
                teamDetails.stealthRock = 1
            end
            if set.moves:includes("stickyweb") then
                teamDetails.stickyWeb = 1
            end
            if set.moves:includes("toxicspikes") then
                teamDetails.toxicSpikes = 1
            end
            if set.moves:includes("defog") then
                teamDetails.defog = 1
            end
            if set.moves:includes("rapidspin") then
                teamDetails.rapidSpin = 1
            end
            if set.moves:includes("auroraveil") or (set.moves:includes("reflect") and set.moves:includes("lightscreen")) then
                teamDetails.screens = 1
            end
            if set.ability == "Illusion" then
                teamDetails.illusion = #pokemon
            end
        end
        ::__continue381::
    end
    if (#pokemon < self.maxTeamSize) and (#pokemon < 12) then
        error(
            __TS__New(
                Error,
                ((("Could not build a random team for " .. tostring(self.format)) .. " (seed=") .. tostring(seed)) .. ")"
            ),
            0
        )
    end
    return pokemon
end
function RandomTeams.prototype.randomCAP1v1Team(self)
    local pokemon = {}
    local pokemonPool = __TS__ObjectKeys(self.randomCAP1v1Sets)
    while #pokemonPool and (#pokemon < self.maxTeamSize) do
        do
            local species = self.dex.species:get(
                self:sampleNoReplace(pokemonPool)
            )
            if not species.exists then
                error(
                    __TS__New(
                        Error,
                        (("Invalid Pokemon \"" .. tostring(species)) .. "\" in ") .. tostring(self.format)
                    ),
                    0
                )
            end
            if self.forceMonotype and (not species.types:includes(self.forceMonotype)) then
                goto __continue428
            end
            local setData = self:sample(self.randomCAP1v1Sets[species.name])
            local set = {
                name = species.baseSpecies,
                species = species.name,
                gender = species.gender,
                item = self:sampleIfArray(setData.item) or "",
                ability = self:sampleIfArray(setData.ability),
                shiny = self:randomChance(1, 1024),
                evs = __TS__ObjectAssign({hp = 0, atk = 0, def = 0, spa = 0, spd = 0, spe = 0}, setData.evs),
                nature = setData.nature,
                ivs = __TS__ObjectAssign({hp = 31, atk = 31, def = 31, spa = 31, spd = 31, spe = 31}, setData.ivs or ({})),
                moves = setData.moves:map(
                    function(____, move) return self:sampleIfArray(move) end
                )
            }
            __TS__ArrayPush(pokemon, set)
        end
        ::__continue428::
    end
    return pokemon
end
function RandomTeams.prototype.randomBSSFactorySet(self, species, teamData)
    local id = toID(_G, species.name)
    local setList = self.randomBSSFactorySets[id].sets
    local movesMax = {batonpass = 1, stealthrock = 1, toxicspikes = 1, trickroom = 1, auroraveil = 1}
    local requiredMoves = {}
    local effectivePool = {}
    local priorityPool = {}
    for ____, curSet in __TS__Iterator(setList) do
        do
            local reject = false
            local hasRequiredMove = false
            local curSetMoveVariants = {}
            for ____, move in __TS__Iterator(curSet.moves) do
                local variantIndex = self:random(move.length)
                local moveId = toID(_G, move[variantIndex])
                if movesMax[moveId] and (teamData.has[moveId] >= movesMax[moveId]) then
                    reject = true
                    break
                end
                if requiredMoves[moveId] and (not teamData.has[requiredMoves[moveId]]) then
                    hasRequiredMove = true
                end
                __TS__ArrayPush(curSetMoveVariants, variantIndex)
            end
            if reject then
                goto __continue433
            end
            local set = {set = curSet, moveVariants = curSetMoveVariants}
            __TS__ArrayPush(effectivePool, set)
            if hasRequiredMove then
                __TS__ArrayPush(priorityPool, set)
            end
        end
        ::__continue433::
    end
    if #priorityPool then
        effectivePool = priorityPool
    end
    if not #effectivePool then
        if not teamData.forceResult then
            return nil
        end
        for ____, curSet in __TS__Iterator(setList) do
            __TS__ArrayPush(effectivePool, {set = curSet})
        end
    end
    local setData = self:sample(effectivePool)
    local moves = {}
    for ____, ____value in __TS__Iterator(
        setData.set.moves:entries()
    ) do
        local i
        i = ____value[1]
        local moveSlot
        moveSlot = ____value[2]
        __TS__ArrayPush(
            moves,
            ((setData.moveVariants and (function() return moveSlot[setData.moveVariants[i]] end)) or (function() return self:sample(moveSlot) end))()
        )
    end
    local setDataAbility = self:sampleIfArray(setData.set.ability)
    return {
        name = (setData.set.nickname or setData.set.name) or species.baseSpecies,
        species = setData.set.species,
        gigantamax = setData.set.gigantamax,
        gender = (setData.set.gender or species.gender) or ((self:randomChance(1, 2) and "M") or "F"),
        item = self:sampleIfArray(setData.set.item) or "",
        ability = setDataAbility or species.abilities["0"],
        shiny = (((type(setData.set.shiny) == "nil") and (function() return self:randomChance(1, 1024) end)) or (function() return setData.set.shiny end))(),
        level = setData.set.level or 50,
        happiness = ((type(setData.set.happiness) == "nil") and 255) or setData.set.happiness,
        evs = __TS__ObjectAssign({hp = 0, atk = 0, def = 0, spa = 0, spd = 0, spe = 0}, setData.set.evs),
        ivs = __TS__ObjectAssign({hp = 31, atk = 31, def = 31, spa = 31, spd = 31, spe = 31}, setData.set.ivs),
        nature = setData.set.nature or "Serious",
        moves = moves
    }
end
function RandomTeams.prototype.randomBSSFactoryTeam(self, side, depth)
    if depth == nil then
        depth = 0
    end
    local forceResult = depth >= 4
    local pokemon = {}
    local pokemonPool = __TS__ObjectKeys(self.randomBSSFactorySets)
    local teamData = {typeCount = {}, typeComboCount = {}, baseFormes = {}, has = {}, forceResult = forceResult, weaknesses = {}, resistances = {}}
    local requiredMoveFamilies = {}
    local requiredMoves = {}
    local weatherAbilitiesSet = {drizzle = "raindance", drought = "sunnyday", snowwarning = "hail", sandstream = "sandstorm"}
    local resistanceAbilities = {waterabsorb = {"Water"}, flashfire = {"Fire"}, lightningrod = {"Electric"}, voltabsorb = {"Electric"}, thickfat = {"Ice", "Fire"}, levitate = {"Ground"}}
    while #pokemonPool and (#pokemon < self.maxTeamSize) do
        do
            local maxUsage = 0
            local sets = {}
            for ____, specie in ipairs(pokemonPool) do
                do
                    if teamData.baseFormes[self.dex.species:get(specie).baseSpecies] then
                        goto __continue446
                    end
                    local usage = self.randomBSSFactorySets[specie].usage
                    sets[specie] = usage + maxUsage
                    maxUsage = maxUsage + usage
                end
                ::__continue446::
            end
            local usage = self:random(1, maxUsage)
            local last = 0
            local specie
            for ____, key in ipairs(
                __TS__ObjectKeys(sets)
            ) do
                if (usage > last) and (usage <= sets[key]) then
                    specie = key
                    break
                end
                last = sets[key]
            end
            local species = self.dex.species:get(specie)
            if not species.exists then
                goto __continue445
            end
            if self.forceMonotype and (not species.types:includes(self.forceMonotype)) then
                goto __continue445
            end
            if teamData.baseFormes[species.baseSpecies] then
                goto __continue445
            end
            local types = species.types
            local skip = false
            for ____, ____type in __TS__Iterator(types) do
                if (teamData.typeCount[____type] > 1) and self:randomChance(4, 5) then
                    skip = true
                    break
                end
            end
            if skip then
                goto __continue445
            end
            local set = self:randomBSSFactorySet(species, teamData)
            if not set then
                goto __continue445
            end
            local typeCombo = types:slice():sort():join()
            if (set.ability == "Drought") or (set.ability == "Drizzle") then
                typeCombo = set.ability
            end
            if teamData.typeComboCount[typeCombo] ~= nil then
                goto __continue445
            end
            local itemData = self.dex.items:get(set.item)
            if teamData.has[itemData.id] then
                goto __continue445
            end
            __TS__ArrayPush(pokemon, set)
            for ____, ____type in __TS__Iterator(types) do
                if teamData.typeCount[____type] ~= nil then
                    local ____obj, ____index = teamData.typeCount, ____type
                    ____obj[____index] = ____obj[____index] + 1
                else
                    teamData.typeCount[____type] = 1
                end
            end
            teamData.typeComboCount[typeCombo] = 1
            teamData.baseFormes[species.baseSpecies] = 1
            teamData.has[itemData.id] = 1
            local abilityState = self.dex.abilities:get(set.ability)
            if weatherAbilitiesSet[abilityState.id] ~= nil then
                teamData.weather = weatherAbilitiesSet[abilityState.id]
            end
            for ____, move in __TS__Iterator(set.moves) do
                local moveId = toID(_G, move)
                if teamData.has[moveId] ~= nil then
                    local ____obj, ____index = teamData.has, moveId
                    ____obj[____index] = ____obj[____index] + 1
                else
                    teamData.has[moveId] = 1
                end
                if requiredMoves[moveId] ~= nil then
                    teamData.has[requiredMoves[moveId]] = 1
                end
            end
            for ____, typeName in __TS__Iterator(
                self.dex.types:names()
            ) do
                do
                    if teamData.resistances[typeName] >= 1 then
                        goto __continue468
                    end
                    if resistanceAbilities[abilityState.id]:includes(typeName) or (not self.dex:getImmunity(typeName, types)) then
                        teamData.resistances[typeName] = (teamData.resistances[typeName] or 0) + 1
                        if teamData.resistances[typeName] >= 1 then
                            teamData.weaknesses[typeName] = 0
                        end
                        goto __continue468
                    end
                    local typeMod = self.dex:getEffectiveness(typeName, types)
                    if typeMod < 0 then
                        teamData.resistances[typeName] = (teamData.resistances[typeName] or 0) + 1
                        if teamData.resistances[typeName] >= 1 then
                            teamData.weaknesses[typeName] = 0
                        end
                    elseif typeMod > 0 then
                        teamData.weaknesses[typeName] = (teamData.weaknesses[typeName] or 0) + 1
                    end
                end
                ::__continue468::
            end
        end
        ::__continue445::
    end
    if #pokemon < self.maxTeamSize then
        return self:randomBSSFactoryTeam(
            side,
            (function()
                depth = depth + 1
                return depth
            end)()
        )
    end
    if not teamData.forceResult then
        for ____, requiredFamily in ipairs(requiredMoveFamilies) do
            if not teamData.has[requiredFamily] then
                return self:randomBSSFactoryTeam(
                    side,
                    (function()
                        depth = depth + 1
                        return depth
                    end)()
                )
            end
        end
        for ____type in pairs(teamData.weaknesses) do
            if teamData.weaknesses[____type] >= 3 then
                return self:randomBSSFactoryTeam(
                    side,
                    (function()
                        depth = depth + 1
                        return depth
                    end)()
                )
            end
        end
    end
    return pokemon
end
____exports.default = ____exports.RandomTeams
return ____exports
