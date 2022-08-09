--Basalt configurated installer
local filePath = "basalt.lua" --here you can change the file path default: basalt
if not(fs.exists(filePath))then
    shell.run("pastebin run ESs1mg7P packed true "..filePath:gsub(".lua", "")) -- this is an alternative to the wget command
end

-- toastonrye's example: Redstone Analog Output
local basalt = require(filePath:gsub(".lua", "")) -- here you can change the variablename in any variablename you want default: basalt
local w, h = term.getSize()

local main = basalt.createFrame()
 :show()
 :setBackground(colours.blue)

local sub = main:addFrame()
 :setPosition(2,2)
 :setSize(w-2,h-2)
 :setBackground(colours.lightBlue)
 
local rFrame = sub:addFrame("redstoneFrame")
 :setPosition(1,1)
 :setSize(25,5)
 :setMoveable(true)
 :setBackground(colours.red)

-- Redstone Analog Output
local redstoneAnalog = rFrame:addLabel()
 :setPosition(18,3):setText("1")

redstone.setAnalogOutput("left", 1)

rFrame:addLabel()
 :setText("Redstone Analog Output")
 :setPosition(1,2)
 
rFrame:addSlider()
 :setPosition(1,3)
 :onChange(function(self)
  redstoneAnalog:setText(self:getValue())
 end)
 :setMaxValue(15)
 :setSize(15,1)

redstoneAnalog:onChange(function(self)
 redstone.setAnalogOutput("left", tonumber(self:getValue()))
 basalt.debug(self:getValue())
end)

basalt.autoUpdate()
