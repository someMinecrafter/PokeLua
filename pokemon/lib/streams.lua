--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local BUF_SIZE = 65536 * 4
____exports.ReadStream = __TS__Class()
local ReadStream = ____exports.ReadStream
ReadStream.name = "ReadStream"
function ReadStream.prototype.____constructor(self, optionsOrStreamLike)
    if optionsOrStreamLike == nil then
        optionsOrStreamLike = {}
    end
    self.buf = Buffer:allocUnsafe(BUF_SIZE)
    self.bufStart = 0
    self.bufEnd = 0
    self.bufCapacity = BUF_SIZE
    self.readSize = 0
    self.atEOF = false
    self.errorBuf = nil
    self.encoding = "utf8"
    self.isReadable = true
    self.isWritable = false
    self.nodeReadableStream = nil
    self.nextPushResolver = nil
    self.nextPush = __TS__New(
        Promise,
        function(____, resolve)
            self.nextPushResolver = resolve
        end
    )
    self.awaitingPush = false
    local options
    if type(optionsOrStreamLike) == "string" then
        options = {buffer = optionsOrStreamLike}
    elseif __TS__InstanceOf(optionsOrStreamLike, Buffer) then
        options = {buffer = optionsOrStreamLike}
    elseif type(optionsOrStreamLike._readableState) == "table" then
        options = {nodeStream = optionsOrStreamLike}
    else
        options = optionsOrStreamLike
    end
    if options.nodeStream then
        local nodeStream = options.nodeStream
        self.nodeReadableStream = nodeStream
        nodeStream:on(
            "data",
            function(____, data)
                self:push(data)
            end
        )
        nodeStream:on(
            "end",
            function()
                self:pushEnd()
            end
        )
        options.read = function(self, unusedBytes)
            self.nodeReadableStream:resume()
        end
        options.pause = function(self, unusedBytes)
            self.nodeReadableStream:pause()
        end
    end
    if options.read then
        self._read = options.read
    end
    if options.pause then
        self._pause = options.pause
    end
    if options.destroy then
        self._destroy = options.destroy
    end
    if options.encoding then
        self.encoding = options.encoding
    end
    if options.buffer ~= nil then
        self:push(options.buffer)
        self:pushEnd()
    end
end
__TS__SetDescriptor(
    ReadStream.prototype,
    "bufSize",
    {
        get = function(self)
            return self.bufEnd - self.bufStart
        end
    },
    true
)
function ReadStream.prototype.moveBuf(self)
    if self.bufStart ~= self.bufEnd then
        self.buf:copy(self.buf, 0, self.bufStart, self.bufEnd)
    end
    self.bufEnd = self.bufEnd - self.bufStart
    self.bufStart = 0
end
function ReadStream.prototype.expandBuf(self, newCapacity)
    if newCapacity == nil then
        newCapacity = self.bufCapacity * 2
    end
    local newBuf = Buffer:allocUnsafe(newCapacity)
    self.buf:copy(newBuf, 0, self.bufStart, self.bufEnd)
    self.bufEnd = self.bufEnd - self.bufStart
    self.bufStart = 0
    self.bufCapacity = newCapacity
    self.buf = newBuf
end
function ReadStream.prototype.ensureCapacity(self, additionalCapacity)
    if (self.bufEnd + additionalCapacity) <= self.bufCapacity then
        return
    end
    local capacity = (self.bufEnd - self.bufStart) + additionalCapacity
    if capacity <= self.bufCapacity then
        return self:moveBuf()
    end
    local newCapacity = self.bufCapacity * 2
    while newCapacity < capacity do
        newCapacity = newCapacity * 2
    end
    self:expandBuf(newCapacity)
