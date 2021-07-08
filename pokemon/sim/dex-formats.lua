--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____lib = require("lib/index")
local Utils = ____lib.Utils
local ____dex_2Ddata = require("sim/dex-data")
local toID = ____dex_2Ddata.toID
local BasicEffect = ____dex_2Ddata.BasicEffect
local ____tags = require("data/tags")
local Tags = ____tags.Tags
local DEFAULT_MOD = "gen8"
local MAIN_FORMATS = tostring(__dirname) .. "/../.config-dist/formats"
local CUSTOM_FORMATS = tostring(__dirname) .. "/../.config-dist/custom-formats"
____exports.RuleTable = __TS__Class()
local RuleTable = ____exports.RuleTable
RuleTable.name = "RuleTable"
__TS__ClassExtends(RuleTable, Map)
function RuleTable.prototype.____constructor(self)
    RuleTable.____super.prototype.____constructor(self)
    self.complexBans = {}
    self.complexTeamBans = {}
    self.checkCanLearn = nil
    self.timer = nil
    self.tagRules = {}
    self.valueRules = __TS__New(Map)
end
function RuleTable.prototype.isBanned(self, thing)
    if self:has("+" .. thing) then
        return false
    end
    return self:has("-" .. thing)
end
function RuleTable.prototype.isBannedSpecies(self, species)
    if self:has(
        "+pokemon:" .. tostring(species.id)
    ) then
        return false
    end
    if self:has(
        "-pokemon:" .. tostring(species.id)
    ) then
        return true
    end
    if self:has(
        "+basepokemon:" .. tostring(
            toID(_G, species.baseSpecies)
        )
    ) then
        return false
    end
    if self:has(
        "-basepokemon:" .. tostring(
            toID(_G, species.baseSpecies)
        )
    ) then
        return true
    end
    for tagid in pairs(Tags) do
        local tag = Tags[tagid]
        if self:has("-pokemontag:" .. tagid) then
            if (tag.speciesFilter or tag.genericFilter)(_G, species) then
                return true
            end
        end
    end
    for tagid in pairs(Tags) do
        local tag = Tags[tagid]
        if self:has("+pokemontag:" .. tagid) then
            if (tag.speciesFilter or tag.genericFilter)(_G, species) then
                return false
            end
        end
    end
    return self:has("-pokemontag:allpokemon")
end
function RuleTable.prototype.isRestricted(self, thing)
    if self:has("+" .. thing) then
        return false
    end
    return self:has("*" .. thing)
end
function RuleTable.prototype.isRestrictedSpecies(self, species)
    if self:has(
        "+pokemon:" .. tostring(species.id)
    ) then
        return false
    end
    if self:has(
        "*pokemon:" .. tostring(species.id)
    ) then
        return true
    end
    if self:has(
        "+basepokemon:" .. tostring(
            toID(_G, species.baseSpecies)
        )
    ) then
        return false
    end
    if self:has(
        "*basepokemon:" .. tostring(
            toID(_G, species.baseSpecies)
        )
    ) then
        return true
    end
    for tagid in pairs(Tags) do
        local tag = Tags[tagid]
        if self:has("*pokemontag:" .. tagid) then
            if (tag.speciesFilter or tag.genericFilter)(_G, species) then
                return true
            end
        end
    end
    for tagid in pairs(Tags) do
        local tag = Tags[tagid]
        if self:has("+pokemontag:" .. tagid) then
            if (tag.speciesFilter or tag.genericFilter)(_G, species) then
                return false
            end
        end
    end
    return self:has("*pokemontag:allpokemon")
end
function RuleTable.prototype.getTagRules(self)
    local tagRules = {}
    for ____, ruleid in __TS__Iterator(
        self:keys()
    ) do
        if test(ruleid) then -- was nil:test() ...
            local banid = ruleid:slice(12)
            if ((((banid == "allpokemon") or (banid == "allitems")) or (banid == "allmoves")) or (banid == "allabilities")) or (banid == "allnatures") then
            else
                __TS__ArrayPush(tagRules, ruleid)
            end
        elseif ("+*-"):includes(
            ruleid:charAt(0)
        ) and (ruleid:slice(1) == "nonexistent") then
            __TS__ArrayPush(
                tagRules,
                tostring(
                    ruleid:charAt(0)
                ) .. "pokemontag:nonexistent"
            )
        end
    end
    self.tagRules = __TS__ArrayReverse(tagRules)
    return self.tagRules
end
function RuleTable.prototype.check(self, thing, setHas)
    if setHas == nil then
        setHas = nil
    end
    if self:has("+" .. thing) then
        return ""
    end
    if setHas then
        setHas[thing] = true
    end
    return self:getReason("-" .. thing)
end
function RuleTable.prototype.getReason(self, key)
    local source = self:get(key)
    if source == nil then
        return nil
    end
    if (key == "-nonexistent") or key:startsWith("obtainable") then
        return "not obtainable"
    end
    return ((source and (function() return "banned by " .. tostring(source) end)) or (function() return "banned" end))()
end
function RuleTable.prototype.blame(self, key)
    local source = self:get(key)
    return ((source and (function() return " from " .. tostring(source) end)) or (function() return "" end))()
end
function RuleTable.prototype.getComplexBanIndex(self, complexBans, rule)
    local ruleId = toID(_G, rule)
    local complexBanIndex = -1
    do
        local i = 0
        while i < #complexBans do
            if toID(_G, complexBans[i + 1][1]) == ruleId then
                complexBanIndex = i
                break
            end
            i = i + 1
        end
    end
    return complexBanIndex
