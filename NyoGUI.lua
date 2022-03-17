-- Shad's GUI free for everyone to use

frame = { __type = "Frame", name = ""} -- Frame element
frame.__index = frame

animation = {__type = "Animation", name = ""}
animation.__index = animation

local object = {} -- Base class for all UI elements

local activeFrame
local frames = {}
local animations = {}

--Utility Functions:
function getTextAlign(text, w, textAlign)
    local text = string.sub(text, 1, w)
    local n = w-string.len(text)
    if(textAlign=="right")then
        text = string.rep(" ", n)..text
    elseif(textAlign=="center")then
        text = string.rep(" ", math.floor(n/2))..text..string.rep(" ", math.floor(n/2))
        text = text..(string.len(text) < w and " " or "")
    else
        text = text..string.rep(" ", n)
    end
    return text
end

--------------

frame.new = function(name, screen)
local usedScreen = screen~=nil and screen or term.native()
local w, h = usedScreen.getSize()
local newElement = {name=name, screen = usedScreen, fWindow = window.create(usedScreen,1,1,w,h),w=w,h=h, objects={},bgcolor = colors.black, fgcolor=colors.white, title="New Frame", titlebgcolor = colors.lightBlue, titlefgcolor = colors.black, textAlign="left",focusedObject={}}
    if(frames[name] == nil)then
        frames[name] = newElement
        newElement.fWindow.setVisible(false)
        setmetatable(newElement, {__index = frame});
        newElement.debugLabel=newElement:addLabel("DebugLabel")
        return newElement;
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

function frame:getObject(name)
    return self.objects[name]
end

function frame:getFocusedObject()
    return self.focusedObject
end


--Animation System
animation.new = function(name)
    local newElement = {name=name,animations={},nextWaitTimer=0,index=1,infiniteloop=false}
    setmetatable(newElement, animation)
    table.insert(animations, newElement)
    return newElement
end

function animation:addAnimation(func)
    table.insert(self.animations, {f=func,t=self.nextWaitTimer})
    self.nextWaitTimer = 0
    return self
end

function animation:wait(timer)
    self.nextWaitTimer = timer
    return self
end

function animation:onPlay() -- internal function, don't use it unless you know what you do!
    if(self.playing)then
        self.animations[self.index].f(self)
        self.index = self.index+1

        if(self.animations[self.index]~=nil)then
            if(self.animations[self.index].t>0)then
                self.timeObj = os.startTimer(self.animations[self.index].t)
            else
                self:onPlay()
            end
        else
            if(self.infiniteloop)then
                self.index = 1
                if(self.animations[self.index].t>0)then
                    self.timeObj = os.startTimer(self.animations[self.index].t)
                else
                    self:onPlay()
                end
            end
        end
    end
end

function animation:play(infiniteloop)
    if(infiniteloop~=nil)then self.infiniteloop=infiniteloop end
    self.playing = true
    if(self.animations[self.index]~=nil)then
        if(self.animations[self.index].t>0)then
            self.timeObj = os.startTimer(self.animations[self.index].t)
        else
            self:onPlay()
        end
    end
    return self
end

function animation:cancel()
    os.cancelTimer(self.timeObj)
    self.playing = false
    self.infiniteloop = false
    self.index = 0
    return self
end
-----------





--Object Constructors:
function object:new()
    local newElement = {__type = "Object",name="",drawCalls=0,x=1,y=1,w=1,h=1,textAlign="left",draw=false,changed=true,bgcolor=colors.black,fgcolor=colors.white,text=""}
    setmetatable(newElement, {__index = self})
    return newElement
end

timer = object:new()
function timer:new()
    local newElement = {__type = "Timer"}
    setmetatable(newElement, {__index = self})
    return newElement
end

checkbox = object:new()
function checkbox:new()
    local newElement = {__type = "Checkbox",symbol="x",bgcolor=colors.lightBlue,fgcolor=colors.black}
    setmetatable(newElement, {__index = self})
    return newElement
end

label = object:new()
function label:new()
    local newElement = {__type = "Label"}
    setmetatable(newElement, {__index = self})
    return newElement
end

input = object:new()
function input:new()
    local newElement = {__type = "Input",bgcolor=colors.lightBlue,fgcolor=colors.black,w=5}
    setmetatable(newElement, {__index = self})
    return newElement
end

button = object:new()
function button:new()
    local newElement = {__type = "Button",bgcolor=colors.lightBlue,fgcolor=colors.black,w=5,textAlign="center"}
    setmetatable(newElement, {__index = self})
    return newElement
end

