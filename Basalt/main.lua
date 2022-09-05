local basaltEvent = require("basaltEvent")()
local Frame = require("Frame")
local theme = require("theme")
local utils = require("utils")
local log = require("basaltLogs")
local uuid = utils.uuid
local createText = utils.createText
local count = utils.tableCount


local baseTerm = term.current()
local version = "1.6.2"
local debugger = true

local projectDirectory = fs.getDir(table.pack(...)[2] or "")

local activeKey, frames, monFrames, monGroups, variables, schedules = {}, {}, {}, {}, {}, {}
local mainFrame, activeFrame, focusedObject, updaterActive

local basalt = {}

if not  term.isColor or not term.isColor() then
    error('Basalt requires an advanced (golden) computer to run.', 0)
end

local function stop()
    updaterActive = false    
    baseTerm.clear()
    baseTerm.setCursorPos(1, 1)
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

    stop = stop,
    newFrame = Frame,

    getDirectory = function()
        return projectDirectory
    end
}

local basaltError = function(errMsg)
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

local function handleSchedules(event, p1, p2, p3, p4)
    if(#schedules>0)then
        local finished = {}
        for n=1,#schedules do
            if(schedules[n]~=nil)then 
                if (coroutine.status(schedules[n]) == "suspended")then
                    local ok, result = coroutine.resume(schedules[n], event, p1, p2, p3, p4)
                    if not(ok)then
                        basaltError(result)
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

local function basaltUpdateEvent(event, p1, p2, p3, p4)
    if(basaltEvent:sendEvent("basaltEventCycle", event, p1, p2, p3, p4)==false)then return end
    if(mainFrame~=nil)then
        if (event == "mouse_click") then
            mainFrame:mouseHandler(p1, p2, p3, false)
            activeFrame = mainFrame
        elseif (event == "mouse_drag") then
            mainFrame:dragHandler(p1, p2, p3, p4)
            activeFrame = mainFrame
        elseif (event == "mouse_up") then
            mainFrame:mouseUpHandler(p1, p2, p3, p4)
            activeFrame = mainFrame
        elseif (event == "mouse_scroll") then
            mainFrame:scrollHandler(p1, p2, p3, p4)
            activeFrame = mainFrame
        end
    end
    if(event == "monitor_touch") then
        if(monFrames[p1]~=nil)then
            monFrames[p1]:mouseHandler(1, p2, p3, true)
            activeFrame = monFrames[p1]
        end
        if(count(monGroups)>0)then
            for k,v in pairs(monGroups)do
                v[1]:mouseHandler(1, p2, p3, true, p1)
            end
        end
    end



    if(event == "char")then
        if(activeFrame~=nil)then
            activeFrame:charHandler(p1)
        end
    end
    if(event == "key_up")then
        if(activeFrame~=nil)then
            activeFrame:keyUpHandler(p1)
        end
        activeKey[p1] = false
    end
    if(event == "key")then
        if(activeFrame~=nil)then
            activeFrame:keyHandler(p1, p2)
        end
        activeKey[p1] = true
    end
    if(event == "terminate")then
        if(activeFrame~=nil)then
            activeFrame:eventHandler(event)
            if(updaterActive==false)then return end
        end
    end
    if(event~="mouse_click")and(event~="mouse_up")and(event~="mouse_scroll")and(event~="mouse_drag")and(event~="key")and(event~="key_up")and(event~="char")and(event~="terminate")then
        for k, v in pairs(frames) do
            v:eventHandler(event, p1, p2, p3, p4)
        end
    end
    handleSchedules(event, p1, p2, p3, p4)
    drawFrames()
end

basalt = {
    logging = false,
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
    
    update = function(event, p1, p2, p3, p4)
        if (event ~= nil) then
            local ok, err = xpcall(basaltUpdateEvent, debug.traceback, event, p1, p2, p3, p4)
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

    schedule = function(f)
        assert(f~="function", "Schedule needs a function in order to work!")
        return function(...)
            local co = coroutine.create(f)
            local ok, result = coroutine.resume(co, ...)
            if(ok)then
                table.insert(schedules, co)
            else
                basaltError(result)
            end
        end
    end,
    
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
