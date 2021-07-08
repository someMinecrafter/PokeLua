--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local fs = require("lib/fs")
local path = require("lib/path")
local CRASH_EMAIL_THROTTLE = (5 * 60) * 1000
local LOCKDOWN_PERIOD = (30 * 60) * 1000
local logPath = path:resolve(__dirname, "../logs/errors.txt")
local lastCrashLog = 0
local transport
function ____exports.crashlogger(self, ____error, description, data)
    if data == nil then
        data = nil
    end
    local datenow = Date:now()
    local stack = (((type(____error) == "string") and (function() return ____error end)) or (function() return ____error.stack end))() or ""
    if data then
        stack = tostring(stack) .. "\n\nAdditional information:\n"
        for k in pairs(data) do
            stack = tostring(stack) .. (((("  " .. k) .. " = ") .. tostring(data[k])) .. "\n")
        end
    end
    print(("\nCRASH: " .. stack) .. "\n")
    local out = fs:createWriteStream(logPath, {flags = "a"})
    out:on(
        "open",
        function()
            out:write(("\n" .. stack) .. "\n")
            out["end"](out)
        end
    ):on(
        "error",
        function(____, err)
            print(("\nSUBCRASH: " .. err.stack) .. "\n")
        end
    )
    if Config.crashguardemail and ((datenow - lastCrashLog) > CRASH_EMAIL_THROTTLE) then
        lastCrashLog = datenow
        if not transport then
            do
                local ____try, e = pcall(
                    function()
                        require:resolve("nodemailer")
                    end
                )
                if not ____try then
                    error(
                        __TS__New(Error, "nodemailer is not installed, but it is required if Config.crashguardemail is configured! " .. "Run npm install --no-save nodemailer and restart the server."),
                        0
                    )
                end
            end
        end
        local text = description .. " crashed "
        if transport then
            text = tostring(text) .. ("again with this stack trace:\n" .. stack)
        else
            do
                local ____try, e = pcall(
                    function()
                        transport = require(_G, "nodemailer"):createTransport(Config.crashguardemail.options)
                    end
                )
                if not ____try then
                    error(
                        __TS__New(Error, "Failed to start nodemailer; are you sure you've configured Config.crashguardemail correctly?"),
                        0
                    )
                end
            end
            text = tostring(text) .. ("with this stack trace:\n" .. stack)
        end
        transport:sendMail(
            {from = Config.crashguardemail.from, to = Config.crashguardemail.to, subject = Config.crashguardemail.subject, text = text},
            function(____, err)
                if err then
                    print(
                        "Error sending email: " .. tostring(err)
                    )
                end
            end
        )
    end
    if (process:uptime() * 1000) < LOCKDOWN_PERIOD then
        return "lockdown"
    end
    return nil
end
return ____exports
