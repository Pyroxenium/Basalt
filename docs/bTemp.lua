local project = {} 
local packaged = true 
local baseRequire = require 
local require = function(path)
    for k,v in pairs(project)do
        if(type(v)=="table")then
            for name,b in pairs(v)do
                if(name==path)then
                    return b()
                end
            end
        else
            if(k==path)then
                return v()
            end
        end
    end
    return baseRequire(path);
end
local getProject = function(subDir)
    if(subDir~=nil)then
        return project[subDir]
    end
    return project
end

project["main"] = function(...)
local basaltEvent = require("basaltEvent")()
local baseObjects = require("loadObjects")
local moddedObjects
local pluginSystem = require("plugin")
local utils = require("utils")
local log = require("basaltLogs")
local uuid = utils.uuid
local wrapText = utils.wrapText
local count = utils.tableCount
local moveThrottle = 300
local dragThrottle = 0
local renderingThrottle = 0
local newObjects = {}

local baseTerm = term.current()
local version = "1.7.0"

local projectDirectory = fs.getDir(table.pack(...)[2] or "")

local activeKey, frames, monFrames, variables, schedules = {}, {}, {}, {}, {}
local mainFrame, activeFrame, focusedObject, updaterActive

local basalt = {}

if not  term.isColor or not term.isColor() then
    error('Basalt requires an advanced (golden) computer to run.', 0)
end

local defaultColors = {}
for k,v in pairs(colors)do
    if(type(v)=="number")then
        defaultColors[k] = {baseTerm.getPaletteColor(v)}
    end
end


local function stop()
    updaterActive = false    
    baseTerm.clear()
    baseTerm.setCursorPos(1, 1)
    for k,v in pairs(colors)do
        if(type(v)=="number")then
            baseTerm.setPaletteColor(v, colors.packRGB(table.unpack(defaultColors[k])))
        end
    end
end

local function schedule(f)
assert(f~="function", "Schedule needs a function in order to work!")
return function(...)
        local co = coroutine.create(f)
        local ok, result = coroutine.resume(co, ...)
        if(ok)then
            table.insert(schedules, co)
        else
            basalt.basaltError(result)
        end
    end
end

basalt.log = function(...)
    log(...)
end

local setVariable = function(name, var)
    variables[name] = var
end

local getVariable = function(name)
    return variables[name]
end

local bInstance = {
    getDynamicValueEventSetting = function()
        return basalt.dynamicValueEvents
    end,
    
    getMainFrame = function()
        return mainFrame
    end,

    setVariable = setVariable,
    getVariable = getVariable,

    setMainFrame = function(mFrame)
        mainFrame = mFrame
    end,

    getActiveFrame = function()
        return activeFrame
    end,

    setActiveFrame = function(aFrame)
        activeFrame = aFrame
    end,

    getFocusedObject = function()
        return focusedObject
    end,

    setFocusedObject = function(focused)
        focusedObject = focused
    end,
    
    getMonitorFrame = function(name)
        return monFrames[name] or monGroups[name][1]
    end,

    setMonitorFrame = function(name, frame, isGroupedMon)
        if(mainFrame == frame)then mainFrame = nil end
        if(isGroupedMon)then
            monGroups[name] = {frame, sides}
        else
            monFrames[name] = frame
        end
        if(frame==nil)then
            monGroups[name] = nil
        end
    end,

    getTerm = function()
        return baseTerm
    end,

    schedule = schedule,

    stop = stop,
    debug = basalt.debug,
    log = basalt.log,

    getObjects = function()
        return moddedObjects
    end,

    getObject = function(id)
        return moddedObjects[id]
    end,

    getDirectory = function()
        return projectDirectory
    end
}

local function defaultErrorHandler(errMsg)
    baseTerm.clear()
    baseTerm.setBackgroundColor(colors.black)
    baseTerm.setTextColor(colors.red)
    local w,h = baseTerm.getSize()
    if(basalt.logging)then
        log(errMsg, "Error")
    end

    local text = wrapText("Basalt error: "..errMsg, w)
    local yPos = 1
    for _,v in pairs(text)do
        baseTerm.setCursorPos(1,yPos)
        baseTerm.write(v)
        yPos = yPos + 1
    end 
    baseTerm.setCursorPos(1,yPos+1)
    updaterActive = false
end