end
function RuleTable.prototype.addComplexBan(self, rule, source, limit, bans)
    local complexBanIndex = self:getComplexBanIndex(self.complexBans, rule)
    if complexBanIndex ~= -1 then
        if self.complexBans[complexBanIndex + 1][3] == math.huge then
            return
        end
        self.complexBans[complexBanIndex + 1] = {rule, source, limit, bans}
    else
        __TS__ArrayPush(self.complexBans, {rule, source, limit, bans})
    end
end
function RuleTable.prototype.addComplexTeamBan(self, rule, source, limit, bans)
    local complexBanTeamIndex = self:getComplexBanIndex(self.complexTeamBans, rule)
    if complexBanTeamIndex ~= -1 then
        if self.complexTeamBans[complexBanTeamIndex + 1][3] == math.huge then
            return
        end
        self.complexTeamBans[complexBanTeamIndex + 1] = {rule, source, limit, bans}
    else
        __TS__ArrayPush(self.complexTeamBans, {rule, source, limit, bans})
    end
end
function RuleTable.prototype.resolveNumbers(self, format, dex)
    local gameTypeMinTeamSize = (({"triples", "rotation"}):includes(format.gameType) and 3) or (((format.gameType == "doubles") and 2) or 1)
    self.minTeamSize = __TS__Number(
        self.valueRules:get("minteamsize")
    ) or 0
    self.maxTeamSize = __TS__Number(
        self.valueRules:get("maxteamsize")
    ) or 6
    self.pickedTeamSize = __TS__Number(
        self.valueRules:get("pickedteamsize")
    ) or nil
    self.maxTotalLevel = __TS__Number(
        self.valueRules:get("maxtotallevel")
    ) or nil
    self.maxMoveCount = __TS__Number(
        self.valueRules:get("maxmovecount")
    ) or 4
    self.minSourceGen = __TS__Number(
        self.valueRules:get("minsourcegen")
    ) or 1
    self.minLevel = __TS__Number(
        self.valueRules:get("minlevel")
    ) or 1
    self.maxLevel = __TS__Number(
        self.valueRules:get("maxlevel")
    ) or 100
    self.defaultLevel = __TS__Number(
        self.valueRules:get("defaultlevel")
    ) or 0
    self.adjustLevel = __TS__Number(
        self.valueRules:get("adjustlevel")
    ) or nil
    self.adjustLevelDown = __TS__Number(
        self.valueRules:get("adjustleveldown")
    ) or nil
    self.evLimit = __TS__Number(
        self.valueRules:get("evlimit")
    ) or nil
    if self.valueRules:get("pickedteamsize") == "Auto" then
        self.pickedTeamSize = (({"doubles", "rotation"}):includes(format.gameType) and 4) or (((format.gameType == "triples") and 6) or 3)
    end
    if self.valueRules:get("evlimit") == "Auto" then
        self.evLimit = ((dex.gen > 2) and 510) or nil
        if format.mod == "gen7letsgo" then
            self.evLimit = ((self:has("allowavs") and (function() return nil end)) or (function() return 0 end))()
        end
    end
    if self.maxTeamSize > 24 then
        error(
            __TS__New(
                Error,
                (("Max team size " .. tostring(self.maxTeamSize)) .. self:blame("maxteamsize")) .. " is unsupported (we only support up to 24)."
            ),
            0
        )
    end
    if self.maxLevel > 99999 then
        error(
            __TS__New(
                Error,
                (("Max level " .. tostring(self.maxLevel)) .. self:blame("maxlevel")) .. " is unsupported (we only support up to 99999)"
            ),
            0
        )
    end
    if self.maxMoveCount > 24 then
        error(
            __TS__New(
                Error,
                (("Max move count " .. tostring(self.maxMoveCount)) .. self:blame("maxmovecount")) .. " is unsupported (we only support up to 24)"
            ),
            0
        )
    end
    if not self.defaultLevel then
        local maxTeamSize = self.pickedTeamSize or self.maxTeamSize
        if (self.maxTotalLevel and (self.maxLevel > 100)) and ((self.maxLevel * maxTeamSize) > self.maxTotalLevel) then
            self.defaultLevel = 100
        else
            self.defaultLevel = self.maxLevel
        end
    end
    if self.minTeamSize and (self.minTeamSize < gameTypeMinTeamSize) then
        error(
            __TS__New(
                Error,
                (((((("Min team size " .. tostring(self.minTeamSize)) .. self:blame("minteamsize")) .. " must be at least ") .. tostring(gameTypeMinTeamSize)) .. " for a ") .. tostring(format.gameType)) .. " game."
            ),
            0
        )
    end
    if self.pickedTeamSize and (self.pickedTeamSize < gameTypeMinTeamSize) then
        error(
            __TS__New(
                Error,
                (((((("Chosen team size " .. tostring(self.pickedTeamSize)) .. self:blame("pickedteamsize")) .. " must be at least ") .. tostring(gameTypeMinTeamSize)) .. " for a ") .. tostring(format.gameType)) .. " game."
            ),
            0
        )
    end
    if (self.minTeamSize and self.pickedTeamSize) and (self.minTeamSize < self.pickedTeamSize) then
        error(
            __TS__New(
                Error,
                ((((("Min team size " .. tostring(self.minTeamSize)) .. self:blame("minteamsize")) .. " is lower than chosen team size ") .. tostring(self.pickedTeamSize)) .. self:blame("pickedteamsize")) .. "."
            ),
            0
        )
    end
    if not self.minTeamSize then
        self.minTeamSize = math.max(gameTypeMinTeamSize, self.pickedTeamSize or 0)
    end
    if self.maxTeamSize < gameTypeMinTeamSize then
        error(
            __TS__New(
                Error,
                (((((("Max team size " .. tostring(self.maxTeamSize)) .. self:blame("maxteamsize")) .. " must be at least ") .. tostring(gameTypeMinTeamSize)) .. " for a ") .. tostring(format.gameType)) .. " game."
            ),
            0
        )
    end
    if self.maxTeamSize < self.minTeamSize then
        error(
            __TS__New(
                Error,
                ((((("Max team size " .. tostring(self.maxTeamSize)) .. self:blame("maxteamsize")) .. " must be at least min team size ") .. tostring(self.minTeamSize)) .. self:blame("minteamsize")) .. "."
            ),
            0
        )
    end
    if self.minLevel > self.maxLevel then
        error(
            __TS__New(
                Error,
                ((((("Min level " .. tostring(self.minLevel)) .. self:blame("minlevel")) .. " should not be above max level ") .. tostring(self.maxLevel)) .. self:blame("maxlevel")) .. "."
            ),
            0
        )
    end
    if self.defaultLevel > self.maxLevel then
        error(
            __TS__New(
                Error,
                ((((("Default level " .. tostring(self.defaultLevel)) .. self:blame("defaultlevel")) .. " should not be above max level ") .. tostring(self.maxLevel)) .. self:blame("maxlevel")) .. "."
            ),
            0
        )
    end
    if self.defaultLevel < self.minLevel then
        error(
            __TS__New(
                Error,
                ((((("Default level " .. tostring(self.defaultLevel)) .. self:blame("defaultlevel")) .. " should not be below min level ") .. tostring(self.minLevel)) .. self:blame("minlevel")) .. "."
            ),
            0
        )
    end
    if self.adjustLevelDown and (self.adjustLevelDown >= self.maxLevel) then
        error(
            __TS__New(
                Error,
                ((((("Adjust Level Down " .. tostring(self.adjustLevelDown)) .. self:blame("adjustleveldown")) .. " will have no effect because it's not below max level ") .. tostring(self.maxLevel)) .. self:blame("maxlevel")) .. "."
            ),
            0
        )
    end
    if self.adjustLevel and self.valueRules:has("minlevel") then
        error(
            __TS__New(
                Error,
                ((((("Min Level " .. tostring(self.minLevel)) .. self:blame("minlevel")) .. " will have no effect because you're using Adjust Level ") .. tostring(self.adjustLevel)) .. self:blame("adjustlevel")) .. "."
            ),
            0
        )
    end
    if self.evLimit and (self.evLimit >= 1512) then
        error(
            __TS__New(
                Error,
                (("EV Limit " .. tostring(self.evLimit)) .. self:blame("evlimit")) .. " will have no effect because it's not lower than 1512, the maximum possible combination of 252 EVs in every stat (if you currently have an EV limit, use \"! EV Limit\" to remove the limit)."
            ),
            0
        )
    end
    if self.evLimit and (self.evLimit < 0) then
        error(
            __TS__New(
                Error,
                (("EV Limit " .. tostring(self.evLimit)) .. self:blame("evlimit")) .. " can't be less than 0 (you might have meant: \"! EV Limit\" to remove the limit, or \"EV Limit = 0\" to ban EVs)."
            ),
            0
        )
    end
    if format.cupLevelLimit then
        error(
            __TS__New(Error, "cupLevelLimit.range[0], cupLevelLimit.range[1], cupLevelLimit.total are now rules, respectively: \"Min Level = NUMBER\", \"Max Level = NUMBER\", and \"Max Total Level = NUMBER\""),
            0
        )
    end
    if format.teamLength then
        error(
            __TS__New(Error, "teamLength.validate[0], teamLength.validate[1], teamLength.battle are now rules, respectively: \"Min Team Size = NUMBER\", \"Max Team Size = NUMBER\", and \"Picked Team Size = NUMBER\""),
            0
        )
    end
    if format.minSourceGen then
        error(
            __TS__New(Error, "minSourceGen is now a rule: \"Min Source Gen = NUMBER\""),
            0
        )
    end
    if format.maxLevel then
        error(
            __TS__New(Error, "maxLevel is now a rule: \"Max Level = NUMBER\""),
            0
        )
    end
    if format.defaultLevel then
        error(
            __TS__New(Error, "defaultLevel is now a rule: \"Default Level = NUMBER\""),
            0
        )
    end
    if format.forcedLevel then
        error(
            __TS__New(Error, "forcedLevel is now a rule: \"Adjust Level = NUMBER\""),
            0
        )
    end
    if format.maxForcedLevel then
        error(
            __TS__New(Error, "maxForcedLevel is now a rule: \"Adjust Level Down = NUMBER\""),
            0
        )
    end
