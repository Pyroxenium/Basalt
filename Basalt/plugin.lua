local args = {...}   
local plugins = {} 

local dir = fs.getDir(args[2] or "Basalt")
local pluginDir = fs.combine(dir, "plugins")
if(fs.exists(pluginDir))then
    for _,v in pairs(fs.list(pluginDir))do
        local newPlugin = require(v:gsub(".lua", ""))
        if(type(newPlugin)=="table")then
            for a,b in pairs(newPlugin)do
                if(type(a)=="string")then
                    if(plugins[a]==nil)then plugins[a] = {} end
                    table.insert(plugins[a], b)
                end
            end
        end
    end
end

local function get(name)
    return plugins[name]
end

return {
    get = get,
    addPlugins = function(objects, basalt)
        for k,v in pairs(objects)do
            local plugList = plugins[k]
            if(plugList~=nil)then
                objects[k] = function(...)
                    local moddedObject = v(...)
                    for a,b in pairs(plugList)do
                        local ext = b(moddedObject, basalt, ...)
                        ext.__index = ext
                        moddedObject = setmetatable(ext, moddedObject)
                    end
                    return moddedObject
                end
            end
        end
        return objects
    end
}