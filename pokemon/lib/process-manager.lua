--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
--local child_process = require("lib.child_process")
--local cluster = require("lib.cluster")
--local path = require("lib.path") -- none of the above exist
local Streams = require("lib.streams")
local ROOT_DIR = "" -- path:resolve(__dirname, "..") -- nor this
____exports.processManagers = {}
____exports.disabled = false
function ____exports.exec(self, args, execOptions)
    if __TS__ArrayIsArray(args) then
        local cmd = __TS__ArrayShift(args)
        if not cmd then
            error(
                __TS__New(Error, "You must pass a command to ProcessManager.exec."),
                0
            )
        end
        return __TS__New(
            Promise,
            function(____, resolve, reject)
                child_process:execFile(
                    cmd,
                    args,
                    execOptions,
                    function(____, err, stdout, stderr)
                        if err then
                            reject(_G, err)
                        end
                        if type(stdout) ~= "string" then
                            stdout = tostring(stdout)
                        end
                        if type(stderr) ~= "string" then
                            stderr = tostring(stderr)
                        end
                        resolve(_G, {stdout = stdout, stderr = stderr})
                    end
                )
            end
        )
    else
        return __TS__New(
            Promise,
            function(____, resolve, reject)
                child_process:exec(
                    args,
                    execOptions,
                    function(____, ____error, stdout, stderr)
                        if ____error then
                            reject(_G, ____error)
                        end
                        if type(stdout) ~= "string" then
                            stdout = tostring(stdout)
                        end
                        resolve(_G, stdout)
                    end
                )
            end
        )
    end
end
local SubprocessStream = __TS__Class()
SubprocessStream.name = "SubprocessStream"
__TS__ClassExtends(SubprocessStream, Streams.ObjectReadWriteStream)
function SubprocessStream.prototype.____constructor(self, process, taskId)
    SubprocessStream.____super.prototype.____constructor(self)
    self.process = process
    self.taskId = taskId
    self.process.process:send(
        tostring(taskId) .. "\nNEW"
    )
end
function SubprocessStream.prototype._write(self, message)
    if not self.process.process.connected then
        self:pushError(
            __TS__New(Error, "Process disconnected (possibly crashed?)")
        )
        return
    end
    self.process.process:send(
        (tostring(self.taskId) .. "\nWRITE\n") .. message
    )
end
function SubprocessStream.prototype._writeEnd(self)
    self.process.process:send(
        tostring(self.taskId) .. "\nWRITEEND"
    )
end
function SubprocessStream.prototype._destroy(self)
    if not self.process.process.connected then
        return
    end
    self.process.process:send(
        tostring(self.taskId) .. "\nDESTROY"
    )
    self.process:deleteStream(self.taskId)
    self.process = nil
end
local RawSubprocessStream = __TS__Class()
RawSubprocessStream.name = "RawSubprocessStream"
__TS__ClassExtends(RawSubprocessStream, Streams.ObjectReadWriteStream)
function RawSubprocessStream.prototype.____constructor(self, process)
    RawSubprocessStream.____super.prototype.____constructor(self)
    self.process = process
end
function RawSubprocessStream.prototype._write(self, message)
    if not self.process:getProcess().connected then
        return
    end
    self.process.process:send(message)
end
____exports.QueryProcessWrapper = __TS__Class()
local QueryProcessWrapper = ____exports.QueryProcessWrapper
QueryProcessWrapper.name = "QueryProcessWrapper"
function QueryProcessWrapper.prototype.____constructor(self, file, messageCallback)
    self.process = child_process:fork(file, {}, {cwd = ROOT_DIR})
    self.taskId = 0
    self.pendingTasks = __TS__New(Map)
    self.pendingRelease = nil
    self.resolveRelease = nil
    self.messageCallback = messageCallback or nil
    self.process:on(
        "message",
        function(____, message)
            if message:startsWith("THROW\n") then
                local ____error = __TS__New(Error)
                ____error.stack = string.sub(message, 7)
                error(____error, 0)
            end
            if message:startsWith("DEBUG\n") then
                self.debug = string.sub(message, 7)
                return
            end
            if self.messageCallback and message:startsWith("CALLBACK\n") then
                self:messageCallback(
                    string.sub(message, 10)
                )
                return
            end
            local nlLoc = (string.find(message, "\n", nil, true) or 0) - 1
            if nlLoc <= 0 then
                error(
                    __TS__New(Error, "Invalid response " .. message),
                    0
                )
            end
            local taskId = __TS__ParseInt(
                __TS__StringSlice(message, 0, nlLoc)
            )
            local resolve = self.pendingTasks:get(taskId)
            if not resolve then
                error(
                    __TS__New(
                        Error,
                        "Invalid taskId " .. __TS__StringSlice(message, 0, nlLoc)
                    ),
                    0
                )
            end
            self.pendingTasks:delete(taskId)
            resolve(
                _G,
                JSON:parse(
                    __TS__StringSlice(message, nlLoc + 1)
                )
            )
            if self.resolveRelease and (not self:getLoad()) then
                self:destroy()
            end
        end
    )