end
____exports.Format = __TS__Class()
local Format = ____exports.Format
Format.name = "Format"
__TS__ClassExtends(Format, BasicEffect)
function Format.prototype.____constructor(self, data)
    BasicEffect.prototype.____constructor(self, data)
    data = self
    self.mod = Utils:getString(data.mod) or "gen8"
    self.effectType = Utils:getString(data.effectType) or "Format"
    self.debug = not (not data.debug)
    self.rated = (((type(data.rated) == "string") and (function() return data.rated end)) or (function() return data.rated ~= false end))()
    self.gameType = data.gameType or "singles"
    self.ruleset = data.ruleset or ({})
    self.baseRuleset = data.baseRuleset or ({})
    self.banlist = data.banlist or ({})
    self.restricted = data.restricted or ({})
    self.unbanlist = data.unbanlist or ({})
    self.customRules = data.customRules or nil
    self.ruleTable = nil
    self.onBegin = data.onBegin or nil
    self.noLog = not (not data.noLog)
end
local function mergeFormatLists(self, main, custom)
    local result = {}
    local build = {}
    local current = {section = "", formats = {}}
    for ____, element in ipairs(main) do
        if element.section then
            current = {section = element.section, column = element.column, formats = {}}
            __TS__ArrayPush(build, current)
        elseif element.name then
            __TS__ArrayPush(current.formats, element)
        end
    end
    if custom ~= nil then
        for ____, element in ipairs(custom) do
            if element.section then
                current = build:find(
                    function(____, e) return e.section == element.section end
                )
                if current == nil then
                    current = {section = element.section, column = element.column, formats = {}}
                    __TS__ArrayPush(build, current)
                end
            elseif element.name then
                __TS__ArrayPush(current.formats, element)
            end
        end
    end
    for ____, element in ipairs(build) do
        __TS__ArrayPush(
            result,
            {section = element.section, column = element.column},
            __TS__Unpack(element.formats)
        )
    end
    return result
