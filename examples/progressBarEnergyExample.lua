-- This is a example on how to use progressbars for energy. I used the Mekanism Ultimate Energy Cube.


local filePath = "basalt.lua" --here you can change the file path default: basalt.lua
if not(fs.exists(filePath))then
    shell.run("pastebin run ESs1mg7P packed true "..filePath) -- this is an alternative to the wget command
end
local basalt = require(filePath:gsub(".lua", "")) -- here you can change the variablename in any variablename you want default: basalt

local energyCube = peripheral.find("ultimateEnergyCube")

local main = basalt.createFrame("main"):show()

local progressText = main:addLabel("currentEnergyValue")
            :setText(0)
            :setForeground(colors.gray)
            :setBackground(false)
            :setPosition(10, 3)
            :setZIndex(6)
            :show()

local energyProgress = main:addProgressbar("mainEnergyCube")
            :setSize(20,3)
            :setPosition(2,2)
            :setBackground(colors.black)
            :setProgressBar(colors.green)
            :show()

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

main:addThread("energyThread"):start(checkCurrentEnergy)

basalt.autoUpdate()
