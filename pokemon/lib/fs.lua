--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local fs = require("lib/fs")
local pathModule = require("lib/path")
local ____streams = require("lib/streams")
local ReadStream = ____streams.ReadStream
local WriteStream = ____streams.WriteStream
local FileReadStream
local ROOT_PATH = pathModule:resolve(__dirname, "..")
if not global.__fsState then
    global.__fsState = {
        pendingUpdates = __TS__New(Map)
    }
end
____exports.FSPath = __TS__Class()
local FSPath = ____exports.FSPath
FSPath.name = "FSPath"
function FSPath.prototype.____constructor(self, path)
    self.path = pathModule:resolve(ROOT_PATH, path)
end
function FSPath.prototype.parentDir(self)
    return __TS__New(
        ____exports.FSPath,
        pathModule:dirname(self.path)
    )
end
function FSPath.prototype.read(self, options)
    if options == nil then
        options = "utf8"
    end
    if (type(options) ~= "string") and (options.encoding == nil) then
        options.encoding = "utf8"
    end
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:readFile(
                self.path,
                options,
                function(____, err, data)
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(_G, data) end))()
                end
            )
        end
    )
end
function FSPath.prototype.readSync(self, options)
    if options == nil then
        options = "utf8"
    end
    if (type(options) ~= "string") and (options.encoding == nil) then
        options.encoding = "utf8"
    end
    return fs:readFileSync(self.path, options)
end
function FSPath.prototype.readBuffer(self, options)
    if options == nil then
        options = {}
    end
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:readFile(
                self.path,
                options,
                function(____, err, data)
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(_G, data) end))()
                end
            )
        end
    )
end
function FSPath.prototype.readBufferSync(self, options)
    if options == nil then
        options = {}
    end
    return fs:readFileSync(self.path, options)
end
function FSPath.prototype.exists(self)
    return __TS__New(
        Promise,
        function(____, resolve)
            fs:exists(
                self.path,
                function(____, exists)
                    resolve(_G, exists)
                end
            )
        end
    )
end
function FSPath.prototype.existsSync(self)
    return fs:existsSync(self.path)
end
function FSPath.prototype.readIfExists(self)
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:readFile(
                self.path,
                "utf8",
                function(____, err, data)
                    if err and (err.code == "ENOENT") then
                        return resolve(_G, "")
                    end
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(_G, data) end))()
                end
            )
        end
    )
end
function FSPath.prototype.readIfExistsSync(self)
    do
        local ____try, err, ____returnValue = pcall(
            function()
                return true, fs:readFileSync(self.path, "utf8")
            end
        )
        if not ____try then
            err, ____returnValue = (function()
                if err.code ~= "ENOENT" then
                    error(err, 0)
                end
            end)()
        end
        if err then
            return ____returnValue
        end
    end
    return ""
end
function FSPath.prototype.write(self, data, options)
    if options == nil then
        options = {}
    end
    if global.Config.nofswriting then
        return Promise:resolve()
    end
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:writeFile(
                self.path,
                data,
                options,
                function(____, err)
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(_G) end))()
                end
            )
        end
    )
end
function FSPath.prototype.writeSync(self, data, options)
    if options == nil then
        options = {}
    end
    if global.Config.nofswriting then
        return
    end
    return fs:writeFileSync(self.path, data, options)
end
function FSPath.prototype.safeWrite(self, data, options)
    if options == nil then
        options = {}
    end
    local ____ = nil
    local ____ = nil
end
function FSPath.prototype.safeWriteSync(self, data, options)
    if options == nil then
        options = {}
    end
    ____exports.FS(
        _G,
        tostring(self.path) .. ".NEW"
    ):writeSync(data, options)
    ____exports.FS(
        _G,
        tostring(self.path) .. ".NEW"
    ):renameSync(self.path)
end
function FSPath.prototype.writeUpdate(self, dataFetcher, options)
    if options == nil then
        options = {}
    end
    if global.Config.nofswriting then
        return
    end
    local pendingUpdate = __fsState.pendingUpdates:get(self.path)
    local throttleTime = ((options.throttle and (function() return Date:now() + options.throttle end)) or (function() return 0 end))()
    if pendingUpdate then
        pendingUpdate.pendingDataFetcher = dataFetcher
        pendingUpdate.pendingOptions = options
        if pendingUpdate.throttleTimer and (throttleTime < pendingUpdate.throttleTime) then
            pendingUpdate.throttleTime = throttleTime
            clearTimeout(_G, pendingUpdate.throttleTimer)
            pendingUpdate.throttleTimer = setTimeout(
                _G,
                function() return self:checkNextUpdate() end,
                throttleTime - Date:now()
            )
        end
        return
    end
    if not throttleTime then
        self:writeUpdateNow(dataFetcher, options)
        return
    end
    local update = {
        isWriting = false,
        pendingDataFetcher = dataFetcher,
        pendingOptions = options,
        throttleTime = throttleTime,
        throttleTimer = setTimeout(
            _G,
            function() return self:checkNextUpdate() end,
            throttleTime - Date:now()
        )
    }
    __fsState.pendingUpdates:set(self.path, update)