end
____exports.DexFormats = __TS__Class()
local DexFormats = ____exports.DexFormats
DexFormats.name = "DexFormats"
function DexFormats.prototype.____constructor(self, dex)
    self.rulesetCache = __TS__New(Map)
    self.dex = dex
    self.formatsListCache = nil
end
function DexFormats.prototype.load(self)
    if not self.dex.isBase then
        error(
            __TS__New(Error, "This should only be run on the base mod"),
            0
        )
    end
    self.dex:includeMods()
    if self.formatsListCache then
        return self
    end
    local formatsList = {}
    local customFormats
    do
        local ____try, e = pcall(
            function()
                customFormats = require(_G, CUSTOM_FORMATS).Formats
                if not __TS__ArrayIsArray(customFormats) then
                    error(
                        __TS__New(TypeError, "Exported property 'Formats' from \"./config/custom-formats.ts\" must be an array"),
                        0
                    )
                end
            end
        )
        if not ____try then
            if (e.code ~= "MODULE_NOT_FOUND") and (e.code ~= "ENOENT") then
                error(e, 0)
            end
        end
    end
    local Formats = require(_G, MAIN_FORMATS).Formats
    if not __TS__ArrayIsArray(Formats) then
        error(
            __TS__New(TypeError, "Exported property 'Formats' from \"./config/formats.ts\" must be an array"),
            0
        )
    end
    if customFormats then
        Formats = mergeFormatLists(_G, Formats, customFormats)
    end
    local section = ""
    local column = 1
    for ____, ____value in __TS__Iterator(
        Formats:entries()
    ) do
        local i
        i = ____value[1]
        local format
        format = ____value[2]
        do
            local id = toID(_G, format.name)
            if format.section then
                section = format.section
            end
            if format.column then
                column = format.column
            end
            if (not format.name) and format.section then
                goto __continue105
            end
            if not id then
                error(
                    __TS__New(
                        RangeError,
                        ((("Format #" .. tostring(i + 1)) .. " must have a name with alphanumeric characters, not '") .. tostring(format.name)) .. "'"
                    ),
                    0
                )
            end
            if not format.section then
                format.section = section
            end
            if not format.column then
                format.column = column
            end
            if self.rulesetCache:has(id) then
                error(
                    __TS__New(
                        Error,
                        ((("Format #" .. tostring(i + 1)) .. " has a duplicate ID: '") .. tostring(id)) .. "'"
                    ),
                    0
                )
            end
            format.effectType = "Format"
            format.baseRuleset = ((format.ruleset and (function() return format.ruleset:slice() end)) or (function() return {} end))()
            if format.challengeShow == nil then
                format.challengeShow = true
            end
            if format.searchShow == nil then
                format.searchShow = true
            end
            if format.tournamentShow == nil then
                format.tournamentShow = true
            end
            if format.mod == nil then
                format.mod = "gen8"
            end
            if not self.dex.dexes[format.mod] then
                error(
                    __TS__New(
                        Error,
                        ((("Format \"" .. tostring(format.name)) .. "\" requires nonexistent mod: '") .. tostring(format.mod)) .. "'"
                    ),
                    0
                )
            end
            local ruleset = __TS__New(____exports.Format, format)
            self.rulesetCache:set(id, ruleset)
            __TS__ArrayPush(formatsList, ruleset)
        end
        ::__continue105::
    end
    self.formatsListCache = formatsList
    return self
end
function DexFormats.prototype.validate(self, name)
    local formatName, customRulesString = __TS__Unpack(
        __TS__StringSplit(name, "@@@", 2)
    )
    local format = self:get(formatName)
    if not format.exists then
        error(
            __TS__New(Error, ("Unrecognized format \"" .. formatName) .. "\""),
            0
        )
    end
    if not customRulesString then
        return format.id
    end
    local ruleTable = self:getRuleTable(format)
    local customRules = __TS__ArrayFilter(
        __TS__ArrayMap(
            __TS__StringSplit(customRulesString, ","),
            function(____, rule)
                rule = __TS__StringTrim(
                    __TS__StringReplace(rule, nil, "")
                )
                local ruleSpec = self:validateRule(rule)
                if (type(ruleSpec) == "string") and ruleTable:has(ruleSpec) then
                    return nil
                end
                return rule
            end
        ),
        Boolean
    )
    if not #customRules then
        error(
            __TS__New(Error, "The format already has your custom rules"),
            0
        )
    end
    local validatedFormatid = (tostring(format.id) .. "@@@") .. tostring(
        table.concat(customRules, "," or ",")
    )
    local moddedFormat = self:get(validatedFormatid, true)
    self:getRuleTable(moddedFormat)
    return validatedFormatid
