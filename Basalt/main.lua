local basaltEvent = require("basaltEvent")()
local Frame = require("Frame")
local theme = require("theme")
local utils = require("utils")
local log = require("basaltLogs")
local uuid = utils.uuid
local createText = utils.createText
local count = utils.tableCount
local moveThrottle = 300
local dragThrottle = 50

local baseTerm = term.current()
local version = "1.6.4"

local projectDirectory = fs.getDir(table.pack(...)[2] or "")

local activeKey, frames, monFrames, monGroups, variables, schedules = {}, {}, {}, {}, {}, {}
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

local function basaltError(errMsg)
    baseTerm.clear()
    baseTerm.setBackgroundColor(colors.black)
    baseTerm.setTextColor(colors.red)
    local w,h = baseTerm.getSize()
    if(basalt.logging)then
        log(errMsg, "Error")
    end

    local text = createText("Basalt error: "..errMsg, w)
    local yPos = 1
    for k,v in pairs(text)do
        baseTerm.setCursorPos(1,yPos)
        baseTerm.write(v)
        yPos = yPos + 1
    end 
    baseTerm.setCursorPos(1,yPos+1)
    updaterActive = false
end

local function schedule(f)
assert(f~="function", "Schedule needs a function in order to work!")
return function(...)
        local co = coroutine.create(f)
        local ok, result = coroutine.resume(co, ...)
        if(ok)then
            table.insert(schedules, {co, result})
        else
            basaltError(result)
        end
    end
end

local setVariable = function(name, var)
    variables[name] = var
end

local getVariable = function(name)
    return variables[name]
end

local setTheme = function(_theme)
    theme = _theme
end

local getTheme = function(name)
    return theme[name]
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
    getTheme = getTheme,

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

    getBaseTerm = function()
        return baseTerm
    end,

    schedule = schedule,

    stop = stop,
    newFrame = Frame,

    getDirectory = function()
        return projectDirectory
    end
}

local function handleSchedules(event, ...)
    if(#schedules>0)then
        local finished = {}
        for n=1,#schedules do
            if(schedules[n]~=nil)then 
                if (coroutine.status(schedules[n][1]) == "suspended")then
                    if(schedules[n][2]~=nil)then
                        if(schedules[n][2]==event)then
                            local ok, result = coroutine.resume(schedules[n][1], event, ...)     
                            schedules[n][2] = result                       
                            if not(ok)then
                                basaltError(result)
                            end
                        end
                    else
                        local ok, result = coroutine.resume(schedules[n][1], event, ...)    
                        schedules[n][2] = result                        
                        if not(ok)then
                            basaltError(result)
                        end
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
        mainFrame:draw()
        mainFrame:updateTerm()
    end
    for _,v in pairs(monFrames)do
        v:draw()
        v:updateTerm()
    end
    for _,v in pairs(monGroups)do
        v[1]:draw()
        v[1]:updateTerm()
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
            drawFrames()
            return
        end
    end

    if(event == "monitor_touch") then
        if(monFrames[a[1]]~=nil)then
            monFrames[a[1]]:mouseHandler(1, a[2], a[3], true)
            activeFrame = monFrames[a[1]]
        end
        if(count(monGroups)>0)then
            for k,v in pairs(monGroups)do
                v[1]:mouseHandler(1, a[2], a[3], true, a[1])
            end
        end
        handleSchedules(event, ...)
        drawFrames()
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
            drawFrames()
            return
        end
    end

    if(event=="timer")and(a[1]==moveTimer)then
        moveHandlerTimer()
    elseif(event=="timer")and(a[1]==dragTimer)then
        dragHandlerTimer()
    else
        for k, v in pairs(frames) do
            v:eventHandler(event, ...)
        end
    end
    handleSchedules(event, ...)
    drawFrames()
end

basalt = {
    logging = false,
    dynamicValueEvents = false,
    setTheme = setTheme,
    getTheme = getTheme,
    drawFrames = drawFrames,
    getVersion = function()
        return version
    end,

    setVariable = setVariable,
    getVariable = getVariable,

    setBaseTerm = function(_baseTerm)
        baseTerm = _baseTerm
    end,

    log = function(...)
        log(...)
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
        local ok, err = xpcall(f, debug.traceback)
        if not(ok)then
            basaltError(err)
            return
        end
    end,
    
    update = function(event, ...)
        if (event ~= nil) then
            local ok, err = xpcall(basaltUpdateEvent, debug.traceback, event, ...)
            if not(ok)then
                basaltError(err)
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
        if (frame:getType() == "Frame") then
            activeFrame = frame
            return true
        end
        return false
    end,
    
    onEvent = function(...)
        for _,v in pairs(table.pack(...))do
            if(type(v)=="function")then
                basaltEvent:registerEvent("basaltEventCycle", v)
            end
        end
    end,

    schedule = schedule,
    
    createFrame = function(name)
        name = name or uuid()
        for _, v in pairs(frames) do
            if (v.name == name) then
                return nil
            end
        end
        local newFrame = Frame(name,nil,nil,bInstance)
        newFrame:init()
        table.insert(frames, newFrame)
        if(mainFrame==nil)and(newFrame:getName()~="basaltDebuggingFrame")then
            newFrame:show()
        end
        return newFrame
    end,
    
    removeFrame = function(name)
        frames[name] = nil
    end,

    setProjectDir = function(dir)
        projectDirectory = dir
    end,

    debug = function(...)
        local args = { ... }
        if(mainFrame==nil)then print(...) return end
        if (mainFrame.name ~= "basaltDebuggingFrame") then
            if (mainFrame ~= basalt.debugFrame) then
                basalt.debugLabel:setParent(mainFrame)
            end
        end
        local str = ""
        for key, value in pairs(args) do
            str = str .. tostring(value) .. (#args ~= key and ", " or "")
        end
        basalt.debugLabel:setText("[Debug] " .. str)
        for k,v in pairs(createText(str, basalt.debugList:getWidth()))do
            basalt.debugList:addItem(v)
        end
        if (basalt.debugList:getItemCount() > 50) then
            basalt.debugList:removeItem(1)
        end
        basalt.debugList:setValue(basalt.debugList:getItem(basalt.debugList:getItemCount()))
        if(basalt.debugList.getItemCount() > basalt.debugList:getHeight())then
            basalt.debugList:setOffset(basalt.debugList:getItemCount() - basalt.debugList:getHeight())
        end
        basalt.debugLabel:show()
    end,
}

basalt.debugFrame = basalt.createFrame("basaltDebuggingFrame"):showBar():setBackground(colors.lightGray):setBar("Debug", colors.black, colors.gray)
basalt.debugFrame:addButton("back"):setAnchor("topRight"):setSize(1, 1):setText("\22"):onClick(function() if(basalt.oldFrame~=nil)then basalt.oldFrame:show() end end):setBackground(colors.red):show()
basalt.debugList = basalt.debugFrame:addList("debugList"):setSize("parent.w - 2", "parent.h - 3"):setPosition(2, 3):setScrollable(true):show()
basalt.debugLabel = basalt.debugFrame:addLabel("debugLabel"):onClick(function() basalt.oldFrame = mainFrame basalt.debugFrame:show() end):setBackground(colors.black):setForeground(colors.white):setAnchor("bottomLeft"):ignoreOffset():setZIndex(20):show()

return basalt