end
function QueryProcessWrapper.prototype.getProcess(self)
    return self.process
end
function QueryProcessWrapper.prototype.getLoad(self)
    return self.pendingTasks.size
end
function QueryProcessWrapper.prototype.query(self, input)
    self.taskId = self.taskId + 1
    local taskId = self.taskId
    self.process:send(
        (tostring(taskId) .. "\n") .. JSON:stringify(input)
    )
    return __TS__New(
        Promise,
        function(____, resolve)
            self.pendingTasks:set(taskId, resolve)
        end
    )
end
function QueryProcessWrapper.prototype.release(self)
    if self.pendingRelease then
        return self.pendingRelease
    end
    if not self:getLoad() then
        self:destroy()
    else
        self.pendingRelease = __TS__New(
            Promise,
            function(____, resolve)
                self.resolveRelease = resolve
            end
        )
    end
    return self.pendingRelease
end
function QueryProcessWrapper.prototype.destroy(self)
    if self.pendingRelease and (not self.resolveRelease) then
        return
    end
    self.process:disconnect()
    for ____, resolver in __TS__Iterator(
        self.pendingTasks:values()
    ) do
        resolver(_G, "")
    end
    self.pendingTasks:clear()
    if self.resolveRelease then
        self:resolveRelease()
        self.resolveRelease = nil
    elseif not self.pendingRelease then
        self.pendingRelease = Promise:resolve()
    end
end
____exports.StreamProcessWrapper = __TS__Class()
local StreamProcessWrapper = ____exports.StreamProcessWrapper
StreamProcessWrapper.name = "StreamProcessWrapper"
function StreamProcessWrapper.prototype.____constructor(self, file, messageCallback)
    self.taskId = 0
    self.activeStreams = __TS__New(Map)
    self.pendingRelease = nil
    self.resolveRelease = nil
    self.process = child_process:fork(file, {}, {cwd = ROOT_DIR})
    self.messageCallback = messageCallback
    self.process:on(
        "message",
        function(____, message)
            if message:startsWith("THROW\n") then
                local ____error = __TS__New(Error)
                ____error.stack = string.sub(message, 7)
                error(____error, 0)
            end
            if self.messageCallback and message:startsWith("CALLBACK\n") then
                self:messageCallback(
                    string.sub(message, 10)
                )
                return
            end
            if message:startsWith("DEBUG\n") then
                self:setDebug(
                    string.sub(message, 7)
                )
                return
            end
            local nlLoc = (string.find(message, "\n", nil, true) or 0) - 1
            if nlLoc <= 0 then
                error(
                    __TS__New(Error, "Invalid response " .. message),
                    0
                )
            end
            local taskId = __TS__ParseInt(
                __TS__StringSlice(message, 0, nlLoc)
            )
            local stream = self.activeStreams:get(taskId)
            if not stream then
                return
            end
            message = __TS__StringSlice(message, nlLoc + 1)
            nlLoc = (string.find(message, "\n", nil, true) or 0) - 1
            if nlLoc < 0 then
                nlLoc = #message
            end
            local messageType = __TS__StringSlice(message, 0, nlLoc)
            message = __TS__StringSlice(message, nlLoc + 1)
            if messageType == "END" then
                stream:pushEnd()
                self:deleteStream(taskId)
                return
            elseif messageType == "PUSH" then
                stream:push(message)
            elseif messageType == "THROW" then
                local ____error = __TS__New(Error)
                ____error.stack = message
                stream:pushError(____error, true)
            else
                error(
                    __TS__New(Error, "Unrecognized messageType " .. messageType),
                    0
                )
            end
        end
    )
