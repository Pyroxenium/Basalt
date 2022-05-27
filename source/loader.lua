local absolutePath = "source"
local basalt = dofile(fs.combine(absolutePath, "packager.lua"))

return (load(basalt, "t")())