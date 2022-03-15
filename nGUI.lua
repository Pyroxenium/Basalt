-- Shad's GUI free for everyone to use

frame = { __type = "Frame", name = ""}
frame.__index = frame

button = { __type = "Button", name = ""}
button.__index = button

label = { __type = "Label", name = ""}
label.__index = label

textbox = { __type = "Textbox", name = ""}
textbox.__index = textbox

timer = { __type = "Timer", name = ""}
timer.__index = timer

checkbox = { __type = "Checkbox", name = ""}
checkbox.__index = checkbox

local w, h = term.getSize()
local activeFrame
local frames = {}

frame.new = function(name, screen) 
    local newElement = {name=name, fWindow = window.create((screen~=nil and screen or term.native()),1,1,w,h), objects={},bgcolor = colors.black, fgcolor=colors.white, title="", titlebgcolor = colors.lightBlue, titlefgcolor = colors.black, align="left"}
        if(frames[name] == nil)then
            frames[name] = newElement
            newElement.fWindow.setVisible(false)
            local metaTab = setmetatable(newElement, frame);
            metaTab.debugLabel=metaTab:addLabel("DebugLabel")
            return metaTab;
        else
            return frames[name];
        end
    end


function frame:getName()
    return self.name
end

function frame:setBackground(color)
    self.bgcolor = color
    self.changed = true
    return self
end

function frame:setForeground(color)
    self.fgcolor = color
    self.changed = true
    return self
end

function frame:setTitle(title,fgcolor,bgcolor)
    self.title=title
    if(fgcolor~=nil)then self.titlefgcolor = fgcolor end
    if(bgcolor~=nil)then  self.titlebgcolor = bgcolor end
    self.changed = true
    return self
end

function frame:setTextAlign(align)
    self.textAlign = align
    self.changed = true
    return self
end

function frame:show()
    self.draw = true
    self.changed = true
    self.fWindow.setBackgroundColor(self.bgcolor)
    self.fWindow.setTextColor(self.fgcolor)
    self.fWindow.setVisible(true)
    if(activeFrame~=nil)then
        activeFrame:hide()
    end
    activeFrame = self
    return self
end

function frame:hide()
    self.fWindow.setVisible(false)
    self.changed = true
    self.draw = false
    return self
end

function frame:addTimer(name)
local newElement = {name=name,frame = self, timer=5, repeats=0}
    if(self.objects[name] == nil)then
        self.objects[name] = newElement
        return setmetatable(newElement, timer);
    else
        return nil, "id "..name.." already exists";
    end
    return self
end

function timer:setTime(time, repeats)
    self.timer = time
    if(repeats>0)then
        self.repeats = repeats
    else
        self.repeats = -1
    end
    return self
end

function timer:start(time, repeats)
    self.active = true
    if(time~=nil)then self.timer = time end
    if(repeats~=nil)then self.repeats = repeats end
    self.timeObj = os.startTimer(self.timer)
    return self
end

function timer:cancel()
    self.active = false
    os.cancelTimer(self.timeObj)
    return self
end

function timer:onCall(func)
    self.call = func
    return self
end

function frame:addCheckbox(name)
local newElement = {name=name,frame = self, x=1, y=1, w=1, h=1, bgcolor=colors.lightBlue, fgcolor=colors.black,symbol="X",changed=true,checked=false,drawCalls=0}
    if(self.objects[name] == nil)then
        self.objects[name] = newElement
        return setmetatable(newElement, checkbox);
    else
        return nil, "id "..name.." already exists";
    end
    return self
end

function checkbox:show()
    if not(self.draw)then
        self.draw = true
        self.changed = true
    end
    return self
end

function checkbox:hide()
    if (self.draw)then
        self.draw = false
        self.changed = true
    end
    return self
end

function checkbox:setPosition(x,y)
    self.x = tonumber(x)
    self.y = tonumber(y)
    self.changed = true
    return self
end

function checkbox:setBackground(color)
    self.bgcolor = color
    self.changed = true
    return self