end
function StreamProcessWrapper.prototype.setDebug(self, message)
    self.debug = (tostring(
        string.sub(self.debug or "", -32768)
    ) .. "\n=====\n") .. tostring(message)
end
function StreamProcessWrapper.prototype.getLoad(self)
    return self.activeStreams.size
end
function StreamProcessWrapper.prototype.getProcess(self)
    return self.process
end
function StreamProcessWrapper.prototype.deleteStream(self, taskId)
    self.activeStreams:delete(taskId)
    if self.resolveRelease and (not self:getLoad()) then
        local ____ = nil
    end
end
function StreamProcessWrapper.prototype.createStream(self)
    self.taskId = self.taskId + 1
    local taskId = self.taskId
    local stream = __TS__New(SubprocessStream, self, taskId)
    self.activeStreams:set(taskId, stream)
    return stream
end
function StreamProcessWrapper.prototype.release(self)
    if self.pendingRelease then
        return self.pendingRelease
    end
    if not self:getLoad() then
        local ____ = nil
    else
        self.pendingRelease = __TS__New(
            Promise,
            function(____, resolve)
                self.resolveRelease = resolve
            end
        )
    end
    return self.pendingRelease
end
function StreamProcessWrapper.prototype.destroy(self)
    if self.pendingRelease and (not self.resolveRelease) then
        return
    end
    self.process:disconnect()
    local destroyed = {}
    for ____, stream in __TS__Iterator(
        self.activeStreams:values()
    ) do
        __TS__ArrayPush(
            destroyed,
            stream:destroy()
        )
    end
    self.activeStreams:clear()
    if self.resolveRelease then
        self:resolveRelease()
        self.resolveRelease = nil
    elseif not self.pendingRelease then
        self.pendingRelease = Promise:resolve()
    end
    return Promise:all(destroyed)
end
____exports.StreamWorker = __TS__Class()
local StreamWorker = ____exports.StreamWorker
StreamWorker.name = "StreamWorker"
function StreamWorker.prototype.____constructor(self, stream)
    self.load = 0
    self.workerid = 0
    self.stream = stream
end
____exports.RawProcessWrapper = __TS__Class()
local RawProcessWrapper = ____exports.RawProcessWrapper
RawProcessWrapper.name = "RawProcessWrapper"
function RawProcessWrapper.prototype.____constructor(self, file, isCluster, env)
    self.taskId = 0
    self.pendingRelease = nil
    self.resolveRelease = nil
    self.workerid = 0
    self.load = 0
    if isCluster then
        self.process = cluster:fork(env)
        self.workerid = self.process.id
    else
        self.process = child_process:fork(file, {}, {cwd = ROOT_DIR, env = env})
    end
    self.process:on(
        "message",
        function(____, message)
            self.stream:push(message)
        end
    )
    self.stream = __TS__New(RawSubprocessStream, self)
end
function RawProcessWrapper.prototype.setDebug(self, message)
    self.debug = (tostring(
        string.sub(self.debug or "", -32768)
    ) .. "\n=====\n") .. tostring(message)
end
function RawProcessWrapper.prototype.getLoad(self)
    return self.load
end
function RawProcessWrapper.prototype.getProcess(self)
    return ((self.process.process and (function() return self.process.process end)) or (function() return self.process end))()
end
function RawProcessWrapper.prototype.release(self)
    if self.pendingRelease then
        return self.pendingRelease
    end
    if not self:getLoad() then
        local ____ = nil
    else
        self.pendingRelease = __TS__New(
            Promise,
            function(____, resolve)
                self.resolveRelease = resolve
            end
        )
    end
    return self.pendingRelease
end
function RawProcessWrapper.prototype.destroy(self)
    if self.pendingRelease and (not self.resolveRelease) then
        return
    end
    self.stream:destroy()
    self.process:disconnect()
    return
