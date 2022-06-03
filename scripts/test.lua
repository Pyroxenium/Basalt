lfs = require "lfs"
sourcesPath = "source/"

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

for _, file in pairs(fetchFiles(sourcesPath, sourcesPath .. "lib", sourcesPath .. "objects")) do
    print(file)
end