end

function checkbox:setForeground(color)
    self.fgcolor = color
    self.changed = true
    return self
end

function checkbox:setSymbol(symbol)
    self.symbol = string.sub(symbol,1,1)
    self.changed = true
    return self
end

function checkbox:onClick(func)
    self.clickFunc = func
    return self
end

function checkbox:drawObject()
    if(self.draw)then
        self.drawCalls= self.drawCalls+1
        self.frame.fWindow.setCursorPos(self.x,self.y)
        self.frame.fWindow.setBackgroundColor(self.bgcolor)
        self.frame.fWindow.setTextColor(self.fgcolor)
        if(self.checked)then
            self.frame.fWindow.write(self.symbol)
        else
            self.frame.fWindow.write(" ")
        end
        self.changed = false
    end
end

function frame:addLabel(name)
local newElement = {name=name,frame = self, x=1, y=1,w=1,h=1, bgcolor=self.bgcolor, fgcolor=self.fgcolor,text="Label",changed=true,drawCalls=0}
    if(self.objects[name] == nil)then
        self.objects[name] = newElement
        return setmetatable(newElement, label);
    else
        return nil, "id "..name.." already exists";
    end
    return self
end

function label:show()
    if not(self.draw)then
        self.draw = true
        self.changed = true
    end
    return self
end

function label:hide()
    if (self.draw)then
        self.draw = false
        self.changed = true
    end
    return self
end

function label:setPosition(x,y)
    self.x = tonumber(x)
    self.y = tonumber(y)
    self.changed = true
    return self
end

function label:setBackground(color)
    self.bgcolor = color
    self.changed = true
    return self
end

function label:setForeground(color)
    self.fgcolor = color
    self.changed = true
    return self
end

function label:setText(text)
    self.text = text
    self.w = string.len(text)
    self.changed = true
    return self
end

function label:onClick(func)
    self.clickFunc = func
    return self
end

function label:drawObject()
    if(self.draw)then
        self.drawCalls= self.drawCalls+1
        self.frame.fWindow.setCursorPos(self.x,self.y)
        self.frame.fWindow.setBackgroundColor(self.bgcolor)
        self.frame.fWindow.setTextColor(self.fgcolor)
        self.frame.fWindow.write(self.text)
        self.changed = false
    end
end

function frame:addTextbox(name)
local newElement = {name=name,frame = self, x=1, y=1, bgcolor=colors.lightBlue, fgcolor=colors.black,w=3,h=1,text="",changed=true,drawCalls=0}
    if(self.objects[name] == nil)then
        self.objects[name] = newElement
        return setmetatable(newElement, textbox);
    else
        return nil, "id "..name.." already exists";
    end
    return self
end

function textbox:show()
    if not(self.draw)then
        self.draw = true
        self.changed = true
    end
    return self
end

function textbox:hide()
    if (self.draw)then
        self.draw = false
        self.changed = true
    end
    return self
end

function textbox:setPosition(x,y)
    self.x = tonumber(x)
    self.y = tonumber(y)
    self.changed = true
    return self
end

function textbox:setSize(w,l)
    self.w = tonumber(w)
    self.l = tonumber(l)
    self.changed = true
    return self
end

function textbox:setBackground(color)
    self.bgcolor = color
    self.changed = true
    return self
end

function textbox:setForeground(color)
    self.fgcolor = color
    self.changed = true
    return self
end

function textbox:setText(text)
    self.text = tostring(text)
    self.changed = true
    return self
end

function textbox:onChange(func)
    self.changeFunc = func
    return self
end

function textbox:onClick(func)
    self.clickFunc = func
    return self
end

function textbox:drawObject()
    local text = ""
    if(self.draw)then
        if(string.len(self.text)>=self.w)then
            text = string.sub(self.text, string.len(self.text)-self.w+2, string.len(self.text))
        else
            text = self.text
        end
        local n = self.w-string.len(text)
        text = text..string.rep(" ", n)
        self.drawCalls= self.drawCalls+1
        self.frame.fWindow.setCursorPos(self.x,self.y)
        self.frame.fWindow.setBackgroundColor(self.bgcolor)
        self.frame.fWindow.setTextColor(self.fgcolor)
        self.frame.fWindow.write(text)
        self.changed = false
    end