end
____exports.ProcessManager = __TS__Class()
local ProcessManager = ____exports.ProcessManager
ProcessManager.name = "ProcessManager"
function ProcessManager.prototype.____constructor(self, module)
    self.processes = {}
    self.releasingProcesses = {}
    self.crashedProcesses = {}
    self.crashTime = 0
    self.crashRespawnCount = 0
    self.module = module
    self.filename = module.filename
    self.basename = path:basename(module.filename)
    self.isParentProcess = (process.mainModule ~= module) or (not process.send)
    self:listen()
end
function ProcessManager.prototype.acquire(self)
    if not #self.processes then
        return nil
    end
    local lowestLoad = self.processes[1]
    for ____, process in ipairs(self.processes) do
        if process:getLoad() < lowestLoad:getLoad() then
            lowestLoad = process
        end
    end
    return lowestLoad
end
function ProcessManager.prototype.releaseCrashed(self, process)
    local index = __TS__ArrayIndexOf(self.processes, process)
    if index < 0 then
        return
    end
    __TS__ArraySplice(self.processes, index, 1)
    self:destroyProcess(process)
    local ____ = nil
    local now = Date:now()
    if self.crashTime and ((now - self.crashTime) > ((30 * 60) * 1000)) then
        self.crashTime = 0
        self.crashRespawnCount = 0
    end
    if not self.crashTime then
        self.crashTime = now
    end
    self.crashRespawnCount = self.crashRespawnCount + 1
    local ____ = nil
    __TS__ArrayPush(self.releasingProcesses, process)
    __TS__ArrayPush(self.crashedProcesses, process)
    if self.crashRespawnCount <= 5 then
        self:spawn(#self.processes + 1)
    end
end
function ProcessManager.prototype.unspawn(self)
    return Promise:all(
        __TS__ArrayMap(
            {
                __TS__Unpack(self.processes)
            },
            function(____, process) return self:unspawnOne(process) end
        )
    )
end
function ProcessManager.prototype.unspawnOne(self, process)
    if not process then
        return
    end
    self:destroyProcess(process)
    local processIndex = __TS__ArrayIndexOf(self.processes, process)
    if processIndex < 0 then
        error(
            __TS__New(Error, "Process inactive"),
            0
        )
    end
    __TS__ArraySplice(
        self.processes,
        __TS__ArrayIndexOf(self.processes, process),
        1
    )
    __TS__ArrayPush(self.releasingProcesses, process)
    local ____ = nil
    local index = __TS__ArrayIndexOf(self.releasingProcesses, process)
    if index < 0 then
        return
    end
    __TS__ArraySplice(self.releasingProcesses, index, 1)
end
function ProcessManager.prototype.spawn(self, count, force)
    if count == nil then
        count = 1
    end
    if not self.isParentProcess then
        return
    end
    if ____exports.disabled and (not force) then
        return
    end
    local spawnCount = count - #self.processes
    do
        local i = 0
        while i < spawnCount do
            self:spawnOne(force)
            i = i + 1
        end
    end
end
function ProcessManager.prototype.spawnOne(self, force)
    if not self.isParentProcess then
        error(
            __TS__New(Error, "Must use in parent process"),
            0
        )
    end
    if ____exports.disabled and (not force) then
        return nil
    end
    local process = self:createProcess()
    process.process:on(
        "disconnect",
        function() return self:releaseCrashed(process) end
    )
    __TS__ArrayPush(self.processes, process)
    return process
end
function ProcessManager.prototype.respawn(self, count)
    if count == nil then
        count = nil
    end
    if count == nil then
        count = #self.processes
    end
    local unspawned = self:unspawn()
    self:spawn(count)
    return unspawned
end
function ProcessManager.prototype.destroyProcess(self, process)
end
function ProcessManager.prototype.destroy(self)
    local index = __TS__ArrayIndexOf(____exports.processManagers, self)
    if index >= 0 then
        __TS__ArraySplice(____exports.processManagers, index, 1)
    end
    return self:unspawn()
end
____exports.QueryProcessManager = __TS__Class()
local QueryProcessManager = ____exports.QueryProcessManager
QueryProcessManager.name = "QueryProcessManager"
__TS__ClassExtends(QueryProcessManager, ____exports.ProcessManager)
function QueryProcessManager.prototype.____constructor(self, module, query, timeout, debugCallback)
    if timeout == nil then
        timeout = (15 * 60) * 1000
    end
    QueryProcessManager.____super.prototype.____constructor(self, module)
    self._query = query
    self.timeout = timeout
    self.messageCallback = debugCallback
    __TS__ArrayPush(____exports.processManagers, self)
end
function QueryProcessManager.prototype.query(self, input, process)
    if process == nil then
        process = self:acquire()
    end
    if not process then
        return self:_query(input)
    end
    local timeout = setTimeout(
        _G,
        function()
            local debugInfo = process.debug or "No debug information found."
            process:destroy()
            error(
                __TS__New(Error, (("A query originating in " .. self.basename) .. " took too long to complete; the process has been killed.\n") .. debugInfo),
                0
            )
        end,
        self.timeout
    )
    local result = nil
    clearTimeout(_G, timeout)
    return result
end
function QueryProcessManager.prototype.queryTemporaryProcess(self, input, force)
    local process = self:spawnOne(force)
    local result = self:query(input, process)
    local ____ = nil
    return result
end
function QueryProcessManager.prototype.createProcess(self)
    return __TS__New(____exports.QueryProcessWrapper, self.filename, self.messageCallback)
end
function QueryProcessManager.prototype.listen(self)
    if self.isParentProcess then
        return
    end
    process:on(
        "message",
        function(____, message)
            local nlLoc = (string.find(message, "\n", nil, true) or 0) - 1
            if nlLoc <= 0 then
                error(
                    __TS__New(Error, "Invalid response " .. message),
                    0
                )
            end
            local taskId = __TS__StringSlice(message, 0, nlLoc)
            message = __TS__StringSlice(message, nlLoc + 1)
            if taskId:startsWith("EVAL") then
                process.send(
                    _G,
                    (taskId .. "\n") .. tostring(
                        eval(_G, message)
                    )
                )
                return
            end
            local ____ = nil
        end
    )
    process:on(
        "disconnect",
        function()
            process:exit()
        end
    )
end
____exports.StreamProcessManager = __TS__Class()
local StreamProcessManager = ____exports.StreamProcessManager
StreamProcessManager.name = "StreamProcessManager"
__TS__ClassExtends(StreamProcessManager, ____exports.ProcessManager)
function StreamProcessManager.prototype.____constructor(self, module, createStream, messageCallback)
    StreamProcessManager.____super.prototype.____constructor(self, module)
    self.activeStreams = __TS__New(Map)
    self._createStream = createStream
    self.messageCallback = messageCallback
    __TS__ArrayPush(____exports.processManagers, self)
end
function StreamProcessManager.prototype.createStream(self)
    local process = self:acquire()
    if not process then
        return self:_createStream()
    end
    return process:createStream()
end
function StreamProcessManager.prototype.createProcess(self)
    return __TS__New(____exports.StreamProcessWrapper, self.filename, self.messageCallback)
end
function StreamProcessManager.prototype.pipeStream(self, taskId, stream)
    local done = false
    while not done do
        do
            local ____try, err = pcall(
                function()
                    local value;
                    (function()
                        local ____ = nil
                        value = ____.value
                        done = ____.done
                        return ____
                    end)()
                    process.send(
                        _G,
                        (taskId .. "\nPUSH\n") .. tostring(value)
                    )
                end
            )
            if not ____try then
                process.send(
                    _G,
                    (taskId .. "\nTHROW\n") .. tostring(err.stack)
                )
            end
        end
    end
    if not self.activeStreams:has(taskId) then
        return
    end
    process.send(_G, taskId .. "\nEND")
    self.activeStreams:delete(taskId)
end
function StreamProcessManager.prototype.listen(self)
    if self.isParentProcess then
        return
    end
    process:on(
        "message",
        function(____, message)
            local nlLoc = (string.find(message, "\n", nil, true) or 0) - 1
            if nlLoc <= 0 then
                error(
                    __TS__New(Error, "Invalid request " .. message),
                    0
                )
            end
            local taskId = __TS__StringSlice(message, 0, nlLoc)
            local stream = self.activeStreams:get(taskId)
            message = __TS__StringSlice(message, nlLoc + 1)
            nlLoc = (string.find(message, "\n", nil, true) or 0) - 1
            if nlLoc < 0 then
                nlLoc = #message
            end
            local messageType = __TS__StringSlice(message, 0, nlLoc)
            message = __TS__StringSlice(message, nlLoc + 1)
            if taskId:startsWith("EVAL") then
                process.send(
                    _G,
                    (taskId .. "\n") .. tostring(
                        eval(_G, message)
                    )
                )
                return
            end
            if messageType == "NEW" then
                if stream then
                    error(
                        __TS__New(Error, ("NEW: taskId " .. taskId) .. " already exists"),
                        0
                    )
                end
                local newStream = self:_createStream()
                self.activeStreams:set(taskId, newStream)
                local ____ = nil
            elseif messageType == "DESTROY" then
                if not stream then
                    error(
                        __TS__New(Error, "DESTROY: Invalid taskId " .. taskId),
                        0
                    )
                end
                local ____ = nil
                self.activeStreams:delete(taskId)
            elseif messageType == "WRITE" then
                if not stream then
                    error(
                        __TS__New(Error, "WRITE: Invalid taskId " .. taskId),
                        0
                    )
                end
                local ____ = nil
            elseif messageType == "WRITEEND" then
                if not stream then
                    error(
                        __TS__New(Error, "WRITEEND: Invalid taskId " .. taskId),
                        0
                    )
                end
                local ____ = nil
            else
                error(
                    __TS__New(Error, "Unrecognized messageType " .. messageType),
                    0
                )
            end
        end
    )
    process:on(
        "disconnect",
        function()
            process:exit()
        end
    )
end
____exports.RawProcessManager = __TS__Class()
local RawProcessManager = ____exports.RawProcessManager
RawProcessManager.name = "RawProcessManager"
__TS__ClassExtends(RawProcessManager, ____exports.ProcessManager)
function RawProcessManager.prototype.____constructor(self, options)
    RawProcessManager.____super.prototype.____constructor(self, options.module)
    self.workers = {}
    self.masterWorker = nil
    self.activeStream = nil
    self.spawnSubscription = nil
    self.unspawnSubscription = nil
    self.workerid = cluster.worker.id or 0
    self.isCluster = not (not options.isCluster)
    self._setupChild = options.setupChild
    self.env = options.env
    if self.isCluster and self.isParentProcess then
        cluster:setupMaster({exec = self.filename, cwd = ROOT_DIR})
    end
    __TS__ArrayPush(____exports.processManagers, self)
end
function RawProcessManager.prototype.subscribeSpawn(self, callback)
    self.spawnSubscription = callback
end
function RawProcessManager.prototype.subscribeUnspawn(self, callback)
    self.unspawnSubscription = callback
end
function RawProcessManager.prototype.spawn(self, count)
    RawProcessManager.____super.prototype.spawn(self, count)
    if not #self.workers then
        self.masterWorker = __TS__New(
            ____exports.StreamWorker,
            self:_setupChild()
        )
        __TS__ArrayPush(self.workers, self.masterWorker)
        self:spawnSubscription(self.masterWorker)
    end
end
function RawProcessManager.prototype.createProcess(self)
    local process = __TS__New(____exports.RawProcessWrapper, self.filename, self.isCluster, self.env)
    __TS__ArrayPush(self.workers, process)
    self:spawnSubscription(process)
    return process
end
function RawProcessManager.prototype.destroyProcess(self, process)
    local index = __TS__ArrayIndexOf(self.workers, process)
    if index >= 0 then
        __TS__ArraySplice(self.workers, index, 1)
    end
    self:unspawnSubscription(process)
end
function RawProcessManager.prototype.pipeStream(self, stream)
    local done = false
    while not done do
        do
            local ____try, err = pcall(
                function()
                    local value;
                    (function()
                        local ____ = nil
                        value = ____.value
                        done = ____.done
                        return ____
                    end)()
                    process.send(_G, value)
                end
            )
            if not ____try then
                process.send(
                    _G,
                    "THROW\n" .. tostring(err.stack)
                )
            end
        end
    end
end
function RawProcessManager.prototype.listen(self)
    if self.isParentProcess then
        return
    end
    setImmediate(
        _G,
        function()
            self.activeStream = self:_setupChild()
            local ____ = nil
        end
    )
    process:on(
        "message",
        function(____, message)
            local ____ = nil
        end
    )
    process:on(
        "disconnect",
        function()
            process:exit()
        end
    )
end
return ____exports
