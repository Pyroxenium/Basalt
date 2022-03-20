-- Shad's GUI free for everyone to use


animation = {__type = "Animation", name = ""}
animation.__index = animation

local object = {} -- Base class for all UI elements

local activeScreen
local screen = {}
local screens = {}
local animations = {}

--Utility Functions:
local function getTextAlign(text, w, textAlign)
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
--(base class for every element/object even frames)
function object:new()
    local newElement = {__type = "Object",name="",zIndex=1,drawCalls=0,x=1,y=1,w=1,h=1,textAlign="left",draw=false,changed=true,bgcolor=colors.black,fgcolor=colors.white,text="",hanchor="left",vanchor="top"}
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
    local newElement = {__type = "Checkbox",symbol="x",zIndex=5,bgcolor=colors.lightBlue,fgcolor=colors.black}
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
    local newElement = {__type = "Input",zIndex=5,bgcolor=colors.lightBlue,fgcolor=colors.black,w=5}
    setmetatable(newElement, {__index = self})
    return newElement
end

button = object:new()
function button:new()
    local newElement = {__type = "Button",zIndex=5,bgcolor=colors.lightBlue,fgcolor=colors.black,w=5,textAlign="center"}
    setmetatable(newElement, {__index = self})
    return newElement
end

dropdown = object:new()
function dropdown:new()
    local newElement = {__type = "Dropdown",zIndex=10,bgcolor=colors.lightBlue,fgcolor=colors.black,w=5,textAlign="center",elements={},selected={text="",fgcolor=colors.black,bgcolor=colors.lightBlue}}
    setmetatable(newElement, {__index = self})
    return newElement
end

list = object:new()
function list:new()
    local newElement = {__type = "List",zIndex=5,bgcolor=colors.lightBlue,fgcolor=colors.black,w=5,textAlign="center",elements={},selected={text="",fgcolor=colors.black,bgcolor=colors.lightBlue}}
    setmetatable(newElement, {__index = self})
    return newElement
end

frame = object:new()
function frame:new(name,scrn)
    local parent = scrn~=nil and scrn or term.native()
    local w, h = parent.getSize()
    local newElement = {name=name, parent = parent, fWindow = window.create(parent,1,1,w,h),x=1,y=1,w=w,h=h, objects={},objZKeys={},bgcolor = colors.black, fgcolor=colors.white,barActive = false, title="New Frame", titlebgcolor = colors.lightBlue, titlefgcolor = colors.black, textAlign="left",focusedObject={}}
    setmetatable(newElement, {__index = self})
    return newElement
end
--------

--object methods
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

function object:getName()
    return self.name
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

function object:drawObject()
    if(self.draw)then
        self.drawCalls = self.drawCalls + 1
    end
end

function object:setAnchor(ank1,ank2)
    if(ank1=="right")or(ank1=="left")then
        self.hanchor = ank1
    end
    if(ank2=="top")or(ank2=="bottom")then
        self.vanchor = ank2
    end
    if(ank1=="top")or(ank1=="bottom")then
        self.vanchor = ank1
    end
    if(ank2=="right")or(ank2=="left")then
        self.hanchor = ank2
    end
    return self
end

function object:relativeToAbsolutePosition(x,y) -- relative position
    if(x==nil)then x = 0 end
    if(y==nil)then y = 0 end

    x = x+self.x;y=y+self.y
    if(self.frame~=nil)then
        x,y = self.frame:relativeToAbsolutePosition(x,y)
        x = x-1; y = y-1
    end
    return x,y
end

function object:getAnchorPosition(x,y)
    if(x==nil)then x = self.x end
    if(y==nil)then y = self.y end
    if(self.hanchor=="right")then
        x = self.frame.w-x+1
    end
    if(self.vanchor=="bottom")then
        y = self.frame.h-y
    end
    return x, y
end

function object:isFocusedElement()
    return self == self.frame.focusedObject
end

