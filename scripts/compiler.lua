lfs = require "lfs"
sourcesPath = "source/"
scriptsPath = "scripts/"
buildPath = "build/"

fetchFiles = function(...)
    local tbl = {}
    for _, directory in pairs{...} do
        for file in lfs.dir(directory) do
            if file ~= "." and file ~= ".." then
                table.insert(tbl, file)
            end
        end
    end

    return tbl
end

dirExists = function(path)
    local _, endIndex = string.find(path, "/")
    if(endIndex == #path) then
        path = string.sub(path, 1, #path - 1)
    end
    if(lfs.attributes(path, "mode") == "directory") then
        return true
    end
    return false
end

local compiledSource = dofile(scriptsPath .. "packager.lua") -- path to packager

if not dirExists(buildPath) then
    lfs.mkdir(buildPath)
    assert(dirExists(buildPath), "Failed to make build directory, exiting...")
    return
end

local sourceFileName = "basalt.lua"
local sourceFile = io.open(buildPath .. sourceFileName, "w")



sourceFile:write(compiledSource)
sourceFile:close()