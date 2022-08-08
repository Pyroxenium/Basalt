local filePath = "basalt.lua" --here you can change the file path default: basalt.lua
if not(fs.exists(filePath))then
    shell.run("pastebin run ESs1mg7P packed true "..filePath) -- this is an alternative to the wget command
end

-- toastonrye's example: Redstone Analog Output
local basalt = require(filePath:gsub(".lua", "")) -- here you can change the variablename in any variablename you want default: basalt