end
function ReadStream.prototype.push(self, buf, encoding)
    if encoding == nil then
        encoding = self.encoding
    end
    local size
    if self.atEOF then
        return
    end
    if type(buf) == "string" then
        size = Buffer:byteLength(buf, encoding)
        self:ensureCapacity(size)
        self.buf:write(buf, self.bufEnd)
    else
        size = buf.length
        self:ensureCapacity(size)
        buf:copy(self.buf, self.bufEnd)
    end
    self.bufEnd = self.bufEnd + size
    if (self.bufSize > self.readSize) and ((size * 2) < self.bufSize) then
        self:_pause()
    end
    self:resolvePush()
end
function ReadStream.prototype.pushEnd(self)
    self.atEOF = true
    self:resolvePush()
end
function ReadStream.prototype.pushError(self, err, recoverable)
    if not self.errorBuf then
        self.errorBuf = {}
    end
    __TS__ArrayPush(self.errorBuf, err)
    if not recoverable then
        self.atEOF = true
    end
    self:resolvePush()
end
function ReadStream.prototype.readError(self)
    if self.errorBuf then
        local err = __TS__ArrayShift(self.errorBuf)
        if not #self.errorBuf then
            self.errorBuf = nil
        end
        error(err, 0)
    end
end
function ReadStream.prototype.peekError(self)
    if self.errorBuf then
        error(self.errorBuf[1], 0)
    end
end
function ReadStream.prototype.resolvePush(self)
    if not self.nextPushResolver then
        error(
            __TS__New(Error, "Push after end of read stream"),
            0
        )
    end
    self:nextPushResolver()
    if self.atEOF then
        self.nextPushResolver = nil
        return
    end
    self.nextPush = __TS__New(
        Promise,
        function(____, resolve)
            self.nextPushResolver = resolve
        end
    )
end
function ReadStream.prototype._read(self, size)
    if size == nil then
        size = 0
    end
    error(
        __TS__New(Error, "ReadStream needs to be subclassed and the _read function needs to be implemented."),
        0
    )
end
function ReadStream.prototype._destroy(self)
end
function ReadStream.prototype._pause(self)
end
function ReadStream.prototype.loadIntoBuffer(self, byteCount, readError)
    if byteCount == nil then
        byteCount = nil
    end
    self[(readError and "readError") or "peekError"](self)
    if byteCount == 0 then
        return
    end
    self.readSize = math.max(
        (((byteCount == true) and (function() return self.bufSize + 1 end)) or (function() return ((byteCount == nil) and 1) or byteCount end))(),
        self.readSize
    )
    if ((not self.errorBuf) and (not self.atEOF)) and (self.bufSize < self.readSize) then
        local bytes = self.readSize - self.bufSize
        if ((bytes == math.huge) or (byteCount == nil)) or (byteCount == true) then
            bytes = nil
        end
        return self:doLoad(bytes, readError)
    end
end
function ReadStream.prototype.doLoad(self, chunkSize, readError)
    while ((not self.errorBuf) and (not self.atEOF)) and (self.bufSize < self.readSize) do
        if chunkSize then
            local ____ = nil
        else
            local ____ = nil
        end
        local ____ = nil
        self[(readError and "readError") or "peekError"](self)
    end
end
function ReadStream.prototype.peek(self, byteCount, encoding)
    if byteCount == nil then
        byteCount = nil
    end
    if encoding == nil then
        encoding = self.encoding
    end
    if type(byteCount) == "string" then
        encoding = byteCount
        byteCount = nil
    end
    local maybeLoad = self:loadIntoBuffer(byteCount)
    if maybeLoad then
        return maybeLoad["then"](
            maybeLoad,
            function() return self:peek(byteCount, encoding) end
        )
    end
    if (not self.bufSize) and (byteCount ~= 0) then
        return nil
    end
    if byteCount == nil then
        return tostring(self.buf)
    end
    if byteCount > self.bufSize then
        byteCount = self.bufSize
    end
    return tostring(self.buf)
