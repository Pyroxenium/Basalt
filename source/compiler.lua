local basaltFileName = "basalt-source.lua"
local absolutePath = "source"
local basalt = dofile(fs.combine(absolutePath, "packager.lua")) -- path to packager

local b = fs.open(fs.combine(absolutePath, basaltFileName), "w")
b.write(basalt)
b.close()