end

function frame:addButton(name)
local newElement = {name=name,frame = self, x=1, y=1, bgcolor=colors.lightBlue, fgcolor=colors.black,w=3,h=1,text="Click",align="center",changed=true,drawCalls=0}
    if(self.objects[name] == nil)then
        self.objects[name] = newElement
        return setmetatable(newElement, button);
    else
        return nil, "id "..name.." already exists";
    end
    return self
end

function button:show()
    if not(self.draw)then
        self.draw = true
        self.changed = true
    end
    return self
end

function button:hide()
    if (self.draw)then
        self.draw = false
        self.changed = true
    end
    return self
end

function button:setPosition(x,y)
    self.x = tonumber(x)
    self.y = tonumber(y)
    self.changed = true
    return self
end

function button:setSize(w,l)
    self.w = tonumber(w)
    self.l = tonumber(l)
    self.changed = true
    return self
end

function button:setTextAlign(align)
    self.textAlign = align
    self.changed = true
    return self
end

function button:setBackground(color)
    self.bgcolor = color
    self.changed = true
    return self
end

function button:setForeground(color)
    self.fgcolor = color
    self.changed = true
    return self
end

function button:setText(text)
    self.text = text
    self.changed = true
    return self
end

function button:onClick(func)
    self.clickFunc = func
    return self
end

function button:drawObject()
    if(self.draw)then
        local text = string.sub(self.text, 1, self.w)
        local n = self.w-string.len(text)
        if(self.textAlign=="left")then
            text = text..string.rep(" ", n)
        end
        if(self.textAlign=="right")then
            text = string.rep(" ", n)..text
        end
        if(self.textAlign=="center")then
            text = string.rep(" ", math.floor(n/2))..text..string.rep(" ", math.floor(n/2))
            text = text..(string.len(text) < self.w and " " or "")
        end
        --Debug("Drawcalls: "..self.drawCalls)
        self.drawCalls = self.drawCalls+1
        self.frame.fWindow.setCursorPos(self.x,self.y)
        self.frame.fWindow.setBackgroundColor(self.bgcolor)
        self.frame.fWindow.setTextColor(self.fgcolor)
        self.frame.fWindow.write(text)
        self.changed = false
    end
end

local function checkMouseClick(clicktype,x,y)
    activeFrame.textboxActive = false
    for k,v in pairs(activeFrame.objects)do
        if not(v.__type=="Timer")then
            if(v.x<=x)and(v.x+v.w>x)and(v.y<=y)and(v.y+v.h>y)then
                if(v.clickFunc~=nil)then
                    v.clickFunc(v,clicktype)
                end
            end
        end
        if(v.__type=="Textbox")then
            if(v.x<=x)and(v.x+v.w>x)and(v.y<=y)and(v.y+v.h>y)then
                v.frame.textboxActive = true
                v.frame.activeTextbox = v
                v.frame.fWindow.setCursorPos(v.x+(string.len(v.text) < v.w and string.len(v.text) or v.w)-1,v.y)
                v.frame.cursorX = v.x+(string.len(v.text) < v.w and string.len(v.text) or v.w-1)
                v.frame.cursorY = v.y
                v.frame.fWindow.setCursorBlink(true)
            end            
        end
        if(v.__type=="Checkbox")then
            if(v.x==x)and(v.y==y)then
                v.checked = not v.checked
                v.changed = true
            end
        end
    end
    if not(activeFrame.textboxActive)then
        activeFrame.fWindow.setCursorBlink(false)
    end
end

