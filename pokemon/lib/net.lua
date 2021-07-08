--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
--[[
local ____exports = {}
local https = require("lib.https")
local http = require("lib.http")
local url = require("lib.url")
local Streams = require("lib.streams")
____exports.HttpError = __TS__Class()
local HttpError = ____exports.HttpError
HttpError.name = "HttpError"
__TS__ClassExtends(HttpError, Error)
function HttpError.prototype.____constructor(self, message, statusCode, body)
    Error.prototype.____constructor(self, message)
    self.name = "HttpError"
    self.statusCode = statusCode
    self.body = body
    Error:captureStackTrace(self, ____exports.HttpError)
end
____exports.NetStream = __TS__Class()
local NetStream = ____exports.NetStream
NetStream.name = "NetStream"
__TS__ClassExtends(NetStream, Streams.ReadWriteStream)
function NetStream.prototype.____constructor(self, uri, opts)
    if opts == nil then
        opts = nil
    end
    NetStream.____super.prototype.____constructor(self)
    self.statusCode = nil
    self.headers = nil
    self.uri = uri
    self.opts = opts
    self.response = nil
    self.state = "pending"
    self.request = self:makeRequest(opts)
end
function NetStream.prototype.makeRequest(self, opts)
    if not opts then
        opts = {}
    end
    local body = opts.body
    if body and (type(body) ~= "string") then
        if not opts.headers then
            opts.headers = {}
        end
        if not opts.headers["Content-Type"] then
            opts.headers["Content-Type"] = "application/x-www-form-urlencoded"
        end
        body = ____exports.NetStream:encodeQuery(body)
    end
    if opts.query then
        self.uri = tostring(self.uri) .. (tostring(
            (self.uri:includes("?") and "&") or "?"
        ) .. tostring(
            ____exports.NetStream:encodeQuery(opts.query)
        ))
    end
    if body then
        if not opts.headers then
            opts.headers = {}
        end
        if not opts.headers["Content-Length"] then
            opts.headers["Content-Length"] = Buffer:byteLength(body)
        end
    end
    local protocol = url:parse(self.uri).protocol
    local net = (((protocol == "https:") and (function() return https end)) or (function() return http end))()
    local resolveResponse
    self.response = __TS__New(
        Promise,
        function(____, resolve)
            resolveResponse = resolve
        end
    )
    local request = net:request(
        self.uri,
        opts,
        function(____, response)
            self.state = "open"
            self.nodeReadableStream = response
            self.response = response
            self.statusCode = response.statusCode or nil
            self.headers = response.headers
            response:setEncoding("utf-8")
            resolveResponse(_G, response)
            resolveResponse = nil
            response:on(
                "data",
                function(____, data)
                    self:push(data)
                end
            )
            response:on(
                "end",
                function()
                    if self.state == "open" then
                        self.state = "success"
                    end
                    if not self.atEOF then
                        self:pushEnd()
                    end
                end
            )
        end
    )
    request:on(
        "close",
        function()
            if not self.atEOF then
                self.state = "error"
                self:pushError(
                    __TS__New(Error, "Unexpected connection close")
                )
            end
            if resolveResponse then
                self.response = nil
                resolveResponse(_G, nil)
                resolveResponse = nil
            end
        end
    )
    request:on(
        "error",
        function(____, ____error)
            if not self.atEOF then
                self:pushError(____error, true)
            end
        end
    )
    if opts.timeout or (opts.timeout == nil) then
        request:setTimeout(
            opts.timeout or 5000,
            function()
                self.state = "timeout"
                self:pushError(
                    __TS__New(Error, "Request timeout")
                )
                request:abort()
            end
        )
    end
    if body then
        request:write(body)
        request["end"](request)
        if opts.writable then
            error(
                __TS__New(Error, "options.body is what you would have written to a NetStream - you must choose one or the other"),
                0
            )
        end
    elseif opts.writable then
        self.nodeWritableStream = request
    else
        request["end"](request)
    end
    return request
end
function NetStream.encodeQuery(self, data)
    local out = ""
    for key in pairs(data) do
        if out then
            out = tostring(out) .. "&"
        end
        out = tostring(out) .. ((key .. "=") .. encodeURIComponent(
            _G,
            "" .. tostring(data[key])
        ))
    end
    return out
end
function NetStream.prototype._write(self, data)
    if not self.nodeWritableStream then
        error(
            __TS__New(Error, "You must specify opts.writable to write to a request."),
            0
        )
    end
    local result = self.nodeWritableStream:write(data)
    if result ~= false then
        return nil
    end
    if not #self.drainListeners then
        self.nodeWritableStream:once(
            "drain",
            function()
                for ____, listener in ipairs(self.drainListeners) do
                    listener(_G)
                end
                self.drainListeners = {}
            end
        )
    end
    return __TS__New(
        Promise,
        function(____, resolve)
            __TS__ArrayPush(self.drainListeners, resolve)
        end
    )
end
function NetStream.prototype._read(self)
    self.nodeReadableStream:resume()
end
function NetStream.prototype._pause(self)
    self.nodeReadableStream:pause()
end
____exports.NetRequest = __TS__Class()
local NetRequest = ____exports.NetRequest
NetRequest.name = "NetRequest"
function NetRequest.prototype.____constructor(self, uri)
    self.uri = uri
end
function NetRequest.prototype.getStream(self, opts)
    if opts == nil then
        opts = {}
    end
    if (type(Config) ~= "nil") and Config.noNetRequests then
        error(
            __TS__New(Error, "Net requests are disabled."),
            0
        )
    end
    local stream = __TS__New(____exports.NetStream, self.uri, opts)
    return stream
end
function NetRequest.prototype.get(self, opts)
    if opts == nil then
        opts = {}
    end
    local stream = self:getStream(opts)
    local response = nil
    if response and (response.statusCode ~= 200) then
        error(
            __TS__New(____exports.HttpError, response.statusMessage or "Connection error", response.statusCode, nil),
            0
        )
    end
    return stream:readAll()
end
function NetRequest.prototype.post(self, opts, body)
    if opts == nil then
        opts = {}
    end
    if not body then
        body = opts.body
    end
    return self:get(
        __TS__ObjectAssign({}, opts, {method = "POST", body = body})
    )
end
____exports.Net = __TS__ObjectAssign(
    function(____, path) return __TS__New(____exports.NetRequest, path) end,
    {NetRequest = ____exports.NetRequest, NetStream = ____exports.NetStream}
)
return ____exports
--]]
return {}