local function handleSchedules(event, p1, p2, p3, p4)
    if(#schedules>0)then
        local finished = {}
        for n=1,#schedules do
            if(schedules[n]~=nil)then 
                if (coroutine.status(schedules[n]) == "suspended")then
                    local ok, result = coroutine.resume(schedules[n], event, p1, p2, p3, p4)
                    if not(ok)then
                        basalt.basaltError(result)
                    end
                else
                    table.insert(finished, n)
                end
            end
        end
        for n=1,#finished do
            table.remove(schedules, finished[n]-(n-1))
        end
    end
end

local function drawFrames()
    if(updaterActive==false)then return end
    if(mainFrame~=nil)then
        mainFrame:render()
        mainFrame:updateTerm()
    end
    for _,v in pairs(monFrames)do
        v:render()
        v:updateTerm()
    end
end

local stopped, moveX, moveY = nil, nil, nil
local moveTimer = nil
local function mouseMoveEvent(_, stp, x, y)
    stopped, moveX, moveY = stp, x, y
    if(moveTimer==nil)then
        moveTimer = os.startTimer(moveThrottle/1000)
    end
end

local function moveHandlerTimer()
    moveTimer = nil
    mainFrame:hoverHandler(moveX, moveY, stopped)
    activeFrame = mainFrame
end

local btn, dragX, dragY = nil, nil, nil
local dragTimer = nil
local function dragHandlerTimer()
    dragTimer = nil
    mainFrame:dragHandler(btn, dragX, dragY)
    activeFrame = mainFrame
end

local function mouseDragEvent(_, b, x, y)
    btn, dragX, dragY = b, x, y
    if(dragThrottle<50)then 
        dragHandlerTimer() 
    else
        if(dragTimer==nil)then
            dragTimer = os.startTimer(dragThrottle/1000)
        end
    end
end


local renderingTimer = nil
local function renderingUpdateTimer()
    renderingTimer = nil
    drawFrames() 
end

local function renderingUpdateEvent(timer)
    if(renderingThrottle<50)then 
        drawFrames() 
    else
        if(renderingTimer==nil)then
            renderingTimer = os.startTimer(renderingThrottle/1000)
        end
    end
end

local function basaltUpdateEvent(event, ...)
    local a = {...}
    if(basaltEvent:sendEvent("basaltEventCycle", event, ...)==false)then return end
    if(event=="terminate")then basalt.stop() end
    if(mainFrame~=nil)then
        local mouseEvents = {
            mouse_click = mainFrame.mouseHandler,
            mouse_up = mainFrame.mouseUpHandler,
            mouse_scroll = mainFrame.scrollHandler,
            mouse_drag = mouseDragEvent,
            mouse_move = mouseMoveEvent,
        }
        local mouseEvent = mouseEvents[event]
        if(mouseEvent~=nil)then
            mouseEvent(mainFrame, ...)
            handleSchedules(event, ...)
            renderingUpdateEvent()
            return
        end
    end

    if(event == "monitor_touch") then
        for k,v in pairs(monFrames)do
            if(v:mouseHandler(1, a[2], a[3], true, a[1]))then
                activeFrame = v
            end
        end
        handleSchedules(event, ...)
        renderingUpdateEvent()
        return
    end

    if(activeFrame~=nil)then
    local keyEvents = {
        char = activeFrame.charHandler,
        key = activeFrame.keyHandler,
        key_up = activeFrame.keyUpHandler,
    }
    local keyEvent = keyEvents[event]
        if(keyEvent~=nil)then
            if(event == "key")then
                activeKey[a[1]] = true
            elseif(event == "key_up")then
                activeKey[a[1]] = false
            end
            keyEvent(activeFrame, ...)
            handleSchedules(event, ...)
            renderingUpdateEvent()
            return
        end
    end

    if(event=="timer")and(a[1]==moveTimer)then
        moveHandlerTimer()
    elseif(event=="timer")and(a[1]==dragTimer)then
        dragHandlerTimer()
    elseif(event=="timer")and(a[1]==renderingTimer)then
        renderingUpdateTimer()
    else
        for _, v in pairs(frames) do
            v:eventHandler(event, ...)
        end
        for _, v in pairs(monFrames) do
            v:eventHandler(event, ...)
        end
        handleSchedules(event, ...)
        renderingUpdateEvent()
    end
end

local loadedObjects = false
local loadedPlugins = false
local function InitializeBasalt()
    if not(loadedObjects)then
        for _,v in pairs(newObjects)do
            if(fs.exists(v))then
                if(fs.isDir(v))then
                    local files = fs.list(v)
                    for _,object in pairs(files)do
                        if not(fs.isDir(v.."/"..object))then
                            local name = object:gsub(".lua", "")
                            if(name~="example.lua")and not(name:find(".disabled"))then
                                if(baseObjects[name]==nil)then
                                    baseObjects[name] = require(v.."."..object:gsub(".lua", ""))
                                else
                                    error("Duplicate object name: "..name)
                                end
                            end
                        end
                    end
                else
                    local name = v:gsub(".lua", "")
                    if(baseObjects[name]==nil)then
                        baseObjects[name] = require(name)
                    else
                        error("Duplicate object name: "..name)
                    end
                end
            end
        end
        loadedObjects = true
    end
    if not(loadedPlugins)then
        moddedObjects = pluginSystem.loadPlugins(baseObjects, bInstance)
        local basaltPlugins = pluginSystem.get("basalt")
        if(basaltPlugins~=nil)then
            for k,v in pairs(basaltPlugins)do
                for a,b in pairs(v(basalt))do
                    basalt[a] = b
                    bInstance[a] = b
                end
            end
        end
        local basaltPlugins = pluginSystem.get("basaltInternal")
        if(basaltPlugins~=nil)then
            for _,v in pairs(basaltPlugins)do
                for a,b in pairs(v(basalt))do
                    bInstance[a] = b
                end
            end
        end
        loadedPlugins = true
    end
end

local function createFrame(name)
    InitializeBasalt()
    for _, v in pairs(frames) do
        if (v:getName() == name) then
            return nil
        end
    end
    local newFrame = moddedObjects["BaseFrame"](name, bInstance)
    newFrame:init()
    newFrame:load()
    newFrame:draw()
    table.insert(frames, newFrame)
    if(mainFrame==nil)and(newFrame:getName()~="basaltDebuggingFrame")then
        newFrame:show()
    end
    return newFrame
end

basalt = {
    basaltError = defaultErrorHandler,
    logging = false,
    dynamicValueEvents = false,
    drawFrames = drawFrames,
    log = log,
    getVersion = function()
        return version
    end,

    memory = function()
        return math.floor(collectgarbage("count")+0.5).."KB"
    end,
    
    addObject = function(path)
        if(fs.exists(path))then
            table.insert(newObjects, path)
        end
    end,

    addPlugin = function(path)
        pluginSystem.addPlugin(path)
    end,

    getAvailablePlugins = function()
        return pluginSystem.getAvailablePlugins()
    end,

    getAvailableObjects = function()
        local objectNames = {}
        for k,_ in pairs(baseObjects)do
            table.insert(objectNames, k)
        end
        return objectNames
    end,

    setVariable = setVariable,
    getVariable = getVariable,

    setBaseTerm = function(_baseTerm)
        baseTerm = _baseTerm
    end,

    resetPalette = function()
        for k,v in pairs(colors)do
            if(type(v)=="number")then
                --baseTerm.setPaletteColor(v, colors.packRGB(table.unpack(defaultColors[k])))
            end
        end
    end,

    setMouseMoveThrottle = function(amount)
        if(_HOST:find("CraftOS%-PC"))then
            if(config.get("mouse_move_throttle")~=10)then config.set("mouse_move_throttle", 10) end
            if(amount<100)then
                moveThrottle = 100
            else
                moveThrottle = amount
            end
            return true
        end
        return false
    end,

    setRenderingThrottle = function(amount)
        if(amount<=0)then
            renderingThrottle = 0
        else
            renderingTimer = nil
            renderingThrottle = amount
        end
    end,

    setMouseDragThrottle = function(amount)
        if(amount<=0)then
            dragThrottle = 0
        else
            dragTimer = nil
            dragThrottle = amount
        end
    end,

    autoUpdate = function(isActive)
        updaterActive = isActive
        if(isActive==nil)then updaterActive = true end
        local function f()
            drawFrames()
            while updaterActive do
                basaltUpdateEvent(os.pullEventRaw())
            end
        end
        while updaterActive do
            local ok, err = xpcall(f, debug.traceback)
            if not(ok)then
                basalt.basaltError(err)
            end
        end
    end,
    
    update = function(event, ...)
        if (event ~= nil) then
            local args = {...}
            local ok, err = xpcall(function() basaltUpdateEvent(event, table.unpack(args)) end, debug.traceback)
            if not(ok)then
                basalt.basaltError(err)
                return
            end
        end
    end,
    
    stop = stop,
    stopUpdate = stop,
    
    isKeyDown = function(key)
        if(activeKey[key]==nil)then return false end
        return activeKey[key];
    end,
    
    getFrame = function(name)
        for _, value in pairs(frames) do
            if (value.name == name) then
                return value
            end
        end
    end,
    
    getActiveFrame = function()
        return activeFrame
    end,
    
    setActiveFrame = function(frame)
        if (frame:getType() == "Container") then
            activeFrame = frame
            return true
        end
        return false
    end,

    getMainFrame = function()
        return mainFrame
    end,
    
    onEvent = function(...)
        for _,v in pairs(table.pack(...))do
            if(type(v)=="function")then
                basaltEvent:registerEvent("basaltEventCycle", v)
            end
        end
    end,

    schedule = schedule,
    
    addFrame  = createFrame,
    createFrame = createFrame,

    addMonitor = function(name)
        InitializeBasalt()
        for _, v in pairs(frames) do
            if (v:getName() == name) then
                return nil
            end
        end
        local newFrame = moddedObjects["MonitorFrame"](name, bInstance)
        newFrame:init()
        newFrame:load()
        newFrame:draw()
        table.insert(monFrames, newFrame)
        return newFrame
    end,
    
    removeFrame = function(name)
        frames[name] = nil
    end,

    setProjectDir = function(dir)
        projectDirectory = dir
    end,
}

local basaltPlugins = pluginSystem.get("basalt")
if(basaltPlugins~=nil)then
    for k,v in pairs(basaltPlugins)do
        for a,b in pairs(v(basalt))do
            basalt[a] = b
            bInstance[a] = b
        end
    end
end
local basaltPlugins = pluginSystem.get("basaltInternal")
if(basaltPlugins~=nil)then
    for k,v in pairs(basaltPlugins)do
        for a,b in pairs(v(basalt))do
            bInstance[a] = b
        end
    end
end

return basalt

end
project["loadObjects"] = function(...)
local _OBJECTS = {}

if(packaged)then
    for k,v in pairs(getProject("objects"))do
        _OBJECTS[k] = v()
    end
    return _OBJECTS
end

local args = table.pack(...)
local dir = fs.getDir(args[2] or "Basalt")
if(dir==nil)then
    error("Unable to find directory "..args[2].." please report this bug to our discord.")
end

for _,v in pairs(fs.list(fs.combine(dir, "objects")))do
    if(v~="example.lua")and not(v:find(".disabled"))then
        local name = v:gsub(".lua", "")
        _OBJECTS[name] = require(name)
    end
end
return _OBJECTS
end
project["plugins"] = {}

project["plugins"]["basaltAdditions"] = function(...)
return {
    basalt = function()
        return {
            cool = function()
                print("ello")
                sleep(2)
            end
        }
    end
}
end
project["plugins"]["advancedBackground"] = function(...)
local utils = require("utils")
local xmlValue = utils.xmlValue

return {
    VisualObject = function(base)
        local bgSymbol = false
        local bgSymbolColor = colors.black  

        local object = {
            setBackground = function(self, bg, symbol, symbolCol)
                base.setBackground(self, bg)
                bgSymbol = symbol or bgSymbol
                bgSymbolColor = symbolCol or bgSymbolColor
                return self
            end,

            setBackgroundSymbol = function(self, symbol, symbolCol)
                bgSymbol = symbol
                bgSymbolColor = symbolCol or bgSymbolColor
                self:updateDraw()
                return self
            end,

            getBackgroundSymbol = function(self)
                return bgSymbol
            end,

            getBackgroundSymbolColor = function(self)
                return bgSymbolColor
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                if(xmlValue("background-symbol", data)~=nil)then self:setBackgroundSymbol(xmlValue("background-symbol", data), xmlValue("background-symbol-color", data)) end
                return self
            end,

            draw = function(self)
                base.draw(self)
                self:addDraw("advanced-bg", function()
                    local w, h = self:getSize()
                    if(bgSymbol~=false)then
                        self:addTextBox(1, 1, w, h, bgSymbol:sub(1,1))
                        if(bgSymbol~=" ")then
                            self:addForegroundBox(1, 1, w, h, bgSymbolColor)
                        end
                    end
            end, 2)
            end,
        }

        return object
    end
}
end
project["plugins"]["bigfonts"] = function(...)
-------------------------------------------------------------------------------------
-- Wojbies API 5.0 - Bigfont - functions to write bigger font using drawing sybols --
-------------------------------------------------------------------------------------
--   Copyright (c) 2015-2022 Wojbie (wojbie@wojbie.net)
--   Redistribution and use in source and binary forms, with or without modification, are permitted (subject to the limitations in the disclaimer below) provided that the following conditions are met:
--   1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
--   2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
--   3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
--   4. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
--   5. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
--   NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. YOU ACKNOWLEDGE THAT THIS SOFTWARE IS NOT DESIGNED, LICENSED OR INTENDED FOR USE IN THE DESIGN, CONSTRUCTION, OPERATION OR MAINTENANCE OF ANY NUCLEAR FACILITY.

-- Basalt - Nyorie: Please don't copy paste this code to your projects, this code is slightly changed (to fit the way basalt draws stuff), if you want the original code, checkout this:
-- http://www.computercraft.info/forums2/index.php?/topic/25367-bigfont-api-write-bigger-letters-v10/

local tHex = require("tHex")

local rawFont = {{"\32\32\32\137\156\148\158\159\148\135\135\144\159\139\32\136\157\32\159\139\32\32\143\32\32\143\32\32\32\32\32\32\32\32\147\148\150\131\148\32\32\32\151\140\148\151\140\147", "\32\32\32\149\132\149\136\156\149\144\32\133\139\159\129\143\159\133\143\159\133\138\32\133\138\32\133\32\32\32\32\32\32\150\150\129\137\156\129\32\32\32\133\131\129\133\131\132", "\32\32\32\130\131\32\130\131\32\32\129\32\32\32\32\130\131\32\130\131\32\32\32\32\143\143\143\32\32\32\32\32\32\130\129\32\130\135\32\32\32\32\131\32\32\131\32\131", "\139\144\32\32\143\148\135\130\144\149\32\149\150\151\149\158\140\129\32\32\32\135\130\144\135\130\144\32\149\32\32\139\32\159\148\32\32\32\32\159\32\144\32\148\32\147\131\132", "\159\135\129\131\143\149\143\138\144\138\32\133\130\149\149\137\155\149\159\143\144\147\130\132\32\149\32\147\130\132\131\159\129\139\151\129\148\32\32\139\131\135\133\32\144\130\151\32", "\32\32\32\32\32\32\130\135\32\130\32\129\32\129\129\131\131\32\130\131\129\140\141\132\32\129\32\32\129\32\32\32\32\32\32\32\131\131\129\32\32\32\32\32\32\32\32\32", "\32\32\32\32\149\32\159\154\133\133\133\144\152\141\132\133\151\129\136\153\32\32\154\32\159\134\129\130\137\144\159\32\144\32\148\32\32\32\32\32\32\32\32\32\32\32\151\129", "\32\32\32\32\133\32\32\32\32\145\145\132\141\140\132\151\129\144\150\146\129\32\32\32\138\144\32\32\159\133\136\131\132\131\151\129\32\144\32\131\131\129\32\144\32\151\129\32", "\32\32\32\32\129\32\32\32\32\130\130\32\32\129\32\129\32\129\130\129\129\32\32\32\32\130\129\130\129\32\32\32\32\32\32\32\32\133\32\32\32\32\32\129\32\129\32\32", "\150\156\148\136\149\32\134\131\148\134\131\148\159\134\149\136\140\129\152\131\32\135\131\149\150\131\148\150\131\148\32\148\32\32\148\32\32\152\129\143\143\144\130\155\32\134\131\148", "\157\129\149\32\149\32\152\131\144\144\131\148\141\140\149\144\32\149\151\131\148\32\150\32\150\131\148\130\156\133\32\144\32\32\144\32\130\155\32\143\143\144\32\152\129\32\134\32", "\130\131\32\131\131\129\131\131\129\130\131\32\32\32\129\130\131\32\130\131\32\32\129\32\130\131\32\130\129\32\32\129\32\32\133\32\32\32\129\32\32\32\130\32\32\32\129\32", "\150\140\150\137\140\148\136\140\132\150\131\132\151\131\148\136\147\129\136\147\129\150\156\145\138\143\149\130\151\32\32\32\149\138\152\129\149\32\32\157\152\149\157\144\149\150\131\148", "\149\143\142\149\32\149\149\32\149\149\32\144\149\32\149\149\32\32\149\32\32\149\32\149\149\32\149\32\149\32\144\32\149\149\130\148\149\32\32\149\32\149\149\130\149\149\32\149", "\130\131\129\129\32\129\131\131\32\130\131\32\131\131\32\131\131\129\129\32\32\130\131\32\129\32\129\130\131\32\130\131\32\129\32\129\131\131\129\129\32\129\129\32\129\130\131\32", "\136\140\132\150\131\148\136\140\132\153\140\129\131\151\129\149\32\149\149\32\149\149\32\149\137\152\129\137\152\129\131\156\133\149\131\32\150\32\32\130\148\32\152\137\144\32\32\32", "\149\32\32\149\159\133\149\32\149\144\32\149\32\149\32\149\32\149\150\151\129\138\155\149\150\130\148\32\149\32\152\129\32\149\32\32\32\150\32\32\149\32\32\32\32\32\32\32", "\129\32\32\130\129\129\129\32\129\130\131\32\32\129\32\130\131\32\32\129\32\129\32\129\129\32\129\32\129\32\131\131\129\130\131\32\32\32\129\130\131\32\32\32\32\140\140\132", "\32\154\32\159\143\32\149\143\32\159\143\32\159\144\149\159\143\32\159\137\145\159\143\144\149\143\32\32\145\32\32\32\145\149\32\144\32\149\32\143\159\32\143\143\32\159\143\32", "\32\32\32\152\140\149\151\32\149\149\32\145\149\130\149\157\140\133\32\149\32\154\143\149\151\32\149\32\149\32\144\32\149\149\153\32\32\149\32\149\133\149\149\32\149\149\32\149", "\32\32\32\130\131\129\131\131\32\130\131\32\130\131\129\130\131\129\32\129\32\140\140\129\129\32\129\32\129\32\137\140\129\130\32\129\32\130\32\129\32\129\129\32\129\130\131\32", "\144\143\32\159\144\144\144\143\32\159\143\144\159\138\32\144\32\144\144\32\144\144\32\144\144\32\144\144\32\144\143\143\144\32\150\129\32\149\32\130\150\32\134\137\134\134\131\148", "\136\143\133\154\141\149\151\32\129\137\140\144\32\149\32\149\32\149\154\159\133\149\148\149\157\153\32\154\143\149\159\134\32\130\148\32\32\149\32\32\151\129\32\32\32\32\134\32", "\133\32\32\32\32\133\129\32\32\131\131\32\32\130\32\130\131\129\32\129\32\130\131\129\129\32\129\140\140\129\131\131\129\32\130\129\32\129\32\130\129\32\32\32\32\32\129\32", "\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32", "\32\32\32\32\32\32\32\32\32\32\32\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\32\32\32\32\32\32\32\32\32\32\32", "\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32", "\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32\32\32\32\32\149\32\32\149\32\32\32\32", "\32\32\32\32\32\32\32\32\32\32\32\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\32\32\32\32\32\32\32\32\32\32\32", "\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32\32\149\32", "\32\32\32\32\145\32\159\139\32\151\131\132\155\143\132\134\135\145\32\149\32\158\140\129\130\130\32\152\147\155\157\134\32\32\144\144\32\32\32\32\32\32\152\131\155\131\131\129", "\32\32\32\32\149\32\149\32\145\148\131\32\149\32\149\140\157\132\32\148\32\137\155\149\32\32\32\149\154\149\137\142\32\153\153\32\131\131\149\131\131\129\149\135\145\32\32\32", "\32\32\32\32\129\32\130\135\32\131\131\129\134\131\132\32\129\32\32\129\32\131\131\32\32\32\32\130\131\129\32\32\32\32\129\129\32\32\32\32\32\32\130\131\129\32\32\32", "\150\150\32\32\148\32\134\32\32\132\32\32\134\32\32\144\32\144\150\151\149\32\32\32\32\32\32\145\32\32\152\140\144\144\144\32\133\151\129\133\151\129\132\151\129\32\145\32", "\130\129\32\131\151\129\141\32\32\142\32\32\32\32\32\149\32\149\130\149\149\32\143\32\32\32\32\142\132\32\154\143\133\157\153\132\151\150\148\151\158\132\151\150\148\144\130\148", "\32\32\32\140\140\132\32\32\32\32\32\32\32\32\32\151\131\32\32\129\129\32\32\32\32\134\32\32\32\32\32\32\32\129\129\32\129\32\129\129\130\129\129\32\129\130\131\32", "\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\159\142\32\150\151\129\150\131\132\140\143\144\143\141\145\137\140\148\141\141\144\157\142\32\159\140\32\151\134\32\157\141\32", "\157\140\149\157\140\149\157\140\149\157\140\149\157\140\149\157\140\149\151\151\32\154\143\132\157\140\32\157\140\32\157\140\32\157\140\32\32\149\32\32\149\32\32\149\32\32\149\32", "\129\32\129\129\32\129\129\32\129\129\32\129\129\32\129\129\32\129\129\131\129\32\134\32\131\131\129\131\131\129\131\131\129\131\131\129\130\131\32\130\131\32\130\131\32\130\131\32", "\151\131\148\152\137\145\155\140\144\152\142\145\153\140\132\153\137\32\154\142\144\155\159\132\150\156\148\147\32\144\144\130\145\136\137\32\146\130\144\144\130\145\130\136\32\151\140\132", "\151\32\149\151\155\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\152\137\144\157\129\149\149\32\149\149\32\149\149\32\149\149\32\149\130\150\32\32\157\129\149\32\149", "\131\131\32\129\32\129\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\32\32\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\129\32\130\131\32\133\131\32", "\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\159\142\32\159\159\144\152\140\144\156\143\32\159\141\129\153\140\132\157\141\32\130\145\32\32\147\32\136\153\32\130\146\32", "\152\140\149\152\140\149\152\140\149\152\140\149\152\140\149\152\140\149\149\157\134\154\143\132\157\140\133\157\140\133\157\140\133\157\140\133\32\149\32\32\149\32\32\149\32\32\149\32", "\130\131\129\130\131\129\130\131\129\130\131\129\130\131\129\130\131\129\130\130\131\32\134\32\130\131\129\130\131\129\130\131\129\130\131\129\32\129\32\32\129\32\32\129\32\32\129\32", "\159\134\144\137\137\32\156\143\32\159\141\129\153\140\132\153\137\32\157\141\32\32\132\32\159\143\32\147\32\144\144\130\145\136\137\32\146\130\144\144\130\145\130\138\32\146\130\144", "\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\149\32\149\131\147\129\138\134\149\149\32\149\149\32\149\149\32\149\149\32\149\154\143\149\32\157\129\154\143\149", "\130\131\32\129\32\129\130\131\32\130\131\32\130\131\32\130\131\32\130\131\32\32\32\32\130\131\32\130\131\129\130\131\129\130\131\129\130\131\129\140\140\129\130\131\32\140\140\129" }, {"000110000110110000110010101000000010000000100101", "000000110110000000000010101000000010000000100101", "000000000000000000000000000000000000000000000000", "100010110100000010000110110000010100000100000110", "000000110000000010110110000110000000000000110000", "000000000000000000000000000000000000000000000000", "000000110110000010000000100000100000000000000010", "000000000110110100010000000010000000000000000100", "000000000000000000000000000000000000000000000000", "010000000000100110000000000000000000000110010000", "000000000000000000000000000010000000010110000000", "000000000000000000000000000000000000000000000000", "011110110000000100100010110000000100000000000000", "000000000000000000000000000000000000000000000000", "000000000000000000000000000000000000000000000000", "110000110110000000000000000000010100100010000000", "000010000000000000110110000000000100010010000000", "000000000000000000000000000000000000000000000000", "010110010110100110110110010000000100000110110110", "000000000000000000000110000000000110000000000000", "000000000000000000000000000000000000000000000000", "010100010110110000000000000000110000000010000000", "110110000000000000110000110110100000000010000000", "000000000000000000000000000000000000000000000000", "000100011111000100011111000100011111000100011111", "000000000000100100100100011011011011111111111111", "000000000000000000000000000000000000000000000000", "000100011111000100011111000100011111000100011111", "000000000000100100100100011011011011111111111111", "100100100100100100100100100100100100100100100100", "000000110100110110000010000011110000000000011000", "000000000100000000000010000011000110000000001000", "000000000000000000000000000000000000000000000000", "010000100100000000000000000100000000010010110000", "000000000000000000000000000000110110110110110000", "000000000000000000000000000000000000000000000000", "110110110110110110000000110110110110110110110110", "000000000000000000000110000000000000000000000000", "000000000000000000000000000000000000000000000000", "000000000000110110000110010000000000000000010010", "000010000000000000000000000000000000000000000000", "000000000000000000000000000000000000000000000000", "110110110110110110110000110110110110000000000000", "000000000000000000000110000000000000000000000000", "000000000000000000000000000000000000000000000000", "110110110110110110110000110000000000000000010000", "000000000000000000000000100000000000000110000110", "000000000000000000000000000000000000000000000000" }}

--### Genarate fonts using 3x3 chars per a character. (1 character is 6x9 pixels)
local fonts = {}
local firstFont = {}
do
    local char = 0
    local height = #rawFont[1]
    local length = #rawFont[1][1]
    for i = 1, height, 3 do
        for j = 1, length, 3 do
            local thisChar = string.char(char)

            local temp = {}
            temp[1] = rawFont[1][i]:sub(j, j + 2)
            temp[2] = rawFont[1][i + 1]:sub(j, j + 2)
            temp[3] = rawFont[1][i + 2]:sub(j, j + 2)

            local temp2 = {}
            temp2[1] = rawFont[2][i]:sub(j, j + 2)
            temp2[2] = rawFont[2][i + 1]:sub(j, j + 2)
            temp2[3] = rawFont[2][i + 2]:sub(j, j + 2)

            firstFont[thisChar] = {temp, temp2}
            char = char + 1
        end
    end
    fonts[1] = firstFont
end

local function generateFontSize(size,yeld)
    local inverter = {["0"] = "1", ["1"] = "0"} --:gsub("[01]",inverter)
    if size<= #fonts then return true end
    for f = #fonts+1, size do
        --automagicly make bigger fonts using firstFont and fonts[f-1].
        local nextFont = {}
        local lastFont = fonts[f - 1]
        for char = 0, 255 do
            local thisChar = string.char(char)
            --sleep(0) print(f,thisChar)

            local temp = {}
            local temp2 = {}

            local templateChar = lastFont[thisChar][1]
            local templateBack = lastFont[thisChar][2]
            for i = 1, #templateChar do
                local line1, line2, line3, back1, back2, back3 = {}, {}, {}, {}, {}, {}
                for j = 1, #templateChar[1] do
                    local currentChar = firstFont[templateChar[i]:sub(j, j)][1]
                    table.insert(line1, currentChar[1])
                    table.insert(line2, currentChar[2])
                    table.insert(line3, currentChar[3])

                    local currentBack = firstFont[templateChar[i]:sub(j, j)][2]
                    if templateBack[i]:sub(j, j) == "1" then
                        table.insert(back1, (currentBack[1]:gsub("[01]", inverter)))
                        table.insert(back2, (currentBack[2]:gsub("[01]", inverter)))
                        table.insert(back3, (currentBack[3]:gsub("[01]", inverter)))
                    else
                        table.insert(back1, currentBack[1])
                        table.insert(back2, currentBack[2])
                        table.insert(back3, currentBack[3])
                    end
                end
                table.insert(temp, table.concat(line1))
                table.insert(temp, table.concat(line2))
                table.insert(temp, table.concat(line3))
                table.insert(temp2, table.concat(back1))
                table.insert(temp2, table.concat(back2))
                table.insert(temp2, table.concat(back3))
            end

            nextFont[thisChar] = {temp, temp2}
            if yeld then yeld = "Font"..f.."Yeld"..char os.queueEvent(yeld) os.pullEvent(yeld) end
        end
        fonts[f] = nextFont
    end
    return true
end

local function makeText(nSize, sString, nFC, nBC, bBlit)
    if not type(sString) == "string" then error("Not a String",3) end --this should never happend with expects in place.
    local cFC = type(nFC) == "string" and nFC:sub(1, 1) or tHex[nFC] or error("Wrong Front Color",3)
    local cBC = type(nBC) == "string" and nBC:sub(1, 1) or tHex[nBC] or error("Wrong Back Color",3)
    if(fonts[nSize]==nil)then generateFontSize(3,false) end
    local font = fonts[nSize] or error("Wrong font size selected",3)
    if sString == "" then return {{""}, {""}, {""}} end
    
    local input = {}
    for i in sString:gmatch('.') do table.insert(input, i) end

    local tText = {}
    local height = #font[input[1]][1]


    for nLine = 1, height do
        local outLine = {}
        for i = 1, #input do
            outLine[i] = font[input[i]] and font[input[i]][1][nLine] or ""
        end
        tText[nLine] = table.concat(outLine)
    end

    local tFront = {}
    local tBack = {}
    local tFrontSub = {["0"] = cFC, ["1"] = cBC}
    local tBackSub = {["0"] = cBC, ["1"] = cFC}

    for nLine = 1, height do
        local front = {}
        local back = {}
        for i = 1, #input do
            local template = font[input[i]] and font[input[i]][2][nLine] or ""
            front[i] = template:gsub("[01]", bBlit and {["0"] = nFC:sub(i, i), ["1"] = nBC:sub(i, i)} or tFrontSub)
            back[i] = template:gsub("[01]", bBlit and {["0"] = nBC:sub(i, i), ["1"] = nFC:sub(i, i)} or tBackSub)
        end
        tFront[nLine] = table.concat(front)
        tBack[nLine] = table.concat(back)
    end

    return {tText, tFront, tBack}
end

-- The following code is related to basalt and has nothing to do with bigfonts, it creates a plugin which will be added to labels:
local utils = require("utils")
local xmlValue = utils.xmlValue
return {
    Label = function(base)
        local fontsize = 1
        local bigfont
    
        local object = {
            setFontSize = function(self, newFont)
                if(type(newFont)=="number")then
                    fontsize = newFont
                    if(fontsize>1)then
                        self:setDrawState("label", false)
                        bigfont = makeText(fontsize-1, self:getText(), self:getForeground(), self:getBackground() or colors.lightGray)
                        if(self:getAutoSize())then
                            self:getBase():setSize(#bigfont[1][1], #bigfont[1]-1)
                        end
                    else
                        self:setDrawState("label", true)
                    end
                    self:updateDraw()
                end
                return self
            end,

            getFontSize = function(self)
                return fontsize
            end,

            getSize = function(self)
                local w, h = base.getSize(self)
                if(fontsize>1)and(self:getAutoSize())then
                    return fontsize==2 and self:getText():len()*3 or math.floor(self:getText():len() * 8.5), fontsize==2 and h * 2 or math.floor(h)
                else
                    return w, h
                end
            end,

            getWidth = function(self)
                local w = base.getWidth(self)
                if(fontsize>1)and(self:getAutoSize())then
                    return fontsize==2 and self:getText():len()*3 or math.floor(self:getText():len() * 8.5)
                else
                    return w
                end
            end,

            getHeight = function(self)
                local h = base.getHeight(self)
                if(fontsize>1)and(self:getAutoSize())then
                    return fontsize==2 and h * 2 or math.floor(h)
                else
                    return h
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                if(xmlValue("fontSize", data)~=nil)then self:setFontSize(xmlValue("fontSize", data)) end
                return self
            end,

            draw = function(self)
                base.draw(self)
                self:addDraw("bigfonts", function()
                    if(fontsize>1)then
                        local obx, oby = self:getPosition()
                        local parent = self:getParent()
                        local oX, oY = parent:getSize()
                        local cX, cY = #bigfont[1][1], #bigfont[1]
                        obx = obx or math.floor((oX - cX) / 2) + 1
                        oby = oby or math.floor((oY - cY) / 2) + 1
                    
                        for i = 1, cY do
                            self:addFG(1, i, bigfont[2][i])
                            self:addBG(1, i, bigfont[3][i])
                            self:addText(1, i, bigfont[1][i])
                        end
                    end
                end)
            end,
        }
        return object
    end
}
end
project["plugins"]["border"] = function(...)
local utils = require("utils")
local xmlValue = utils.xmlValue

return {
    VisualObject = function(base)
        local inline = true
        local borderColors = {top = false, bottom = false, left = false, right = false}

        local object = {
            setBorder = function(self, ...)
                local t = {...}
                if(t~=nil)then
                    for k,v in pairs(t)do
                        if(v=="left")or(#t==1)then
                            borderColors["left"] = t[1]
                        end
                        if(v=="top")or(#t==1)then
                            borderColors["top"] = t[1]
                        end
                        if(v=="right")or(#t==1)then
                            borderColors["right"] = t[1]
                        end
                        if(v=="bottom")or(#t==1)then
                            borderColors["bottom"] = t[1]
                        end
                    end
                end
                self:updateDraw()
                return self
            end,

            draw = function(self)
                base.draw(self)
                self:addDraw("border", function()
                    local x, y = self:getPosition()
                    local w,h = self:getSize()      
                    local bgCol = self:getBackground()          
                    if(inline)then
                        if(borderColors["left"]~=false)then
                            self:addTextBox(1, 1, 1, h, "\149")
                            if(bgCol~=false)then self:addBackgroundBox(1, 1, 1, h, bgCol) end
                            self:addForegroundBox(1, 1, 1, h, borderColors["left"])
                        end
                        
                        if(borderColors["top"]~=false)then
                            self:addTextBox(1, 1, w, 1, "\131")
                            if(bgCol~=false)then self:addBackgroundBox(1, 1, w, 1, bgCol) end
                            self:addForegroundBox(1, 1, w, 1, borderColors["top"])
                        end
                        
                        if(borderColors["left"]~=false)and(borderColors["top"]~=false)then
                            self:addTextBox(1, 1, 1, 1, "\151")
                            if(bgCol~=false)then self:addBackgroundBox(1, 1, 1, 1, bgCol) end
                            self:addForegroundBox(1, 1, 1, 1, borderColors["left"])
                        end
                        if(borderColors["right"]~=false)then
                            self:addTextBox(w, 1, 1, h, "\149")
                            if(bgCol~=false)then self:addForegroundBox(w, 1, 1, h, bgCol) end
                            self:addBackgroundBox(w, 1, 1, h, borderColors["right"])
                        end
                        if(borderColors["bottom"]~=false)then
                            self:addTextBox(1, h, w, 1, "\143")
                            if(bgCol~=false)then self:addForegroundBox(1, h, w, 1, bgCol) end
                            self:addBackgroundBox(1, h, w, 1, borderColors["bottom"])
                        end
                        if(borderColors["top"]~=false)and(borderColors["right"]~=false)then
                            self:addTextBox(w, 1, 1, 1, "\148")
                            if(bgCol~=false)then self:addForegroundBox(w, 1, 1, 1, bgCol) end
                            self:addBackgroundBox(w, 1, 1, 1, borderColors["right"])
                        end
                        if(borderColors["right"]~=false)and(borderColors["bottom"]~=false)then
                            self:addTextBox(w, h, 1, 1, "\133")
                            if(bgCol~=false)then self:addForegroundBox(w, h, 1, 1, bgCol) end
                            self:addBackgroundBox(w, h, 1, 1, borderColors["right"])
                        end
                        if(borderColors["bottom"]~=false)and(borderColors["left"]~=false)then
                            self:addTextBox(1, h, 1, 1, "\138")
                            if(bgCol~=false)then self:addForegroundBox(0, h, 1, 1, bgCol) end
                            self:addBackgroundBox(1, h, 1, 1, borderColors["left"])
                        end
                    end
                end)
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data)
                local borders = {}
                if(xmlValue("border", data)~=nil)then 
                    borders["top"] = colors[xmlValue("border", data)]
                    borders["bottom"] = colors[xmlValue("border", data)]
                    borders["left"] = colors[xmlValue("border", data)]
                    borders["right"] = colors[xmlValue("border", data)]
                end
                if(xmlValue("borderTop", data)~=nil)then borders["top"] = colors[xmlValue("borderTop", data)] end
                if(xmlValue("borderBottom", data)~=nil)then borders["bottom"] = colors[xmlValue("borderBottom", data)] end
                if(xmlValue("borderLeft", data)~=nil)then borders["left"] = colors[xmlValue("borderLeft", data)] end
                if(xmlValue("borderRight", data)~=nil)then borders["right"] = colors[xmlValue("borderRight", data)] end
                self:setBorder(borders["top"], borders["bottom"], borders["left"], borders["right"])
                return self
            end
        }

        return object
    end
}
end
project["plugins"]["betterError"] = function(...)
local utils = require("utils")
local wrapText = utils.wrapText

return {
    basalt = function(basalt)
        local frame
        local errorList
        return {
            getBasaltErrorFrame = function()
                return frame
            end,
            basaltError = function(err)
                if(frame==nil)then
                    local mainFrame = basalt.getMainFrame()
                    local w, h = mainFrame:getSize()
                    frame = mainFrame:addMovableFrame("basaltErrorFrame"):setSize(w-10, h-4):setBackground(colors.lightGray):setForeground(colors.white):setZIndex(500)
                    frame:addPane("titleBackground"):setSize(w, 1):setPosition(1, 1):setBackground(colors.black):setForeground(colors.white)
                    frame:setPosition(w/2-frame:getWidth()/2, h/2-frame:getHeight()/2):setBorder(colors.black)
                    frame:addLabel("title"):setText("Basalt Unexpected Error"):setPosition(2, 1):setBackground(colors.black):setForeground(colors.white)
                    errorList = frame:addList("errorList"):setSize(frame:getWidth()-2, frame:getHeight()-6):setPosition(2, 3):setBackground(colors.lightGray):setForeground(colors.white):setSelectionColor(colors.lightGray, colors.gray)
                    frame:addButton("xButton"):setText("x"):setPosition(frame:getWidth(), 1):setSize(1, 1):setBackground(colors.black):setForeground(colors.red):onClick(function() 
                        frame:hide()
                    end)
                    frame:addButton("Clear"):setText("Clear"):setPosition(frame:getWidth()-19, frame:getHeight()-1):setSize(9, 1):setBackground(colors.black):setForeground(colors.white):onClick(function() 
                        errorList:clear()
                    end)
                    frame:addButton("Close"):setText("Close"):setPosition(frame:getWidth()-9, frame:getHeight()-1):setSize(9, 1):setBackground(colors.black):setForeground(colors.white):onClick(function() 
                        basalt.autoUpdate(false)
                        term.clear()
                        term.setCursorPos(1, 1)
                    end)
                end
                frame:show()
                errorList:addItem(("-"):rep(frame:getWidth()-2))
                local err = wrapText(err, frame:getWidth()-2)
                for i=1, #err do
                    errorList:addItem(err[i])
                end
            end
        }
    end
}
end
project["plugins"]["animations"] = function(...)
local floor,sin,cos,pi,sqrt,pow = math.floor,math.sin,math.cos,math.pi,math.sqrt,math.pow

-- You can find the easing curves here https://easings.net

local function lerp(s, e, pct)
    return s + (e - s) * pct
end

local function linear(t)
    return t
end

local function flip(t)
    return 1 - t
end

local function easeIn(t)
    return t * t * t
end

local function easeOut(t)
    return flip(easeIn(flip(t)))
end

local function easeInOut(t)
    return lerp(easeIn(t), easeOut(t), t)
end

local function easeOutSine(t)
    return sin((t * pi) / 2);
end

local function easeInSine(t)
    return flip(cos((t * pi) / 2))
end

local function easeInOutSine(t)
    return -(cos(pi * x) - 1) / 2
end

local function easeInBack(t)
    local c1 = 1.70158;
    local c3 = c1 + 1
    return c3*t^3-c1*t^2
end

local function easeInCubic(t)
    return t^3
end

local function easeInElastic(t)
    local c4 = (2*pi)/3;
    return t == 0 and 0 or (t == 1 and 1 or (
        -2^(10*t-10)*sin((t*10-10.75)*c4)
    ))
end

local function easeInExpo(t)
    return t == 0 and 0 or 2^(10*t-10)
end

local function easeInExpo(t)
    return t == 0 and 0 or 2^(10*t-10)
end

local function easeInOutBack(t)
    local c1 = 1.70158;
    local c2 = c1 * 1.525;
    return t < 0.5 and ((2*t)^2*((c2+1)*2*t-c2))/2 or ((2*t-2)^2*((c2+1)*(t*2-2)+c2)+2)/2
end

local function easeInOutCubic(t)
    return t < 0.5 and 4 * t^3 or 1-(-2*t+2)^3 / 2
end

local function easeInOutElastic(t)
    local c5 = (2*pi) / 4.5
    return t==0 and 0 or (t == 1 and 1 or (t < 0.5 and -(2^(20*t-10) * sin((20*t - 11.125) * c5))/2 or (2^(-20*t+10) * sin((20*t - 11.125) * c5))/2 + 1))
end

local function easeInOutExpo(t)
    return t == 0 and 0 or (t == 1 and 1 or (t < 0.5 and 2^(20*t-10)/2 or (2-2^(-20*t+10)) /2))
end

local function easeInOutQuad(t)
    return t < 0.5 and 2*t^2 or 1-(-2*t+2)^2/2
end

local function easeInOutQuart(t)
    return t < 0.5 and 8*t^4 or 1 - (-2*t+2)^4 / 2
end

local function easeInOutQuint(t)
    return t < 0.5 and 16*t^5 or 1-(-2*t+2)^5 / 2
end

local function easeInQuad(t)
    return t^2
end

local function easeInQuart(t)
    return t^4
end

local function easeInQuint(t)
    return t^5
end

local function easeOutBack(t)
    local c1 = 1.70158;
    local c3 = c1 + 1
    return 1+c3*(t-1)^3+c1*(t-1)^2
end

local function easeOutCubic(t)
    return 1 - (1-t)^3
end

local function easeOutElastic(t)
    local c4 = (2*pi)/3;

    return t == 0 and 0 or (t == 1 and 1 or (2^(-10*t)*sin((t*10-0.75)*c4)+1))
end

local function easeOutExpo(t)
    return t == 1 and 1 or 1-2^(-10*t)
end

local function easeOutQuad(t)
    return 1 - (1 - t) * (1 - t)
end

local function easeOutQuart(t)
    return 1 - (1-t)^4
end

local function easeOutQuint(t)
    return 1 - (1 - t)^5
end

local function easeInCirc(t)
    return 1 - sqrt(1 - pow(t, 2))
end

local function easeOutCirc(t)
    return sqrt(1 - pow(t - 1, 2))
end

local function easeInOutCirc(t)
    return t < 0.5 and (1 - sqrt(1 - pow(2 * t, 2))) / 2 or (sqrt(1 - pow(-2 * t + 2, 2)) + 1) / 2;
end

local function easeOutBounce(t)
    local n1 = 7.5625;
    local d1 = 2.75;

    if (t < 1 / d1)then
        return n1 * t * t
    elseif (t < 2 / d1)then
        local a = t - 1.5 / d1
        return n1 * a * a + 0.75;
    elseif (t < 2.5 / d1)then
        local a = t - 2.25 / d1
        return n1 * a * a + 0.9375;
    else
        local a = t - 2.625 / d1
        return n1 * a * a + 0.984375;
    end
end

local function easeInBounce(t)
    return 1 - easeOutBounce(1 - t)
end

local function easeInOutBounce(t)
    return x < 0.5 and (1 - easeOutBounce(1 - 2 * t)) / 2 or (1 + easeOutBounce(2 * t - 1)) / 2;
end

local lerp = {
    linear = linear,
    lerp = lerp,
    flip=flip,
    easeIn=easeIn,
    easeInSine = easeInSine,
    easeInBack=easeInBack,
    easeInCubic=easeInCubic,
    easeInElastic=easeInElastic,
    easeInExpo=easeInExpo,
    easeInQuad=easeInQuad,
    easeInQuart=easeInQuart,
    easeInQuint=easeInQuint,
    easeInCirc=easeInCirc,
    easeInBounce=easeInBounce,
    easeOut=easeOut,
    easeOutSine = easeOutSine,
    easeOutBack=easeOutBack,
    easeOutCubic=easeOutCubic,
    easeOutElastic=easeOutElastic,
    easeOutExpo=easeOutExpo,
    easeOutQuad=easeOutQuad,
    easeOutQuart=easeOutQuart,
    easeOutQuint=easeOutQuint,
    easeOutCirc=easeOutCirc,
    easeOutBounce=easeOutBounce,
    easeInOut=easeInOut,
    easeInOutSine = easeInOutSine,
    easeInOutBack=easeInOutBack,
    easeInOutCubic=easeInOutCubic,
    easeInOutElastic=easeInOutElastic,
    easeInOutExpo=easeInOutExpo,
    easeInOutQuad=easeInOutQuad,
    easeInOutQuart=easeInOutQuart,
    easeInOutQuint=easeInOutQuint,
    easeInOutCirc=easeInOutCirc,
    easeInOutBounce=easeInOutBounce,
}

local utils = require("utils")
local xmlValue = utils.xmlValue

return {
    VisualObject = function(base, basalt)
        local activeAnimations = {}
        local defaultMode = "linear"

        local function getAnimation(self, timerId)
            for k,v in pairs(activeAnimations)do
                if(v.timerId==timerId)then
                    return v
                end
            end
        end

        local function createAnimation(self, v1, v2, duration, timeOffset, mode, typ, f, get, set)
            local v1Val, v2Val = get(self)
            if(activeAnimations[typ]~=nil)then
                os.cancelTimer(activeAnimations[typ].timerId)
            end
            activeAnimations[typ] = {}
            activeAnimations[typ].call = function()
                local progress = activeAnimations[typ].progress
                local _v1 = math.floor(lerp.lerp(v1Val, v1, lerp[mode](progress / duration))+0.5)
                local _v2 = math.floor(lerp.lerp(v2Val, v2, lerp[mode](progress / duration))+0.5)
                set(self, _v1, _v2)
            end
            activeAnimations[typ].finished = function()
                set(self, v1, v2)
                if(f~=nil)then f(self) end
            end

            activeAnimations[typ].timerId=os.startTimer(0.05+timeOffset)
            activeAnimations[typ].progress=0
            activeAnimations[typ].duration=duration
            activeAnimations[typ].mode=mode
            self:listenEvent("other_event")
        end

        local function createColorAnimation(self, duration, timeOffset, typ, set, ...)
            local newColors = {...}
            if(activeAnimations[typ]~=nil)then
                os.cancelTimer(activeAnimations[typ].timerId)
            end
            activeAnimations[typ] = {}
            local colorIndex = 1
            activeAnimations[typ].call = function()
                local color = newColors[colorIndex]
                set(self, color)
            end
        end

        local object = {
            animatePosition = function(self, x, y, duration, timeOffset, mode, f)
                mode = mode or defaultMode
                duration = duration or 1
                timeOffset = timeOffset or 0
                x = math.floor(x+0.5)
                y = math.floor(y+0.5)
                createAnimation(self, x, y, duration, timeOffset, mode, "position", f, self.getPosition, self.setPosition)
                return self
            end,

            animateSize = function(self, w, h, duration, timeOffset, mode, f)
                mode = mode or defaultMode
                duration = duration or 1
                timeOffset = timeOffset or 0
                createAnimation(self, w, h, duration, timeOffset, mode, "size", f, self.getSize, self.setSize)
                return self
            end,

            animateOffset = function(self, x, y, duration, timeOffset, mode, f)
                mode = mode or defaultMode
                duration = duration or 1
                timeOffset = timeOffset or 0
                createAnimation(self, x, y, duration, timeOffset, mode, "offset", f, self.getOffset, self.setOffset)
                return self
            end,

            animateBackground = function(self, color, duration, timeOffset, mode, f)
                mode = mode or defaultMode
                duration = duration or 1
                timeOffset = timeOffset or 0
                createColorAnimation(self, color, nil, duration, timeOffset, mode, "background", f, self.getBackground, self.setBackground)
                return self
            end,

            doneHandler = function(self, timerId, ...)
                for k,v in pairs(activeAnimations)do
                    if(v.timerId==timerId)then
                        activeAnimations[k] = nil
                        self:sendEvent("animation_done", self, "animation_done", k)
                    end
                end
            end,

            onAnimationDone = function(self, ...)
                for _,v in pairs(table.pack(...))do
                    if(type(v)=="function")then
                        self:registerEvent("animation_done", v)
                    end
                end

                return self
            end,

            eventHandler = function(self, event, timerId, ...)
                base.eventHandler(self, event, timerId, ...)
                if(event=="timer")then
                    local animation = getAnimation(self, timerId)
                    if(animation~=nil)then
                        if(animation.progress<animation.duration)then
                            animation.call()
                            animation.progress = animation.progress+0.05
                            animation.timerId=os.startTimer(0.05)
                        else
                            animation.finished()
                            self:doneHandler(timerId)
                        end
                    end
                end
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                local animX, animY, animateDuration, animeteTimeOffset, animateMode = xmlValue("animateX", data), xmlValue("animateY", data), xmlValue("animateDuration", data), xmlValue("animateTimeOffset", data), xmlValue("animateMode", data)
                local animW, animH, animateDuration, animeteTimeOffset, animateMode = xmlValue("animateW", data), xmlValue("animateH", data), xmlValue("animateDuration", data), xmlValue("animateTimeOffset", data), xmlValue("animateMode", data)
                local animXOffset, animYOffset, animateDuration, animeteTimeOffset, animateMode = xmlValue("animateXOffset", data), xmlValue("animateYOffset", data), xmlValue("animateDuration", data), xmlValue("animateTimeOffset", data), xmlValue("animateMode", data)
                if(animX~=nil and animY~=nil)then
                    self:animatePosition(animX, animY, animateDuration, animeteTimeOffset, animateMode)
                end
                if(animW~=nil and animH~=nil)then
                    self:animateSize(animW, animH, animateDuration, animeteTimeOffset, animateMode)
                end
                if(animXOffset~=nil and animYOffset~=nil)then
                    self:animateOffset(animXOffset, animYOffset, animateDuration, animeteTimeOffset, animateMode)
                end                
                return self
            end,
        }

        return object
    end
}
end
project["plugins"]["debug"] = function(...)
local utils = require("utils")
local wrapText = utils.wrapText

return {
    basalt = function(basalt)
        local mainFrame = basalt.getMainFrame()
        local debugFrame
        local debugList
        local debugLabel
        local debugExitButton

        local function createDebuggingFrame()
            local minW = 16
            local minH = 6
            local maxW = 99
            local maxH = 99
            local w, h = mainFrame:getSize()
            debugFrame = mainFrame:addMovableFrame("basaltDebuggingFrame"):setSize(w-20, h-10):setBackground(colors.gray):setForeground(colors.white):setZIndex(100):hide()
            debugFrame:addPane():setSize("parent.w", 1):setPosition(1, 1):setBackground(colors.black):setForeground(colors.white)
            debugFrame:setPosition(-w, h/2-debugFrame:getHeight()/2):setBorder(colors.black)
            local resizeButton = debugFrame:addButton()
                :setPosition("parent.w", "parent.h")
                :setSize(1, 1)
                :setText("\133")
                :setForeground(colors.gray)
                :setBackground(colors.black)
                :onClick(function() end)
                :onDrag(function(self, event, btn, xOffset, yOffset)
                    local w, h = debugFrame:getSize()
                    local wOff, hOff = w, h
                    if(w+xOffset-1>=minW)and(w+xOffset-1<=maxW)then
                        wOff = w+xOffset-1
                    end
                    if(h+yOffset-1>=minH)and(h+yOffset-1<=maxH)then
                        hOff = h+yOffset-1
                    end
                    debugFrame:setSize(wOff, hOff)
                end)

            debugExitButton = debugFrame:addButton():setText("Close"):setPosition("parent.w - 6", 1):setSize(7, 1):setBackground(colors.red):setForeground(colors.white):onClick(function() 
                debugFrame:animatePosition(-w, h/2-debugFrame:getHeight()/2, 0.5)
            end)
            debugList = debugFrame:addList()
                        :setSize("parent.w - 2", "parent.h - 3")
                        :setPosition(2, 3)
                        :setBackground(colors.gray)
                        :setForeground(colors.white)
                        :setSelectionColor(colors.gray, colors.white)
            if(debugLabel==nil)then 
                debugLabel = mainFrame:addLabel()
                :setPosition(1, "parent.h")
                :setBackground(colors.black)
                :setForeground(colors.white)
                :setZIndex(100)
                :onClick(function()
                    debugFrame:show()
                    debugFrame:animatePosition(w/2-debugFrame:getWidth()/2, h/2-debugFrame:getHeight()/2, 0.5)
                end)
            end
        end

        return {
            debug = function(...)
                local args = { ... }
                if(mainFrame==nil)then 
                    mainFrame = basalt.getMainFrame() 
                    if(mainFrame~=nil)then
                        createDebuggingFrame()
                    else
                        print(...) return
                    end
                end
                if (mainFrame:getName() ~= "basaltDebuggingFrame") then
                    if (mainFrame ~= debugFrame) then
                        debugLabel:setParent(mainFrame)
                    end
                end
                local str = ""
                for key, value in pairs(args) do
                    str = str .. tostring(value) .. (#args ~= key and ", " or "")
                end
                debugLabel:setText("[Debug] " .. str)
                for k,v in pairs(wrapText(str, debugList:getWidth()))do
                    debugList:addItem(v)
                end
                if (debugList:getItemCount() > 50) then
                    debugList:removeItem(1)
                end
                debugList:setValue(debugList:getItem(debugList:getItemCount()))
                if(debugList.getItemCount() > debugList:getHeight())then
                    debugList:setOffset(debugList:getItemCount() - debugList:getHeight())
                end
                debugLabel:show()
            end
        }
    end
}
end
project["plugins"]["dynamicValues"] = function(...)
local utils = require("utils")
local count = utils.tableCount
local xmlValue = utils.xmlValue

return {
    VisualObject = function(base, basalt)
        local dynObjects = {}
        local curProperties = {}
        local properties = {x="getX", y="getY", w="getWidth", h="getHeight"}

        local function stringToNumber(str)
            local ok, result = pcall(load("return " .. str, "", nil, {math=math}))
            if not(ok)then error(str.." - is not a valid dynamic value string") end
            return result
        end

        local function createDynamicValue(self, key, val)
            local objectGroup = {}
            local properties = properties
            for a,b in pairs(properties)do
                for v in val:gmatch("%a+%."..a)do
                    local name = v:gsub("%."..a, "")
                    if(name~="self")and(name~="parent")then 
                        table.insert(objectGroup, name) 
                    end
                end
            end

            local parent = self:getParent()
            local objects = {}
            for k,v in pairs(objectGroup)do
                objects[v] = parent:getObject(v)
                if(objects[v]==nil)then
                    error("Dynamic Values - unable to find object: "..v)
                end
            end
            objects["self"] = self
            objects["parent"] = parent

            dynObjects[key] = function()
                local mainVal = val
                for a,b in pairs(properties)do
                    for v in val:gmatch("%w+%."..a) do
                        local obj = objects[v:gsub("%."..a, "")]
                        if(obj~=nil)then
                            mainVal = mainVal:gsub(v, obj[b](obj))
                        else
                            error("Dynamic Values - unable to find object: "..v)
                        end
                    end
                end
                curProperties[key] = math.floor(stringToNumber(mainVal)+0.5)
            end
            dynObjects[key]()
        end

        local function updatePositions(self)
            if(count(dynObjects)>0)then
                for k,v in pairs(dynObjects)do
                    v()
                end
                local properties = {x="getX", y="getY", w="getWidth", h="getHeight"}
                for k,v in pairs(properties)do
                    if(dynObjects[k]~=nil)then
                        if(curProperties[k]~=self[v](self))then
                            if(k=="x")or(k=="y")then
                                base.setPosition(self, curProperties["x"] or self:getX(), curProperties["y"] or self:getY())
                            end
                            if(k=="w")or(k=="h")then
                                base.setSize(self, curProperties["w"] or self:getWidth(), curProperties["h"] or self:getHeight())
                            end
                        end
                    end
                end
            end
        end

        local object = {
            updatePositions = updatePositions,
            createDynamicValue = createDynamicValue,

            setPosition = function(self, xPos, yPos, rel)
                curProperties.x = xPos
                curProperties.y = yPos
                if(type(xPos)=="string")then
                    createDynamicValue(self, "x", xPos)
                else
                    dynObjects["x"] = nil
                end
                if(type(yPos)=="string")then
                    createDynamicValue(self, "y", yPos)
                else
                    dynObjects["y"] = nil
                end
                base.setPosition(self, curProperties.x, curProperties.y, rel)
                return self
            end,

            setSize = function(self, w, h, rel)
                curProperties.w = w
                curProperties.h = h
                if(type(w)=="string")then
                    createDynamicValue(self, "w", w)
                else
                    dynObjects["w"] = nil
                end
                if(type(h)=="string")then
                    createDynamicValue(self, "h", h)
                else
                    dynObjects["h"] = nil
                end
                base.setSize(self, curProperties.w, curProperties.h, rel)
                return self
            end,

            customEventHandler = function(self, event, ...)
                base.customEventHandler(self, event, ...)
                if(event=="basalt_FrameReposition")or(event=="basalt_FrameResize")then
                    updatePositions(self)
                end
            end,
        }
        return object
    end
}
end
project["plugins"]["pixelbox"] = function(...)
-- Most of this is made by Dev9551, you can find his awesome work here: https://github.com/9551-Dev/apis/blob/main/pixelbox_lite.lua
-- Slighly modified by NyoriE to work with Basalt

--[[
The MIT License (MIT)
Copyright © 2022 Oliver Caha (9551Dev)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ?Software?), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ?AS IS?, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]
local t_sort,t_cat,s_char  = table.sort,table.concat,string.char
local function sort(a,b) return a[2] > b[2] end

local distances = {
    {5,256,16,8,64,32},
    {4,16,16384,256,128},
    [4] = {4,64,1024,256,128},
    [8] = {4,512,2048,256,1},
    [16] = {4,2,16384,256,1},
    [32] = {4,8192,4096,256,1},
    [64] = {4,4,1024,256,1},
    [128] = {6,32768,256,1024,2048,4096,16384},
    [256] = {6,1,128,2,512,4,8192},
    [512] = {4,8,2048,256,128},
    [1024] = {4,4,64,128,32768},
    [2048] = {4,512,8,128,32768},
    [4096] = {4,8192,32,128,32768},
    [8192] = {3,32,4096,256128},
    [16384] = {4,2,16,128,32768},
    [32768] = {5,128,1024,2048,4096,16384}
}

local to_colors = {}
for i = 0, 15 do
    to_colors[("%x"):format(i)] = 2^i
end

local to_blit = {}
for i = 0, 15 do
    to_blit[2^i] = ("%x"):format(i)
end

local function pixelbox(colTable, defaultCol)
    defaultCol = defaultCol or "f"
    local width, height = #colTable[1], #colTable
    local cache = {}
    local canv = {}
    local cached = false
    
    local function generateCanvas()
        for y = 1, height * 3 do
            for x = 1, width * 2 do
                if not canv[y] then canv[y] = {} end
                canv[y][x] = defaultCol
            end
        end

        for k, v in ipairs(colTable) do
            for x = 1, #v do
                local col = v:sub(x, x)
                canv[k][x] = to_colors[col]
            end
        end
    end
    generateCanvas()

    local function setSize(w,h)
        width, height = w, h
        canv = {}
        cached = false
        generateCanvas()
    end


    local function generateChar(a,b,c,d,e,f)
        local arr = {a,b,c,d,e,f}
        local c_types = {}
        local sortable = {}
        local ind = 0
        for i=1,6 do
            local c = arr[i]
            if not c_types[c] then
                ind = ind + 1
                c_types[c] = {0,ind}
            end
    
            local t = c_types[c]
            local t1 = t[1] + 1
    
            t[1] = t1
            sortable[t[2]] = {c,t1}
        end
        local n = #sortable
        while n > 2 do
            t_sort(sortable,sort)
            local bit6 = distances[sortable[n][1]]
            local index,run = 1,false
            local nm1 = n - 1
            for i=2,bit6[1] do
                if run then break end
                local tab = bit6[i]
                for j=1,nm1 do
                    if sortable[j][1] == tab then
                        index = j
                        run = true
                        break
                    end
                end
            end
            local from,to = sortable[n][1],sortable[index][1]
            for i=1,6 do
                if arr[i] == from then
                    arr[i] = to
                    local sindex = sortable[index]
                    sindex[2] = sindex[2] + 1
                end
            end
    
            sortable[n] = nil
            n = n - 1
        end
    
        local n = 128
        local a6 = arr[6]
    
        if arr[1] ~= a6 then n = n + 1 end
        if arr[2] ~= a6 then n = n + 2 end
        if arr[3] ~= a6 then n = n + 4 end
        if arr[4] ~= a6 then n = n + 8 end
        if arr[5] ~= a6 then n = n + 16 end
    
        if sortable[1][1] == arr[6] then
            return s_char(n),sortable[2][1],arr[6]
        else
            return s_char(n),sortable[1][1],arr[6]
        end
    end

    local function convert()
        local w_double = width * 2

        local sy = 0
        for y = 1, height * 3, 3 do
            sy = sy + 1
            local layer_1 = canv[y]
            local layer_2 = canv[y + 1]
            local layer_3 = canv[y + 2]
            local char_line, fg_line, bg_line = {}, {}, {}
            local n = 0
            for x = 1, w_double, 2 do
                local xp1 = x + 1
                local b11, b21, b12, b22, b13, b23 = layer_1[x], layer_1[xp1], layer_2[x], layer_2[xp1], layer_3[x], layer_3[xp1]

                local char, fg, bg = " ", 1, b11
                if not (b21 == b11 and b12 == b11 and b22 == b11 and b13 == b11 and b23 == b11) then
                    char, fg, bg = generateChar(b11, b21, b12, b22, b13, b23)
                end
                n = n + 1
                char_line[n] = char
                fg_line[n] = to_blit[fg]
                bg_line[n] = to_blit[bg]
            end

            cache[sy] = {t_cat(char_line), t_cat(fg_line), t_cat(bg_line)}
        end
        cached = true
    end

    return {
        convert = convert,
        generateCanvas = generateCanvas,
        setSize = setSize,
        getSize = function()
            return width, height
        end,
        set = function(colTab, defCol)
            colTable = colTab
            defaultCol = defCol or defaultCol
            canv = {}
            cached = false
            generateCanvas()
        end,
        get = function(y)
            if not cached then convert() end
            return y~= nil and cache[y] or cache
        end
    }
end

return {
    Image = function(base, basalt)
        return {
            shrink = function(self)
                local bimg = self:getImageFrame(1)
                local img = {}
                for k,v in pairs(bimg)do
                    if(type(k)=="number")then
                        table.insert(img,v[3])
                    end
                end
                local shrinkedImg = pixelbox(img, self:getBackground()).get()
                self:setImage(shrinkedImg)
                return self
            end,

            getShrinkedImage = function(self)
                local bimg = self:getImageFrame(1)
                local img = {}
                for k,v in pairs(bimg)do
                    if(type(k)=="number")then
                        table.insert(img, v[3])
                    end
                end
                return pixelbox(img, self:getBackground()).get()
            end,
        }
    end,
}
end
project["plugins"]["shadow"] = function(...)
local utils = require("utils")
local xmlValue = utils.xmlValue

return {
    VisualObject = function(base)
        local shadow = false        

        local object = {
            setShadow = function(self, color)
                shadow = color
                self:updateDraw()
                return self
            end,

            getShadow = function(self)
                return shadow
            end,

            draw = function(self)
                base.draw(self)
                self:addDraw("shadow", function()
                    if(shadow~=false)then
                        local w,h = self:getSize()
                        if(shadow)then               
                            self:addBackgroundBox(w+1, 2, 1, h, shadow)
                            self:addBackgroundBox(2, h+1, w, 1, shadow)
                            self:addForegroundBox(w+1, 2, 1, h, shadow)
                            self:addForegroundBox(2, h+1, w, 1, shadow)
                        end
                    end
                end)
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                if(xmlValue("shadow", data)~=nil)then self:setShadow(xmlValue("shadow", data)) end
                return self
            end
        }

        return object
    end
}
end
project["plugins"]["textures"] = function(...)
local images = require("images")
local utils = require("utils")
local xmlValue = utils.xmlValue
return {
    VisualObject = function(base)
        local textureId, infinitePlay = 1, true
        local bimg, texture, textureTimerId
        local textureMode = "default"

        local object = {
            addTexture = function(self, path, animate)
                bimg = images.loadImageAsBimg(path)
                texture = bimg[1]
                if(animate)then
                    if(bimg.animated)then
                        self:listenEvent("other_event")
                        local t = bimg[textureId].duration or bimg.secondsPerFrame or 0.2
                        textureTimerId = os.startTimer(t)
                    end
                end
                self:setBackground(false)
                self:setForeground(false)
                self:setDrawState("texture-base", true)
                self:updateDraw()
                return self
            end,

            setTextureMode = function(self, mode)
                textureMode = mode or textureMode
                self:updateDraw()
                return self
            end,

            setInfinitePlay = function(self, state)
                infinitePlay = state
                return self
            end,

            eventHandler = function(self, event, timerId, ...)
                base.eventHandler(self, event, timerId, ...)
                if(event=="timer")then
                    if(timerId == textureTimerId)then
                        if(bimg[textureId+1]~=nil)then
                            textureId = textureId + 1
                            texture = bimg[textureId]
                            local t = bimg[textureId].duration or bimg.secondsPerFrame or 0.2
                            textureTimerId = os.startTimer(t)
                            self:updateDraw()
                        else
                            if(infinitePlay)then
                                textureId = 1
                                texture = bimg[1]
                                local t = bimg[textureId].duration or bimg.secondsPerFrame or 0.2
                                textureTimerId = os.startTimer(t)
                                self:updateDraw()
                            end
                        end
                    end
                end
            end,

            draw = function(self)
                base.draw(self)
                self:addDraw("texture-base", function()
                    local obj = self:getParent() or self
                    local x, y = self:getPosition()
                    local w,h = self:getSize()
                    local wP,hP = obj:getSize()

                    local textureWidth = bimg.width or #bimg[textureId][1][1]
                    local textureHeight = bimg.height or #bimg[textureId]

                    local startX, startY = 0, 0

                    if (textureMode == "center") then
                        startX = x + math.floor((w - textureWidth) / 2 + 0.5) - 1
                        startY = y + math.floor((h - textureHeight) / 2 + 0.5) - 1
                    elseif (textureMode == "default") then
                        startX, startY = x, y
                    elseif (textureMode == "right") then
                        startX, startY = x + w - textureWidth, y + h - textureHeight
                    end

                    local textureX = x - startX
                    local textureY = y - startY

                    if startX < x then
                        startX = x
                        textureWidth = textureWidth - textureX
                    end
                    if startY < y then
                        startY = y
                        textureHeight = textureHeight - textureY
                    end
                    if startX + textureWidth > x + w then
                        textureWidth = (x + w) - startX
                    end
                    if startY + textureHeight > y + h then
                        textureHeight = (y + h) - startY
                    end

                    for k = 1, textureHeight do
                        if(texture[k+textureY]~=nil)then
                        local t, f, b = table.unpack(texture[k+textureY])
                            self:addBlit(1, k, t:sub(textureX, textureX + textureWidth), f:sub(textureX, textureX + textureWidth), b:sub(textureX, textureX + textureWidth))
                        end
                    end
                end, 1)
                self:setDrawState("texture-base", false)
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data, scripts)
                if(xmlValue("texture", data)~=nil)then self:addTexture(xmlValue("texture", data), xmlValue("animate", data)) end
                if(xmlValue("textureMode", data)~=nil)then self:setTextureMode(xmlValue("textureMode", data)) end
                if(xmlValue("infinitePlay", data)~=nil)then self:setInfinitePlay(xmlValue("infinitePlay", data)) end
                return self
            end
        }

        return object
    end
}
end
project["plugins"]["xml"] = function(...)
local utils = require("utils")
local uuid = utils.uuid
local xmlValue = utils.xmlValue

local function newNode(name)
    local node = {}
    node.___value = nil
    node.___name = name
    node.___children = {}
    node.___props = {}
    node.___reactiveProps = {}

    function node:value() return self.___value end
    function node:setValue(val) self.___value = val end
    function node:name() return self.___name end
    function node:setName(name) self.___name = name end
    function node:children() return self.___children end
    function node:numChildren() return #self.___children end
    function node:addChild(child)
        if self[child:name()] ~= nil then
            if type(self[child:name()].name) == "function" then
                local tempTable = {}
                table.insert(tempTable, self[child:name()])
                self[child:name()] = tempTable
            end
            table.insert(self[child:name()], child)
        else
            self[child:name()] = child
        end
        table.insert(self.___children, child)
    end

    function node:properties() return self.___props end
    function node:numProperties() return #self.___props end
    function node:addProperty(name, value)
        local lName = "@" .. name
        if self[lName] ~= nil then
            if type(self[lName]) == "string" then
                local tempTable = {}
                table.insert(tempTable, self[lName])
                self[lName] = tempTable
            end
            table.insert(self[lName], value)
        else
            self[lName] = value
        end
        table.insert(self.___props, { name = name, value = self[lName] })
    end

    function node:reactiveProperties() return self.___reactiveProps end
    function node:addReactiveProperty(name, value)
        self.___reactiveProps[name] = value
    end

    return node
end

local XmlParser = {}

function XmlParser:ToXmlString(value)
    value = string.gsub(value, "&", "&amp;"); -- '&' -> "&amp;"
    value = string.gsub(value, "<", "&lt;"); -- '<' -> "&lt;"
    value = string.gsub(value, ">", "&gt;"); -- '>' -> "&gt;"
    value = string.gsub(value, "\"", "&quot;"); -- '"' -> "&quot;"
    value = string.gsub(value, "([^%w%&%;%p%\t% ])",
        function(c)
            return string.format("&#x%X;", string.byte(c))
        end);
    return value;
end

function XmlParser:FromXmlString(value)
    value = string.gsub(value, "&#x([%x]+)%;",
        function(h)
            return string.char(tonumber(h, 16))
        end);
    value = string.gsub(value, "&#([0-9]+)%;",
        function(h)
            return string.char(tonumber(h, 10))
        end);
    value = string.gsub(value, "&quot;", "\"");
    value = string.gsub(value, "&apos;", "'");
    value = string.gsub(value, "&gt;", ">");
    value = string.gsub(value, "&lt;", "<");
    value = string.gsub(value, "&amp;", "&");
    return value;
end

function XmlParser:ParseProps(node, s)
    string.gsub(s, "(%w+)=([\"'])(.-)%2", function(w, _, a)
        node:addProperty(w, self:FromXmlString(a))
    end)
end

function XmlParser:ParseReactiveProps(node, s)
    string.gsub(s, "(%w+)={(.-)}", function(w, a)
        node:addReactiveProperty(w, a)
    end)
end

function XmlParser:ParseXmlText(xmlText)
    local stack = {}
    local top = newNode()
    table.insert(stack, top)
    local ni, c, label, xarg, empty
    local i, j = 1, 1
    while true do
        ni, j, c, label, xarg, empty = string.find(xmlText, "<(%/?)([%w_:]+)(.-)(%/?)>", i)
        if not ni then break end
        local text = string.sub(xmlText, i, ni - 1);
        if not string.find(text, "^%s*$") then
            local lVal = (top:value() or "") .. self:FromXmlString(text)
            stack[#stack]:setValue(lVal)
        end
        if empty == "/" then -- empty element tag
            local lNode = newNode(label)
            self:ParseProps(lNode, xarg)
            self:ParseReactiveProps(lNode, xarg)
            top:addChild(lNode)
        elseif c == "" then -- start tag
            local lNode = newNode(label)
            self:ParseProps(lNode, xarg)
            self:ParseReactiveProps(lNode, xarg)
            table.insert(stack, lNode)
    top = lNode
        else -- end tag
            local toclose = table.remove(stack) -- remove top

            top = stack[#stack]
            if #stack < 1 then
                error("XmlParser: nothing to close with " .. label)
            end
            if toclose:name() ~= label then
                error("XmlParser: trying to close " .. toclose.name .. " with " .. label)
            end
            top:addChild(toclose)
        end
        i = j + 1
    end
    local text = string.sub(xmlText, i);
    if #stack > 1 then
        error("XmlParser: unclosed " .. stack[#stack]:name())
    end
    return top
end

local function maybeExecuteScript(data, renderContext)
    local script = xmlValue('script', data)
    if (script ~= nil) then
        load(script, nil, "t", renderContext.env)()
    end
end

local function registerFunctionEvent(self, data, event, renderContext)
    local eventEnv = renderContext.env
    if(data:sub(1,1)=="$")then
        local data = data:sub(2)
        event(self, self:getBasalt().getVariable(data))
    else
        event(self, function(...)
            eventEnv.event = {...}
            local success, msg = pcall(load(data, nil, "t", eventEnv))
            if not success then
                error("XML Error: "..msg)
            end
        end)
    end
end

local function registerFunctionEvents(self, data, events, renderContext)
    for _, event in pairs(events) do
        local expression = data:reactiveProperties()[event]
        if (expression ~= nil) then
            registerFunctionEvent(self, expression .. "()", self[event], renderContext)
        end
    end
end

local currentEffect = nil

local clearEffectDependencies = function(effect)
    for _, dependency in ipairs(effect.dependencies) do
        for index, backlink in ipairs(dependency) do
            if (backlink == effect) then
                table.remove(dependency, index)
            end
        end
    end
    effect.dependencies = {};
end

return {
    basalt = function(basalt)
        local object = {
            layout = function(path)
                return {
                    path = path,
                }
            end,

            reactive = function(initialValue)
                local value = initialValue
                local observerEffects = {}
                local get = function()
                    if (currentEffect ~= nil) then
                        table.insert(observerEffects, currentEffect)
                        table.insert(currentEffect.dependencies, observerEffects)
                    end
                    return value
                end
                local set = function(newValue)
                    value = newValue
                    local observerEffectsCopy = {}
                    for index, effect in ipairs(observerEffects) do
                        observerEffectsCopy[index] = effect
                    end
                    for _, effect in ipairs(observerEffectsCopy) do
                        effect.execute()
                    end
                end
                return get, set
            end,

            untracked = function(getter)
                local parentEffect = currentEffect
                currentEffect = nil
                local value = getter()
                currentEffect = parentEffect
                return value
            end,

            effect = function(effectFn)
                local effect = {dependencies = {}}
                local execute = function()
                    clearEffectDependencies(effect)
                    local parentEffect = currentEffect
                    currentEffect = effect
                    effectFn()
                    currentEffect = parentEffect
                end
                effect.execute = execute
                effect.execute()
            end,

            derived = function(computeFn)
                local getValue, setValue = basalt.reactive();
                basalt.effect(function()
                    setValue(computeFn())
                end)
                return getValue;
            end
        }
        return object
    end,

    VisualObject = function(base, basalt)

        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                local x, y = self:getPosition()
                local w, h = self:getSize()
                if (name == "x") then
                    self:setPosition(value, y)
                elseif (name == "y") then
                    self:setPosition(x, value)
                elseif (name == "width") then
                    self:setSize(value, h)
                elseif (name == "height") then
                    self:setSize(w, value)
                elseif (name == "background") then
                    self:setBackground(colors[value])
                elseif (name == "foreground") then
                    self:setForeground(colors[value])
                end
            end,

            updateSpecifiedValuesByXMLData = function(self, data, valueNames)
                for _, name in ipairs(valueNames) do
                    local value = xmlValue(name, data)
                    if (value ~= nil) then
                        self:updateValue(name, value)
                    end
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                renderContext.env[self:getName()] = self
                for prop, expression in pairs(data:reactiveProperties()) do
                    local update = function()
                        local value = load("return " .. expression, nil, "t", renderContext.env)()
                        self:updateValue(prop, value)
                    end
                    basalt.effect(update)
                end
                self:updateSpecifiedValuesByXMLData(data, {
                    "x",
                    "y",
                    "width",
                    "height",
                    "background",
                    "foreground"
                })
                registerFunctionEvents(self, data, {
                    "onClick",
                    "onClickUp",
                    "onHover",
                    "onScroll",
                    "onDrag",
                    "onKey",
                    "onKeyUp",
                    "onRelease",
                    "onChar",
                    "onGetFocus",
                    "onLoseFocus",
                    "onResize",
                    "onReposition",
                    "onEvent",
                    "onLeave"
                }, renderContext)
                return self
            end,
        }
        return object
    end,

    ChangeableObject = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                if (name == "value") then
                    self:setValue(value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "value"
                })
                registerFunctionEvent(self, data, {
                    "onChange"
                }, renderContext)
                return self
            end,
        }
        return object
    end,

    Container = function(base, basalt)
        local lastXMLReferences = {}

        local function xmlDefaultValues(data, obj, renderContext)
            if (obj~=nil) then
                obj:setValuesByXMLData(data, renderContext)
            end
        end

        local function addXMLObjectType(node, addFn, self, renderContext)
            if (node ~= nil) then
                if (node.properties ~= nil) then
                    node = {node}
                end
                for _, v in pairs(node) do
                    local obj = addFn(self, v["@id"] or uuid())
                    lastXMLReferences[obj:getName()] = obj
                    xmlDefaultValues(v, obj, renderContext)
                end
            end
        end

        local function insertChildLayout(self, layout, node, renderContext)
            local props = {}
            for _, prop in ipairs(node:properties()) do
                props[prop.name] = prop.value
            end
            local updateFns = {}
            for prop, expression in pairs(node:reactiveProperties()) do
                updateFns[prop] = basalt.derived(function()
                    return load("return " .. expression, nil, "t", renderContext.env)()
                end)
            end
            setmetatable(props, {
                __index = function(_, k)
                    return updateFns[k]()
                end
            })
            self:loadLayout(layout.path, props)
        end

        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                lastXMLReferences = {}
                base.setValuesByXMLData(self, data, renderContext)
    
                local children = data:children()
                local _OBJECTS = basalt.getObjects()

                for _, childNode in pairs(children) do
                    local tagName = childNode.___name
                    if (tagName ~= "animation") then
                        local layout = renderContext.env[tagName]
                        local objectKey = tagName:gsub("^%l", string.upper)
                        if (layout ~= nil) then
                            insertChildLayout(self, layout, childNode, renderContext)
                        elseif (_OBJECTS[objectKey] ~= nil) then
                            local addFn = self["add" .. objectKey]
                            addXMLObjectType(childNode, addFn, self, renderContext)
                        end
                    end
                end
                
                addXMLObjectType(data["animation"], self.addAnimation, self, renderContext)
                return self
            end,

            loadLayout = function(self, path, props)
                if(fs.exists(path))then
                    local renderContext = {}
                    renderContext.env = _ENV
                    renderContext.env.props = props
                    local f = fs.open(path, "r")
                    local data = XmlParser:ParseXmlText(f.readAll())
                    f.close()
                    lastXMLReferences = {}
                    maybeExecuteScript(data, renderContext)
                    self:setValuesByXMLData(data, renderContext)
                end
                return self
            end,

            getXMLElements = function(self)
                return lastXMLReferences
            end,
        }
        return object
    end,

    BaseFrame = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                local _, yOffset = self:getOffset()
                if (name == "layout") then
                    self:setLayout(value)
                elseif (name == "xOffset") then
                    self:setOffset(value, yOffset)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "layout",
                    "xOffset"
                })
                return self
            end,
        }
        return object
    end,

    Frame = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                local xOffset, yOffset = self:getOffset()
                if (name == "layout") then
                    self:setLayout(value)
                elseif (name == "xOffset") then
                    self:setOffset(value, yOffset)
                elseif (name == "yOffset") then
                    self:setOffset(xOffset, value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "layout",
                    "xOffset",
                    "yOffset"
                })
                return self
            end,
        }
        return object
    end,

    Flexbox = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                if (name == "flexDirection") then
                    self:setFlexDirection(value)
                elseif (name == "justifyContent") then
                    self:setJustifyContent(value)
                elseif (name == "alignItems") then
                    self:setAlignItems(value)
                elseif (name == "spacing") then
                    self:setSpacing(value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "flexDirection",
                    "justifyContent",
                    "alignItems",
                    "spacing"
                })
                return self
            end,
        }
        return object
    end,

    Button = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                if (name == "text") then
                    self:setText(value)
                elseif (name == "horizontalAlign") then
                    self:setHorizontalAlign(value)
                elseif (name == "verticalAlign") then
                    self:setVerticalAlign(value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "text",
                    "horizontalAlign",
                    "verticalAlign"
                })
                return self
            end,
        }
        return object
    end,

    Label = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                if (name == "text") then
                    self:setText(value)
                elseif (name == "align") then
                    self:setAlign(value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "text",
                    "align"
                })
                return self
            end,
        }
        return object
    end,

    Input = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                local defaultText, defaultFG, defaultBG = self:getDefaultText()
                if (name == "defaultText") then
                    self:setDefaultText(value, defaultFG, defaultBG)
                elseif (name == "defaultFG") then
                    self:setDefaultText(defaultText, value, defaultBG)
                elseif (name == "defaultBG") then
                    self:setDefaultText(defaultText, defaultFG, value)
                elseif (name == "offset") then
                    self:setOffset(value)
                elseif (name == "textOffset") then
                    self:setTextOffset(value)
                elseif (name == "text") then
                    self:setText(value)
                elseif (name == "inputLimit") then
                    self:setInputLimit(value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "defaultText",
                    "defaultFG",
                    "defaultBG",
                    "offset",
                    "textOffset",
                    "text",
                    "inputLimit"
                })
                return self
            end,
        }
        return object
    end,

    Image = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                local xOffset, yOffset = self:getOffset()
                if (name == "xOffset") then
                    self:setOffset(value, yOffset)
                elseif (name == "yOffset") then
                    self:setOffset(xOffset, value)
                elseif (name == "path") then
                    self:loadImage(value)
                elseif (name == "usePalette") then
                    self:usePalette(value)
                elseif (name == "play") then
                    self:play(value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "xOffset",
                    "yOffset",
                    "path",
                    "usePalette",
                    "play"
                })
                return self
            end,
        }
        return object
    end,

    Checkbox = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                local activeSymbol, inactiveSymbol = self:getSymbol()
                if (name == "text") then
                    self:setText(value)
                elseif (name == "checked") then
                    self:setChecked(value)
                elseif (name == "textPosition") then
                    self:setTextPosition(value)
                elseif (name == "activeSymbol") then
                    self:setSymbol(value, inactiveSymbol)
                elseif (name == "inactiveSymbol") then
                    self:setSymbol(activeSymbol, value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "text",
                    "checked",
                    "textPosition",
                    "activeSymbol",
                    "inactiveSymbol"
                })
                return self
            end,
        }
        return object
    end,

    Program = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                if (name == "execute") then
                    self:execute(value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "execute"
                })
                return self
            end,
        }
        return object
    end,

    Progressbar = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                local activeBarColor, activeBarSymbol, activeBarSymbolCol = self:getProgressBar()
                if (name == "direction") then
                    self:setDirection(value)
                elseif (name == "activeBarColor") then
                    self:setProgressBar(value, activeBarSymbol, activeBarSymbolCol)
                elseif (name == "activeBarSymbol") then
                    self:setProgressBar(activeBarColor, value, activeBarSymbolCol)
                elseif (name == "activeBarSymbolColor") then
                    self:setProgressBar(activeBarColor, activeBarSymbol, value)
                elseif (name == "backgroundSymbol") then
                    self:setBackgroundSymbol(value)
                elseif (name == "progress") then
                    self:setProgress(value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "direction",
                    "activeBarColor",
                    "activeBarSymbol",
                    "activeBarSymbolColor",
                    "backgroundSymbol",
                    "progress"
                })
                return self
            end,
        }
        return object
    end,

    Slider = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                if (name == "symbol") then
                    self:setSymbol(value)
                elseif (name == "symbolColor") then
                    self:setSymbolColor(value)
                elseif (name == "index") then
                    self:setIndex(value)
                elseif (name == "maxValue") then
                    self:setMaxValue(value)
                elseif (name == "barType") then
                    self:setBarType(value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "symbol",
                    "symbolColor",
                    "index",
                    "maxValue",
                    "barType"
                })
                return self
            end,
        }
        return object
    end,

    Scrollbar = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                if (name == "symbol") then
                    self:setSymbol(value)
                elseif (name == "symbolColor") then
                    self:setSymbolColor(value)
                elseif (name == "symbolSize") then
                    self:setSymbolSize(value)
                elseif (name == "scrollAmount") then
                    self:setScrollAmount(value)
                elseif (name == "index") then
                    self:setIndex(value)
                elseif (name == "maxValue") then
                    self:setMaxValue(value)
                elseif (name == "barType") then
                    self:setBarType(value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "symbol",
                    "symbolColor",
                    "symbolSize",
                    "scrollAmount",
                    "index",
                    "maxValue",
                    "barType"
                })
                return self
            end,
        }
        return object
    end,

    MonitorFrame = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                if (name == "monitor") then
                    self:setMonitor(value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "monitor"
                })
                return self
            end,
        }
        return object
    end,

    Switch = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                if (name == "symbol") then
                    self:setSymbol(value)
                elseif (name == "activeBackground") then
                    self:setActiveBackground(value)
                elseif (name == "inactiveBackground") then
                    self:setInactiveBackground(value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "symbol",
                    "activeBackground",
                    "inactiveBackground"
                })
                return self
            end,
        }
        return object
    end,

    Textfield = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                local fgSel, bgSel = self:getSelection()
                local xOffset, yOffset = self:getOffset()
                if (name == "bgSelection") then
                    self:setSelection(fgSel, value)
                elseif (name == "fgSelection") then
                    self:setSelection(value, bgSel)
                elseif (name == "xOffset") then
                    self:setOffset(value, yOffset)
                elseif (name == "yOffset") then
                    self:setOffset(xOffset, value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "bgSelection",
                    "fgSelection",
                    "xOffset",
                    "yOffset"
                })


                if(data["lines"]~=nil)then
                    local l = data["lines"]["line"]
                    if(l.properties~=nil)then l = {l} end
                    for _,v in pairs(l)do
                        self:addLine(v:value())
                    end
                end
                if(data["keywords"]~=nil)then
                    for k,v in pairs(data["keywords"])do
                        if(colors[k]~=nil)then
                            local entry = v
                            if(entry.properties~=nil)then entry = {entry} end
                            local tab = {}
                            for a,b in pairs(entry)do
                                local keywordList = b["keyword"]
                                if(b["keyword"].properties~=nil)then keywordList = {b["keyword"]} end
                                for c,d in pairs(keywordList)do
                                    table.insert(tab, d:value())
                                end
                            end
                            self:addKeywords(colors[k], tab)
                        end
                    end
                end
                if(data["rules"]~=nil)then
                    if(data["rules"]["rule"]~=nil)then
                        local tab = data["rules"]["rule"]
                        if(data["rules"]["rule"].properties~=nil)then tab = {data["rules"]["rule"]} end
                        for k,v in pairs(tab)do

                            if(xmlValue("pattern", v)~=nil)then
                                self:addRule(xmlValue("pattern", v), colors[xmlValue("fg", v)], colors[xmlValue("bg", v)])
                            end
                        end
                    end
                end
                return self
            end,
        }
        return object
    end,

    Thread = function(base, basalt)
        local object = {
            setValuesByXMLData = function(self, data, renderContext)
                local script = xmlValue("start", data)~=nil
                if(script~=nil)then
                    local f = load(script, nil, "t", renderContext.env)
                    self:start(f)
                end
                return self
            end,
        }
        return object
    end,

    Timer = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                if (name == "start") then
                    self:start(value)
                elseif (name == "time") then
                    self:setTime(value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "start",
                    "time"
                })
                registerFunctionEvents(self, data, {
                    "onCall"
                }, renderContext)
                return self
            end,
        }
        return object
    end,

    List = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                local selBg, selFg = self:getSelectionColor()
                if (name == "align") then
                    self:setTextAlign(value)
                elseif (name == "offset") then
                    self:setOffset(value)
                elseif (name == "selectionBg") then
                    self:setSelectionColor(value, selFg)
                elseif (name == "selectionFg") then
                    self:setSelectionColor(selBg, value)
                elseif (name == "scrollable") then
                    self:setScrollable(value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "align",
                    "offset",
                    "selectionBg",
                    "selectionFg",
                    "scrollable"
                })

                if(data["item"]~=nil)then
                    local tab = data["item"]
                    if(tab.properties~=nil)then tab = {tab} end
                    for _,v in pairs(tab)do
                        if(self:getType()~="Radio")then
                            self:addItem(xmlValue("text", v), colors[xmlValue("bg", v)], colors[xmlValue("fg", v)])
                        end
                    end
                end
                return self
            end,
        }
        return object
    end,

    Dropdown = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                local w, h = self:getDropdownSize()
                if (name == "dropdownWidth") then
                    self:setDropdownSize(value, h)
                elseif (name == "dropdownHeight") then
                    self:setDropdownSize(w, value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "dropdownWidth",
                    "dropdownHeight"
                })
                return self
            end,
        }
        return object
    end,

    Radio = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                local selBg, selFg = self:getBoxSelectionColor()
                local defBg, defFg = self:setBoxDefaultColor()
                if (name == "selectionBg") then
                    self:setBoxSelectionColor(value, selFg)
                elseif (name == "selectionFg") then
                    self:setBoxSelectionColor(selBg, value)
                elseif (name == "defaultBg") then
                    self:setBoxDefaultColor(value, defFg)
                elseif (name == "defaultFg") then
                    self:setBoxDefaultColor(defBg, value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "selectionBg",
                    "selectionFg",
                    "defaultBg",
                    "defaultFg"
                })

                if(data["item"]~=nil)then
                    local tab = data["item"]
                    if(tab.properties~=nil)then tab = {tab} end
                    for _,v in pairs(tab)do
                        self:addItem(xmlValue("text", v), xmlValue("x", v), xmlValue("y", v), colors[xmlValue("bg", v)], colors[xmlValue("fg", v)])
                    end
                end
                return self
            end,
        }
        return object
    end,

    Menubar = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                if (name == "space") then
                    self:setSpace(value)
                elseif (name == "scrollable") then
                    self:setScrollable(value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "space",
                    "scrollable"
                })
                return self
            end,
        }
        return object
    end,

    Graph = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                local symbol, symbolCol = self:getGraphSymbol()
                if (name == "maxEntries") then
                    self:setMaxEntries(value)
                elseif (name == "type") then
                    self:setType(value)
                elseif (name == "minValue") then
                    self:setMinValue(value)
                elseif (name == "maxValue") then
                    self:setMaxValue(value)
                elseif (name == "symbol") then
                    self:setGraphSymbol(value, symbolCol)
                elseif (name == "symbolColor") then
                    self:setGraphSymbol(symbol, value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "maxEntries",
                    "type",
                    "minValue",
                    "maxValue",
                    "symbol",
                    "symbolColor"
                })
                if(data["item"]~=nil)then
                    local tab = data["item"]
                    if(tab.properties~=nil)then tab = {tab} end
                    for _,_ in pairs(tab)do
                        self:addDataPoint(xmlValue("value"))
                    end
                end
                return self
            end,
        }
        return object
    end,

    Treeview = function(base, basalt)
        local object = {
            updateValue = function(self, name, value)
                if (value == nil) then return end
                base.updateValue(self, name, value)
                local selBg, selFg = self:getSelectionColor()
                local xOffset, yOffset = self:getOffset()
                if (name == "space") then
                    self:setSpace(value)
                elseif (name == "scrollable") then
                    self:setScrollable(value)
                elseif (name == "selectionBg") then
                    self:setSelectionColor(value, selFg)
                elseif (name == "selectionFg") then
                    self:setSelectionColor(selBg, value)
                elseif (name == "xOffset") then
                    self:setOffset(value, yOffset)
                elseif (name == "yOffset") then
                    self:setOffset(xOffset, value)
                end
            end,

            setValuesByXMLData = function(self, data, renderContext)
                base.setValuesByXMLData(self, data, renderContext)
                self:updateSpecifiedValuesByXMLData(data, {
                    "space",
                    "scrollable",
                    "selectionBg",
                    "selectionFg",
                    "xOffset",
                    "yOffset"
                })
                local function addNode(node, data)
                    if(data["node"]~=nil)then
                        local tab = data["node"]
                        if(tab.properties~=nil)then tab = {tab} end
                        for _,v in pairs(tab)do
                            local n = node:addNode(xmlValue("text", v), colors[xmlValue("bg", v)], colors[xmlValue("fg", v)])
                            addNode(n, v)
                        end
                    end
                end
                if(data["node"]~=nil)then
                    local tab = data["node"]
                    if(tab.properties~=nil)then tab = {tab} end
                    for _,v in pairs(tab)do
                        local n = self:addNode(xmlValue("text", v), colors[xmlValue("bg", v)], colors[xmlValue("fg", v)])
                        addNode(n, v)
                    end
                end


                return self
            end,
        }
        return object
    end,

}

