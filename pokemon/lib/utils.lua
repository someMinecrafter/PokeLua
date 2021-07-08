--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
function ____exports.forceWrap(self, text)
    return __TS__StringReplace(
        text,
        nil,
        function(____, word)
            local lastBreak = 0
            local brokenWord = ""
            do
                local i = 1
                while i < #word do
                    if ((i - lastBreak) >= 10) or nil:test(
                        __TS__StringSlice(word, i - 1, i + 1)
                    ) then
                        brokenWord = tostring(brokenWord) .. (tostring(
                            __TS__StringSlice(word, lastBreak, i)
                        ) .. "​")
                        lastBreak = i
                    end
                    i = i + 1
                end
            end
            brokenWord = tostring(brokenWord) .. tostring(
                __TS__StringSlice(word, lastBreak)
            )
            return brokenWord
        end
    )
end
function ____exports.getString(self, str)
    return ((((type(str) == "string") or (type(str) == "number")) and (function() return "" .. tostring(str) end)) or (function() return "" end))()
end
function ____exports.escapeRegex(self, str)
    return __TS__StringReplace(str, nil, "\\$&")
end
function ____exports.escapeHTML(self, str)
    if (str == nil) or (str == nil) then
        return ""
    end
    return __TS__StringReplace(
        __TS__StringReplace(
            __TS__StringReplace(
                __TS__StringReplace(
                    __TS__StringReplace(
                        __TS__StringReplace(
                            __TS__StringReplace(
                                "" .. tostring(str),
                                nil,
                                "&amp;"
                            ),
                            nil,
                            "&lt;"
                        ),
                        nil,
                        "&gt;"
                    ),
                    nil,
                    "&quot;"
                ),
                nil,
                "&apos;"
            ),
            nil,
            "&#x2f;"
        ),
        nil,
        "<br />"
    )
end
function ____exports.stripHTML(self, htmlContent)
    if not htmlContent then
        return ""
    end
    return __TS__StringReplace(htmlContent, nil, "")
end
function ____exports.visualize(self, value, depth)
    if depth == nil then
        depth = 0
    end
    if value == nil then
        return "undefined"
    end
    if value == nil then
        return "null"
    end
    if (type(value) == "number") or (type(value) == "boolean") then
        return tostring(value)
    end
    if type(value) == "string" then
        return ("\"" .. value) .. "\""
    end
    if type(value) == "symbol" then
        return tostring(value)
    end
    if __TS__ArrayIsArray(value) then
        if depth > 10 then
            return "[array]"
        end
        return ("[" .. tostring(
            table.concat(
                __TS__ArrayMap(
                    value,
                    function(____, elem) return ____exports.visualize(_G, elem, depth + 1) end
                ),
                ", " or ","
            )
        )) .. "]"
    end
    if (__TS__InstanceOf(value, RegExp) or __TS__InstanceOf(value, Date)) or __TS__InstanceOf(value, Function) then
        if depth and __TS__InstanceOf(value, Function) then
            return "Function"
        end
        return tostring(value)
    end
    local constructor = ""
    if (value.constructor and value.constructor.name) and (type(value.constructor.name) == "string") then
        constructor = value.constructor.name
        if constructor == "Object" then
            constructor = ""
        end
    else
        constructor = "null"
    end
    local baseClass = (value.toString and nil:exec(
        tostring(value)
    )[2]) or constructor
    local ____switch22 = baseClass
    local mapped
    if ____switch22 == "Map" then
        goto ____switch22_case_0
    elseif ____switch22 == "Set" then
        goto ____switch22_case_1
    end
    goto ____switch22_end
    ::____switch22_case_0::
    do
        if depth > 2 then
            return "Map"
        end
        mapped = __TS__ArrayMap(
            {
                __TS__Spread(
                    value:entries()
                )
            },
            function(____, val) return (____exports.visualize(_G, val[0], depth + 1) .. " => ") .. ____exports.visualize(_G, val[1], depth + 1) end
        )
        return ((((constructor .. " (") .. tostring(value.size)) .. ") { ") .. table.concat(mapped, ", " or ",")) .. " }"
    end
    ::____switch22_case_1::
    do
        if depth > 2 then
            return "Set"
        end
        return ((((constructor .. " (") .. tostring(value.size)) .. ") { ") .. table.concat(
            __TS__ArrayMap(
                {
                    __TS__Spread(value)
                },
                function(____, v) return ____exports.visualize(_G, v) end,
                depth + 1
            ),
            ", " or ","
        )) .. " }"
    end
    ::____switch22_end::
    if value.toString then
        do
            local ____try, ____returned, ____returnValue = pcall(
                function()
                    local stringValue = tostring(value)
                    if ((type(stringValue) == "string") and (stringValue ~= "[object Object]")) and (stringValue ~= (("[object " .. constructor) .. "]")) then
                        return true, ((constructor .. "(") .. stringValue) .. ")"
                    end
                end
            )
            if ____try and ____returned then
                return ____returnValue
            end
        end
    end
    local buf = ""
    for key in pairs(value) do
        do
            if not Object.prototype.hasOwnProperty(value, key) then
                goto __continue30
            end
            if (depth > 2) or (depth and constructor) then
                buf = "..."
                break
            end
            if buf then
                buf = tostring(buf) .. ", "
            end
            local displayedKey = key
            if not nil:test(key) then
                displayedKey = JSON:stringify(key)
            end
            buf = tostring(buf) .. ((displayedKey .. ": ") .. tostring(
                ____exports.visualize(_G, value[key], depth + 1)
            ))
        end
        ::__continue30::
    end
    if (constructor and (not buf)) and (constructor ~= "null") then
        return constructor
    end
    return ((constructor .. "{") .. buf) .. "}"
