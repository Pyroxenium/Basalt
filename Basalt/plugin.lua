local args = {...}
local plugins = {}
local pluginNames = {}

local dir = fs.getDir(args[2] or "Basalt")
local pluginDir = fs.combine(dir, "plugins")
if(packaged)then
    for k,v in pairs(getProject("plugins"))do
        table.insert(pluginNames, k)
        local newPlugin = v()
        if(type(newPlugin)=="table")then
            for a,b in pairs(newPlugin)do
                if(type(a)=="string")then
                    if(plugins[a]==nil)then plugins[a] = {} end
                    table.insert(plugins[a], b)
                end
            end
        end
    end
else
    if(fs.exists(pluginDir))then
        for _,v in pairs(fs.list(pluginDir))do
            local newPlugin
            if(fs.isDir(fs.combine(pluginDir, v)))then
                table.insert(pluginNames, fs.combine(pluginDir, v))
                newPlugin = require(v.."/init")
            else
                table.insert(pluginNames, v)
                newPlugin = require(v:gsub(".lua", ""))
            end
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
end

local function get(name)
    return plugins[name]
end

return {
    --- Gets a plugin list
    --- @param name string name of plugin list
    --- @return table plugins
    get = get,
    getAvailablePlugins = function()
        return pluginNames
    end,

    --- Adds a plugin to basalt's plugin list
    --- @param path string path to plugin
    addPlugin = function(path)
        if(fs.exists(path))then
            if(fs.isDir(path))then
                for _,v in pairs(fs.list(path))do
                    table.insert(pluginNames, v)
                    if not(fs.isDir(fs.combine(path, v)))then
                        local pluginName = v:gsub(".lua", "")
                        local newPlugin = require(fs.combine(path, pluginName))
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
            else
                local newPlugin = require(path:gsub(".lua", ""))
                table.insert(pluginNames, path:match("[\\/]?([^\\/]-([^%.]+))$"))
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
    end,

    --- Loads all available plugins into basalt's objects
    --- @param objects table objects to load plugins into
    --- @param basalt table basalt
    --- @return table objects modified objects
    loadPlugins = function(objects, basalt)
        for k,v in pairs(objects)do
            local plugList = plugins[k]
            if(plugList~=nil)then
                objects[k] = function(...)
                    local moddedObject = v(...)
                    for _,b in pairs(plugList)do
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