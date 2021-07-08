--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports.Dashycode = require("lib/dashycode")
do
    local ____repl = require("lib/repl")
    local Repl = ____repl.Repl
    ____exports.Repl = Repl
end
do
    local ____net = require("lib/net")
    local Net = ____net.Net
    ____exports.Net = Net
end
____exports.Streams = require("lib/streams")
do
    local ____fs = require("lib/fs")
    local FS = ____fs.FS
    ____exports.FS = FS
end
____exports.Utils = require("lib/utils")
do
    local ____crashlogger = require("lib/crashlogger")
    local crashlogger = ____crashlogger.crashlogger
    ____exports.crashlogger = crashlogger
end
____exports.ProcessManager = require("lib/process-manager")
return ____exports