end
function DexFormats.prototype.get(self, name, isTrusted)
    if isTrusted == nil then
        isTrusted = false
    end
    if name and (type(name) ~= "string") then
        return name
    end
    name = (name or ""):trim()
    local id = toID(_G, name)
    if not name:includes("@@@") then
        local ruleset = self.rulesetCache:get(id)
        if ruleset then
            return ruleset
        end
    end
    if rawget(self.dex.data.Aliases, id) ~= nil then
        name = self.dex.data.Aliases[id]
        id = toID(_G, name)
    end
    if rawget(
        self.dex.data.Rulesets,
        tostring(DEFAULT_MOD) .. tostring(id)
    ) ~= nil then
        id = tostring(DEFAULT_MOD) .. tostring(id)
    end
    local supplementaryAttributes = nil
    if name:includes("@@@") then
        if not isTrusted then
            do
                pcall(
                    function()
                        name = self:validate(name)
                        isTrusted = true
                    end
                )
            end
        end
        local newName, customRulesString = __TS__Unpack(
            name:split("@@@", 2)
        )
        name = newName:trim()
        id = toID(_G, name)
        if isTrusted and customRulesString then
            supplementaryAttributes = {
                customRules = customRulesString:split(","),
                searchShow = false
            }
        end
    end
    local effect
    if rawget(self.dex.data.Rulesets, id) ~= nil then
        effect = __TS__New(
            ____exports.Format,
            __TS__ObjectAssign({name = name}, self.dex.data.Rulesets[id], supplementaryAttributes)
        )
    else
        effect = __TS__New(____exports.Format, {id = id, name = name, exists = false})
    end
    return effect
end
function DexFormats.prototype.all(self)
    self:load()
    return self.formatsListCache
