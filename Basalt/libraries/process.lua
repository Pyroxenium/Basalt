local processes = {}
local process = {}
local processId = 0

local newPackage = dofile("rom/modules/main/cc/require.lua").make

function process:new(path, window, newEnv, ...)
    local args = {...}
    local newP = setmetatable({ path = path }, { __index = self })
    newP.window = window
    window.current = term.current
    window.redirect = term.redirect
    newP.processId = processId
    if(type(path)=="string")then
    newP.coroutine = coroutine.create(function()
        local pPath = shell.resolveProgram(path)
        local env = setmetatable(newEnv, {__index=_ENV})
        env.shell = shell
        env.basaltProgram=true
        env.arg = {[0]=path, table.unpack(args)}
        env.require, env.package = newPackage(env, fs.getDir(pPath))
        if(fs.exists(pPath))then
            local file = fs.open(pPath, "r")
            local content = file.readAll()
            file.close()
            local program = load(content, path, "bt", env)
            if(program~=nil)then
                return program()
            end
        end
    end)
    elseif(type(path)=="function")then
        newP.coroutine = coroutine.create(function()
            path(table.unpack(args))
        end)
    else
        return
    end
    processes[processId] = newP
    processId = processId + 1
    return newP
end

function process:resume(event, ...)
    local cur = term.current()
    term.redirect(self.window)
    if(self.filter~=nil)then
        if(event~=self.filter)then return end
        self.filter=nil
    end
    local ok, result = coroutine.resume(self.coroutine, event, ...)

    if ok then
        self.filter = result
    else
        printError(result)
    end
    term.redirect(cur)
    return ok, result
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