dropdown = object:new()
function dropdown:new()
    local newElement = {__type = "Dropdown",bgcolor=colors.lightBlue,fgcolor=colors.black,w=5,textAlign="center",elements={},selected=""}
    setmetatable(newElement, {__index = self})
    return newElement
end
--------
function object:show()
    if not(self.draw)then
        self.draw = true
        self.changed = true
    end
    return self
end

function object:hide()
    if(self.draw)then
        self.draw = false
        self.changed = true
    end
    return self
end

function object:setPosition(x,y)
    self.x = tonumber(x)
    self.y = tonumber(y)
    self.changed = true
    return self
end

function object:setBackground(color)
    self.bgcolor = color
    self.changed = true
    return self
end

function object:setForeground(color)
    self.fgcolor = color
    self.changed = true
    return self
end

function object:onClick(func)
    self.clickFunc = func
    return self
end

function object:setText(text)
    self.text = text
    self.changed = true
    return self
end

function object:onChange(func)
    self.changeFunc = func
    return self
end

function object:setSize(w,h)
    self.w = tonumber(w)
    self.h = tonumber(h)
    self.changed = true
    return self
end

function object:setTextAlign(align)
    self.textAlign = align
    self.changed = true
    return self
end

function object:drawObject() -- Base class for drawing a object
    if(self.draw)then
        self.drawCalls = self.drawCalls + 1
    end
    return self
end

function object:IsFocusedElement()
    return self == self.frame.focusedObject
end

function frame:addTimer(name)
    if(self.objects[name] == nil)then
        local obj = timer:new()
        self.objects[name] = obj
        obj.name = name;obj.frame=self;
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
    return self
end

function timer:setTime(timer, repeats)
    self.timer = timer
    if(repeats>0)then
        self.repeats = repeats
    else
        self.repeats = -1
    end
    return self
end

function timer:start(timer, repeats)
    self.active = true
    if(timer~=nil)then self.timer = timer end
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
    if(self.objects[name] == nil)then
        local obj = checkbox:new()
        self.objects[name] = obj
        obj.name = name;obj.frame=self;
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
    return self
end

function checkbox:setSymbol(symbol)
    self.symbol = string.sub(symbol,1,1)
    self.changed = true
    return self
end

function checkbox:drawObject()
    object.drawObject(self) -- Base class
    if(self.draw)then
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
    if(self.objects[name] == nil)then
        local obj = label:new()
        self.objects[name] = obj
        obj.name = name;obj.frame=self;
        obj.bgcolor = self.bgcolor
        obj.fgcolor = self.fgcolor
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
    return self
end

function label:setText(text)
    object.setText(self,text)
    self.w = string.len(text)
    return self
end

function label:drawObject()
    object.drawObject(self) -- Base class
    if(self.draw)then
        self.frame.fWindow.setCursorPos(self.x,self.y)
        self.frame.fWindow.setBackgroundColor(self.bgcolor)
        self.frame.fWindow.setTextColor(self.fgcolor)
        self.frame.fWindow.write(self.text)
        self.changed = false
    end
end

function frame:addInput(name)
    if(self.objects[name] == nil)then
        local obj = input:new()
        self.objects[name] = obj
        obj.name = name;obj.frame=self;
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
    return self
end

function input:drawObject()
    object.drawObject(self) -- Base class
    local text = ""
    if(self.draw)then
        if(string.len(self.text)>=self.w)then
            text = string.sub(self.text, string.len(self.text)-self.w+2, string.len(self.text))
        else
            text = self.text
        end
        local n = self.w-string.len(text)
        text = text..string.rep(" ", n)
        self.frame.fWindow.setCursorPos(self.x,self.y)
        self.frame.fWindow.setBackgroundColor(self.bgcolor)
        self.frame.fWindow.setTextColor(self.fgcolor)
        self.frame.fWindow.write(text)
        self.changed = false
    end
end

function frame:addButton(name)
    if(self.objects[name] == nil)then
        local obj = button:new()
        self.objects[name] = obj
        obj.name = name;obj.frame=self;
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
    return self
end

function button:drawObject()
    object.drawObject(self) -- Base class
    if(self.draw)then

        self.frame.fWindow.setCursorPos(self.x,self.y)
        self.frame.fWindow.setBackgroundColor(self.bgcolor)
        self.frame.fWindow.setTextColor(self.fgcolor)
        self.frame.fWindow.write(getTextAlign(self.text, self.w, self.textAlign))
        self.changed = false
    end
end

