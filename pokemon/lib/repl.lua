--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local fs = require("lib/fs")
local net = require("lib/net")
local path = require("lib/path")
local repl = require("lib/repl")
local ____crashlogger = require("lib/crashlogger")
local crashlogger = ____crashlogger.crashlogger
____exports.Repl = __TS__New(
    (function()
        local ____ = __TS__Class()
        ____.name = ""
        function ____.prototype.____constructor(self)
            self.socketPathnames = __TS__New(Set)
            self.listenersSetup = false
        end
        function ____.prototype.setupListeners(self, filename)
            if ____exports.Repl.listenersSetup then
                return
            end
            ____exports.Repl.listenersSetup = true
            process:once(
                "exit",
                function(____, code)
                    for ____, s in __TS__Iterator(____exports.Repl.socketPathnames) do
                        do
                            pcall(
                                function()
                                    fs:unlinkSync(s)
                                end
                            )
                        end
                    end
                    if (code == 129) or (code == 130) then
                        process.exitCode = 0
                    end
                end
            )
            if not process:listeners("SIGHUP").length then
                process:once(
                    "SIGHUP",
                    function() return process:exit(128 + 1) end
                )
            end
            if not process:listeners("SIGINT").length then
                process:once(
                    "SIGINT",
                    function() return process:exit(128 + 2) end
                )
            end
            global.heapdump = function(____, targetPath)
                if not targetPath then
                    targetPath = (filename .. "-") .. __TS__New(Date):toISOString()
                end
                local handler
                do
                    local ____try, e = pcall(
                        function()
                            handler = require(_G, "node-oom-heapdump")(_G)
                        end
                    )
                    if not ____try then
                        if e.code ~= "MODULE_NOT_FOUND" then
                            error(e, 0)
                        end
                        error(
                            __TS__New(Error, "node-oom-heapdump is not installed. Run `npm install --no-save node-oom-heapdump` and try again."),
                            0
                        )
                    end
                end
                return handler:createHeapSnapshot(path)
            end
        end
        function ____.prototype.start(self, filename, evalFunction)
            local config = (((type(Config) ~= "nil") and (function() return Config end)) or (function() return {} end))()
            if (config.repl ~= nil) and (not config.repl) then
                return
            end
            ____exports.Repl:setupListeners(filename)
            if filename == "app" then
                local directory = path:dirname(
                    path:resolve(__dirname, "..", config.replsocketprefix or "logs/repl", "app")
                )
                for ____, file in __TS__Iterator(
                    fs:readdirSync(directory)
                ) do
                    do
                        local pathname = path:resolve(directory, file)
                        local stat = fs:statSync(pathname)
                        if not stat:isSocket() then
                            goto __continue22
                        end
                        local socket
                        socket = net:connect(
                            pathname,
                            function()
                                socket["end"](socket)
                                socket:destroy()
                            end
                        ):on(
                            "error",
                            function()
                                fs:unlink(
                                    pathname,
                                    function()
                                    end
                                )
                            end
                        )
                    end
                    ::__continue22::
                end
            end
            local server = net:createServer(
                function(____, socket)
                    repl:start(
                        {
                            input = socket,
                            output = socket,
                            eval = function(self, cmd, context, unusedFilename, callback)
                                do
                                    local ____try, e, ____returnValue = pcall(
                                        function()
                                            return true, callback(
                                                _G,
                                                nil,
                                                evalFunction(_G, cmd)
                                            )
                                        end
                                    )
                                    if not ____try then
                                        e, ____returnValue = (function()
                                            return true, callback(_G, e, nil)
                                        end)()
                                    end
                                    if e then
                                        return ____returnValue
                                    end
                                end
                            end
                        }
                    ):on(
                        "exit",
                        function() return socket["end"](socket) end
                    )
                    socket:on(
                        "error",
                        function() return socket:destroy() end
                    )
                end
            )
            local pathname = path:resolve(__dirname, "..", Config.replsocketprefix or "logs/repl", filename)
            do
                local ____try, err = pcall(
                    function()
                        server:listen(
                            pathname,
                            function()
                                fs:chmodSync(pathname, Config.replsocketmode or 384)
                                ____exports.Repl.socketPathnames:add(pathname)
                            end
                        )
                        server:once(
                            "error",
                            function(____, err)
                                server:close()
                                if err.code == "EADDRINUSE" then
                                    fs:unlink(
                                        pathname,
                                        function(____, _err)
                                            if _err and (_err.code ~= "ENOENT") then
                                                crashlogger(_G, _err, "REPL: " .. filename)
                                            end
                                        end
                                    )
                                elseif err.code == "EACCES" then
                                    if process.platform ~= "win32" then
                                        print(("Could not start REPL server \"" .. filename) .. "\": Your filesystem doesn't support Unix sockets (everything else will still work)")
                                    end
                                else
                                    crashlogger(_G, err, "REPL: " .. filename)
                                end
                            end
                        )
                        server:once(
                            "close",
                            function()
                                ____exports.Repl.socketPathnames:delete(pathname)
                            end
                        )
                    end
                )
                if not ____try then
                    print(
                        (("Could not start REPL server \"" .. filename) .. "\": ") .. tostring(err)
                    )
                end
            end
        end
        return ____
    end)(),
    true
)
return ____exports