end
function ____exports.compare(self, a, b)
    if type(a) == "number" then
        return a - b
    end
    if type(a) == "string" then
        return a:localeCompare(b)
    end
    if type(a) == "boolean" then
        return ((a and 1) or 2) - ((b and 1) or 2)
    end
    if __TS__ArrayIsArray(a) then
        do
            local i = 0
            while i < #a do
                local comparison = ____exports.compare(_G, a[i + 1], b[i + 1])
                if comparison then
                    return comparison
                end
                i = i + 1
            end
        end
        return 0
    end
    if a.reverse ~= nil then
        return ____exports.compare(_G, b.reverse, a.reverse)
    end
    error(
        __TS__New(
            Error,
            ("Passed value " .. tostring(a)) .. " is not comparable"
        ),
        0
    )
end
function ____exports.sortBy(self, array, callback)
    if not callback then
        return __TS__ArraySort(array, ____exports.compare)
    end
    return __TS__ArraySort(
        array,
        function(____, a, b) return ____exports.compare(
            _G,
            callback(_G, a),
            callback(_G, b)
        ) end
    )
end
function ____exports.splitFirst(self, str, delimiter, limit)
    if limit == nil then
        limit = 1
    end
    local splitStr = {}
    while #splitStr < limit do
        local delimiterIndex = (string.find(str, delimiter, nil, true) or 0) - 1
        if delimiterIndex >= 0 then
            __TS__ArrayPush(
                splitStr,
                __TS__StringSlice(str, 0, delimiterIndex)
            )
            str = __TS__StringSlice(str, delimiterIndex + #delimiter)
        else
            __TS__ArrayPush(splitStr, str)
            str = ""
        end
    end
    __TS__ArrayPush(splitStr, str)
    return splitStr
end
function ____exports.html(self, strings, ...)
    local args = {...}
    local buf = strings[1]
    local i = 0
    while i < args.length do
        buf = tostring(buf) .. tostring(
            ____exports.escapeHTML(_G, args[i])
        )
        buf = tostring(buf) .. tostring(
            strings[(function()
                i = i + 1
                return i
            end)() + 1]
        )
    end
    return buf
end
function ____exports.escapeHTMLForceWrap(self, text)
    return __TS__StringReplace(
        ____exports.escapeHTML(
            _G,
            ____exports.forceWrap(_G, text)
        ),
        nil,
        "<wbr />"
    )
end
function ____exports.shuffle(self, arr)
    do
        local i = #arr - 1
        while i > 0 do
            local j = math.floor(
                math.random() * (i + 1)
            )
            arr[i + 1], arr[j + 1] = __TS__Unpack({arr[j + 1], arr[i + 1]})
            i = i - 1
        end
    end
    return arr
end
function ____exports.randomElement(self, arr)
    local i = math.floor(
        math.random() * #arr
    )
    return arr[i + 1]
end
function ____exports.clampIntRange(self, num, min, max)
    if type(num) ~= "number" then
        num = 0
    end
    num = math.floor(num)
    if (min ~= nil) and (num < min) then
        num = min
    end
    if (max ~= nil) and (num > max) then
        num = max
    end
    return num
end
function ____exports.clearRequireCache(self, options)
    if options == nil then
        options = {}
    end
    local excludes = options.exclude or ({})
    __TS__ArrayPush(excludes, "/node_modules/")
    for path in pairs(require.cache) do
        local skip = false
        for ____, exclude in ipairs(excludes) do
            if path:includes(exclude) then
                skip = true
                break
            end
        end
        if not skip then
            __TS__Delete(require.cache, path)
        end
    end
end
function ____exports.deepClone(self, obj)
    if (obj == nil) or (type(obj) ~= "table") then
        return obj
    end
    if __TS__ArrayIsArray(obj) then
        return __TS__ArrayMap(
            obj,
            function(____, prop) return ____exports.deepClone(_G, prop) end
        )
    end
    local clone = Object:create(
        Object:getPrototypeOf(obj)
    )
    for ____, key in ipairs(
        __TS__ObjectKeys(obj)
    ) do
        clone[key] = ____exports.deepClone(_G, obj[key])
    end
    return clone
end
function ____exports.levenshtein(self, s, t, l)
    local d = {}
    local n = #s
    local m = #t
    if n == 0 then
        return m
    end
    if m == 0 then
        return n
    end
    if l and (math.abs(m - n) > l) then
        return math.abs(m - n)
    end
    do
        local i = n
        while i >= 0 do
            d[i + 1] = {}
            i = i - 1
        end
    end
    do
        local i = n
        while i >= 0 do
            d[i + 1][1] = i
            i = i - 1
        end
    end
    do
        local j = m
        while j >= 0 do
            d[1][j + 1] = j
            j = j - 1
        end
    end
    do
        local i = 1
        while i <= n do
            local si = __TS__StringCharAt(s, i - 1)
            do
                local j = 1
                while j <= m do
                    if (i == j) and (d[i + 1][j + 1] > 4) then
                        return n
                    end
                    local tj = __TS__StringCharAt(t, j - 1)
                    local cost = ((si == tj) and 0) or 1
                    local mi = d[i][j + 1] + 1
                    local b = d[i + 1][j] + 1
                    local c = d[i][j] + cost
                    if b < mi then
                        mi = b
                    end
                    if c < mi then
                        mi = c
                    end
                    d[i + 1][j + 1] = mi
                    j = j + 1
                end
            end
            i = i + 1
        end
    end
    return d[n + 1][m + 1]
end
function ____exports.waitUntil(self, time)
    return __TS__New(
        Promise,
        function(____, resolve)
            setTimeout(
                _G,
                function() return resolve(_G) end,
                time - Date:now()
            )
        end
    )
end
____exports.Multiset = __TS__Class()
local Multiset = ____exports.Multiset
Multiset.name = "Multiset"
__TS__ClassExtends(Multiset, Map)
function Multiset.prototype.add(self, key)
    self:set(
        key,
        (function(____lhs)
            if ____lhs == nil then
                return 0
            else
                return ____lhs
            end
        end)(
            self:get(key)
        ) + 1
    )
    return self
end
function Multiset.prototype.remove(self, key)
    local newValue = (function(____lhs)
        if ____lhs == nil then
            return 0
        else
            return ____lhs
        end
    end)(
        self:get(key)
    ) - 1
    if newValue <= 0 then
        return self:delete(key)
    end
    self:set(key, newValue)
    return true
end
____exports.Utils = {waitUntil = ____exports.waitUntil, html = ____exports.html, escapeHTML = ____exports.escapeHTML, compare = ____exports.compare, sortBy = ____exports.sortBy, levenshtein = ____exports.levenshtein, shuffle = ____exports.shuffle, deepClone = ____exports.deepClone, clearRequireCache = ____exports.clearRequireCache, randomElement = ____exports.randomElement, forceWrap = ____exports.forceWrap, splitFirst = ____exports.splitFirst, stripHTML = ____exports.stripHTML, visualize = ____exports.visualize, getString = ____exports.getString, escapeRegex = ____exports.escapeRegex, Multiset = ____exports.Multiset}
return ____exports
