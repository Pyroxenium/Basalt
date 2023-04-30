local logDir = ""
local logFileName = "basaltLog.txt"

local defaultLogType = "Debug"

fs.delete(logDir~="" and logDir.."/"..logFileName or logFileName)

local mt = {
    __call = function(_,text, typ)
        if(text==nil)then return end
        local dirStr = logDir~="" and logDir.."/"..logFileName or logFileName
        local handle = fs.open(dirStr, fs.exists(dirStr) and "a" or "w")
        handle.writeLine("[Basalt]["..os.date("%Y-%m-%d %H:%M:%S").."]["..(typ and typ or defaultLogType).."]: "..tostring(text))
        handle.close()
    end,
}

return setmetatable({}, mt)

--Work in progress