end
function ReadStream.prototype.peekBuffer(self, byteCount)
    if byteCount == nil then
        byteCount = nil
    end
    local maybeLoad = self:loadIntoBuffer(byteCount)
    if maybeLoad then
        return maybeLoad["then"](
            maybeLoad,
            function() return self:peekBuffer(byteCount) end
        )
    end
    if (not self.bufSize) and (byteCount ~= 0) then
        return nil
    end
    if byteCount == nil then
        return self.buf:slice(self.bufStart, self.bufEnd)
    end
    if byteCount > self.bufSize then
        byteCount = self.bufSize
    end
    return self.buf:slice(self.bufStart, self.bufStart + byteCount)
end
function ReadStream.prototype.read(self, byteCount, encoding)
    if byteCount == nil then
        byteCount = nil
    end
    if encoding == nil then
        encoding = self.encoding
    end
    if type(byteCount) == "string" then
        encoding = byteCount
        byteCount = nil
    end
    local ____ = nil
    local out = self:peek(byteCount, encoding)
    if out and (type(out) ~= "string") then
        error(
            __TS__New(Error, "Race condition; you must not read before a previous read has completed"),
            0
        )
    end
    if (byteCount == nil) or (byteCount >= self.bufSize) then
        self.bufStart = 0
        self.bufEnd = 0
        self.readSize = 0
    else
        self.bufStart = self.bufStart + byteCount
        self.readSize = self.readSize - byteCount
    end
    return out
end
function ReadStream.prototype.byChunk(self, byteCount)
    local byteStream = self
    return __TS__New(
        ____exports.ObjectReadStream,
        {
            read = function(self)
                local next = nil
                if type(next) == "string" then
                    self:push(next)
                else
                    self:pushEnd()
                end
            end
        }
    )
end
function ReadStream.prototype.byLine(self)
    local byteStream = self
    return __TS__New(
        ____exports.ObjectReadStream,
        {
            read = function(self)
                local next = nil
                if type(next) == "string" then
                    self:push(next)
                else
                    self:pushEnd()
                end
            end
        }
    )
end
function ReadStream.prototype.delimitedBy(self, delimiter)
    local byteStream = self
    return __TS__New(
        ____exports.ObjectReadStream,
        {
            read = function(self)
                local next = nil
                if type(next) == "string" then
                    self:push(next)
                else
                    self:pushEnd()
                end
            end
        }
    )
end
function ReadStream.prototype.readBuffer(self, byteCount)
    if byteCount == nil then
        byteCount = nil
    end
    local ____ = nil
    local out = self:peekBuffer(byteCount)
    if out and out["then"] then
        error(
            __TS__New(Error, "Race condition; you must not read before a previous read has completed"),
            0
        )
    end
    if (byteCount == nil) or (byteCount >= self.bufSize) then
        self.bufStart = 0
        self.bufEnd = 0
    else
        self.bufStart = self.bufStart + byteCount
    end
    return out
end
function ReadStream.prototype.indexOf(self, symbol, encoding)
    if encoding == nil then
        encoding = self.encoding
    end
    local idx = self.buf:indexOf(symbol, self.bufStart, encoding)
    while (not self.atEOF) and ((idx >= self.bufEnd) or (idx < 0)) do
        local ____ = nil
        idx = self.buf:indexOf(symbol, self.bufStart, encoding)
    end
    if idx >= self.bufEnd then
        return -1
    end
    return idx - self.bufStart
end
function ReadStream.prototype.readAll(self, encoding)
    if encoding == nil then
        encoding = self.encoding
    end
    return nil or ""
end
function ReadStream.prototype.peekAll(self, encoding)
    if encoding == nil then
        encoding = self.encoding
    end
    return self:peek(math.huge, encoding)
end
function ReadStream.prototype.readDelimitedBy(self, symbol, encoding)
    if encoding == nil then
        encoding = self.encoding
    end
    if self.atEOF and (not self.bufSize) then
        return nil
    end
    local idx = nil
    if idx < 0 then
        return self:readAll(encoding)
    else
        local out = nil
        self.bufStart = self.bufStart + Buffer:byteLength(symbol, "utf8")
        return out
    end
