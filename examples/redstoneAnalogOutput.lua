--Basalt configurated installer
local filePath = "basalt.lua" --here you can change the file path default: basalt
if not(fs.exists(filePath))then
    shell.run("pastebin run ESs1mg7P packed true "..filePath:gsub(".lua", "")) -- this is an alternative to the wget command
end

-- toastonrye's example: Redstone Analog Output
local basalt = require(filePath:gsub(".lua", "")) -- here you can change the variablename in any variablename you want default: basalt
local w, h = term.getSize() -- dimensions to use when drawing the sub frame

local main = basalt.createFrame()
 :show()
 :setBackground(colours.blue) -- using colours to easily determine what frame I'm in

local sub = main:addFrame()
 :setPosition(2,2)
 :setSize(w-2,h-2)
 :setBackground(colours.lightBlue)
 
local rFrame = sub:addFrame("redstoneFrame")
 :setPosition(1,1)
 :setSize(25,5)
 :setMoveable(true) -- the next release of Basalt will fix spelling to :setMovable
 :setBackground(colours.red)

-- Redstone Analog Output
local redstoneAnalog = rFrame:addLabel() -- label that displays the value of the slider & Redstone output
 :setPosition(18,3):setText("1")

redstone.setAnalogOutput("left", 1) -- initialize the redstone output to 1, to match the above label

rFrame:addLabel() -- draw a label on the frame
 :setText("Redstone Analog Output")
 :setPosition(1,2)
 
rFrame:addSlider()
 :setPosition(1,3)
 :onChange(function(self) -- when a player interacts with the slider, update the variable redstoneAnalog
  redstoneAnalog:setText(self:getValue())
 end)
 :setMaxValue(15) -- max value of the slider, default 8. Redstone has 15 levels (16 including 0)
 :setSize(15,1) -- draw the slider to this size, without this redstoneAnalog value can have decimals

redstoneAnalog:onChange(function(self) -- when the slider value changes, change the Redstone output to match
 redstone.setAnalogOutput("left", tonumber(self:getValue()))
 basalt.debug(self:getValue())
end)

basalt.autoUpdate()