end
function DexFormats.prototype.getRuleTable(self, format, depth, repeals)
    if depth == nil then
        depth = 1
    end
    if format.ruleTable and (not repeals) then
        return format.ruleTable
    end
    if depth == 1 then
        local dex = self.dex:mod(format.mod)
        if dex ~= self.dex then
            return dex.formats:getRuleTable(format, 2, repeals)
        end
    end
    local ruleTable = __TS__New(____exports.RuleTable)
    local ruleset = __TS__ArraySlice(format.ruleset)
    for ____, ban in ipairs(format.banlist) do
        __TS__ArrayPush(
            ruleset,
            "-" .. tostring(ban)
        )
    end
    for ____, ban in ipairs(format.restricted) do
        __TS__ArrayPush(
            ruleset,
            "*" .. tostring(ban)
        )
    end
    for ____, ban in ipairs(format.unbanlist) do
        __TS__ArrayPush(
            ruleset,
            "+" .. tostring(ban)
        )
    end
    if format.customRules then
        __TS__ArrayPush(
            ruleset,
            __TS__Unpack(format.customRules)
        )
    end
    if format.checkCanLearn then
        ruleTable.checkCanLearn = {format.checkCanLearn, format.name}
    end
    if format.timer then
        ruleTable.timer = {format.timer, format.name}
    end
    for ____, rule in ipairs(ruleset) do
        if rule:startsWith("!") and (not rule:startsWith("!!")) then
            local ruleSpec = self:validateRule(rule, format)
            if not repeals then
                repeals = __TS__New(Map)
            end
            repeals:set(
                string.sub(ruleSpec, 2),
                depth
            )
        end
    end
    for ____, rule in ipairs(ruleset) do
        do
            local ruleSpec = self:validateRule(rule, format)
            if type(ruleSpec) ~= "string" then
                if ruleSpec[1] == "complexTeamBan" then
                    local complexTeamBan = __TS__ArraySlice(ruleSpec, 1)
                    ruleTable:addComplexTeamBan(complexTeamBan[1], complexTeamBan[2], complexTeamBan[3], complexTeamBan[4])
                elseif ruleSpec[1] == "complexBan" then
                    local complexBan = __TS__ArraySlice(ruleSpec, 1)
                    ruleTable:addComplexBan(complexBan[1], complexBan[2], complexBan[3], complexBan[4])
                else
                    error(
                        __TS__New(
                            Error,
                            "Unrecognized rule spec " .. tostring(ruleSpec)
                        ),
                        0
                    )
                end
                goto __continue150
            end
            if rule:startsWith("!") and (not rule:startsWith("!!")) then
                local repealDepth = repeals:get(
                    string.sub(ruleSpec, 2)
                )
                if repealDepth == nil then
                    error(
                        __TS__New(Error, (("Multiple \"" .. rule) .. "\" rules in ") .. format.name),
                        0
                    )
                end
                if repealDepth == depth then
                    error(
                        __TS__New(
                            Error,
                            ((("Rule \"" .. rule) .. "\" did nothing because \"") .. string.sub(rule, 2)) .. "\" is not in effect"
                        ),
                        0
                    )
                end
                if repealDepth == -depth then
                    repeals:delete(
                        string.sub(ruleSpec, 2)
                    )
                end
                goto __continue150
            end
            if ("+*-"):includes(
                string.sub(ruleSpec, 1, 1)
            ) then
                if ruleTable:has(ruleSpec) then
                    error(
                        __TS__New(
                            Error,
                            ((((("Rule \"" .. rule) .. "\" in \"") .. format.name) .. "\" already exists in \"") .. tostring(
                                ruleTable:get(ruleSpec) or format.name
                            )) .. "\""
                        ),
                        0
                    )
                end
                for ____, prefix in __TS__Iterator("+*-") do
                    ruleTable:delete(
                        tostring(prefix) .. tostring(
                            string.sub(ruleSpec, 2)
                        )
                    )
                end
                ruleTable:set(ruleSpec, "")
                goto __continue150
            end
            local formatid, value = __TS__Unpack(
                __TS__StringSplit(ruleSpec, "=")
            )
            local subformat = self:get(formatid)
            local repealAndReplace = ruleSpec:startsWith("!!")
            if repeals:has(subformat.id) then
                repeals:set(
                    subformat.id,
                    -math.abs(
                        repeals:get(subformat.id)
                    )
                )
                goto __continue150
            end
            if subformat.hasValue then
                if value == nil then
                    error(
                        __TS__New(Error, ((("Rule \"" .. ruleSpec) .. "\" should have a value (like \"") .. ruleSpec) .. " = something\")"),
                        0
                    )
                end
                if value == "Current Gen" then
                    value = tostring(self.dex.gen)
                end
                if ((subformat.id == "pickedteamsize") or (subformat.id == "evlimit")) and (value == "Auto") then
                elseif (subformat.hasValue == "integer") or (subformat.hasValue == "positive-integer") then
                    local intValue = __TS__ParseInt(value)
                    if __TS__NumberIsNaN(
                        __TS__Number(intValue)
                    ) or (value ~= tostring(intValue)) then
                        error(
                            __TS__New(Error, ((("In rule \"" .. ruleSpec) .. "\", \"") .. value) .. "\" must be an integer number."),
                            0
                        )
                    end
                end
                if subformat.hasValue == "positive-integer" then
                    if __TS__ParseInt(value) == 0 then
                        error(
                            __TS__New(Error, ((((("In rule \"" .. ruleSpec) .. "\", \"") .. value) .. "\" must be positive (to remove it, use the rule \"! ") .. subformat.name) .. "\")."),
                            0
                        )
                    end
                    if __TS__ParseInt(value) <= 0 then
                        error(
                            __TS__New(Error, ((("In rule \"" .. ruleSpec) .. "\", \"") .. value) .. "\" must be positive."),
                            0
                        )
                    end
                end
                local oldValue = ruleTable.valueRules:get(subformat.id)
                if oldValue == value then
                    error(
                        __TS__New(
                            Error,
                            ((((((("Rule \"" .. ruleSpec) .. "\" is redundant with existing rule \"") .. tostring(subformat.id)) .. "=") .. value) .. "\"") .. ruleTable:blame(subformat.id)) .. "."
                        ),
                        0
                    )
                elseif repealAndReplace then
                    if oldValue == nil then
                        if subformat.mutuallyExclusiveWith and ruleTable.valueRules:has(subformat.mutuallyExclusiveWith) then
                            if self.dex.formats:get(subformat.mutuallyExclusiveWith).ruleset.length then
                                error(
                                    __TS__New(Error, "This format does not support \"!!\""),
                                    0
                                )
                            end
                            ruleTable.valueRules:delete(subformat.mutuallyExclusiveWith)
                            ruleTable:delete(subformat.mutuallyExclusiveWith)
                        else
                            error(
                                __TS__New(Error, ("Rule \"" .. ruleSpec) .. "\" is not replacing anything (it should not have \"!!\")"),
                                0
                            )
                        end
                    end
                else
                    if oldValue ~= nil then
                        error(
                            __TS__New(
                                Error,
                                ((((((((((((("Rule \"" .. ruleSpec) .. "\" conflicts with \"") .. tostring(subformat.id)) .. "=") .. tostring(oldValue)) .. "\"") .. ruleTable:blame(subformat.id)) .. " (Use \"!! ") .. ruleSpec) .. "\" to override \"") .. tostring(subformat.id)) .. "=") .. tostring(oldValue)) .. "\".)"
                            ),
                            0
                        )
                    end
                    if subformat.mutuallyExclusiveWith and ruleTable.valueRules:has(subformat.mutuallyExclusiveWith) then
                        local oldRule = ((("\"" .. subformat.mutuallyExclusiveWith) .. "=") .. tostring(
                            ruleTable.valueRules:get(subformat.mutuallyExclusiveWith)
                        )) .. "\""
                        error(
                            __TS__New(
                                Error,
                                (((((((("Format can't simultaneously have \"" .. ruleSpec) .. "\" and ") .. oldRule) .. ruleTable:blame(subformat.mutuallyExclusiveWith)) .. " (Use \"!! ") .. ruleSpec) .. "\" to override ") .. oldRule) .. ".)"
                            ),
                            0
                        )
                    end
                end
                ruleTable.valueRules:set(subformat.id, value)
            else
                if value ~= nil then
                    error(
                        __TS__New(Error, ("Rule \"" .. ruleSpec) .. "\" should not have a value (no equals sign)"),
                        0
                    )
                end
                if repealAndReplace then
                    error(
                        __TS__New(Error, "\"!!\" is not supported for this rule"),
                        0
                    )
                end
                if ruleTable:has(subformat.id) and (not repealAndReplace) then
                    error(
                        __TS__New(
                            Error,
                            ((((("Rule \"" .. rule) .. "\" in \"") .. format.name) .. "\" already exists in \"") .. tostring(
                                ruleTable:get(subformat.id) or format.name
                            )) .. "\""
                        ),
                        0
                    )
                end
            end
            ruleTable:set(subformat.id, "")
            if depth > 16 then
                error(
                    __TS__New(
                        Error,
                        (((("Excessive ruleTable recursion in " .. format.name) .. ": ") .. ruleSpec) .. " of ") .. tostring(format.ruleset)
                    ),
                    0
                )
            end
            local subRuleTable = self:getRuleTable(subformat, depth + 1, repeals)
            for ____, ____value in __TS__Iterator(subRuleTable) do
                local ruleid
                ruleid = ____value[1]
                local sourceFormat
                sourceFormat = ____value[2]
                if not repeals:has(ruleid) then
                    local newValue = subRuleTable.valueRules:get(ruleid)
                    local oldValue = ruleTable.valueRules:get(ruleid)
                    if newValue ~= nil then
                        local subSubFormat = self:get(ruleid)
                        if subSubFormat.mutuallyExclusiveWith and ruleTable.valueRules:has(subSubFormat.mutuallyExclusiveWith) then
                            error(
                                __TS__New(
                                    Error,
                                    (((((((((((("Rule \"" .. tostring(ruleid)) .. "=") .. tostring(newValue)) .. "\" from ") .. subformat.name) .. subRuleTable:blame(ruleid)) .. " conflicts with \"") .. subSubFormat.mutuallyExclusiveWith) .. "=") .. tostring(
                                        ruleTable.valueRules:get(subSubFormat.mutuallyExclusiveWith)
                                    )) .. "\"") .. ruleTable:blame(subSubFormat.mutuallyExclusiveWith)) .. " (Repeal one with ! before adding another)"
                                ),
                                0
                            )
                        end
                        if newValue ~= oldValue then
                            if oldValue ~= nil then
                                error(
                                    __TS__New(
                                        Error,
                                        (((((((((((("Rule \"" .. tostring(ruleid)) .. "=") .. tostring(newValue)) .. "\" from ") .. subformat.name) .. subRuleTable:blame(ruleid)) .. " conflicts with \"") .. tostring(ruleid)) .. "=") .. tostring(oldValue)) .. "\"") .. ruleTable:blame(ruleid)) .. " (Repeal one with ! before adding another)"
                                    ),
                                    0
                                )
                            end
                            ruleTable.valueRules:set(ruleid, newValue)
                        end
                    end
                    ruleTable:set(ruleid, sourceFormat or subformat.name)
                end
            end
            for ____, ____value in ipairs(subRuleTable.complexBans) do
                local subRule
                subRule = ____value[1]
                local source
                source = ____value[2]
                local limit
                limit = ____value[3]
                local bans
                bans = ____value[4]
                ruleTable:addComplexBan(subRule, source or subformat.name, limit, bans)
            end
            for ____, ____value in ipairs(subRuleTable.complexTeamBans) do
                local subRule
                subRule = ____value[1]
                local source
                source = ____value[2]
                local limit
                limit = ____value[3]
                local bans
                bans = ____value[4]
                ruleTable:addComplexTeamBan(subRule, source or subformat.name, limit, bans)
            end
            if subRuleTable.checkCanLearn then
                if ruleTable.checkCanLearn then
                    error(
                        __TS__New(Error, (("\"" .. format.name) .. "\" has conflicting move validation rules from ") .. (((("\"" .. ruleTable.checkCanLearn[2]) .. "\" and \"") .. subRuleTable.checkCanLearn[2]) .. "\"")),
                        0
                    )
                end
                ruleTable.checkCanLearn = subRuleTable.checkCanLearn
            end
            if subRuleTable.timer then
                if ruleTable.timer then
                    error(
                        __TS__New(Error, ((((("\"" .. format.name) .. "\" has conflicting timer validation rules from \"") .. ruleTable.timer[2]) .. "\" and \"") .. subRuleTable.timer[2]) .. "\""),
                        0
                    )
                end
                ruleTable.timer = subRuleTable.timer
            end
        end
        ::__continue150::
    end
    ruleTable:getTagRules()
    ruleTable:resolveNumbers(format, self.dex)
    for ____, rule in __TS__Iterator(
        ruleTable:keys()
    ) do
        do
            if ("+*-!"):includes(
                rule:charAt(0)
            ) then
                goto __continue198
            end
            local subFormat = self.dex.formats:get(rule)
            if subFormat.exists then
                local value = subFormat.onValidateRule:call(
                    {format = format, ruleTable = ruleTable, dex = self.dex},
                    ruleTable.valueRules:get(rule)
                )
                if type(value) == "string" then
                    ruleTable.valueRules:set(subFormat.id, value)
                end
            end
        end
        ::__continue198::
    end
    if not repeals then
        format.ruleTable = ruleTable
    end
    return ruleTable