end
function ReadStream.prototype.readLine(self, encoding)
    if encoding == nil then
        encoding = self.encoding
    end
    if not encoding then
        error(
            __TS__New(Error, "readLine must have an encoding"),
            0
        )
    end
    local line = nil
    if line:endsWith("\r") then
        line = string.sub(line, 1, -2)
    end
    return line
end
function ReadStream.prototype.destroy(self)
    self.atEOF = true
    self.bufStart = 0
    self.bufEnd = 0
    if self.nextPushResolver then
        self:resolvePush()
    end
    return self:_destroy()
end
function ReadStream.prototype.next(self, byteCount)
    if byteCount == nil then
        byteCount = nil
    end
    local value = nil
    return {value = value, done = value == nil}
end
function ReadStream.prototype.pipeTo(self, outStream, options)
    if options == nil then
        options = {}
    end
    local value
    local done
    while (function()
        (function()
            local ____ = nil
            value = ____.value
            done = ____.done
            return ____
        end)()
        return not done
    end)() do
        local ____ = nil
    end
    if not options.noEnd then
        return outStream:writeEnd()
    end
end
____exports.WriteStream = __TS__Class()
local WriteStream = ____exports.WriteStream
WriteStream.name = "WriteStream"
function WriteStream.prototype.____constructor(self, optionsOrStream)
    if optionsOrStream == nil then
        optionsOrStream = {}
    end
    self.isReadable = false
    self.isWritable = true
    self.encoding = "utf8"
    self.nodeWritableStream = nil
    self.drainListeners = {}
    local options = optionsOrStream
    if options._writableState then
        options = {nodeStream = optionsOrStream}
    end
    if options.nodeStream then
        local nodeStream = options.nodeStream
        self.nodeWritableStream = nodeStream
        options.write = function(self, data)
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
        if (nodeStream ~= process.stdout) and (nodeStream ~= process.stderr) then
            options.writeEnd = function(self)
                return __TS__New(
                    Promise,
                    function(____, resolve)
                        (function()
                            local ____self = self.nodeWritableStream
                            return ____self["end"](
                                ____self,
                                function() return resolve(_G) end
                            )
                        end)()
                    end
                )
            end
        end
    end
    if options.write then
        self._write = options.write
    end
    if options.writeEnd then
        self._writeEnd = options.writeEnd
    end
end
function WriteStream.prototype.write(self, chunk)
    return self:_write(chunk)
end
function WriteStream.prototype.writeLine(self, chunk)
    if chunk == nil then
        return self:writeEnd()
    end
    return self:write(
        tostring(chunk) .. "\n"
    )
end
function WriteStream.prototype._write(self, chunk)
    error(
        __TS__New(Error, "WriteStream needs to be subclassed and the _write function needs to be implemented."),
        0
    )
end
function WriteStream.prototype._writeEnd(self)
end
function WriteStream.prototype.writeEnd(self, chunk)
    if chunk then
        local ____ = nil
    end
    return self:_writeEnd()
end
____exports.ReadWriteStream = __TS__Class()
local ReadWriteStream = ____exports.ReadWriteStream
ReadWriteStream.name = "ReadWriteStream"
__TS__ClassExtends(ReadWriteStream, ____exports.ReadStream)
function ReadWriteStream.prototype.____constructor(self, options)
    if options == nil then
        options = {}
    end
    ReadWriteStream.____super.prototype.____constructor(self, options)
    self.isReadable = true
    self.isWritable = true
    self.nodeWritableStream = nil
    self.drainListeners = {}
    if options.nodeStream then
        local nodeStream = options.nodeStream
        self.nodeWritableStream = nodeStream
        options.write = function(self, data)
            local result = self.nodeWritableStream:write(data)
            if result ~= false then
                return nil
            end
            if not self.drainListeners.length then
                self.nodeWritableStream:once(
                    "drain",
                    function()
                        for ____, listener in __TS__Iterator(self.drainListeners) do
                            listener(_G)
                        end
                        self.drainListeners = {}
                    end
                )
            end
            return __TS__New(
                Promise,
                function(____, resolve)
                    self.drainListeners:push(resolve)
                end
            )
        end
        if (nodeStream ~= process.stdout) and (nodeStream ~= process.stderr) then
            options.writeEnd = function(self)
                return __TS__New(
                    Promise,
                    function(____, resolve)
                        (function()
                            local ____self = self.nodeWritableStream
                            return ____self["end"](
                                ____self,
                                function() return resolve(_G) end
                            )
                        end)()
                    end
                )
            end
        end
    end
    if options.write then
        self._write = options.write
    end
    if options.writeEnd then
        self._writeEnd = options.writeEnd
    end
