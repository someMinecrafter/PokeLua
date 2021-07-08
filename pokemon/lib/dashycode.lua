--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local CODE_MAP = "23456789abcdefghijkmnpqrstuvwxyz"
local UNSAFE_MAP = "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~"
local function streamWrite(self, stream, writeBufLength, writeBuf)
    stream.buf = stream.buf + bit.lshift(writeBuf, stream.bufLength)
    stream.bufLength = stream.bufLength + writeBufLength
    while stream.bufLength >= 5 do
        stream.codeBuf = tostring(stream.codeBuf) .. tostring(
            __TS__StringCharAt(
                CODE_MAP,
                bit.band(stream.buf, 31)
            )
        )
        stream.buf = bit.arshift(stream.buf, 5)
        stream.bufLength = stream.bufLength - 5
    end
end
local function streamGetCode(self, stream)
    local buf = tostring(stream.codeBuf) .. tostring(
        __TS__StringCharAt(CODE_MAP, stream.buf)
    )
    local end2Len = 0
    while __TS__StringCharAt(buf, (#buf - 1) - end2Len) == "2" do
        end2Len = end2Len + 1
    end
    return ((end2Len and (function() return __TS__StringSlice(buf, 0, -end2Len) end)) or (function() return buf end))()
end
local function streamPeek(self, stream, readLength, readMask)
    if readMask == nil then
        readMask = bit.arshift(65535, 16 - readLength)
    end
    while (stream.bufLength < readLength) and #stream.codeBuf do
        local next5Bits = (string.find(
            CODE_MAP,
            string.sub(stream.codeBuf, 1, 1),
            nil,
            true
        ) or 0) - 1
        if next5Bits < 0 then
            error(
                __TS__New(Error, "Invalid character in coded buffer"),
                0
            )
        end
        stream.codeBuf = string.sub(stream.codeBuf, 2)
        stream.buf = stream.buf + bit.lshift(next5Bits, stream.bufLength)
        stream.bufLength = stream.bufLength + 5
    end
    return bit.band(stream.buf, readMask)
end
local function streamRead(self, stream, readLength, readMask)
    if readMask == nil then
        readMask = bit.arshift(65535, 16 - readLength)
    end
    local output = streamPeek(_G, stream, readLength, readMask)
    stream.buf = bit.arshift(stream.buf, readLength)
    stream.bufLength = stream.bufLength - readLength
    return output
end
function ____exports.encode(self, str, allowCaps)
    if allowCaps == nil then
        allowCaps = false
    end
    if not str then
        return "0--0"
    end
    local safePart = ""
    local unsafeStream = {codeBuf = "", buf = 0, bufLength = 0}
    local isSafe = true
    local alphaIndex = 0
    local capBuffer = 0
    do
        local i = 0
        while i < (#str + 1) do
            do
                local curCharCode = (((i ~= #str) and (function() return __TS__StringCharCodeAt(str, i) end)) or (function() return -1 end))()
                local isLowercase = (97 <= curCharCode) and (curCharCode <= 122)
                local isUppercase = (65 <= curCharCode) and (curCharCode <= 90)
                local isNumeric = (48 <= curCharCode) and (curCharCode <= 57)
                if capBuffer and (((not ((isLowercase or isUppercase) or isNumeric)) or (alphaIndex >= 8)) or (i == #str)) then
                    if capBuffer == 13 then
                        streamWrite(_G, unsafeStream, 3, 1)
                    else
                        streamWrite(_G, unsafeStream, 11, capBuffer)
                    end
                    alphaIndex = alphaIndex - 8
                    capBuffer = 0
                end
                if i == #str then
                    break
                end
                if (isLowercase or isUppercase) or isNumeric then
                    if alphaIndex < 0 then
                        error(
                            __TS__New(Error, "alphaIndex should be non-negative here"),
                            0
                        )
                    end
                    if not isSafe then
                        if capBuffer then
                            error(
                                __TS__New(Error, "capBuffer shouldn't exist here"),
                                0
                            )
                        end
                        streamWrite(_G, unsafeStream, 2, 0)
                        isSafe = true
                    end
                    if isUppercase and (not allowCaps) then
                        safePart = tostring(safePart) .. tostring(
                            string.char(curCharCode + 32)
                        )
                        while alphaIndex >= 8 do
                            if capBuffer then
                                error(
                                    __TS__New(Error, "capBuffer shouldn't exist here"),
                                    0
                                )
                            end
                            alphaIndex = alphaIndex - 8
                            streamWrite(_G, unsafeStream, 11, 5)
                        end
                        if not capBuffer then
                            capBuffer = 5
                        end
                        capBuffer = capBuffer + bit.lshift(1, alphaIndex + 3)
                    else
                        safePart = tostring(safePart) .. tostring(
                            __TS__StringCharAt(str, i)
                        )
                    end
                    if isUppercase or isLowercase then
                        alphaIndex = alphaIndex + 1
                    end
                    goto __continue12
                end
                if capBuffer then
                    error(
                        __TS__New(Error, "capBuffer shouldn't exist here"),
                        0
                    )
                end
                alphaIndex = 0
                if isSafe and (curCharCode == 32) then
                    local nextCharCode = __TS__StringCharCodeAt(str, i + 1)
                    if (((97 <= nextCharCode) and (nextCharCode <= 122)) or ((65 <= nextCharCode) and (nextCharCode <= 90))) or ((48 <= nextCharCode) and (nextCharCode <= 57)) then
                        safePart = tostring(safePart) .. "-"
                        streamWrite(_G, unsafeStream, 2, 0)
                        goto __continue12
                    end
                end
                if isSafe then
                    safePart = tostring(safePart) .. "-"
                    isSafe = false
                end
                local unsafeMapIndex = -1
                if curCharCode == -1 then
                    streamWrite(_G, unsafeStream, 2, 0)
                elseif curCharCode == 32 then
                    streamWrite(_G, unsafeStream, 3, 3)
                elseif (function()
                    unsafeMapIndex = (string.find(
                        UNSAFE_MAP,
                        __TS__StringCharAt(str, i),
                        nil,
                        true
                    ) or 0) - 1
                    return unsafeMapIndex
                end)() >= 0 then
                    curCharCode = bit.lshift(unsafeMapIndex, 2) + 2
                    streamWrite(_G, unsafeStream, 7, curCharCode)
                else
                    curCharCode = bit.lshift(curCharCode, 3) + 7
                    streamWrite(_G, unsafeStream, 19, curCharCode)
                end
            end
            ::__continue12::
            i = i + 1
        end
    end
    local unsafePart = streamGetCode(_G, unsafeStream)
    if safePart:startsWith("-") then
        safePart = string.sub(safePart, 2)
        unsafePart = tostring(unsafePart) .. "2"
    end
    if safePart:endsWith("-") then
        safePart = string.sub(safePart, 1, -2)
    end
    if not safePart then
        safePart = "0"
        unsafePart = "0" .. tostring(unsafePart)
        if unsafePart:endsWith("2") then
            unsafePart = string.sub(unsafePart, 1, -2)
        end
    end
    if not unsafePart then
        return safePart
    end
    return (tostring(safePart) .. "--") .. tostring(unsafePart)
end
function ____exports.decode(self, codedStr)
    local str = ""
    local lastDashIndex = codedStr:lastIndexOf("--")
    if lastDashIndex < 0 then
        return __TS__StringReplace(codedStr, nil, " ")
    end
    if __TS__StringCharAt(codedStr, lastDashIndex + 2) == "0" then
        if (not codedStr:startsWith("0")) or (lastDashIndex ~= 1) then
            error(
                __TS__New(Error, "Invalid Dashycode"),
                0
            )
        end
        lastDashIndex = lastDashIndex - 1
        codedStr = "--" .. tostring(
            string.sub(codedStr, 5)
        )
    end
    if codedStr:endsWith("2") then
        codedStr = "-" .. tostring(
            string.sub(codedStr, 1, -2)
        )
        lastDashIndex = lastDashIndex + 1
    end
    local unsafeStream = {
        codeBuf = __TS__StringSlice(codedStr, lastDashIndex + 2),
        buf = 0,
        bufLength = 0
    }
    local capBuffer = 1
    do
        local i = 0
        while i < (lastDashIndex + 1) do
            local curChar = __TS__StringCharAt(codedStr, i)
            if curChar ~= "-" then
                local curCharCode = __TS__StringCharCodeAt(codedStr, i)
                local isLowercase = (97 <= curCharCode) and (curCharCode <= 122)
                if isLowercase then
                    if capBuffer == 1 then
                        capBuffer = 0
                        if streamPeek(_G, unsafeStream, 2, 3) == 1 then
                            local ____switch51 = streamRead(_G, unsafeStream, 3, 7)
                            if ____switch51 == 5 then
                                goto ____switch51_case_0
                            elseif ____switch51 == 1 then
                                goto ____switch51_case_1
                            end
                            goto ____switch51_end
                            ::____switch51_case_0::
                            do
                                capBuffer = streamRead(_G, unsafeStream, 8, 255) + 256
                                goto ____switch51_end
                            end
                            ::____switch51_case_1::
                            do
                                capBuffer = 257
                                goto ____switch51_end
                            end
                            ::____switch51_end::
                        end
                    end
                    local toCapitalize = bit.band(capBuffer, 1)
                    capBuffer = bit.arshift(capBuffer, 1)
                    if toCapitalize then
                        curChar = string.char(curCharCode - 32)
                    end
                end
                str = tostring(str) .. tostring(curChar)
            else
                capBuffer = 1
                local isEmpty = true
                repeat
                    do
                        local ____switch55 = streamRead(_G, unsafeStream, 2, 3)
                        if ____switch55 == 0 then
                            goto ____switch55_case_0
                        elseif ____switch55 == 1 then
                            goto ____switch55_case_1
                        elseif ____switch55 == 2 then
                            goto ____switch55_case_2
                        elseif ____switch55 == 3 then
                            goto ____switch55_case_3
                        end
                        goto ____switch55_end
                        ::____switch55_case_0::
                        do
                            curChar = ""
                            goto ____switch55_end
                        end
                        ::____switch55_case_1::
                        do
                            error(
                                __TS__New(Error, "Invalid capitalization token"),
                                0
                            )
                        end
                        ::____switch55_case_2::
                        do
                            curChar = __TS__StringCharAt(
                                UNSAFE_MAP,
                                streamRead(_G, unsafeStream, 5, 31)
                            )
                            isEmpty = false
                            goto ____switch55_end
                        end
                        ::____switch55_case_3::
                        do
                            if streamRead(_G, unsafeStream, 1, 1) then
                                curChar = string.char(
                                    streamRead(_G, unsafeStream, 16, 65535)
                                )
                            else
                                curChar = " "
                            end
                            isEmpty = false
                            goto ____switch55_end
                        end
                        ::____switch55_end::
                        str = tostring(str) .. tostring(curChar)
                    end
                until not curChar
                if isEmpty and (i ~= lastDashIndex) then
                    str = tostring(str) .. " "
                end
            end
            i = i + 1
        end
    end
    return str
end
function ____exports.vizStream(self, codeBuf, translate)
    if translate == nil then
        translate = true
    end
    local spacedStream = ""
    if codeBuf:startsWith("0") then
        codeBuf = string.sub(codeBuf, 2)
        spacedStream = " [no safe chars]" .. tostring(spacedStream)
    end
    if codeBuf:endsWith("2") then
        codeBuf = string.sub(codeBuf, 1, -2)
        spacedStream = " [start unsafe]" .. tostring(spacedStream)
    end
    local stream = {codeBuf = codeBuf, buf = 0, bufLength = 0}
    local function vizBlock(self, s, bufLen)
        local buf = streamRead(_G, s, bufLen)
        return __TS__NumberToString(buf, 2):padStart(bufLen, "0")
    end
    while (stream.bufLength > 0) or stream.codeBuf do
        local ____switch64 = streamRead(_G, stream, 2)
        if ____switch64 == 0 then
            goto ____switch64_case_0
        elseif ____switch64 == 1 then
            goto ____switch64_case_1
        elseif ____switch64 == 2 then
            goto ____switch64_case_2
        elseif ____switch64 == 3 then
            goto ____switch64_case_3
        end
        goto ____switch64_end
        ::____switch64_case_0::
        do
            spacedStream = tostring((translate and " |") or " 00") .. tostring(spacedStream)
            goto ____switch64_end
        end
        ::____switch64_case_1::
        do
            if streamRead(_G, stream, 1) then
                spacedStream = ((" " .. tostring(
                    vizBlock(_G, stream, 8)
                )) .. tostring((translate and "-cap") or "_1_01")) .. tostring(spacedStream)
            else
                spacedStream = tostring((translate and " capfirst") or " 0_01") .. tostring(spacedStream)
            end
            goto ____switch64_end
        end
        ::____switch64_case_2::
        do
            spacedStream = ((" " .. tostring(
                vizBlock(_G, stream, 5)
            )) .. tostring((translate and "-ascii") or "_10")) .. tostring(spacedStream)
            goto ____switch64_end
        end
        ::____switch64_case_3::
        do
            if streamRead(_G, stream, 1) then
                spacedStream = ((" " .. tostring(
                    vizBlock(_G, stream, 16)
                )) .. tostring((translate and "-utf") or "_1_11")) .. tostring(spacedStream)
            else
                spacedStream = tostring((translate and " space") or " 0_11") .. tostring(spacedStream)
            end
            goto ____switch64_end
        end
        ::____switch64_end::
    end
    return spacedStream
end
return ____exports