end
function DexFormats.prototype.validateRule(self, rule, format)
    if format == nil then
        format = nil
    end
    if rule ~= __TS__StringTrim(rule) then
        error(
            __TS__New(Error, ("Rule \"" .. rule) .. "\" should be trimmed"),
            0
        )
    end
    local ____switch205 = string.sub(rule, 1, 1)
    local ruleName, value, id, ruleset
    if ____switch205 == "-" then
        goto ____switch205_case_0
    elseif ____switch205 == "*" then
        goto ____switch205_case_1
    elseif ____switch205 == "+" then
        goto ____switch205_case_2
    end
    goto ____switch205_case_default
    ::____switch205_case_0::
    do
    end
    ::____switch205_case_1::
    do
    end
    ::____switch205_case_2::
    do
        if format.team then
            error(
                __TS__New(Error, "We don't currently support bans in generated teams"),
                0
            )
        end
        if string.sub(rule, 2):includes(">") or string.sub(rule, 2):includes("+") then
            local buf = string.sub(rule, 2)
            local gtIndex = buf:lastIndexOf(">")
            local limit = ((rule:startsWith("+") and (function() return math.huge end)) or (function() return 0 end))()
            if (gtIndex >= 0) and test( -- was nil:test() ...
                __TS__StringTrim(
                    __TS__StringSlice(buf, gtIndex + 1)
                )
            ) then
                if limit == 0 then
                    limit = __TS__ParseInt(
                        __TS__StringSlice(buf, gtIndex + 1)
                    )
                end
                buf = __TS__StringSlice(buf, 0, gtIndex)
            end
            local checkTeam = buf:includes("++")
            local banNames = __TS__ArrayMap(
                __TS__StringSplit(buf, (checkTeam and "++") or "+"),
                function(____, v) return __TS__StringTrim(v) end
            )
            if (#banNames == 1) and (limit > 0) then
                checkTeam = true
            end
            local innerRule = table.concat(banNames, ((checkTeam and " ++ ") or " + ") or ",")
            local bans = __TS__ArrayMap(
                banNames,
                function(____, v) return self:validateBanRule(v) end
            )
            if checkTeam then
                return {"complexTeamBan", innerRule, "", limit, bans}
            end
            if (#bans > 1) or (limit > 0) then
                return {"complexBan", innerRule, "", limit, bans}
            end
            error(
                __TS__New(Error, "Confusing rule " .. rule),
                0
            )
        end
        return tostring(
            string.sub(rule, 1, 1)
        ) .. tostring(
            self:validateBanRule(
                string.sub(rule, 2)
            )
        )
    end
    ::____switch205_case_default::
    do
        ruleName, value = __TS__Unpack(
            __TS__StringSplit(rule, "=")
        )
        id = toID(_G, ruleName)
        ruleset = self.dex.formats:get(id)
        if not ruleset.exists then
            error(
                __TS__New(Error, ("Unrecognized rule \"" .. rule) .. "\""),
                0
            )
        end
        if type(value) == "string" then
            id = (id .. "=") .. __TS__StringTrim(value)
        end
        if rule:startsWith("!!") then
            return "!!" .. id
        end
        if rule:startsWith("!") then
            return "!" .. id
        end
        return id
    end
    ::____switch205_end::
end
function DexFormats.prototype.validPokemonTag(self, tagid)
    local tag = (rawget(Tags, tagid) ~= nil) and Tags[tagid]
    if not tag then
        return false
    end
    return not (not (tag.speciesFilter or tag.genericFilter))
end
function DexFormats.prototype.validateBanRule(self, rule)
    local id = toID(_G, rule)
    if id == "unreleased" then
        return "unreleased"
    end
    if id == "nonexistent" then
        return "nonexistent"
    end
    local matches = {}
    local matchTypes = {"pokemon", "move", "ability", "item", "nature", "pokemontag"}
    for ____, matchType in ipairs(matchTypes) do
        if rule:startsWith(matchType .. ":") then
            matchTypes = {matchType}
            id = id:slice(#matchType)
            break
        end
    end
    local ruleid = id
    if rawget(self.dex.data.Aliases, id) ~= nil then
        id = toID(_G, self.dex.data.Aliases[id])
    end
    for ____, matchType in ipairs(matchTypes) do
        do
            if (matchType == "item") and (ruleid == "noitem") then
                return "item:noitem"
            end
            local ____table
            local ____switch229 = matchType
            local validTags
            if ____switch229 == "pokemon" then
                goto ____switch229_case_0
            elseif ____switch229 == "move" then
                goto ____switch229_case_1
            elseif ____switch229 == "item" then
                goto ____switch229_case_2
            elseif ____switch229 == "ability" then
                goto ____switch229_case_3
            elseif ____switch229 == "nature" then
                goto ____switch229_case_4
            elseif ____switch229 == "pokemontag" then
                goto ____switch229_case_5
            end
            goto ____switch229_case_default
            ::____switch229_case_0::
            do
                ____table = self.dex.data.Pokedex
                goto ____switch229_end
            end
            ::____switch229_case_1::
            do
                ____table = self.dex.data.Moves
                goto ____switch229_end
            end
            ::____switch229_case_2::
            do
                ____table = self.dex.data.Items
                goto ____switch229_end
            end
            ::____switch229_case_3::
            do
                ____table = self.dex.data.Abilities
                goto ____switch229_end
            end
            ::____switch229_case_4::
            do
                ____table = self.dex.data.Natures
                goto ____switch229_end
            end
            ::____switch229_case_5::
            do
                validTags = {"allpokemon", "allitems", "allmoves", "allabilities", "allnatures"}
                if validTags:includes(ruleid) or self:validPokemonTag(ruleid) then
                    __TS__ArrayPush(
                        matches,
                        "pokemontag:" .. tostring(ruleid)
                    )
                end
                goto __continue227
            end
            ::____switch229_case_default::
            do
                error(
                    __TS__New(Error, "Unrecognized match type."),
                    0
                )
            end
            ::____switch229_end::
            if rawget(____table, id) ~= nil then
                if matchType == "pokemon" then
                    local species = ____table[id]
                    if species.otherFormes and (ruleid ~= (species.id + toID(_G, species.baseForme))) then
                        __TS__ArrayPush(
                            matches,
                            "basepokemon:" .. tostring(id)
                        )
                        goto __continue227
                    end
                end
                __TS__ArrayPush(
                    matches,
                    (tostring(matchType) .. ":") .. tostring(id)
                )
            elseif (matchType == "pokemon") and id:endsWith("base") then
                id = id:slice(0, -4)
                if rawget(____table, id) ~= nil then
                    __TS__ArrayPush(
                        matches,
                        "pokemon:" .. tostring(id)
                    )
                end
            end
        end
        ::__continue227::
    end
    if #matches > 1 then
        error(
            __TS__New(
                Error,
                (("More than one thing matches \"" .. rule) .. "\"; please specify one of: ") .. tostring(
                    __TS__ArrayJoin(matches, ", ")
                )
            ),
            0
        )
    end
    if #matches < 1 then
        error(
            __TS__New(Error, ("Nothing matches \"" .. rule) .. "\""),
            0
        )
    end
    return matches[1]
end
return ____exports
