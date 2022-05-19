local basaltFileName = "basalt.lua"
local absoluteFilePath = "source"

local requiredFiles = {
    "mainTop.lua",
    "mainBottom.lua",
    "Frame.lua",
    "Object.lua",
    "defaultTheme.lua",
    "minify.lua",
    "lib/drawHelper.lua",
    "lib/eventSystem.lua",
    "lib/process.lua",
    "lib/utils.lua",

}

local basalt = ""

for k,v in pairs(requiredFiles)do
    assert(fs.exists(fs.combine(absoluteFilePath, v)), "File "..v.." doesn't exists!")
end

local lib = fs.list(fs.combine(absoluteFilePath, "lib"))
local objects = fs.list(fs.combine(absoluteFilePath, "objects"))

local file = fs.open(fs.combine(absoluteFilePath, "mainTop.lua"), "r")
basalt = basalt..file.readAll().."\n"
file.close()

local file = fs.open(fs.combine(absoluteFilePath, "defaultTheme.lua"), "r")
basalt = basalt..file.readAll().."\n"
file.close()

for _,v in pairs(lib)do
    local path = fs.combine(fs.combine(absoluteFilePath, "lib"), v)
    if not(fs.isDir(path))then
        local file = fs.open(path, "r")
        basalt = basalt..file.readAll().."\n"
        file.close()
    end
end

local file = fs.open(fs.combine(absoluteFilePath, "Object.lua"), "r")
basalt = basalt..file.readAll().."\n"
file.close()

for _,v in pairs(objects)do
    local path = fs.combine(fs.combine(absoluteFilePath, "objects"), v)
    if not(fs.isDir(path))then
        local file = fs.open(path, "r")
        basalt = basalt..file.readAll().."\n"
        file.close()
    end
end

local file = fs.open(fs.combine(absoluteFilePath, "Frame.lua"), "r")
basalt = basalt..file.readAll().."\n"
file.close()

local file = fs.open(fs.combine(absoluteFilePath, "mainBottom.lua"), "r")
basalt = basalt..file.readAll().."\n"
file.close()

local b = fs.open(fs.combine(absoluteFilePath, "basalt.lua"), "w")
b.write(basalt)
b.close()