end
function ReadWriteStream.prototype.write(self, chunk)
    return self:_write(chunk)
end
function ReadWriteStream.prototype.writeLine(self, chunk)
    return self:write(
        tostring(chunk) .. "\n"
    )
end
function ReadWriteStream.prototype._write(self, chunk)
    error(
        __TS__New(Error, "WriteStream needs to be subclassed and the _write function needs to be implemented."),
        0
    )
end
function ReadWriteStream.prototype._read(self, size)
end
function ReadWriteStream.prototype._writeEnd(self)
end
function ReadWriteStream.prototype.writeEnd(self)
    return self:_writeEnd()
end
____exports.ObjectReadStream = __TS__Class()
local ObjectReadStream = ____exports.ObjectReadStream
ObjectReadStream.name = "ObjectReadStream"
function ObjectReadStream.prototype.____constructor(self, optionsOrStreamLike)
    if optionsOrStreamLike == nil then
        optionsOrStreamLike = {}
    end
    self.buf = {}
    self.readSize = 0
    self.atEOF = false
    self.errorBuf = nil
    self.isReadable = true
    self.isWritable = false
    self.nodeReadableStream = nil
    self.nextPushResolver = nil
    self.nextPush = __TS__New(
        Promise,
        function(____, resolve)
            self.nextPushResolver = resolve
        end
    )
    self.awaitingPush = false
    local options
    if __TS__ArrayIsArray(optionsOrStreamLike) then
        options = {buffer = optionsOrStreamLike}
    elseif type(optionsOrStreamLike._readableState) == "table" then
        options = {nodeStream = optionsOrStreamLike}
    else
        options = optionsOrStreamLike
    end
    if options.nodeStream then
        local nodeStream = options.nodeStream
        self.nodeReadableStream = nodeStream
        nodeStream:on(
            "data",
            function(____, data)
                self:push(data)
            end
        )
        nodeStream:on(
            "end",
            function()
                self:pushEnd()
            end
        )
        options = {
            read = function(self)
                self.nodeReadableStream:resume()
            end,
            pause = function(self)
                self.nodeReadableStream:pause()
            end
        }
    end
    if options.read then
        self._read = options.read
    end
    if options.pause then
        self._pause = options.pause
    end
    if options.destroy then
        self._destroy = options.destroy
    end
    if options.buffer ~= nil then
        self.buf = __TS__ArraySlice(options.buffer)
        self:pushEnd()
    end