local function checkTimer(timeObject)
    for k,v in pairs(activeFrame.objects)do  
        if(v.__type=="Timer")and(v.active)then 
            if(v.timeObj == timeObject)then
                v.call(v)
                if(v.repeats~=0)then
                    v.timeObj = os.startTimer(v.timer)
                    v.repeats = (v.repeats > 0 and v.repeats-1 or v.repeats)
                end
            end
        end
    end
end

local function drawObjects()
    if(activeFrame.draw)then
        activeFrame.fWindow.clear()

        if(activeFrame.title~="")then
            local text = string.sub(activeFrame.title, 1, w)
            local n = w-string.len(text)
            if(activeFrame.textAlign=="left")then
                text = text..string.rep(" ", n)
            end
            if(activeFrame.textAlign=="right")then
                text = string.rep(" ", n)..text
            end
            if(activeFrame.textAlign=="center")then
                text = string.rep(" ", math.floor(n/2))..text..string.rep(" ", math.floor(n/2))
                text = text..(string.len(text) < w and " " or "")
            end
            activeFrame.fWindow.setBackgroundColor(activeFrame.titlebgcolor)
            activeFrame.fWindow.setTextColor(activeFrame.titlefgcolor)
            activeFrame.fWindow.setCursorPos(1,1)
            activeFrame.fWindow.write(text)
        end
        for k,v in pairs(activeFrame.objects)do  
            if(v.draw~=nil)then  
                v:drawObject()
            end
        end
        if(activeFrame.textboxActive)then
            activeFrame.fWindow.setCursorPos(activeFrame.cursorX, activeFrame.cursorY)
        end
        activeFrame.fWindow.setBackgroundColor(activeFrame.bgcolor)
        activeFrame.fWindow.setTextColor(activeFrame.fgcolor)
        activeFrame.fWindow.setVisible(true)
        activeFrame.fWindow.redraw()
    end
end

local function checkForChangedObjects()
local changed = activeFrame.changed
    for k,v in pairs(activeFrame.objects)do
        if(v.changed)then
            changed = true
        end
    end
    if(changed)then
        drawObjects()
    end
end

local function checkKeyboardInput(event, key)
    if(activeFrame.textboxActive)then
        if(event=="key")then
            if(key==259)then
                activeFrame.activeTextbox:setText(string.sub(activeFrame.activeTextbox.text,1,string.len(activeFrame.activeTextbox.text)-1))
            end
            if(key==257)then
                if(activeFrame.textboxActive)then
                    activeFrame.textboxActive = false
                    activeFrame.fWindow.setCursorBlink(false)
                end
            end
        end
        if(event=="char")then
            activeFrame.activeTextbox:setText(activeFrame.activeTextbox.text..key)
        end
        activeFrame.cursorX = activeFrame.activeTextbox.x+(string.len(activeFrame.activeTextbox.text) < activeFrame.activeTextbox.w and string.len(activeFrame.activeTextbox.text) or activeFrame.activeTextbox.w-1)
        activeFrame.cursorY = activeFrame.activeTextbox.y
        if(activeFrame.activeTextbox.changeFunc~=nil)then
            activeFrame.activeTextbox.changeFunc(activeFrame.activeTextbox)
        end
    end
end

function frame.startUpdate()
    checkForChangedObjects()
    while true do
        local event, p1,p2,p3 = os.pullEvent()
        --debug(event,p1,p2,p3)
        if(event=="mouse_click")then
            checkMouseClick(p1,p2,p3)
        end
        if(event=="timer")then
            checkTimer(p1)
        end
        if(event=="char")or(event=="key")then
            checkKeyboardInput(event,p1)
        end
        checkForChangedObjects()
    end
end


function debug(...)
    local args = {...}
    activeFrame.debugLabel:setPosition(1,h)
    local str = "[Debug] "
    for k,v in pairs(args)do
        str = str..tostring(v)..(#args~=k and ", " or "")
    end
    activeFrame.debugLabel:setText(str)
    activeFrame.debugLabel:show()
end

frame.debug = debug

function frame.get(name)
    return frames[name];
end

function frame.getActiveFrame()
    return activeFrame
end

return frame;