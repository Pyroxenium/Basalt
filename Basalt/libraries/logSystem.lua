local logDir = ""
local logFileName = "log.txt"

return {
    setLogDir = function(dir)
        logDir = dir
    end,

    setLogFileName = function(name)
        logFileName = name
    end,

    __call = function()
        --somelogs
    end 
}