end
project["plugins"]["themes"] = function(...)
local baseTheme = { -- The default main theme for basalt!
    BaseFrameBG = colors.lightGray,
    BaseFrameText = colors.black,
    FrameBG = colors.gray,
    FrameText = colors.black,
    ButtonBG = colors.gray,
    ButtonText = colors.black,
    CheckboxBG = colors.lightGray,
    CheckboxText = colors.black,
    InputBG = colors.black,
    InputText = colors.lightGray,
    TextfieldBG = colors.black,
    TextfieldText = colors.white,
    ListBG = colors.gray,
    ListText = colors.black,
    MenubarBG = colors.gray,
    MenubarText = colors.black,
    DropdownBG = colors.gray,
    DropdownText = colors.black,
    RadioBG = colors.gray,
    RadioText = colors.black,
    SelectionBG = colors.black,
    SelectionText = colors.lightGray,
    GraphicBG = colors.black,
    ImageBG = colors.black,
    PaneBG = colors.black,
    ProgramBG = colors.black,
    ProgressbarBG = colors.gray,
    ProgressbarText = colors.black,
    ProgressbarActiveBG = colors.black,
    ScrollbarBG = colors.lightGray,
    ScrollbarText = colors.gray,
    ScrollbarSymbolColor = colors.black,
    SliderBG = false,
    SliderText = colors.gray,
    SliderSymbolColor = colors.black,
    SwitchBG = colors.lightGray,
    SwitchText = colors.gray,
    LabelBG = false,
    LabelText = colors.black,
    GraphBG = colors.gray,
    GraphText = colors.black    
}

local plugin = {
    Container = function(base, name, basalt)
        local theme = {}

        local object = {
            getTheme = function(self, name)
                local parent = self:getParent()
                return theme[name] or (parent~=nil and parent:getTheme(name) or baseTheme[name])
            end,
            setTheme = function(self, _theme, col)
                if(type(_theme)=="table")then
                    theme = _theme
                elseif(type(_theme)=="string")then
                    theme[_theme] = col
                end
                self:updateDraw()
                return self
            end,
        }
        return object
    end,

    basalt = function()
        return {
            getTheme = function(name)
                return baseTheme[name]
            end,
            setTheme = function(_theme, col)
                if(type(_theme)=="table")then
                    baseTheme = _theme
                elseif(type(_theme)=="string")then
                    baseTheme[_theme] = col
                end
            end
        }
    end
    
}

for k,v in pairs({"BaseFrame", "Frame", "ScrollableFrame", "MovableFrame", "Button", "Checkbox", "Dropdown", "Graph", "Graphic", "Input", "Label", "List", "Menubar", "Pane", "Program", "Progressbar", "Radio", "Scrollbar", "Slider", "Switch", "Textfield"})do
plugin[v] = function(base, name, basalt)
        local object = {
            init = function(self)
                if(base.init(self))then
                    local parent = self:getParent() or self
                    self:setBackground(parent:getTheme(v.."BG"))
                    self:setForeground(parent:getTheme(v.."Text"))      
                end
            end
        }
        return object
    end
end

return plugin
end
project["libraries"] = {}

project["libraries"]["basaltDraw"] = function(...)
local tHex = require("tHex")
local utils = require("utils")
local split = utils.splitString
local sub,rep = string.sub,string.rep