function frame:addDropdown(name)
    if(self.objects[name] == nil)then
        local obj = dropdown:new()
        self.objects[name] = obj
        obj.name = name;obj.frame=self;
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
    return self
end

function dropdown:addElement(text)
    table.insert(self.elements,text)
    return self
end

function dropdown:drawObject()
    object.drawObject(self) -- Base class
    if(self.draw)then
        self.frame.fWindow.setCursorPos(self.x,self.y)
        self.frame.fWindow.setBackgroundColor(self.bgcolor)
        self.frame.fWindow.setTextColor(self.fgcolor)
        self.frame.fWindow.write(getTextAlign(self.selected, self.w, self.textAlign))

        if(self.frame:getFocusedObject()==self)then
            if(#self.elements>0)then
                local index = 1
                for _,v in ipairs(self.elements)do
                    self.frame.fWindow.setCursorPos(self.x,self.y+index)
                    self.frame.fWindow.setBackgroundColor(self.bgcolor)
                    self.frame.fWindow.setTextColor(self.fgcolor)
                    self.frame.fWindow.write(getTextAlign(v, self.w, self.textAlign))
                    index = index+1
                end
            end
        end
        self.changed = false
    end
end

function dropdown:getSelection()
    return self.selected
end

local function checkMouseClick(clicktype,x,y)
    activeFrame.inputActive = false
    local d = activeFrame.focusedObject
    if(d.__type=="Dropdown")then
        if(d:IsFocusedElement())then
            if(#d.elements>0)then
                local index = 1
                for _,b in pairs(d.elements)do
                    if(d.x<=x)and(d.x+d.w>x)and(d.y+index<=y)and(d.y+index+d.h>y)then
                        d.selected = b
                        if(d.changeFunc~=nil)then
                            d.changeFunc(d)
                        end
                        activeFrame.focusedObject = {}
                        return
                    end
                    index = index+1
                end
            end
        end
    end
    activeFrame.focusedObject = {}
    for k,v in pairs(activeFrame.objects)do
        if(v.draw~=false)then
            if not(v.__type=="Timer")then
                if(v.x<=x)and(v.x+v.w>x)and(v.y<=y)and(v.y+v.h>y)then
                    if(v.clickFunc~=nil)then
                        v.clickFunc(v,clicktype)
                    end
                    activeFrame.focusedObject = v
                end
            end
            if(v.__type=="Input")then
                if(v.x<=x)and(v.x+v.w>x)and(v.y<=y)and(v.y+v.h>y)then
                    v.frame.inputActive = true
                    v.frame.activeInput = v
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
    end
    if not(activeFrame.inputActive)then
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
    if(#animations>0)then
        for k,v in pairs(animations)do
            if(v.timeObj==timeObject)then
                v:onPlay()
            end
        end
    end
end

local function drawObjects()
    if(activeFrame.draw)then
        activeFrame.fWindow.clear()

        if(activeFrame.title~="")then
            local text = string.sub(activeFrame.title, 1, activeFrame.w)
            local n = activeFrame.w-string.len(text)
            if(activeFrame.textAlign=="left")then
                text = text..string.rep(" ", n)
            end
            if(activeFrame.textAlign=="right")then
                text = string.rep(" ", n)..text
            end
            if(activeFrame.textAlign=="center")then
                text = string.rep(" ", math.floor(n/2))..text..string.rep(" ", math.floor(n/2))
                text = text..(string.len(text) < activeFrame.w and " " or "")
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
        if(activeFrame.inputActive)then
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
    if(activeFrame.inputActive)then
        if(activeFrame.activeInput.draw)then
            if(event=="key")then
                if(key==259)then
                    activeFrame.activeInput:setText(string.sub(activeFrame.activeInput.text,1,string.len(activeFrame.activeInput.text)-1))
                end
                if(key==257)then
                    if(activeFrame.inputActive)then
                        activeFrame.inputActive = false
                        activeFrame.fWindow.setCursorBlink(false)
                    end
                end
            end
            if(event=="char")then
                activeFrame.activeInput:setText(activeFrame.activeInput.text..key)
            end
            activeFrame.cursorX = activeFrame.activeInput.x+(string.len(activeFrame.activeInput.text) < activeFrame.activeInput.w and string.len(activeFrame.activeInput.text) or activeFrame.activeInput.w-1)
            activeFrame.cursorY = activeFrame.activeInput.y
            if(activeFrame.activeInput.changeFunc~=nil)then
                activeFrame.activeInput.changeFunc(activeFrame.activeInput)
            end
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
    activeFrame.debugLabel:setPosition(1,activeFrame.h)
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