local basaltFileName = "basalt.lua"

local requiredFiles = {
    "mainTop.lua",
    "mainBottom.lua",
    "Frame.lua",
    "Object.lua",
    "defaultTheme.lua",
    "lib/drawHelper.lua",
    "lib/eventSystem.lua",
    "lib/process.lua",
    "lib/utils.lua",
}
for _, value in pairs(requiredFiles)do
    assert(io.open(sourcesPath .. value), "File ".. value .." not found!")
end

local lib = fetchFiles(sourcesPath .. "lib")
local objects = fetchFiles(sourcesPath .. "objects")

local filesOrdered = {}

table.insert(filesOrdered, "mainTop.lua")
table.insert(filesOrdered, "defaultTheme.lua")

for _, libFile in pairs(lib) do
    table.insert(filesOrdered, "lib/" .. libFile)
end

table.insert(filesOrdered,  "Object.lua")

for _, objectFile in pairs(objects) do
    table.insert(filesOrdered,  "objects/" .. objectFile)
end

table.insert(filesOrdered, "Frame.lua")
table.insert(filesOrdered, "mainBottom.lua")

local basalt = io.open(sourcesPath .. basaltFileName, "w")
local compiledSource = ""

for _, file in ipairs(filesOrdered) do
    print("Loading file ".. file)
    local currentSource = io.open(sourcesPath .. file, "r")
    compiledSource = compiledSource .. currentSource:read("*a") .. "\n"
end

basalt:write(compiledSource)
basalt:close()
return compiledSource