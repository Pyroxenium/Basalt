local curDir = fs.getDir(table.pack(...)[2]) or ""

local defaultPath = package.path
local format = "%s;/%s/?.lua;/%s/?/init.lua"
package.path = string.format(format, package.path, curDir,curDir)..string.format(format, package.path, curDir.."/libraries",curDir.."/libraries")..string.format(format, package.path, curDir.."/objects",curDir.."/objects")

local Basalt = require("main")
package.path = defaultPath

return Basalt