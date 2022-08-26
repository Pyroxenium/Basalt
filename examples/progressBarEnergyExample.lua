-- This is a example on how to use progressbars for energy. I used the Mekanism Ultimate Energy Cube.


--Basalt configurated installer
local filePath = "basalt.lua" --here you can change the file path default: basalt
if not(fs.exists(filePath))then
    shell.run("pastebin run ESs1mg7P packed true "..filePath:gsub(".lua", "")) -- this is an alternative to the wget command
end
local basalt = require(filePath:gsub(".lua", ""))

local energyCube = peripheral.find("ultimateEnergyCube")

local main = basalt.createFrame()

local progressText = main:addLabel()
            :setText(0)
            :setForeground(colors.gray)
            :setBackground(false)
            :setPosition(10, 3)
            :setZIndex(6)

local energyProgress = main:addProgressbar()
            :setSize(20,3)
            :setPosition(2,2)
            :setBackground(colors.black)
            :setProgressBar(colors.green)

energyProgress:onChange(function()
    local energy = tostring(energyCube.getEnergy())
    progressText:setText(energy)
    progressText:setPosition(energyProgress:getWidth()/2+1 - math.floor(energy:len()/2), 3)
end)


local function checkCurrentEnergy()
    while true do
        energyCube = peripheral.find("ultimateEnergyCube")
        if(energyCube~=nil)then
            local energyCalculation = energyCube.getEnergy() / energyCube.getMaxEnergy() * 100
            energyProgress:setProgress(energyCalculation)
        else
            energyProgress:setProgress(0)
            os.sleep(3)
        end
        os.sleep(1)
    end
end

main:addThread():start(checkCurrentEnergy)

basalt.autoUpdate()