function object:clickEvent(typ,x,y) -- internal class, dont use unless you know what you do
local vx,vy = self:getAnchorPosition(self:relativeToAbsolutePosition())
    if(vx<=x)and(vx+self.w>x)and(vy<=y)and(vy+self.h>y)then
        if(self.clickFunc~=nil)then
            self.clickFunc(self,typ)
        end
        if(self.frame~=nil)then self.frame:setFocusedElement(self) end
        return true
    end
    return false
end

function object:loseFocusEvent()   

end

function object:getFocusEvent()    
end

function object:setZIndex(index)
    self.frame:changeZIndexOfObj(self,index)
    return self
end
--object end

--Frame object
screen.new = function(name, scrn)
local obj = frame:new(name,scrn)
    if(screens[name] == nil)then
        screens[name] = obj
        obj.fWindow.setVisible(false)
        obj.debugLabel=obj:addLabel("DebugLabel")
        return obj;
    else
        return screens[name];
    end
end

screen.remove = function(name)
    screens[name].fWindow.setVisible(false)
    screens[name] = nil
end

function frame:addFrame(name)
    if(self:getObject(name) == nil)then
        local obj = frame:new(name,self.fWindow)
        obj.name = name;obj.frame=self;
        self:addObject(obj)
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
end

function frame:showBar()
    self.barActive = true
    return self
end

function frame:hideBar()
    self.barActive = false
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

function frame:setSize(width, height)
    object.setSize(self,width,height)
    self.fWindow.reposition(self.x,self.y,width,height)
    return self
end

function frame:setPosition(x,y)
    object.setPosition(self,x,y)
    self.fWindow.reposition(x,y)
    return self
end

function frame:show()
    object.show(self)
    self.fWindow.setBackgroundColor(self.bgcolor)
    self.fWindow.setTextColor(self.fgcolor)
    self.fWindow.setVisible(true)
    if(self.frame == nil)then
        activeScreen = self
    end
    return self
end

function frame:hide()
    object.hide(self)
    self.fWindow.setVisible(false)
    self.fWindow.redraw()
    self.parent.clear()
    return self
end

function frame:close()
    if(self.frame~=nil)then
        object.hide(self)
    end
    self.changed = true
    self.draw = false
    self.fWindow.setVisible(false)
    screens[self.name] = nil
    self.parent.clear()
end

function frame:getObject(name)
    if(self.objects~=nil)then
        for k,v in pairs(self.objects)do
            if(v[name]~=nil)then
                return v[name]
            end
        end
    end
end

function frame:getFocusedObject()
    return self.focusedObject
end

