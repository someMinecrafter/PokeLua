--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____dex = require("sim/dex")
local Dex = ____dex.Dex
local toID = ____dex.toID
____exports.Teams = __TS__New(
    (function()
        local Teams = __TS__Class()
        Teams.name = "Teams"
        function Teams.prototype.____constructor(self)
        end
        function Teams.prototype.pack(self, team)
            if not team then
                return ""
            end
            local function getIv(self, ivs, s)
                return (((ivs[s] == 31) or (ivs[s] == nil)) and "") or tostring(ivs[s])
            end
            local buf = ""
            for ____, set in ipairs(team) do
                if buf then
                    buf = tostring(buf) .. "]"
                end
                buf = tostring(buf) .. tostring(set.name or set.species)
                local id = self:packName(set.species or set.name)
                buf = tostring(buf) .. ("|" .. tostring(
                    ((self:packName(set.name or set.species) == id) and "") or id
                ))
                buf = tostring(buf) .. ("|" .. tostring(
                    self:packName(set.item)
                ))
                buf = tostring(buf) .. ("|" .. tostring(
                    self:packName(set.ability)
                ))
                buf = tostring(buf) .. ("|" .. tostring(
                    table.concat(
                        __TS__ArrayMap(set.moves, self.packName),
                        "," or ","
                    )
                ))
                buf = tostring(buf) .. ("|" .. tostring(set.nature or ""))
                local evs = "|"
                if set.evs then
                    evs = (((((((((("|" .. tostring(set.evs.hp or "")) .. ",") .. tostring(set.evs.atk or "")) .. ",") .. tostring(set.evs.def or "")) .. ",") .. tostring(set.evs.spa or "")) .. ",") .. tostring(set.evs.spd or "")) .. ",") .. tostring(set.evs.spe or "")
                end
                if evs == "|,,,,," then
                    buf = tostring(buf) .. "|"
                else
                    buf = tostring(buf) .. tostring(evs)
                end
                if set.gender then
                    buf = tostring(buf) .. ("|" .. tostring(set.gender))
                else
                    buf = tostring(buf) .. "|"
                end
                local ivs = "|"
                if set.ivs then
                    ivs = (((((((((("|" .. tostring(
                        getIv(_G, set.ivs, "hp")
                    )) .. ",") .. tostring(
                        getIv(_G, set.ivs, "atk")
                    )) .. ",") .. tostring(
                        getIv(_G, set.ivs, "def")
                    )) .. ",") .. tostring(
                        getIv(_G, set.ivs, "spa")
                    )) .. ",") .. tostring(
                        getIv(_G, set.ivs, "spd")
                    )) .. ",") .. tostring(
                        getIv(_G, set.ivs, "spe")
                    )
                end
                if ivs == "|,,,,," then
                    buf = tostring(buf) .. "|"
                else
                    buf = tostring(buf) .. tostring(ivs)
                end
                if set.shiny then
                    buf = tostring(buf) .. "|S"
                else
                    buf = tostring(buf) .. "|"
                end
                if set.level and (set.level ~= 100) then
                    buf = tostring(buf) .. ("|" .. tostring(set.level))
                else
                    buf = tostring(buf) .. "|"
                end
                if (set.happiness ~= nil) and (set.happiness ~= 255) then
                    buf = tostring(buf) .. ("|" .. tostring(set.happiness))
                else
                    buf = tostring(buf) .. "|"
                end
                if (set.pokeball or set.hpType) or set.gigantamax then
                    buf = tostring(buf) .. ("," .. tostring(set.hpType or ""))
                    buf = tostring(buf) .. ("," .. tostring(
                        self:packName(set.pokeball or "")
                    ))
                    buf = tostring(buf) .. ("," .. tostring((set.gigantamax and "G") or ""))
                end
            end
            return buf
        end
        function Teams.prototype.unpack(self, buf)
            if not buf then
                return nil
            end
            if type(buf) ~= "string" then
                return buf
            end
            if buf:startsWith("[") and buf:endsWith("]") then
                buf = self:pack(
                    JSON:parse(buf)
                )
            end
            local team = {}
            local i = 0
            local j = 0
            do
                local count = 0
                while count < 24 do
                    local set = {}
                    __TS__ArrayPush(team, set)
                    j = (string.find(
                        buf,
                        "|",
                        math.max(i + 1, 1),
                        true
                    ) or 0) - 1
                    if j < 0 then
                        return nil
                    end
                    set.name = __TS__StringSubstring(buf, i, j)
                    i = j + 1
                    j = (string.find(
                        buf,
                        "|",
                        math.max(i + 1, 1),
                        true
                    ) or 0) - 1
                    if j < 0 then
                        return nil
                    end
                    set.species = self:unpackName(
                        __TS__StringSubstring(buf, i, j),
                        Dex.species
                    ) or set.name
                    i = j + 1
                    j = (string.find(
                        buf,
                        "|",
                        math.max(i + 1, 1),
                        true
                    ) or 0) - 1
                    if j < 0 then
                        return nil
                    end
                    set.item = self:unpackName(
                        __TS__StringSubstring(buf, i, j),
                        Dex.items
                    )
                    i = j + 1
                    j = (string.find(
                        buf,
                        "|",
                        math.max(i + 1, 1),
                        true
                    ) or 0) - 1
                    if j < 0 then
                        return nil
                    end
                    local ability = __TS__StringSubstring(buf, i, j)
                    local species = Dex.species:get(set.species)
                    set.ability = ((({"", "0", "1", "H", "S"}):includes(ability) and (function() return species.abilities[ability or "0"] or (((ability == "") and "") or "!!!ERROR!!!") end)) or (function() return self:unpackName(ability, Dex.abilities) end))()
                    i = j + 1
                    j = (string.find(
                        buf,
                        "|",
                        math.max(i + 1, 1),
                        true
                    ) or 0) - 1
                    if j < 0 then
                        return nil
                    end
                    set.moves = __TS__ArrayMap(
                        __TS__StringSplit(
                            __TS__StringSubstring(buf, i, j),
                            ",",
                            24
                        ),
                        function(____, name) return self:unpackName(name, Dex.moves) end
                    )
                    i = j + 1
                    j = (string.find(
                        buf,
                        "|",
                        math.max(i + 1, 1),
                        true
                    ) or 0) - 1
                    if j < 0 then
                        return nil
                    end
                    set.nature = self:unpackName(
                        __TS__StringSubstring(buf, i, j),
                        Dex.natures
                    )
                    i = j + 1
                    j = (string.find(
                        buf,
                        "|",
                        math.max(i + 1, 1),
                        true
                    ) or 0) - 1
                    if j < 0 then
                        return nil
                    end
                    if j ~= i then
                        local evs = __TS__StringSplit(
                            __TS__StringSubstring(buf, i, j),
                            ",",
                            6
                        )
                        set.evs = {
                            hp = __TS__Number(evs[1]) or 0,
                            atk = __TS__Number(evs[2]) or 0,
                            def = __TS__Number(evs[3]) or 0,
                            spa = __TS__Number(evs[4]) or 0,
                            spd = __TS__Number(evs[5]) or 0,
                            spe = __TS__Number(evs[6]) or 0
                        }
                    end
                    i = j + 1
                    j = (string.find(
                        buf,
                        "|",
                        math.max(i + 1, 1),
                        true
                    ) or 0) - 1
                    if j < 0 then
                        return nil
                    end
                    if i ~= j then
                        set.gender = __TS__StringSubstring(buf, i, j)
                    end
                    i = j + 1
                    j = (string.find(
                        buf,
                        "|",
                        math.max(i + 1, 1),
                        true
                    ) or 0) - 1
                    if j < 0 then
                        return nil
                    end
                    if j ~= i then
                        local ivs = __TS__StringSplit(
                            __TS__StringSubstring(buf, i, j),
                            ",",
                            6
                        )
                        set.ivs = {
                            hp = ((ivs[1] == "") and 31) or (__TS__Number(ivs[1]) or 0),
                            atk = ((ivs[2] == "") and 31) or (__TS__Number(ivs[2]) or 0),
                            def = ((ivs[3] == "") and 31) or (__TS__Number(ivs[3]) or 0),
                            spa = ((ivs[4] == "") and 31) or (__TS__Number(ivs[4]) or 0),
                            spd = ((ivs[5] == "") and 31) or (__TS__Number(ivs[5]) or 0),
                            spe = ((ivs[6] == "") and 31) or (__TS__Number(ivs[6]) or 0)
                        }
                    end
                    i = j + 1
                    j = (string.find(
                        buf,
                        "|",
                        math.max(i + 1, 1),
                        true
                    ) or 0) - 1
                    if j < 0 then
                        return nil
                    end
                    if i ~= j then
                        set.shiny = true
                    end
                    i = j + 1
                    j = (string.find(
                        buf,
                        "|",
                        math.max(i + 1, 1),
                        true
                    ) or 0) - 1
                    if j < 0 then
                        return nil
                    end
                    if i ~= j then
                        set.level = __TS__ParseInt(
                            __TS__StringSubstring(buf, i, j)
                        )
                    end
                    i = j + 1
                    j = (string.find(
                        buf,
                        "]",
                        math.max(i + 1, 1),
                        true
                    ) or 0) - 1
                    local misc
                    if j < 0 then
                        if i < #buf then
                            misc = __TS__StringSplit(
                                __TS__StringSubstring(buf, i),
                                ",",
                                4
                            )
                        end
                    else
                        if i ~= j then
                            misc = __TS__StringSplit(
                                __TS__StringSubstring(buf, i, j),
                                ",",
                                4
                            )
                        end
                    end
                    if misc then
                        set.happiness = ((misc[0] and (function() return __TS__Number(misc[0]) end)) or (function() return 255 end))()
                        set.hpType = misc[1] or ""
                        set.pokeball = self:unpackName(misc[2] or "", Dex.items)
                        set.gigantamax = not (not misc[3])
                    end
                    if j < 0 then
                        break
                    end
                    i = j + 1
                    count = count + 1
                end
            end
            return team
        end
        function Teams.prototype.packName(self, name)
            if not name then
                return ""
            end
            return __TS__StringReplace(name, nil, "")
        end
        function Teams.prototype.unpackName(self, name, dexTable)
            if not name then
                return ""
            end
            if dexTable then
                local obj = dexTable:get(name)
                if obj.exists then
                    return obj.name
                end
            end
            return __TS__StringTrim(
                __TS__StringReplace(
                    __TS__StringReplace(
                        __TS__StringReplace(name, nil, " $1 "),
                        nil,
                        " $1"
                    ),
                    nil,
                    " "
                )
            )
        end
        function Teams.prototype.export(self, team, options)
            local output = ""
            for ____, set in ipairs(team) do
                output = tostring(output) .. (tostring(
                    self:exportSet(set, options)
                ) .. "\n")
            end
            return output
        end
        function Teams.prototype.exportSet(self, set, ____bindingPattern0)
            if ____bindingPattern0 == nil then
                ____bindingPattern0 = {}
            end
            local hideStats
            hideStats = ____bindingPattern0.hideStats
            local out = ""
            if set.name and (set.name ~= set.species) then
                out = tostring(out) .. (((set.name .. " (") .. set.species) .. ")")
            else
                out = tostring(out) .. tostring(set.species)
            end
            if set.gender == "M" then
                out = tostring(out) .. " (M)"
            end
            if set.gender == "F" then
                out = tostring(out) .. " (F)"
            end
            if set.item then
                out = tostring(out) .. (" @ " .. set.item)
            end
            out = tostring(out) .. "  \n"
            if set.ability then
                out = tostring(out) .. (("Ability: " .. set.ability) .. "  \n")
            end
            if set.level and (set.level ~= 100) then
                out = tostring(out) .. (("Level: " .. tostring(set.level)) .. "  \n")
            end
            if set.shiny then
                out = tostring(out) .. "Shiny: Yes  \n"
            end
            if ((type(set.happiness) == "number") and (set.happiness ~= 255)) and (not __TS__NumberIsNaN(
                __TS__Number(set.happiness)
            )) then
                out = tostring(out) .. (("Happiness: " .. tostring(set.happiness)) .. "  \n")
            end
            if set.pokeball then
                out = tostring(out) .. (("Pokeball: " .. set.pokeball) .. "  \n")
            end
            if set.hpType then
                out = tostring(out) .. (("Hidden Power: " .. set.hpType) .. "  \n")
            end
            if set.gigantamax then
                out = tostring(out) .. "Gigantamax: Yes  \n"
            end
            if not hideStats then
                if set.evs then
                    local stats = __TS__ArrayFilter(
                        __TS__ArrayMap(
                            Dex.stats:ids(),
                            function(____, stat) return ((set.evs[stat] and (function() return (tostring(set.evs[stat]) .. " ") .. Dex.stats.shortNames[stat] end)) or (function() return "" end))() end
                        ),
                        Boolean
                    )
                    if #stats then
                        out = tostring(out) .. (("EVs: " .. table.concat(stats, " / " or ",")) .. "  \n")
                    end
                end
                if set.nature then
                    out = tostring(out) .. (set.nature .. " Nature  \n")
                end
                if set.ivs then
                    local stats = __TS__ArrayFilter(
                        __TS__ArrayMap(
                            Dex.stats:ids(),
                            function(____, stat) return ((((set.ivs[stat] ~= 31) and (set.ivs[stat] ~= nil)) and (function() return (tostring(set.ivs[stat] or 0) .. " ") .. Dex.stats.shortNames[stat] end)) or (function() return "" end))() end
                        ),
                        Boolean
                    )
                    if #stats then
                        out = tostring(out) .. (("IVs: " .. table.concat(stats, " / " or ",")) .. "  \n")
                    end
                end
            end
            for ____, move in ipairs(set.moves) do
                if move:startsWith("Hidden Power ") and (string.sub(move, 14, 14) ~= "[") then
                    move = ("Hidden Power [" .. string.sub(move, 14)) .. "]"
                end
                out = tostring(out) .. (("- " .. move) .. "  \n")
            end
            return out
        end
        function Teams.prototype.parseExportedTeamLine(self, line, isFirstLine, set)
            if isFirstLine then
                local item
                line, item = __TS__Unpack(
                    __TS__StringSplit(line, " @ ")
                )
                if item then
                    set.item = item
                    if toID(_G, set.item) == "noitem" then
                        set.item = ""
                    end
                end
                if line:endsWith(" (M)") then
                    set.gender = "M"
                    line = string.sub(line, 1, -5)
                end
                if line:endsWith(" (F)") then
                    set.gender = "F"
                    line = string.sub(line, 1, -5)
                end
                if line:endsWith(")") and line:includes("(") then
                    local name, species = __TS__Unpack(
                        __TS__StringSplit(
                            string.sub(line, 1, -2),
                            "("
                        )
                    )
                    set.species = Dex.species:get(species).name
                    set.name = __TS__StringTrim(name)
                else
                    set.species = Dex.species:get(line).name
                    set.name = ""
                end
            elseif line:startsWith("Trait: ") then
                line = string.sub(line, 8)
                set.ability = line
            elseif line:startsWith("Ability: ") then
                line = string.sub(line, 10)
                set.ability = line
            elseif line == "Shiny: Yes" then
                set.shiny = true
            elseif line:startsWith("Level: ") then
                line = string.sub(line, 8)
                set.level = line
            elseif line:startsWith("Happiness: ") then
                line = string.sub(line, 12)
                set.happiness = line
            elseif line:startsWith("Pokeball: ") then
                line = string.sub(line, 11)
                set.pokeball = line
            elseif line:startsWith("Hidden Power: ") then
                line = string.sub(line, 15)
                set.hpType = line
            elseif line == "Gigantamax: Yes" then
                set.gigantamax = true
            elseif line:startsWith("EVs: ") then
                line = string.sub(line, 6)
                local evLines = __TS__StringSplit(line, "/")
                set.evs = {hp = 0, atk = 0, def = 0, spa = 0, spd = 0, spe = 0}
                for ____, evLine in ipairs(evLines) do
                    do
                        local statValue, statName = __TS__Unpack(
                            __TS__StringSplit(
                                __TS__StringTrim(evLine),
                                " "
                            )
                        )
                        local statid = Dex.stats:getID(statName)
                        if not statid then
                            goto __continue100
                        end
                        local value = __TS__ParseInt(statValue)
                        set.evs[statid] = value
                    end
                    ::__continue100::
                end
            elseif line:startsWith("IVs: ") then
                line = string.sub(line, 6)
                local ivLines = __TS__StringSplit(line, "/")
                set.ivs = {hp = 31, atk = 31, def = 31, spa = 31, spd = 31, spe = 31}
                for ____, ivLine in ipairs(ivLines) do
                    do
                        local statValue, statName = __TS__Unpack(
                            __TS__StringSplit(
                                __TS__StringTrim(ivLine),
                                " "
                            )
                        )
                        local statid = Dex.stats:getID(statName)
                        if not statid then
                            goto __continue103
                        end
                        local value = __TS__ParseInt(statValue)
                        if __TS__NumberIsNaN(
                            __TS__Number(value)
                        ) then
                            value = 31
                        end
                        set.ivs[statid] = value
                    end
                    ::__continue103::
                end
            elseif nil:test(line) then
                local natureIndex = (string.find(line, " Nature", nil, true) or 0) - 1
                if natureIndex == -1 then
                    natureIndex = (string.find(line, " nature", nil, true) or 0) - 1
                end
                if natureIndex == -1 then
                    return
                end
                line = __TS__StringSubstr(line, 0, natureIndex)
                if line ~= "undefined" then
                    set.nature = line
                end
            elseif line:startsWith("-") or line:startsWith("~") then
                line = __TS__StringSlice(
                    line,
                    ((string.sub(line, 2, 2) == " ") and 2) or 1
                )
                if line:startsWith("Hidden Power [") then
                    local hpType = string.sub(line, 15, -2)
                    line = "Hidden Power " .. tostring(hpType)
                    if (not set.ivs) and Dex.types:isName(hpType) then
                        set.ivs = {hp = 31, atk = 31, def = 31, spa = 31, spd = 31, spe = 31}
                        local hpIVs = Dex.types:get(hpType).HPivs or ({})
                        for statid in pairs(hpIVs) do
                            set.ivs[statid] = hpIVs[statid]
                        end
                    end
                end
                if (line == "Frustration") and (set.happiness == nil) then
                    set.happiness = 0
                end
                __TS__ArrayPush(set.moves, line)
            end
        end
        function Teams.prototype.import(self, buffer)
            if buffer:startsWith("[") then
                do
                    local ____try, ____returned, ____returnValue = pcall(
                        function()
                            local team = JSON:parse(buffer)
                            if not __TS__ArrayIsArray(team) then
                                error(
                                    __TS__New(Error, "Team should be an Array but isn't"),
                                    0
                                )
                            end
                            for ____, set in ipairs(team) do
                                set.name = Dex:getName(set.name)
                                set.species = Dex:getName(set.species)
                                set.item = Dex:getName(set.item)
                                set.ability = Dex:getName(set.ability)
                                set.gender = Dex:getName(set.gender)
                                set.nature = Dex:getName(set.nature)
                                local evs = {hp = 0, atk = 0, def = 0, spa = 0, spd = 0, spe = 0}
                                if set.evs then
                                    for statid in pairs(evs) do
                                        if type(set.evs[statid]) == "number" then
                                            evs[statid] = set.evs[statid]
                                        end
                                    end
                                end
                                set.evs = evs
                                local ivs = {hp = 31, atk = 31, def = 31, spa = 31, spd = 31, spe = 31}
                                if set.ivs then
                                    for statid in pairs(ivs) do
                                        if type(set.ivs[statid]) == "number" then
                                            ivs[statid] = set.ivs[statid]
                                        end
                                    end
                                end
                                set.ivs = ivs
                                if not __TS__ArrayIsArray(set.moves) then
                                    set.moves = {}
                                else
                                    set.moves = set.moves:map(Dex.getName)
                                end
                            end
                            return true, team
                        end
                    )
                    if ____try and ____returned then
                        return ____returnValue
                    end
                end
            end
            local lines = __TS__StringSplit(buffer, "\n")
            local sets = {}
            local curSet = nil
            while #lines and (not lines[1]) do
                __TS__ArrayShift(lines)
            end
            while #lines and (not lines[#lines]) do
                table.remove(lines)
            end
            if (#lines == 1) and lines[1]:includes("|") then
                return self:unpack(lines[1])
            end
            for ____, line in ipairs(lines) do
                line = __TS__StringTrim(line)
                if (line == "") or (line == "---") then
                    curSet = nil
                elseif line:startsWith("===") then
                elseif not curSet then
                    curSet = {name = "", species = "", item = "", ability = "", gender = "", nature = "", evs = {hp = 0, atk = 0, def = 0, spa = 0, spd = 0, spe = 0}, ivs = {hp = 31, atk = 31, def = 31, spa = 31, spd = 31, spe = 31}, level = 100, moves = {}}
                    __TS__ArrayPush(sets, curSet)
                    self:parseExportedTeamLine(line, true, curSet)
                else
                    self:parseExportedTeamLine(line, false, curSet)
                end
            end
            return sets
        end
        function Teams.prototype.getGenerator(self, format, seed)
            if seed == nil then
                seed = nil
            end
            local TeamGenerator = require(
                _G,
                tostring(
                    Dex:forFormat(format).dataDir
                ) .. "/random-teams"
            ).default
            return __TS__New(TeamGenerator, format, seed)
        end
        function Teams.prototype.generate(self, format, options)
            if options == nil then
                options = nil
            end
            return self:getGenerator(format, options.seed):getTeam(options)
        end
        return Teams
    end)(),
    true
)
____exports.default = ____exports.Teams
return ____exports
