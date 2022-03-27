-- Shad's GUI free for everyone to use


animation = {__type = "Animation", name = ""}
animation.__index = animation

local object = {} -- Base class for all UI elements

local activeScreen
local screen = {}
local screens = {}
local animations = {}
local keyModifier = {}

--Utility Functions:
local function getTextHorizontalAlign(text, w, textAlign)
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

local function getTextVerticalAlign(h,textAlign)
local offset = 0
    if(textAlign=="center")then
        offset = h%2 == 0 and math.floor(h / 2)-1 or math.floor(h / 2)
    end
    if(textAlign=="bottom")then
        offset = h
    end
    return offset
end

local function rpairs(t)
	return function(t, i)
		i = i - 1
		if i ~= 0 then
			return i, t[i]
		end
	end, t, #t + 1
end

local function copyVar(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[copyVar(orig_key)] = copyVar(orig_value)
        end
        setmetatable(copy, copyVar(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local function callAll(tab,...)
    if(tab~=nil)then
        if(#tab>0)then
            for k,v in pairs(tab)do
                v(type(...)=="table" and table.unpack(...) or ...)
            end
        end
    end
end

local function tableCount(tab)
local n = 0
    for _,v in pairs(tab)do
        n = n+1
    end
    return n
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
    local newElement = {__type = "Object",name="",links={},zIndex=1,drawCalls=0,x=1,y=1,w=1,h=1,textAlign="left",draw=false,changed=true,bgcolor=colors.black,fgcolor=colors.white,text="",hanchor="left",vanchor="top"}
    setmetatable(newElement, {__index = self})
    return newElement
end

function object:copy(obj)
local newElement = {}
    for k,v in pairs(obj)do
        newElement[k] = v
    end
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
    local newElement = {__type = "Checkbox",symbol="\42",zIndex=5,bgcolor=colors.lightBlue,fgcolor=colors.black, value = false}
    setmetatable(newElement, {__index = self})
    return newElement
end

radio = object:new()
function radio:new()
    local newElement = {__type = "Radio",symbol="\7",zIndex=5,bgcolor=colors.lightBlue,fgcolor=colors.black, value = "", elements={}}
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
    local newElement = {__type = "Input",zIndex=5,bgcolor=colors.lightBlue,fgcolor=colors.black,w=5, value = ""}
    setmetatable(newElement, {__index = self})
    return newElement
end

button = object:new()
function button:new()
    local newElement = {__type = "Button",zIndex=5,bgcolor=colors.lightBlue,fgcolor=colors.black,w=5,horizontalTextAlign="center",verticalTextAlign="center"}
    setmetatable(newElement, {__index = self})
    return newElement
end

dropdown = object:new()
function dropdown:new()
    local newElement = {__type = "Dropdown",zIndex=10,bgcolor=colors.lightBlue,fgcolor=colors.black,w=5,horizontalTextAlign="center",elements={},value={text="",fgcolor=colors.black,bgcolor=colors.lightBlue}}
    setmetatable(newElement, {__index = self})
    return newElement
end

list = object:new()
function list:new()
    local newElement = {__type = "List",index=1,zIndex=5,symbol=">",bgcolor=colors.lightBlue,fgcolor=colors.black,w=5,horizontalTextAlign="center",elements={},value={text="",fgcolor=colors.black,bgcolor=colors.lightBlue}}
    setmetatable(newElement, {__index = self})
    return newElement
end

textfield = object:new()
function textfield:new()
    local newElement = {__type = "Textfield",hIndex=1,wIndex=1,textX=1,textY=1,zIndex=5,bgcolor=colors.lightBlue,fgcolor=colors.black,w=5,h=2,value="",curCharOffset=0,lines={""}}
    setmetatable(newElement, {__index = self})
    return newElement
end

frame = object:new()
function frame:new(name,scrn,frameObj)
    local parent = scrn~=nil and scrn or term.current()
    local w, h = parent.getSize()
    local newElement = {}
    if(frameObj~=nil)then
        newElement = object:copy(frameObj)
        newElement.fWindow = window.create(parent,1,1,frameObj.w,frameObj.h)
    else
        newElement = {__type = "Frame",name=name, parent = parent,zIndex=1, fWindow = window.create(parent,1,1,w,h),x=1,y=1,w=w,h=h, objects={},objZKeys={},bgcolor = colors.black, fgcolor=colors.white,barActive = false, title="New Frame", titlebgcolor = colors.lightBlue, titlefgcolor = colors.black, horizontalTextAlign="left",focusedObject={}, isMoveable = false}
    end
    setmetatable(newElement, {__index = self})
    return newElement
end
--------
 
--object methods
function object:show()
    self.draw = true
    self.changed = true
    return self
end

function object:hide()
    self.draw = false
    self.changed = true
    return self
end

function object:changeVisibility()
    if(self.draw)then
        self:hide()
    else
        self:show()
    end
    return self
end

function object:isVisible()
    return self.draw
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

--Object Events:-----
function object:onClick(func)
    if(self.clickFunc==nil)then self.clickFunc = {} end
    table.insert(self.clickFunc,func)
    return self
end

function object:onClickUp(func)
    if(self.upFunc==nil)then self.upFunc = {} end
    table.insert(self.upFunc,func)
    return self
end

function object:onMouseDrag(func)
    if(self.dragFunc==nil)then self.dragFunc = {} end
    table.insert(self.dragFunc,func)
    return self
end

function object:onChange(func)
    if(self.changeFunc==nil)then self.changeFunc = {} end
    table.insert(self.changeFunc,func)
    return self
end

function object:onKeyClick(func)
    if(self.keyEventFunc==nil)then self.keyEventFunc = {} end
    table.insert(self.keyEventFunc,func)
    return self
end

function object:onLoseFocus(func)
    if(self.loseFocusEventFunc==nil)then self.loseFocusEventFunc = {} end
    table.insert(self.loseFocusEventFunc,func)
    return self
end

function object:onGetFocus(func)
    if(self.getFocusEventFunc==nil)then self.getFocusEventFunc = {} end
    table.insert(self.getFocusEventFunc,func)
    return self
end
--------------------

function object:setText(text)
    self.text = text
    self.changed = true
    return self
end

function object:setSize(w,h)
    self.w = tonumber(w)
    self.h = tonumber(h)
    self.changed = true
    return self
end

function object:getHeight()
    return self.h
end

function object:getWidth()
    return self.w
end

function object:linkTo(obj)
    if(obj.__type==self.__type)then
        obj.links[self.name] = self
    end
    return self
end

function object:link(obj)
    if(obj.__type==self.__type)then
        self.links[obj.name] = obj
    end
    return self
end

function object:isLinkedTo(obj)
    return (obj[self.name] ~= nil)
end

function object:isLinked(obj)
    return (self[obj.name] ~= nil)
end

function object:setValue(val)
    self.value = val
    self.changed = true
    for _,v in pairs(self.links)do
        v.value = val
        v.changed = true
    end
    callAll(self.changeFunc,self)
    return self
end

function object:getValue()
    return self.value;
end

function object:setTextAlign(halign,valign)
    self.horizontalTextAlign = halign
    if(valign~=nil)then self.verticalTextAlign = valign end
    self.changed = true
    return self
end

function object:drawObject()
    if(self.draw)then
        self.drawCalls = self.drawCalls + 1
    end
end

function object:setAnchor(...)
    if(type(...)=="string")then
            if(...=="right")or(...=="left")then
                self.hanchor = ...
            end
            if(...=="top")or(...=="bottom")then
                self.vanchor = ...
            end
    end
    if(type(...)=="table")then
        for _,v in pairs(...)do
        if(v=="right")or(v=="left")then
            self.hanchor = v
        end
        if(v=="top")or(v=="bottom")then
            self.vanchor = v
        end
    end
end
    return self
end

function object:relativeToAbsolutePosition(x,y) -- relative position
    if(x==nil)then x = self.x end
    if(y==nil)then y = self.y end

    if(self.frame~=nil)then
        local fx,fy = self.frame:relativeToAbsolutePosition()
        x=fx+x-1
        y=fy+y-1
    end
    return x, y
end

function object:relativeToAbsolutePositionOLD(x,y) -- relative position
    if(x==nil)then x = 0 end
    if(y==nil)then y = 0 end

    x = x+self.x;y=y+self.y
    if(self.frame~=nil)then
        x,y = self.frame:relativeToAbsolutePosition(x,y)
        x = x-1; y = y-1
    end
    return x, y
end

function object:getAnchorPosition(x,y)
    if(x==nil)then x = self.x end
    if(y==nil)then y = self.y end
    if(self.hanchor=="right")then
        x = self.frame.w-x-self.w+2
    end
    if(self.vanchor=="bottom")then
        y = self.frame.h-y-self.h+2
    end
    return x, y
end

function object:isFocusedElement()
    if(self.frame~=nil)then
        return self == self.frame.focusedObject
    end
    return false
end

function object:mouseEvent(event,typ,x,y) -- internal class, dont use unless you know what you do
local vx,vy = self:relativeToAbsolutePosition(self:getAnchorPosition())
    if(vx<=x)and(vx+self.w>x)and(vy<=y)and(vy+self.h>y)then
        if(self.frame~=nil)then self.frame:setFocusedElement(self) end
        if(event=="mouse_click")then
            if(self.clickFunc~=nil)then
                callAll(self.clickFunc,self,typ,x,y)
            end
        elseif(event=="mouse_up")then
            if(self.upFunc~=nil)then
                callAll(self.upFunc,self,typ,x,y)
            end
        elseif(event=="mouse_drag")then
            if(self.dragFunc~=nil)then
                callAll(self.dragFunc,self,typ,x,y)
            end
        end
        return true
    end
    return false
end

function object:keyEvent(event,typ) -- internal class, dont use unless you know what you do
    if(self.keyEventFunc~=nil)then
        callAll(self.keyEventFunc,self,typ)
    end
end

function object:setFocus()    
    if(self.frame~=nil)then
        self.frame:setFocusedElement(self)
    end
    return self
end

function object:loseFocusEvent()   
    if(self.loseFocusEventFunc~=nil)then
        callAll(self.loseFocusEventFunc,self)
    end
end

function object:getFocusEvent()    
    if(self.getFocusEventFunc~=nil)then
        callAll(self.getFocusEventFunc,self)
    end
end

function object:setZIndex(index)
    self.frame:changeZIndexOfObj(self,index)
    return self
end
--object end

--Frame object
screen.new = function(name, scrn) -- this is also just a frame, but its a level 0 frame and doesn't inherit
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

function frame:addFrame(frameObj) -- with this you also create frames, but it needs to have a parent frame
    if(self:getObject(frameObj) == nil)then
        local obj
        if(type(frameObj)=="string")then
            obj = frame:new(frameObj,self.fWindow)
        elseif(type(frameObj)=="table")and(frameObj.__type=="Frame")then
            obj = frame:new(frameObj.name,self.fWindow,frameObj)
        end
        obj.frame=self;
        self:addObject(obj)
        return obj;
    else
        return nil, "id "..frameObj.." already exists";
    end
end

function frame:setParentFrame(parent) -- if you want to change the parent of a frame, even level 0 frames can have a parent (they will be 'converted' *habschi*)
    if(parent.__type=="Frame")and(parent~=self.frame)then
        if(self.frame~=nil)then
            self.frame:removeObject(self)
        end
        self.parent = parent.fWindow
        self.frame = parent
        self.fWindow.setVisible(false)
        self.fWindow = window.create(parent.fWindow,self.x,self.y,self.w,self.h)
        self.frame:addObject(self)
        if(self.draw)then 
            self:show() 
        end
    end
    return self
end

function frame:showBar() -- shows top bar
    self.barActive = true
    return self
end

function frame:hideBar() -- hides top bar
    self.barActive = false
    return self
end

function frame:isModifierActive(key)
    if(key==340)or(key=="shift")then
        return keyModifier[340]
    end
    if(key==341)or(key=="ctrl")then
        return keyModifier[341]
    end
    if(key==342)or(key=="alt")then
        return keyModifier[342]
    end
    return keyModifier[key]
end

function frame:setTitle(title,fgcolor,bgcolor) -- changed the title in your top bar
    self.title=title
    if(fgcolor~=nil)then self.titlefgcolor = fgcolor end
    if(bgcolor~=nil)then  self.titlebgcolor = bgcolor end
    self.changed = true
    return self
end

function frame:setTextAlign(align) -- changes title align
    self.horizontalTextAlign = align
    self.changed = true
    return self
end

function frame:setSize(width, height) -- frame size
    object.setSize(self,width,height)
    self.fWindow.reposition(self.x,self.y,width,height)
    return self
end

function frame:setPosition(x,y) -- pos
    object.setPosition(self,x,y)
    self.fWindow.reposition(x,y)
    return self
end

function frame:show() -- you need to call to be able to see the frame
    object.show(self)
    self.fWindow.setBackgroundColor(self.bgcolor)
    self.fWindow.setTextColor(self.fgcolor)
    self.fWindow.setVisible(true)
    self.fWindow.redraw()
    if(self.frame == nil)then
        activeScreen = self
    end
    return self
end

function frame:hide() -- hides the frame (does not remove setted values)
    object.hide(self)
    self.fWindow.setVisible(false)
    self.fWindow.redraw()
    self.parent.clear()
    return self
end

function frame:remove() -- removes the frame completly
    if(self.frame~=nil)then
        object.hide(self)
    end
    self.changed = true
    self.draw = false
    self.fWindow.setVisible(false)
    screens[self.name] = nil
    self.parent.clear()
end

function frame:getObject(name) -- you can find objects by their name
    if(self.objects~=nil)then
        for _,b in pairs(self.objects)do
            for _,v in pairs(b)do
                if(v.name==name)then
                    return v
                end
            end
        end
    end
end

function frame:removeObject(obj) -- you can remove objects by their name
    if(self.objects~=nil)then
        for a,b in pairs(self.objects)do
            for k,v in pairs(b)do
                if(v==obj)then
                    table.remove(self.objects[a],k)
                    return;
                end
            end
        end
    end
end

function frame:addObject(obj) -- you can add a object manually, normaly you shouldn't use this function, it get called internally
    if(self.objects[obj.zIndex]==nil)then
        for x=0,#self.objZKeys do
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
    table.insert(self.objects[obj.zIndex],obj)
end

function frame:drawObject()  -- this draws the frame, you dont need that function, it gets called internally
    object.drawObject(self)
    if(self.draw)then
        if(self.drag)and(self.frame==nil)then
            self.parent.clear()
        end
        self.fWindow.clear()
        if(self.barActive)then
            self.fWindow.setBackgroundColor(self.titlebgcolor)
            self.fWindow.setTextColor(self.titlefgcolor)
            self.fWindow.setCursorPos(1,1)
            self.fWindow.write(getTextHorizontalAlign(self.title,self.w,self.horizontalTextAlign))
        end
        local keys = {}
        for k in pairs(self.objects)do
            table.insert(keys,k)
        end
        for _,b in rpairs(keys)do
            for k,v in pairs(self.objects[b])do  
                if(v.draw~=nil)then  
                    v:drawObject()
                end
            end
        end
        if(self.focusedObject.cursorX~=nil)and(self.focusedObject.cursorY~=nil)then        
            self.fWindow.setCursorPos(self.focusedObject.cursorX, self.focusedObject.cursorY)
            --self.fWindow.setCursorBlink(true)
        end
        self.fWindow.setBackgroundColor(self.bgcolor)
        self.fWindow.setTextColor(self.fgcolor)
        self.fWindow.setVisible(true)
        self.fWindow.redraw()
    end
end

function frame:mouseEvent(event,typ,x,y) -- internal mouse event, should make it local but as lazy i am..
    local fx,fy = self:relativeToAbsolutePosition(self:getAnchorPosition())
    if(self.drag)and(self.draw)then        
        if(event=="mouse_drag")then
            local parentX=1;local parentY=1
            if(self.frame~=nil)then
                parentX,parentY = self.frame:relativeToAbsolutePosition(self.frame:getAnchorPosition())
            end
            self:setPosition(x+self.xToRem-(parentX-1),y-(parentY-1))
        end
        if(event=="mouse_up")then
            self.drag = false
        end
        return true
    end

    if(object.mouseEvent(self,event,typ,x,y))then
        if(x>fx+self.w-1)or(y>fy+self.h-1)then return end
            local keys = {}
            for k in pairs(self.objects)do
                table.insert(keys,k)
            end
            for _,b in pairs(keys)do
                for _,v in rpairs(self.objects[b])do
                    if(v.draw~=false)then                
                        if(v:mouseEvent(event,typ,x,y))then
                            return true
                        end
                    end
                end
            end
        if(self.isMoveable)then
            if(x>=fx)and(x<=fx+self.w)and(y==fy)and(event=="mouse_click")then
                self.drag = true
                self.xToRem = fx-x
            end
        end
    end
    if(fx<=x)and(fx+self.w>x)and(fy<=y)and(fy+self.h>y)then
        self:removeFocusedElement()
        return true
    end
    return false
end

function frame:keyEvent(event,key)-- internal key event, should make it local but as lazy i am..
    for _,b in pairs(self.objects)do
        for _,v in pairs(b)do
            if(v.draw~=false)then
                if(v:keyEvent(event,key))then
                    return true
                end
            end
        end
    end
    return false
end

function frame:changeZIndexOfObj(obj, zindex)-- this function is not working right now
    self.objects[obj.zIndex][obj.name] =  nil
    obj.zIndex = zindex
    self:addObject(obj)
end

function frame:setFocusedElement(obj)-- you can set the focus of an element in a frame
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

function frame:removeFocusedElement()-- and here you can remove the focus
    if(self.focusedObject.name~=nil)then
        self.focusedObject:loseFocusEvent()
    end
    self.focusedObject = {}
end

function frame:getFocusedElement()--gets the current focused element
    return self.focusedObject
end

function frame:loseFocusEvent()--event which gets fired when the frame lost the focus in this case i remove the cursor blink from the active input object
    object.loseFocusEvent(self)
    self.inputActive = false
    self.fWindow.setCursorBlink(false)
end

function frame:getFocusEvent()--event which gets fired when the frame gets the focus
local frameList = {}
    for k,v in pairs(self.frame.objects[self.zIndex])do
        if(self~=v)then
            table.insert(frameList,v)
        end
    end
    table.insert(frameList,self)
    self.frame.objects[self.zIndex] = frameList
    self.changed = true
end


function frame:setMoveable(mv)--you can make the frame moveable (Todo: i want to make all objects moveable, so i can create a ingame gui editor MUHUHHUH)
    self.isMoveable = mv
    return self;
end
--Frames end


--Timer object
function frame:addTimer(name)--adds the timer object
    if(self:getObject(name) == nil)then
        local obj = timer:new()
        obj.name = name;obj.frame=self;
        self:addObject(obj)
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
end

function timer:setTime(timer, repeats)--tobecontinued
    self.timer = timer
    if(repeats==nil)then repeats = -1 end
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
        if(self.value)then
            self.frame.fWindow.write(self.symbol)
        else
            self.frame.fWindow.write(" ")
        end
        self.changed = false
    end
end

function checkbox:mouseEvent(event,typ,x,y) -- we have to switch the order of object.mouseEvent with checkbox:mouseEvent, because the value should be changed before we call user click events
    local vx,vy = self:relativeToAbsolutePosition(self:getAnchorPosition())
    if(vx<=x)and(vx+self.w>x)and(vy<=y)and(vy+self.h>y)then
        if(event=="mouse_click")then
            self:setValue(not self.value)
            self.changed = true
        end
    end
    if(object.mouseEvent(self,event,typ,x,y))then return true end
    return false
end
--Checkbox end

--Radio object
function frame:addRadio(name)
    if(self:getObject(name) == nil)then
        local obj = radio:new()
        obj.name = name;obj.frame=self;
        obj.bgcolor = self.bgcolor
        obj.fgcolor = self.fgcolor
        self:addObject(obj)
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
end

function radio:setSymbol(symbol)
    self.symbol = string.sub(symbol,1,1)
    self.changed = true
    return self
end

function radio:addElement(text,x,y,bgcolor,fgcolor)
    if(x==nil)or(y==nil)then
        table.insert(self.elements,{text=text,bgcolor=(bgcolor ~= nil and bgcolor or self.bgcolor),fgcolor=(fgcolor ~= nil and fgcolor or self.fgcolor),x=0,y=#self.elements})
    else
        table.insert(self.elements,{text=text,bgcolor=(bgcolor ~= nil and bgcolor or self.bgcolor),fgcolor=(fgcolor ~= nil and fgcolor or self.fgcolor),x=x,y=y})
    end
    if(#self.elements==1)then
        self:setValue(self.elements[1])
    end
    return self
end

function radio:mouseEvent(event,typ,x,y)
    if(object.mouseEvent(self,event,typ,x,y))then
        if(#self.elements>0)then
            local dx,dy = self:relativeToAbsolutePosition(self:getAnchorPosition())
            for _,v in pairs(self.elements)do
                if(dx<=x)and(dx+v.x+string.len(v.text)+1>x)and(dy+v.y==y)then
                    self:setValue(v)
                    self.changed = true
                    if(self.changeFunc~=nil)then
                        self.changeFunc(self)
                    end
                    return true
                end
            end
        end
    end
    return false
end

function radio:drawObject()
    object.drawObject(self) -- Base class
    if(self.draw)then
        if(#self.elements>0)then
            for _,v in ipairs(self.elements)do
                local objx, objy = self:getAnchorPosition()
                self.frame.fWindow.setBackgroundColor(v.bgcolor)
                self.frame.fWindow.setTextColor(v.fgcolor)
                self.frame.fWindow.setCursorPos(objx+v.x,objy+v.y)
                if(v==self.value)then
                    self.frame.fWindow.write(self.symbol..v.text)
                else
                    self.frame.fWindow.write(" "..v.text)
                end
            end
        end
        self.changed = false
    end
end
--Radio end

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

function input:mouseEvent(event,typ,x,y)
    if(object.mouseEvent(self,event,typ,x,y))then
        local anchX,anchY = self:getAnchorPosition()
        self.frame.fWindow.setCursorPos(anchX+(string.len(self.value) < self.w-1 and string.len(self.value) or self.w-1),anchY)
        self.cursorX = anchX+(string.len(self.value) < self.w-1 and string.len(self.value) or self.w-1)
        self.cursorY = anchY
        self.frame.fWindow.setCursorBlink(true)
        return true
    end
    return false
end

function input:keyEvent(event,key)
    if(self:isFocusedElement())then
        if(self.draw)then
            if(event=="key")then
                if(key==259)then
                    self:setValue(string.sub(self.value,1,string.len(self.value)-1))
                end
                if(key==257)then -- on enter
                    if(self.inputActive)then
                        self.inputActive = false
                        self.fWindow.setCursorBlink(false)
                    end
                end
            end
            if(event=="char")then
                self:setValue(self.value..key)
            end
            local anchX,anchY = self:getAnchorPosition()
            self.cursorX = anchX+(string.len(self.value) < self.w and string.len(self.value) or self.w-1)
            self.cursorY = anchY
            if(self.changeFunc~=nil)then
                self.changeFunc(self.acveInput)
            end
        end
    end
end

function input:drawObject()
    object.drawObject(self) -- Base class
    local text = ""
    if(self.draw)then
        if(string.len(self.value)>=self.w)then
            text = string.sub(self.value, string.len(self.value)-self.w+2, string.len(self.value))
        else
            text = self.value
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
        local x,y = self:getAnchorPosition()
        local yOffset = getTextVerticalAlign(self.h,self.verticalTextAlign)
            self.frame.fWindow.setBackgroundColor(self.bgcolor)
            self.frame.fWindow.setTextColor(self.fgcolor)
        for line=0,self.h-1 do
            self.frame.fWindow.setCursorPos(x,y+line)
            if(line==yOffset)then
                self.frame.fWindow.write(getTextHorizontalAlign(self.text, self.w, self.horizontalTextAlign))
            else
                self.frame.fWindow.write(string.rep(" ", self.w))
            end
        end
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
        self:setValue(self.elements[1])
    end
    return self
end

function dropdown:drawObject()
    object.drawObject(self) -- Base class
    if(self.draw)then
        self.frame.fWindow.setCursorPos(self:getAnchorPosition())
        self.frame.fWindow.setBackgroundColor(self.value.bgcolor)
        self.frame.fWindow.setTextColor(self.value.fgcolor)
        self.frame.fWindow.write(getTextHorizontalAlign(self.value.text, self.w, self.horizontalTextAlign))

        if(self:isFocusedElement())then
            print("asd")
            if(#self.elements>0)then
                local index = 1
                for _,v in ipairs(self.elements)do
                    local objx, objy = self:getAnchorPosition()
                    self.frame.fWindow.setBackgroundColor(v.bgcolor)
                    self.frame.fWindow.setTextColor(v.fgcolor)
                    self.frame.fWindow.setCursorPos(objx,objy+index)
                    self.frame.fWindow.write(getTextHorizontalAlign(v.text, self.w, self.horizontalTextAlign))
                    index = index+1
                end
            end
        end
        self.changed = false
    end
end

function dropdown:mouseEvent(event,typ,x,y)
    object.mouseEvent(self,event,typ,x,y)
    if(self:isFocusedElement())then
        if(#self.elements>0)then
            local dx,dy = self:relativeToAbsolutePosition(self:getAnchorPosition())
            local index = 1
            for _,b in pairs(self.elements)do
                if(dx<=x)and(dx+self.w>x)and(dy+index==y)then
                    self:setValue(b)
                    if(self.changeFunc~=nil)then
                        self.changeFunc(self)
                    end
                    self.frame:removeFocusedElement()
                    return true
                end
                index = index+1
            end
            if not((dx<=x)and(dx+self.w>x)and(dy<=y)and(dy+self.h>y))then
                self.frame:removeFocusedElement()
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
        for index=0,self.h-1 do
            self.frame.fWindow.setCursorPos(self:getAnchorPosition(self.x,self.y+index))
            self.frame.fWindow.setBackgroundColor(self.bgcolor)

            if(self.elements[index+self.index]~=nil)then
                self.frame.fWindow.setBackgroundColor(self.elements[index+self.index].bgcolor)
                self.frame.fWindow.setTextColor(self.elements[index+self.index].fgcolor)
                if(self.elements[index+self.index]==self.value)then
                    self.frame.fWindow.write(self.symbol..getTextHorizontalAlign(self.elements[index+self.index].text, self.w-string.len(self.symbol), self.horizontalTextAlign))
                else
                    self.frame.fWindow.write(string.rep(" ", string.len(self.symbol))..getTextHorizontalAlign(self.elements[index+self.index].text, self.w-string.len(self.symbol), self.horizontalTextAlign))
                end
            else
                self.frame.fWindow.write(getTextHorizontalAlign(" ", self.w, self.horizontalTextAlign))
            end
        end
        self.changed = false
    end
end

function list:mouseEvent(event,typ,x,y)
    if(object.mouseEvent(self,event,typ,x,y))then
        if(event=="mouse_click")or(event=="mouse_drag")then -- remove mouse_drag if i want to make objects moveable uwuwuwuw
            if(#self.elements>0)then
                local dx,dy = self:relativeToAbsolutePosition(self:getAnchorPosition())
                for index=0,self.h do
                    if(self.elements[index+self.index]~=nil)then
                        if(dx<=x)and(dx+self.w>x)and(dy+index==y)then
                            self:setValue(self.elements[index+self.index])
                            self.changed = true
                            return true
                        end
                    end
                end
            end
        end
        if(event=="mouse_scroll")then
            self.index = self.index+typ
            if(self.index<1)then self.index = 1 end
            if(typ==1)then if(#self.elements>self.h)then if(self.index>#self.elements-self.h)then self.index = #self.elements-self.h end else self.index = self.index-1 end end
            self.changed = true
            return true
        end
    end
    return false
end

function list:addElement(text,bgcolor,fgcolor,...)
    table.insert(self.elements,{text=text,bgcolor=(bgcolor ~= nil and bgcolor or self.bgcolor),fgcolor=(fgcolor ~= nil and fgcolor or self.fgcolor),vars=...})
    if(#self.elements==1)then
        self:setValue(self.elements[1])
    end
    return self
end

function list:removeElement(element)
    if(type(element)=="table")then
        for k,v in pairs(self.elements)do
            if(v==element)then
                table.remove(self.elements,k)
                break;
            end
        end
    end
    return self
end

function list:setSymbol(symbol)
    self.symbol = string.sub(symbol,1,1)
    self.changed = true
    return self
end

function frame:addTextfield(name)
    if(self:getObject(name) == nil)then
        local obj = textfield:new()
        obj.name = name;obj.frame=self;
        self:addObject(obj)
        return obj;
    else
        return nil, "id "..name.." already exists";
    end
end

function textfield:keyEvent(event,key)
    if(self:isFocusedElement())then
        if(self.draw)then
            local anchX,anchY = self:getAnchorPosition()
            if(event=="key")then
                if(key==259)then -- on backspace
                    if(self.lines[self.textY]=="")then
                        if(self.textY>1)then
                            table.remove(self.lines,self.textY)
                            self.textX = self.lines[self.textY-1]:len()+1
                            self.wIndex = self.textX-self.w+1
                            if(self.wIndex<1)then self.wIndex = 1 end
                            self.textY = self.textY-1
                        end
                    elseif(self.textX<=1)then
                        if(self.textY>1)then
                            self.textX = self.lines[self.textY-1]:len()+1
                            self.wIndex = self.textX-self.w+1
                            if(self.wIndex<1)then self.wIndex = 1 end
                            self.lines[self.textY-1] = self.lines[self.textY-1]..self.lines[self.textY]
                            table.remove(self.lines,self.textY)
                            self.textY = self.textY-1
                        end
                    else
                        self.lines[self.textY] = self.lines[self.textY]:sub(1,self.textX-2)..self.lines[self.textY]:sub(self.textX,self.lines[self.textY]:len())
                        if(self.textX>1)then self.textX = self.textX-1 end
                        if(self.wIndex>1)then
                            if(self.textX<self.wIndex)then
                                self.wIndex = self.wIndex-1
                            end
                        end
                    end
                    if(self.textY<self.hIndex)then
                        self.hIndex = self.hIndex-1
                    end
                end
                if(key==257)then -- on enter
                    table.insert(self.lines,self.textY+1,self.lines[self.textY]:sub(self.textX,self.lines[self.textY]:len()))
                    self.lines[self.textY] = self.lines[self.textY]:sub(1,self.textX-1)

                    self.textY = self.textY+1
                    self.textX = 1
                    self.wIndex = 1
                    if(self.textY-self.hIndex>=self.h)then
                        self.hIndex = self.hIndex+1
                    end
                end
                if(key==258)then -- on tab

                    --self.lines[self.textY] = self.lines[self.textY]..string.rep(" ",self.w-(self.w-self.lines[self.textY]:len()))
                end
                if(key==265)then -- arrow up
                    if(self.textY>1)then
                        self.textY = self.textY-1
                        if(self.textX>self.lines[self.textY]:len()+1)then self.textX = self.lines[self.textY]:len()+1 end
                        if(self.wIndex>1)then
                            if(self.textX<self.wIndex)then
                                self.wIndex = self.textX-self.w+1                                
                                if(self.wIndex<1)then self.wIndex = 1 end
                            end
                        end
                        if(self.hIndex>1)then
                            if(self.textY<self.hIndex)then
                                self.hIndex = self.hIndex-1
                            end
                        end
                    end
                end
                if(key==264)then -- arrow down
                    if(self.textY<#self.lines)then
                        self.textY = self.textY+1
                        if(self.textX>self.lines[self.textY]:len()+1)then self.textX = self.lines[self.textY]:len()+1 end

                        if(self.textY>=self.hIndex+self.h)then
                            self.hIndex = self.hIndex+1
                        end
                    end
                end
                if(key==262)then -- arrow right
                    self.textX = self.textX+1
                    if(self.textY<#self.lines)then
                        if(self.textX>self.lines[self.textY]:len()+1)then
                            self.textX = 1
                            self.textY = self.textY+1
                        end
                    elseif(self.textX > self.lines[self.textY]:len())then
                        self.textX = self.lines[self.textY]:len()+1
                    end
                    if(self.textX<1)then self.textX = 1 end
                    if(self.textX<self.wIndex)or(self.textX>=self.w+self.wIndex)then
                        self.wIndex = self.textX-self.w+1
                    end 
                    if(self.wIndex<1)then self.wIndex = 1 end 

                end
                if(key==263)then -- arrow left
                    self.textX = self.textX-1
                    if(self.textX>=1)then
                        if(self.textX<self.wIndex)or(self.textX>=self.w+self.wIndex)then
                            self.wIndex = self.textX+1
                        end  
                    end
                    if(self.textY>1)then
                        if(self.textX<1)then
                            self.textY = self.textY-1
                            self.textX = self.lines[self.textY]:len()+1
                            self.wIndex = self.textX-self.w+1
                        end
                    end
                    if(self.textX<1)then self.textX = 1 end     
                    if(self.wIndex<1)then self.wIndex = 1 end 
                end
            end
            if(event=="char")then
                self.lines[self.textY] = self.lines[self.textY]:sub(1,self.textX-1)..key..self.lines[self.textY]:sub(self.textX,self.lines[self.textY]:len())
                self.textX = self.textX+1
                if(self.textX>=self.w+self.wIndex)then self.wIndex = self.wIndex+1 end
            end
            self.cursorX = anchX+(self.textX <= self.lines[self.textY]:len() and self.textX-1 or self.lines[self.textY]:len())-(self.wIndex-1)
            if(self.cursorX>self.x+self.w-1)then self.cursorX = self.x+self.w-1 end
            self.cursorY = anchY+(self.textY-self.hIndex < self.h and self.textY-self.hIndex or self.textY-self.hIndex-1)
            if(self.changeFunc~=nil)then
                callAll(self.changeFunc)
            end
        end
    end
end

function textfield:mouseEvent(event,typ,x,y)
    if(object.mouseEvent(self,event,typ,x,y))then
        if(event=="mouse_click")then
            local anchX,anchY = self:getAnchorPosition()
            local absX,absY = self:relativeToAbsolutePosition(self:getAnchorPosition())
            if(self.lines[y-absY+self.hIndex]~=nil)then
                self.textX = x-absX+self.wIndex
                self.textY = y-absY+self.hIndex
                if(self.textX>self.lines[self.textY]:len())then
                    self.textX = self.lines[self.textY]:len()+1
                end
                if(self.textX<self.wIndex)then
                    self.wIndex = self.textX-1
                    if(self.wIndex<1)then self.wIndex = 1 end
                end
                debug(self.wIndex)
                self.cursorX = anchX+self.textX-self.wIndex
                self.cursorY = anchY+self.textY-self.hIndex
                self.frame.fWindow.setCursorBlink(true)
                self.changed = true
            end

        end
        if(event=="mouse_scroll")then -- buggggy
            self.hIndex = self.hIndex+typ
            if(self.hIndex<1)then self.hIndex = 1 end
            if(self.hIndex>=#self.lines-self.h)then self.hIndex = #self.lines-self.h end
            self.changed = true
        end
        return true
    end
    return false
end

function textfield:drawObject()
    object.drawObject(self) -- Base class
    if(self.draw)then
        for index=0,self.h-1 do
            self.frame.fWindow.setBackgroundColor(self.bgcolor)
            self.frame.fWindow.setTextColor(self.fgcolor)
            local text = ""
            if(self.lines[index+self.hIndex]~=nil)then 
                text = self.lines[index+self.hIndex]
            end
            text = text:sub(self.wIndex, self.w+self.wIndex-1)      
            local n = self.w-text:len()
            if(n<0)then n = 0 end
            text = text..string.rep(" ", n)

            self.frame.fWindow.setCursorPos(self:getAnchorPosition(self.x,self.y+index))
            self.frame.fWindow.write(text)
        end
        if(self.cursorX==nil)or(self.cursorX<self.x)or(self.cursorX>self.x+self.w)then self.cursorX = self.x end
        if(self.cursorY==nil)or(self.cursorY<self.y)or(self.cursorY>self.y+self.h)then self.cursorY = self.y end
        self.frame.fWindow.setCursorPos(self.cursorX,self.cursorY)

        self.changed = false
    end
end


function textfield:getFocusEvent()
    object.getFocusEvent(self)
    self.frame.fWindow.setCursorPos(1,1)
    self.frame.fWindow.setCursorBlink(true)
end

function textfield:loseFocusEvent()
    object.loseFocusEvent(self)
    self.frame.fWindow.setCursorBlink(false)
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
    if not(screen.updater)then
        handleChangedObjectsEvent()
        screen.updater = true
        while screen.updater do
            local event, p1,p2,p3,p4 = os.pullEvent()
            activeScreen.changed = true
            if(event=="mouse_click")then
                activeScreen:mouseEvent(event,p1,p2,p3)
            end
            if(event=="mouse_scroll")then
                activeScreen:mouseEvent(event,p1,p2,p3)
            end
            if(event=="mouse_drag")then
                activeScreen:mouseEvent(event,p1,p2,p3)
            end
            if(event=="mouse_up")then
                activeScreen:mouseEvent(event,p1,p2,p3)
            end
            if(event=="timer")then
                checkTimer(p1)
            end
            if(event=="char")or(event=="key")then
                activeScreen:keyEvent(event,p1)
                keyModifier[p1] = true
            end
            if(event=="key_up")then
                keyModifier[p1] = false
            end
            handleChangedObjectsEvent()
        end
    end
end

function screen.stopUpdate()
    screen.updater = false
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