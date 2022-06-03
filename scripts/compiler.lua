lfs = require "lfs"
sourcesPath = "source/"
scriptsPath = "scripts/"

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


local compiledSource = dofile(scriptsPath .. "packager.lua") -- path to packager