end
function FSPath.prototype.writeUpdateNow(self, dataFetcher, options)
    local throttleTime = ((options.throttle and (function() return Date:now() + options.throttle end)) or (function() return 0 end))()
    local update = {isWriting = true, pendingDataFetcher = nil, pendingOptions = nil, throttleTime = throttleTime, throttleTimer = nil}
    __fsState.pendingUpdates:set(self.path, update)
    local ____ = nil
end
function FSPath.prototype.checkNextUpdate(self)
    local pendingUpdate = __fsState.pendingUpdates:get(self.path)
    if not pendingUpdate then
        error(
            __TS__New(Error, "FS: Pending update not found"),
            0
        )
    end
    if pendingUpdate.isWriting then
        error(
            __TS__New(Error, "FS: Conflicting update"),
            0
        )
    end
    local dataFetcher = pendingUpdate.pendingDataFetcher
    local options = pendingUpdate.pendingOptions
    if (not dataFetcher) or (not options) then
        __fsState.pendingUpdates:delete(self.path)
        return
    end
    self:writeUpdateNow(dataFetcher, options)
end
function FSPath.prototype.finishUpdate(self)
    local pendingUpdate = __fsState.pendingUpdates:get(self.path)
    if not pendingUpdate then
        error(
            __TS__New(Error, "FS: Pending update not found"),
            0
        )
    end
    if not pendingUpdate.isWriting then
        error(
            __TS__New(Error, "FS: Conflicting update"),
            0
        )
    end
    pendingUpdate.isWriting = false
    local throttleTime = pendingUpdate.throttleTime
    if (not throttleTime) or (throttleTime < Date:now()) then
        self:checkNextUpdate()
        return
    end
    pendingUpdate.throttleTimer = setTimeout(
        _G,
        function() return self:checkNextUpdate() end,
        throttleTime - Date:now()
    )
end
function FSPath.prototype.append(self, data, options)
    if options == nil then
        options = {}
    end
    if global.Config.nofswriting then
        return Promise:resolve()
    end
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:appendFile(
                self.path,
                data,
                options,
                function(____, err)
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(_G) end))()
                end
            )
        end
    )
end
function FSPath.prototype.appendSync(self, data, options)
    if options == nil then
        options = {}
    end
    if global.Config.nofswriting then
        return
    end
    return fs:appendFileSync(self.path, data, options)
end
function FSPath.prototype.symlinkTo(self, target)
    if global.Config.nofswriting then
        return Promise:resolve()
    end
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:symlink(
                target,
                self.path,
                function(____, err)
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(_G) end))()
                end
            )
        end
    )
end
function FSPath.prototype.symlinkToSync(self, target)
    if global.Config.nofswriting then
        return
    end
    return fs:symlinkSync(target, self.path)
end
function FSPath.prototype.copyFile(self, dest)
    if global.Config.nofswriting then
        return Promise:resolve()
    end
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:copyFile(
                self.path,
                dest,
                function(____, err)
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(_G) end))()
                end
            )
        end
    )
end
function FSPath.prototype.rename(self, target)
    if global.Config.nofswriting then
        return Promise:resolve()
    end
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:rename(
                self.path,
                target,
                function(____, err)
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(_G) end))()
                end
            )
        end
    )
end
function FSPath.prototype.renameSync(self, target)
    if global.Config.nofswriting then
        return
    end
    return fs:renameSync(self.path, target)
end
function FSPath.prototype.readdir(self)
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:readdir(
                self.path,
                function(____, err, data)
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(_G, data) end))()
                end
            )
        end
    )
end
function FSPath.prototype.readdirSync(self)
    return fs:readdirSync(self.path)
end
function FSPath.prototype.createReadStream(self)
    return __TS__New(FileReadStream, self.path)
end
function FSPath.prototype.createWriteStream(self, options)
    if options == nil then
        options = {}
    end
    if global.Config.nofswriting then
        return __TS__New(
            WriteStream,
            {
                write = function(self)
                end
            }
        )
    end
    return __TS__New(
        WriteStream,
        fs:createWriteStream(self.path, options)
    )
end
function FSPath.prototype.createAppendStream(self, options)
    if options == nil then
        options = {}
    end
    if global.Config.nofswriting then
        return __TS__New(
            WriteStream,
            {
                write = function(self)
                end
            }
        )
    end
    options.flags = options.flags or "a"
    return __TS__New(
        WriteStream,
        fs:createWriteStream(self.path, options)
    )
end
function FSPath.prototype.unlinkIfExists(self)
    if global.Config.nofswriting then
        return Promise:resolve()
    end
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:unlink(
                self.path,
                function(____, err)
                    if err and (err.code == "ENOENT") then
                        return resolve(_G)
                    end
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(_G) end))()
                end
            )
        end
    )
end
function FSPath.prototype.unlinkIfExistsSync(self)
    if global.Config.nofswriting then
        return
    end
    do
        local ____try, err = pcall(
            function()
                fs:unlinkSync(self.path)
            end
        )
        if not ____try then
            if err.code ~= "ENOENT" then
                error(err, 0)
            end
        end
    end