function frame:addObject(obj) --Z index not working need bugfix
    if(self.objects[obj.zIndex]==nil)then
        for x=1,#self.objZKeys+1 do
            if(self.objZKeys[x]~=nil)then
                if(obj.zIndex >self.objZKeys[x])then
                    table.insert(self.objZKeys,x,obj.zIndex)
                end       
            else
                table.insert(self.objZKeys,x,obj.zIndex)
            end     
        end
        if(#self.objZKeys<=0)then
            table.insert(self.objZKeys,obj.zIndex)
        end
        local cache = {}
        for k,v in pairs(self.objZKeys)do
            if(self.objects[v]~=nil)then
                cache[v] = self.objects[v]
            else
                cache[v] = {}
            end
        end
        self.objects = cache
    end
    self.objects[obj.zIndex][obj.name] =  obj
end

function frame:drawObject() 
    if(self.draw)then
        object.drawObject(self)
        self.fWindow.clear()
        if(self.barActive)then
            local text = string.sub(self.title, 1, self.w)
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
            self.fWindow.setBackgroundColor(self.titlebgcolor)
            self.fWindow.setTextColor(self.titlefgcolor)
            self.fWindow.setCursorPos(1,1)
            self.fWindow.write(text)
        end

        for a,b in pairs(self.objects)do
            for k,v in pairs(b)do  
                if(v.draw~=nil)then  
                    v:drawObject()
                end
            end
        end

        if(self.inputActive)then
            self.fWindow.setCursorPos(self.cursorX, self.cursorY)
        end
        self.fWindow.setBackgroundColor(self.bgcolor)
        self.fWindow.setTextColor(self.fgcolor)
        self.fWindow.setVisible(true)
        self.fWindow.redraw()
    end
end

function frame:clickEvent(typ,x,y)
    if(object.clickEvent(self,typ,x,y))then
        local fx,fy = self:getAnchorPosition(self:relativeToAbsolutePosition())
        if(x>fx+self.w-1)or(y>fy+self.h-1)then return end
        for a,b in pairs(self.objects)do
            for _,v in pairs(b)do
                if(v.draw~=false)then
                    if(v:clickEvent(typ,x,y))then
                        return true
                    end
                end
            end
        end
        self:loseFocusedElement()
    end
    return false
end

function frame:changeZIndexOfObj(obj, zindex)
    self.objects[obj.zIndex][obj.name] =  nil
    obj.zIndex = zindex
    self:addObject(obj)
end

function frame:setFocusedElement(obj)
    if(self:getObject(obj.name)~=nil)then
        if(self.focusedObject~=obj)then
            if(self.focusedObject.name~=nil)then
                self.focusedObject:loseFocusEvent()
            end
            obj:getFocusEvent()
            self.focusedObject = obj
        end
    end
end

function frame:loseFocusedElement()
    if(self.focusedObject.name~=nil)then
        self.focusedObject:loseFocusEvent()
    end
    self.focusedObject = {}
end
--Frames end


--Timer object
function frame:addTimer(name)
    if(self:getObject(name) == nil)then
        local obj = timer:new()
        obj.name = name;obj.frame=self;
        self:addObject(obj)
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
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
--Timer end


--Checkbox object
function frame:addCheckbox(name)
    if(self:getObject(name) == nil)then
        local obj = checkbox:new()
        obj.name = name;obj.frame=self;
        self:addObject(obj)
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
end

function checkbox:setSymbol(symbol)
    self.symbol = string.sub(symbol,1,1)
    self.changed = true
    return self
end

function checkbox:drawObject()
    object.drawObject(self) -- Base class
    if(self.draw)then
        self.frame.fWindow.setCursorPos(self:getAnchorPosition())
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

function checkbox:clickEvent(typ,x,y)
    if(object.clickEvent(self,typ,x,y))then
        self.checked = not self.checked
        self.changed = true
        return true
    end
    return false
end
--Checkbox end

--Label object
function frame:addLabel(name)
    if(self:getObject(name) == nil)then
        local obj = label:new()
        obj.bgcolor = self.bgcolor
        obj.fgcolor = self.fgcolor
        obj.name=name;obj.frame=self;
        self:addObject(obj)
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
end

function label:setText(text)
    object.setText(self,text)
    self.w = string.len(text)
    return self
end

function label:drawObject()
    object.drawObject(self) -- Base class
    if(self.draw)then
        self.frame.fWindow.setCursorPos(self:getAnchorPosition())
        self.frame.fWindow.setBackgroundColor(self.bgcolor)
        self.frame.fWindow.setTextColor(self.fgcolor)
        self.frame.fWindow.write(self.text)
        self.changed = false
    end
end
--Label end

function frame:addInput(name)
    if(self:getObject(name) == nil)then
        local obj = input:new()
        obj.name = name;obj.frame=self;
        self:addObject(obj)
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
end

function input:clickEvent(typ,x,y)
    if(object.clickEvent(self,typ,x,y))then
        local vx,vy = self:getAnchorPosition(self:relativeToAbsolutePosition())
        self.frame.inputActive = true
        self.frame.activeInput = self
        self.frame.fWindow.setCursorPos(vx+(string.len(self.text) < self.w and string.len(self.text) or self.w),vy)
        self.frame.cursorX = vx+(string.len(self.text) < self.w and string.len(self.text) or self.w)
        self.frame.cursorY = vy
        self.frame.fWindow.setCursorBlink(true)
        return true
    end
    return false
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
        self.frame.fWindow.setCursorPos(self:getAnchorPosition())
        self.frame.fWindow.setBackgroundColor(self.bgcolor)
        self.frame.fWindow.setTextColor(self.fgcolor)
        self.frame.fWindow.write(text)
        self.changed = false
    end
end


function input:getFocusEvent()
    object.getFocusEvent(self)
    self.frame.fWindow.setCursorPos(self:getAnchorPosition())
    self.frame.fWindow.setCursorBlink(true)
end

function input:loseFocusEvent()
    object.loseFocusEvent(self)
    self.frame.inputActive = false
    self.frame.fWindow.setCursorBlink(false)
end

function frame:addButton(name)
    if(self:getObject(name) == nil)then
        local obj = button:new()
        obj.name = name;obj.frame=self;
        self:addObject(obj)
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
end

function button:drawObject()
    object.drawObject(self) -- Base class
    if(self.draw)then
        self.frame.fWindow.setCursorPos(self:getAnchorPosition())
        self.frame.fWindow.setBackgroundColor(self.bgcolor)
        self.frame.fWindow.setTextColor(self.fgcolor)
        self.frame.fWindow.write(getTextAlign(self.text, self.w, self.textAlign))
        self.changed = false
    end
end

function frame:addDropdown(name)
    if(self:getObject(name) == nil)then
        local obj = dropdown:new()
        obj.name = name;obj.frame=self;
        self:addObject(obj)
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
end

function dropdown:addElement(text,bgcolor,fgcolor)
    table.insert(self.elements,{text=text,bgcolor=(bgcolor ~= nil and bgcolor or self.bgcolor),fgcolor=(fgcolor ~= nil and fgcolor or self.fgcolor)})
    if(#self.elements==1)then
        self.selected = self.elements[1]
    end
    return self
end

function dropdown:drawObject()
    object.drawObject(self) -- Base class
    if(self.draw)then
        self.frame.fWindow.setCursorPos(self:getAnchorPosition())
        self.frame.fWindow.setBackgroundColor(self.selected.bgcolor)
        self.frame.fWindow.setTextColor(self.selected.fgcolor)
        self.frame.fWindow.write(getTextAlign(self.selected.text, self.w, self.textAlign))

        if(self:isFocusedElement())then
            if(#self.elements>0)then
                local index = 1
                for _,v in ipairs(self.elements)do
                    local objx, objy = self:getAnchorPosition()
                    self.frame.fWindow.setBackgroundColor(v.bgcolor)
                    self.frame.fWindow.setTextColor(v.fgcolor)
                    self.frame.fWindow.setCursorPos(objx,objy+index)
                    self.frame.fWindow.write(getTextAlign(v.text, self.w, self.textAlign))
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

function dropdown:clickEvent(typ,x,y)
    object.clickEvent(self,typ,x,y)
        if(self:isFocusedElement())then
            if(#self.elements>0)then
                local dx,dy = self:getAnchorPosition(self:relativeToAbsolutePosition())
                local index = 1
                for _,b in pairs(self.elements)do
                    if(dx<=x)and(dx+self.w>x)and(dy+index==y)then
                        self.selected = b
                        if(self.changeFunc~=nil)then
                            self.changeFunc(self)
                        end
                        activeScreen:loseFocusedElement()
                        return true
                    end
                    index = index+1
                end
                if not((dx<=x)and(dx+self.w>x)and(dy<=y)and(dy+self.h>y))then
                    activeScreen:loseFocusedElement()
                end
                return true
            end
        end
    return false
end


function frame:addList(name)
    if(self:getObject(name) == nil)then
        local obj = list:new()
        obj.name = name;obj.frame=self;
        self:addObject(obj)
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
end

function list:drawObject()
    object.drawObject(self) -- Base class
    if(self.draw)then
        self.frame.fWindow.setCursorPos(self:getAnchorPosition())
        self.frame.fWindow.setBackgroundColor(self.bgcolor)
        self.frame.fWindow.setTextColor(self.fgcolor)
        self.frame.fWindow.write(getTextAlign(self.selected.text, self.w, self.textAlign))

        if(#self.elements>0)then
            local index = 0
            for _,v in ipairs(self.elements)do
                local objx, objy = self:getAnchorPosition()
                self.frame.fWindow.setBackgroundColor(v.bgcolor)
                self.frame.fWindow.setTextColor(v.fgcolor)
                self.frame.fWindow.setCursorPos(objx,objy+index)
                if(v==self.selected)then
                    self.frame.fWindow.write(">"..getTextAlign(v.text, self.w, self.textAlign))
                else
                    self.frame.fWindow.write(" "..getTextAlign(v.text, self.w, self.textAlign))
                end
                index = index+1
            end
        end
        self.changed = false
    end
end

function list:clickEvent(typ,x,y)
    object.clickEvent(self,typ,x,y)
    if(#self.elements>0)then
        local dx,dy = self:getAnchorPosition(self:relativeToAbsolutePosition())
        local index = 0
        for _,v in pairs(self.elements)do
            if(dx<=x)and(dx+self.w>x)and(dy+index==y)then
                self.selected = v
                self.changed = true
                if(self.changeFunc~=nil)then
                    self.changeFunc(self)
                end
                return true
            end
            index = index+1
        end
    end
    return false
end

function list:getSelection()
    return self.selected
end

function list:addElement(text,bgcolor,fgcolor)
    table.insert(self.elements,{text=text,bgcolor=(bgcolor ~= nil and bgcolor or self.bgcolor),fgcolor=(fgcolor ~= nil and fgcolor or self.fgcolor)})
    if(#self.elements==1)then
        self.selected = self.elements[1]
    end
    return self
end




local function handleMouseEvent(typ,x,y)
    activeScreen:clickEvent(typ,x,y)
end

local function handleKeyboardEvent(event, key)
    if(activeScreen.inputActive)then
        if(activeScreen.activeInput.draw)then
            if(event=="key")then
                if(key==259)then
                    activeScreen.activeInput:setText(string.sub(activeScreen.activeInput.text,1,string.len(activeScreen.activeInput.text)-1))
                end
                if(key==257)then
                    if(activeScreen.inputActive)then
                        activeScreen.inputActive = false
                        activeScreen.fWindow.setCursorBlink(false)
                    end
                end
            end
            if(event=="char")then
                activeScreen.activeInput:setText(activeScreen.activeInput.text..key)
            end
            activeScreen.cursorX = activeScreen.activeInput.x+(string.len(activeScreen.activeInput.text) < activeScreen.activeInput.w and string.len(activeScreen.activeInput.text) or activeScreen.activeInput.w-1)
            activeScreen.cursorY = activeScreen.activeInput.y
            if(activeScreen.activeInput.changeFunc~=nil)then
                activeScreen.activeInput.changeFunc(activeScreen.activeInput)
            end
        end
    end
end

local function checkTimer(timeObject)
    for a,b in pairs(activeScreen.objects)do
        for k,v in pairs(b)do  
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
    if(#animations>0)then
        for k,v in pairs(animations)do
            if(v.timeObj==timeObject)then
                v:onPlay()
            end
        end
    end
end

local function handleChangedObjectsEvent()
    local changed = activeScreen.changed
    for a,b in pairs(activeScreen.objects)do
        for k,v in pairs(b)do
            if(v.changed)then
                changed = true
            end
        end
    end
    if(changed)then
        if(activeScreen.draw)then
            activeScreen:drawObject()
        end
    end
end

function screen.startUpdate()
    handleChangedObjectsEvent()
    while true do
        local event, p1,p2,p3 = os.pullEvent()
        if(event=="mouse_click")then
            handleMouseEvent(p1,p2,p3)
        end
        if(event=="timer")then
            checkTimer(p1)
        end
        if(event=="char")or(event=="key")then
            handleKeyboardEvent(event,p1)
        end
        handleChangedObjectsEvent()
    end
end


function debug(...)
    local args = {...}
    activeScreen.debugLabel:setPosition(1,activeScreen.h)
    local str = "[Debug] "
    for k,v in pairs(args)do
        str = str..tostring(v)..(#args~=k and ", " or "")
    end
    activeScreen.debugLabel:setText(str)
    activeScreen.debugLabel:show()
end

screen.debug = debug

function screen.get(name)
    return screens[name];
end

function screen.getActiveScreen()
    return activeScreen
end

return screen;