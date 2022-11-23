local curDir = fs.getDir(table.pack(...)[2]) or ""

if not(packed)then
    local defaultPath = package.path
    local format = "path;/path/?.lua;/path/?/init.lua;"

    local main = format:gsub("path", curDir)
    local objFolder = format:gsub("path", curDir.."/objects")
    local libFolder = format:gsub("path", curDir.."/libraries")


    package.path = main..objFolder..libFolder..defaultPath
end
local Basalt = require("main")
package.path = defaultPath

return Basalt