end
function FSPath.prototype.rmdir(self, recursive)
    if global.Config.nofswriting then
        return Promise:resolve()
    end
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:rmdir(
                self.path,
                {recursive = recursive},
                function(____, err)
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(_G) end))()
                end
            )
        end
    )
end
function FSPath.prototype.rmdirSync(self, recursive)
    if global.Config.nofswriting then
        return
    end
    return fs:rmdirSync(self.path, {recursive = recursive})
end
function FSPath.prototype.mkdir(self, mode)
    if mode == nil then
        mode = 493
    end
    if global.Config.nofswriting then
        return Promise:resolve()
    end
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:mkdir(
                self.path,
                mode,
                function(____, err)
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(_G) end))()
                end
            )
        end
    )
end
function FSPath.prototype.mkdirSync(self, mode)
    if mode == nil then
        mode = 493
    end
    if global.Config.nofswriting then
        return
    end
    return fs:mkdirSync(self.path, mode)
end
function FSPath.prototype.mkdirIfNonexistent(self, mode)
    if mode == nil then
        mode = 493
    end
    if global.Config.nofswriting then
        return Promise:resolve()
    end
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:mkdir(
                self.path,
                mode,
                function(____, err)
                    if err and (err.code == "EEXIST") then
                        return resolve(_G)
                    end
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(_G) end))()
                end
            )
        end
    )
end
function FSPath.prototype.mkdirIfNonexistentSync(self, mode)
    if mode == nil then
        mode = 493
    end
    if global.Config.nofswriting then
        return
    end
    do
        local ____try, err = pcall(
            function()
                fs:mkdirSync(self.path, mode)
            end
        )
        if not ____try then
            if err.code ~= "EEXIST" then
                error(err, 0)
            end
        end
    end
end
function FSPath.prototype.mkdirp(self, mode)
    if mode == nil then
        mode = 493
    end
    do
        local ____try, err = pcall(
            function()
                local ____ = nil
            end
        )
        if not ____try then
            if err.code ~= "ENOENT" then
                error(err, 0)
            end
            local ____ = nil
            local ____ = nil
        end
    end
end
function FSPath.prototype.mkdirpSync(self, mode)
    if mode == nil then
        mode = 493
    end
    do
        local ____try, err = pcall(
            function()
                self:mkdirIfNonexistentSync(mode)
            end
        )
        if not ____try then
            if err.code ~= "ENOENT" then
                error(err, 0)
            end
            self:parentDir():mkdirpSync(mode)
            self:mkdirIfNonexistentSync(mode)
        end
    end
end
function FSPath.prototype.onModify(self, callback)
    fs:watchFile(
        self.path,
        function(____, curr, prev)
            if curr.mtime > prev.mtime then
                return callback(_G)
            end
        end
    )
end
function FSPath.prototype.unwatch(self)
    fs:unwatchFile(self.path)
end
function FSPath.prototype.isFile(self)
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:stat(
                self.path,
                function(____, err, stats)
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(
                        _G,
                        stats:isFile()
                    ) end))()
                end
            )
        end
    )
end
function FSPath.prototype.isFileSync(self)
    return fs:statSync(self.path):isFile()
end
function FSPath.prototype.isDirectory(self)
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:stat(
                self.path,
                function(____, err, stats)
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(
                        _G,
                        stats:isDirectory()
                    ) end))()
                end
            )
        end
    )
end
function FSPath.prototype.isDirectorySync(self)
    return fs:statSync(self.path):isDirectory()
end
function FSPath.prototype.realpath(self)
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:realpath(
                self.path,
                function(____, err, path)
                    ((err and (function() return reject(_G, err) end)) or (function() return resolve(_G, path) end))()
                end
            )
        end
    )
end
function FSPath.prototype.realpathSync(self)
    return fs:realpathSync(self.path)
end
FileReadStream = __TS__Class()
FileReadStream.name = "FileReadStream"
__TS__ClassExtends(FileReadStream, ReadStream)
function FileReadStream.prototype.____constructor(self, file)
    ReadStream.prototype.____constructor(self)
    self.fd = __TS__New(
        Promise,
        function(____, resolve, reject)
            fs:open(
                file,
                "r",
                function(____, err, fd) return ((err and (function() return reject(_G, err) end)) or (function() return resolve(_G, fd) end))() end
            )
        end
    )
    self.atEOF = false
end
function FileReadStream.prototype._read(self, size)
    if size == nil then
        size = 16384
    end
    return __TS__New(
        Promise,
        function(____, resolve, reject)
            if self.atEOF then
                return resolve(_G)
            end
            self:ensureCapacity(size)
            local ____ = nil
        end
    )
end
function FileReadStream.prototype._destroy(self)
    return __TS__New(
        Promise,
        function(____, resolve)
            local ____ = nil
        end
    )
end
local function getFs(self, path)
    return __TS__New(____exports.FSPath, path)
end
____exports.FS = __TS__ObjectAssign(getFs, {FileReadStream = FileReadStream, FSPath = ____exports.FSPath})
return ____exports
