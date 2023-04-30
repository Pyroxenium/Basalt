local curDir = fs.getDir(table.pack(...)[2]) or ""

local defaultPath = package.path
if not(packed)then
    local format = "path;/path/?.lua;/path/?/init.lua;"

    local main = format:gsub("path", curDir)
    local objFolder = format:gsub("path", curDir.."/objects")
    local plugFolder = format:gsub("path", curDir.."/plugins")
    local libFolder = format:gsub("path", curDir.."/libraries")


    package.path = main..objFolder..plugFolder..libFolder..defaultPath
end
local Basalt = require("main")
package.path = defaultPath

return Basalt