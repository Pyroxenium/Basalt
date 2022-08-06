--Basalt configurated installer
local filePath = "basalt.lua" --here you can change the file path default: basalt.lua
if not(fs.exists(filePath))then
    shell.run("pastebin run ESs1mg7P packed true "..filePath:gsub(".lua", "")) -- this is an alternative to the wget command
end
local basalt = require(filePath:gsub(".lua", "")) -- here you can change the variablename in any variablename you want default: basalt

local w, h = term.getSize()


local main = basalt.createFrame("mainFrame"):show()
local objFrame = main:addFrame("objectFrame"):setPosition(1,2):setBackground(colors.lightGray):setSize(w, h-1):show()
local programFrame = main:addFrame("programFrame"):setPosition(1,2):setBackground(colors.lightGray):setSize(w, h-1)
local editorFrame = main:addFrame("editorFrame"):setPosition(1,2):setBackground(colors.lightGray):setSize(w, h-1)

local menuBar = main:addMenubar("mainMenuBar"):addItem("Object"):addItem("Program"):addItem("Editor"):setBackground(colors.gray):setSize(w, 1):setSpace(5):setScrollable():show()
menuBar:onChange(function(self)
    objFrame:hide()
    programFrame:hide()
    editorFrame:hide()
    if(self:getValue().text=="Object")then
        objFrame:show() 
    elseif(self:getValue().text=="Program")then
        programFrame:show() 
    elseif(self:getValue().text=="Editor")then
        editorFrame:show() 
    end
end)

local function visualButton(btn)
    btn:onClick(function(self) btn:setBackground(colors.black) btn:setForeground(colors.lightGray) end)
    btn:onClickUp(function(self) btn:setBackground(colors.gray) btn:setForeground(colors.black) end)
    btn:onLoseFocus(function(self) btn:setBackground(colors.gray) btn:setForeground(colors.black) end)
end

--Object Frame:

visualButton(objFrame:addButton("exampleButton"):setText("Button"):setSize(12,3):setPosition(2,2):onClick(function() end):show())
local sliderValue = objFrame:addLabel("sliderValueLabel"):setPosition(11,6):setText("1"):show()
objFrame:addSlider("exampleSlider"):setPosition(2,6):onChange(function(self) sliderValue:setText(self:getValue()) end):show()
objFrame:addInput("exampleText"):setPosition(2,8):setSize(16,1):setBackground(colors.black):setForeground(colors.lightGray):setDefaultText("Text Example", colors.gray):show()
objFrame:addInput("exampleNumber"):setPosition(2,10):setSize(16,1):setBackground(colors.black):setForeground(colors.lightGray):setDefaultText("Number Example", colors.gray):setInputType("number"):show()
objFrame:addInput("examplePassword"):setPosition(2,12):setSize(16,1):setBackground(colors.black):setForeground(colors.lightGray):setDefaultText("Password Example", colors.gray):setInputType("password"):show()

objFrame:addList("exampleList"):setPosition(20,2):addItem("1. Entry"):addItem("2. Entry"):addItem("3. Entry"):addItem("4. Entry"):addItem("5. Entry"):addItem("6. Entry"):addItem("7. Entry"):addItem("8. Entry"):show()
objFrame:addDropdown("exampleDropdown"):setPosition(37,2):addItem("1. Entry"):addItem("2. Entry"):addItem("3. Entry"):addItem("4. Entry"):addItem("5. Entry"):addItem("6. Entry"):addItem("7. Entry"):addItem("8. Entry"):show()
objFrame:addCheckbox("exampleCheckbox1"):setPosition(20,10):show()
objFrame:addLabel("checkbox1Label"):setPosition(22,10):setText("Checkbox 1"):show()
objFrame:addCheckbox("exampleCheckbox2"):setPosition(20,12):show()
objFrame:addLabel("checkbox2Label"):setPosition(22,12):setText("Checkbox 2"):show()

objFrame:addRadio("exampleRadio"):setPosition(35,10):addItem("", 1, 1):addItem("", 1, 3):addItem("", 1, 5):setSelectedItem(colors.gray, colors.black):show()
objFrame:addLabel("radio1Label"):setPosition(37,10):setText("Radio 1"):show()
objFrame:addLabel("radio2Label"):setPosition(37,12):setText("Radio 2"):show()
objFrame:addLabel("radio3Label"):setPosition(37,14):setText("Radio 3"):show()

objFrame:addScrollbar("exampleScrollbar"):setPosition(objFrame:getWidth(),1):setMaxValue(objFrame:getHeight()):setSize(1,objFrame:getHeight()):setSymbolSize(3):ignoreOffset():onChange(function(self) objFrame:setOffset(0, (self:getValue()-1)) end):setAnchor("topRight"):show():setZIndex(15)
local prog = objFrame:addProgressbar("exampleProgressbar"):setAnchor("bottomLeft"):setSize(30, 3):setBackground(colors.gray):setPosition(2,3):onProgressDone(function()
basalt.debug("Progress done!")
end):show()


local timer = objFrame:addTimer("exampleTimer"):setTime(1, -1):onCall(function()
    prog:setProgress(prog:getProgress()+2)
end):start()

--Program Frame:
local programCount = 1
visualButton(programFrame:addButton("exampleButton"):setText("Add Shell"):setSize(13,3):setPosition(2,2):onClick(function()
    local newProgramWindow = programFrame:addFrame("programFrame"..programCount):setMoveable(true):setBar("Console", colors.black, colors.lightGray):showBar():setPosition(3,3):setSize(26,12):show()
    local program = newProgramWindow:addProgram("exampleProgram"..programCount):setSize(26,11):setPosition(1,2):setBackground(colors.black):show()
    program:execute("rom/programs/shell.lua")
    programCount = programCount + 1
end):show())

-- Editor Frame:
editorFrame:addTextfield("exampleTextfield"):setPosition(2,2):setBackground(colors.black):setSize(w-2,h-3):setForeground(colors.white):show()

basalt.autoUpdate()