end
function ObjectReadStream.prototype.push(self, elem)
    if self.atEOF then
        return
    end
    __TS__ArrayPush(self.buf, elem)
    if (#self.buf > self.readSize) and (#self.buf >= 16) then
        self:_pause()
    end
    self:resolvePush()
end
function ObjectReadStream.prototype.pushEnd(self)
    self.atEOF = true
    self:resolvePush()
end
function ObjectReadStream.prototype.pushError(self, err, recoverable)
    if not self.errorBuf then
        self.errorBuf = {}
    end
    __TS__ArrayPush(self.errorBuf, err)
    if not recoverable then
        self.atEOF = true
    end
    self:resolvePush()
end
function ObjectReadStream.prototype.readError(self)
    if self.errorBuf then
        local err = __TS__ArrayShift(self.errorBuf)
        if not #self.errorBuf then
            self.errorBuf = nil
        end
        error(err, 0)
    end
end
function ObjectReadStream.prototype.peekError(self)
    if self.errorBuf then
        error(self.errorBuf[1], 0)
    end
end
function ObjectReadStream.prototype.resolvePush(self)
    if not self.nextPushResolver then
        error(
            __TS__New(Error, "Push after end of read stream"),
            0
        )
    end
    self:nextPushResolver()
    if self.atEOF then
        self.nextPushResolver = nil
        return
    end
    self.nextPush = __TS__New(
        Promise,
        function(____, resolve)
            self.nextPushResolver = resolve
        end
    )
end
function ObjectReadStream.prototype._read(self, size)
    if size == nil then
        size = 0
    end
    error(
        __TS__New(Error, "ReadStream needs to be subclassed and the _read function needs to be implemented."),
        0
    )
end
function ObjectReadStream.prototype._destroy(self)
end
function ObjectReadStream.prototype._pause(self)
end
function ObjectReadStream.prototype.loadIntoBuffer(self, count, readError)
    if count == nil then
        count = 1
    end
    self[(readError and "readError") or "peekError"](self)
    if count == true then
        count = #self.buf + 1
    end
    if #self.buf >= count then
        return
    end
    self.readSize = math.max(count, self.readSize)
    while ((not self.errorBuf) and (not self.atEOF)) and (#self.buf < self.readSize) do
        local readResult = self:_read()
        if readResult then
            local ____ = nil
        else
            local ____ = nil
        end
        self[(readError and "readError") or "peekError"](self)
    end
end
function ObjectReadStream.prototype.peek(self)
    if #self.buf then
        return self.buf[1]
    end
    local ____ = nil
    return self.buf[1]
end
function ObjectReadStream.prototype.read(self)
    if #self.buf then
        return __TS__ArrayShift(self.buf)
    end
    local ____ = nil
    if not #self.buf then
        return nil
    end
    return __TS__ArrayShift(self.buf)
end
function ObjectReadStream.prototype.peekArray(self, count)
    if count == nil then
        count = nil
    end
    local ____ = nil
    return __TS__ArraySlice(
        self.buf,
        0,
        (((count == nil) and (function() return math.huge end)) or (function() return count end))()
    )
end
function ObjectReadStream.prototype.readArray(self, count)
    if count == nil then
        count = nil
    end
    local ____ = nil
    local out = __TS__ArraySlice(
        self.buf,
        0,
        (((count == nil) and (function() return math.huge end)) or (function() return count end))()
    )
    self.buf = __TS__ArraySlice(self.buf, #out)
    return out
end
function ObjectReadStream.prototype.readAll(self)
    local ____ = nil
    local out = self.buf
    self.buf = {}
    return out
end
function ObjectReadStream.prototype.peekAll(self)
    local ____ = nil
    return __TS__ArraySlice(self.buf)
end
function ObjectReadStream.prototype.destroy(self)
    self.atEOF = true
    self.buf = {}
    self:resolvePush()
    return self:_destroy()
end
ObjectReadStream.prototype[Symbol.asyncIterator] = function(self)
    return self
end
function ObjectReadStream.prototype.next(self)
    if #self.buf then
        return {
            value = __TS__ArrayShift(self.buf),
            done = false
        }
    end
    local ____ = nil
    if not #self.buf then
        return {value = nil, done = true}
    end
    return {
        value = __TS__ArrayShift(self.buf),
        done = false
    }
end
function ObjectReadStream.prototype.pipeTo(self, outStream, options)
    if options == nil then
        options = {}
    end
    local value
    local done
    while (function()
        (function()
            local ____ = nil
            value = ____.value
            done = ____.done
            return ____
        end)()
        return not done
    end)() do
        local ____ = nil
    end
    if not options.noEnd then
        return outStream:writeEnd()
    end
end
____exports.ObjectWriteStream = __TS__Class()
local ObjectWriteStream = ____exports.ObjectWriteStream
ObjectWriteStream.name = "ObjectWriteStream"
function ObjectWriteStream.prototype.____constructor(self, optionsOrStream)
    if optionsOrStream == nil then
        optionsOrStream = {}
    end
    self.isReadable = false
    self.isWritable = true
    self.nodeWritableStream = nil
    local options = optionsOrStream
    if options._writableState then
        options = {nodeStream = optionsOrStream}
    end
    if options.nodeStream then
        local nodeStream = options.nodeStream
        self.nodeWritableStream = nodeStream
        options.write = function(self, data)
            local result = self.nodeWritableStream:write(data)
            if result == false then
                return __TS__New(
                    Promise,
                    function(____, resolve)
                        self.nodeWritableStream:once(
                            "drain",
                            function()
                                resolve(_G)
                            end
                        )
                    end
                )
            end
        end
        if (nodeStream ~= process.stdout) and (nodeStream ~= process.stderr) then
            options.writeEnd = function(self)
                return __TS__New(
                    Promise,
                    function(____, resolve)
                        (function()
                            local ____self = self.nodeWritableStream
                            return ____self["end"](
                                ____self,
                                function() return resolve(_G) end
                            )
                        end)()
                    end
                )
            end
        end
    end
    if options.write then
        self._write = options.write
    end
    if options.writeEnd then
        self._writeEnd = options.writeEnd
    end
end
function ObjectWriteStream.prototype.write(self, elem)
    if elem == nil then
        return self:writeEnd()
    end
    return self:_write(elem)
end
function ObjectWriteStream.prototype._write(self, elem)
    error(
        __TS__New(Error, "WriteStream needs to be subclassed and the _write function needs to be implemented."),
        0
    )
end
function ObjectWriteStream.prototype._writeEnd(self)
end
function ObjectWriteStream.prototype.writeEnd(self, elem)
    if elem ~= nil then
        local ____ = nil
    end
    return self:_writeEnd()
end
____exports.ObjectReadWriteStream = __TS__Class()
local ObjectReadWriteStream = ____exports.ObjectReadWriteStream
ObjectReadWriteStream.name = "ObjectReadWriteStream"
__TS__ClassExtends(ObjectReadWriteStream, ____exports.ObjectReadStream)
function ObjectReadWriteStream.prototype.____constructor(self, options)
    if options == nil then
        options = {}
    end
    ObjectReadWriteStream.____super.prototype.____constructor(self, options)
    self.isReadable = true
    self.isWritable = true
    self.nodeWritableStream = nil
    if options.write then
        self._write = options.write
    end
    if options.writeEnd then
        self._writeEnd = options.writeEnd
    end
end
function ObjectReadWriteStream.prototype.write(self, elem)
    return self:_write(elem)
end
function ObjectReadWriteStream.prototype._write(self, elem)
    error(
        __TS__New(Error, "WriteStream needs to be subclassed and the _write function needs to be implemented."),
        0
    )
end
function ObjectReadWriteStream.prototype._read(self)
end
function ObjectReadWriteStream.prototype._writeEnd(self)
end
function ObjectReadWriteStream.prototype.writeEnd(self)
    return self:_writeEnd()
end
function ____exports.readAll(self, nodeStream, encoding)
    return __TS__New(____exports.ReadStream, nodeStream):readAll(encoding)
end
function ____exports.stdin(self)
    return __TS__New(____exports.ReadStream, process.stdin)
end
function ____exports.stdout(self)
    return __TS__New(____exports.WriteStream, process.stdout)
end
function ____exports.stdpipe(self, stream)
    local promises = {}
    if stream.pipeTo then
        __TS__ArrayPush(
            promises,
            stream:pipeTo(
                ____exports.stdout(_G)
            )
        )
    end
    if stream.write then
        __TS__ArrayPush(
            promises,
            ____exports.stdin(_G):pipeTo(stream)
        )
    end
    return Promise:all(promises)
end
return ____exports
