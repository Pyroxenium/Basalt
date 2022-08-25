local processes = {}
local process = {}
local processId = 0

function process:new(path, window, ...)
    local args = {...}
    local newP = setmetatable({ path = path }, { __index = self })
    newP.window = window
    newP.processId = processId
    newP.coroutine = coroutine.create(function()
        shell.execute(path, table.unpack(args))
    end)
    processes[processId] = newP
    processId = processId + 1
    return newP
end

function process:resume(event, ...)
    term.redirect(self.window)
    if(self.filter~=nil)then
        if(event~=self.filter)then return end
        self.filter=nil
    end
    local ok, result = coroutine.resume(self.coroutine, event, ...)
    self.window = term.current()
    if ok then
        self.filter = result
    else
        error(result)
    end
end

function process:isDead()
    if (self.coroutine ~= nil) then
        if (coroutine.status(self.coroutine) == "dead") then
            table.remove(processes, self.processId)
            return true
        end
    else
        return true
    end
    return false
end

function process:getStatus()
    if (self.coroutine ~= nil) then
        return coroutine.status(self.coroutine)
    end
    return nil
end

function process:start()
    coroutine.resume(self.coroutine)
end

return process