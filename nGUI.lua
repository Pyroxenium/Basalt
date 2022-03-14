-- Shad's GUI free for everyone to use

local sGUI = {}

local frame = { __type = "Frame", name = ""}
sGUI.frames = {}
frame.__index = frame

local button = { __type = "Button", name = ""}
frame.buttons = {}
button.__index = button

local textbox = { __type = "Textbox", name = ""}
frame.textboxs = {}
textbox.__index = textbox

local w, h = term.getSize()

frame.new = function(name) 
    local newElement = {name=name, fWindow = window.create(term.native(),1,1,w,h)}
        if(sGUI.frames[name] == nil)then
            sGUI.frames[name] = newElement
            newElement.fWindow.setVisible(false)
            return setmetatable(newElement, frame);
        else
            return sGUI.frames[name];
        end
    end


function frame:getName()
    return self.name
end

function frame:show()
    self.draw = true
end
function frame:hide()
    self.draw = false
end

function frame:addButton(name)
local newElement = {name=name,frame = self, x=1, y=1, bgcolor=colors.white, fgcolor=colors.black,w=3,h=1,text="Click"}
    if(self.buttons[name] == nil)then
        self.buttons[name] = newElement
        return setmetatable(newElement, button);
    else
        return self.buttons[name];
    end
end

function button:show()
    self.draw = true
    self:redraw()
end

function button:hide()
    self.draw = false
end

function button:setPosition(x,y)
    self.x = tonumber(x)
    self.y = tonumber(y)
end

function button:setBackground(color)
    self.bgolor = color
    if(self.draw)then
        button:redraw()
    end
end

function button:setText(text)
    self.text = text
end

function button:redraw()
    print(self.name)
    self.frame.fWindow.setCursorPos(self.x,self.y)
    self.frame.fWindow.setBackgroundColor(self.bgcolor)
    paintutils.drawFilledBox(self.x, self.y, self.x+self.w, self.y+self.h, self.bgcolor)
end


function sGUI.DrawObjects()
    for k,v in pairs(sGUI.frames)do
        if(v.draw)then
            v.fWindow.setVisible(true)
            v.fWindow.redraw()
        end
    end
end

function sGUI.StartUpdate()
    while true do
        local event, key = os.pullEvent()
        sGUI.DrawObjects()
        os.sleep(0.1)
    end
end

function sGUI.getFrame(name)

end

local myFrame = frame.new("Test")
local myButton = myFrame:addButton("Testbutton")
myButton:setPosition(1,2)
myButton:show()
myFrame:show()

sGUI.StartUpdate()