return function(drawTerm)
    local terminal = drawTerm or term.current()
    local mirrorTerm
    local width, height = terminal.getSize()
    local cacheT = {}
    local cacheBG = {}
    local cacheFG = {}

    local emptySpaceLine
    local emptyColorLines = {}
    
    local function createEmptyLines()
        emptySpaceLine = rep(" ", width)
        for n = 0, 15 do
            local nColor = 2 ^ n
            local sHex = tHex[nColor]
            emptyColorLines[nColor] = rep(sHex, width)
        end
    end
    ----
    createEmptyLines()

    local function recreateWindowArray()
        createEmptyLines()
        local emptyText = emptySpaceLine
        local emptyFG = emptyColorLines[colors.white]
        local emptyBG = emptyColorLines[colors.black]
        for currentY = 1, height do
            cacheT[currentY] = sub(cacheT[currentY] == nil and emptyText or cacheT[currentY] .. emptyText:sub(1, width - cacheT[currentY]:len()), 1, width)
            cacheFG[currentY] = sub(cacheFG[currentY] == nil and emptyFG or cacheFG[currentY] .. emptyFG:sub(1, width - cacheFG[currentY]:len()), 1, width)
            cacheBG[currentY] = sub(cacheBG[currentY] == nil and emptyBG or cacheBG[currentY] .. emptyBG:sub(1, width - cacheBG[currentY]:len()), 1, width)
        end
    end
    recreateWindowArray()

    local function blit(x, y, t, fg, bg)
        if #t == #fg and #t == #bg then
            if y >= 1 and y <= height then
                if x + #t > 0 and x <= width then
                    local newCacheT, newCacheFG, newCacheBG
                    local oldCacheT, oldCacheFG, oldCacheBG = cacheT[y], cacheFG[y], cacheBG[y]
                    local startN, endN = 1, #t
    
                    if x < 1 then
                        startN = 1 - x + 1
                        endN = width - x + 1
                    elseif x + #t > width then
                        endN = width - x + 1
                    end
    
                    newCacheT = sub(oldCacheT, 1, x - 1) .. sub(t, startN, endN)
                    newCacheFG = sub(oldCacheFG, 1, x - 1) .. sub(fg, startN, endN)
                    newCacheBG = sub(oldCacheBG, 1, x - 1) .. sub(bg, startN, endN)
    
                    if x + #t <= width then
                        newCacheT = newCacheT .. sub(oldCacheT, x + #t, width)
                        newCacheFG = newCacheFG .. sub(oldCacheFG, x + #t, width)
                        newCacheBG = newCacheBG .. sub(oldCacheBG, x + #t, width)
                    end
    
                    cacheT[y], cacheFG[y], cacheBG[y] = newCacheT,newCacheFG,newCacheBG
                end
            end
        end
    end

    local function setText(x, y, t)
        if y >= 1 and y <= height then
            if x + #t > 0 and x <= width then
                local newCacheT
                local oldCacheT = cacheT[y]
                local startN, endN = 1, #t

                if x < 1 then
                    startN = 1 - x + 1
                    endN = width - x + 1
                elseif x + #t > width then
                    endN = width - x + 1
                end

                newCacheT = sub(oldCacheT, 1, x - 1) .. sub(t, startN, endN)

                if x + #t <= width then
                    newCacheT = newCacheT .. sub(oldCacheT, x + #t, width)
                end

                cacheT[y] = newCacheT
            end
        end
    end

    local function setBG(x, y, bg)
        if y >= 1 and y <= height then
            if x + #bg > 0 and x <= width then
                local newCacheBG
                local oldCacheBG = cacheBG[y]
                local startN, endN = 1, #bg

                if x < 1 then
                    startN = 1 - x + 1
                    endN = width - x + 1
                elseif x + #bg > width then
                    endN = width - x + 1
                end

                newCacheBG = sub(oldCacheBG, 1, x - 1) .. sub(bg, startN, endN)

                if x + #bg <= width then
                    newCacheBG = newCacheBG .. sub(oldCacheBG, x + #bg, width)
                end

                cacheBG[y] = newCacheBG
            end
        end
    end

    local function setFG(x, y, fg)
        if y >= 1 and y <= height then
            if x + #fg > 0 and x <= width then
                local newCacheFG
                local oldCacheFG = cacheFG[y]
                local startN, endN = 1, #fg

                if x < 1 then
                    startN = 1 - x + 1
                    endN = width - x + 1
                elseif x + #fg > width then
                    endN = width - x + 1
                end

                newCacheFG = sub(oldCacheFG, 1, x - 1) .. sub(fg, startN, endN)

                if x + #fg <= width then
                    newCacheFG = newCacheFG .. sub(oldCacheFG, x + #fg, width)
                end

                cacheFG[y] = newCacheFG
            end
        end
    end

    --[[
    local function setText(x, y, text)
        if (y >= 1) and (y <= height) then
            local emptyLine = rep(" ", #text)
            blit(x, y, text, emptyLine, emptyLine)
        end
    end

    local function setFG(x, y, colorStr)
        if (y >= 1) and (y <= height) then
            local w = #colorStr
            local emptyLine = rep(" ", w)
            local text = sub(cacheT[y], x, w)
            blit(x, y, text, colorStr, emptyLine)
        end
    end

    local function setBG(x, y, colorStr)
        if (y >= 1) and (y <= height) then
            local w = #colorStr
            local emptyLine = rep(" ", w)
            local text = sub(cacheT[y], x, w)
            blit(x, y, text, emptyLine, colorStr)
        end
    end]]

    local drawHelper = {
        setSize = function(w, h)
            width, height = w, h
            recreateWindowArray()
        end,

        setMirror = function(mirror)
            mirrorTerm = mirror
        end,

        setBG = function(x, y, colorStr)
            setBG(x, y, colorStr)
        end,

        setText = function(x, y, text)
            setText(x, y, text)
        end,

        setFG = function(x, y, colorStr)
            setFG(x, y, colorStr)
        end;

        blit = function(x, y, t, fg, bg)
            blit(x, y, t, fg, bg)
        end,

        drawBackgroundBox = function(x, y, width, height, bgCol)
            local colorStr = rep(tHex[bgCol], width)
            for n = 1, height do
                setBG(x, y + (n - 1), colorStr)
            end
        end,
        drawForegroundBox = function(x, y, width, height, fgCol)
            local colorStr = rep(tHex[fgCol], width)
            for n = 1, height do
                setFG(x, y + (n - 1), colorStr)
            end
        end,
        drawTextBox = function(x, y, width, height, symbol)
            local textStr = rep(symbol, width)
            for n = 1, height do
                setText(x, y + (n - 1), textStr)
            end
        end,

        update = function()
            local xC, yC = terminal.getCursorPos()
            local isBlinking = false
            if (terminal.getCursorBlink ~= nil) then
                isBlinking = terminal.getCursorBlink()
            end
            terminal.setCursorBlink(false)
            if(mirrorTerm~=nil)then mirrorTerm.setCursorBlink(false) end
            for n = 1, height do
                terminal.setCursorPos(1, n)
                terminal.blit(cacheT[n], cacheFG[n], cacheBG[n])
                if(mirrorTerm~=nil)then 
                    mirrorTerm.setCursorPos(1, n) 
                    mirrorTerm.blit(cacheT[n], cacheFG[n], cacheBG[n])
                end
            end
            terminal.setBackgroundColor(colors.black)
            terminal.setCursorBlink(isBlinking)
            terminal.setCursorPos(xC, yC)
            if(mirrorTerm~=nil)then 
                mirrorTerm.setBackgroundColor(colors.black)
                mirrorTerm.setCursorBlink(isBlinking)
                mirrorTerm.setCursorPos(xC, yC)
            end
            
        end,

        setTerm = function(newTerm)
            terminal = newTerm
        end,
    }
    return drawHelper
end
end
project["libraries"]["basaltEvent"] = function(...)
return function()
    local events = {}

    local event = {
        registerEvent = function(self, _event, func)
            if (events[_event] == nil) then
                events[_event] = {}
            end
            table.insert(events[_event], func)
        end,

        removeEvent = function(self, _event, index)
            events[_event][index[_event]] = nil
        end,

        hasEvent = function(self, _event)
            return events[_event]~=nil
        end,
        
        getEventCount = function(self, _event)
            return events[_event]~=nil and #events[_event] or 0
        end,

        getEvents = function(self)
            local t = {}
            for k,v in pairs(events)do
                table.insert(t, k)
            end
            return t
        end,

        clearEvent = function(self, _event)
            events[_event] = nil
        end,

        clear = function(self, _event)
            events = {}
        end,

        sendEvent = function(self, _event, ...)
            local returnValue
            if (events[_event] ~= nil) then
                for _, value in pairs(events[_event]) do
                    local val = value(...)
                    if(val==false)then
                        returnValue = val
                    end
                end
            end
            return returnValue
        end,
    }
    event.__index = event
    return event
end
end
project["libraries"]["basaltLogs"] = function(...)
local logDir = ""
local logFileName = "basaltLog.txt"

local defaultLogType = "Debug"

fs.delete(logDir~="" and logDir.."/"..logFileName or logFileName)

local mt = {
    __call = function(_,text, typ)
        if(text==nil)then return end
        local dirStr = logDir~="" and logDir.."/"..logFileName or logFileName
        local handle = fs.open(dirStr, fs.exists(dirStr) and "a" or "w")
        handle.writeLine("[Basalt]["..os.date("%Y-%m-%d %H:%M:%S").."]["..(typ and typ or defaultLogType).."]: "..tostring(text))
        handle.close()
    end,
}

return setmetatable({}, mt)

--Work in progress
end
project["libraries"]["basaltMon"] = function(...)
-- Right now this doesn't support scroll(n)
-- Because this lbirary is mainly made for basalt - it doesn't need scroll support, maybe i will add it in the future

local tHex = {
    [colors.white] = "0",
    [colors.orange] = "1",
    [colors.magenta] = "2",
    [colors.lightBlue] = "3",
    [colors.yellow] = "4",
    [colors.lime] = "5",
    [colors.pink] = "6",
    [colors.gray] = "7",
    [colors.lightGray] = "8",
    [colors.cyan] = "9",
    [colors.purple] = "a",
    [colors.blue] = "b",
    [colors.brown] = "c",
    [colors.green] = "d",
    [colors.red] = "e",
    [colors.black] = "f",
}

local type,len,rep,sub = type,string.len,string.rep,string.sub


return function (monitorNames)
    local monitors = {}
    for k,v in pairs(monitorNames)do
        monitors[k] = {}
        for a,b in pairs(v)do
            local mon = peripheral.wrap(b)
            if(mon==nil)then
                error("Unable to find monitor "..b)
            end
            monitors[k][a] = mon
            monitors[k][a].name = b
        end
    end


    local x,y,monX,monY,monW,monH,w,h = 1,1,1,1,0,0,0,0
    local blink,scale = false,1
    local fg,bg = colors.white,colors.black

  
    local function calcSize()
        local maxW,maxH = 0,0
        for k,v in pairs(monitors)do
            local _maxW,_maxH = 0,0
            for a,b in pairs(v)do
                local nw,nh = b.getSize()
                _maxW = _maxW + nw
                _maxH = nh > _maxH and nh or _maxH
            end
            maxW = maxW > _maxW and maxW or _maxW
            maxH = maxH + _maxH
        end
        w,h = maxW,maxH
    end
    calcSize()

    local function calcPosition()
        local relY = 0
        local mX,mY = 0,0
        for k,v in pairs(monitors)do
            local relX = 0
            local _mh = 0
            for a,b in pairs(v)do
                local mw,mh = b.getSize()
                if(x-relX>=1)and(x-relX<=mw)then
                    mX = a
                end
                b.setCursorPos(x-relX, y-relY)
                relX = relX + mw
                if(_mh<mh)then _mh = mh end
            end
            if(y-relY>=1)and(y-relY<=_mh)then
                mY = k
            end
            relY = relY + _mh
        end
        monX,monY = mX,mY
    end
    calcPosition()

    local function call(f, ...)
        local t = {...}
        return function()
            for k,v in pairs(monitors)do
                for a,b in pairs(v)do
                    b[f](table.unpack(t))
                end
            end
        end
    end

    local function cursorBlink()
        call("setCursorBlink", false)()
        if not(blink)then return end
        if(monitors[monY]==nil)then return end
        local mon = monitors[monY][monX]
        if(mon==nil)then return end
        mon.setCursorBlink(blink)
    end

    local function blit(text, tCol, bCol)
        if(monitors[monY]==nil)then return end
        local mon = monitors[monY][monX]
        if(mon==nil)then return end
        mon.blit(text, tCol, bCol)
        local mW, mH = mon.getSize()
        if(len(text)+x>mW)then
            local monRight = monitors[monY][monX+1]
            if(monRight~=nil)then
                monRight.blit(text, tCol, bCol)
                monX = monX + 1
                x = x + len(text)
            end
        end
        calcPosition()
    end

   return {
        clear = call("clear"),

        setCursorBlink = function(_blink)
            blink = _blink
            cursorBlink()
        end,

        getCursorBlink = function()
            return blink
        end,

        getCursorPos = function()
            return x, y
        end,
        
        setCursorPos = function(newX,newY)
            x, y = newX, newY
            calcPosition()
            cursorBlink()
        end,

        setTextScale = function(_scale)
            call("setTextScale", _scale)()
            calcSize()
            calcPosition()
            scale = _scale
        end,

        getTextScale = function()
            return scale
        end,

        blit = function(text,fgCol,bgCol)
            blit(text,fgCol,bgCol)
        end,

        write = function(text)
            text = tostring(text)
            local l = len(text)
            blit(text, rep(tHex[fg], l), rep(tHex[bg], l))
        end,

        getSize = function()
            return w,h
        end,

        setBackgroundColor = function(col)
            call("setBackgroundColor", col)()
            bg = col
        end,

        setTextColor = function(col)
            call("setTextColor", col)()
            fg = col
        end,

        calculateClick = function(name, xClick, yClick)
            local relY = 0
            for k,v in pairs(monitors)do
                local relX = 0
                local maxY = 0
                for a,b in pairs(v)do
                    local wM,hM = b.getSize()
                    if(b.name==name)then
                        return xClick + relX, yClick + relY
                    end
                    relX = relX + wM
                    if(hM > maxY)then maxY = hM end
                end
                relY = relY + maxY
            end
            return xClick, yClick
        end,

   }
end
end
project["libraries"]["images"] = function(...)
local sub,floor = string.sub,math.floor

local function loadNFPAsBimg(path)
    return {[1]={{}, {}, paintutils.loadImage(path)}}, "bimg"
end

local function loadNFP(path)
    return paintutils.loadImage(path), "nfp"
end

local function loadBIMG(path, binaryMode)
    local f = fs.open(path, binaryMode and "rb" or "r")
    if(f==nil)then error("Path - "..path.." doesn't exist!") end
    local content = textutils.unserialize(f.readAll())

    f.close()
    if(content~=nil)then
        return content, "bimg"
    end
end

local function loadBBF(path)

end

local function loadBBFAsBimg(path)

end

local function loadImage(path, f, binaryMode)
    if(sub(path, -4) == ".bimg")then
        return loadBIMG(path, binaryMode)
    elseif(sub(path, -3) == ".bbf")then
        return loadBBF(path, binaryMode)
    else
        return loadNFP(path, binaryMode)
    end
    -- ...
end

local function loadImageAsBimg(path)
    if(path:find(".bimg"))then
        return loadBIMG(path)
    elseif(path:find(".bbf"))then
        return loadBBFAsBimg(path)
    else
        return loadNFPAsBimg(path)
    end
end

local function resizeBIMG(source, w, h)
    local oW, oH = source.width or #source[1][1][1], source.height or #source[1]
    local newImg = {}
    for k,v in pairs(source)do
        if(type(k)=="number")then
            local frame = {}
            for y=1, h do
                local xT,xFG,xBG = "","",""
                local yR = floor(y / h * oH + 0.5)
                if(v[yR]~=nil)then
                    for x=1, w do
                        local xR = floor(x / w * oW + 0.5)
                        xT = xT..sub(v[yR][1], xR,xR)
                        xFG = xFG..sub(v[yR][2], xR,xR)
                        xBG = xBG..sub(v[yR][3], xR,xR)
                    end
                    table.insert(frame, {xT, xFG, xBG})
                end
            end
            table.insert(newImg, k, frame)
        else
            newImg[k] = v
        end
    end
    newImg.width = w
    newImg.height = h
    return newImg
end

return {
    loadNFP = loadNFP,
    loadBIMG = loadBIMG,
    loadImage = loadImage,
    resizeBIMG = resizeBIMG,
    loadImageAsBimg = loadImageAsBimg,

}
end
project["libraries"]["bimg"] = function(...)
local sub,rep = string.sub,string.rep

local function frame(base, manager)
    local w, h = 0, 0
    local t,fg,bg = {}, {}, {}
    local x, y = 1,1

    local data = {}

    local function recalculateSize()
        for y=1,h do
            if(t[y]==nil)then
                t[y] = rep(" ", w)
            else
                t[y] = t[y]..rep(" ", w-#t[y])
            end
            if(fg[y]==nil)then
                fg[y] = rep("0", w)
            else
                fg[y] = fg[y]..rep("0", w-#fg[y])
            end
            if(bg[y]==nil)then
                bg[y] = rep("f", w)
            else
                bg[y] = bg[y]..rep("f", w-#bg[y])
            end
        end
    end

    local addText = function(text, _x, _y)
        x = _x or x
        y = _y or y
        if(t[y]==nil)then
            t[y] = rep(" ", x-1)..text..rep(" ", w-(#text+x))
        else
            t[y] = sub(t[y], 1, x-1)..rep(" ", x-#t[y])..text..sub(t[y], x+#text, w)
        end
        if(#t[y]>w)then w = #t[y] end
        if(y > h)then h = y end  
        manager.updateSize(w, h)
    end

    local addBg = function(b, _x, _y)
        x = _x or x
        y = _y or y
        if(bg[y]==nil)then
            bg[y] = rep("f", x-1)..b..rep("f", w-(#b+x))
        else
            bg[y] = sub(bg[y], 1, x-1)..rep("f", x-#bg[y])..b..sub(bg[y], x+#b, w)
        end
        if(#bg[y]>w)then w = #bg[y] end
        if(y > h)then h = y end  
        manager.updateSize(w, h)
    end

    local addFg = function(f, _x, _y)
        x = _x or x
        y = _y or y
        if(fg[y]==nil)then
            fg[y] = rep("0", x-1)..f..rep("0", w-(#f+x))
        else
            fg[y] = sub(fg[y], 1, x-1)..rep("0", x-#fg[y])..f..sub(fg[y], x+#f, w)
        end
        if(#fg[y]>w)then w = #fg[y] end
        if(y > h)then h = y end  
        manager.updateSize(w, h)
    end

    local function setFrame(frm)
        data = {}
        t, fg, bg = {}, {}, {}
        for k,v in pairs(base)do
            if(type(k)=="string")then
                data[k] = v
            else
                t[k], fg[k], bg[k] = v[1], v[2], v[3]
            end
        end
        manager.updateSize(w, h)
    end

    if(base~=nil)then
        if(#base>0)then
            w = #base[1][1]
            h = #base
            setFrame(base)
        end
    end

    return {
        recalculateSize = recalculateSize,
        setFrame = setFrame,

        getFrame = function()
            local f = {}

            for k,v in pairs(t)do
                table.insert(f, {v, fg[k], bg[k]})
            end

            for k,v in pairs(data)do
                f[k] = v
            end
            
            return f, w, h
        end,

        getImage = function()
            local i = {}
            for k,v in pairs(t)do
                table.insert(i, {v, fg[k], bg[k]})
            end
            return i
        end,

        setFrameData = function(key, value)
            if(value~=nil)then
                data[key] = value
            else
                if(type(key)=="table")then
                    data = key
                end
            end
        end,

        setFrameImage = function(imgData)
            for k,v in pairs(imgData.t)do
                t[k] = imgData.t[k]
                fg[k] = imgData.fg[k]
                bg[k] = imgData.bg[k]
            end
        end,

        getFrameImage = function()
            return {t = t, fg = fg, bg = bg}
        end,

        getFrameData = function(key)
            if(key~=nil)then
                return data[key]
            else
                return data
            end
        end,

        blit = function(text, fgCol, bgCol, x, y)
            addText(text, x, y)
            addFg(fgCol, x, y)
            addBg(bgCol, x, y)
        end,
        
        text = addText,
        fg = addFg,
        bg = addBg,

        getSize = function()
            return w, h
        end,

        setSize = function(_w, _h)
            local nt,nfg,nbg = {}, {}, {}
            for _y=1,_h do
                if(t[_y]~=nil)then
                    nt[_y] = sub(t[_y], 1, _w)..rep(" ", _w - w)
                else
                    nt[_y] = rep(" ", _w)
                end
                if(fg[_y]~=nil)then
                    nfg[_y] = sub(fg[_y], 1, _w)..rep("0", _w - w)
                else
                    nfg[_y] = rep("0", _w)
                end
                if(bg[_y]~=nil)then
                    nbg[_y] = sub(bg[_y], 1, _w)..rep("f", _w - w)
                else
                    nbg[_y] = rep("f", _w)
                end
            end
            t, fg, bg = nt, nfg, nbg
            w, h = _w, _h
        end,
    }
end

return function(img)
    local frames = {}
    local metadata = {creator="Bimg Library by NyoriE", date=os.date("!%Y-%m-%dT%TZ")}
    local width,height = 0, 0

    if(img~=nil)then
        if(img[1][1][1]~=nil)then
            width,height = metadata.width or #img[1][1][1], metadata.height or #img[1]
        end
    end

    local manager = {}

    local function addFrame(id, data)
        id = id or #frames+1
        local f = frame(data, manager)
        table.insert(frames, id, f)
        if(data==nil)then
            frames[id].setSize(width, height)
        end
        return f
    end

    local function removeFrame(id)
        table.remove(frames, id or #frames)
    end

    local function moveFrame(id, dir)
        local f = frames[id]
        if(f~=nil)then
        local newId = id+dir
            if(newId>=1)and(newId<=#frames)then
                table.remove(frames, id)
                table.insert(frames, newId, f)
            end
        end
    end

    manager = {
        updateSize = function(w, h, force)
            local changed = force==true and true or false
            if(w > width)then changed = true width = w end
            if(h > height)then changed = true height = h end
            if(changed)then
                for k,v in pairs(frames)do
                    v.setSize(width, height)
                    v.recalculateSize()
                end
            end
        end,

        text = function(frame, text, x, y)
            local f = frames[frame]
            if(f==nil)then
                f = addFrame(frame)
            end
            f.text(text, x, y)
        end,

        fg = function(frame, fg, x, y)
            local f = frames[frame]
            if(f==nil)then
                f = addFrame(frame)
            end
            f.fg(fg, x, y)
        end,

        bg = function(frame, bg, x, y)
            local f = frames[frame]
            if(f==nil)then
                f = addFrame(frame)
            end
            f.bg(bg, x, y)
        end,

        blit = function(frame, text, fg, bg, x, y)
            local f = frames[frame]
            if(f==nil)then
                f = addFrame(frame)
            end
            f.blit(text, fg, bg, x, y)
        end,

        setSize = function(w, h)
            width = w
            height = h
            for k,v in pairs(frames)do
                v.setSize(w, h)
            end
        end,

        getFrame = function(id)
            if(frames[id]~=nil)then
                return frames[id].getFrame()
            end
        end,

        getFrameObjects = function()
            return frames
        end,

        getFrames = function()
            local f = {}
            for k,v in pairs(frames)do
                local frame = v.getFrame()
                table.insert(f, frame)
            end
            return f
        end,

        getFrameObject = function(id)
            return frames[id]
        end,

        addFrame = function(id)
            if(#frames<=1)then
                if(metadata.animated==nil)then
                metadata.animated = true
                end
                if(metadata.secondsPerFrame==nil)then
                    metadata.secondsPerFrame = 0.2
                end
            end
            return addFrame(id)
        end,

        removeFrame = removeFrame,

        moveFrame = moveFrame,

        setFrameData = function(id, key, value)
            if(frames[id]~=nil)then
                frames[id].setFrameData(key, value)
            end
        end,

        getFrameData = function(id, key)
            if(frames[id]~=nil)then
                return frames[id].getFrameData(key)
            end
        end,

        getSize = function()
            return width, height
        end,

        setAnimation = function(anim)
            metadata.animation = anim
        end,

        setMetadata = function(key, val)
            if(val~=nil)then
                metadata[key] = val
            else
               if(type(key)=="table")then
                    metadata = key
               end
            end
        end,

        getMetadata = function(key)
            if(key~=nil)then
                return metadata[key]
            else
                return metadata
            end
        end,

        createBimg = function()
            local bimg = {}
            for k,v in pairs(frames)do
                local f = v.getFrame()
                table.insert(bimg, f)
            end
            for k,v in pairs(metadata)do
                bimg[k] = v
            end
            bimg.width = width
            bimg.height = height
            return bimg
        end,
    }

    if(img~=nil)then
        for k,v in pairs(img)do
            if(type(k)=="string")then
                metadata[k] = v
            end
        end
        if(metadata.width==nil)or(metadata.height==nil)then
            width = metadata.width or #img[1][1][1]
            height = metadata.height or #img[1]
            manager.updateSize(width, height, true)
        end

        for k,v in pairs(img)do
            if(type(k)=="number")then
                addFrame(k, v)
            end
        end
    else
        addFrame(1)
    end

    return manager
end
end
project["libraries"]["tHex"] = function(...)
local cols = {}

for i = 0, 15 do
    cols[2^i] = ("%x"):format(i)
end
return cols
end
project["libraries"]["utils"] = function(...)
local tHex = require("tHex")
local sub,find,reverse,rep,insert,len = string.sub,string.find,string.reverse,string.rep,table.insert,string.len

local function splitString(str, delimiter)
    local results = {}
    if str == "" or delimiter == "" then
        return results
    end
    local start = 1
    local delim_start, delim_end = find(str, delimiter, start)
        while delim_start do
            insert(results, sub(str, start, delim_start - 1))
            start = delim_end + 1
            delim_start, delim_end = find(str, delimiter, start)
        end
    insert(results, sub(str, start))
    return results
end

local function removeTags(input)
    return input:gsub("{[^}]+}", "")
end


local function wrapText(str, width)
    str = removeTags(str)
    if(str=="")or(width==0)then
        return {""}
    end
    local uniqueLines = splitString(str, "\n")
    local result = {}
    for k, v in pairs(uniqueLines) do
        if #v == 0 then
            table.insert(result, "")
        else
            while #v > width do
                local last_space = width
                for i = width, 1, -1 do
                    if sub(v, i, i) == " " then
                        last_space = i
                        break
                    end
                end

                if last_space == width then
                    local line = sub(v, 1, last_space - 1) .. "-"
                    table.insert(result, line)
                    v = sub(v, last_space)
                else
                    local line = sub(v, 1, last_space - 1)
                    table.insert(result, line)
                    v = sub(v, last_space + 1)
                end

                if #v <= width then
                    break
                end
            end
            if #v > 0 then
                table.insert(result, v)
            end
        end
    end
    return result
end

--- Coonverts a string with special tags to a table with colors and text
-- @param input The string to convert
-- @return A table with the following structure: { {text = "Hello", color = colors.red}, {text = "World", color = colors.blue} }
local function convertRichText(input)
    local parsedResult = {}
    local currentPosition = 1
    local rawPosition = 1

    while currentPosition <= #input do
        local closestColor, closestBgColor
        local color, bgColor
        local colorEnd, bgColorEnd

        for colorName, _ in pairs(colors) do
            local fgPattern = "{fg:" .. colorName.."}"
            local bgColorPattern = "{bg:" .. colorName.."}"
            local colorStart, colorEndCandidate = input:find(fgPattern, currentPosition)
            local bgColorStart, bgColorEndCandidate = input:find(bgColorPattern, currentPosition)

            if colorStart and (not closestColor or colorStart < closestColor) then
                closestColor = colorStart
                color = colorName
                colorEnd = colorEndCandidate
            end

            if bgColorStart and (not closestBgColor or bgColorStart < closestBgColor) then
                closestBgColor = bgColorStart
                bgColor = colorName
                bgColorEnd = bgColorEndCandidate
            end
        end

        local nextPosition
        if closestColor and (not closestBgColor or closestColor < closestBgColor) then
            nextPosition = closestColor
        elseif closestBgColor then
            nextPosition = closestBgColor
        else
            nextPosition = #input + 1
        end

        local text = input:sub(currentPosition, nextPosition - 1)
        if #text > 0 then
            table.insert(parsedResult, {
                color = nil,
                bgColor = nil,
                text = text,
                position = rawPosition
            })
            rawPosition = rawPosition + #text
            currentPosition = currentPosition + #text
        end

        if closestColor and (not closestBgColor or closestColor < closestBgColor) then
            table.insert(parsedResult, {
                color = color,
                bgColor = nil,
                text = "",
                position = rawPosition,
            })
            currentPosition = colorEnd + 1
        elseif closestBgColor then
            table.insert(parsedResult, {
                color = nil,
                bgColor = bgColor,
                text = "",
                position = rawPosition,
            })
            currentPosition = bgColorEnd + 1
        else
            break
        end
    end

    return parsedResult
end

--- Wrapts text with special color tags, like {fg:red} or {bg:blue} to multiple lines
--- @param text string Text to wrap
--- @param width number Width of the line
--- @return table Table of lines
local function wrapRichText(text, width)
    local colorData = convertRichText(text)
    local formattedLines = {}
    local x, y = 1, 1
    local currentColor, currentBgColor

    local function addFormattedEntry(entry)
        table.insert(formattedLines, {
            x = x,
            y = y,
            text = entry.text,
            color = entry.color or currentColor,
            bgColor = entry.bgColor or currentBgColor
        })
    end

    for _, entry in ipairs(colorData) do
        if entry.color then
            currentColor = entry.color
        elseif entry.bgColor then
            currentBgColor = entry.bgColor
        else
            local words = splitString(entry.text, " ")

            for i, word in ipairs(words) do
                local wordLength = #word

                if i > 1 then
                    if x + 1 + wordLength <= width then
                        addFormattedEntry({ text = " " })
                        x = x + 1
                    else
                        x = 1
                        y = y + 1
                    end
                end

                while wordLength > 0 do
                    local line = word:sub(1, width - x + 1)
                    word = word:sub(width - x + 2)
                    wordLength = #word

                    addFormattedEntry({ text = line })

                    if wordLength > 0 then
                        x = 1
                        y = y + 1
                    else
                        x = x + #line
                    end
                end
            end
        end

        if x > width then
            x = 1
            y = y + 1
        end
    end

    return formattedLines
end


    

return {
getTextHorizontalAlign = function(text, width, textAlign, replaceChar)
    text = sub(text, 1, width)
    local offset = width - len(text)
    if (textAlign == "right") then
        text = rep(replaceChar or " ", offset) .. text
    elseif (textAlign == "center") then
        text = rep(replaceChar or " ", math.floor(offset / 2)) .. text .. rep(replaceChar or " ", math.floor(offset / 2))
        text = text .. (len(text) < width and (replaceChar or " ") or "")
    else
        text = text .. rep(replaceChar or " ", offset)
    end
    return text
end,

getTextVerticalAlign = function(h, textAlign)
    local offset = 0
    if (textAlign == "center") then
        offset = math.ceil(h / 2)
        if (offset < 1) then
            offset = 1
        end
    end
    if (textAlign == "bottom") then
        offset = h
    end
    if(offset<1)then offset=1 end
    return offset
end,

orderedTable = function(t)
    local newTable = {}
    for _, v in pairs(t) do
        newTable[#newTable+1] = v
    end
    return newTable
end,

rpairs = function(t)
    return function(t, i)
        i = i - 1
        if i ~= 0 then
            return i, t[i]
        end
    end, t, #t + 1
end,

tableCount = function(t)
    local n = 0
    if(t~=nil)then
        for k,v in pairs(t)do
            n = n + 1
        end
    end
    return n
end,

splitString = splitString,
removeTags = removeTags,

wrapText = wrapText,

xmlValue = function(name, tab)
    local var
    if(type(tab)~="table")then return end
    if(tab[name]~=nil)then
        if(type(tab[name])=="table")then
            if(tab[name].value~=nil)then
                var = tab[name]:value()
            end
        end
    end
    if(var==nil)then var = tab["@"..name] end

    if(var=="true")then 
        var = true 
    elseif(var=="false")then 
        var = false
    elseif(tonumber(var)~=nil)then 
        var = tonumber(var)
    end
    return var
end,

convertRichText = convertRichText,

--- Writes text with special color tags
--- @param obj object The object to write to
--- @param x number X-Position
--- @param y number Y-Position
--- @param text string The text to write
writeRichText = function(obj, x, y, text)
    local richText = convertRichText(text)
    if(#richText==0)then
        obj:addText(x, y, text)
        return
    end

    local defaultFG, defaultBG = obj:getForeground(), obj:getBackground()
    for _,v in pairs(richText)do
        obj:addText(x+v.position-1, y, v.text)
        if(v.color~=nil)then
            obj:addFG(x+v.position-1, y, tHex[colors[v.color] ]:rep(#v.text))
            defaultFG = colors[v.color]
        else
            obj:addFG(x+v.position-1, y, tHex[defaultFG]:rep(#v.text))
        end
        if(v.bgColor~=nil)then
            obj:addBG(x+v.position-1, y, tHex[colors[v.bgColor] ]:rep(#v.text))
            defaultBG = colors[v.bgColor]
        else
            if(defaultBG~=false)then
                obj:addBG(x+v.position-1, y, tHex[defaultBG]:rep(#v.text))
            end
        end
    end
end,

wrapRichText = wrapRichText,

--- Writes wrapped Text with special tags.
--- @param obj object The object to write to
--- @param x number X-Position
--- @param y number Y-Position
--- @param text string Text
--- @param width number Width
--- @param height number Height
writeWrappedText = function(obj, x, y, text, width, height)
    local wrapped = wrapRichText(text, width)
    for _,v in pairs(wrapped)do
        if(v.y>height)then
            break
        end
        if(v.text~=nil)then
            obj:addText(x+v.x-1, y+v.y-1, v.text)
        end
        if(v.color~=nil)then
            obj:addFG(x+v.x-1, y+v.y-1, tHex[colors[v.color] ]:rep(#v.text))
        end
        if(v.bgColor~=nil)then
            obj:addBG(x+v.x-1, y+v.y-1, tHex[colors[v.bgColor] ]:rep(#v.text))
        end
    end
end,

--- Returns a random UUID.
--- @return string UUID.
uuid = function()
    return string.gsub(string.format('%x-%x-%x-%x-%x', math.random(0, 0xffff), math.random(0, 0xffff), math.random(0, 0xffff), math.random(0, 0x0fff) + 0x4000, math.random(0, 0x3fff) + 0x8000), ' ', '0')
end

}
end
project["libraries"]["process"] = function(...)
local processes = {}
local process = {}
local processId = 0

local newPackage = dofile("rom/modules/main/cc/require.lua").make

function process:new(path, window, newEnv, ...)
    local args = {...}
    local newP = setmetatable({ path = path }, { __index = self })
    newP.window = window
    window.current = term.current
    window.redirect = term.redirect
    newP.processId = processId
    if(type(path)=="string")then
    newP.coroutine = coroutine.create(function()
        local pPath = shell.resolveProgram(path)
        local env = setmetatable(newEnv, {__index=_ENV})
        env.shell = shell
        env.basaltProgram=true
        env.arg = {[0]=path, table.unpack(args)}
        if(pPath==nil)then
            error("The path "..path.." does not exist!")
        end
        env.require, env.package = newPackage(env, fs.getDir(pPath))
        if(fs.exists(pPath))then
            local file = fs.open(pPath, "r")
            local content = file.readAll()
            file.close()
            local program = load(content, path, "bt", env)
            if(program~=nil)then
                return program()
            end
        end
    end)
    elseif(type(path)=="function")then
        newP.coroutine = coroutine.create(function()
            path(table.unpack(args))
        end)
    else
        return
    end
    processes[processId] = newP
    processId = processId + 1
    return newP
end

function process:resume(event, ...)
    local cur = term.current()
    term.redirect(self.window)
    if(self.filter~=nil)then
        if(event~=self.filter)then return end
        self.filter=nil
    end
    local ok, result = coroutine.resume(self.coroutine, event, ...)

    if ok then
        self.filter = result
    else
        printError(result)
    end
    term.redirect(cur)
    return ok, result
end

function process:isDead()
    if (self.coroutine ~= nil) then
        if (coroutine.status(self.coroutine) == "dead") then
            table.remove(processes, self.processId)
            return true
        end
    else
        return true
    end
    return false
end

function process:getStatus()
    if (self.coroutine ~= nil) then
        return coroutine.status(self.coroutine)
    end
    return nil
end

function process:start()
    coroutine.resume(self.coroutine)
end

return process
end
project["plugin"] = function(...)
local args = {...}
local plugins = {}
local pluginNames = {}

local dir = fs.getDir(args[2] or "Basalt")
local pluginDir = fs.combine(dir, "plugins")
if(packaged)then
    for k,v in pairs(getProject("plugins"))do
        table.insert(pluginNames, k)
        local newPlugin = v()
        if(type(newPlugin)=="table")then
            for a,b in pairs(newPlugin)do
                if(type(a)=="string")then
                    if(plugins[a]==nil)then plugins[a] = {} end
                    table.insert(plugins[a], b)
                end
            end
        end
    end
end
if(fs.exists(pluginDir))then
    for _,v in pairs(fs.list(pluginDir))do
        table.insert(pluginNames, v)
        local newPlugin = require(v:gsub(".lua", ""))
        if(type(newPlugin)=="table")then
            for a,b in pairs(newPlugin)do
                if(type(a)=="string")then
                    if(plugins[a]==nil)then plugins[a] = {} end
                    table.insert(plugins[a], b)
                end
            end
        end
    end
end

local function get(name)
    return plugins[name]
end

return {
    --- Gets a plugin list
    --- @param name string name of plugin list
    --- @return table plugins
    get = get,
    getAvailablePlugins = function()
        return pluginNames
    end,

    --- Adds a plugin to basalt's plugin list
    --- @param path string path to plugin
    addPlugin = function(path)
        if(fs.exists(path))then
            if(fs.isDir(path))then
                for _,v in pairs(fs.list(path))do
                    table.insert(pluginNames, v)
                    if not(fs.isDir(fs.combine(path, v)))then
                        local pluginName = v:gsub(".lua", "")
                        local newPlugin = require(fs.combine(path, pluginName))
                        if(type(newPlugin)=="table")then
                            for a,b in pairs(newPlugin)do
                                if(type(a)=="string")then
                                    if(plugins[a]==nil)then plugins[a] = {} end
                                    table.insert(plugins[a], b)
                                end
                            end
                        end
                    end
                end
            else
                local newPlugin = require(path:gsub(".lua", ""))
                table.insert(pluginNames, path:match("[\\/]?([^\\/]-([^%.]+))$"))
                if(type(newPlugin)=="table")then
                    for a,b in pairs(newPlugin)do
                        if(type(a)=="string")then
                            if(plugins[a]==nil)then plugins[a] = {} end
                            table.insert(plugins[a], b)
                        end
                    end
                end
            end
        end
    end,

    --- Loads all available plugins into basalt's objects
    --- @param objects table objects to load plugins into
    --- @param basalt table basalt
    --- @return table objects modified objects
    loadPlugins = function(objects, basalt)
        for k,v in pairs(objects)do
            local plugList = plugins[k]
            if(plugList~=nil)then
                objects[k] = function(...)
                    local moddedObject = v(...)
                    for _,b in pairs(plugList)do
                        local ext = b(moddedObject, basalt, ...)
                        ext.__index = ext
                        moddedObject = setmetatable(ext, moddedObject)
                    end
                    return moddedObject
                end
            end
        end
        return objects
    end
}
end
project["objects"] = {}

project["objects"]["Button"] = function(...)
local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    -- Button
    local base = basalt.getObject("VisualObject")(name, basalt)
    local objectType = "Button"
    local textHorizontalAlign = "center"
    local textVerticalAlign = "center"

    local text = "Button"

    base:setSize(12, 3)
    base:setZIndex(5)

    local object = {
        getType = function(self)
            return objectType
        end,
        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        getBase = function(self)
            return base
        end,  
        
        setHorizontalAlign = function(self, pos)
            textHorizontalAlign = pos
            self:updateDraw()
            return self
        end,

        setVerticalAlign = function(self, pos)
            textVerticalAlign = pos
            self:updateDraw()
            return self
        end,

        setText = function(self, newText)
            text = newText
            self:updateDraw()
            return self
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("button", function()
                local w,h = self:getSize()
                local verticalAlign = utils.getTextVerticalAlign(h, textVerticalAlign)
                local xOffset
                if(textHorizontalAlign=="center")then
                    xOffset = math.floor((w - text:len()) / 2)
                elseif(textHorizontalAlign=="right")then
                    xOffset = w - text:len()
                end

                self:addText(xOffset + 1, verticalAlign, text)
                self:addFG(xOffset + 1, verticalAlign, tHex[self:getForeground() or colors.white]:rep(text:len()))
            end)
        end,
    }
    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Checkbox"] = function(...)
local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    -- Checkbox
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Checkbox"

    base:setZIndex(5)
    base:setValue(false)
    base:setSize(1, 1)

    local symbol,inactiveSymbol,text,textPos = "\42"," ","","right"

    local object = {
        load = function(self)
            self:listenEvent("mouse_click", self)
            self:listenEvent("mouse_up", self)
        end,

        getType = function(self)
            return objectType
        end,
        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        setSymbol = function(self, sym, inactive)
            symbol = sym or symbol
            inactiveSymbol = inactive or inactiveSymbol
            self:updateDraw()
            return self
        end,

        getSymbol = function(self)
            return symbol, inactiveSymbol
        end,

        setText = function(self, _text)
            text = _text
            return self
        end,

        setTextPosition = function(self, pos)
            textPos = pos or textPos
            return self
        end,

        setChecked = base.setValue,

        mouseHandler = function(self, button, x, y)
            if (base.mouseHandler(self, button, x, y)) then
                if(button == 1)then
                    if (self:getValue() ~= true) and (self:getValue() ~= false) then
                        self:setValue(false)
                    else
                        self:setValue(not self:getValue())
                    end
                self:updateDraw()
                return true
                end
            end
            return false
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("checkbox", function()
                local obx, oby = self:getPosition()
                local w,h = self:getSize()
                local verticalAlign = utils.getTextVerticalAlign(h, "center")
                local bg,fg = self:getBackground(), self:getForeground()
                if (self:getValue()) then
                    self:addBlit(1, verticalAlign, utils.getTextHorizontalAlign(symbol, w, "center"), tHex[fg], tHex[bg])
                else
                    self:addBlit(1, verticalAlign, utils.getTextHorizontalAlign(inactiveSymbol, w, "center"), tHex[fg], tHex[bg])
                end
                if(text~="")then
                    local align = textPos=="left" and -text:len() or 3
                    self:addText(align, verticalAlign, text)
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Dropdown"] = function(...)
local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("List")(name, basalt)
    local objectType = "Dropdown"

    base:setSize(12, 1)
    base:setZIndex(6)

    local selectionColorActive = true
    local align = "left"
    local yOffset = 0

    local dropdownW = 0
    local dropdownH = 0
    local autoSize = true
    local closedSymbol = "\16"
    local openedSymbol = "\31"
    local isOpened = false

    local object = {
        getType = function(self)
            return objectType
        end,

        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        load = function(self)
            self:listenEvent("mouse_click", self)
            self:listenEvent("mouse_up", self)
            self:listenEvent("mouse_scroll", self)
            self:listenEvent("mouse_drag", self)
        end,

        setOffset = function(self, yOff)
            yOffset = yOff
            self:updateDraw()
            return self
        end,

        getOffset = function(self)
            return yOffset
        end,

        addItem = function(self, t, ...)
            base.addItem(self, t, ...)
            if(autoSize)then
                dropdownW = math.max(dropdownW, #t)
                dropdownH = dropdownH + 1
            end
            return self
        end,

        removeItem = function(self, index)
            base.removeItem(self, index)
            if(autoSize)then
                dropdownW = 0
                dropdownH = 0
                for n = 1, #list do
                    dropdownW = math.max(dropdownW, #list[n].text)
                end
                dropdownH = #list
            end
        end,

        isOpened = function(self)
            return isOpened
        end,

        setOpened = function(self, open)
            isOpened = open
            self:updateDraw()
            return self
        end,

        setDropdownSize = function(self, width, height)
            dropdownW, dropdownH = width, height
            autoSize = false
            self:updateDraw()
            return self
        end,

        getDropdownSize = function(self)
            return dropdownW, dropdownH
        end,

        mouseHandler = function(self, button, x, y, isMon)
            if (isOpened) then
                local obx, oby = self:getAbsolutePosition()
                if(button==1)then
                    local list = self:getAll()
                    if (#list > 0) then
                        for n = 1, dropdownH do
                            if (list[n + yOffset] ~= nil) then
                                if (obx <= x) and (obx + dropdownW > x) and (oby + n == y) then
                                    self:setValue(list[n + yOffset])
                                    self:updateDraw()
                                    local val = self:sendEvent("mouse_click", self, "mouse_click", button, x, y)
                                    if(val==false)then return val end
                                    if(isMon)then
                                        basalt.schedule(function()
                                            sleep(0.1)
                                            self:mouseUpHandler(button, x, y)
                                        end)()
                                    end
                                    return true
                                end
                            end
                        end
                    end
                end
            end
            local base = base:getBase()
            if (base.mouseHandler(self, button, x, y)) then
                isOpened = not isOpened
                self:getParent():setImportant(self)
                self:updateDraw()
                return true
            else
                if(isOpened)then 
                    self:updateDraw()
                    isOpened = false
                end 
                return false
            end
        end,

        mouseUpHandler = function(self, button, x, y)
            if (isOpened) then
                local obx, oby = self:getAbsolutePosition()
                if(button==1)then
                    local list = self:getAll()
                    if (#list > 0) then
                        for n = 1, dropdownH do
                            if (list[n + yOffset] ~= nil) then
                                if (obx <= x) and (obx + dropdownW > x) and (oby + n == y) then
                                    isOpened = false
                                    self:updateDraw()
                                    local val = self:sendEvent("mouse_up", self, "mouse_up", button, x, y)
                                    if(val==false)then return val end
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end,

        dragHandler = function(self, btn, x, y)
            if(base.dragHandler(self, btn, x, y))then
                isOpened = true
            end
        end,

        scrollHandler = function(self, dir, x, y)
            if(isOpened)then
                local xPos, yPos = self:getAbsolutePosition()
                if(x >= xPos)and(x <= xPos + dropdownW)and(y >= yPos)and(y <= yPos + dropdownH)then
                    self:setFocus()
                end
            end
            if (isOpened)and(self:isFocused()) then
                local xPos, yPos = self:getAbsolutePosition()
                if(x < xPos)or(x > xPos + dropdownW)or(y < yPos)or(y > yPos + dropdownH)then
                    return false
                end
                if(#self:getAll() <= dropdownH)then return false end

                local list = self:getAll()
                yOffset = yOffset + dir
                if (yOffset < 0) then
                    yOffset = 0
                end
                if (dir == 1) then
                    if (#list > dropdownH) then
                        if (yOffset > #list - dropdownH) then
                            yOffset = #list - dropdownH
                        end
                    else
                        yOffset = math.min(#list - 1, 0)
                    end
                end
                local val = self:sendEvent("mouse_scroll", self, "mouse_scroll", dir, x, y)
                if(val==false)then return val end
                self:updateDraw()
                return true
            end
        end,

        draw = function(self)
            base.draw(self)
            self:setDrawState("list", false)
            self:addDraw("dropdown", function()
                local obx, oby = self:getPosition()
                local w,h = self:getSize()
                local val = self:getValue()
                local list = self:getAll()
                local bgCol, fgCol = self:getBackground(), self:getForeground()
                local text = utils.getTextHorizontalAlign((val~=nil and val.text or ""), w, align):sub(1, w - 1)  .. (isOpened and openedSymbol or closedSymbol)
                self:addBlit(1, 1, text, tHex[fgCol]:rep(#text), tHex[bgCol]:rep(#text))

                if (isOpened) then
                    self:addTextBox(1, 2, dropdownW, dropdownH, " ")
                    self:addBackgroundBox(1, 2, dropdownW, dropdownH, bgCol)
                    self:addForegroundBox(1, 2, dropdownW, dropdownH, fgCol)
                    for n = 1, dropdownH do
                        if (list[n + yOffset] ~= nil) then
                            local t =utils.getTextHorizontalAlign(list[n + yOffset].text, dropdownW, align)
                            if (list[n + yOffset] == val) then
                                if (selectionColorActive) then
                                    local itemSelectedBG, itemSelectedFG = self:getSelectionColor()
                                    self:addBlit(1, n+1, t, tHex[itemSelectedFG]:rep(#t), tHex[itemSelectedBG]:rep(#t))
                                else
                                    self:addBlit(1, n+1, t, tHex[list[n + yOffset].fgCol]:rep(#t), tHex[list[n + yOffset].bgCol]:rep(#t))
                                end
                            else
                                self:addBlit(1, n+1, t, tHex[list[n + yOffset].fgCol]:rep(#t), tHex[list[n + yOffset].bgCol]:rep(#t))
                            end
                        end
                    end
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["BaseFrame"] = function(...)
local drawSystem = require("basaltDraw")
local utils = require("utils")

local max,min,sub,rep = math.max,math.min,string.sub,string.rep

return function(name, basalt)
    local base = basalt.getObject("Container")(name, basalt)
    local objectType = "BaseFrame"

    local xOffset, yOffset = 0, 0

    local colorTheme = {}

    local updateRender = true
    
    local termObject = basalt.getTerm()
    local basaltDraw = drawSystem(termObject)

    local xCursor, yCursor, cursorBlink, cursorColor = 1, 1, false, colors.white

    local object = {   
        getType = function()
            return objectType
        end,
        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        getBase = function(self)
            return base
        end,

        getOffset = function(self)
            return xOffset, yOffset
        end,

        setOffset = function(self, xOff, yOff)
            xOffset = xOff or xOffset
            yOffset = yOff or yOffset
            self:updateDraw()
            return self
        end,

        setPalette = function(self, col, ...)            
            if(self==basalt.getActiveFrame())then
                if(type(col)=="string")then
                    colorTheme[col] = ...
                    termObject.setPaletteColor(type(col)=="number" and col or colors[col], ...)
                elseif(type(col)=="table")then
                    for k,v in pairs(col)do
                        colorTheme[k] = v
                        if(type(v)=="number")then
                            termObject.setPaletteColor(type(k)=="number" and k or colors[k], v)
                        else
                            local r,g,b = table.unpack(v)
                            termObject.setPaletteColor(type(k)=="number" and k or colors[k], r,g,b)
                        end
                    end
                end
            end
            return self
        end,

        setSize = function(self, ...)
            base.setSize(self, ...)
            basaltDraw = drawSystem(termObject)
            return self
        end,

        getSize = function()
            return termObject.getSize()
        end,

        getWidth = function(self)
            return ({termObject.getSize()})[1]
        end,

        getHeight = function(self)
            return ({termObject.getSize()})[2]
        end,

        show = function(self)
            base.show(self)
            basalt.setActiveFrame(self)
            for k,v in pairs(colors)do
                if(type(v)=="number")then
                    termObject.setPaletteColor(v, colors.packRGB(term.nativePaletteColor((v))))
                end
            end
            for k,v in pairs(colorTheme)do
                if(type(v)=="number")then
                    termObject.setPaletteColor(type(k)=="number" and k or colors[k], v)
                else
                    local r,g,b = table.unpack(v)
                    termObject.setPaletteColor(type(k)=="number" and k or colors[k], r,g,b)
                end
            end
            basalt.setMainFrame(self)
            return self
        end,

        render = function(self)
            if(base.render~=nil)then
                if(self:isVisible())then
                    if(updateRender)then
                        base.render(self)
                        local objects = self:getObjects()
                        for _, obj in ipairs(objects) do
                            if (obj.element.render ~= nil) then
                                obj.element:render()
                            end
                        end
                        updateRender = false
                    end
                end
            end
        end,

        updateDraw = function(self)
            updateRender = true
            return self
        end,

        eventHandler = function(self, event, ...)
            base.eventHandler(self, event, ...)
            if(event=="term_resize")then
                self:setSize(termObject.getSize())
            end
        end,

        updateTerm = function(self)
            if(basaltDraw~=nil)then
                basaltDraw.update()
            end
        end,

        setTerm = function(self, newTerm)
            termObject = newTerm
            if(newTerm==nil)then
                basaltDraw = nil
            else
                basaltDraw = drawSystem(termObject)
            end
            return self
        end,

        getTerm = function()
            return termObject
        end,

        blit = function (self, x, y, t, f, b)
            local obx, oby = self:getPosition()
            local w, h = self:getSize()
            if y >= 1 and y <= h then
                local t_visible = sub(t, max(1 - x + 1, 1), max(w - x + 1, 1))
                local f_visible = sub(f, max(1 - x + 1, 1), max(w - x + 1, 1))
                local b_visible = sub(b, max(1 - x + 1, 1), max(w - x + 1, 1))
                basaltDraw.blit(max(x + (obx - 1), obx), oby + y - 1, t_visible, f_visible, b_visible)
            end
        end,

        setCursor = function(self, _blink, _xCursor, _yCursor, color)
            local obx, oby = self:getAbsolutePosition()
            local xO, yO = self:getOffset()
            cursorBlink = _blink or false
            if (_xCursor ~= nil) then
                xCursor = obx + _xCursor - 1 - xO
            end
            if (_yCursor ~= nil) then
                yCursor = oby + _yCursor - 1 - yO
            end
            cursorColor = color or cursorColor
            if (cursorBlink) then
                termObject.setTextColor(cursorColor)
                termObject.setCursorPos(xCursor, yCursor)
                termObject.setCursorBlink(cursorBlink)
            else
                termObject.setCursorBlink(false)
            end
            return self
        end,
    }

    for k,v in pairs({mouse_click={"mouseHandler", true},mouse_up={"mouseUpHandler", false},mouse_drag={"dragHandler", false},mouse_scroll={"scrollHandler", true},mouse_hover={"hoverHandler", false}})do
        object[v[1]] = function(self, btn, x, y, ...)
            if(base[v[1]](self, btn, x, y, ...))then
                basalt.setActiveFrame(self)
            end
        end
    end

    for k,v in pairs({"drawBackgroundBox", "drawForegroundBox", "drawTextBox"})do
        object[v] = function(self, x, y, width, height, symbol)
            local obx, oby = self:getPosition()
            local w, h  = self:getSize()
            height = (y < 1 and (height + y > self:getHeight() and self:getHeight() or height + y - 1) or (height + y > self:getHeight() and self:getHeight() - y + 1 or height))
            width = (x < 1 and (width + x > self:getWidth() and self:getWidth() or width + x - 1) or (width + x > self:getWidth() and self:getWidth() - x + 1 or width))
            basaltDraw[v](max(x + (obx - 1), obx), max(y + (oby - 1), oby), width, height, symbol)
        end
    end

    for k,v in pairs({"setBG", "setFG", "setText"}) do
        object[v] = function(self, x, y, str)
            local obx, oby = self:getPosition()
            local w, h  = self:getSize()
            if (y >= 1) and (y <= h) then
                basaltDraw[v](max(x + (obx - 1), obx), oby + y - 1, sub(str, max(1 - x + 1, 1), max(w - x + 1,1)))
            end
        end
    end


    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Container"] = function(...)
local utils = require("utils")
local tableCount = utils.tableCount

return function(name, basalt)
    local base = basalt.getObject("VisualObject")(name, basalt)
    local objectType = "Container"

    local elements = {}

    local events = {}

    local container = {}

    local focusedObject
    local sorted = true
    local objId, evId = 0, 0

    local objSort = function(a, b)
        if a.zIndex == b.zIndex then
            return a.objId < b.objId
        else
            return a.zIndex < b.zIndex
        end
    end
    local evSort = function(a, b)
        if a.zIndex == b.zIndex then
            return a.evId > b.evId
        else
            return a.zIndex > b.zIndex
        end
    end

    local function getObject(self, name)
        if(type(name)=="table")then name = name:getName() end
        for i, v in ipairs(elements) do
            if v.element:getName() == name then
                return v.element
            end
        end    
    end

    local function getDeepObject(self, name)
        local o = getObject(name)
        if(o~=nil)then return o end
        for _, value in pairs(objects) do            
            if (b:getType() == "Container") then
                local oF = b:getDeepObject(name)
                if(oF~=nil)then return oF end
            end
        end
    end

    local function addObject(self, element, el2)
        if (getObject(element:getName()) ~= nil) then
            return
        end
        objId = objId + 1
        local zIndex = element:getZIndex()
        table.insert(elements, {element = element, zIndex = zIndex, objId = objId})
        sorted = false
        element:setParent(self, true)
        if(element.init~=nil)then element:init() end
        if(element.load~=nil)then element:load() end
        if(element.draw~=nil)then element:draw() end
        return element
    end

    local function updateZIndex(self, element, newZ)
        objId = objId + 1
        evId = evId + 1
        for _,v in pairs(elements)do
            if(v.element==element)then
                v.zIndex = newZ
                v.objId = objId
                break
            end
        end
        for _,v in pairs(events)do
            for a,b in pairs(v)do
                if(b.element==element)then
                    b.zIndex = newZ
                    b.evId = evId
                end
            end
        end
        sorted = false
        self:updateDraw()
    end

    local function removeObject(self, element)
        if(type(element)=="string")then element = getObject(element:getName()) end
        if(element==nil)then return end
        for i, v in ipairs(elements) do
            if v.element == element then
                table.remove(elements, i)
                return true
            end
        end
        sorted = false
    end

    local function removeEvents(self, element)
        local parent = self:getParent()
        for a, b in pairs(events) do
            for c, d in pairs(b) do
                if(d.element == element)then
                    table.remove(events[a], c)
                end
            end
            if(tableCount(events[a])<=0)then
                if(parent~=nil)then
                    parent:removeEvent(a, self)
                end
            end
        end
        sorted = false
    end

    local function getEvent(self, event, name)
        if(type(name)=="table")then name = name:getName() end
        if(events[event]~=nil)then
            for _, obj in pairs(events[event]) do
                if (obj.element:getName() == name) then
                    return obj
                end
            end
        end
    end

    local function addEvent(self, event, element)
        if (getEvent(self, event, element:getName()) ~= nil) then
            return
        end
        local zIndex = element:getZIndex() 
        evId = evId + 1
        if(events[event]==nil)then events[event] = {} end
        table.insert(events[event], {element = element, zIndex = zIndex, evId = evId})
        sorted = false
        self:listenEvent(event)
        return element
    end

    local function removeEvent(self, event, element)
        if(events[event]~=nil)then
            for a, b in pairs(events[event]) do
                if(b.element == element)then
                    table.remove(events[event], a)
                end
            end
            if(tableCount(events[event])<=0)then
                self:listenEvent(event, false)
            end
        end
        sorted = false
    end

    local function getObjects(self)
        self:sortElementOrder()
        return elements
    end

    local function getEvents(self, event)
        return event~=nil and events[event] or events
    end

    container = {
        getType = function()
            return objectType
        end,

        getBase = function(self)
            return base
        end,  
        
        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,
        
        setSize = function(self, ...)
            base.setSize(self, ...)
            self:customEventHandler("basalt_FrameResize")
            return self
        end,

        setPosition = function(self, ...)
            base.setPosition(self, ...)
            self:customEventHandler("basalt_FrameReposition")
            return self
        end,

        searchObjects = function(self, name)
            local t = {}
            for k,v in pairs(elements)do
                if(string.find(k:getName(), name))then
                    table.insert(t, v)
                end
            end
            return t
        end,

        getObjectsByType = function(self, t)
            local t = {}
            for k,v in pairs(elements)do
                if(v:isType(t))then
                    table.insert(t, v)
                end
            end
            return t
        end,

        setImportant = function(self, element)
            objId = objId + 1
            evId = evId + 1
            for a, b in pairs(events) do
                for c, d in pairs(b) do
                    if(d.element == element)then
                        d.evId = evId
                        table.remove(events[a], c)
                        table.insert(events[a], d)
                        break
                    end
                end
            end
            for i, v in ipairs(elements) do
                if v.element == element then
                    v.objId = objId
                    table.remove(elements, i)
                    table.insert(elements, v)
                    break
                end
            end
            if(self.updateDraw~=nil)then
                self:updateDraw()
            end
            sorted = false
        end,

        sortElementOrder = function(self)
            if(sorted)then return end
            table.sort(elements, objSort)
            for a, b in pairs(events) do
                table.sort(events[a], evSort)
            end
            sorted = true
        end,

        removeFocusedObject = function(self)
            if(focusedObject~=nil)then
                if(getObject(self, focusedObject)~=nil)then
                    focusedObject:loseFocusHandler()
                end
            end
            focusedObject = nil
            return self
        end,

        setFocusedObject = function(self, obj)
            if(focusedObject~=obj)then
                if(focusedObject~=nil)then
                    if(getObject(self, focusedObject)~=nil)then
                        focusedObject:loseFocusHandler()
                    end
                end
                if(obj~=nil)then
                    if(getObject(self, obj)~=nil)then
                        obj:getFocusHandler()
                    end
                end
                focusedObject = obj
                return true
            end
            return false
        end,

        getFocusedObject = function(self)
            return focusedObject
        end,
        
        getObject = getObject,
        getObjects = getObjects,
        getDeepObject = getDeepObject,
        addObject = addObject,
        removeObject = removeObject,
        getEvents = getEvents,
        getEvent = getEvent,
        addEvent = addEvent,
        removeEvent = removeEvent,
        removeEvents = removeEvents,
        updateZIndex = updateZIndex,

        listenEvent = function(self, event, active)
            base.listenEvent(self, event, active)
            if(events[event]==nil)then events[event] = {} end
            return self
        end,

        customEventHandler = function(self, ...)
            base.customEventHandler(self, ...)
            for _, o in pairs(elements) do
                if (o.element.customEventHandler ~= nil) then
                    o.element:customEventHandler(...)
                end
            end
        end,

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            if(focusedObject~=nil)then focusedObject:loseFocusHandler() focusedObject = nil end
        end,

        getBasalt = function(self)
            return basalt
        end,

        setPalette = function(self, col, ...)
            local parent = self:getParent()
            parent:setPalette(col, ...)
            return self
        end,

        eventHandler = function(self, ...)
            if(base.eventHandler~=nil)then
                base.eventHandler(self, ...)
                if(events["other_event"]~=nil)then
                    self:sortElementOrder()
                    for _, obj in ipairs(events["other_event"]) do
                        if (obj.element.eventHandler ~= nil) then
                            obj.element.eventHandler(obj.element, ...)
                        end
                    end
                end
            end
        end,
    }

    for k,v in pairs({mouse_click={"mouseHandler", true},mouse_up={"mouseUpHandler", false},mouse_drag={"dragHandler", false},mouse_scroll={"scrollHandler", true},mouse_hover={"hoverHandler", false}})do
        container[v[1]] = function(self, btn, x, y, ...)
            if(base[v[1]]~=nil)then
                if(base[v[1]](self, btn, x, y, ...))then
                    if(events[k]~=nil)then
                        self:sortElementOrder()
                        for _, obj in ipairs(events[k]) do
                            if (obj.element[v[1]] ~= nil) then
                                local xO, yO = 0, 0
                                if(self.getOffset~=nil)then
                                    xO, yO = self:getOffset()
                                end
                                if(obj.element.getIgnoreOffset~=nil)then
                                    if(obj.element.getIgnoreOffset())then
                                        xO, yO = 0, 0
                                    end
                                end
                                if (obj.element[v[1]](obj.element, btn, x+xO, y+yO, ...)) then      
                                    return true
                                end
                            end
                        end
                    if(v[2])then
                        self:removeFocusedObject()
                    end
                    end
                    return true
                end
            end
        end
    end

    for k,v in pairs({key="keyHandler",key_up="keyUpHandler",char="charHandler"})do
        container[v] = function(self, ...)
            if(base[v]~=nil)then
                if(base[v](self, ...))then
                    if(events[k]~=nil)then  
                        self:sortElementOrder()                  
                        for _, obj in ipairs(events[k]) do
                            if (obj.element[v] ~= nil) then
                                if (obj.element[v](obj.element, ...)) then
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    for k,v in pairs(basalt.getObjects())do
        container["add"..k] = function(self, name)
            return addObject(self, v(name, basalt))
        end
    end

    container.__index = container
    return setmetatable(container, base)
end
end
project["objects"]["List"] = function(...)
local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "List"

    local list = {}
    local itemSelectedBG = colors.black
    local itemSelectedFG = colors.lightGray
    local selectionColorActive = true
    local textAlign = "left"
    local yOffset = 0
    local scrollable = true

    base:setSize(16, 8)
    base:setZIndex(5)

    local object = {
        init = function(self)
            local parent = self:getParent()
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_drag")
            self:listenEvent("mouse_scroll")
            return base.init(self)
        end,

        getBase = function(self)
            return base
        end,

        setTextAlign = function(self, align)
            textAlign = align
            return self
        end,

        getTextAlign = function(self)
            return textAlign
        end,

        getBase = function(self)
            return base
        end,  

        getType = function(self)
            return objectType
        end,

        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        addItem = function(self, text, bgCol, fgCol, ...)
            table.insert(list, { text = text, bgCol = bgCol or self:getBackground(), fgCol = fgCol or self:getForeground(), args = { ... } })
            if (#list <= 1) then
                self:setValue(list[1], false)
            end
            self:updateDraw()
            return self
        end,

        setOptions = function(self, ...)
            list = {}
            for k,v in pairs(...)do
                if(type(v)=="string")then
                    table.insert(list, { text = v, bgCol = self:getBackground(), fgCol = self:getForeground(), args = {} })
                else
                    table.insert(list, { text = v[1], bgCol = v[2] or self:getBackground(), fgCol = v[3] or self:getForeground(), args = v[4] or {} })
                end
            end
            self:setValue(list[1], false)
            self:updateDraw()
            return self
        end,

        setOffset = function(self, yOff)
            yOffset = yOff
            self:updateDraw()
            return self
        end,

        getOffset = function(self)
            return yOffset
        end,

        removeItem = function(self, index)
            if(type(index)=="number")then
                table.remove(list, index)
            elseif(type(index)=="table")then
                for k,v in pairs(list)do
                    if(v==index)then
                        table.remove(list, k)
                        break
                    end
                end
            end
            self:updateDraw()
            return self
        end,

        getItem = function(self, index)
            return list[index]
        end,

        getAll = function(self)
            return list
        end,

        getOptions = function(self)
            return list
        end,

        getItemIndex = function(self)
            local selected = self:getValue()
            for key, value in pairs(list) do
                if (value == selected) then
                    return key
                end
            end
        end,

        clear = function(self)
            list = {}
            self:setValue({}, false)
            self:updateDraw()
            return self
        end,

        getItemCount = function(self)
            return #list
        end,

        editItem = function(self, index, text, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { text = text, bgCol = bgCol or self:getBackground(), fgCol = fgCol or self:getForeground(), args = { ... } })
            self:updateDraw()
            return self
        end,

        selectItem = function(self, index)
            self:setValue(list[index] or {}, false)
            self:updateDraw()
            return self
        end,

        setSelectionColor = function(self, bgCol, fgCol, active)
            itemSelectedBG = bgCol or self:getBackground()
            itemSelectedFG = fgCol or self:getForeground()
            selectionColorActive = active~=nil and active or true
            self:updateDraw()
            return self
        end,

        getSelectionColor = function(self)
            return itemSelectedBG, itemSelectedFG
        end,

        isSelectionColorActive = function(self)
            return selectionColorActive
        end,

        setScrollable = function(self, scroll)
            scrollable = scroll
            if(scroll==nil)then scrollable = true end
            self:updateDraw()
            return self
        end,

        scrollHandler = function(self, dir, x, y)
            if(base.scrollHandler(self, dir, x, y))then
                if(scrollable)then
                    local w,h = self:getSize()
                    yOffset = yOffset + dir
                    if (yOffset < 0) then
                        yOffset = 0
                    end
                    if (dir >= 1) then
                        if (#list > h) then
                            if (yOffset > #list - h) then
                                yOffset = #list - h
                            end
                            if (yOffset >= #list) then
                                yOffset = #list - 1
                            end
                        else
                            yOffset = yOffset - 1
                        end
                    end
                    self:updateDraw()
                end
                return true
            end
            return false
        end,

        mouseHandler = function(self, button, x, y)
            if(base.mouseHandler(self, button, x, y))then
                local obx, oby = self:getAbsolutePosition()
                local w,h = self:getSize()
                if (#list > 0) then
                    for n = 1, h do
                        if (list[n + yOffset] ~= nil) then
                            if (obx <= x) and (obx + w > x) and (oby + n - 1 == y) then
                                self:setValue(list[n + yOffset])
                                self:selectHandler()
                                self:updateDraw()
                            end
                        end
                    end
                end
                return true
            end
            return false
        end,

        dragHandler = function(self, button, x, y)
            return self:mouseHandler(button, x, y)
        end,

        touchHandler = function(self, x, y)
            return self:mouseHandler(1, x, y)
        end,

        onSelect = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("select_item", v)
                end
            end
            return self
        end,

        selectHandler = function(self)
            self:sendEvent("select_item", self:getValue())
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("list", function()
                local w, h = self:getSize()
                for n = 1, h do
                    if list[n + yOffset] then
                        local t = list[n + yOffset].text
                        local fg, bg = list[n + yOffset].fgCol, list[n + yOffset].bgCol
                        if list[n + yOffset] == self:getValue() and selectionColorActive then
                            fg, bg = itemSelectedFG, itemSelectedBG
                        end
                        self:addText(1, n, t:sub(1,w))
                        self:addBG(1, n, tHex[bg]:rep(w))
                        self:addFG(1, n, tHex[fg]:rep(w))
                    end
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Frame"] = function(...)
local utils = require("utils")

local max,min,sub,rep,len = math.max,math.min,string.sub,string.rep,string.len

return function(name, basalt)
    local base = basalt.getObject("Container")(name, basalt)
    local objectType = "Frame"
    local parent
    
    local updateRender = true

    local xOffset, yOffset = 0, 0

    base:setSize(30, 10)
    base:setZIndex(10)

    local object = {    
        getType = function()
            return objectType
        end,

        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        getBase = function(self)
            return base
        end,  
        
        getOffset = function(self)
            return xOffset, yOffset
        end,

        setOffset = function(self, xOff, yOff)
            xOffset = xOff or xOffset
            yOffset = yOff or yOffset
            self:updateDraw()
            return self
        end,

        setParent = function(self, p, ...)
            base.setParent(self, p, ...)
            parent = p
            return self
        end,

        render = function(self)
            if(base.render~=nil)then
                if(self:isVisible())then
                    base.render(self)
                    local objects = self:getObjects()
                    for _, obj in ipairs(objects) do
                        if (obj.element.render ~= nil) then
                            obj.element:render()
                        end
                    end
                end
            end
        end,

        updateDraw = function(self)
            if(parent~=nil)then
                parent:updateDraw()
            end
            return self
        end,

        blit = function (self, x, y, t, f, b)
            local obx, oby = self:getPosition()
            local xO, yO = parent:getOffset()
            obx = obx - xO
            oby = oby - yO
            local w, h = self:getSize()        
            if y >= 1 and y <= h then
                local t_visible = sub(t, max(1 - x + 1, 1), max(w - x + 1, 1))
                local f_visible = sub(f, max(1 - x + 1, 1), max(w - x + 1, 1))
                local b_visible = sub(b, max(1 - x + 1, 1), max(w - x + 1, 1))        
                parent:blit(max(x + (obx - 1), obx), oby + y - 1, t_visible, f_visible, b_visible)
            end
        end,      

        setCursor = function(self, blink, x, y, color)
            local obx, oby = self:getPosition()
            local xO, yO = self:getOffset()
            parent:setCursor(blink or false, (x or 0)+obx-1 - xO, (y or 0)+oby-1 - yO, color or colors.white)
            return self
        end,
    }

    for k,v in pairs({"drawBackgroundBox", "drawForegroundBox", "drawTextBox"})do
        object[v] = function(self, x, y, width, height, symbol)
            local obx, oby = self:getPosition()
            local xO, yO = parent:getOffset()
            obx = obx - xO
            oby = oby - yO
            height = (y < 1 and (height + y > self:getHeight() and self:getHeight() or height + y - 1) or (height + y > self:getHeight() and self:getHeight() - y + 1 or height))
            width = (x < 1 and (width + x > self:getWidth() and self:getWidth() or width + x - 1) or (width + x > self:getWidth() and self:getWidth() - x + 1 or width))
            parent[v](parent, max(x + (obx - 1), obx), max(y + (oby - 1), oby), width, height, symbol)
        end
    end

    for k,v in pairs({"setBG", "setFG", "setText"})do
        object[v] = function(self, x, y, str)
            local obx, oby = self:getPosition()
            local xO, yO = parent:getOffset()
            obx = obx - xO
            oby = oby - yO
            local w, h  = self:getSize()
            if (y >= 1) and (y <= h) then
                parent[v](parent, max(x + (obx - 1), obx), oby + y - 1, sub(str, max(1 - x + 1, 1), max(w - x + 1,1)))
            end
        end
    end

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Input"] = function(...)
local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    -- Input
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Input"

    local inputType = "text"
    local inputLimit = 0
    base:setZIndex(5)
    base:setValue("")
    base:setSize(12, 1)

    local textX = 1
    local wIndex = 1

    local defaultText = ""
    local defaultBGCol = colors.black
    local defaultFGCol = colors.lightGray
    local showingText = defaultText
    local internalValueChange = false

    local object = {
        load = function(self)
            self:listenEvent("mouse_click")
            self:listenEvent("key")
            self:listenEvent("char")
            self:listenEvent("other_event")
            self:listenEvent("mouse_drag")
        end,

        getType = function(self)
            return objectType
        end,
        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        setDefaultText = function(self, text, fCol, bCol)
            defaultText = text
            defaultFGCol = fCol or defaultFGCol
            defaultBGCol = bCol or defaultBGCol
            if (self:isFocused()) then
                showingText = ""
            else
                showingText = defaultText
            end
            self:updateDraw()
            return self
        end,

        getDefaultText = function(self)
            return defaultText, defaultFGCol, defaultBGCol
        end,

        setOffset = function(self, x)
            wIndex = x
            self:updateDraw()
            return self
        end,

        getOffset = function(self)
            return wIndex
        end,

        setTextOffset = function(self, x)
            textX = x
            self:updateDraw()
            return self
        end,

        getTextOffset = function(self)
            return textX
        end,

        setInputType = function(self, t)
            inputType = t
            self:updateDraw()
            return self
        end,

        getInputType = function(self)
            return inputType
        end,

        setValue = function(self, val)
            base.setValue(self, tostring(val))
            if not (internalValueChange) then
                textX = tostring(val):len() + 1
                wIndex = math.max(1, textX-self:getWidth()+1)
                if(self:isFocused())then
                    local parent = self:getParent()
                    local obx, oby = self:getPosition()
                    parent:setCursor(true, obx + textX - wIndex, oby+math.floor(self:getHeight()/2), self:getForeground())
                end
            end
            self:updateDraw()
            return self
        end,

        getValue = function(self)
            local val = base.getValue(self)
            return inputType == "number" and tonumber(val) or val
        end,

        setInputLimit = function(self, limit)
            inputLimit = tonumber(limit) or inputLimit
            self:updateDraw()
            return self
        end,

        getInputLimit = function(self)
            return inputLimit
        end,

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            local parent = self:getParent()
            if (parent ~= nil) then
                local obx, oby = self:getPosition()
                showingText = ""
                if(defaultText~="")then
                    self:updateDraw()
                end
                parent:setCursor(true, obx + textX - wIndex, oby+math.max(math.ceil(self:getHeight()/2-1, 1)), self:getForeground())
            end
        end,

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            local parent = self:getParent()
            showingText = defaultText
            if(defaultText~="")then
                self:updateDraw()
            end
            parent:setCursor(false)
        end,

        keyHandler = function(self, key)
            if (base.keyHandler(self, key)) then
                local w,h = self:getSize()
                local parent = self:getParent()
                internalValueChange = true
                    if (key == keys.backspace) then
                        -- on backspace
                        local text = tostring(base.getValue())
                        if (textX > 1) then
                            self:setValue(text:sub(1, textX - 2) .. text:sub(textX, text:len()))
                            textX = math.max(textX - 1, 1)
                            if (textX < wIndex) then
                                wIndex = math.max(wIndex - 1, 1)
                            end
                        end
                    end
                    if (key == keys.enter) then
                        parent:removeFocusedObject(self)
                    end
                    if (key == keys.right) then
                        local tLength = tostring(base.getValue()):len()
                        textX = textX + 1

                        if (textX > tLength) then
                            textX = tLength + 1
                        end
                        textX = math.max(textX, 1)
                        if (textX < wIndex) or (textX >= w + wIndex) then
                            wIndex = textX - w + 1
                        end
                        wIndex = math.max(wIndex, 1)
                    end

                    if (key == keys.left) then
                        -- left arrow
                        textX = textX - 1
                        if (textX >= 1) then
                            if (textX < wIndex) or (textX >= w + wIndex) then
                                wIndex = textX
                            end
                        end
                        textX = math.max(textX, 1)
                        wIndex = math.max(wIndex, 1)
                    end
                local obx, oby = self:getPosition()
                local val = tostring(base.getValue())

                self:updateDraw()
                internalValueChange = false
                return true
            end
        end,

        charHandler = function(self, char)
            if (base.charHandler(self, char)) then
                internalValueChange = true
                local w,h = self:getSize()
                local text = base.getValue()
                if (text:len() < inputLimit or inputLimit <= 0) then
                    if (inputType == "number") then
                        local cache = text
                        if (textX==1 and char == "-") or (char == ".") or (tonumber(char) ~= nil) then
                            self:setValue(text:sub(1, textX - 1) .. char .. text:sub(textX, text:len()))
                            textX = textX + 1
                            if(char==".")or(char=="-")and(#text>0)then
                                if (tonumber(base.getValue()) == nil) then
                                    self:setValue(cache)
                                    textX = textX - 1
                                end
                            end
                        end
                    else
                        self:setValue(text:sub(1, textX - 1) .. char .. text:sub(textX, text:len()))
                        textX = textX + 1
                    end
                    if (textX >= w + wIndex) then
                        wIndex = wIndex + 1
                    end
                end
                local obx, oby = self:getPosition()
                local val = tostring(base.getValue())

                internalValueChange = false
                self:updateDraw()
                return true
            end
        end,

        mouseHandler = function(self, button, x, y)
            if(base.mouseHandler(self, button, x, y))then
                local parent = self:getParent()
                local ax, ay = self:getPosition()
                local obx, oby = self:getAbsolutePosition(ax, ay)
                local w, h = self:getSize()
                textX = x - obx + wIndex
                local text = base.getValue()
                if (textX > text:len()) then
                    textX = text:len() + 1
                end
                if (textX < wIndex) then
                    wIndex = textX - 1
                    if (wIndex < 1) then
                        wIndex = 1
                    end
                end
                parent:setCursor(true, ax + textX - wIndex, ay+math.max(math.ceil(h/2-1, 1)), self:getForeground())
                return true
            end
        end,

        dragHandler = function(self, btn, x, y, xOffset, yOffset)
            if(self:isFocused())then
                if(self:isCoordsInObject(x, y))then
                    if(base.dragHandler(self, btn, x, y, xOffset, yOffset))then
                        return true
                    end
                end
                local parent = self:getParent()
                parent:removeFocusedObject()
            end
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("input", function()
                local parent = self:getParent()
                local obx, oby = self:getPosition()
                local w,h = self:getSize()
                local verticalAlign = utils.getTextVerticalAlign(h, textVerticalAlign)
     
                local val = tostring(base.getValue())
                local bCol = self:getBackground()
                local fCol = self:getForeground()
                local text
                if (val:len() <= 0) then
                    text = showingText
                    bCol = defaultBGCol or bCol
                    fCol = defaultFGCol or fCol
                end

                text = showingText
                if (val ~= "") then
                    text = val
                end
                text = text:sub(wIndex, w + wIndex - 1)
                local space = w - text:len()
                if (space < 0) then
                    space = 0
                end
                if (inputType == "password") and (val ~= "") then
                    text = string.rep("*", text:len())
                end
                text = text .. string.rep(" ", space)
                self:addBlit(1, verticalAlign, text, tHex[fCol]:rep(text:len()), tHex[bCol]:rep(text:len()))

                if(self:isFocused())then
                    parent:setCursor(true, obx + textX - wIndex, oby+math.floor(self:getHeight()/2), self:getForeground())
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["ChangeableObject"] = function(...)
return function(name, basalt)
    local base = basalt.getObject("VisualObject")(name, basalt)
    -- Base object
    local objectType = "ChangeableObject"

    local value
    
    local object = {
        setValue = function(self, _value, valueChangedHandler)
            if (value ~= _value) then
                value = _value
                self:updateDraw()
                if(valueChangedHandler~=false)then
                    self:valueChangedHandler()
                end
            end
            return self
        end,

        getValue = function(self)
            return value
        end,

        onChange = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("value_changed", v)
                end
            end
            return self
        end,

        valueChangedHandler = function(self)
            self:sendEvent("value_changed", value)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Flexbox"] = function(...)
return function(name, basalt)
    local base = basalt.getObject("Frame")(name, basalt)
    local objectType = "Flexbox"

    local flexDirection = "row" -- "row" or "column"
    local justifyContent = "flex-start" -- "flex-start", "flex-end", "center", "space-between", "space-around"
    local alignItems = "flex-start" -- "flex-start", "flex-end", "center", "space-between", "space-around"
    local spacing = 1

    local function getObjectOffAxisOffset(self, obj)
        local width, height = self:getSize()
        local objWidth, objHeight = obj.element:getSize()
        local availableSpace = flexDirection == "row" and height - objHeight or width - objWidth
        local offset = 1
        if alignItems == "center" then
            offset = 1 + availableSpace / 2
        elseif alignItems == "flex-end" then
            offset = 1 + availableSpace
        end
        return offset
    end

    local function applyLayout(self)
        local objects = self:getObjects()
        local totalElements = #objects
        local width, height = self:getSize()
    
        local mainAxisTotalChildSize = 0
        for _, obj in ipairs(objects) do
            local objWidth, objHeight = obj.element:getSize()
            if flexDirection == "row" then
                mainAxisTotalChildSize = mainAxisTotalChildSize + objWidth
            else
                mainAxisTotalChildSize = mainAxisTotalChildSize + objHeight
            end
        end
        local mainAxisAvailableSpace = (flexDirection == "row" and width or height) - mainAxisTotalChildSize - (spacing * (totalElements - 1))
        local justifyContentOffset = 1
        if justifyContent == "center" then
            justifyContentOffset = 1 + mainAxisAvailableSpace / 2
        elseif justifyContent == "flex-end" then
            justifyContentOffset = 1 + mainAxisvailableSpace
        end
    
        for _, obj in ipairs(objects) do
            local alignItemsOffset = getObjectOffAxisOffset(self, obj)
            if flexDirection == "row" then
                obj.element:setPosition(justifyContentOffset, alignItemsOffset)
                local objWidth, _ = obj.element:getSize()
                justifyContentOffset = justifyContentOffset + objWidth + spacing
            else
                obj.element:setPosition(alignItemsOffset, math.floor(justifyContentOffset+0.5))
                local _, objHeight = obj.element:getSize()
                justifyContentOffset = justifyContentOffset + objHeight + spacing
            end
        end
    end
    

    local object = {
        getType = function()
            return objectType
        end,

        isType = function(self, t)
            return objectType == t or base.getBase(self).isType(t) or false
        end,

        setSpacing = function(self, newSpacing)
            spacing = newSpacing
            applyLayout(self)
            return self
        end,
    
        getSpacing = function(self)
            return spacing
        end,

        setFlexDirection = function(self, direction)
            if direction == "row" or direction == "column" then
                flexDirection = direction
                applyLayout(self)
            end
            return self
        end,

        setJustifyContent = function(self, alignment)
            if alignment == "flex-start" or alignment == "flex-end" or alignment == "center" or alignment == "space-between" or alignment == "space-around" then
                justifyContent = alignment
                applyLayout(self)
            end
            return self
        end,

        setAlignItems = function(self, alignment)
            if alignment == "flex-start" or alignment == "flex-end" or alignment == "center" or alignment == "space-between" or alignment == "space-around" then
                alignItems = alignment
                applyLayout(self)
            end
            return self
        end,
    }

    for k,v in pairs(basalt.getObjects())do
        object["add"..k] = function(self, name)
            local obj = base["add"..k](self, name)
            applyLayout(base)
            return obj
        end
    end

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Graph"] = function(...)
return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Graph"

    base:setZIndex(5)
    base:setSize(30, 10)

    local graphData = {}
    local graphColor = colors.gray
    local graphSymbol = "\7"
    local graphSymbolCol = colors.black
    local maxValue = 100
    local minValue = 0
    local graphType = "line"
    local maxEntries = 10

    local object = {
        getType = function(self)
            return objectType
        end,

        setGraphColor = function(self, color)
            graphColor = color or graphColor
            self:updateDraw()
            return self
        end,

        setGraphSymbol = function(self, symbol, symbolcolor)
            graphSymbol = symbol or graphSymbol
            graphSymbolCol = symbolcolor or graphSymbolCol
            self:updateDraw()
            return self
        end,

        getGraphSymbol = function(self)
            return graphSymbol, graphSymbolCol
        end,

        addDataPoint = function(self, value)
            if value >= minValue and value <= maxValue then
                table.insert(graphData, value)
                self:updateDraw()
            end
            if(#graphData>100)then -- 100 is hard capped to prevent memory leaks
                table.remove(graphData,1)
            end
            return self
        end,

        setMaxValue = function(self, value)
            maxValue = value
            self:updateDraw()
            return self
        end,

        getMaxValue = function(self)
            return maxValue
        end,

        setMinValue = function(self, value)
            minValue = value
            self:updateDraw()
            return self
        end,

        getMinValue = function(self)
            return minValue
        end,

        setGraphType = function(self, graph_type)
            if graph_type == "scatter" or graph_type == "line" or graph_type == "bar" then
                graphType = graph_type
                self:updateDraw()
            end
            return self
        end,

        setMaxEntries = function(self, value)
            maxEntries = value
            self:updateDraw()
            return self
        end,
    
        getMaxEntries = function(self)
            return maxEntries
        end,

        clear = function(self)
            graphData = {}
            self:updateDraw()
            return self
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("graph", function()
                local obx, oby = self:getPosition()
                local w, h = self:getSize()
                local bgCol, fgCol = self:getBackground(), self:getForeground()

                local range = maxValue - minValue
                local prev_x, prev_y

                local startIndex = #graphData - maxEntries + 1
                if startIndex < 1 then startIndex = 1 end

                for i = startIndex, #graphData do
                    local data = graphData[i]
                    local x = math.floor(((w - 1) / (maxEntries - 1)) * (i - startIndex) + 1.5)
                    local y = math.floor((h - 1) - ((h - 1) / range) * (data - minValue) + 1.5)


                    if graphType == "scatter" then
                        self:addBackgroundBox(x, y, 1, 1, graphColor)
                        self:addForegroundBox(x, y, 1, 1, graphSymbolCol)
                        self:addTextBox(x, y, 1, 1, graphSymbol)
                    elseif graphType == "line" then
                        if prev_x and prev_y then
                            local dx = math.abs(x - prev_x)
                            local dy = math.abs(y - prev_y)
                            local sx = prev_x < x and 1 or -1
                            local sy = prev_y < y and 1 or -1
                            local err = dx - dy
                        
                            while true do
                                self:addBackgroundBox(prev_x, prev_y, 1, 1, graphColor)
                                self:addForegroundBox(prev_x, prev_y, 1, 1, graphSymbolCol)
                                self:addTextBox(prev_x, prev_y, 1, 1, graphSymbol)
                        
                                if prev_x == x and prev_y == y then
                                    break
                                end
                        
                                local e2 = 2 * err
                        
                                if e2 > -dy then
                                    err = err - dy
                                    prev_x = prev_x + sx
                                end
                        
                                if e2 < dx then
                                    err = err + dx
                                    prev_y = prev_y + sy
                                end
                            end
                        end
                        prev_x, prev_y = x, y
                    elseif graphType == "bar" then
                        self:addBackgroundBox(x - 1, y, 1, h - y, graphColor)
                    end
                end
            end)
        end,

    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Label"] = function(...)
local utils = require("utils")
local wrapText = utils.wrapText
local writeWrappedText = utils.writeWrappedText
local tHex = require("tHex")

return function(name, basalt)
    -- Label
    local base = basalt.getObject("VisualObject")(name, basalt)
    local objectType = "Label"

    base:setZIndex(3)
    base:setSize(5, 1)
    base:setBackground(false)

    local autoSize = true
    local text, textAlign = "Label", "left"

    local object = {
        --- Returns the object type.
        --- @return string
        getType = function(self)
            return objectType
        end,

        --- Returns the label's base object.
        --- @return object
        getBase = function(self)
            return base
        end,
        
        --- Changes the label's text.
        --- @param newText string  The new text of the label.
        --- @return object
        setText = function(self, newText)
            text = tostring(newText)
            if(autoSize)then
                local t = wrapText(text, #text)
                local newW, newH = 1,1
                for k,v in pairs(t)do
                    newH = newH+1
                    newW = math.max(newW, v:len())
                end
                self:setSize(newW, newH)
                autoSize = true
            end
            self:updateDraw()
            return self
        end,

        --- Returns the label's autoSize property.
        --- @return boolean
        getAutoSize = function(self)
            return autoSize
        end,

        --- Sets the label's autoSize property.
        --- @param bool boolean  The new value of the autoSize property.
        --- @return object
        setAutoSize = function(self, bool)
            autoSize = bool
            return self
        end,

        --- Returns the label's text.
        --- @return string
        getText = function(self)
            return text
        end,

        --- Sets the size of the label.
        --- @param width number  The width of the label.
        --- @param height number  The height of the label.
        --- @return object
        setSize = function(self, width, height)
            base.setSize(self, width, height)
            autoSize = false
            return self
        end,

        --- Sets the text alignment of the label.
        --- @param align string  The alignment of the text. Can be "left", "center", or "right".
        --- @return object
        setTextAlign = function(self, align)
            textAlign = align or textAlign
            return self;
        end,

        --- Queues a new draw function to be called when the object is drawn.
        draw = function(self)
            base.draw(self)
            self:addDraw("label", function()
                local w, h = self:getSize()
                local align = textAlign=="center" and math.floor(w/2-text:len()/2+0.5) or textAlign=="right" and w-(text:len()-1) or 1
                writeWrappedText(self, align, 1, text, w+1, h)
            end)
        end,
        
        --- Initializes the label.
        init = function(self)
            base.init(self)
            local parent = self:getParent()
            self:setForeground(parent:getForeground())
        end

    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Image"] = function(...)
local images = require("images")
local bimg = require("bimg")
local unpack,sub,max,min = table.unpack,string.sub,math.max,math.min
return function(name, basalt)
    -- Image
    local base = basalt.getObject("VisualObject")(name, basalt)
    local objectType = "Image"

    local bimgLibrary = bimg()
    local bimgFrame = bimgLibrary.getFrameObject(1)
    local originalImage
    local image
    local activeFrame = 1

    local infinitePlay = false
    local animTimer
    local usePalette = false
    local autoSize = true

    local xOffset, yOffset = 0, 0

    base:setSize(24, 8)
    base:setZIndex(2)

    local function getPalette(id)
        local p = {}
        for k,v in pairs(colors)do
            if(type(v)=="number")then
                p[k] = {term.nativePaletteColor(v)}
            end
        end
        local globalPalette = bimgLibrary.getMetadata("palette")
        if(globalPalette~=nil)then
            for k,v in pairs(globalPalette)do
                p[k] = tonumber(v)
            end
        end
        local localPalette = bimgLibrary.getFrameData("palette")
        basalt.log(localPalette)
        if(localPalette~=nil)then
            for k,v in pairs(localPalette)do
                p[k] = tonumber(v)
            end
        end
        return p
    end

    local function checkAutoSize()
        if(autoSize)then
            if(bimgLibrary~=nil)then
                base:setSize(bimgLibrary.getSize())
            end
        end
    end

    local object = {
        getType = function(self)
            return objectType
        end,
        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        setOffset = function(self, _x, _y, rel)
            if(rel)then
                xOffset = xOffset + _x or 0
                yOffset = yOffset + _y or 0
            else
                xOffset = _x or xOffset
                yOffset = _y or yOffset
            end
            self:updateDraw()
            return self
        end,

        setSize = function(self, _x, _y)
            base:setSize(_x, _y)
            autoSize = false
            return self
        end,

        getOffset = function(self)
            return xOffset, yOffset
        end,

        selectFrame = function(self, id)
            if(bimgLibrary.getFrameObject(id)==nil)then
                bimgLibrary.addFrame(id)
            end
            bimgFrame = bimgLibrary.getFrameObject(id)
            image = bimgFrame.getImage(id)
            activeFrame = id
            self:updateDraw()
        end,

        addFrame = function(self, id)
            bimgLibrary.addFrame(id)
            return self
        end,

        getFrame = function(self, id)
            return bimgLibrary.getFrame(id)
        end,

        getFrameObject = function(self, id)
            return bimgLibrary.getFrameObject(id)
        end,

        removeFrame = function(self, id)
            bimgLibrary.removeFrame(id)
            return self
        end,

        moveFrame = function(self, id, dir)
            bimgLibrary.moveFrame(id, dir)
            return self
        end,

        getFrames = function(self)
            return bimgLibrary.getFrames()
        end,

        getFrameCount = function(self)
            return #bimgLibrary.getFrames()
        end,

        getActiveFrame = function(self)
            return activeFrame
        end,

        loadImage = function(self, path)
            if(fs.exists(path))then
                local newBimg = images.loadBIMG(path)
                bimgLibrary = bimg(newBimg)
                activeFrame = 1
                bimgFrame = bimgLibrary.getFrameObject(1)
                originalImage = bimgLibrary.createBimg()
                image = bimgFrame.getImage()
                checkAutoSize()
                self:updateDraw()
            end     
            return self
        end,

        setImage = function(self, t)
            if(type(t)=="table")then
                bimgLibrary = bimg(t)
                activeFrame = 1
                bimgFrame = bimgLibrary.getFrameObject(1)
                originalImage = bimgLibrary.createBimg()
                image = bimgFrame.getImage()
                checkAutoSize()
                self:updateDraw()
            end
            return self
        end,

        clear = function(self)
            bimgLibrary = bimg()
            bimgFrame = bimgLibrary.getFrameObject(1)
            image = nil
            self:updateDraw()
            return self
        end,

        getImage = function(self)
            return bimgLibrary.createBimg()
        end,

        getImageFrame = function(self, id)
            return bimgFrame.getImage(id)
        end,

        usePalette = function(self, use)
            usePalette = use~=nil and use or true
            return self
        end,

        play = function(self, inf)
            if(bimgLibrary.getMetadata("animated"))then
                local t = bimgLibrary.getMetadata("duration") or bimgLibrary.getMetadata("secondsPerFrame") or 0.2
                self:listenEvent("other_event")
                animTimer = os.startTimer(t)
                infinitePlay = inf or false
            end
            return self
        end,

        stop = function(self)
            os.cancelTimer(animTimer)
            animTimer = nil
            infinitePlay = false
            return self
        end,

        eventHandler = function(self, event, timerId, ...)
            base.eventHandler(self, event, timerId, ...)
            if(event=="timer")then
                if(timerId==animTimer)then
                    if(bimgLibrary.getFrame(activeFrame+1)~=nil)then
                        activeFrame = activeFrame + 1
                        self:selectFrame(activeFrame)
                        local t = bimgLibrary.getFrameData(activeFrame, "duration") or bimgLibrary.getMetadata("secondsPerFrame") or 0.2
                        animTimer = os.startTimer(t)
                    else
                        if(infinitePlay)then
                            activeFrame = 1
                            self:selectFrame(activeFrame)
                            local t = bimgLibrary.getFrameData(activeFrame, "duration") or bimgLibrary.getMetadata("secondsPerFrame") or 0.2
                            animTimer = os.startTimer(t)
                        end
                    end
                    self:updateDraw()
                end
            end
        end,

        setMetadata = function(self, key, value)
            bimgLibrary.setMetadata(key, value)
            return self
        end,

        getMetadata = function(self, key)
            return bimgLibrary.getMetadata(key)
        end,

        getFrameMetadata = function(self, id, key)
            return bimgLibrary.getFrameData(id, key)
        end,

        setFrameMetadata = function(self, id, key, value)
            bimgLibrary.setFrameData(id, key, value)
            return self
        end,

        blit = function(self, text, fg, bg, _x, _y)
            x = _x or x
            y = _y or y
            bimgFrame.blit(text, fg, bg, x, y)
            image = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        setText = function(self, text, _x, _y)
            x = _x or x
            y = _y or y
            bimgFrame.text(text, x, y)
            image = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        setBg = function(self, bg, _x, _y)
            x = _x or x
            y = _y or y
            bimgFrame.bg(bg, x, y)
            image = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        setFg = function(self, fg, _x, _y)
            x = _x or x
            y = _y or y
            bimgFrame.fg(fg, x, y)
            image = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        getImageSize = function(self)
            return bimgLibrary.getSize()
        end,

        setImageSize = function(self, w, h)
            bimgLibrary.setSize(w, h)
            image = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        resizeImage = function(self, w, h)
            local newBimg = images.resizeBIMG(originalImage, w, h)
            bimgLibrary = bimg(newBimg)
            activeFrame = 1
            bimgFrame = bimgLibrary.getFrameObject(1)
            image = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("image", function()
                local w,h = self:getSize()
                local x, y = self:getPosition()
                local wParent, hParent = self:getParent():getSize()
                local parentXOffset, parentYOffset = self:getParent():getOffset()
                
                if(x - parentXOffset > wParent)or(y - parentYOffset > hParent)or(x - parentXOffset + w < 1)or(y - parentYOffset + h < 1)then
                    return
                end

                if(usePalette)then
                    self:getParent():setPalette(getPalette(activeFrame))
                end

                if(image~=nil)then
                    for k,v in pairs(image)do
                        if(k+yOffset<=h)and(k+yOffset>=1)then
                            local t,f,b = v[1],v[2],v[3]

                            local startIdx = max(1 - xOffset, 1)
                            local endIdx = min(w - xOffset, #t)
                            
                            t = sub(t, startIdx, endIdx)
                            f = sub(f, startIdx, endIdx)
                            b = sub(b, startIdx, endIdx)

                            self:addBlit(max(1 + xOffset, 1), k + yOffset, t, f, b)
                        end
                    end
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Menubar"] = function(...)
local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("List")(name, basalt)
    local objectType = "Menubar"
    local object = {}

    base:setSize(30, 1)
    base:setZIndex(5)

    local itemOffset = 0
    local space, outerSpace = 1, 1
    local scrollable = true

    local function maxScroll()
        local mScroll = 0
        local w = base:getWidth()
        local list = base:getAll()
        for n = 1, #list do
            mScroll = mScroll + list[n].text:len() + space * 2
        end
        return math.max(mScroll - w, 0)
    end

    object = {
        init = function(self)
            local parent = self:getParent()
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_drag")
            self:listenEvent("mouse_scroll")
            return base.init(self)
        end,

        getType = function(self)
            return objectType
        end,

        getBase = function(self)
            return base
        end,

        setSpace = function(self, _space)
            space = _space or space
            self:updateDraw()
            return self
        end,

        setScrollable = function(self, scroll)
            scrollable = scroll
            if(scroll==nil)then scrollable = true end
            return self
        end,


        mouseHandler = function(self, button, x, y)
            if(base:getBase().mouseHandler(self, button, x, y))then
                local objX, objY = self:getAbsolutePosition()
                local w,h = self:getSize()
                    local xPos = 0
                    local list = self:getAll()
                    for n = 1, #list do
                        if (list[n] ~= nil) then
                            if (objX + xPos <= x + itemOffset) and (objX + xPos + list[n].text:len() + (space*2) > x + itemOffset) and (objY == y) then
                                self:setValue(list[n])
                                self:sendEvent(event, self, event, 0, x, y, list[n])
                            end
                            xPos = xPos + list[n].text:len() + space * 2
                        end
                    end
                self:updateDraw()
                return true
            end
        end,

        scrollHandler = function(self, dir, x, y)
            if(base:getBase().scrollHandler(self, dir, x, y))then
                if(scrollable)then
                    itemOffset = itemOffset + dir
                    if (itemOffset < 0) then
                        itemOffset = 0
                    end

                    local mScroll = maxScroll()

                    if (itemOffset > mScroll) then
                        itemOffset = mScroll
                    end
                    self:updateDraw()
                end
                return true
            end
            return false
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("list", function()
                local parent = self:getParent()
                local w,h = self:getSize()
                local text = ""
                local textBGCol = ""
                local textFGCol = ""
                local itemSelectedBG, itemSelectedFG = self:getSelectionColor()
                for _, v in pairs(self:getAll()) do
                    local newItem = (" "):rep(space) .. v.text .. (" "):rep(space)
                    text = text .. newItem
                    if(v == self:getValue())then
                        textBGCol = textBGCol .. tHex[itemSelectedBG or v.bgCol or self:getBackground()]:rep(newItem:len())
                        textFGCol = textFGCol .. tHex[itemSelectedFG or v.FgCol or self:getForeground()]:rep(newItem:len())
                    else
                        textBGCol = textBGCol .. tHex[v.bgCol or self:getBackground()]:rep(newItem:len())
                        textFGCol = textFGCol .. tHex[v.FgCol or self:getForeground()]:rep(newItem:len())
                    end
                end

                self:addBlit(1, 1, text:sub(itemOffset+1, w+itemOffset), textFGCol:sub(itemOffset+1, w+itemOffset), textBGCol:sub(itemOffset+1, w+itemOffset))
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Object"] = function(...)
local basaltEvent = require("basaltEvent")
local utils = require("utils")
local uuid = utils.uuid

local unpack,sub = table.unpack,string.sub

return function(name, basalt)
    name = name or uuid()
    assert(basalt~=nil, "Unable to find basalt instance! ID: "..name)

    -- Base object
    local objectType = "Object" -- not changeable
    local isEnabled,initialized = true,false

    local eventSystem = basaltEvent()
    local activeEvents = {}

    local parent
    
    local object = {
        init = function(self)
            if(initialized)then return false end
            initialized = true
            return true
        end,

        load = function(self)
        end,

        getType = function(self)
            return objectType
        end,
        isType = function(self, t)
            return objectType==t
        end,
        
        getName = function(self)
            return name
        end,

        getParent = function(self)
            return parent
        end,

        setParent = function(self, newParent, noRemove)
            if(noRemove)then parent = newParent return self end
            if (newParent.getType ~= nil and newParent:isType("Container")) then
                self:remove()
                newParent:addObject(self)
                if (self.show) then
                    self:show()
                end
                parent = newParent
            end
            return self
        end,

        updateEvents = function(self)
            for k,v in pairs(activeEvents)do
                parent:removeEvent(k, self)
                if(v)then
                    parent:addEvent(k, self)
                end
            end
            return self
        end,

        listenEvent = function(self, event, active)
            if(parent~=nil)then
                if(active)or(active==nil)then
                    activeEvents[event] = true
                    parent:addEvent(event, self)
                elseif(active==false)then
                    activeEvents[event] = false
                    parent:removeEvent(event, self)
                end
            end
            return self
        end,

        getZIndex = function(self)
            return 1
        end,

        enable = function(self)
            isEnabled = true
            return self
        end,

        disable = function(self)
            isEnabled = false
            return self
        end,

        isEnabled = function(self)
            return isEnabled
        end,

        remove = function(self)
            if (parent ~= nil) then
                parent:removeObject(self)
                parent:removeEvents(self)
            end
            self:updateDraw()
            return self
        end,

        getBaseFrame = function(self)
            if(parent~=nil)then
                return parent:getBaseFrame()
            end
            return self
        end,

        onEvent = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("other_event", v)
                end
            end
            return self
        end,

        getEventSystem = function(self)
            return eventSystem
        end,

        registerEvent = function(self, event, func)
            if(parent~=nil)then
                parent:addEvent(event, self)
            end
            return eventSystem:registerEvent(event, func)
        end,

        removeEvent = function(self, event, index)
            if(eventSystem:getEventCount(event)<1)then
                if(parent~=nil)then
                    parent:removeEvent(event, self)
                end
            end
            return eventSystem:removeEvent(event, index)
        end,

        eventHandler = function(self, event, ...)
            local val = self:sendEvent("other_event", event, ...)
            if(val~=nil)then return val end
        end,

        customEventHandler = function(self, event, ...)
            local val = self:sendEvent("custom_event", event, ...)
            if(val~=nil)then return val end
            return true
        end,

        sendEvent = function(self, event, ...)
            if(event=="other_event")or(event=="custom_event")then
                return eventSystem:sendEvent(event, self, ...)
            end
            return eventSystem:sendEvent(event, self, event, ...)
        end,

        onClick = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_click", v)
                end
            end
            return self
        end,

        onClickUp = function(self, ...)
                for _,v in pairs(table.pack(...))do
                    if(type(v)=="function")then
                        self:registerEvent("mouse_up", v)
                    end
                end
            return self
        end,

        onRelease = function(self, ...)
                for _,v in pairs(table.pack(...))do
                    if(type(v)=="function")then
                        self:registerEvent("mouse_release", v)
                    end
                end
            return self
        end,

        onScroll = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_scroll", v)
                end
            end
            return self
        end,

        onHover = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_hover", v)
                end
            end
            return self
        end,

        onLeave = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_leave", v)
                end
            end
            return self
        end,

        onDrag = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("mouse_drag", v)
                end
            end
            return self
        end,

        onKey = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("key", v)
                end
            end
            return self
        end,

        onChar = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("char", v)
                end
            end
            return self
        end,

        onKeyUp = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("key_up", v)
                end
            end
            return self
        end,
        }

    object.__index = object
    return object
end
end
project["objects"]["MonitorFrame"] = function(...)
local basaltMon = require("basaltMon")
local max,min,sub,rep = math.max,math.min,string.sub,string.rep


return function(name, basalt)
    local base = basalt.getObject("BaseFrame")(name, basalt)
    local objectType = "MonitorFrame"

    base:setTerm(nil)
    local isMonitorGroup = false
    local monGroup
    
    local object = {    

        getType = function()
            return objectType
        end,

        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        getBase = function(self)
            return base
        end,

        setMonitor = function(self, newMon)
            if(type(newMon)=="string")then
                local mon = peripheral.wrap(newMon)
                if(mon~=nil)then
                    self:setTerm(mon)
                end
            elseif(type(newMon)=="table")then
                self:setTerm(newMon)
            end
            return self
        end,

        setMonitorGroup = function(self, monGrp)
            monGroup = basaltMon(monGrp)
            self:setTerm(monGroup)
            isMonitorGroup = true
            return self
        end,

        render = function(self)
            if(self:getTerm()~=nil)then
                base.render(self)
            end
        end,
        
        show = function(self)
            base:getBase().show(self)
            basalt.setActiveFrame(self)
            for k,v in pairs(colors)do
                if(type(v)=="number")then
                    termObject.setPaletteColor(v, colors.packRGB(term.nativePaletteColor((v))))
                end
            end
            for k,v in pairs(colorTheme)do
                if(type(v)=="number")then
                    termObject.setPaletteColor(type(k)=="number" and k or colors[k], v)
                else
                    local r,g,b = table.unpack(v)
                    termObject.setPaletteColor(type(k)=="number" and k or colors[k], r,g,b)
                end
            end
            return self
        end,
    }

    object.mouseHandler = function(self, btn, x, y, isMon, monitor, ...)
        if(isMonitorGroup)then
            x, y = monGroup.calculateClick(monitor, x, y)
        end
        base.mouseHandler(self, btn, x, y, isMon, monitor, ...)
    end

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Pane"] = function(...)
return function(name, basalt)
    -- Pane
    local base = basalt.getObject("VisualObject")(name, basalt)
    local objectType = "Pane"

    base:setSize(25, 10)

    local object = {
        getType = function(self)
            return objectType
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Program"] = function(...)
local tHex = require("tHex")
local process = require("process")

local sub = string.sub

return function(name, basalt)
    local base = basalt.getObject("VisualObject")(name, basalt)
    local objectType = "Program"
    local object
    local cachedPath
    local enviroment = {}

    local function createBasaltWindow(x, y, width, height)
        local xCursor, yCursor = 1, 1
        local bgColor, fgColor = colors.black, colors.white
        local cursorBlink = false
        local visible = false

        local cacheT = {}
        local cacheBG = {}
        local cacheFG = {}

        local tPalette = {}

        local emptySpaceLine
        local emptyColorLines = {}

        for i = 0, 15 do
            local c = 2 ^ i
            tPalette[c] = { basalt.getTerm().getPaletteColour(c) }
        end

        local function createEmptyLines()
            emptySpaceLine = (" "):rep(width)
            for n = 0, 15 do
                local nColor = 2 ^ n
                local sHex = tHex[nColor]
                emptyColorLines[nColor] = sHex:rep(width)
            end
        end

        local function recreateWindowArray()
            createEmptyLines()
            local emptyText = emptySpaceLine
            local emptyFG = emptyColorLines[colors.white]
            local emptyBG = emptyColorLines[colors.black]
            for n = 1, height do
                cacheT[n] = sub(cacheT[n] == nil and emptyText or cacheT[n] .. emptyText:sub(1, width - cacheT[n]:len()), 1, width)
                cacheFG[n] = sub(cacheFG[n] == nil and emptyFG or cacheFG[n] .. emptyFG:sub(1, width - cacheFG[n]:len()), 1, width)
                cacheBG[n] = sub(cacheBG[n] == nil and emptyBG or cacheBG[n] .. emptyBG:sub(1, width - cacheBG[n]:len()), 1, width)
            end
            base.updateDraw(base)
        end
        recreateWindowArray()

        local function updateCursor()
            if xCursor >= 1 and yCursor >= 1 and xCursor <= width and yCursor <= height then
                --parentTerminal.setCursorPos(xCursor + x - 1, yCursor + y - 1)
            else
                --parentTerminal.setCursorPos(0, 0)
            end
            --parentTerminal.setTextColor(fgColor)
        end

        local function internalBlit(sText, sTextColor, sBackgroundColor)
            if yCursor < 1 or yCursor > height or xCursor < 1 or xCursor + #sText - 1 > width then
                return
            end
            cacheT[yCursor] = sub(cacheT[yCursor], 1, xCursor - 1) .. sText .. sub(cacheT[yCursor], xCursor + #sText, width)
            cacheFG[yCursor] = sub(cacheFG[yCursor], 1, xCursor - 1) .. sTextColor .. sub(cacheFG[yCursor], xCursor + #sText, width)
            cacheBG[yCursor] = sub(cacheBG[yCursor], 1, xCursor - 1) .. sBackgroundColor .. sub(cacheBG[yCursor], xCursor + #sText, width)
            xCursor = xCursor + #sText
            if visible then
                updateCursor()
            end
            object:updateDraw()
        end

        local function setText(_x, _y, text)
            if (text ~= nil) then
                local gText = cacheT[_y]
                if (gText ~= nil) then
                    cacheT[_y] = sub(gText:sub(1, _x - 1) .. text .. gText:sub(_x + (text:len()), width), 1, width)
                end
            end
            object:updateDraw()
        end

        local function setBG(_x, _y, colorStr)
            if (colorStr ~= nil) then
                local gBG = cacheBG[_y]
                if (gBG ~= nil) then
                    cacheBG[_y] = sub(gBG:sub(1, _x - 1) .. colorStr .. gBG:sub(_x + (colorStr:len()), width), 1, width)
                end
            end
            object:updateDraw()
        end

        local function setFG(_x, _y, colorStr)
            if (colorStr ~= nil) then
                local gFG = cacheFG[_y]
                if (gFG ~= nil) then
                    cacheFG[_y] = sub(gFG:sub(1, _x - 1) .. colorStr .. gFG:sub(_x + (colorStr:len()), width), 1, width)
                end
            end
            object:updateDraw()
        end

        local setTextColor = function(color)
            if type(color) ~= "number" then
                error("bad argument #1 (expected number, got " .. type(color) .. ")", 2)
            elseif tHex[color] == nil then
                error("Invalid color (got " .. color .. ")", 2)
            end
            fgColor = color
        end

        local setBackgroundColor = function(color)
            if type(color) ~= "number" then
                error("bad argument #1 (expected number, got " .. type(color) .. ")", 2)
            elseif tHex[color] == nil then
                error("Invalid color (got " .. color .. ")", 2)
            end
            bgColor = color
        end

        local setPaletteColor = function(colour, r, g, b)
            -- have to work on
            if type(colour) ~= "number" then
                error("bad argument #1 (expected number, got " .. type(colour) .. ")", 2)
            end

            if tHex[colour] == nil then
                error("Invalid color (got " .. colour .. ")", 2)
            end

            local tCol
            if type(r) == "number" and g == nil and b == nil then
                tCol = { colours.rgb8(r) }
                tPalette[colour] = tCol
            else
                if type(r) ~= "number" then
                    error("bad argument #2 (expected number, got " .. type(r) .. ")", 2)
                end
                if type(g) ~= "number" then
                    error("bad argument #3 (expected number, got " .. type(g) .. ")", 2)
                end
                if type(b) ~= "number" then
                    error("bad argument #4 (expected number, got " .. type(b) .. ")", 2)
                end

                tCol = tPalette[colour]
                tCol[1] = r
                tCol[2] = g
                tCol[3] = b
            end
        end

        local getPaletteColor = function(colour)
            if type(colour) ~= "number" then
                error("bad argument #1 (expected number, got " .. type(colour) .. ")", 2)
            end
            if tHex[colour] == nil then
                error("Invalid color (got " .. colour .. ")", 2)
            end
            local tCol = tPalette[colour]
            return tCol[1], tCol[2], tCol[3]
        end

        local basaltwindow = {
            setCursorPos = function(_x, _y)
                if type(_x) ~= "number" then
                    error("bad argument #1 (expected number, got " .. type(_x) .. ")", 2)
                end
                if type(_y) ~= "number" then
                    error("bad argument #2 (expected number, got " .. type(_y) .. ")", 2)
                end
                xCursor = math.floor(_x)
                yCursor = math.floor(_y)
                if (visible) then
                    updateCursor()
                end
            end,

            getCursorPos = function()
                return xCursor, yCursor
            end;

            setCursorBlink = function(blink)
                if type(blink) ~= "boolean" then
                    error("bad argument #1 (expected boolean, got " .. type(blink) .. ")", 2)
                end
                cursorBlink = blink
            end;

            getCursorBlink = function()
                return cursorBlink
            end;


            getPaletteColor = getPaletteColor,
            getPaletteColour = getPaletteColor,

            setBackgroundColor = setBackgroundColor,
            setBackgroundColour = setBackgroundColor,

            setTextColor = setTextColor,
            setTextColour = setTextColor,

            setPaletteColor = setPaletteColor,
            setPaletteColour = setPaletteColor,

            getBackgroundColor = function()
                return bgColor
            end;
            getBackgroundColour = function()
                return bgColor
            end;

            getSize = function()
                return width, height
            end;

            getTextColor = function()
                return fgColor
            end;
            getTextColour = function()
                return fgColor
            end;

            basalt_resize = function(_width, _height)
                width, height = _width, _height
                recreateWindowArray()
            end;

            basalt_reposition = function(_x, _y)
                x, y = _x, _y
            end;

            basalt_setVisible = function(vis)
                visible = vis
            end;

            drawBackgroundBox = function(_x, _y, _width, _height, bgCol)
                for n = 1, _height do
                    setBG(_x, _y + (n - 1), tHex[bgCol]:rep(_width))
                end
            end;
            drawForegroundBox = function(_x, _y, _width, _height, fgCol)
                for n = 1, _height do
                    setFG(_x, _y + (n - 1), tHex[fgCol]:rep(_width))
                end
            end;
            drawTextBox = function(_x, _y, _width, _height, symbol)
                for n = 1, _height do
                    setText(_x, _y + (n - 1), symbol:rep(_width))
                end
            end;

            basalt_update = function()
                for n = 1, height do
                    object:addBlit(1, n, cacheT[n], cacheFG[n], cacheBG[n])
                end
            end,

            scroll = function(offset)
                assert(type(offset) == "number", "bad argument #1 (expected number, got " .. type(offset) .. ")")
                if offset ~= 0 then
                  for newY = 1, height do
                    local y = newY + offset
                    if y < 1 or y > height then
                      cacheT[newY] = emptySpaceLine
                      cacheFG[newY] = emptyColorLines[fgColor]
                      cacheBG[newY] = emptyColorLines[bgColor]
                    else
                      cacheT[newY] = cacheT[y]
                      cacheBG[newY] = cacheBG[y]
                      cacheFG[newY] = cacheFG[y]
                    end
                  end
                end
                if (visible) then
                    updateCursor()
                end
            end,


            isColor = function()
                return basalt.getTerm().isColor()
            end;

            isColour = function()
                return basalt.getTerm().isColor()
            end;

            write = function(text)
                text = tostring(text)
                if (visible) then
                    internalBlit(text, tHex[fgColor]:rep(text:len()), tHex[bgColor]:rep(text:len()))
                end
            end;

            clearLine = function()
                if (visible) then
                    setText(1, yCursor, (" "):rep(width))
                    setBG(1, yCursor, tHex[bgColor]:rep(width))
                    setFG(1, yCursor, tHex[fgColor]:rep(width))
                end
                if (visible) then
                    updateCursor()
                end
            end;

            clear = function()
                for n = 1, height do
                    setText(1, n, (" "):rep(width))
                    setBG(1, n, tHex[bgColor]:rep(width))
                    setFG(1, n, tHex[fgColor]:rep(width))
                end
                if (visible) then
                    updateCursor()
                end
            end;

            blit = function(text, fgcol, bgcol)
                if type(text) ~= "string" then
                    error("bad argument #1 (expected string, got " .. type(text) .. ")", 2)
                end
                if type(fgcol) ~= "string" then
                    error("bad argument #2 (expected string, got " .. type(fgcol) .. ")", 2)
                end
                if type(bgcol) ~= "string" then
                    error("bad argument #3 (expected string, got " .. type(bgcol) .. ")", 2)
                end
                if #fgcol ~= #text or #bgcol ~= #text then
                    error("Arguments must be the same length", 2)
                end
                if (visible) then
                    internalBlit(text, fgcol, bgcol)
                end
            end


        }

        return basaltwindow
    end

    base:setZIndex(5)
    base:setSize(30, 12)
    local pWindow = createBasaltWindow(1, 1, 30, 12)
    local curProcess
    local paused = false
    local queuedEvent = {}

    local function updateCursor(self)
        local parent = self:getParent()
        local xCur, yCur = pWindow.getCursorPos()
        local obx, oby = self:getPosition()
        local w,h = self:getSize()
        if (obx + xCur - 1 >= 1 and obx + xCur - 1 <= obx + w - 1 and yCur + oby - 1 >= 1 and yCur + oby - 1 <= oby + h - 1) then
            parent:setCursor(self:isFocused() and pWindow.getCursorBlink(), obx + xCur - 1, yCur + oby - 1, pWindow.getTextColor())
        end
    end

    local function resumeProcess(self, event, ...)
        local ok, result = curProcess:resume(event, ...)
        if (ok==false)and(result~=nil)and(result~="Terminated")then
            local val = self:sendEvent("program_error", result)
            if(val~=false)then
                error("Basalt Program - "..result)
            end
        end
        
        if(curProcess:getStatus()=="dead")then
            self:sendEvent("program_done")
        end
    end

    local function mouseEvent(self, event, p1, x, y)
        if (curProcess == nil) then
            return false
        end
        if not (curProcess:isDead()) then
            if not (paused) then
                local absX, absY = self:getAbsolutePosition()
                resumeProcess(self, event, p1, x-absX+1, y-absY+1)
                updateCursor(self)
            end
        end
    end

    local function keyEvent(self, event, key, isHolding)
        if (curProcess == nil) then
            return false
        end
        if not (curProcess:isDead()) then
            if not (paused) then
                if (self.draw) then
                    resumeProcess(self, event, key, isHolding)
                    updateCursor(self)
                end
            end
        end
    end

    object = {
        getType = function(self)
            return objectType
        end;

        show = function(self)
            base.show(self)
            pWindow.setBackgroundColor(self:getBackground())
            pWindow.setTextColor(self:getForeground())
            pWindow.basalt_setVisible(true)
            return self
        end;

        hide = function(self)
            base.hide(self)
            pWindow.basalt_setVisible(false)
            return self
        end;

        setPosition = function(self, x, y, rel)
            base.setPosition(self, x, y, rel)
            pWindow.basalt_reposition(self:getPosition())
            return self
        end,

        getBasaltWindow = function()
            return pWindow
        end;

        getBasaltProcess = function()
            return curProcess
        end;

        setSize = function(self, width, height, rel)
            base.setSize(self, width, height, rel)
            pWindow.basalt_resize(self:getWidth(), self:getHeight())
            return self
        end;

        getStatus = function(self)
            if (curProcess ~= nil) then
                return curProcess:getStatus()
            end
            return "inactive"
        end;

        setEnviroment = function(self, env)
            enviroment = env or {}
            return self
        end,

        execute = function(self, path, ...)
            cachedPath = path or cachedPath
            curProcess = process:new(cachedPath, pWindow, enviroment, ...)
            pWindow.setBackgroundColor(colors.black)
            pWindow.setTextColor(colors.white)
            pWindow.clear()
            pWindow.setCursorPos(1, 1)
            pWindow.setBackgroundColor(self:getBackground())
            pWindow.setTextColor(self:getForeground() or colors.white)
            pWindow.basalt_setVisible(true)

            resumeProcess(self)
            paused = false
            self:listenEvent("mouse_click", self)
            self:listenEvent("mouse_up", self)
            self:listenEvent("mouse_drag", self)
            self:listenEvent("mouse_scroll", self)
            self:listenEvent("key", self)
            self:listenEvent("key_up", self)
            self:listenEvent("char", self)
            self:listenEvent("other_event", self)
            return self
        end;

        stop = function(self)            
            local parent = self:getParent()
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    resumeProcess(self, "terminate")
                    if (curProcess:isDead()) then
                        parent:setCursor(false)
                    end
                end
            end
            parent:removeEvents(self)
            return self
        end;

        pause = function(self, p)
            paused = p or (not paused)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    if not (paused) then
                        self:injectEvents(table.unpack(queuedEvent))
                        queuedEvent = {}
                    end
                end
            end
            return self
        end;

        isPaused = function(self)
            return paused
        end;

        injectEvent = function(self, event, ign, ...)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    if (paused == false) or (ign) then
                        resumeProcess(self, event, ...)
                    else
                        table.insert(queuedEvent, { event = event, args = {...} })
                    end
                end
            end
            return self
        end;

        getQueuedEvents = function(self)
            return queuedEvent
        end;

        updateQueuedEvents = function(self, events)
            queuedEvent = events or queuedEvent
            return self
        end;

        injectEvents = function(self, ...)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    for _, value in pairs({...}) do
                        resumeProcess(self, value.event, table.unpack(value.args))
                    end
                end
            end
            return self
        end;

        mouseHandler = function(self, button, x, y)
            if (base.mouseHandler(self, button, x, y)) then
                mouseEvent(self, "mouse_click", button, x, y)
                return true
            end
            return false
        end,

        mouseUpHandler = function(self, button, x, y)
            if (base.mouseUpHandler(self, button, x, y)) then
                mouseEvent(self, "mouse_up", button, x, y)
                return true
            end
            return false
        end,

        scrollHandler = function(self, dir, x, y)
            if (base.scrollHandler(self, dir, x, y)) then
                mouseEvent(self, "mouse_scroll", dir, x, y)
                return true
            end
            return false
        end,

        dragHandler = function(self, button, x, y)
            if (base.dragHandler(self, button, x, y)) then
                mouseEvent(self, "mouse_drag", button, x, y)
                return true
            end
            return false
        end,

        keyHandler = function(self, key, isHolding)
            if(base.keyHandler(self, key, isHolding))then
                keyEvent(self, "key", key, isHolding)
                return true
            end
            return false
        end,

        keyUpHandler = function(self, key)
            if(base.keyUpHandler(self, key))then
                keyEvent(self, "key_up", key)
                return true
            end
            return false
        end,

        charHandler = function(self, char)
            if(base.charHandler(self, char))then
                keyEvent(self, "char", char)
                return true
            end
            return false
        end,

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    if not (paused) then
                        local parent = self:getParent()
                        if (parent ~= nil) then
                            local xCur, yCur = pWindow.getCursorPos()
                            local obx, oby = self:getPosition()
                            local w,h = self:getSize()
                            if (obx + xCur - 1 >= 1 and obx + xCur - 1 <= obx + w - 1 and yCur + oby - 1 >= 1 and yCur + oby - 1 <= oby + h - 1) then
                                parent:setCursor(pWindow.getCursorBlink(), obx + xCur - 1, yCur + oby - 1, pWindow.getTextColor())
                            end
                        end
                    end
                end
            end
        end,

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    local parent = self:getParent()
                    if (parent ~= nil) then
                        parent:setCursor(false)
                    end
                end
            end
        end,

        eventHandler = function(self, event, ...)
            base.eventHandler(self, event, ...)
            if curProcess == nil then
                return
            end
            if not curProcess:isDead() then
                if not paused then
                    resumeProcess(self, event, ...)
                    if self:isFocused() then
                        local parent = self:getParent()
                        local obx, oby = self:getPosition()
                        local xCur, yCur = pWindow.getCursorPos()
                        local w,h = self:getSize()
                        if obx + xCur - 1 >= 1 and obx + xCur - 1 <= obx + w - 1 and yCur + oby - 1 >= 1 and yCur + oby - 1 <= oby + h - 1 then
                            parent:setCursor(pWindow.getCursorBlink(), obx + xCur - 1, yCur + oby - 1, pWindow.getTextColor())
                        end
                    end
                else
                    table.insert(queuedEvent, { event = event, args = { ... } })
                end
            end
        end,

        resizeHandler = function(self, ...)
            base.resizeHandler(self, ...)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    if not (paused) then
                        pWindow.basalt_resize(self:getSize())
                        resumeProcess(self, "term_resize", self:getSize())
                    else
                        pWindow.basalt_resize(self:getSize())
                        table.insert(queuedEvent, { event = "term_resize", args = { self:getSize() } })
                    end
                end
            end
        end,

        repositionHandler = function(self, ...)
            base.repositionHandler(self, ...)
            if (curProcess ~= nil) then
                if not (curProcess:isDead()) then
                    pWindow.basalt_reposition(self:getPosition())
                end
            end
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("program", function()
                local parent = self:getParent()
                local obx, oby = self:getPosition()
                local xCur, yCur = pWindow.getCursorPos()
                local w,h = self:getSize()
                pWindow.basalt_update()
            end)
        end,

        onError = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("program_error", v)
                end
            end
            local parent = self:getParent()
            self:listenEvent("other_event")
            return self
        end,

        onDone = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("program_done", v)
                end
            end
            local parent = self:getParent()
            self:listenEvent("other_event")
            return self
        end,

    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Switch"] = function(...)
return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Switch"

    base:setSize(4, 1)
    base:setValue(false)
    base:setZIndex(5)

    local bgSymbol = colors.black
    local inactiveBG = colors.red
    local activeBG = colors.green

    local object = {
        getType = function(self)
            return objectType
        end,

        setSymbol = function(self, col)
            bgSymbol = col
            return self
        end,

        setActiveBackground = function(self, col)
            activeBG = col
            return self
        end,

        setInactiveBackground = function(self, col)
            inactiveBG = col
            return self
        end,


        load = function(self)
            self:listenEvent("mouse_click")
        end,

        mouseHandler = function(self, ...)
            if (base.mouseHandler(self, ...)) then
                self:setValue(not self:getValue())
                self:updateDraw()
                return true
            end
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("switch", function()
                local parent = self:getParent()
                local bgCol,fgCol = self:getBackground(), self:getForeground()
                local w,h = self:getSize()
                if(self:getValue())then
                    self:addBackgroundBox(1, 1, w, h, activeBG)
                    self:addBackgroundBox(w, 1, 1, h, bgSymbol)
                else
                    self:addBackgroundBox(1, 1, w, h, inactiveBG)
                    self:addBackgroundBox(1, 1, 1, h, bgSymbol)
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Slider"] = function(...)
local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Slider"

    base:setSize(12, 1)
    base:setValue(1)
    base:setBackground(false, "\140", colors.black)

    local barType = "horizontal"
    local symbol = " "
    local symbolFG = colors.black
    local symbolBG = colors.gray
    local maxValue = 12
    local index = 1
    local symbolSize = 1

    local function mouseEvent(self, button, x, y)
    local obx, oby = self:getPosition()
    local w,h = self:getSize()
        local size = barType == "vertical" and h or w
        for i = 0, size do
            if ((barType == "vertical" and oby + i == y) or (barType == "horizontal" and obx + i == x)) and (obx <= x) and (obx + w > x) and (oby <= y) and (oby + h > y) then
                index = math.min(i + 1, size - (#symbol + symbolSize - 2))
                self:setValue(maxValue / size * index)
                self:updateDraw()
            end
        end
    end

    local object = {
        getType = function(self)
            return objectType
        end,

        load = function(self)
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_drag")
            self:listenEvent("mouse_scroll")
        end,

        setSymbol = function(self, _symbol)
            symbol = _symbol:sub(1, 1)
            self:updateDraw()
            return self
        end,

        setIndex = function(self, _index)
            index = _index
            if (index < 1) then
                index = 1
            end
            local w,h = self:getSize()
            index = math.min(index, (barType == "vertical" and h or w) - (symbolSize - 1))
            self:setValue(maxValue / (barType == "vertical" and h or w) * index)
            self:updateDraw()
            return self
        end,

        getIndex = function(self)
            return index
        end,

        setMaxValue = function(self, val)
            maxValue = val
            return self
        end,

        setSymbolColor = function(self, col)
            symbolColor = col
            self:updateDraw()
            return self
        end,

        setBarType = function(self, _typ)
            barType = _typ:lower()
            self:updateDraw()
            return self
        end,

        mouseHandler = function(self, button, x, y)
            if (base.mouseHandler(self, button, x, y)) then
                mouseEvent(self, button, x, y)
                return true
            end
            return false
        end,

        dragHandler = function(self, button, x, y)
            if (base.dragHandler(self, button, x, y)) then
                mouseEvent(self, button, x, y)
                return true
            end
            return false
        end,

        scrollHandler = function(self, dir, x, y)
            if(base.scrollHandler(self, dir, x, y))then
                local w,h = self:getSize()
                index = index + dir
                if (index < 1) then
                    index = 1
                end
                index = math.min(index, (barType == "vertical" and h or w) - (symbolSize - 1))
                self:setValue(maxValue / (barType == "vertical" and h or w) * index)
                self:updateDraw()
                return true
            end
            return false
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("slider", function()
                local w,h = self:getSize()
                local bgCol,fgCol = self:getBackground(), self:getForeground()
                if (barType == "horizontal") then
                    self:addText(index, oby, symbol:rep(symbolSize))
                    if(symbolBG~=false)then self:addBG(index, 1, tHex[symbolBG]:rep(#symbol*symbolSize)) end
                    if(symbolFG~=false)then self:addFG(index, 1, tHex[symbolFG]:rep(#symbol*symbolSize)) end
                end

                if (barType == "vertical") then
                    for n = 0, h - 1 do
                        if (index == n + 1) then
                            for curIndexOffset = 0, math.min(symbolSize - 1, h) do
                                self:addBlit(1, 1+n+curIndexOffset, symbol, tHex[symbolColor], tHex[symbolColor])
                            end
                        else
                            if (n + 1 < index) or (n + 1 > index - 1 + symbolSize) then
                                self:addBlit(1, 1+n, bgSymbol, tHex[fgCol], tHex[bgCol])
                            end
                        end
                    end
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["MovableFrame"] = function(...)
local max,min,sub,rep = math.max,math.min,string.sub,string.rep

return function(name, basalt)
    local base = basalt.getObject("Frame")(name, basalt)
    local objectType = "MovableFrame"
    local parent

    local dragXOffset, dragYOffset, isDragging = 0, 0, false

    local dragMap = {
        {x1 = 1, x2 = "width", y1 = 1, y2 = 1}
    }

    local object = {    
        getType = function()
            return objectType
        end,

        setDraggingMap = function(self, t)
            dragMap = t
            return self
        end,

        getDraggingMap = function(self)
            return dragMap
        end,

        isType = function(self, t)
            return objectType==t or (base.isType~=nil and base.isType(t)) or false
        end,

        getBase = function(self)
            return base
        end, 
        
        load = function(self)
            base.load(self)
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_up")
            self:listenEvent("mouse_drag")
        end,

        dragHandler = function(self, btn, x, y)
            if(base.dragHandler(self, btn, x, y))then
                if (isDragging) then
                    local xO, yO = parent:getOffset()
                    xO = xO < 0 and math.abs(xO) or -xO
                    yO = yO < 0 and math.abs(yO) or -yO
                    local parentX = 1
                    local parentY = 1
                    parentX, parentY = parent:getAbsolutePosition()
                    self:setPosition(x + dragXOffset - (parentX - 1) + xO, y + dragYOffset - (parentY - 1) + yO)
                    self:updateDraw()
                end
                return true
            end
        end,

        mouseHandler = function(self, btn, x, y, ...)
            if(base.mouseHandler(self, btn, x, y, ...))then
                parent:setImportant(self)
                local fx, fy = self:getAbsolutePosition()
                local w, h = self:getSize()
                for k,v in pairs(dragMap)do
                    local x1, x2 = v.x1=="width" and w or v.x1, v.x2=="width" and w or v.x2
                    local y1, y2= v.y1=="height" and h or v.y1, v.y2=="height" and h or v.y2
                    if(x>=fx+x1-1)and(x<=fx+x2-1)and(y>=fy+y1-1)and(y<=fy+y2-1)then
                        isDragging = true
                        dragXOffset = fx - x
                        dragYOffset = fy - y
                        return true
                    end
                end
                return true
            end
        end,

        mouseUpHandler = function(self, ...)
            isDragging = false
            return base.mouseUpHandler(self, ...)
        end,

        setParent = function(self, p, ...)
            base.setParent(self, p, ...)
            parent = p
            return self
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Progressbar"] = function(...)
return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Progressbar"

    local progress = 0

    base:setZIndex(5)
    base:setValue(false)
    base:setSize(25, 3)

    local activeBarColor = colors.black
    local activeBarSymbol = ""
    local activeBarSymbolCol = colors.white
    local bgBarSymbol = ""
    local direction = 0

    local object = {
        getType = function(self)
            return objectType
        end,

        setDirection = function(self, dir)
            direction = dir
            self:updateDraw()
            return self
        end,

        setProgressBar = function(self, color, symbol, symbolcolor)
            activeBarColor = color or activeBarColor
            activeBarSymbol = symbol or activeBarSymbol
            activeBarSymbolCol = symbolcolor or activeBarSymbolCol
            self:updateDraw()
            return self
        end,

        getProgressBar = function(self)
            return activeBarColor, activeBarSymbol, activeBarSymbolCol
        end,

        setBackgroundSymbol = function(self, symbol)
            bgBarSymbol = symbol:sub(1, 1)
            self:updateDraw()
            return self
        end,

        setProgress = function(self, value)
            if (value >= 0) and (value <= 100) and (progress ~= value) then
                progress = value
                self:setValue(progress)
                if (progress == 100) then
                    self:progressDoneHandler()
                end
            end
            self:updateDraw()
            return self
        end,

        getProgress = function(self)
            return progress
        end,

        onProgressDone = function(self, f)
            self:registerEvent("progress_done", f)
            return self
        end,

        progressDoneHandler = function(self)
            self:sendEvent("progress_done")
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("progressbar", function()
                local obx, oby = self:getPosition()
                local w,h = self:getSize()
                local bgCol,fgCol = self:getBackground(), self:getForeground()
                if(bgCol~=false)then self:addBackgroundBox(1, 1, w, h, bgCol) end
                if(bgBarSymbol~="")then self:addTextBox(1, 1, w, h, bgBarSymbol) end
                if(fgCol~=false)then self:addForegroundBox(1, 1, w, h, fgCol) end
                if (direction == 1) then
                    self:addBackgroundBox(1, 1, w, h / 100 * progress, activeBarColor)
                    self:addForegroundBox(1, 1, w, h / 100 * progress, activeBarSymbolCol)
                    self:addTextBox(1, 1, w, h / 100 * progress, activeBarSymbol)
                elseif (direction == 3) then
                    self:addBackgroundBox(1, 1 + math.ceil(h - h / 100 * progress), w, h / 100 * progress, activeBarColor)
                    self:addForegroundBox(1, 1 + math.ceil(h - h / 100 * progress), w, h / 100 * progress, activeBarSymbolCol)
                    self:addTextBox(1, 1 + math.ceil(h - h / 100 * progress), w, h / 100 * progress, activeBarSymbol)
                elseif (direction == 2) then
                    self:addBackgroundBox(1 + math.ceil(w - w / 100 * progress), 1, w / 100 * progress, h, activeBarColor)
                    self:addForegroundBox(1 + math.ceil(w - w / 100 * progress), 1, w / 100 * progress, h, activeBarSymbolCol)
                    self:addTextBox(1 + math.ceil(w - w / 100 * progress), 1, w / 100 * progress, h, activeBarSymbol)
                else
                    self:addBackgroundBox(1, 1, math.ceil( w / 100 * progress), h, activeBarColor)
                    self:addForegroundBox(1, 1, math.ceil(w / 100 * progress), h, activeBarSymbolCol)
                    self:addTextBox(1, 1, math.ceil(w / 100 * progress), h, activeBarSymbol)
                end
            end)
        end,

    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Thread"] = function(...)
return function(name, basalt)
    local base = basalt.getObject("Object")(name, basalt)

    local objectType = "Thread"

    local func
    local cRoutine
    local isActive = false
    local filter

    local object = {
        getType = function(self)
            return objectType
        end,

        start = function(self, f)
            if (f == nil) then
                error("Function provided to thread is nil")
            end
            func = f
            cRoutine = coroutine.create(func)
            isActive = true
            filter=nil
            local ok, result = coroutine.resume(cRoutine)
            filter = result
            if not (ok) then
                if (result ~= "Terminated") then
                    error("Thread Error Occurred - " .. result)
                end
            end
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_up")
            self:listenEvent("mouse_scroll")
            self:listenEvent("mouse_drag")
            self:listenEvent("key")
            self:listenEvent("key_up")
            self:listenEvent("char")
            self:listenEvent("other_event")
            return self
        end,

        getStatus = function(self, f)
            if (cRoutine ~= nil) then
                return coroutine.status(cRoutine)
            end
            return nil
        end,

        stop = function(self, f)
            isActive = false
            self:listenEvent("mouse_click", false)
            self:listenEvent("mouse_up", false)
            self:listenEvent("mouse_scroll", false)
            self:listenEvent("mouse_drag", false)
            self:listenEvent("key", false)
            self:listenEvent("key_up", false)
            self:listenEvent("char", false)
            self:listenEvent("other_event", false)
            return self
        end,

        mouseHandler = function(self, ...)
            self:eventHandler("mouse_click", ...)
        end,
        mouseUpHandler = function(self, ...)
            self:eventHandler("mouse_up", ...)
        end,
        mouseScrollHandler = function(self, ...)
            self:eventHandler("mouse_scroll", ...)
        end,
        mouseDragHandler = function(self, ...)
            self:eventHandler("mouse_drag", ...)
        end,
        mouseMoveHandler = function(self, ...)
            self:eventHandler("mouse_move", ...)
        end,
        keyHandler = function(self, ...)
            self:eventHandler("key", ...)
        end,
        keyUpHandler = function(self, ...)
            self:eventHandler("key_up", ...)
        end,
        charHandler = function(self, ...)
            self:eventHandler("char", ...)
        end,

        eventHandler = function(self, event, ...)
            base.eventHandler(self, event, ...)
            if (isActive) then
                if (coroutine.status(cRoutine) == "suspended") then
                    if(filter~=nil)then
                        if(event~=filter)then return end
                        filter=nil
                    end
                    local ok, result = coroutine.resume(cRoutine, event, ...)
                    filter = result
                    if not (ok) then
                        if (result ~= "Terminated") then
                            error("Thread Error Occurred - " .. result)
                        end
                    end
                else
                    self:stop()
                end
            end
        end,

    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Radio"] = function(...)
local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("List")(name, basalt)
    local objectType = "Radio"

    base:setSize(1, 1)
    base:setZIndex(5)

    local list = {}
    local boxSelectedBG = colors.black
    local boxSelectedFG = colors.green
    local boxNotSelectedBG = colors.black
    local boxNotSelectedFG = colors.red
    local selectionColorActive = true
    local symbol = "\7"
    local align = "left"

    local object = {
        getType = function(self)
            return objectType
        end,

        addItem = function(self, text, x, y, bgCol, fgCol, ...)
            base.addItem(self, text, bgCol, fgCol, ...)
            table.insert(list, { x = x or 1, y = y or #list * 2 })
            return self
        end,

        removeItem = function(self, index)
            base.removeItem(self, index)
            table.remove(list, index)
            return self
        end,

        clear = function(self)
            base.clear(self)
            list = {}
            return self
        end,

        editItem = function(self, index, text, x, y, bgCol, fgCol, ...)
            base.editItem(self, index, text, bgCol, fgCol, ...)
            table.remove(list, index)
            table.insert(list, index, { x = x or 1, y = y or 1 })
            return self
        end,

        setBoxSelectionColor = function(self, bg, fg)
            boxSelectedBG = bg
            boxSelectedFG = fg
            return self
        end,

        getBoxSelectionColor = function(self)
            return boxSelectedBG, boxSelectedFG
        end,

        setBoxDefaultColor = function(self, bg, fg)
            boxNotSelectedBG = bg
            boxNotSelectedFG = fg
            return self
        end,

        getBoxDefaultColor = function(self)
            return boxNotSelectedBG, boxNotSelectedFG
        end,

        mouseHandler = function(self, button, x, y, ...)
            if (#list > 0) then
                local obx, oby = self:getAbsolutePosition()
                local baseList = self:getAll()
                for k, value in pairs(baseList) do
                    if (obx + list[k].x - 1 <= x) and (obx + list[k].x - 1 + value.text:len() + 1 >= x) and (oby + list[k].y - 1 == y) then
                        self:setValue(value)
                        local val = self:sendEvent("mouse_click", self, "mouse_click", button, x, y, ...)
                        self:updateDraw()
                        if(val==false)then return val end
                        return true
                    end
                end
            end
        end,

        draw = function(self)
            self:addDraw("radio", function()
                local itemSelectedBG, itemSelectedFG = self:getSelectionColor()
                local baseList = self:getAll()
                for k, value in pairs(baseList) do
                    if (value == self:getValue()) then
                        self:addBlit(list[k].x, list[k].y, symbol, tHex[boxSelectedFG], tHex[boxSelectedBG])
                        self:addBlit(list[k].x + 2, list[k].y, value.text, tHex[itemSelectedFG]:rep(#value.text), tHex[itemSelectedBG]:rep(#value.text))
                    else
                        self:addBackgroundBox(list[k].x, list[k].y, 1, 1, boxNotSelectedBG or colors.black)
                        self:addBlit(list[k].x + 2, list[k].y, value.text, tHex[value.fgCol]:rep(#value.text), tHex[value.bgCol]:rep(#value.text))
                    end
                end
                return true
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Scrollbar"] = function(...)
local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("VisualObject")(name, basalt)
    local objectType = "Scrollbar"

    base:setZIndex(2)
    base:setSize(1, 8)
    base:setBackground(colors.lightGray, "\127", colors.gray)

    local barType = "vertical"
    local symbol = " "
    local symbolBG = colors.black
    local symbolFG = colors.black
    local scrollAmount = 3
    local index = 1
    local symbolSize = 1
    local symbolAutoSize = true

    local function updateSymbolSize()
        local w,h = base:getSize()
        if(symbolAutoSize)then
            symbolSize = math.max((barType == "vertical" and h or w-(#symbol)) - (scrollAmount-1), 1)
        end
    end
    updateSymbolSize()

    local function mouseEvent(self, button, x, y)
    local obx, oby = self:getAbsolutePosition()
    local w,h = self:getSize()
        updateSymbolSize()
        local size = barType == "vertical" and h or w
        for i = 0, size do
            if ((barType == "vertical" and oby + i == y) or (barType == "horizontal" and obx + i == x)) and (obx <= x) and (obx + w > x) and (oby <= y) and (oby + h > y) then
                index = math.min(i + 1, size - (#symbol + symbolSize - 2))
                self:scrollbarMoveHandler()
                self:updateDraw()
            end
        end
    end

    local object = {
        getType = function(self)
            return objectType
        end,

        load = function(self)
            base.load(self)
            local parent = self:getParent()
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_up")
            self:listenEvent("mouse_scroll")
            self:listenEvent("mouse_drag")
        end,

        setSymbol = function(self, _symbol, bg, fg)
            symbol = _symbol:sub(1,1)
            symbolBG = bg or symbolBG
            symbolFG = fg or symbolFG
            updateSymbolSize()
            self:updateDraw()
            return self
        end,

        setIndex = function(self, _index)
            index = _index
            if (index < 1) then
                index = 1
            end
            local w,h = self:getSize()
            --index = math.min(index, (barType == "vertical" and h or w) - (symbolSize - 1))
            updateSymbolSize()
            self:updateDraw()
            return self
        end,

        setScrollAmount = function(self, amount)
            scrollAmount = amount
            updateSymbolSize()
            self:updateDraw()
            return self
        end,

        getIndex = function(self)
            local w,h = self:getSize()
            return scrollAmount > (barType=="vertical" and h or w) and math.floor(scrollAmount/(barType=="vertical" and h or w) * index) or index
        end,

        setSymbolSize = function(self, size)
            symbolSize = tonumber(size) or 1
            symbolAutoSize = size~=false and false or true
            updateSymbolSize()
            self:updateDraw()
            return self
        end,

        setBarType = function(self, _typ)
            barType = _typ:lower()
            updateSymbolSize()
            self:updateDraw()
            return self
        end,

        mouseHandler = function(self, button, x, y, ...)
            if (base.mouseHandler(self, button, x, y, ...)) then
                mouseEvent(self, button, x, y)
                return true
            end
            return false
        end,

        dragHandler = function(self, button, x, y)
            if (base.dragHandler(self, button, x, y)) then
                mouseEvent(self, button, x, y)
                return true
            end
            return false
        end,

        setSize = function(self, ...)
            base.setSize(self, ...)
            updateSymbolSize()
            return self
        end,

        scrollHandler = function(self, dir, x, y)
            if(base.scrollHandler(self, dir, x, y))then
                local w,h = self:getSize()
                updateSymbolSize()
                index = index + dir
                if (index < 1) then
                    index = 1
                end
                index = math.min(index, (barType == "vertical" and h or w) - (barType == "vertical" and symbolSize - 1 or #symbol+symbolSize-2))
                self:scrollbarMoveHandler()
                self:updateDraw()
            end
        end,

        onChange = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("scrollbar_moved", v)
                end
            end
            return self
        end,


        scrollbarMoveHandler = function(self)
            self:sendEvent("scrollbar_moved", self:getIndex())
        end,

        customEventHandler = function(self, event, ...)
            base.customEventHandler(self, event, ...)
            if(event=="basalt_FrameResize")then
                updateSymbolSize()
            end 
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("scrollbar", function()
                local parent = self:getParent()
                local w,h = self:getSize()
                local bgCol,fgCol = self:getBackground(), self:getForeground()
                if (barType == "horizontal") then
                    for n = 0, h - 1 do
                        self:addBlit(index, 1 + n, symbol:rep(symbolSize), tHex[symbolFG]:rep(#symbol*symbolSize), tHex[symbolBG]:rep(#symbol*symbolSize))
                    end
                elseif (barType == "vertical") then
                    for n = 0, h - 1 do
                        if (index == n + 1) then
                            for curIndexOffset = 0, math.min(symbolSize - 1, h) do
                                self:addBlit(1, index + curIndexOffset, symbol:rep(math.max(#symbol, w)), tHex[symbolFG]:rep(math.max(#symbol, w)), tHex[symbolBG]:rep(math.max(#symbol, w)))
                            end
                        end
                    end
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Timer"] = function(...)
return function(name, basalt)
    local base = basalt.getObject("Object")(name, basalt)
    local objectType = "Timer"

    local timer = 0
    local savedRepeats = 0
    local repeats = 0
    local timerObj
    local timerIsActive = false

    local object = {
        getType = function(self)
            return objectType
        end,

        setTime = function(self, _timer, _repeats)
            timer = _timer or 0
            savedRepeats = _repeats or 1
            return self
        end,

        start = function(self)
            if(timerIsActive)then
                os.cancelTimer(timerObj)
            end
            repeats = savedRepeats
            timerObj = os.startTimer(timer)
            timerIsActive = true
            self:listenEvent("other_event")
            return self
        end,

        isActive = function(self)
            return timerIsActive
        end,

        cancel = function(self)
            if (timerObj ~= nil) then
                os.cancelTimer(timerObj)
            end
            timerIsActive = false
            self:removeEvent("other_event")
            return self
        end,

        onCall = function(self, func)
            self:registerEvent("timed_event", func)
            return self
        end,

        eventHandler = function(self, event, ...)
            base.eventHandler(self, event, ...)
            if event == "timer" and tObj == timerObj and timerIsActive then
                self:sendEvent("timed_event")
                if (repeats >= 1) then
                    repeats = repeats - 1
                    if (repeats >= 1) then
                        timerObj = os.startTimer(timer)
                    end
                elseif (repeats == -1) then
                    timerObj = os.startTimer(timer)
                end
            end
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Textfield"] = function(...)
local tHex = require("tHex")

local rep,find,gmatch,sub,len = string.rep,string.find,string.gmatch,string.sub,string.len

return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Textfield"
    local hIndex, wIndex, textX, textY = 1, 1, 1, 1

    local lines = { "" }
    local bgLines = { "" }
    local fgLines = { "" }
    local keyWords = { }
    local rules = { }

    local startSelX,endSelX,startSelY,endSelY

    local selectionBG,selectionFG = colors.lightBlue,colors.black

    base:setSize(30, 12)
    base:setZIndex(5)

    local function isSelected()
        if(startSelX~=nil)and(endSelX~=nil)and(startSelY~=nil)and(endSelY~=nil)then
            return true
        end
        return false
    end

    local function getSelectionCoordinates()
        local sx, ex, sy, ey = startSelX, endSelX, startSelY, endSelY
        if isSelected() then
            if startSelX < endSelX and startSelY <= endSelY then
                sx = startSelX
                ex = endSelX
                if startSelY < endSelY then
                    sy = startSelY
                    ey = endSelY
                else
                    sy = endSelY
                    ey = startSelY
                end
            elseif startSelX > endSelX and startSelY >= endSelY then
                sx = endSelX
                ex = startSelX
                if startSelY > endSelY then
                    sy = endSelY
                    ey = startSelY
                else
                    sy = startSelY
                    ey = endSelY
                end
            elseif startSelY > endSelY then
                sx = endSelX
                ex = startSelX
                sy = endSelY
                ey = startSelY
            end
            return sx, ex, sy, ey
        end
    end

    local function removeSelection(self)
        local sx, ex, sy, ey = getSelectionCoordinates(self)
        local startLine = lines[sy]
        local endLine = lines[ey]
        lines[sy] = startLine:sub(1, sx - 1) .. endLine:sub(ex + 1, endLine:len())
        bgLines[sy] = bgLines[sy]:sub(1, sx - 1) .. bgLines[ey]:sub(ex + 1, bgLines[ey]:len())
        fgLines[sy] = fgLines[sy]:sub(1, sx - 1) .. fgLines[ey]:sub(ex + 1, fgLines[ey]:len())
    
        for i = ey, sy + 1, -1 do
            if i ~= sy then
                table.remove(lines, i)
                table.remove(bgLines, i)
                table.remove(fgLines, i)
            end
        end
    
        textX, textY = sx, sy
        startSelX, endSelX, startSelY, endSelY = nil, nil, nil, nil
        return self
    end

    local function stringGetPositions(str, word)
        local pos = {}
        if(str:len()>0)then
            for w in gmatch(str, word)do
                local s, e = find(str, w)
                if(s~=nil)and(e~=nil)then
                    table.insert(pos,s)
                    table.insert(pos,e)
                    local startL = sub(str, 1, (s-1))
                    local endL = sub(str, e+1, str:len())
                    str = startL..(":"):rep(w:len())..endL
                end
            end
        end
        return pos
    end

    local function updateColors(self, l)
        l = l or textY
        local fgLine = tHex[self:getForeground()]:rep(fgLines[l]:len())
        local bgLine = tHex[self:getBackground()]:rep(bgLines[l]:len())
        for k,v in pairs(rules)do
            local pos = stringGetPositions(lines[l], v[1])
            if(#pos>0)then
                for x=1,#pos/2 do
                    local xP = x*2 - 1
                    if(v[2]~=nil)then
                        fgLine = fgLine:sub(1, pos[xP]-1)..tHex[v[2]]:rep(pos[xP+1]-(pos[xP]-1))..fgLine:sub(pos[xP+1]+1, fgLine:len())
                    end
                    if(v[3]~=nil)then
                        bgLine = bgLine:sub(1, pos[xP]-1)..tHex[v[3]]:rep(pos[xP+1]-(pos[xP]-1))..bgLine:sub(pos[xP+1]+1, bgLine:len())
                    end
                end
            end
        end
        for k,v in pairs(keyWords)do
            for _,b in pairs(v)do
                local pos = stringGetPositions(lines[l], b)
                if(#pos>0)then
                    for x=1,#pos/2 do
                        local xP = x*2 - 1
                        fgLine = fgLine:sub(1, pos[xP]-1)..tHex[k]:rep(pos[xP+1]-(pos[xP]-1))..fgLine:sub(pos[xP+1]+1, fgLine:len())
                    end
                end
            end
        end
        fgLines[l] = fgLine
        bgLines[l] = bgLine
        self:updateDraw()
    end

    local function updateAllColors(self)
        for n=1,#lines do
            updateColors(self, n)
        end
    end

    local object = {
        getType = function(self)
            return objectType
        end;

        setBackground = function(self, bg)
            base.setBackground(self, bg)
            updateAllColors(self)
            return self
        end,

        setForeground = function(self, fg)
            base.setForeground(self, fg)
            updateAllColors(self)
            return self
        end,

        setSelection = function(self, fg, bg)
            selectionFG = fg or selectionFG
            selectionBG = bg or selectionBG
            return self
        end,

        getSelection = function(self)
            return selectionFG, selectionBG
        end,

        getLines = function(self)
            return lines
        end,

        getLine = function(self, index)
            return lines[index]
        end,

        editLine = function(self, index, text)
            lines[index] = text or lines[index]
            updateColors(self, index)
            self:updateDraw()
            return self
        end,

        clear = function(self)
            lines = {""}
            bgLines = {""}
            fgLines = {""}
            startSelX,endSelX,startSelY,endSelY = nil,nil,nil,nil
            hIndex, wIndex, textX, textY = 1, 1, 1, 1
            self:updateDraw()
            return self
        end,

        addLine = function(self, text, index)
            if(text~=nil)then
                local bgColor = self:getBackground()
                local fgColor = self:getForeground()
                if(#lines==1)and(lines[1]=="")then
                    lines[1] = text
                    bgLines[1] = tHex[bgColor]:rep(text:len())
                    fgLines[1] = tHex[fgColor]:rep(text:len())
                    updateColors(self, 1)
                    return self
                end
                if (index ~= nil) then
                    table.insert(lines, index, text)
                    table.insert(bgLines, index, tHex[bgColor]:rep(text:len()))
                    table.insert(fgLines, index, tHex[fgColor]:rep(text:len()))
                else
                    table.insert(lines, text)
                    table.insert(bgLines, tHex[bgColor]:rep(text:len()))
                    table.insert(fgLines, tHex[fgColor]:rep(text:len()))
                end
            end
            updateColors(self, index or #lines)
            self:updateDraw()
            return self
        end;

        addKeywords = function(self, color, tab)
            if(keyWords[color]==nil)then
                keyWords[color] = {}
            end
            for k,v in pairs(tab)do
                table.insert(keyWords[color], v)
            end
            self:updateDraw()
            return self
        end;

        addRule = function(self, rule, fg, bg)
            table.insert(rules, {rule, fg, bg})
            self:updateDraw()
            return self
        end;

        editRule = function(self, rule, fg, bg)
            for k,v in pairs(rules)do
                if(v[1]==rule)then
                    rules[k][2] = fg
                    rules[k][3] = bg
                end
            end
            self:updateDraw()
            return self
        end;

        removeRule = function(self, rule)
            for k,v in pairs(rules)do
                if(v[1]==rule)then
                    table.remove(rules, k)
                end
            end
            self:updateDraw()
            return self
        end,

        setKeywords = function(self, color, tab)
            keyWords[color] = tab
            self:updateDraw()
            return self
        end,

        removeLine = function(self, index)
            if(#lines>1)then
                table.remove(lines, index or #lines)
                table.remove(bgLines, index or #bgLines)
                table.remove(fgLines, index or #fgLines)
            else
                lines = {""}
                bgLines = {""}
                fgLines = {""}
            end
            self:updateDraw()
            return self
        end,

        getTextCursor = function(self)
            return textX, textY
        end,

        getOffset = function(self)
            return wIndex, hIndex
        end,

        setOffset = function(self, xOff, yOff)
            wIndex = xOff or wIndex
            hIndex = yOff or hIndex
            self:updateDraw()
            return self
        end,

        getFocusHandler = function(self)
            base.getFocusHandler(self)
            local obx, oby = self:getPosition()
            self:getParent():setCursor(true, obx + textX - wIndex, oby + textY - hIndex, self:getForeground())
        end,

        loseFocusHandler = function(self)
            base.loseFocusHandler(self)
            self:getParent():setCursor(false)
        end,

        keyHandler = function(self, key)
            if (base.keyHandler(self, event, key)) then
                local parent = self:getParent()
                local obx, oby = self:getPosition()
                local w,h = self:getSize()
                    if (key == keys.backspace) then
                        -- on backspace
                        if(isSelected())then
                            removeSelection(self)
                        else
                            if (lines[textY] == "") then
                                if (textY > 1) then
                                    table.remove(lines, textY)
                                    table.remove(fgLines, textY)
                                    table.remove(bgLines, textY)
                                    textX = lines[textY - 1]:len() + 1
                                    wIndex = textX - w + 1
                                    if (wIndex < 1) then
                                        wIndex = 1
                                    end
                                    textY = textY - 1
                                end
                            elseif (textX <= 1) then
                                if (textY > 1) then
                                    textX = lines[textY - 1]:len() + 1
                                    wIndex = textX - w + 1
                                    if (wIndex < 1) then
                                        wIndex = 1
                                    end
                                    lines[textY - 1] = lines[textY - 1] .. lines[textY]
                                    fgLines[textY - 1] = fgLines[textY - 1] .. fgLines[textY]
                                    bgLines[textY - 1] = bgLines[textY - 1] .. bgLines[textY]
                                    table.remove(lines, textY)
                                    table.remove(fgLines, textY)
                                    table.remove(bgLines, textY)
                                    textY = textY - 1
                                end
                            else
                                lines[textY] = lines[textY]:sub(1, textX - 2) .. lines[textY]:sub(textX, lines[textY]:len())
                                fgLines[textY] = fgLines[textY]:sub(1, textX - 2) .. fgLines[textY]:sub(textX, fgLines[textY]:len())
                                bgLines[textY] = bgLines[textY]:sub(1, textX - 2) .. bgLines[textY]:sub(textX, bgLines[textY]:len())
                                if (textX > 1) then
                                    textX = textX - 1
                                end
                                if (wIndex > 1) then
                                    if (textX < wIndex) then
                                        wIndex = wIndex - 1
                                    end
                                end
                            end
                            if (textY < hIndex) then
                                hIndex = hIndex - 1
                            end
                        end
                        updateColors(self)
                        self:setValue("")
                    elseif (key == keys.delete) then
                        -- on delete
                        if(isSelected())then
                            removeSelection(self)
                        else
                            if (textX > lines[textY]:len()) then
                                if (lines[textY + 1] ~= nil) then
                                    lines[textY] = lines[textY] .. lines[textY + 1]
                                    table.remove(lines, textY + 1)
                                    table.remove(bgLines, textY + 1)
                                    table.remove(fgLines, textY + 1)
                                end
                            else
                                lines[textY] = lines[textY]:sub(1, textX - 1) .. lines[textY]:sub(textX + 1, lines[textY]:len())
                                fgLines[textY] = fgLines[textY]:sub(1, textX - 1) .. fgLines[textY]:sub(textX + 1, fgLines[textY]:len())
                                bgLines[textY] = bgLines[textY]:sub(1, textX - 1) .. bgLines[textY]:sub(textX + 1, bgLines[textY]:len())
                            end
                        end
                        updateColors(self)
                    elseif (key == keys.enter) then
                        if(isSelected())then
                            removeSelection(self)
                        end
                        -- on enter
                        table.insert(lines, textY + 1, lines[textY]:sub(textX, lines[textY]:len()))
                        table.insert(fgLines, textY + 1, fgLines[textY]:sub(textX, fgLines[textY]:len()))
                        table.insert(bgLines, textY + 1, bgLines[textY]:sub(textX, bgLines[textY]:len()))
                        lines[textY] = lines[textY]:sub(1, textX - 1)
                        fgLines[textY] = fgLines[textY]:sub(1, textX - 1)
                        bgLines[textY] = bgLines[textY]:sub(1, textX - 1)
                        textY = textY + 1
                        textX = 1
                        wIndex = 1
                        if (textY - hIndex >= h) then
                            hIndex = hIndex + 1
                        end
                        self:setValue("")
                    elseif (key == keys.up) then
                        startSelX, startSelY, endSelX, endSelY = nil, nil, nil, nil
                        -- arrow up
                        if (textY > 1) then
                            textY = textY - 1
                            if (textX > lines[textY]:len() + 1) then
                                textX = lines[textY]:len() + 1
                            end
                            if (wIndex > 1) then
                                if (textX < wIndex) then
                                    wIndex = textX - w + 1
                                    if (wIndex < 1) then
                                        wIndex = 1
                                    end
                                end
                            end
                            if (hIndex > 1) then
                                if (textY < hIndex) then
                                    hIndex = hIndex - 1
                                end
                            end
                        end
                    elseif (key == keys.down) then
                        startSelX, startSelY, endSelX, endSelY = nil, nil, nil, nil
                        -- arrow down
                        if (textY < #lines) then
                            textY = textY + 1
                            if (textX > lines[textY]:len() + 1) then
                                textX = lines[textY]:len() + 1
                            end
                            if (wIndex > 1) then
                                if (textX < wIndex) then
                                    wIndex = textX - w + 1
                                    if (wIndex < 1) then
                                        wIndex = 1
                                    end
                                end
                            end
                            if (textY >= hIndex + h) then
                                hIndex = hIndex + 1
                            end
                        end
                    elseif (key == keys.right) then
                        startSelX, startSelY, endSelX, endSelY = nil, nil, nil, nil
                        -- arrow right
                        textX = textX + 1
                        if (textY < #lines) then
                            if (textX > lines[textY]:len() + 1) then
                                textX = 1
                                textY = textY + 1
                            end
                        elseif (textX > lines[textY]:len()) then
                            textX = lines[textY]:len() + 1
                        end
                        if (textX < 1) then
                            textX = 1
                        end
                        if (textX < wIndex) or (textX >= w + wIndex) then
                            wIndex = textX - w + 1
                        end
                        if (wIndex < 1) then
                            wIndex = 1
                        end

                    elseif (key == keys.left) then
                        startSelX, startSelY, endSelX, endSelY = nil, nil, nil, nil
                        -- arrow left
                        textX = textX - 1
                        if (textX >= 1) then
                            if (textX < wIndex) or (textX >= w + wIndex) then
                                wIndex = textX
                            end
                        end
                        if (textY > 1) then
                            if (textX < 1) then
                                textY = textY - 1
                                textX = lines[textY]:len() + 1
                                wIndex = textX - w + 1
                            end
                        end
                        if (textX < 1) then
                            textX = 1
                        end
                        if (wIndex < 1) then
                            wIndex = 1
                        end
                    elseif(key == keys.tab)then
                        if(textX % 3 == 0 )then
                            lines[textY] = lines[textY]:sub(1, textX - 1) .. " " .. lines[textY]:sub(textX, lines[textY]:len())
                            fgLines[textY] = fgLines[textY]:sub(1, textX - 1) .. tHex[self:getForeground()] .. fgLines[textY]:sub(textX, fgLines[textY]:len())
                            bgLines[textY] = bgLines[textY]:sub(1, textX - 1) .. tHex[self:getBackground()] .. bgLines[textY]:sub(textX, bgLines[textY]:len())
                            textX = textX + 1
                        end
                        while textX % 3 ~= 0 do
                            lines[textY] = lines[textY]:sub(1, textX - 1) .. " " .. lines[textY]:sub(textX, lines[textY]:len())
                            fgLines[textY] = fgLines[textY]:sub(1, textX - 1) .. tHex[self:getForeground()] .. fgLines[textY]:sub(textX, fgLines[textY]:len())
                            bgLines[textY] = bgLines[textY]:sub(1, textX - 1) .. tHex[self:getBackground()] .. bgLines[textY]:sub(textX, bgLines[textY]:len())
                            textX = textX + 1
                        end
                    end

                if not((obx + textX - wIndex >= obx and obx + textX - wIndex < obx + w) and (oby + textY - hIndex >= oby and oby + textY - hIndex < oby + h)) then
                    wIndex = math.max(1, lines[textY]:len()-w+1)
                    hIndex = math.max(1, textY - h + 1)
                end

                local cursorX = (textX <= lines[textY]:len() and textX - 1 or lines[textY]:len()) - (wIndex - 1)
                if (cursorX > self:getX() + w - 1) then
                    cursorX = self:getX() + w - 1
                end
                local cursorY = (textY - hIndex < h and textY - hIndex or textY - hIndex - 1)
                if (cursorX < 1) then
                    cursorX = 0
                end
                parent:setCursor(true, obx + cursorX, oby + cursorY, self:getForeground())
                self:updateDraw()
                return true
            end
        end,

        charHandler = function(self, char)
            if(base.charHandler(self, char))then
                local parent = self:getParent()
                local obx, oby = self:getPosition()
                local w,h = self:getSize()
                if(isSelected())then
                    removeSelection(self)
                end
                lines[textY] = lines[textY]:sub(1, textX - 1) .. char .. lines[textY]:sub(textX, lines[textY]:len())
                fgLines[textY] = fgLines[textY]:sub(1, textX - 1) .. tHex[self:getForeground()] .. fgLines[textY]:sub(textX, fgLines[textY]:len())
                bgLines[textY] = bgLines[textY]:sub(1, textX - 1) .. tHex[self:getBackground()] .. bgLines[textY]:sub(textX, bgLines[textY]:len())
                textX = textX + 1
                if (textX >= w + wIndex) then
                    wIndex = wIndex + 1
                end
                updateColors(self)
                self:setValue("")

                if not((obx + textX - wIndex >= obx and obx + textX - wIndex < obx + w) and (oby + textY - hIndex >= oby and oby + textY - hIndex < oby + h)) then
                    wIndex = math.max(1, lines[textY]:len()-w+1)
                    hIndex = math.max(1, textY - h + 1)
                end

                local cursorX = (textX <= lines[textY]:len() and textX - 1 or lines[textY]:len()) - (wIndex - 1)
                if (cursorX > self:getX() + w - 1) then
                    cursorX = self:getX() + w - 1
                end
                local cursorY = (textY - hIndex < h and textY - hIndex or textY - hIndex - 1)
                if (cursorX < 1) then
                    cursorX = 0
                end
                parent:setCursor(true, obx + cursorX, oby + cursorY, self:getForeground())
                self:updateDraw()
                return true
            end
        end,

        dragHandler = function(self, button, x, y)
            if (base.dragHandler(self, button, x, y)) then
                local parent = self:getParent()
                local obx, oby = self:getAbsolutePosition()
                local anchx, anchy = self:getPosition()
                local w,h = self:getSize()
                if (lines[y - oby + hIndex] ~= nil) then
                    if anchx <= x - obx + wIndex and anchx + w > x - obx + wIndex then
                        textX = x - obx + wIndex
                        textY = y - oby + hIndex
                
                        if textX > lines[textY]:len() then
                            textX = lines[textY]:len() + 1
                        end

                        endSelX = textX
                        endSelY = textY
                        
                        if textX < wIndex then
                            wIndex = textX - 1
                            if wIndex < 1 then
                                wIndex = 1
                            end
                        end
                        parent:setCursor(not isSelected(), anchx + textX - wIndex, anchy + textY - hIndex, self:getForeground())
                        self:updateDraw()
                    end 
                end
                return true
            end
        end,

        scrollHandler = function(self, dir, x, y)
            if (base.scrollHandler(self, dir, x, y)) then
                local parent = self:getParent()
                local obx, oby = self:getAbsolutePosition()
                local anchx, anchy = self:getPosition()
                local w,h = self:getSize()
                hIndex = hIndex + dir
                if (hIndex > #lines - (h - 1)) then
                    hIndex = #lines - (h - 1)
                end

                if (hIndex < 1) then
                    hIndex = 1
                end

                if (obx + textX - wIndex >= obx and obx + textX - wIndex < obx + w) and (anchy + textY - hIndex >= anchy and anchy + textY - hIndex < anchy + h) then
                    parent:setCursor(not isSelected(), anchx + textX - wIndex, anchy + textY - hIndex, self:getForeground())
                else
                    parent:setCursor(false)
                end
                self:updateDraw()
                return true
            end
        end,

        mouseHandler = function(self, button, x, y)
            if (base.mouseHandler(self, button, x, y)) then
                local parent = self:getParent()
                local obx, oby = self:getAbsolutePosition()
                local anchx, anchy = self:getPosition()
                    if (lines[y - oby + hIndex] ~= nil) then
                        textX = x - obx + wIndex
                        textY = y - oby + hIndex
                        endSelX = nil
                        endSelY = nil
                        startSelX = textX
                        startSelY = textY
                        if (textX > lines[textY]:len()) then
                            textX = lines[textY]:len() + 1
                            startSelX = textX
                        end
                        if (textX < wIndex) then
                            wIndex = textX - 1
                            if (wIndex < 1) then
                                wIndex = 1
                            end
                        end
                        self:updateDraw()
                    end
                parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex, self:getForeground())
                return true
            end
        end,

        mouseUpHandler = function(self, button, x, y)
            if (base.mouseUpHandler(self, button, x, y)) then
                local obx, oby = self:getAbsolutePosition()
                local anchx, anchy = self:getPosition()
                    if (lines[y - oby + hIndex] ~= nil) then
                        endSelX = x - obx + wIndex
                        endSelY = y - oby + hIndex
                        if (endSelX > lines[endSelY]:len()) then
                            endSelX = lines[endSelY]:len() + 1
                        end
                        if(startSelX==endSelX)and(startSelY==endSelY)then
                            startSelX, endSelX, startSelY, endSelY = nil, nil, nil, nil
                        end                            
                        self:updateDraw()
                    end
                return true
            end
        end,

        eventHandler = function(self, event, paste, p2, p3, p4)
            if(base.eventHandler(self, event, paste, p2, p3, p4))then
                if(event=="paste")then
                    if(self:isFocused())then
                        local parent = self:getParent()
                        local fgColor, bgColor = self:getForeground(), self:getBackground()
                        local w, h = self:getSize()
                        lines[textY] = lines[textY]:sub(1, textX - 1) .. paste .. lines[textY]:sub(textX, lines[textY]:len())
                        fgLines[textY] = fgLines[textY]:sub(1, textX - 1) .. tHex[fgColor]:rep(paste:len()) .. fgLines[textY]:sub(textX, fgLines[textY]:len())
                        bgLines[textY] = bgLines[textY]:sub(1, textX - 1) .. tHex[bgColor]:rep(paste:len()) .. bgLines[textY]:sub(textX, bgLines[textY]:len())
                        textX = textX + paste:len()
                        if (textX >= w + wIndex) then
                            wIndex = (textX+1)-w
                        end
                        local anchx, anchy = self:getPosition()
                        parent:setCursor(true, anchx + textX - wIndex, anchy + textY - hIndex, fgColor)
                        updateColors(self)
                        self:updateDraw()
                    end
                end
            end
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("textfield", function()
                local parent = self:getParent()
                local obx, oby = self:getPosition()
                local w, h = self:getSize()
                local bgColor = tHex[self:getBackground()]
                local fgColor = tHex[self:getForeground()]
        
                for n = 1, h do
                    local text = ""
                    local bg = ""
                    local fg = ""
                    if lines[n + hIndex - 1] then
                        text = lines[n + hIndex - 1]
                        fg = fgLines[n + hIndex - 1]
                        bg = bgLines[n + hIndex - 1]
                    end
        
                    text = sub(text, wIndex, w + wIndex - 1)
                    bg = rep(bgColor, w)
                    fg = rep(fgColor, w)
        
                    self:addText(1, n, text)
                    self:addBG(1, n, bg)
                    self:addFG(1, n, fg)
                    self:addBlit(1, n, text, fg, bg)
                end
        
                if startSelX and endSelX and startSelY and endSelY then
                    local sx, ex, sy, ey = getSelectionCoordinates(self)
                    for n = sy, ey do
                        local line = #lines[n]
                        local xOffset = 0
                        if n == sy and n == ey then
                            xOffset = sx - 1
                            line = line - (sx - 1) - (line - ex)
                        elseif n == ey then
                            line = line - (line - ex)
                        elseif n == sy then
                            line = line - (sx - 1)
                            xOffset = sx - 1
                        end
                        self:addBG(1 + xOffset, n, rep(tHex[selectionBG], line))
                        self:addFG(1 + xOffset, n, rep(tHex[selectionFG], line))
                    end
                end
            end)
        end,

        load = function(self)
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_up")
            self:listenEvent("mouse_scroll")
            self:listenEvent("mouse_drag")
            self:listenEvent("key")
            self:listenEvent("char")
            self:listenEvent("other_event")
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["Treeview"] = function(...)
local utils = require("utils")
local tHex = require("tHex")

return function(name, basalt)
    local base = basalt.getObject("ChangeableObject")(name, basalt)
    local objectType = "Treeview"

    local nodes = {}
    local itemSelectedBG = colors.black
    local itemSelectedFG = colors.lightGray
    local selectionColorActive = true
    local textAlign = "left"
    local xOffset, yOffset = 0, 0
    local scrollable = true

    base:setSize(16, 8)
    base:setZIndex(5)

    local function newNode(text, expandable)
        text = text or ""
        expandable = expandable or false
        local expanded = false
        local parent = nil
        local children = {}

        local node = {}

        local onSelect

        node = {
            getChildren = function()
                return children
            end,

            setParent = function(p)
                if(parent~=nil)then
                    parent.removeChild(parent.findChildrenByText(node.getText()))
                end
                parent = p
                base:updateDraw()
                return node
            end,

            getParent = function()
                return parent
            end,

            addChild = function(text, expandable)
                local childNode = newNode(text, expandable)
                childNode.setParent(node)
                table.insert(children, childNode)
                base:updateDraw()
                return childNode
            end,

            setExpanded = function(exp)
                if(expandable)then
                    expanded = exp
                end
                base:updateDraw()
                return node
            end,

            isExpanded = function()
                return expanded
            end,

            onSelect = function(...)
                for _,v in pairs(table.pack(...))do
                    if(type(v)=="function")then
                        onSelect = v
                    end
                end
                return node
            end,

            callOnSelect = function()
                if(onSelect~=nil)then
                    onSelect(node)
                end
            end,

            setExpandable = function(expandable)
                expandable = expandable
                base:updateDraw()
                return node
            end,

            isExpandable = function()
                return expandable
            end,

            removeChild = function(index)
                if(type(index)=="table")then
                    for k,v in pairs(index)do
                        if(v==index)then
                            index = k
                            break
                        end
                    end
                end
                table.remove(children, index)
                base:updateDraw()
                return node
            end,

            findChildrenByText = function(searchText)
                local foundNodes = {}
                for _, child in ipairs(children) do
                    if string.find(child.getText(), searchText) then
                        table.insert(foundNodes, child)
                    end
                end
                return foundNodes
            end,

            getText = function()
                return text
            end,

            setText = function(t)
                text = t
                base:updateDraw()
                return node
            end
        }

        return node
    end

    local root = newNode("Root", true)
    root.setExpanded(true)

    local object = {
        init = function(self)
            local parent = self:getParent()
            self:listenEvent("mouse_click")
            self:listenEvent("mouse_scroll")
            return base.init(self)
        end,

        getBase = function(self)
            return base
        end,

        getType = function(self)
            return objectType
        end,

        isType = function(self, t)
            return objectType == t or base.isType ~= nil and base.isType(t) or false
        end,

        setOffset = function(self, x, y)
            xOffset = x
            yOffset = y
            return self
        end,

        getOffset = function(self)
            return xOffset, yOffset
        end,

        setScrollable = function(self, scroll)
            scrollable = scroll
            return self
        end,

        setSelectionColor = function(self, bgCol, fgCol, active)
            itemSelectedBG = bgCol or self:getBackground()
            itemSelectedFG = fgCol or self:getForeground()
            selectionColorActive = active~=nil and active or true
            self:updateDraw()
            return self
        end,

        getSelectionColor = function(self)
            return itemSelectedBG, itemSelectedFG
        end,

        isSelectionColorActive = function(self)
            return selectionColorActive
        end,

        getRoot = function(self)
            return root
        end,

        setRoot = function(self, node)
            root = node
            node.setParent(nil)
            return self
        end,

        onSelect = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("treeview_select", v)
                end
            end
            return self
        end,

        selectionHandler = function(self, node)
            node.callOnSelect(node)
            self:sendEvent("treeview_select", node)
            return self
        end,

        mouseHandler = function(self, button, x, y)
            if base.mouseHandler(self, button, x, y) then
                local currentLine = 1 - yOffset
                local obx, oby = self:getAbsolutePosition()
                local w, h = self:getSize()
                local function checkNodeClick(node, level)
                    if y == oby+currentLine-1 then
                        if x >= obx and x < obx + w then
                            node.setExpanded(not node.isExpanded())
                            self:selectionHandler(node)
                            self:setValue(node)
                            self:updateDraw()
                            return true
                        end
                    end
                    currentLine = currentLine + 1
                    if node.isExpanded() then
                        for _, child in ipairs(node.getChildren()) do
                            if checkNodeClick(child, level + 1) then
                                return true
                            end
                        end
                    end
                    return false
                end
        
                for _, item in ipairs(root.getChildren()) do
                    if checkNodeClick(item, 1) then
                        return true
                    end
                end
            end
        end,

        scrollHandler = function(self, dir, x, y)
            if base.scrollHandler(self, dir, x, y) then
                if scrollable then
                    local _, h = self:getSize()
                    yOffset = yOffset + dir
        
                    if yOffset < 0 then
                        yOffset = 0
                    end
        
                    if dir >= 1 then
                        local visibleLines = 0
                        local function countVisibleLines(node, level)
                            visibleLines = visibleLines + 1
                            if node.isExpanded() then
                                for _, child in ipairs(node.getChildren()) do
                                    countVisibleLines(child, level + 1)
                                end
                            end
                        end
        
                        for _, item in ipairs(root.getChildren()) do
                            countVisibleLines(item, 1)
                        end
        
                        if visibleLines > h then
                            if yOffset > visibleLines - h then
                                yOffset = visibleLines - h
                            end
                        else
                            yOffset = yOffset - 1
                        end
                    end
                    self:updateDraw()
                end
                return true
            end
            return false
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("treeview", function()
                local currentLine = 1 - yOffset
                local lastClickedNode = self:getValue()
                local function drawNode(node, level)
                    local w, h = self:getSize()
                
                    if currentLine >= 1 and currentLine <= h then
                        local bg = (node == lastClickedNode) and itemSelectedBG or self:getBackground()
                        local fg = (node == lastClickedNode) and itemSelectedFG or self:getForeground()
                
                        local text = node.getText()
                        self:addBlit(1 + level + xOffset, currentLine, text, tHex[fg]:rep(#text), tHex[bg]:rep(#text))
                    end
                
                    currentLine = currentLine + 1     
                               
                    if node.isExpanded() then
                        for _, child in ipairs(node.getChildren()) do
                            drawNode(child, level + 1)
                        end
                    end
                end
        
                for _, item in ipairs(root.getChildren()) do
                    drawNode(item, 1)
                end
            end)
        end,


    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["ScrollableFrame"] = function(...)
local max,min,sub,rep = math.max,math.min,string.sub,string.rep

return function(name, basalt)
    local base = basalt.getObject("Frame")(name, basalt)
    local objectType = "ScrollableFrame"
    local parent

    local direction = 0
    local manualScrollAmount = 0
    local calculateScrollAmount = true

    local function getHorizontalScrollAmount(self)
        local amount = 0
        local objects = self:getObjects()
        for _, b in pairs(objects) do
            if(b.element.getWidth~=nil)and(b.element.getX~=nil)then
                local w, x = b.element:getWidth(), b.element:getX()
                local width = self:getWidth()
                if(b.element:getType()=="Dropdown")then
                    if(b.element:isOpened())then
                        local dropdownW = b.element:getDropdownSize()
                        if (dropdownW + x - width >= amount) then
                            amount = max(dropdownW + x - width, 0)
                        end
                    end
                end

                if (h + x - width >= amount) then
                    amount = max(w + x - width, 0)
                end
            end
        end
        return amount
    end

    local function getVerticalScrollAmount(self)
        local amount = 0
        local objects = self:getObjects()
        for _, b in pairs(objects) do
            if(b.element.getHeight~=nil)and(b.element.getY~=nil)then
                local h, y = b.element:getHeight(), b.element:getY()
                local height = self:getHeight()
                if(b.element:getType()=="Dropdown")then
                    if(b.element:isOpened())then
                        local _,dropdownH = b.element:getDropdownSize()
                        if (dropdownH + y - height >= amount) then
                            amount = max(dropdownH + y - height, 0)
                        end
                    end
                end
                if (h + y - height >= amount) then
                    amount = max(h + y - height, 0)
                end
            end
        end
        return amount
    end

    local function scrollHandler(self, dir)
        local xO, yO = self:getOffset()
        local scrollAmn
        if(direction==1)then
            scrollAmn = calculateScrollAmount and getHorizontalScrollAmount(self) or manualScrollAmount
            self:setOffset(min(scrollAmn, max(0, xO + dir)), yO)
        elseif(direction==0)then
            scrollAmn = calculateScrollAmount and getVerticalScrollAmount(self) or manualScrollAmount
            self:setOffset(xO, min(scrollAmn, max(0, yO + dir)))
        end
        self:updateDraw()
    end
    
    local object = {    
        getType = function()
            return objectType
        end,

        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        setDirection = function(self, dir)
            direction = dir=="horizontal" and 1 or dir=="vertical" and 0 or direction
            return self
        end,

        setScrollAmount = function(self, amount)
            manualScrollAmount = amount
            calculateScrollAmount = false
            return self
        end,

        getBase = function(self)
            return base
        end, 
        
        load = function(self)
            base.load(self)
            self:listenEvent("mouse_scroll")
        end,

        setParent = function(self, p, ...)
            base.setParent(self, p, ...)
            parent = p
            return self
        end,

        scrollHandler = function(self, dir, x, y)
            if(base:getBase().scrollHandler(self, dir, x, y))then
                self:sortElementOrder()
                for _, obj in ipairs(self:getEvents("mouse_scroll")) do
                    if (obj.element.scrollHandler ~= nil) then
                        local xO, yO = 0, 0
                        if(self.getOffset~=nil)then
                            xO, yO = self:getOffset()
                        end
                        if(obj.element.getIgnoreOffset())then
                            xO, yO = 0, 0
                        end
                        if (obj.element.scrollHandler(obj.element, dir, x+xO, y+yO)) then      
                            return true
                        end
                    end
                end
                scrollHandler(self, dir, x, y)
                self:removeFocusedObject()
                return true
            end
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("scrollableFrame", function()
                if(calculateScrollAmount)then
                    scrollHandler(self, 0)
                end
            end, 0)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end
end
project["objects"]["VisualObject"] = function(...)
local utils = require("utils")
local tHex = require("tHex")

local sub, find, insert = string.sub, string.find, table.insert

return function(name, basalt)   
    local base = basalt.getObject("Object")(name, basalt)
    -- Base object
    local objectType = "VisualObject" -- not changeable

    local isVisible,ignOffset,isHovered,isClicked,isDragging = true,false,false,false,false
    local zIndex = 1

    local x, y, width, height = 1,1,1,1
    local dragStartX, dragStartY, dragXOffset, dragYOffset = 0, 0, 0, 0

    local bgColor,fgColor, transparency = colors.black, colors.white, false
    local parent

    local preDrawQueue = {}
    local drawQueue = {}
    local postDrawQueue = {}

    local renderObject = {}

    local function split(str, d)
        local result = {}
        if str == "" then
            return result
        end
        d = d or " "
        local start = 1
        local delim_start, delim_end = find(str, d, start)
            while delim_start do
                insert(result, {x=start, value=sub(str, start, delim_start - 1)})
                start = delim_end + 1
                delim_start, delim_end = find(str, d, start)
            end
        insert(result, {x=start, value=sub(str, start)})
        return result
    end


    local object = {
        getType = function(self)
            return objectType
        end,

        getBase = function(self)
            return base
        end,  
      
        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

        getBasalt = function(self)
            return basalt
        end,

        show = function(self)
            isVisible = true
            self:updateDraw()
            return self
        end,

        hide = function(self)
            isVisible = false
            self:updateDraw()
            return self
        end,

        isVisible = function(self)
            return isVisible
        end,

        setVisible = function(self, _isVisible)
            isVisible = _isVisible or not isVisible
            self:updateDraw()
            return self
        end,

        setTransparency = function(self, _transparency)
            transparency = _transparency~= nil and _transparency or true
            self:updateDraw()
            return self
        end,

        setParent = function(self, newParent, noRemove)
            base.setParent(self, newParent, noRemove)
            parent = newParent
            return self
        end,

        setFocus = function(self)
            if (parent ~= nil) then
                parent:setFocusedObject(self)
            end
            return self
        end,

        setZIndex = function(self, index)
            zIndex = index
            if (parent ~= nil) then
                parent:updateZIndex(self, zIndex)
                self:updateDraw()
            end            
            return self
        end,

        getZIndex = function(self)
            return zIndex
        end,

        updateDraw = function(self)
            if (parent ~= nil) then
                parent:updateDraw()
            end
            return self
        end,

        setPosition = function(self, xPos, yPos, rel)
            local curX, curY = x, y
            if(type(xPos)=="number")then
                x = rel and x+xPos or xPos
            end
            if(type(yPos)=="number")then
                y = rel and y+yPos or yPos
            end
            if(parent~=nil)then parent:customEventHandler("basalt_FrameReposition", self) end
            if(self:getType()=="Container")then parent:customEventHandler("basalt_FrameReposition", self) end
            self:updateDraw()
            self:repositionHandler(curX, curY)
            return self
        end,

        getX = function(self)
            return x
        end,

        getY = function(self)
            return y
        end,

        getPosition = function(self)
            return x, y
        end,

        setSize = function(self, newWidth, newHeight, rel)
            local oldW, oldH = width, height
            if(type(newWidth)=="number")then
                width = rel and width+newWidth or newWidth
            end
            if(type(newHeight)=="number")then
                height = rel and height+newHeight or newHeight
            end
            if(parent~=nil)then 
                parent:customEventHandler("basalt_FrameResize", self)
                if(self:getType()=="Container")then parent:customEventHandler("basalt_FrameResize", self) end
            end
            self:resizeHandler(oldW, oldH)
            self:updateDraw()
            return self
        end,

        getHeight = function(self)
            return height
        end,

        getWidth = function(self)
            return width
        end,

        getSize = function(self)
            return width, height
        end,

        setBackground = function(self, color)
            bgColor = color
            self:updateDraw()
            return self
        end,

        getBackground = function(self)
            return bgColor
        end,

        setForeground = function(self, color)
            fgColor = color or false
            self:updateDraw()
            return self
        end,

        getForeground = function(self)
            return fgColor
        end,

        getAbsolutePosition = function(self, x, y)
            -- relative position to absolute position
            if (x == nil) or (y == nil) then
                x, y = self:getPosition()
            end

            if (parent ~= nil) then
                local fx, fy = parent:getAbsolutePosition()
                x = fx + x - 1
                y = fy + y - 1
            end
            return x, y
        end,

        ignoreOffset = function(self, ignore)
            ignOffset = ignore
            if(ignore==nil)then ignOffset = true end
            return self
        end,

        getIgnoreOffset = function(self)
            return ignOffset
        end,

        isCoordsInObject = function(self, x, y)
            if(isVisible)and(self:isEnabled())then
                if(x==nil)or(y==nil)then return false end
                local objX, objY = self:getAbsolutePosition()
                local w, h = self:getSize()            
                if (objX <= x) and (objX + w > x) and (objY <= y) and (objY + h > y) then
                    return true
                end
            end
            return false
        end,

        onGetFocus = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("get_focus", v)
                end
            end
            return self
        end,

        onLoseFocus = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("lose_focus", v)
                end
            end
            return self
        end,

        isFocused = function(self)
            if (parent ~= nil) then
                return parent:getFocusedObject() == self
            end
            return true
        end,

        resizeHandler = function(self, ...)
            if(self:isEnabled())then
                local val = self:sendEvent("basalt_resize", ...)
                if(val==false)then return false end
            end
            return true
        end,

        repositionHandler = function(self, ...)
            if(self:isEnabled())then
                local val = self:sendEvent("basalt_reposition", ...)
                if(val==false)then return false end
            end
            return true
        end,

        onResize = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("basalt_resize", v)
                end
            end
            return self
        end,

        onReposition = function(self, ...)
            for _,v in pairs(table.pack(...))do
                if(type(v)=="function")then
                    self:registerEvent("basalt_reposition", v)
                end
            end
            return self
        end,

        mouseHandler = function(self, button, x, y, isMon)
            if(self:isCoordsInObject(x, y))then
                local objX, objY = self:getAbsolutePosition()
                local val = self:sendEvent("mouse_click", button, x - (objX-1), y - (objY-1), x, y, isMon)
                if(val==false)then return false end
                if(parent~=nil)then
                    parent:setFocusedObject(self)
                end
                isClicked = true
                isDragging = true
                dragStartX, dragStartY = x, y 
                return true
            end
        end,

        mouseUpHandler = function(self, button, x, y)
            isDragging = false
            if(isClicked)then
                local objX, objY = self:getAbsolutePosition()
                local val = self:sendEvent("mouse_release", button, x - (objX-1), y - (objY-1), x, y)
                isClicked = false
            end
            if(self:isCoordsInObject(x, y))then
                local objX, objY = self:getAbsolutePosition()
                local val = self:sendEvent("mouse_up", button, x - (objX-1), y - (objY-1), x, y)
                if(val==false)then return false end
                return true
            end
        end,

        dragHandler = function(self, button, x, y)
            if(isDragging)then 
                local objX, objY = self:getAbsolutePosition()
                local val = self:sendEvent("mouse_drag", button, x - (objX-1), y - (objY-1), dragStartX-x, dragStartY-y, x, y)
                dragStartX, dragStartY = x, y 
                if(val~=nil)then return val end
                if(parent~=nil)then
                    parent:setFocusedObject(self)
                end
                return true
            end

            if(self:isCoordsInObject(x, y))then
                local objX, objY = self:getAbsolutePosition()
                dragStartX, dragStartY = x, y 
                dragXOffset, dragYOffset = objX - x, objY - y
            end
        end,

        scrollHandler = function(self, dir, x, y)
            if(self:isCoordsInObject(x, y))then
                local objX, objY = self:getAbsolutePosition()
                local val = self:sendEvent("mouse_scroll", dir, x - (objX-1), y - (objY-1))
                if(val==false)then return false end
                if(parent~=nil)then
                    parent:setFocusedObject(self)
                end
                return true
            end
        end,

        hoverHandler = function(self, x, y, stopped)
            if(self:isCoordsInObject(x, y))then
                local val = self:sendEvent("mouse_hover", x, y, stopped)
                if(val==false)then return false end
                isHovered = true
                return true
            end
            if(isHovered)then
                local val = self:sendEvent("mouse_leave", x, y, stopped)
                if(val==false)then return false end
                isHovered = false
            end
        end,

        keyHandler = function(self, key, isHolding)
            if(self:isEnabled())and(isVisible)then
                if (self:isFocused()) then
                local val = self:sendEvent("key", key, isHolding)
                if(val==false)then return false end
                return true
                end
            end
        end,

        keyUpHandler = function(self, key)
            if(self:isEnabled())and(isVisible)then
                if (self:isFocused()) then
                    local val = self:sendEvent("key_up", key)
                if(val==false)then return false end
                return true
                end
            end
        end,

        charHandler = function(self, char)
            if(self:isEnabled())and(isVisible)then
                if(self:isFocused())then
                local val = self:sendEvent("char", char)
                if(val==false)then return false end
                return true
                end
            end
        end,

        getFocusHandler = function(self)
            local val = self:sendEvent("get_focus")
            if(val~=nil)then return val end
            return true
        end,

        loseFocusHandler = function(self)
            isDragging = false
            local val = self:sendEvent("lose_focus")
            if(val~=nil)then return val end
            return true
        end,

        addDraw = function(self, name, f, pos, typ, active)
            local queue = (typ==nil or typ==1) and drawQueue or typ==2 and preDrawQueue or typ==3 and postDrawQueue
            pos = pos or #queue+1
            if(name~=nil)then
                for k,v in pairs(queue)do
                    if(v.name==name)then 
                        table.remove(queue, k)
                        break
                    end
                end
                local t = {name=name, f=f, pos=pos, active=active~=nil and active or true}
                table.insert(queue, pos, t)
            end
            self:updateDraw()
            return self
        end,

        addPreDraw = function(self, name, f, pos, typ)
            self:addDraw(name, f, pos, 2)
            return self
        end,

        addPostDraw = function(self, name, f, pos, typ)
            self:addDraw(name, f, pos, 3)
            return self
        end,

        setDrawState = function(self, name, state, typ)
            local queue = (typ==nil or typ==1) and drawQueue or typ==2 and preDrawQueue or typ==3 and postDrawQueue
            for k,v in pairs(queue)do
                if(v.name==name)then 
                    v.active = state
                    break
                end
            end
            self:updateDraw()
            return self
        end,

        getDrawId = function(self, name, typ)
            local queue = typ==1 and drawQueue or typ==2 and preDrawQueue or typ==3 and postDrawQueue or drawQueue
            for k,v in pairs(queue)do
                if(v.name==name)then 
                    return k
                end
            end
        end,

        addText = function(self, x, y, text)
            local obj = self:getParent() or self
            local xPos,yPos = self:getPosition()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            if not(transparency)then
                obj:setText(x+xPos-1, y+yPos-1, text)
                return
            end
            local t = split(text, "\0")
            for k,v in pairs(t)do
                if(v.value~="")and(v.value~="\0")then
                    obj:setText(x+v.x+xPos-2, y+yPos-1, v.value)
                end
            end
        end,

        addBG = function(self, x, y, bg, noText)
            local obj = parent or self
            local xPos,yPos = self:getPosition()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            if not(transparency)then
                obj:setBG(x+xPos-1, y+yPos-1, bg)
                return
            end
            local t = split(bg)
            for k,v in pairs(t)do
                if(v.value~="")and(v.value~=" ")then
                    if(noText~=true)then
                        obj:setText(x+v.x+xPos-2, y+yPos-1, (" "):rep(#v.value))
                        obj:setBG(x+v.x+xPos-2, y+yPos-1, v.value)
                    else
                        table.insert(renderObject, {x=x+v.x-1,y=y,bg=v.value})
                        obj:setBG(x+xPos-1, y+yPos-1, fg)
                    end
                end
            end
        end,

        addFG = function(self, x, y, fg)
            local obj = parent or self
            local xPos,yPos = self:getPosition()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            if not(transparency)then
                obj:setFG(x+xPos-1, y+yPos-1, fg)
                return
            end
            local t = split(fg)
            for k,v in pairs(t)do
                if(v.value~="")and(v.value~=" ")then
                    obj:setFG(x+v.x+xPos-2, y+yPos-1, v.value)
                end
            end
        end,

        addBlit = function(self, x, y, t, fg, bg)
            local obj = parent or self
            local xPos,yPos = self:getPosition()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            if not(transparency)then
                obj:blit(x+xPos-1, y+yPos-1, t, fg, bg)
                return
            end
            local _text = split(t, "\0")
            local _fg = split(fg)
            local _bg = split(bg)
            for k,v in pairs(_text)do
                if(v.value~="")or(v.value~="\0")then
                    obj:setText(x+v.x+xPos-2, y+yPos-1, v.value)
                end
            end
            for k,v in pairs(_bg)do
                if(v.value~="")or(v.value~=" ")then
                    obj:setBG(x+v.x+xPos-2, y+yPos-1, v.value)
                end
            end
            for k,v in pairs(_fg)do
                if(v.value~="")or(v.value~=" ")then
                    obj:setFG(x+v.x+xPos-2, y+yPos-1, v.value)
                end
            end
        end,

        addTextBox = function(self, x, y, w, h, text)
            local obj = parent or self
            local xPos,yPos = self:getPosition()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            obj:drawTextBox(x+xPos-1, y+yPos-1, w, h, text)
        end,

        addForegroundBox = function(self, x, y, w, h, col)
            local obj = parent or self
            local xPos,yPos = self:getPosition()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            obj:drawForegroundBox(x+xPos-1, y+yPos-1, w, h, col)
        end,

        addBackgroundBox = function(self, x, y, w, h, col)
            local obj = parent or self
            local xPos,yPos = self:getPosition()
            if(parent~=nil)then
                local xO, yO = parent:getOffset()
                xPos = ignOffset and xPos or xPos - xO
                yPos = ignOffset and yPos or yPos - yO
            end
            obj:drawBackgroundBox(x+xPos-1, y+yPos-1, w, h, col)
        end,

        render = function(self)
            if (isVisible)then
                self:redraw()
            end
        end,

        redraw = function(self)
            for k,v in pairs(preDrawQueue)do
                if (v.active)then
                    v.f(self)
                end
            end
            for k,v in pairs(drawQueue)do
                if (v.active)then
                    v.f(self)
                end
            end
            for k,v in pairs(postDrawQueue)do
                if (v.active)then
                    v.f(self)
                end
            end
            return true
        end,

        draw = function(self)
            self:addDraw("base", function()
                local w,h = self:getSize()
                if(bgColor~=false)then
                    self:addTextBox(1, 1, w, h, " ")
                    self:addBackgroundBox(1, 1, w, h, bgColor)
                end
                if(fgColor~=false)then
                    self:addForegroundBox(1, 1, w, h, fgColor)
                end
            end, 1)
        end,
    }
    object.__index = object
    return setmetatable(object, base)
end
end
 return project["main"]()