--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____lib = require("lib.index")
local Utils = ____lib.Utils
____exports.Rulesets = {
    standard = {effectType = "ValidatorRule", name = "Standard", desc = "The standard ruleset for all offical Smogon singles tiers (Ubers, OU, etc.)", ruleset = {"Obtainable", "Team Preview", "Sleep Clause Mod", "Species Clause", "Nickname Clause", "OHKO Clause", "Evasion Moves Clause", "Endless Battle Clause", "HP Percentage Mod", "Cancel Mod"}},
    standardnext = {effectType = "ValidatorRule", name = "Standard NEXT", desc = "The standard ruleset for the NEXT mod", ruleset = {"+Unreleased", "Sleep Clause Mod", "Species Clause", "Nickname Clause", "OHKO Clause", "HP Percentage Mod", "Cancel Mod"}, banlist = {"Soul Dew"}},
    flatrules = {effectType = "ValidatorRule", name = "Flat Rules", desc = "The in-game Flat Rules: Adjust Level Down 50, Species Clause, Item Clause, -Mythical, -Restricted Legendary, Bring 6 Pick 3-6 depending on game type.", ruleset = {"Obtainable", "Team Preview", "Species Clause", "Nickname Clause", "Item Clause", "Adjust Level Down = 50", "Picked Team Size = Auto", "Cancel Mod"}, banlist = {"Mythical", "Restricted Legendary"}},
    limittworestricted = {
        effectType = "ValidatorRule",
        name = "Limit Two Restricted",
        desc = "Limit two restricted Pokémon (flagged with * in the rules list)",
        onValidateTeam = function(self, team)
            local restrictedSpecies = {}
            for ____, set in __TS__Iterator(team) do
                local species = self.dex.species:get(set.species)
                if self.ruleTable:isRestrictedSpecies(species) then
                    __TS__ArrayPush(restrictedSpecies, species.name)
                end
            end
            if #restrictedSpecies > 2 then
                return {
                    ("You can only use up to two restricted Pokémon (you have: " .. __TS__ArrayJoin(restrictedSpecies, ", ")) .. ")"
                }
            end
        end
    },
    limitonerestricted = {
        effectType = "ValidatorRule",
        name = "Limit One Restricted",
        desc = "Limit one restricted Pokémon (flagged with * in the rules list)",
        onValidateTeam = function(self, team)
            local restrictedSpecies = {}
            for ____, set in __TS__Iterator(team) do
                local species = self.dex.species:get(set.species)
                if self.ruleTable:isRestrictedSpecies(species) then
                    __TS__ArrayPush(restrictedSpecies, species.name)
                end
            end
            if #restrictedSpecies > 1 then
                return {
                    ("You can only use one restricted Pokémon (you have: " .. __TS__ArrayJoin(restrictedSpecies, ", ")) .. ")"
                }
            end
        end
    },
    standarddoubles = {effectType = "ValidatorRule", name = "Standard Doubles", desc = "The standard ruleset for all official Smogon doubles tiers", ruleset = {"Obtainable", "Team Preview", "Species Clause", "Nickname Clause", "OHKO Clause", "Evasion Moves Clause", "Gravity Sleep Clause", "Endless Battle Clause", "HP Percentage Mod", "Cancel Mod"}},
    standardnatdex = {
        effectType = "ValidatorRule",
        name = "Standard NatDex",
        desc = "The standard ruleset for all National Dex tiers",
        ruleset = {"Obtainable", "+Unobtainable", "+Past", "Team Preview", "Nickname Clause", "HP Percentage Mod", "Cancel Mod", "Endless Battle Clause"},
        onValidateSet = function(self, set)
            local unobtainables = {"Eevee-Starter", "Floette-Eternal", "Pichu-Spiky-eared", "Pikachu-Belle", "Pikachu-Cosplay", "Pikachu-Libre", "Pikachu-PhD", "Pikachu-Pop-Star", "Pikachu-Rock-Star", "Pikachu-Starter", "Eternatus-Eternamax"}
            local species = self.dex.species:get(set.species)
            if unobtainables:includes(species.name) then
                if self.ruleTable:has(
                    "+pokemon:" .. tostring(species.id)
                ) then
                    return
                end
                return {
                    tostring(set.name or set.species) .. " does not exist in the National Dex."
                }
            end
            if species.tier == "Unreleased" then
                local basePokemon = self:toID(species.baseSpecies)
                if self.ruleTable:has(
                    "+pokemon:" .. tostring(species.id)
                ) or self.ruleTable:has(
                    "+basepokemon:" .. tostring(basePokemon)
                ) then
                    return
                end
                return {
                    tostring(set.name or set.species) .. " does not exist in the National Dex."
                }
            end
            if not set.item then
                return
            end
            local item = self.dex.items:get(set.item)
            if not item.isNonstandard then
                return
            end
            if ((({"Past", "Unobtainable"}):includes(item.isNonstandard) and (not item.zMove)) and (not item.itemUser)) and (not item.forcedForme) then
                if self.ruleTable:has(
                    "+item:" .. tostring(item.id)
                ) then
                    return
                end
                return {
                    ((((tostring(set.name) .. "'s item ") .. tostring(item.name)) .. " does not exist in Gen ") .. tostring(self.dex.gen)) .. "."
                }
            end
        end
    },
    obtainable = {
        effectType = "ValidatorRule",
        name = "Obtainable",
        desc = "Makes sure the team is possible to obtain in-game.",
        ruleset = {"Obtainable Moves", "Obtainable Abilities", "Obtainable Formes", "EV Limit = Auto", "Obtainable Misc"},
        banlist = {"Unreleased", "Unobtainable", "Nonexistent"},
        onValidateTeam = function(self, team, format)
            local kyuremCount = 0
            local necrozmaDMCount = 0
            local necrozmaDWCount = 0
            local calyrexCount = 0
            for ____, set in __TS__Iterator(team) do
                if (set.species == "Kyurem-White") or (set.species == "Kyurem-Black") then
                    if kyuremCount > 0 then
                        return {"You cannot have more than one Kyurem-Black/Kyurem-White.", "(It's untradeable and you can only make one with the DNA Splicers.)"}
                    end
                    kyuremCount = kyuremCount + 1
                end
                if set.species == "Necrozma-Dusk-Mane" then
                    if necrozmaDMCount > 0 then
                        return {"You cannot have more than one Necrozma-Dusk-Mane", "(It's untradeable and you can only make one with the N-Solarizer.)"}
                    end
                    necrozmaDMCount = necrozmaDMCount + 1
                end
                if set.species == "Necrozma-Dawn-Wings" then
                    if necrozmaDWCount > 0 then
                        return {"You cannot have more than one Necrozma-Dawn-Wings", "(It's untradeable and you can only make one with the N-Lunarizer.)"}
                    end
                    necrozmaDWCount = necrozmaDWCount + 1
                end
                if (set.species == "Calyrex-Ice") or (set.species == "Calyrex-Shadow") then
                    if calyrexCount > 0 then
                        return {"You cannot have more than one Calyrex-Ice/Calyrex-Shadow.", "(It's untradeable and you can only make one with the Reins of Unity.)"}
                    end
                    calyrexCount = calyrexCount + 1
                end
            end
            return {}
        end
    },
    obtainablemoves = {effectType = "ValidatorRule", name = "Obtainable Moves", desc = "Makes sure moves are learnable by the species."},
    obtainableabilities = {effectType = "ValidatorRule", name = "Obtainable Abilities", desc = "Makes sure abilities match the species."},
    obtainableformes = {effectType = "ValidatorRule", name = "Obtainable Formes", desc = "Makes sure in-battle formes only appear in-battle."},
    obtainablemisc = {
        effectType = "ValidatorRule",
        name = "Obtainable Misc",
        desc = "Validate all obtainability things that aren't moves/abilities (Hidden Power type, gender, IVs, events, duplicate moves).",
        onChangeSet = function(self, set)
            local species = self.dex.species:get(set.species)
            if species.gender then
                if set.gender ~= species.gender then
                    set.gender = species.gender
                end
            else
                if (set.gender ~= "M") and (set.gender ~= "F") then
                    set.gender = ""
                end
            end
            if set.moves then
                local hasMove = {}
                for ____, moveId in __TS__Iterator(set.moves) do
                    local move = self.dex.moves:get(moveId)
                    local moveid = move.id
                    if hasMove[moveid] then
                        return {
                            ((tostring(species.baseSpecies) .. " has multiple copies of ") .. tostring(move.name)) .. "."
                        }
                    end
                    hasMove[moveid] = true
                end
            end
        end
    },
    hoennpokedex = {
        effectType = "ValidatorRule",
        name = "Hoenn Pokedex",
        desc = "Only allows Pok&eacute;mon native to the Hoenn region (OR/AS)",
        onValidateSet = function(self, set, format)
            local hoennDex = {"Abra", "Absol", "Aggron", "Alakazam", "Altaria", "Anorith", "Armaldo", "Aron", "Azumarill", "Azurill", "Bagon", "Baltoy", "Banette", "Barboach", "Beautifly", "Beldum", "Bellossom", "Blaziken", "Breloom", "Budew", "Cacnea", "Cacturne", "Camerupt", "Carvanha", "Cascoon", "Castform", "Chimecho", "Chinchou", "Chingling", "Clamperl", "Claydol", "Combusken", "Corphish", "Corsola", "Cradily", "Crawdaunt", "Crobat", "Delcatty", "Dodrio", "Doduo", "Donphan", "Dusclops", "Dusknoir", "Duskull", "Dustox", "Electrike", "Electrode", "Exploud", "Feebas", "Flygon", "Froslass", "Gallade", "Gardevoir", "Geodude", "Girafarig", "Glalie", "Gloom", "Golbat", "Goldeen", "Golduck", "Golem", "Gorebyss", "Graveler", "Grimer", "Grovyle", "Grumpig", "Gulpin", "Gyarados", "Hariyama", "Heracross", "Horsea", "Huntail", "Igglybuff", "Illumise", "Jigglypuff", "Kadabra", "Kecleon", "Kingdra", "Kirlia", "Koffing", "Lairon", "Lanturn", "Latias", "Latios", "Lileep", "Linoone", "Lombre", "Lotad", "Loudred", "Ludicolo", "Lunatone", "Luvdisc", "Machamp", "Machoke", "Machop", "Magcargo", "Magikarp", "Magnemite", "Magneton", "Magnezone", "Makuhita", "Manectric", "Marill", "Marshtomp", "Masquerain", "Mawile", "Medicham", "Meditite", "Metagross", "Metang", "Mightyena", "Milotic", "Minun", "Mudkip", "Muk", "Natu", "Nincada", "Ninetales", "Ninjask", "Nosepass", "Numel", "Nuzleaf", "Oddish", "Pelipper", "Phanpy", "Pichu", "Pikachu", "Pinsir", "Plusle", "Poochyena", "Probopass", "Psyduck", "Raichu", "Ralts", "Regice", "Regirock", "Registeel", "Relicanth", "Rhydon", "Rhyhorn", "Rhyperior", "Roselia", "Roserade", "Sableye", "Salamence", "Sandshrew", "Sandslash", "Sceptile", "Seadra", "Seaking", "Sealeo", "Seedot", "Seviper", "Sharpedo", "Shedinja", "Shelgon", "Shiftry", "Shroomish", "Shuppet", "Silcoon", "Skarmory", "Skitty", "Slaking", "Slakoth", "Slugma", "Snorunt", "Solrock", "Spheal", "Spinda", "Spoink", "Starmie", "Staryu", "Surskit", "Swablu", "Swalot", "Swampert", "Swellow", "Taillow", "Tentacool", "Tentacruel", "Torchic", "Torkoal", "Trapinch", "Treecko", "Tropius", "Vibrava", "Vigoroth", "Vileplume", "Volbeat", "Voltorb", "Vulpix", "Wailmer", "Wailord", "Walrein", "Weezing", "Whiscash", "Whismur", "Wigglytuff", "Wingull", "Wobbuffet", "Wurmple", "Wynaut", "Xatu", "Zangoose", "Zigzagoon", "Zubat"}
            local species = self.dex.species:get(set.species or set.name)
            if (not hoennDex:includes(species.baseSpecies)) and (not self.ruleTable:has(
                "+" .. tostring(species.id)
            )) then
                return {
                    tostring(species.baseSpecies) .. " is not in the Hoenn Pokédex."
                }
            end
        end
    },
    sinnohpokedex = {
        effectType = "ValidatorRule",
        name = "Sinnoh Pokedex",
        desc = "Only allows Pok&eacute;mon native to the Sinnoh region (Platinum)",
        onValidateSet = function(self, set, format)
            local sinnohDex = {"Turtwig", "Grotle", "Torterra", "Chimchar", "Monferno", "Infernape", "Piplup", "Prinplup", "Empoleon", "Starly", "Staravia", "Staraptor", "Bidoof", "Bibarel", "Kricketot", "Kricketune", "Shinx", "Luxio", "Luxray", "Abra", "Kadabra", "Alakazam", "Magikarp", "Gyarados", "Budew", "Roselia", "Roserade", "Zubat", "Golbat", "Crobat", "Geodude", "Graveler", "Golem", "Onix", "Steelix", "Cranidos", "Rampardos", "Shieldon", "Bastiodon", "Machop", "Machoke", "Machamp", "Psyduck", "Golduck", "Burmy", "Wormadam", "Mothim", "Wurmple", "Silcoon", "Beautifly", "Cascoon", "Dustox", "Combee", "Vespiquen", "Pachirisu", "Buizel", "Floatzel", "Cherubi", "Cherrim", "Shellos", "Gastrodon", "Heracross", "Aipom", "Ambipom", "Drifloon", "Drifblim", "Buneary", "Lopunny", "Gastly", "Haunter", "Gengar", "Misdreavus", "Mismagius", "Murkrow", "Honchkrow", "Glameow", "Purugly", "Goldeen", "Seaking", "Barboach", "Whiscash", "Chingling", "Chimecho", "Stunky", "Skuntank", "Meditite", "Medicham", "Bronzor", "Bronzong", "Ponyta", "Rapidash", "Bonsly", "Sudowoodo", "Mime Jr.", "Mr. Mime", "Happiny", "Chansey", "Blissey", "Cleffa", "Clefairy", "Clefable", "Chatot", "Pichu", "Pikachu", "Raichu", "Hoothoot", "Noctowl", "Spiritomb", "Gible", "Gabite", "Garchomp", "Munchlax", "Snorlax", "Unown", "Riolu", "Lucario", "Wooper", "Quagsire", "Wingull", "Pelipper", "Girafarig", "Hippopotas", "Hippowdon", "Azurill", "Marill", "Azumarill", "Skorupi", "Drapion", "Croagunk", "Toxicroak", "Carnivine", "Remoraid", "Octillery", "Finneon", "Lumineon", "Tentacool", "Tentacruel", "Feebas", "Milotic", "Mantyke", "Mantine", "Snover", "Abomasnow", "Sneasel", "Weavile", "Uxie", "Mesprit", "Azelf", "Dialga", "Palkia", "Manaphy", "Rotom", "Gligar", "Gliscor", "Nosepass", "Probopass", "Ralts", "Kirlia", "Gardevoir", "Gallade", "Lickitung", "Lickilicky", "Eevee", "Vaporeon", "Jolteon", "Flareon", "Espeon", "Umbreon", "Leafeon", "Glaceon", "Swablu", "Altaria", "Togepi", "Togetic", "Togekiss", "Houndour", "Houndoom", "Magnemite", "Magneton", "Magnezone", "Tangela", "Tangrowth", "Yanma", "Yanmega", "Tropius", "Rhyhorn", "Rhydon", "Rhyperior", "Duskull", "Dusclops", "Dusknoir", "Porygon", "Porygon2", "Porygon-Z", "Scyther", "Scizor", "Elekid", "Electabuzz", "Electivire", "Magby", "Magmar", "Magmortar", "Swinub", "Piloswine", "Mamoswine", "Snorunt", "Glalie", "Froslass", "Absol", "Giratina"}
            local species = self.dex.species:get(set.species or set.name)
            if ((not sinnohDex:includes(species.baseSpecies)) or (species.gen > 4)) and (not self.ruleTable:has(
                "+" .. tostring(species.id)
            )) then
                return {
                    tostring(species.name) .. " is not in the Sinnoh Pokédex."
                }
            end
        end
    },
    oldunovapokedex = {
        effectType = "ValidatorRule",
        name = "Old Unova Pokedex",
        desc = "Only allows Pok&eacute;mon native to the Unova region as of the original Black/White games",
        onValidateSet = function(self, set, format)
            local species = self.dex.species:get(set.species or set.name)
            local isUnova = (((species.num >= 494) and (species.num <= 649)) and (not ({"Black", "White", "Therian", "Resolute"}):includes(species.forme))) and (species.gen <= 5)
            if (not isUnova) and (not self.ruleTable:has(
                "+" .. tostring(species.id)
            )) then
                return {
                    tostring(species.baseSpecies) .. " is not in the Old Unova Pokédex."
                }
            end
        end
    },
    newunovapokedex = {
        effectType = "ValidatorRule",
        name = "New Unova Pokedex",
        desc = "Only allows Pok&eacute;mon native to the Unova region as of the Black 2/White 2 games",
        onValidateSet = function(self, set, format)
            local unovaDex = {"Victini", "Snivy", "Servine", "Serperior", "Tepig", "Pignite", "Emboar", "Oshawott", "Dewott", "Samurott", "Patrat", "Watchog", "Purrloin", "Liepard", "Pidove", "Tranquill", "Unfezant", "Unfezant", "Sewaddle", "Swadloon", "Leavanny", "Sunkern", "Sunflora", "Lillipup", "Herdier", "Stoutland", "Mareep", "Flaaffy", "Ampharos", "Psyduck", "Golduck", "Azurill", "Marill", "Azumarill", "Riolu", "Lucario", "Dunsparce", "Audino", "Pansage", "Simisage", "Pansear", "Simisear", "Panpour", "Simipour", "Venipede", "Whirlipede", "Scolipede", "Koffing", "Weezing", "Magnemite", "Magneton", "Magnezone", "Growlithe", "Arcanine", "Magby", "Magmar", "Magmortar", "Elekid", "Electabuzz", "Electivire", "Rattata", "Raticate", "Zubat", "Golbat", "Crobat", "Grimer", "Muk", "Woobat", "Swoobat", "Roggenrola", "Boldore", "Gigalith", "Onix", "Steelix", "Timburr", "Gurdurr", "Conkeldurr", "Drilbur", "Excadrill", "Skitty", "Delcatty", "Buneary", "Lopunny", "Cottonee", "Whimsicott", "Petilil", "Lilligant", "Munna", "Musharna", "Cleffa", "Clefairy", "Clefable", "Eevee", "Vaporeon", "Jolteon", "Flareon", "Espeon", "Umbreon", "Leafeon", "Glaceon", "Sandile", "Krokorok", "Krookodile", "Darumaka", "Darmanitan", "Basculin", "Basculin", "Trubbish", "Garbodor", "Minccino", "Cinccino", "Rufflet", "Braviary", "Vullaby", "Mandibuzz", "Sandshrew", "Sandslash", "Dwebble", "Crustle", "Scraggy", "Scrafty", "Maractus", "Sigilyph", "Trapinch", "Vibrava", "Flygon", "Yamask", "Cofagrigus", "Tirtouga", "Carracosta", "Archen", "Archeops", "Klink", "Klang", "Klinklang", "Budew", "Roselia", "Roserade", "Gothita", "Gothorita", "Gothitelle", "Solosis", "Duosion", "Reuniclus", "Combee", "Vespiquen", "Emolga", "Heracross", "Pinsir", "Blitzle", "Zebstrika", "Buizel", "Floatzel", "Zorua", "Zoroark", "Ducklett", "Swanna", "Karrablast", "Escavalier", "Shelmet", "Accelgor", "Deerling", "Sawsbuck", "Foongus", "Amoonguss", "Castform", "Nosepass", "Probopass", "Aron", "Lairon", "Aggron", "Baltoy", "Claydol", "Larvesta", "Volcarona", "Joltik", "Galvantula", "Ferroseed", "Ferrothorn", "Tynamo", "Eelektrik", "Eelektross", "Frillish", "Jellicent", "Alomomola", "Axew", "Fraxure", "Haxorus", "Zangoose", "Seviper", "Elgyem", "Beheeyem", "Litwick", "Lampent", "Chandelure", "Heatmor", "Durant", "Cubchoo", "Beartic", "Cryogonal", "Tornadus", "Thundurus", "Landorus", "Skorupi", "Drapion", "Skarmory", "Numel", "Camerupt", "Spoink", "Grumpig", "Drifloon", "Drifblim", "Shuppet", "Banette", "Wingull", "Pelipper", "Lunatone", "Solrock", "Absol", "Tangela", "Tangrowth", "Mienfoo", "Mienshao", "Gligar", "Gliscor", "Pawniard", "Bisharp", "Cobalion", "Terrakion", "Virizion", "Tympole", "Palpitoad", "Seismitoad", "Stunfisk", "Shuckle", "Mantyke", "Mantine", "Remoraid", "Octillery", "Corsola", "Staryu", "Starmie", "Wailmer", "Wailord", "Lapras", "Spheal", "Sealeo", "Walrein", "Swablu", "Altaria", "Vulpix", "Ninetales", "Bronzor", "Bronzong", "Sneasel", "Weavile", "Delibird", "Vanillite", "Vanillish", "Vanilluxe", "Swinub", "Piloswine", "Mamoswine", "Ditto", "Beldum", "Metang", "Metagross", "Seel", "Dewgong", "Throh", "Sawk", "Bouffalant", "Druddigon", "Golett", "Golurk", "Deino", "Zweilous", "Hydreigon", "Slakoth", "Vigoroth", "Slaking", "Corphish", "Crawdaunt", "Igglybuff", "Jigglypuff", "Wigglytuff", "Lickitung", "Lickilicky", "Yanma", "Yanmega", "Tropius", "Carnivine", "Croagunk", "Toxicroak", "Larvitar", "Pupitar", "Tyranitar", "Reshiram", "Zekrom", "Kyurem", "Keldeo", "Meloetta", "Genesect"}
            local species = self.dex.species:get(set.species or set.name)
            local isUnova = unovaDex:includes(species.baseSpecies) and (species.gen <= 5)
            if (not isUnova) and (not self.ruleTable:has(
                "+" .. tostring(species.id)
            )) then
                return {
                    tostring(species.baseSpecies) .. " is not in the New Unova Pokédex."
                }
            end
        end
    },
    kalospokedex = {
        effectType = "ValidatorRule",
        name = "Kalos Pokedex",
        desc = "Only allows Pok&eacute;mon native to the Kalos region (XY)",
        onValidateSet = function(self, set, format)
            local kalosDex = {"Chespin", "Quilladin", "Chesnaught", "Fennekin", "Braixen", "Delphox", "Froakie", "Frogadier", "Greninja", "Bunnelby", "Diggersby", "Zigzagoon", "Linoone", "Fletchling", "Fletchinder", "Talonflame", "Pidgey", "Pidgeotto", "Pidgeot", "Scatterbug", "Spewpa", "Vivillon", "Caterpie", "Metapod", "Butterfree", "Weedle", "Kakuna", "Beedrill", "Pansage", "Simisage", "Pansear", "Simisear", "Panpour", "Simipour", "Pichu", "Pikachu", "Raichu", "Bidoof", "Bibarel", "Dunsparce", "Azurill", "Marill", "Azumarill", "Burmy", "Wormadam", "Mothim", "Surskit", "Masquerain", "Magikarp", "Gyarados", "Corphish", "Crawdaunt", "Goldeen", "Seaking", "Carvanha", "Sharpedo", "Litleo", "Pyroar", "Psyduck", "Golduck", "Farfetch’d", "Riolu", "Lucario", "Ralts", "Kirlia", "Gardevoir", "Gallade", "Flabébé", "Floette", "Florges", "Budew", "Roselia", "Roserade", "Ledyba", "Ledian", "Combee", "Vespiquen", "Skitty", "Delcatty", "Bulbasaur", "Ivysaur", "Venusaur", "Charmander", "Charmeleon", "Charizard", "Squirtle", "Wartortle", "Blastoise", "Skiddo", "Gogoat", "Pancham", "Pangoro", "Furfrou", "Doduo", "Dodrio", "Plusle", "Minun", "Gulpin", "Swalot", "Scraggy", "Scrafty", "Abra", "Kadabra", "Alakazam", "Oddish", "Gloom", "Vileplume", "Bellossom", "Sentret", "Furret", "Nincada", "Ninjask", "Shedinja", "Espurr", "Meowstic", "Kecleon", "Honedge", "Doublade", "Aegislash", "Venipede", "Whirlipede", "Scolipede", "Audino", "Smeargle", "Croagunk", "Toxicroak", "Ducklett", "Swanna", "Spritzee", "Aromatisse", "Swirlix", "Slurpuff", "Volbeat", "Illumise", "Hoppip", "Skiploom", "Jumpluff", "Munchlax", "Snorlax", "Whismur", "Loudred", "Exploud", "Meditite", "Medicham", "Zubat", "Golbat", "Crobat", "Axew", "Fraxure", "Haxorus", "Diancie", "Hoopa", "Volcanion", "Drifloon", "Drifblim", "Mienfoo", "Mienshao", "Zangoose", "Seviper", "Spoink", "Grumpig", "Absol", "Inkay", "Malamar", "Lunatone", "Solrock", "Bagon", "Shelgon", "Salamence", "Wingull", "Pelipper", "Taillow", "Swellow", "Binacle", "Barbaracle", "Dwebble", "Crustle", "Tentacool", "Tentacruel", "Wailmer", "Wailord", "Luvdisc", "Skrelp", "Dragalge", "Clauncher", "Clawitzer", "Staryu", "Starmie", "Shellder", "Cloyster", "Qwilfish", "Horsea", "Seadra", "Kingdra", "Relicanth", "Sandile", "Krokorok", "Krookodile", "Helioptile", "Heliolisk", "Hippopotas", "Hippowdon", "Rhyhorn", "Rhydon", "Rhyperior", "Onix", "Steelix", "Woobat", "Swoobat", "Machop", "Machoke", "Machamp", "Cubone", "Marowak", "Kangaskhan", "Mawile", "Tyrunt", "Tyrantrum", "Amaura", "Aurorus", "Aerodactyl", "Ferroseed", "Ferrothorn", "Snubbull", "Granbull", "Electrike", "Manectric", "Houndour", "Houndoom", "Eevee", "Vaporeon", "Jolteon", "Flareon", "Espeon", "Umbreon", "Leafeon", "Glaceon", "Sylveon", "Emolga", "Yanma", "Yanmega", "Hawlucha", "Sigilyph", "Golett", "Golurk", "Nosepass", "Probopass", "Makuhita", "Hariyama", "Throh", "Sawk", "Starly", "Staravia", "Staraptor", "Stunky", "Skuntank", "Nidoran-F", "Nidorina", "Nidoqueen", "Nidoran-M", "Nidorino", "Nidoking", "Dedenne", "Chingling", "Chimecho", "Mime Jr.", "Mr. Mime", "Solosis", "Duosion", "Reuniclus", "Wynaut", "Wobbuffet", "Roggenrola", "Boldore", "Gigalith", "Sableye", "Carbink", "Tauros", "Miltank", "Mareep", "Flaaffy", "Ampharos", "Pinsir", "Heracross", "Pachirisu", "Slowpoke", "Slowbro", "Slowking", "Exeggcute", "Exeggutor", "Chatot", "Mantyke", "Mantine", "Clamperl", "Huntail", "Gorebyss", "Remoraid", "Octillery", "Corsola", "Chinchou", "Lanturn", "Alomomola", "Lapras", "Articuno", "Zapdos", "Moltres", "Diglett", "Dugtrio", "Trapinch", "Vibrava", "Flygon", "Gible", "Gabite", "Garchomp", "Geodude", "Graveler", "Golem", "Slugma", "Magcargo", "Shuckle", "Skorupi", "Drapion", "Wooper", "Quagsire", "Goomy", "Sliggoo", "Goodra", "Karrablast", "Escavalier", "Shelmet", "Accelgor", "Bellsprout", "Weepinbell", "Victreebel", "Carnivine", "Gastly", "Haunter", "Gengar", "Poliwag", "Poliwhirl", "Poliwrath", "Politoed", "Ekans", "Arbok", "Stunfisk", "Barboach", "Whiscash", "Purrloin", "Liepard", "Poochyena", "Mightyena", "Patrat", "Watchog", "Pawniard", "Bisharp", "Klefki", "Murkrow", "Honchkrow", "Foongus", "Amoonguss", "Lotad", "Lombre", "Ludicolo", "Buizel", "Floatzel", "Basculin", "Phantump", "Trevenant", "Pumpkaboo", "Gourgeist", "Litwick", "Lampent", "Chandelure", "Rotom", "Magnemite", "Magneton", "Magnezone", "Voltorb", "Electrode", "Trubbish", "Garbodor", "Swinub", "Piloswine", "Mamoswine", "Bergmite", "Avalugg", "Cubchoo", "Beartic", "Smoochum", "Jynx", "Vanillite", "Vanillish", "Vanilluxe", "Snover", "Abomasnow", "Delibird", "Sneasel", "Weavile", "Timburr", "Gurdurr", "Conkeldurr", "Torkoal", "Sandshrew", "Sandslash", "Aron", "Lairon", "Aggron", "Larvitar", "Pupitar", "Tyranitar", "Heatmor", "Durant", "Spinarak", "Ariados", "Spearow", "Fearow", "Cryogonal", "Skarmory", "Noibat", "Noivern", "Gligar", "Gliscor", "Hoothoot", "Noctowl", "Igglybuff", "Jigglypuff", "Wigglytuff", "Shuppet", "Banette", "Zorua", "Zoroark", "Gothita", "Gothorita", "Gothitelle", "Bonsly", "Sudowoodo", "Spinda", "Teddiursa", "Ursaring", "Lickitung", "Lickilicky", "Scyther", "Scizor", "Ditto", "Swablu", "Altaria", "Druddigon", "Deino", "Zweilous", "Hydreigon", "Dratini", "Dragonair", "Dragonite", "Xerneas", "Yveltal", "Zygarde", "Mewtwo"}
            local species = self.dex.species:get(set.species or set.name)
            if ((not kalosDex:includes(species.baseSpecies)) or (species.gen > 6)) and (not self.ruleTable:has(
                "+" .. tostring(species.id)
            )) then
                return {
                    tostring(species.name) .. " is not in the Kalos Pokédex."
                }
            end
        end
    },
    alolapokedex = {
        effectType = "ValidatorRule",
        name = "Alola Pokedex",
        desc = "Only allows Pok&eacute;mon native to the Alola region (US/UM)",
        onValidateSet = function(self, set, format)
            local alolaDex = {"Rowlet", "Dartrix", "Decidueye", "Litten", "Torracat", "Incineroar", "Popplio", "Brionne", "Primarina", "Pikipek", "Trumbeak", "Toucannon", "Yungoos", "Gumshoos", "Rattata-Alola", "Raticate-Alola", "Caterpie", "Metapod", "Butterfree", "Ledyba", "Ledian", "Spinarak", "Ariados", "Buneary", "Lopunny", "Inkay", "Malamar", "Zorua", "Zoroark", "Furfrou", "Pichu", "Pikachu", "Raichu-Alola", "Grubbin", "Charjabug", "Vikavolt", "Bonsly", "Sudowoodo", "Happiny", "Chansey", "Blissey", "Munchlax", "Snorlax", "Slowpoke", "Slowbro", "Slowking", "Wingull", "Pelipper", "Abra", "Kadabra", "Alakazam", "Meowth-Alola", "Persian-Alola", "Magnemite", "Magneton", "Magnezone", "Grimer-Alola", "Muk-Alola", "Mime Jr.", "Mr. Mime", "Ekans", "Arbok", "Dunsparce", "Growlithe", "Arcanine", "Drowzee", "Hypno", "Makuhita", "Hariyama", "Smeargle", "Crabrawler", "Crabominable", "Gastly", "Haunter", "Gengar", "Drifloon", "Drifblim", "Murkrow", "Honchkrow", "Zubat", "Golbat", "Crobat", "Noibat", "Noivern", "Diglett-Alola", "Dugtrio-Alola", "Spearow", "Fearow", "Rufflet", "Braviary", "Vullaby", "Mandibuzz", "Mankey", "Primeape", "Delibird", "Hawlucha", "Oricorio", "Cutiefly", "Ribombee", "Flabébé", "Floette", "Florges", "Petilil", "Lilligant", "Cottonee", "Whimsicott", "Psyduck", "Golduck", "Smoochum", "Jynx", "Magikarp", "Gyarados", "Barboach", "Whiscash", "Seal", "Dewgong", "Machop", "Machoke", "Machamp", "Roggenrola", "Boldore", "Gigalith", "Carbink", "Sableye", "Mawile", "Rockruff", "Lycanroc", "Spinda", "Tentacool", "Tentacruel", "Finneon", "Lumineon", "Wishiwashi", "Luvdisc", "Corsola", "Mareanie", "Toxapex", "Shellder", "Cloyster", "Clamperl", "Huntail", "Gorebyss", "Remoraid", "Octillery", "Mantyke", "Mantine", "Bagon", "Shelgon", "Salamence", "Lillipup", "Herdier", "Stoutland", "Eevee", "Vaporeon", "Jolteon", "Flareon", "Espeon", "Umbreon", "Leafeon", "Glaceon", "Sylveon", "Mareep", "Flaaffy", "Ampharos", "Mudbray", "Mudsdale", "Igglybuff", "Jigglypuff", "Wigglytuff", "Tauros", "Miltank", "Surskit", "Masquerain", "Dewpider", "Araquanid", "Fomantis", "Lurantis", "Morelull", "Shiinotic", "Paras", "Parasect", "Poliwag", "Poliwhirl", "Poliwrath", "Politoed", "Goldeen", "Seaking", "Basculin", "Feebas", "Milotic", "Alomomola", "Fletchling", "Fletchinder", "Talonflame", "Salandit", "Salazzle", "Cubone", "Marowak-Alola", "Kangaskhan", "Magby", "Magmar", "Magmortar", "Larvesta", "Volcarona", "Stufful", "Bewear", "Bounsweet", "Steenee", "Tsareena", "Comfey", "Pinsir", "Hoothoot", "Noctowl", "Kecleon", "Oranguru", "Passimian", "Goomy", "Sliggoo", "Goodra", "Castform", "Wimpod", "Golisopod", "Staryu", "Starmie", "Sandygast", "Palossand", "Omanyte", "Omastar", "Kabuto", "Kabutops", "Lileep", "Cradily", "Anorith", "Armaldo", "Cranidos", "Rampardos", "Shieldon", "Bastiodon", "Tirtouga", "Carracosta", "Archen", "Archeops", "Tyrunt", "Tyrantrum", "Amaura", "Aurorus", "Pupitar", "Larvitar", "Tyranitar", "Phantump", "Trevenant", "Natu", "Xatu", "Nosepass", "Probopass", "Pyukumuku", "Chinchou", "Lanturn", "Type: Null", "Silvally", "Poipole", "Naganadel", "Zygarde", "Trubbish", "Garbodor", "Minccino", "Cinccino", "Pineco", "Forretress", "Skarmory", "Ditto", "Cleffa", "Clefairy", "Clefable", "Elgyem", "Beheeyem", "Minior", "Beldum", "Metang", "Metagross", "Porygon", "Porygon2", "Porygon-Z", "Pancham", "Pangoro", "Komala", "Torkoal", "Turtonator", "Houndour", "Houndoom", "Dedenne", "Togedemaru", "Electrike", "Manectric", "Elekid", "Electabuzz", "Electivire", "Geodude-Alola", "Graveler-Alola", "Golem-Alola", "Sandile", "Krokorok", "Krookodile", "Trapinch", "Vibrava", "Flygon", "Gible", "Gabite", "Garchomp", "Baltoy", "Claydol", "Golett", "Golurk", "Klefki", "Mimikyu", "Shuppet", "Banette", "Frillish", "Jellicent", "Bruxish", "Drampa", "Absol", "Snorunt", "Glalie", "Froslass", "Sneasel", "Weavile", "Sandshrew-Alola", "Sandslash-Alola", "Vulpix-Alola", "Ninetales-Alola", "Vanillite", "Vanillish", "Vanilluxe", "Scraggy", "Scrafty", "Pawniard", "Bisharp", "Snubbull", "Granbull", "Shellos", "Gastrodon", "Relicanth", "Dhelmise", "Carvanha", "Sharpedo", "Skrelp", "Dragalge", "Clauncher", "Clawitzer", "Wailmer", "Wailord", "Lapras", "Tropius", "Exeggcute", "Exeggutor-Alola", "Corphish", "Crawdaunt", "Mienfoo", "Mienshao", "Jangmo-o", "Hakamo-o", "Kommo-o", "Emolga", "Scyther", "Scizor", "Heracross", "Aipom", "Ampibom", "Litleo", "Pyroar", "Misdreavus", "Mismagius", "Druddigon", "Lickitung", "Lickilicky", "Riolu", "Lucario", "Dratini", "Dragonair", "Dragonite", "Aerodactyl", "Tapu Koko", "Tapu Lele", "Tapu Bulu", "Tapu Fini", "Cosmog", "Cosmoem", "Solgaleo", "Lunala", "Nihilego", "Stakataka", "Blacephalon", "Buzzwole", "Pheromosa", "Xurkitree", "Celesteela", "Kartana", "Guzzlord", "Necrozma", "Magearna", "Marshadow", "Zeraora"}
            local species = self.dex.species:get(set.species or set.name)
            if ((not alolaDex:includes(species.baseSpecies)) and (not alolaDex:includes(species.name))) and (not self.ruleTable:has(
                "+" .. tostring(species.id)
            )) then
                return {
                    tostring(species.baseSpecies) .. " is not in the Alola Pokédex."
                }
            end
        end
    },
    galarpokedex = {
        effectType = "ValidatorRule",
        name = "Galar Pokedex",
        desc = "Only allows Pok&eacute;mon native to the Galar region (Sw/Sh)",
        banlist = {"Raichu-Alola", "Weezing-Base"},
        onValidateSet = function(self, set, format)
            local galarDex = {"Grookey", "Thwackey", "Rillaboom", "Scorbunny", "Raboot", "Cinderace", "Sobble", "Drizzile", "Inteleon", "Blipbug", "Dottler", "Orbeetle", "Caterpie", "Metapod", "Butterfree", "Grubbin", "Charjabug", "Vikavolt", "Hoothoot", "Noctowl", "Rookidee", "Corvisquire", "Corviknight", "Skwovet", "Greedent", "Pidove", "Tranquill", "Unfezant", "Nickit", "Thievul", "Zigzagoon", "Linoone", "Obstagoon", "Wooloo", "Dubwool", "Lotad", "Lombre", "Ludicolo", "Seedot", "Nuzleaf", "Shiftry", "Chewtle", "Drednaw", "Purrloin", "Liepard", "Yamper", "Boltund", "Bunnelby", "Diggersby", "Minccino", "Cinccino", "Bounsweet", "Steenee", "Tsareena", "Oddish", "Gloom", "Vileplume", "Bellossom", "Budew", "Roselia", "Roserade", "Wingull", "Pelipper", "Joltik", "Galvantula", "Electrike", "Manectric", "Vulpix", "Ninetales", "Growlithe", "Arcanine", "Vanillite", "Vanillish", "Vanilluxe", "Swinub", "Piloswine", "Mamoswine", "Delibird", "Snorunt", "Glalie", "Froslass", "Baltoy", "Claydol", "Mudbray", "Mudsdale", "Dwebble", "Crustle", "Golett", "Golurk", "Munna", "Musharna", "Natu", "Xatu", "Stufful", "Bewear", "Snover", "Abomasnow", "Krabby", "Kingler", "Wooper", "Quagsire", "Corphish", "Crawdaunt", "Nincada", "Ninjask", "Shedinja", "Tyrogue", "Hitmonlee", "Hitmonchan", "Hitmontop", "Pancham", "Pangoro", "Klink", "Klang", "Klinklang", "Combee", "Vespiquen", "Bronzor", "Bronzong", "Ralts", "Kirlia", "Gardevoir", "Gallade", "Drifloon", "Drifblim", "Gossifleur", "Eldegoss", "Cherubi", "Cherrim", "Stunky", "Skuntank", "Tympole", "Palpitoad", "Seismitoad", "Duskull", "Dusclops", "Dusknoir", "Machop", "Machoke", "Machamp", "Gastly", "Haunter", "Gengar", "Magikarp", "Gyarados", "Goldeen", "Seaking", "Remoraid", "Octillery", "Shellder", "Cloyster", "Feebas", "Milotic", "Basculin", "Wishiwashi", "Pyukumuku", "Trubbish", "Garbodor", "Sizzlipede", "Centiskorch", "Rolycoly", "Carkol", "Coalossal", "Diglett", "Dugtrio", "Drilbur", "Excadrill", "Roggenrola", "Boldore", "Gigalith", "Timburr", "Gurdurr", "Conkeldurr", "Woobat", "Swoobat", "Noibat", "Noivern", "Onix", "Steelix", "Arrokuda", "Barraskewda", "Meowth", "Perrserker", "Persian", "Milcery", "Alcremie", "Cutiefly", "Ribombee", "Ferroseed", "Ferrothorn", "Pumpkaboo", "Gourgeist", "Pichu", "Pikachu", "Raichu", "Eevee", "Vaporeon", "Jolteon", "Flareon", "Espeon", "Umbreon", "Leafeon", "Glaceon", "Sylveon", "Applin", "Flapple", "Appletun", "Espurr", "Meowstic", "Swirlix", "Slurpuff", "Spritzee", "Aromatisse", "Dewpider", "Araquanid", "Wynaut", "Wobbuffet", "Farfetch’d", "Sirfetch’d", "Chinchou", "Lanturn", "Croagunk", "Toxicroak", "Scraggy", "Scrafty", "Stunfisk", "Shuckle", "Barboach", "Whiscash", "Shellos", "Gastrodon", "Wimpod", "Golisopod", "Binacle", "Barbaracle", "Corsola", "Cursola", "Impidimp", "Morgrem", "Grimmsnarl", "Hatenna", "Hattrem", "Hatterene", "Salandit", "Salazzle", "Pawniard", "Bisharp", "Throh", "Sawk", "Koffing", "Weezing", "Bonsly", "Sudowoodo", "Cleffa", "Clefairy", "Clefable", "Togepi", "Togetic", "Togekiss", "Munchlax", "Snorlax", "Cottonee", "Whimsicott", "Rhyhorn", "Rhydon", "Rhyperior", "Gothita", "Gothorita", "Gothitelle", "Solosis", "Duosion", "Reuniclus", "Karrablast", "Escavalier", "Shelmet", "Accelgor", "Elgyem", "Beheeyem", "Cubchoo", "Beartic", "Rufflet", "Braviary", "Vullaby", "Mandibuzz", "Skorupi", "Drapion", "Litwick", "Lampent", "Chandelure", "Inkay", "Malamar", "Sneasel", "Weavile", "Sableye", "Mawile", "Maractus", "Sigilyph", "Riolu", "Lucario", "Torkoal", "Mimikyu", "Cufant", "Copperajah", "Qwilfish", "Frillish", "Jellicent", "Mareanie", "Toxapex", "Cramorant", "Toxel", "Toxtricity", "Toxtricity-Low-Key", "Silicobra", "Sandaconda", "Hippopotas", "Hippowdon", "Durant", "Heatmor", "Helioptile", "Heliolisk", "Hawlucha", "Trapinch", "Vibrava", "Flygon", "Axew", "Fraxure", "Haxorus", "Yamask", "Runerigus", "Cofagrigus", "Honedge", "Doublade", "Aegislash", "Ponyta", "Rapidash", "Sinistea", "Polteageist", "Indeedee", "Phantump", "Trevenant", "Morelull", "Shiinotic", "Oranguru", "Passimian", "Morpeko", "Falinks", "Drampa", "Turtonator", "Togedemaru", "Snom", "Frosmoth", "Clobbopus", "Grapploct", "Pincurchin", "Mantyke", "Mantine", "Wailmer", "Wailord", "Bergmite", "Avalugg", "Dhelmise", "Lapras", "Lunatone", "Solrock", "Mime Jr.", "Mr. Mime", "Mr. Rime", "Darumaka", "Darmanitan", "Stonjourner", "Eiscue", "Duraludon", "Rotom", "Ditto", "Dracozolt", "Arctozolt", "Dracovish", "Arctovish", "Charmander", "Charmeleon", "Charizard", "Type: Null", "Silvally", "Larvitar", "Pupitar", "Tyranitar", "Deino", "Zweilous", "Hydreigon", "Goomy", "Sliggoo", "Goodra", "Jangmo-o", "Hakamo-o", "Kommo-o", "Dreepy", "Drakloak", "Dragapult"}
            local species = self.dex.species:get(set.species or set.name)
            if ((not galarDex:includes(species.baseSpecies)) and (not galarDex:includes(species.name))) and (not self.ruleTable:has(
                "+" .. tostring(species.id)
            )) then
                return {
                    tostring(species.baseSpecies) .. " is not in the Galar Pokédex."
                }
            end
        end
    },
    isleofarmorpokedex = {
        effectType = "ValidatorRule",
        name = "Isle of Armor Pokedex",
        desc = "Only allows Pok&eacute;mon native to the Isle of Armor in the Galar Region (Sw/Sh DLC1)",
        onValidateSet = function(self, set, format)
            local ioaDex = {"Slowpoke", "Slowbro", "Slowking", "Buneary", "Lopunny", "Happiny", "Chansey", "Blissey", "Skwovet", "Greedent", "Igglybuff", "Jigglypuff", "Wigglytuff", "Blipbug", "Dottler", "Fomantis", "Lurantis", "Applin", "Flapple", "Appletun", "Fletchling", "Fletchinder", "Talonflame", "Shinx", "Luxio", "Luxray", "Klefki", "Pawniard", "Bisharp", "Abra", "Kadabra", "Alakazam", "Ralts", "Kirlia", "Gardevoir", "Gallade", "Krabby", "Kingler", "Tentacool", "Tentacruel", "Magikarp", "Gyarados", "Remoraid", "Octillery", "Mantyke", "Mantine", "Wingull", "Pelipper", "Skorupi", "Drapion", "Dunsparce", "Bouffalant", "Lickitung", "Lickilicky", "Chewtle", "Drednaw", "Wooper", "Quagsire", "Goomy", "Sliggoo", "Goodra", "Druddigon", "Shelmet", "Accelgor", "Karrablast", "Escavalier", "Bulbasaur", "Ivysaur", "Venusaur", "Squirtle", "Wartortle", "Blastoise", "Venipede", "Whirlipede", "Scolipede", "Foongus", "Amoonguss", "Comfey", "Tangela", "Tangrowth", "Croagunk", "Toxicroak", "Pichu", "Pikachu", "Raichu", "Zorua", "Zoroark", "Oranguru", "Passimian", "Corphish", "Crawdaunt", "Cramorant", "Goldeen", "Seaking", "Arrokuda", "Barraskewda", "Staryu", "Starmie", "Kubfu", "Urshifu", "Emolga", "Dedenne", "Morpeko", "Magnemite", "Magneton", "Magnezone", "Inkay", "Malamar", "Wishiwashi", "Carvanha", "Sharpedo", "Lillipup", "Herdier", "Stoutland", "Tauros", "Miltank", "Scyther", "Scizor", "Pinsir", "Heracross", "Dwebble", "Crustle", "Wimpod", "Golisopod", "Pincurchin", "Mareanie", "Toxapex", "Clobbopus", "Grapploct", "Shellder", "Cloyster", "Sandygast", "Palossand", "Drifloon", "Drifblim", "Barboach", "Whiscash", "Azurill", "Marill", "Azumarill", "Poliwag", "Poliwhirl", "Poliwrath", "Politoed", "Psyduck", "Golduck", "Whismur", "Loudred", "Exploud", "Woobat", "Swoobat", "Skarmory", "Roggenrola", "Boldore", "Gigalith", "Rockruff", "Lycanroc", "Salandit", "Salazzle", "Scraggy", "Scrafty", "Mienfoo", "Mienshao", "Jangmo-o", "Hakamo-o", "Kommo-o", "Sandshrew", "Sandslash", "Cubone", "Marowak", "Kangaskhan", "Torkoal", "Silicobra", "Sandaconda", "Sandile", "Krokorok", "Krookodile", "Rufflet", "Braviary", "Vullaby", "Mandibuzz", "Rhyhorn", "Rhydon", "Rhyperior", "Larvesta", "Volcarona", "Chinchou", "Lanturn", "Wailmer", "Wailord", "Frillish", "Jellicent", "Skrelp", "Dragalge", "Clauncher", "Clawitzer", "Horsea", "Seadra", "Kingdra", "Petilil", "Lilligant", "Combee", "Vespiquen", "Exeggcute", "Exeggutor", "Ditto", "Porygon", "Porygon2", "Porygon-Z"}
            local species = self.dex.species:get(set.species or set.name)
            if ((not ioaDex:includes(species.baseSpecies)) and (not ioaDex:includes(species.name))) and (not self.ruleTable:has(
                "+" .. tostring(species.id)
            )) then
                return {
                    tostring(species.baseSpecies) .. " is not in the Isle of Armor Pokédex."
                }
            end
        end
    },
    crowntundrapokedex = {
        effectType = "ValidatorRule",
        name = "Crown Tundra Pokedex",
        desc = "Only allows Pok&eacute;mon native to the Crown Tundra in the Galar Region (Sw/Sh DLC2)",
        onValidateSet = function(self, set, format)
            local tundraDex = {"Nidoran-F", "Nidorina", "Nidoqueen", "Nidoran-M", "Nidorino", "Nidoking", "Clefairy", "Clefable", "Zubat", "Golbat", "Ponyta", "Rapidash", "Mr. Mime", "Jynx", "Electabuzz", "Magmar", "Magikarp", "Gyarados", "Lapras", "Eevee", "Vaporeon", "Jolteon", "Flareon", "Omanyte", "Omastar", "Kabuto", "Kabutops", "Aerodactyl", "Snorlax", "Articuno", "Zapdos", "Moltres", "Dratini", "Dragonair", "Dragonite", "Crobat", "Cleffa", "Espeon", "Umbreon", "Shuckle", "Sneasel", "Swinub", "Piloswine", "Delibird", "Smoochum", "Elekid", "Magby", "Larvitar", "Pupitar", "Tyranitar", "Zigzagoon", "Linoone", "Sableye", "Mawile", "Aron", "Lairon", "Aggron", "Swablu", "Altaria", "Barboach", "Whiscash", "Baltoy", "Claydol", "Lileep", "Cradily", "Anorith", "Armaldo", "Feebas", "Milotic", "Absol", "Snorunt", "Glalie", "Spheal", "Sealeo", "Walrein", "Relicanth", "Bagon", "Shelgon", "Salamence", "Beldum", "Metang", "Metagross", "Regirock", "Regice", "Registeel", "Bronzor", "Bronzong", "Spiritomb", "Gible", "Gabite", "Garchomp", "Munchlax", "Riolu", "Lucario", "Snover", "Abomasnow", "Weavile", "Electivire", "Magmortar", "Leafeon", "Glaceon", "Mamoswine", "Froslass", "Audino", "Timburr", "Gurdurr", "Conkeldurr", "Cottonee", "Whimsicott", "Basculin", "Darumaka", "Darmanitan", "Tirtouga", "Carracosta", "Archen", "Archeops", "Gothita", "Gothorita", "Gothitelle", "Solosis", "Duosion", "Reuniclus", "Vanillite", "Vanillish", "Vanilluxe", "Karrablast", "Escavalier", "Joltik", "Galvantula", "Ferroseed", "Ferrothorn", "Litwick", "Lampent", "Chandelure", "Cubchoo", "Beartic", "Cryogonal", "Shelmet", "Accelgor", "Druddigon", "Golett", "Golurk", "Heatmor", "Durant", "Deino", "Zweilous", "Hydreigon", "Cobalion", "Terrakion", "Virizion", "Tyrunt", "Tyrantrum", "Amaura", "Aurorus", "Sylveon", "Carbink", "Phantump", "Trevenant", "Bergmite", "Avalugg", "Noibat", "Noivern", "Dewpider", "Araquanid", "Mimikyu", "Dhelmise", "Skwovet", "Greedent", "Rookidee", "Corvisquire", "Corviknight", "Gossifleur", "Eldegoss", "Wooloo", "Dubwool", "Yamper", "Boltund", "Rolycoly", "Carkol", "Coalossal", "Sizzlipede", "Centiskorch", "Sinistea", "Polteageist", "Hatenna", "Hattrem", "Hatterene", "Impidimp", "Morgrem", "Grimmsnarl", "Obstagoon", "Mr. Rime", "Pincurchin", "Snom", "Frosmoth", "Stonjourner", "Eiscue", "Indeedee", "Morpeko", "Cufant", "Copperajah", "Dreepy", "Drakloak", "Dragapult", "Regieleki", "Regidrago", "Glastrier", "Spectrier"}
            local species = self.dex.species:get(set.species or set.name)
            if (not tundraDex:includes(species.baseSpecies)) and (not tundraDex:includes(species.name)) then
                return {
                    tostring(species.baseSpecies) .. " is not in the Crown Tundra Pokédex."
                }
            end
        end
    },
    galarexpansionpokedex = {
        effectType = "ValidatorRule",
        name = "Galar Expansion Pokedex",
        desc = "Only allows Pok&eacute;mon native to the Galar region, Isle of Armor, or Crown Tundra (Sw/Sh + Expansion Pass)",
        onValidateSet = function(self, set, format)
            local galarDex = {"Grookey", "Thwackey", "Rillaboom", "Scorbunny", "Raboot", "Cinderace", "Sobble", "Drizzile", "Inteleon", "Blipbug", "Dottler", "Orbeetle", "Caterpie", "Metapod", "Butterfree", "Grubbin", "Charjabug", "Vikavolt", "Hoothoot", "Noctowl", "Rookidee", "Corvisquire", "Corviknight", "Skwovet", "Greedent", "Pidove", "Tranquill", "Unfezant", "Nickit", "Thievul", "Zigzagoon", "Linoone", "Obstagoon", "Wooloo", "Dubwool", "Lotad", "Lombre", "Ludicolo", "Seedot", "Nuzleaf", "Shiftry", "Chewtle", "Drednaw", "Purrloin", "Liepard", "Yamper", "Boltund", "Bunnelby", "Diggersby", "Minccino", "Cinccino", "Bounsweet", "Steenee", "Tsareena", "Oddish", "Gloom", "Vileplume", "Bellossom", "Budew", "Roselia", "Roserade", "Wingull", "Pelipper", "Joltik", "Galvantula", "Electrike", "Manectric", "Vulpix", "Ninetales", "Growlithe", "Arcanine", "Vanillite", "Vanillish", "Vanilluxe", "Swinub", "Piloswine", "Mamoswine", "Delibird", "Snorunt", "Glalie", "Froslass", "Baltoy", "Claydol", "Mudbray", "Mudsdale", "Dwebble", "Crustle", "Golett", "Golurk", "Munna", "Musharna", "Natu", "Xatu", "Stufful", "Bewear", "Snover", "Abomasnow", "Krabby", "Kingler", "Wooper", "Quagsire", "Corphish", "Crawdaunt", "Nincada", "Ninjask", "Shedinja", "Tyrogue", "Hitmonlee", "Hitmonchan", "Hitmontop", "Pancham", "Pangoro", "Klink", "Klang", "Klinklang", "Combee", "Vespiquen", "Bronzor", "Bronzong", "Ralts", "Kirlia", "Gardevoir", "Gallade", "Drifloon", "Drifblim", "Gossifleur", "Eldegoss", "Cherubi", "Cherrim", "Stunky", "Skuntank", "Tympole", "Palpitoad", "Seismitoad", "Duskull", "Dusclops", "Dusknoir", "Machop", "Machoke", "Machamp", "Gastly", "Haunter", "Gengar", "Magikarp", "Gyarados", "Goldeen", "Seaking", "Remoraid", "Octillery", "Shellder", "Cloyster", "Feebas", "Milotic", "Basculin", "Wishiwashi", "Pyukumuku", "Trubbish", "Garbodor", "Sizzlipede", "Centiskorch", "Rolycoly", "Carkol", "Coalossal", "Diglett", "Dugtrio", "Drilbur", "Excadrill", "Roggenrola", "Boldore", "Gigalith", "Timburr", "Gurdurr", "Conkeldurr", "Woobat", "Swoobat", "Noibat", "Noivern", "Onix", "Steelix", "Arrokuda", "Barraskewda", "Meowth", "Perrserker", "Persian", "Milcery", "Alcremie", "Cutiefly", "Ribombee", "Ferroseed", "Ferrothorn", "Pumpkaboo", "Gourgeist", "Pichu", "Pikachu", "Raichu", "Eevee", "Vaporeon", "Jolteon", "Flareon", "Espeon", "Umbreon", "Leafeon", "Glaceon", "Sylveon", "Applin", "Flapple", "Appletun", "Espurr", "Meowstic", "Swirlix", "Slurpuff", "Spritzee", "Aromatisse", "Dewpider", "Araquanid", "Wynaut", "Wobbuffet", "Farfetch’d", "Sirfetch’d", "Chinchou", "Lanturn", "Croagunk", "Toxicroak", "Scraggy", "Scrafty", "Stunfisk", "Shuckle", "Barboach", "Whiscash", "Shellos", "Gastrodon", "Wimpod", "Golisopod", "Binacle", "Barbaracle", "Corsola", "Cursola", "Impidimp", "Morgrem", "Grimmsnarl", "Hatenna", "Hattrem", "Hatterene", "Salandit", "Salazzle", "Pawniard", "Bisharp", "Throh", "Sawk", "Koffing", "Weezing", "Bonsly", "Sudowoodo", "Cleffa", "Clefairy", "Clefable", "Togepi", "Togetic", "Togekiss", "Munchlax", "Snorlax", "Cottonee", "Whimsicott", "Rhyhorn", "Rhydon", "Rhyperior", "Gothita", "Gothorita", "Gothitelle", "Solosis", "Duosion", "Reuniclus", "Karrablast", "Escavalier", "Shelmet", "Accelgor", "Elgyem", "Beheeyem", "Cubchoo", "Beartic", "Rufflet", "Braviary", "Vullaby", "Mandibuzz", "Skorupi", "Drapion", "Litwick", "Lampent", "Chandelure", "Inkay", "Malamar", "Sneasel", "Weavile", "Sableye", "Mawile", "Maractus", "Sigilyph", "Riolu", "Lucario", "Torkoal", "Mimikyu", "Cufant", "Copperajah", "Qwilfish", "Frillish", "Jellicent", "Mareanie", "Toxapex", "Cramorant", "Toxel", "Toxtricity", "Toxtricity-Low-Key", "Silicobra", "Sandaconda", "Hippopotas", "Hippowdon", "Durant", "Heatmor", "Helioptile", "Heliolisk", "Hawlucha", "Trapinch", "Vibrava", "Flygon", "Axew", "Fraxure", "Haxorus", "Yamask", "Runerigus", "Cofagrigus", "Honedge", "Doublade", "Aegislash", "Ponyta", "Rapidash", "Sinistea", "Polteageist", "Indeedee", "Phantump", "Trevenant", "Morelull", "Shiinotic", "Oranguru", "Passimian", "Morpeko", "Falinks", "Drampa", "Turtonator", "Togedemaru", "Snom", "Frosmoth", "Clobbopus", "Grapploct", "Pincurchin", "Mantyke", "Mantine", "Wailmer", "Wailord", "Bergmite", "Avalugg", "Dhelmise", "Lapras", "Lunatone", "Solrock", "Mime Jr.", "Mr. Mime", "Mr. Rime", "Darumaka", "Darmanitan", "Stonjourner", "Eiscue", "Duraludon", "Rotom", "Ditto", "Dracozolt", "Arctozolt", "Dracovish", "Arctovish", "Charmander", "Charmeleon", "Charizard", "Type: Null", "Silvally", "Larvitar", "Pupitar", "Tyranitar", "Deino", "Zweilous", "Hydreigon", "Goomy", "Sliggoo", "Goodra", "Jangmo-o", "Hakamo-o", "Kommo-o", "Dreepy", "Drakloak", "Dragapult", "Slowpoke", "Slowbro", "Slowking", "Buneary", "Lopunny", "Happiny", "Chansey", "Blissey", "Skwovet", "Greedent", "Igglybuff", "Jigglypuff", "Wigglytuff", "Blipbug", "Dottler", "Fomantis", "Lurantis", "Applin", "Flapple", "Appletun", "Fletchling", "Fletchinder", "Talonflame", "Shinx", "Luxio", "Luxray", "Klefki", "Pawniard", "Bisharp", "Abra", "Kadabra", "Alakazam", "Ralts", "Kirlia", "Gardevoir", "Gallade", "Krabby", "Kingler", "Tentacool", "Tentacruel", "Magikarp", "Gyarados", "Remoraid", "Octillery", "Mantyke", "Mantine", "Wingull", "Pelipper", "Skorupi", "Drapion", "Dunsparce", "Bouffalant", "Lickitung", "Lickilicky", "Chewtle", "Drednaw", "Wooper", "Quagsire", "Goomy", "Sliggoo", "Goodra", "Druddigon", "Shelmet", "Accelgor", "Karrablast", "Escavalier", "Bulbasaur", "Ivysaur", "Venusaur", "Squirtle", "Wartortle", "Blastoise", "Venipede", "Whirlipede", "Scolipede", "Foongus", "Amoonguss", "Comfey", "Tangela", "Tangrowth", "Croagunk", "Toxicroak", "Pichu", "Pikachu", "Raichu", "Zorua", "Zoroark", "Oranguru", "Passimian", "Corphish", "Crawdaunt", "Cramorant", "Goldeen", "Seaking", "Arrokuda", "Barraskewda", "Staryu", "Starmie", "Kubfu", "Urshifu", "Emolga", "Dedenne", "Morpeko", "Magnemite", "Magneton", "Magnezone", "Inkay", "Malamar", "Wishiwashi", "Carvanha", "Sharpedo", "Lillipup", "Herdier", "Stoutland", "Tauros", "Miltank", "Scyther", "Scizor", "Pinsir", "Heracross", "Dwebble", "Crustle", "Wimpod", "Golisopod", "Pincurchin", "Mareanie", "Toxapex", "Clobbopus", "Grapploct", "Shellder", "Cloyster", "Sandygast", "Palossand", "Drifloon", "Drifblim", "Barboach", "Whiscash", "Azurill", "Marill", "Azumarill", "Poliwag", "Poliwhirl", "Poliwrath", "Politoed", "Psyduck", "Golduck", "Whismur", "Loudred", "Exploud", "Woobat", "Swoobat", "Skarmory", "Roggenrola", "Boldore", "Gigalith", "Rockruff", "Lycanroc", "Salandit", "Salazzle", "Scraggy", "Scrafty", "Mienfoo", "Mienshao", "Jangmo-o", "Hakamo-o", "Kommo-o", "Sandshrew", "Sandslash", "Cubone", "Marowak", "Kangaskhan", "Torkoal", "Silicobra", "Sandaconda", "Sandile", "Krokorok", "Krookodile", "Rufflet", "Braviary", "Vullaby", "Mandibuzz", "Rhyhorn", "Rhydon", "Rhyperior", "Larvesta", "Volcarona", "Chinchou", "Lanturn", "Wailmer", "Wailord", "Frillish", "Jellicent", "Skrelp", "Dragalge", "Clauncher", "Clawitzer", "Horsea", "Seadra", "Kingdra", "Petilil", "Lilligant", "Combee", "Vespiquen", "Exeggcute", "Exeggutor", "Ditto", "Porygon", "Porygon2", "Porygon-Z", "Nidoran-F", "Nidorina", "Nidoqueen", "Nidoran-M", "Nidorino", "Nidoking", "Clefairy", "Clefable", "Zubat", "Golbat", "Ponyta", "Rapidash", "Mr. Mime", "Jynx", "Electabuzz", "Magmar", "Magikarp", "Gyarados", "Lapras", "Eevee", "Vaporeon", "Jolteon", "Flareon", "Omanyte", "Omastar", "Kabuto", "Kabutops", "Aerodactyl", "Snorlax", "Articuno", "Zapdos", "Moltres", "Dratini", "Dragonair", "Dragonite", "Crobat", "Cleffa", "Espeon", "Umbreon", "Shuckle", "Sneasel", "Swinub", "Piloswine", "Delibird", "Smoochum", "Elekid", "Magby", "Larvitar", "Pupitar", "Tyranitar", "Zigzagoon", "Linoone", "Sableye", "Mawile", "Aron", "Lairon", "Aggron", "Swablu", "Altaria", "Barboach", "Whiscash", "Baltoy", "Claydol", "Lileep", "Cradily", "Anorith", "Armaldo", "Feebas", "Milotic", "Absol", "Snorunt", "Glalie", "Spheal", "Sealeo", "Walrein", "Relicanth", "Bagon", "Shelgon", "Salamence", "Beldum", "Metang", "Metagross", "Regirock", "Regice", "Registeel", "Bronzor", "Bronzong", "Spiritomb", "Gible", "Gabite", "Garchomp", "Munchlax", "Riolu", "Lucario", "Snover", "Abomasnow", "Weavile", "Electivire", "Magmortar", "Leafeon", "Glaceon", "Mamoswine", "Froslass", "Audino", "Timburr", "Gurdurr", "Conkeldurr", "Cottonee", "Whimsicott", "Basculin", "Darumaka", "Darmanitan", "Tirtouga", "Carracosta", "Archen", "Archeops", "Gothita", "Gothorita", "Gothitelle", "Solosis", "Duosion", "Reuniclus", "Vanillite", "Vanillish", "Vanilluxe", "Karrablast", "Escavalier", "Joltik", "Galvantula", "Ferroseed", "Ferrothorn", "Litwick", "Lampent", "Chandelure", "Cubchoo", "Beartic", "Cryogonal", "Shelmet", "Accelgor", "Druddigon", "Golett", "Golurk", "Heatmor", "Durant", "Deino", "Zweilous", "Hydreigon", "Cobalion", "Terrakion", "Virizion", "Tyrunt", "Tyrantrum", "Amaura", "Aurorus", "Sylveon", "Carbink", "Phantump", "Trevenant", "Bergmite", "Avalugg", "Noibat", "Noivern", "Dewpider", "Araquanid", "Mimikyu", "Dhelmise", "Skwovet", "Greedent", "Rookidee", "Corvisquire", "Corviknight", "Gossifleur", "Eldegoss", "Wooloo", "Dubwool", "Yamper", "Boltund", "Rolycoly", "Carkol", "Coalossal", "Sizzlipede", "Centiskorch", "Sinistea", "Polteageist", "Hatenna", "Hattrem", "Hatterene", "Impidimp", "Morgrem", "Grimmsnarl", "Obstagoon", "Mr. Rime", "Pincurchin", "Snom", "Frosmoth", "Stonjourner", "Eiscue", "Indeedee", "Morpeko", "Cufant", "Copperajah", "Dreepy", "Drakloak", "Dragapult", "Regieleki", "Regidrago", "Glastrier", "Spectrier"}
            local species = self.dex.species:get(set.species or set.name)
            if (not galarDex:includes(species.baseSpecies)) and (not galarDex:includes(species.name)) then
                return {
                    tostring(species.baseSpecies) .. " is not in the Galar, Isle of Armor, or Crown Tundra Pokédexes."
                }
            end
        end
    },
    potd = {
        effectType = "Rule",
        name = "PotD",
        onBegin = function(self)
            if global.Config and global.Config.potd then
                self:add(
                    "rule",
                    "Pokemon of the Day: " .. tostring(
                        self.dex.species:get(Config.potd).name
                    )
                )
            end
        end
    },
    forcemonotype = {
        effectType = "ValidatorRule",
        name = "Force Monotype",
        hasValue = true,
        onValidateRule = function(self, value)
            if not self.dex.types:get(value).exists then
                error(
                    __TS__New(
                        Error,
                        ("Misspelled type \"" .. tostring(value)) .. "\""
                    ),
                    0
                )
            end
            if not self.dex.types:isName(value) then
                error(
                    __TS__New(
                        Error,
                        ("Incorrectly capitalized type \"" .. tostring(value)) .. "\""
                    ),
                    0
                )
            end
        end,
        onValidateSet = function(self, set)
            local species = self.dex.species:get(set.species)
            local ____type = self.ruleTable.valueRules:get("forcemonotype")
            if not species.types:includes(____type) then
                return {
                    (tostring(set.species) .. " must have type ") .. tostring(____type)
                }
            end
        end
    },
    evlimits = {
        effectType = "ValidatorRule",
        name = "EV Limits",
        desc = "Require EVs to be in specific ranges, such as: \"EV Limits = Atk 0-124 / Def 100-252\"",
        hasValue = true,
        onValidateRule = function(self, value)
            if not value then
                error(
                    __TS__New(Error, "To remove EV limits, use \"! EV Limits\""),
                    0
                )
            end
            local slashedParts = value:split("/")
            local UINT_REGEX = nil
            return slashedParts:map(
                function(____, slashedPart)
                    local parts = slashedPart:replace("-", " - "):replace(nil, " "):trim():split(" ")
                    local stat, low, hyphen, high = __TS__Unpack(parts)
                    if (((parts.length ~= 4) or (not UINT_REGEX:test(low))) or (hyphen ~= "-")) or (not UINT_REGEX:test(high)) then
                        error(
                            __TS__New(Error, "EV limits should be in the format \"EV Limits = Atk 0-124 / Def 100-252\""),
                            0
                        )
                    end
                    local statid = self.dex:toID(stat)
                    if not self.dex.stats:ids():includes(statid) then
                        error(
                            __TS__New(
                                Error,
                                ((("Unrecognized stat name \"" .. tostring(stat)) .. "\" in \"") .. tostring(value)) .. "\""
                            ),
                            0
                        )
                    end
                    return (((tostring(statid) .. " ") .. tostring(low)) .. "-") .. tostring(high)
                end
            ):join(" / ")
        end,
        onValidateSet = function(self, set)
            local limits = self.ruleTable.valueRules:get("evlimits")
            local problems = {}
            for ____, limit in __TS__Iterator(
                limits:split(" / ")
            ) do
                local statid, range = __TS__Unpack(
                    limit:split(" ")
                )
                local low, high = __TS__Unpack(
                    __TS__ArrayMap(
                        __TS__StringSplit(range, "-"),
                        function(____, num) return __TS__ParseInt(num) end
                    )
                )
                local ev = set.evs[statid]
                if (ev < low) or (ev > high) then
                    __TS__ArrayPush(
                        problems,
                        (((((((tostring(set.name or set.species) .. "'s ") .. tostring(self.dex.stats.names[statid])) .. " EV (") .. tostring(ev)) .. ") must be ") .. tostring(low)) .. "-") .. tostring(high)
                    )
                end
            end
            return problems
        end
    },
    teampreview = {
        effectType = "Rule",
        name = "Team Preview",
        desc = "Allows each player to see the Pok&eacute;mon on their opponent's team before they choose their lead Pok&eacute;mon",
        onTeamPreview = function(self)
            self:add("clearpoke")
            for ____, pokemon in __TS__Iterator(
                self:getAllPokemon()
            ) do
                local details = pokemon.details:replace(", shiny", ""):replace(nil, "$1-*")
                self:add("poke", pokemon.side.id, details, "")
            end
            self:makeRequest("teampreview")
        end
    },
    onevsone = {effectType = "Rule", name = "One vs One", desc = "Only allows one Pok&eacute;mon in battle", ruleset = {"Picked Team Size = 1"}},
    twovstwo = {effectType = "Rule", name = "Two vs Two", desc = "Only allows two Pok&eacute;mon in battle", ruleset = {"Picked Team Size = 2"}},
    littlecup = {
        effectType = "ValidatorRule",
        name = "Little Cup",
        desc = "Only allows Pok&eacute;mon that can evolve and don't have any prior evolutions",
        ruleset = {"Max Level = 5"},
        onValidateSet = function(self, set)
            local species = self.dex.species:get(set.species or set.name)
            if species.prevo and (self.dex.species:get(species.prevo).gen <= self.gen) then
                return {
                    tostring(set.species) .. " isn't the first in its evolution family."
                }
            end
            if not species.nfe then
                return {
                    tostring(set.species) .. " doesn't have an evolution family."
                }
            end
        end
    },
    blitz = {
        effectType = "Rule",
        name = "Blitz",
        desc = "Super-fast 'Blitz' timer giving 30 second Team Preview and 10 seconds per turn.",
        onBegin = function(self)
            self:add("rule", "Blitz: Super-fast timer")
        end,
        timer = {starting = 15, addPerTurn = 5, maxPerTurn = 15, maxFirstTurn = 40, grace = 30}
    },
    vgctimer = {effectType = "Rule", name = "VGC Timer", desc = "VGC's timer: 90 second Team Preview, 7 minutes Your Time, 1 minute per turn", timer = {starting = 7 * 60, addPerTurn = 0, maxPerTurn = 55, maxFirstTurn = 90, grace = 90, timeoutAutoChoose = true, dcTimerBank = false}},
    speciesclause = {
        effectType = "ValidatorRule",
        name = "Species Clause",
        desc = "Prevents teams from having more than one Pok&eacute;mon from the same species",
        onBegin = function(self)
            self:add("rule", "Species Clause: Limit one of each Pokémon")
        end,
        onValidateTeam = function(self, team, format)
            local speciesTable = __TS__New(Set)
            for ____, set in __TS__Iterator(team) do
                local species = self.dex.species:get(set.species)
                if speciesTable:has(species.num) then
                    return {
                        "You are limited to one of each Pokémon by Species Clause.",
                        ("(You have more than one " .. tostring(species.baseSpecies)) .. ")"
                    }
                end
                speciesTable:add(species.num)
            end
        end
    },
    nicknameclause = {
        effectType = "ValidatorRule",
        name = "Nickname Clause",
        desc = "Prevents teams from having more than one Pok&eacute;mon with the same nickname",
        onValidateTeam = function(self, team, format)
            local nameTable = __TS__New(Set)
            for ____, set in __TS__Iterator(team) do
                do
                    local name = set.name
                    if name then
                        if name == self.dex.species:get(set.species).baseSpecies then
                            goto __continue84
                        end
                        if nameTable:has(name) then
                            return {
                                "Your Pokémon must have different nicknames.",
                                ("(You have more than one " .. tostring(name)) .. ")"
                            }
                        end
                        nameTable:add(name)
                    end
                end
                ::__continue84::
            end
        end
    },
    itemclause = {
        effectType = "ValidatorRule",
        name = "Item Clause",
        desc = "Prevents teams from having more than one Pok&eacute;mon with the same item",
        onBegin = function(self)
            self:add("rule", "Item Clause: Limit one of each item")
        end,
        onValidateTeam = function(self, team)
            local itemTable = __TS__New(Set)
            for ____, set in __TS__Iterator(team) do
                do
                    local item = self:toID(set.item)
                    if not item then
                        goto __continue90
                    end
                    if itemTable:has(item) then
                        return {
                            "You are limited to one of each item by Item Clause.",
                            ("(You have more than one " .. tostring(
                                self.dex.items:get(item).name
                            )) .. ")"
                        }
                    end
                    itemTable:add(item)
                end
                ::__continue90::
            end
        end
    },
    ["2abilityclause"] = {
        effectType = "ValidatorRule",
        name = "2 Ability Clause",
        desc = "Prevents teams from having more than two Pok&eacute;mon with the same ability",
        onBegin = function(self)
            self:add("rule", "2 Ability Clause: Limit two of each ability")
        end,
        onValidateTeam = function(self, team)
            local abilityTable = __TS__New(Map)
            local base = {airlock = "cloudnine", battlearmor = "shellarmor", clearbody = "whitesmoke", dazzling = "queenlymajesty", emergencyexit = "wimpout", filter = "solidrock", gooey = "tanglinghair", insomnia = "vitalspirit", ironbarbs = "roughskin", libero = "protean", minus = "plus", moxie = "chillingneigh", powerofalchemy = "receiver", propellertail = "stalwart", teravolt = "moldbreaker", turboblaze = "moldbreaker"}
            for ____, set in __TS__Iterator(team) do
                do
                    local ability = self:toID(set.ability)
                    if not ability then
                        goto __continue95
                    end
                    if base[ability] ~= nil then
                        ability = base[ability]
                    end
                    if (abilityTable:get(ability) or 0) >= 2 then
                        return {
                            "You are limited to two of each ability by 2 Ability Clause.",
                            ("(You have more than two " .. tostring(
                                self.dex.abilities:get(ability).name
                            )) .. " variants)"
                        }
                    end
                    abilityTable:set(
                        ability,
                        (abilityTable:get(ability) or 0) + 1
                    )
                end
                ::__continue95::
            end
        end
    },
    ohkoclause = {
        effectType = "ValidatorRule",
        name = "OHKO Clause",
        desc = "Bans all OHKO moves, such as Fissure",
        onBegin = function(self)
            self:add("rule", "OHKO Clause: OHKO moves are banned")
        end,
        onValidateSet = function(self, set)
            local problems = {}
            if set.moves then
                for ____, moveId in __TS__Iterator(set.moves) do
                    local move = self.dex.moves:get(moveId)
                    if move.ohko then
                        __TS__ArrayPush(
                            problems,
                            tostring(move.name) .. " is banned by OHKO Clause."
                        )
                    end
                end
            end
            return problems
        end
    },
    evasionabilitiesclause = {
        effectType = "ValidatorRule",
        name = "Evasion Abilities Clause",
        desc = "Bans abilities that boost Evasion under certain weather conditions",
        banlist = {"Sand Veil", "Snow Cloak"},
        onBegin = function(self)
            self:add("rule", "Evasion Abilities Clause: Evasion abilities are banned")
        end
    },
    evasionmovesclause = {
        effectType = "ValidatorRule",
        name = "Evasion Moves Clause",
        desc = "Bans moves that consistently raise the user's evasion when used",
        banlist = {"Minimize", "Double Team"},
        onBegin = function(self)
            self:add("rule", "Evasion Moves Clause: Evasion moves are banned")
        end
    },
    accuracymovesclause = {
        effectType = "ValidatorRule",
        name = "Accuracy Moves Clause",
        desc = "Bans moves that have a chance to lower the target's accuracy when used",
        banlist = {"Flash", "Kinesis", "Leaf Tornado", "Mirror Shot", "Mud Bomb", "Mud-Slap", "Muddy Water", "Night Daze", "Octazooka", "Sand Attack", "Smokescreen"},
        onBegin = function(self)
            self:add("rule", "Accuracy Moves Clause: Accuracy-lowering moves are banned")
        end
    },
    sleepmovesclause = {
        effectType = "ValidatorRule",
        name = "Sleep Moves Clause",
        desc = "Bans all moves that induce sleep, such as Hypnosis",
        banlist = {"Yawn"},
        onBegin = function(self)
            self:add("rule", "Sleep Clause: Sleep-inducing moves are banned")
        end,
        onValidateSet = function(self, set)
            local problems = {}
            if set.moves then
                for ____, id in __TS__Iterator(set.moves) do
                    local move = self.dex.moves:get(id)
                    if move.status and (move.status == "slp") then
                        __TS__ArrayPush(
                            problems,
                            tostring(move.name) .. " is banned by Sleep Clause."
                        )
                    end
                end
            end
            return problems
        end
    },
    gravitysleepclause = {
        effectType = "ValidatorRule",
        name = "Gravity Sleep Clause",
        desc = "Bans sleep moves below 100% accuracy, in conjunction with Gravity or Gigantamax Orbeetle",
        banlist = {"Gravity ++ Grass Whistle", "Gravity ++ Hypnosis", "Gravity ++ Lovely Kiss", "Gravity ++ Sing", "Gravity ++ Sleep Powder"},
        onValidateTeam = function(self, team)
            local hasOrbeetle = false
            local hasSleepMove = false
            for ____, set in __TS__Iterator(team) do
                local species = self.dex.species:get(set.species)
                if (species.name == "Orbeetle") and set.gigantamax then
                    hasOrbeetle = true
                end
                if (not hasOrbeetle) and (species.name == "Orbeetle-Gmax") then
                    hasOrbeetle = true
                end
                for ____, moveid in __TS__Iterator(set.moves) do
                    local move = self.dex.moves:get(moveid)
                    if (move.status and (move.status == "slp")) and (move.accuracy < 100) then
                        hasSleepMove = true
                    end
                end
            end
            if hasOrbeetle and hasSleepMove then
                return {"The combination of Gravity and Gigantamax Orbeetle on the same team is banned."}
            end
        end,
        onBegin = function(self)
            self:add("rule", "Gravity Sleep Clause: The combination of sleep-inducing moves with imperfect accuracy and Gravity or Gigantamax Orbeetle are banned")
        end
    },
    endlessbattleclause = {
        effectType = "Rule",
        name = "Endless Battle Clause",
        desc = "Prevents players from forcing a battle which their opponent cannot end except by forfeit",
        onBegin = function(self)
            self:add("rule", "Endless Battle Clause: Forcing endless battles is banned")
        end
    },
    moodyclause = {
        effectType = "ValidatorRule",
        name = "Moody Clause",
        desc = "Bans the ability Moody",
        banlist = {"Moody"},
        onBegin = function(self)
            self:add("rule", "Moody Clause: Moody is banned")
        end
    },
    swaggerclause = {
        effectType = "ValidatorRule",
        name = "Swagger Clause",
        desc = "Bans the move Swagger",
        banlist = {"Swagger"},
        onBegin = function(self)
            self:add("rule", "Swagger Clause: Swagger is banned")
        end
    },
    batonpassclause = {
        effectType = "ValidatorRule",
        name = "Baton Pass Clause",
        desc = "Stops teams from having more than one Pok&eacute;mon with Baton Pass, and no Pok&eacute;mon may be capable of passing boosts to both Speed and another stat",
        banlist = {"Baton Pass > 1"},
        onBegin = function(self)
            self:add("rule", "Baton Pass Clause: Limit one Baton Passer, can't pass Spe and other stats simultaneously")
        end,
        onValidateSet = function(self, set, format, setHas)
            if not (setHas["move:batonpass"] ~= nil) then
                return
            end
            local item = self.dex.items:get(set.item)
            local ability = self:toID(set.ability)
            local speedBoosted = false
            local nonSpeedBoosted = false
            for ____, moveId in __TS__Iterator(set.moves) do
                local move = self.dex.moves:get(moveId)
                if (move.id == "flamecharge") or ((move.boosts and move.boosts.spe) and (move.boosts.spe > 0)) then
                    speedBoosted = true
                end
                local nonSpeedBoostedMoves = {"acupressure", "bellydrum", "chargebeam", "curse", "diamondstorm", "fellstinger", "fierydance", "flowershield", "poweruppunch", "rage", "rototiller", "skullbash", "stockpile"}
                if nonSpeedBoostedMoves:includes(move.id) or (move.boosts and ((((move.boosts.atk and (move.boosts.atk > 0)) or (move.boosts.def and (move.boosts.def > 0))) or (move.boosts.spa and (move.boosts.spa > 0))) or (move.boosts.spd and (move.boosts.spd > 0)))) then
                    nonSpeedBoosted = true
                end
                if (item.zMove and (move.type == item.zMoveType)) and move.zMove.boost then
                    local boosts = move.zMove.boost
                    if boosts.spe and (boosts.spe > 0) then
                        if not speedBoosted then
                            speedBoosted = move.name
                        end
                    end
                    if (((boosts.atk and (boosts.atk > 0)) or (boosts.def and (boosts.def > 0))) or (boosts.spa and (boosts.spa > 0))) or (boosts.spd and (boosts.spd > 0)) then
                        if (not nonSpeedBoosted) or (move.name == speedBoosted) then
                            nonSpeedBoosted = move.name
                        end
                    end
                end
            end
            local speedBoostedAbilities = {"motordrive", "rattled", "speedboost", "steadfast", "weakarmor"}
            local speedBoostedItems = {"blazikenite", "eeviumz", "kommoniumz", "salacberry"}
            if speedBoostedAbilities:includes(ability) or speedBoostedItems:includes(item.id) then
                speedBoosted = true
            end
            if not speedBoosted then
                return
            end
            local nonSpeedBoostedAbilities = {"angerpoint", "competitive", "defiant", "download", "justified", "lightningrod", "moxie", "sapsipper", "stormdrain"}
            local nonSpeedBoostedItems = {"absorbbulb", "apicotberry", "cellbattery", "eeviumz", "ganlonberry", "keeberry", "kommoniumz", "liechiberry", "luminousmoss", "marangaberry", "petayaberry", "snowball", "starfberry", "weaknesspolicy"}
            if nonSpeedBoostedAbilities:includes(ability) or nonSpeedBoostedItems:includes(item.id) then
                nonSpeedBoosted = true
            end
            if not nonSpeedBoosted then
                return
            end
            if ((speedBoosted ~= nonSpeedBoosted) and (type(speedBoosted) == "string")) and (type(nonSpeedBoosted) == "string") then
                return
            end
            return {
                tostring(set.name or set.species) .. " can Baton Pass both Speed and a different stat, which is banned by Baton Pass Clause."
            }
        end
    },
    ["3batonpassclause"] = {
        effectType = "ValidatorRule",
        name = "3 Baton Pass Clause",
        desc = "Stops teams from having more than three Pok&eacute;mon with Baton Pass",
        banlist = {"Baton Pass > 3"},
        onBegin = function(self)
            self:add("rule", "3 Baton Pass Clause: Limit three Baton Passers")
        end
    },
    cfzclause = {
        effectType = "ValidatorRule",
        name = "CFZ Clause",
        desc = "Bans the use of crystal-free Z-Moves",
        banlist = {"10,000,000 Volt Thunderbolt", "Acid Downpour", "All-Out Pummeling", "Black Hole Eclipse", "Bloom Doom", "Breakneck Blitz", "Catastropika", "Clangorous Soulblaze", "Continental Crush", "Corkscrew Crash", "Devastating Drake", "Extreme Evoboost", "Genesis Supernova", "Gigavolt Havoc", "Guardian of Alola", "Hydro Vortex", "Inferno Overdrive", "Let's Snuggle Forever", "Light That Burns the Sky", "Malicious Moonsault", "Menacing Moonraze Maelstrom", "Never-Ending Nightmare", "Oceanic Operetta", "Pulverizing Pancake", "Savage Spin-Out", "Searing Sunraze Smash", "Shattered Psyche", "Sinister Arrow Raid", "Soul-Stealing 7-Star Strike", "Splintered Stormshards", "Stoked Sparksurfer", "Subzero Slammer", "Supersonic Skystrike", "Tectonic Rage", "Twinkle Tackle"},
        onBegin = function(self)
            self:add("rule", "CFZ Clause: Crystal-free Z-Moves are banned")
        end
    },
    zmoveclause = {
        effectType = "ValidatorRule",
        name = "Z-Move Clause",
        desc = "Bans Pok&eacute;mon from holding Z-Crystals",
        onValidateSet = function(self, set)
            local item = self.dex.items:get(set.item)
            if item.zMove then
                return {
                    ((tostring(set.name or set.species) .. "'s item ") .. tostring(item.name)) .. " is banned by Z-Move Clause."
                }
            end
        end,
        onBegin = function(self)
            self:add("rule", "Z-Move Clause: Z-Moves are banned")
        end
    },
    notfullyevolved = {
        effectType = "ValidatorRule",
        name = "Not Fully Evolved",
        desc = "Bans Pok&eacute;mon that are fully evolved or can't evolve",
        onValidateSet = function(self, set)
            local species = self.dex.species:get(set.species)
            if not species.nfe then
                return {
                    tostring(set.species) .. " cannot evolve."
                }
            end
        end
    },
    hppercentagemod = {
        effectType = "Rule",
        name = "HP Percentage Mod",
        desc = "Shows the HP of Pok&eacute;mon in percentages",
        onBegin = function(self)
            self:add("rule", "HP Percentage Mod: HP is shown in percentages")
            self.reportPercentages = true
        end
    },
    exacthpmod = {
        effectType = "Rule",
        name = "Exact HP Mod",
        desc = "Shows the exact HP of all Pok&eacute;mon",
        onBegin = function(self)
            self:add("rule", "Exact HP Mod: Exact HP is shown")
            self.reportExactHP = true
        end
    },
    cancelmod = {
        effectType = "Rule",
        name = "Cancel Mod",
        desc = "Allows players to change their own choices before their opponents make one",
        onBegin = function(self)
            self.supportCancel = true
        end
    },
    sleepclausemod = {
        effectType = "Rule",
        name = "Sleep Clause Mod",
        desc = "Prevents players from putting more than one of their opponent's Pok&eacute;mon to sleep at a time, and bans Mega Gengar from using Hypnosis",
        banlist = {"Hypnosis + Gengarite"},
        onBegin = function(self)
            self:add("rule", "Sleep Clause Mod: Limit one foe put to sleep")
        end,
        onSetStatus = function(self, status, target, source)
            if source and source:isAlly(target) then
                return
            end
            if status.id == "slp" then
                for ____, pokemon in __TS__Iterator(target.side.pokemon) do
                    if pokemon.hp and (pokemon.status == "slp") then
                        if (not pokemon.statusState.source) or (not pokemon.statusState.source:isAlly(pokemon)) then
                            self:add("-message", "Sleep Clause Mod activated.")
                            return false
                        end
                    end
                end
            end
        end
    },
    stadiumsleepclause = {
        effectType = "Rule",
        name = "Stadium Sleep Clause",
        desc = "Prevents players from putting one of their opponent's Pokémon to sleep if any of the opponent's other Pokémon are asleep (different from Sleep Clause Mod because putting your own Pokémon to sleep is enough to prevent opponents from putting your others to sleep).",
        onBegin = function(self)
            self:add("rule", "Stadium Sleep Clause: Limit one foe put to sleep")
        end,
        onSetStatus = function(self, status, target, source)
            if source and source:isAlly(target) then
                return
            end
            if status.id == "slp" then
                for ____, pokemon in __TS__Iterator(target.side.pokemon) do
                    if pokemon.hp and (pokemon.status == "slp") then
                        self:add("-message", "Sleep Clause activated. (In Stadium, Sleep Clause activates if any of the opponent's Pokemon are asleep, even if self-inflicted from Rest)")
                        return false
                    end
                end
            end
        end
    },
    switchpriorityclausemod = {
        effectType = "Rule",
        name = "Switch Priority Clause Mod",
        desc = "Makes a faster Pokémon switch first when double-switching, unlike in Emerald link battles, where player 1's Pokémon would switch first",
        onBegin = function(self)
            self:add("rule", "Switch Priority Clause Mod: Faster Pokémon switch first")
        end
    },
    desyncclausemod = {
        effectType = "Rule",
        name = "Desync Clause Mod",
        desc = "If a desync would happen, the move fails instead. This rule currently covers Psywave and Counter.",
        onBegin = function(self)
            self:add("rule", "Desync Clause Mod: Desyncs changed to move failure.")
        end
    },
    deoxyscamouflageclause = {
        effectType = "Rule",
        name = "Deoxys Camouflage Clause",
        desc = "Reveals the Deoxys forme when it is sent in battle.",
        onBegin = function(self)
            self:add("rule", "Deoxys Camouflage Clause: Reveals the Deoxys forme when it is sent in battle.")
        end
    },
    freezeclausemod = {
        effectType = "Rule",
        name = "Freeze Clause Mod",
        desc = "Prevents players from freezing more than one of their opponent's Pok&eacute;mon at a time",
        onBegin = function(self)
            self:add("rule", "Freeze Clause Mod: Limit one foe frozen")
        end,
        onSetStatus = function(self, status, target, source)
            if source and source:isAlly(target) then
                return
            end
            if status.id == "frz" then
                for ____, pokemon in __TS__Iterator(target.side.pokemon) do
                    if pokemon.status == "frz" then
                        self:add("-message", "Freeze Clause activated.")
                        return false
                    end
                end
            end
        end
    },
    sametypeclause = {
        effectType = "ValidatorRule",
        name = "Same Type Clause",
        desc = "Forces all Pok&eacute;mon on a team to share a type with each other",
        onBegin = function(self)
            self:add("rule", "Same Type Clause: Pokémon in a team must share a type")
        end,
        onValidateTeam = function(self, team)
            local typeTable = {}
            for ____, ____value in __TS__Iterator(
                team:entries()
            ) do
                local i
                i = ____value[1]
                local set
                set = ____value[2]
                local species = self.dex.species:get(set.species)
                if not species.types then
                    return {
                        "Invalid pokemon " .. tostring(set.name or set.species)
                    }
                end
                if i == 0 then
                    typeTable = species.types
                else
                    typeTable = __TS__ArrayFilter(
                        typeTable,
                        function(____, ____type) return species.types:includes(____type) end
                    )
                end
                if self.gen >= 7 then
                    local item = self.dex.items:get(set.item)
                    if item.megaStone and (species.baseSpecies == item.megaEvolves) then
                        species = self.dex.species:get(item.megaStone)
                        typeTable = __TS__ArrayFilter(
                            typeTable,
                            function(____, ____type) return species.types:includes(____type) end
                        )
                    end
                    if (item.id == "ultranecroziumz") and (species.baseSpecies == "Necrozma") then
                        species = self.dex.species:get("Necrozma-Ultra")
                        typeTable = __TS__ArrayFilter(
                            typeTable,
                            function(____, ____type) return species.types:includes(____type) end
                        )
                    end
                end
                if not #typeTable then
                    return {"Your team must share a type."}
                end
            end
        end
    },
    megarayquazaclause = {
        effectType = "Rule",
        name = "Mega Rayquaza Clause",
        desc = "Prevents Rayquaza from mega evolving",
        onBegin = function(self)
            self:add("rule", "Mega Rayquaza Clause: You cannot mega evolve Rayquaza")
            for ____, pokemon in __TS__Iterator(
                self:getAllPokemon()
            ) do
                if pokemon.species.id == "rayquaza" then
                    pokemon.canMegaEvo = nil
                end
            end
        end
    },
    dynamaxclause = {
        effectType = "Rule",
        name = "Dynamax Clause",
        desc = "Prevents Pok&eacute;mon from dynamaxing",
        onValidateSet = function(self, set)
            if set.gigantamax then
                return {
                    ("Your set for " .. tostring(set.species)) .. " is flagged as Gigantamax, but Gigantamaxing is disallowed",
                    "(If this was a mistake, disable Gigantamaxing on the set.)"
                }
            end
        end,
        onBegin = function(self)
            for ____, side in __TS__Iterator(self.sides) do
                side.dynamaxUsed = true
            end
            self:add("rule", "Dynamax Clause: You cannot dynamax")
        end
    },
    arceusevlimit = {
        effectType = "ValidatorRule",
        name = "Arceus EV Limit",
        desc = "Restricts Arceus to a maximum of 100 EVs in any one stat, and only multiples of 10",
        onValidateSet = function(self, set)
            local species = self.dex.species:get(set.species)
            if (species.num == 493) and set.evs then
                local stat
                for ____value in pairs(set.evs) do
                    stat = ____value
                    local ev = set.evs[stat]
                    if ev > 100 then
                        return {"Arceus can't have more than 100 EVs in any stat, because Arceus is only obtainable from level 100 events.", "Level 100 Pokemon can only gain EVs from vitamins (Carbos etc), which are capped at 100 EVs."}
                    end
                    if not (((ev % 10) == 0) or (((ev % 10) == 8) and ((ev % 4) == 0))) then
                        return {"Arceus can only have EVs that are multiples of 10, because Arceus is only obtainable from level 100 events.", "Level 100 Pokemon can only gain EVs from vitamins (Carbos etc), which boost in multiples of 10."}
                    end
                end
            end
        end
    },
    inversemod = {
        effectType = "Rule",
        name = "Inverse Mod",
        desc = "The mod for Inverse Battle which inverts the type effectiveness chart; weaknesses become resistances, while resistances and immunities become weaknesses",
        onNegateImmunity = false,
        onBegin = function(self)
            self:add("rule", "Inverse Mod: Weaknesses become resistances, while resistances and immunities become weaknesses.")
        end,
        onEffectivenessPriority = 1,
        onEffectiveness = function(self, typeMod, target, ____type, move)
            if (move and (move.id == "freezedry")) and (____type == "Water") then
                return
            end
            if move and (not self.dex:getImmunity(move, ____type)) then
                return 1
            end
            return -typeMod
        end
    },
    minsourcegen = {
        effectType = "ValidatorRule",
        name = "Min Source Gen",
        desc = "Pokemon must be obtained from this generation or later.",
        hasValue = "positive-integer",
        onValidateRule = function(self, value)
            local minSourceGen = __TS__ParseInt(value)
            if minSourceGen > self.dex.gen then
                error(
                    __TS__New(
                        Error,
                        (((("Invalid generation " .. tostring(minSourceGen)) .. tostring(
                            self.ruleTable:blame("minsourcegen")
                        )) .. " for a Gen ") .. tostring(self.dex.gen)) .. " format"
                    ),
                    0
                )
            end
        end
    },
    stabmonsmovelegality = {
        effectType = "ValidatorRule",
        name = "STABmons Move Legality",
        desc = "Allows Pok&eacute;mon to use any move that they or a previous evolution/out-of-battle forme share a type with",
        checkCanLearn = function(self, move, species, setSources, set)
            local nonstandard = (move.isNonstandard == "Past") and (not self.ruleTable:has("standardnatdex"))
            if (((not nonstandard) and (not move.isZ)) and (not move.isMax)) and (not self.ruleTable:isRestricted(
                "move:" .. tostring(move.id)
            )) then
                local dex = self.dex
                local types
                if species.forme or species.otherFormes then
                    local baseSpecies = dex.species:get(species.baseSpecies)
                    local originalForme = dex.species:get(species.changesFrom or species.name)
                    types = originalForme.types
                    if baseSpecies.otherFormes then
                        for ____, formeName in __TS__Iterator(baseSpecies.otherFormes) do
                            do
                                if baseSpecies.prevo then
                                    local prevo = dex.species:get(baseSpecies.prevo)
                                    if prevo.evos:includes(formeName) then
                                        goto __continue206
                                    end
                                end
                                local forme = dex.species:get(formeName)
                                if (forme.changesFrom == originalForme.name) and (not forme.battleOnly) then
                                    types = __TS__ArrayConcat(types, forme.types)
                                end
                            end
                            ::__continue206::
                        end
                    end
                else
                    types = species.types
                end
                local prevo = species.prevo
                while prevo do
                    local prevoSpecies = dex.species:get(prevo)
                    types = __TS__ArrayConcat(types, prevoSpecies.types)
                    prevo = prevoSpecies.prevo
                end
                if types:includes(move.type) then
                    return nil
                end
            end
            return self:checkCanLearn(move, species, setSources, set)
        end
    },
    alphabetcupmovelegality = {
        effectType = "ValidatorRule",
        name = "Alphabet Cup Move Legality",
        desc = "Allows Pok&eacute;mon to use any move that shares the same first letter as their name or a previous evolution's name.",
        checkCanLearn = function(self, move, species, setSources, set)
            local nonstandard = (move.isNonstandard == "Past") and (not self.ruleTable:has("standardnatdex"))
            if (((not nonstandard) and (not move.isZ)) and (not move.isMax)) and (not self.ruleTable:isRestricted(
                "move:" .. tostring(move.id)
            )) then
                local letters = {species.id[0]}
                local prevo = species.prevo
                while prevo do
                    local prevoSpecies = self.dex.species:get(prevo)
                    __TS__ArrayPush(letters, prevoSpecies.id[0])
                    prevo = prevoSpecies.prevo
                end
                if letters:includes(move.id[0]) then
                    return nil
                end
            end
            return self:checkCanLearn(move, species, setSources, set)
        end
    },
    sketchmonsmovelegality = {
        effectType = "ValidatorRule",
        name = "Sketchmons Move Legality",
        desc = "Pok&eacute;mon can learn one of any move they don't normally learn.",
        checkCanLearn = function(self, move, species, lsetData, set)
            local problem = self:checkCanLearn(move, species, lsetData, set)
            if not problem then
                return nil
            end
            if (move.isZ or move.isMax) or self.ruleTable:isRestricted(
                "move:" .. tostring(move.id)
            ) then
                return problem
            end
            if set.sketchMove then
                return (((((" already has " .. tostring(set.sketchMove)) .. " as a sketched move.\n(") .. tostring(species.name)) .. " doesn't learn ") .. tostring(move.name)) .. ".)"
            end
            set.sketchMove = move.name
            return nil
        end,
        onValidateTeam = function(self, team)
            local sketches = __TS__New(Utils.Multiset)
            for ____, set in __TS__Iterator(team) do
                if set.sketchMove then
                    sketches:add(set.sketchMove)
                end
            end
            local overSketched = __TS__ArrayFilter(
                {
                    __TS__Spread(
                        sketches:entries()
                    )
                },
                function(____, ____bindingPattern0)
                    local moveName = ____bindingPattern0[1]
                    local count
                    count = ____bindingPattern0[2]
                    return count > 1
                end
            )
            if #overSketched then
                return __TS__ArrayMap(
                    overSketched,
                    function(____, ____bindingPattern0)
                        local moveName
                        moveName = ____bindingPattern0[1]
                        local count
                        count = ____bindingPattern0[2]
                        return ((((("You are limited to 1 of " .. tostring(moveName)) .. " by Sketch Clause.\n(You have sketched ") .. tostring(moveName)) .. " ") .. tostring(count)) .. " times.)"
                    end
                )
            end
        end
    },
    allowtradeback = {effectType = "ValidatorRule", name = "Allow Tradeback", desc = "Allows Gen 1 pokemon to have moves from their Gen 2 learnsets"},
    allowavs = {effectType = "ValidatorRule", name = "Allow AVs", desc = "Tells formats with the 'gen7letsgo' mod to take Awakening Values into consideration when calculating stats"},
    nfeclause = {
        effectType = "ValidatorRule",
        name = "NFE Clause",
        desc = "Bans all NFE Pokemon",
        onValidateSet = function(self, set)
            local species = self.dex.species:get(set.species or set.name)
            if species.nfe then
                if self.ruleTable:has(
                    "+pokemon:" .. tostring(species.id)
                ) then
                    return
                end
                return {
                    tostring(set.species) .. " is banned due to NFE Clause."
                }
            end
        end
    },
    mimicglitch = {effectType = "ValidatorRule", name = "Mimic Glitch", desc = "Allows any Pokemon with access to Assist, Copycat, Metronome, Mimic, or Transform to gain access to almost any other move."},
    overflowstatmod = {effectType = "Rule", name = "Overflow Stat Mod", desc = "Caps stats at 654 after a positive nature, or 655 after a negative nature"},
    formeclause = {
        effectType = "ValidatorRule",
        name = "Forme Clause",
        desc = "Prevents teams from having more than one Pok&eacute;mon of the same forme",
        onBegin = function(self)
            self:add("rule", "Forme Clause: Limit one of each forme of a Pokémon")
        end,
        onValidateTeam = function(self, team)
            local formeTable = __TS__New(Set)
            for ____, set in __TS__Iterator(team) do
                local species = self.dex.species:get(set.species)
                if species.name ~= species.baseSpecies then
                    local baseSpecies = self.dex.species:get(species.baseSpecies)
                    if (species.types:join("/") == baseSpecies.types:join("/")) and (__TS__ObjectValues(species.baseStats):join("/") == __TS__ObjectValues(baseSpecies.baseStats):join("/")) then
                        species = baseSpecies
                    end
                end
                if formeTable:has(species.name) then
                    return {
                        "You are limited to one of each forme of a Pokémon by Forme Clause.",
                        ("(You have more than one of " .. tostring(species.name)) .. ")"
                    }
                end
                formeTable:add(species.name)
            end
        end
    },
    ["350cupmod"] = {
        effectType = "Rule",
        name = "350 Cup Mod",
        desc = "If a Pok&eacute;mon's BST is 350 or lower, all of its stats get doubled.",
        onBegin = function(self)
            self:add("rule", "350 Cup Mod: If a Pokemon's BST is 350 or lower, all of its stats get doubled.")
        end,
        onModifySpeciesPriority = 2,
        onModifySpecies = function(self, species)
            local newSpecies = self.dex:deepClone(species)
            if newSpecies.bst <= 350 then
                newSpecies.bst = 0
                for stat in pairs(newSpecies.baseStats) do
                    newSpecies.baseStats[stat] = self:clampIntRange(newSpecies.baseStats[stat] * 2, 1, 255)
                    newSpecies.bst = newSpecies.bst + newSpecies.baseStats[stat]
                end
            end
            return newSpecies
        end
    },
    flippedmod = {
        effectType = "Rule",
        name = "Flipped Mod",
        desc = "Every Pok&eacute;mon's stats are reversed. HP becomes Spe, Atk becomes Sp. Def, Def becomes Sp. Atk, and vice versa.",
        onBegin = function(self)
            self:add("rule", "Flipped Mod: Pokemon have their stats flipped (HP becomes Spe, vice versa).")
        end,
        onModifySpeciesPriority = 2,
        onModifySpecies = function(self, species)
            local newSpecies = self.dex:deepClone(species)
            local reversedNums = __TS__ObjectValues(newSpecies.baseStats):reverse()
            for ____, ____value in __TS__Iterator(
                __TS__ObjectKeys(newSpecies.baseStats):entries()
            ) do
                local i
                i = ____value[1]
                local statName
                statName = ____value[2]
                newSpecies.baseStats[statName] = reversedNums[i]
            end
            return newSpecies
        end
    },
    scalemonsmod = {
        effectType = "Rule",
        name = "Scalemons Mod",
        desc = "Every Pok&eacute;mon's stats, barring HP, are scaled to give them a BST as close to 600 as possible",
        onBegin = function(self)
            self:add("rule", "Scalemons Mod: Every Pokemon's stats, barring HP, are scaled to come as close to a BST of 600 as possible")
        end,
        onModifySpeciesPriority = 1,
        onModifySpecies = function(self, species)
            local newSpecies = self.dex:deepClone(species)
            local bstWithoutHp = newSpecies.bst - newSpecies.baseStats.hp
            local scale = 600 - newSpecies.baseStats.hp
            newSpecies.bst = newSpecies.baseStats.hp
            for stat in pairs(newSpecies.baseStats) do
                do
                    if stat == "hp" then
                        goto __continue245
                    end
                    newSpecies.baseStats[stat] = self:clampIntRange((newSpecies.baseStats[stat] * scale) / bstWithoutHp, 1, 255)
                    newSpecies.bst = newSpecies.bst + newSpecies.baseStats[stat]
                end
                ::__continue245::
            end
            return newSpecies
        end
    },
    teamtypepreview = {
        effectType = "Rule",
        name = "Team Type Preview",
        desc = "Allows each player to see the Pok&eacute;mon on their opponent's team and those Pok&eacute;mon's types before they choose their lead Pok&eacute;mon",
        onTeamPreview = function(self)
            for ____, side in __TS__Iterator(self.sides) do
                for ____, pokemon in __TS__Iterator(side.pokemon) do
                    local details = pokemon.details:replace(", shiny", ""):replace(nil, "$1-*")
                    self:add("poke", pokemon.side.id, details, "")
                end
                local buf = "raw|"
                for ____, pokemon in __TS__Iterator(side.pokemon) do
                    if not buf:endsWith("|") then
                        buf = tostring(buf) .. "/</span>&#8203;"
                    end
                    buf = tostring(buf) .. (("<span style=\"white-space:nowrap\"><psicon pokemon=\"" .. tostring(pokemon.species.id)) .. "\" />")
                    for ____, ____type in __TS__Iterator(pokemon.species.types) do
                        buf = tostring(buf) .. (("<psicon type=\"" .. tostring(____type)) .. "\" /> ")
                    end
                end
                self:add(buf .. "</span>")
            end
            self:makeRequest("teampreview")
        end
    },
    aaarestrictedabilities = {
        effectType = "ValidatorRule",
        name = "AAA Restricted Abilities",
        desc = "Allows validation for AAA formats to use restricted abilities instead of banned ones.",
        onValidateSet = function(self, set)
            local ability = self.dex.abilities:get(set.ability)
            if self.ruleTable:isRestricted(
                "ability:" .. tostring(ability.id)
            ) then
                local species = self.dex.species:get(set.species)
                if not __TS__ObjectValues(species.abilities):includes(ability.name) then
                    return {
                        ("The Ability \"" .. tostring(ability.name)) .. "\" is restricted.",
                        ("(Only Pokémon that get " .. tostring(ability.name)) .. " naturally can use it.)"
                    }
                end
            end
        end
    },
    eventmovesclause = {
        effectType = "ValidatorRule",
        name = "Event Moves Clause",
        desc = "Bans moves only obtainable through events.",
        onBegin = function(self)
            self:add("rule", "Event Moves Clause: Event-only moves are banned")
        end,
        onValidateSet = function(self, set)
            local species = self.dex.species:get(set.species)
            local learnsetData = __TS__ObjectAssign({}, self.dex.data.Learnsets[species.id].learnset or ({}))
            local prevo = species.prevo
            while prevo do
                local prevoSpecies = self.dex.species:get(prevo)
                local prevoLsetData = self.dex.data.Learnsets[prevoSpecies.id].learnset or ({})
                for moveid in pairs(prevoLsetData) do
                    if not (learnsetData[moveid] ~= nil) then
                        learnsetData[moveid] = prevoLsetData[moveid]
                    else
                        learnsetData[moveid]:push(
                            __TS__Spread(prevoLsetData[moveid])
                        )
                    end
                end
                prevo = prevoSpecies.prevo
            end
            local problems = {}
            if set.moves.length then
                for ____, move in __TS__Iterator(set.moves) do
                    if learnsetData[self:toID(move)] and (not learnsetData[self:toID(move)]:filter(
                        function(____, v) return not v:includes("S") end
                    ).length) then
                        __TS__ArrayPush(
                            problems,
                            ((tostring(species.name) .. "'s move ") .. tostring(move)) .. " is obtainable only through events."
                        )
                    end
                end
            end
            if #problems then
                __TS__ArrayPush(problems, "(Event-only moves are banned.)")
            end
            return problems
        end
    },
    pickedteamsize = {
        effectType = "Rule",
        name = "Picked Team Size",
        desc = "Team size (number of pokemon) that can be brought out of Team Preview",
        hasValue = "positive-integer",
        onValidateRule = function(self)
            if not self.ruleTable:has("teampreview") then
                error(
                    __TS__New(
                        Error,
                        ("The \"Picked Team Size\" rule" .. tostring(
                            self.ruleTable:blame("pickedteamsize")
                        )) .. " requires Team Preview."
                    ),
                    0
                )
            end
        end
    },
    minteamsize = {effectType = "ValidatorRule", name = "Min Team Size", desc = "Minimum team size (number of pokemon) that can be brought into Team Preview (or into the battle, in formats without Team Preview)", hasValue = "positive-integer"},
    evlimit = {effectType = "ValidatorRule", name = "EV Limit", desc = "Maximum total EVs on each pokemon.", hasValue = "integer"},
    maxteamsize = {effectType = "ValidatorRule", name = "Max Team Size", desc = "Maximum team size (number of pokemon) that can be brought into Team Preview (or into the battle, in formats without Team Preview)", hasValue = "positive-integer"},
    maxmovecount = {effectType = "ValidatorRule", name = "Max Move Count", desc = "Max number of moves allowed on a single pokemon (defaults to 4 in a normal game)", hasValue = "positive-integer"},
    maxtotallevel = {
        effectType = "Rule",
        name = "Max Total Level",
        desc = "Teams are restricted to a total maximum Level limit and Pokemon are restricted to a set range of Levels",
        hasValue = "positive-integer",
        onValidateTeam = function(self, team)
            local pickedTeamSize = self.ruleTable.pickedTeamSize or team.length
            local maxTotalLevel = self.ruleTable.maxTotalLevel
            if maxTotalLevel == nil then
                error(
                    __TS__New(Error, "No maxTotalLevel specified."),
                    0
                )
            end
            local teamLevels = {}
            for ____, set in __TS__Iterator(team) do
                __TS__ArrayPush(teamLevels, set.level)
            end
            __TS__ArraySort(
                teamLevels,
                function(____, a, b) return a - b end
            )
            local totalLowestLevels = 0
            do
                local i = 0
                while i < pickedTeamSize do
                    totalLowestLevels = totalLowestLevels + teamLevels[i + 1]
                    i = i + 1
                end
            end
            if totalLowestLevels > maxTotalLevel then
                local thePokemon = (((pickedTeamSize == team.length) and (function() return ("all " .. tostring(team.length)) .. " Pokémon" end)) or (function() return ("the " .. tostring(pickedTeamSize)) .. " lowest-leveled Pokémon" end))()
                return {
                    (((((("The combined levels of " .. thePokemon) .. " of your team is ") .. tostring(totalLowestLevels)) .. ", above the format's total level limit of ") .. tostring(maxTotalLevel)) .. tostring(
                        self.ruleTable:blame("maxtotallevel")
                    )) .. "."
                }
            end
            local minTotalWithHighestLevel = teamLevels[#teamLevels]
            do
                local i = 0
                while i < (pickedTeamSize - 1) do
                    minTotalWithHighestLevel = minTotalWithHighestLevel + teamLevels[i + 1]
                    i = i + 1
                end
            end
            if minTotalWithHighestLevel > maxTotalLevel then
                return {
                    (("Your highest level Pokémon is unusable, because there's no way to create a team with it whose total level is less than the format's total level limit of " .. tostring(maxTotalLevel)) .. tostring(
                        self.ruleTable:blame("maxtotallevel")
                    )) .. "."
                }
            end
        end,
        onValidateRule = function(self, value)
            local ruleTable = self.ruleTable
            local maxTotalLevel = ruleTable.maxTotalLevel
            local maxTeamSize = ruleTable.pickedTeamSize or ruleTable.maxTeamSize
            local maxTeamSizeBlame = ((ruleTable.pickedTeamSize and (function() return ruleTable:blame("pickedteamsize") end)) or (function() return ruleTable:blame("maxteamsize") end))()
            if maxTotalLevel >= (ruleTable.maxLevel * maxTeamSize) then
                error(
                    __TS__New(
                        Error,
                        ((((((("A Max Total Level of " .. tostring(maxTotalLevel)) .. tostring(
                            ruleTable:blame("maxtotallevel")
                        )) .. " is too high (and will have no effect) with ") .. tostring(maxTeamSize)) .. tostring(maxTeamSizeBlame)) .. " Pokémon at max level ") .. tostring(ruleTable.maxLevel)) .. tostring(
                            ruleTable:blame("maxlevel")
                        )
                    ),
                    0
                )
            end
            if maxTotalLevel <= (ruleTable.minLevel * maxTeamSize) then
                error(
                    __TS__New(
                        Error,
                        ((((((("A Max Total Level of " .. tostring(maxTotalLevel)) .. tostring(
                            ruleTable:blame("maxtotallevel")
                        )) .. " is too low with ") .. tostring(maxTeamSize)) .. tostring(maxTeamSizeBlame)) .. " Pokémon at min level ") .. tostring(ruleTable.minLevel)) .. tostring(
                            ruleTable:blame("minlevel")
                        )
                    ),
                    0
                )
            end
        end
    },
    minlevel = {effectType = "ValidatorRule", name = "Min Level", desc = "Minimum level of brought Pokémon", hasValue = "positive-integer"},
    maxlevel = {effectType = "ValidatorRule", name = "Max Level", desc = "Maximum level of brought Pokémon (if you're using both this and Adjust Level, this will control what level moves you have access to)", hasValue = "positive-integer"},
    defaultlevel = {effectType = "ValidatorRule", name = "Default Level", desc = "Default level of brought Pokémon (normally should be equal to Max Level, except Custom Games have a very high max level but still default to 100)", hasValue = "positive-integer"},
    adjustlevel = {effectType = "ValidatorRule", name = "Adjust Level", desc = "All Pokémon will be set to exactly this level (but unlike Max Level and Min Level, it will still be able to learn moves from above this level) (when using this, Max Level is the level of the pokemon before it's level-adjusted down)", hasValue = "positive-integer", mutuallyExclusiveWith = "adjustleveldown"},
    adjustleveldown = {effectType = "ValidatorRule", name = "Adjust Level Down", desc = "Any Pokémon above this level will be set to this level (but unlike Max Level, it will still be able to learn moves from above this level)", hasValue = "positive-integer", mutuallyExclusiveWith = "adjustlevel"},
    stadiumitemsclause = {effectType = "ValidatorRule", name = "Stadium Items Clause", desc = "Bans items that are not usable in Pokemon Stadium 2.", banlist = {"Fast Ball", "Friend Ball", "Great Ball", "Heavy Ball", "Level Ball", "Love Ball", "Lure Ball", "Master Ball", "Moon Ball", "Park Ball", "Poke Ball", "Safari Ball", "Ultra Ball", "Fire Stone", "Leaf Stone", "Moon Stone", "Sun Stone", "Thunder Stone", "Upgrade", "Water Stone", "Mail"}},
    nintendocup2000movelegality = {effectType = "ValidatorRule", name = "Nintendo Cup 2000 Move Legality", desc = "Prevents Pokémon from having moves that would only be obtainable in Pokémon Crystal."},
    nintendocup1997movelegality = {effectType = "ValidatorRule", name = "Nintendo Cup 1997 Move Legality", desc = "Bans move combinations on Pokémon that weren't legal in Nintendo Cup 1997."},
    noswitching = {
        effectType = "Rule",
        name = "No Switching",
        desc = "All Pokémon are trapped (cannot switch naturally, but can as the effect of an item, move, or Ability).",
        onBegin = function(self)
            self:add("rule", "No Switching: All Pokémon are trapped")
        end,
        onTrapPokemon = function(self, pokemon)
            pokemon.trapped = true
        end
    },
    chimera1v1rule = {
        effectType = "Rule",
        name = "Chimera 1v1 Rule",
        desc = "Validation and battle effects for Chimera 1v1.",
        ruleset = {"Team Preview", "Picked Team Size = 6"},
        onValidateSet = function(self, set)
            if not set.item then
                return
            end
            local item = self.dex.items:get(set.item)
            if item.itemUser and (not self.ruleTable:has(
                "+item:" .. tostring(item.id)
            )) then
                return {
                    ((tostring(set.species) .. "'s item ") .. tostring(item.name)) .. " is banned."
                }
            end
        end,
        onValidateRule = function(self)
            local ____table = self.ruleTable
            if (____table.pickedTeamSize or ____table.minTeamSize) < 6 then
                error(
                    __TS__New(Error, "Custom rules that could allow the active team size to be reduced below 6 (Min Team Size < 6, Picked Team Size < 6) could prevent the Chimera from being fully defined, and are incompatible with Chimera 1v1."),
                    0
                )
            end
            local gameType = self.format.gameType
            if (gameType == "doubles") or (gameType == "triples") then
                error(
                    __TS__New(
                        Error,
                        ("The game type '" .. tostring(gameType)) .. "' cannot be 1v1 because sides can have multiple active Pokémon, so it is incompatible with Chimera 1v1."
                    ),
                    0
                )
            end
        end,
        onBeforeSwitchIn = function(self, pokemon)
            local allies = pokemon.side.pokemon:splice(1)
            pokemon.side.pokemonLeft = 1
            local newSpecies = self.dex:deepClone(pokemon.baseSpecies)
            newSpecies.abilities = allies[1].baseSpecies.abilities
            newSpecies.baseStats = allies[2].baseSpecies.baseStats
            newSpecies.bst = allies[2].baseSpecies.bst
            pokemon.item = allies[0].item
            pokemon.ability = (function(o, i, v)
                o[i] = v
                return v
            end)(pokemon, "baseAbility", allies[1].ability)
            pokemon.set.evs = allies[2].set.evs
            pokemon.set.nature = allies[2].set.nature
            pokemon.set.ivs = allies[2].set.ivs
            pokemon.hpType = (function(o, i, v)
                o[i] = v
                return v
            end)(pokemon, "baseHpType", allies[2].baseHpType)
            pokemon.moveSlots = (function(o, i, v)
                o[i] = v
                return v
            end)(
                pokemon,
                "baseMoveSlots",
                __TS__ArrayFilter(
                    {
                        __TS__Unpack(
                            __TS__ArrayConcat(
                                {
                                    __TS__Spread(
                                        allies[3].baseMoveSlots:slice(0, 2)
                                    )
                                },
                                {
                                    __TS__Spread(
                                        allies[4].baseMoveSlots:slice(2)
                                    )
                                }
                            )
                        )
                    },
                    function(____, move, index, moveSlots) return moveSlots:find(
                        function(____, othermove) return othermove.id == move.id end
                    ) == move end
                )
            )
            pokemon.maxhp = 0
            pokemon:setSpecies(newSpecies, nil)
        end
    },
    bonustyperule = {
        name = "Bonus Type Rule",
        effectType = "Rule",
        desc = "Pok&eacute;mon can be nicknamed the name of a type to have that type added onto their current ones.",
        onBegin = function(self)
            self:add("rule", "Bonus Type Rule: Pokémon can be nicknamed the name of a type to have that type added onto their current ones.")
        end,
        onModifySpeciesPriority = 1,
        onModifySpecies = function(self, species, target, source, effect)
            if not target then
                return
            end
            if effect and ({"imposter", "transform"}):includes(effect.id) then
                return
            end
            local typesSet = __TS__New(Set, species.types)
            local bonusType = self.dex.types:get(target.set.name)
            if bonusType.exists then
                typesSet:add(bonusType.name)
            end
            return __TS__ObjectAssign(
                {},
                species,
                {
                    types = {
                        __TS__Spread(typesSet)
                    }
                }
            )
        end,
        onSwitchIn = function(self, pokemon)
            self:add(
                "-start",
                pokemon,
                "typechange",
                (pokemon.illusion or pokemon):getTypes(true):join("/"),
                "[silent]"
            )
        end,
        onAfterMega = function(self, pokemon)
            self:add(
                "-start",
                pokemon,
                "typechange",
                (pokemon.illusion or pokemon):getTypes(true):join("/"),
                "[silent]"
            )
        end
    }
}
return ____exports
