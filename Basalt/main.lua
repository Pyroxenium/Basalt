local basaltEvent = require("basaltEvent")()
local Frame = require("Frame")
local theme = require("theme")
local uuid = require("utils").uuid

local baseTerm = term.current()
local version = 4
local debugger = true

local projectDirectory = fs.getDir(table.pack(...)[2] or "")

local activeKey, frames, monFrames, variables = {}, {}, {}, {}
local mainFrame, activeFrame, focusedObject, updaterActive

if not  term.isColor or not term.isColor() then
    error('Basalt requires an advanced (golden) computer to run.', 0)
end

local function stop()
    updaterActive = false
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
        return monFrames[name]
    end,

    setMonitorFrame = function(name, frame)
        monFrames[name] = frame
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

local function drawFrames()
    if(updaterActive)then
        if(mainFrame~=nil)then
            mainFrame:draw()
            mainFrame:drawUpdate()
        end
        for _,v in pairs(monFrames)do
            v:draw()
            v:drawUpdate()
        end
    end
end

local function basaltUpdateEvent(event, p1, p2, p3, p4)
    if(basaltEvent:sendEvent("basaltEventCycle", event, p1, p2, p3, p4)==false)then return end
    if(mainFrame~=nil)then
        if (event == "mouse_click") then
            mainFrame:mouseHandler(event, p1, p2, p3, p4)
            activeFrame = mainFrame
        elseif (event == "mouse_drag") then
            mainFrame:mouseHandler(event, p1, p2, p3, p4)
            activeFrame = mainFrame
        elseif (event == "mouse_up") then
            mainFrame:mouseHandler(event, p1, p2, p3, p4)
            activeFrame = mainFrame
        elseif (event == "mouse_scroll") then
            mainFrame:mouseHandler(event, p1, p2, p3, p4)
            activeFrame = mainFrame
        elseif (event == "monitor_touch") then
            if(monFrames[p1]~=nil)then
                monFrames[p1]:mouseHandler(event, p1, p2, p3, p4)
                activeFrame = monFrames[p1]
            end
        end
    end

    if(event == "key") or (event == "char") then
        if(activeFrame~=nil)then
            activeFrame:keyHandler(event, p1)
            activeFrame:backgroundKeyHandler(event, p1)
        end
    end

    if(event == "key")then
        activeKey[p1] = true
    end

    if(event == "key_up")then
        activeKey[p1] = false
    end

    for _, v in pairs(frames) do
        v:eventHandler(event, p1, p2, p3, p4)
    end
    drawFrames()
end

local basalt = {}
basalt = {
    setTheme = setTheme,
    getTheme = getTheme,
    getVersion = function()
        return version
    end,

    setVariable = setVariable,
    getVariable = getVariable,

    setBaseTerm = function(_baseTerm)
        baseTerm = _baseTerm
    end,

    autoUpdate = function(isActive)
        updaterActive = isActive
        if(isActive==nil)then updaterActive = true end
        drawFrames()
        while updaterActive do
            local event, p1, p2, p3, p4 = os.pullEventRaw()
            basaltUpdateEvent(event, p1, p2, p3, p4)
        end
    end,
    
    update = function(event, p1, p2, p3, p4)
        if (event ~= nil) then
            basaltUpdateEvent(event, p1, p2, p3, p4)
        end
    end,
    
    stop = stop,
    
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
    
    createFrame = function(name)
        name = name or uuid()
        for _, v in pairs(frames) do
            if (v.name == name) then
                return nil
            end
        end
        local newFrame = Frame(name,nil,nil,bInstance)
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
        basalt.debugList:addItem(str)
        if (basalt.debugList:getItemCount() > 50) then
            basalt.debugList:removeItem(1)
        end
        basalt.debugList:setValue(basalt.debugList:getItem(basalt.debugList:getItemCount()))
        if(basalt.debugList.getItemCount() > basalt.debugList:getHeight())then
            basalt.debugList:setIndexOffset(basalt.debugList:getItemCount() - basalt.debugList:getHeight())
        end
        basalt.debugLabel:show()
    end,
}

basalt.debugFrame = basalt.createFrame("basaltDebuggingFrame"):showBar():setBackground(colors.lightGray):setBar("Debug", colors.black, colors.gray)
basalt.debugFrame:addButton("back"):setAnchor("topRight"):setSize(1, 1):setText("\22"):onClick(function() if(basalt.oldFrame~=nil)then basalt.oldFrame:show() end end):setBackground(colors.red):show()
basalt.debugList = basalt.debugFrame:addList("debugList"):setSize(basalt.debugFrame.width - 2, basalt.debugFrame.height - 3):setPosition(2, 3):setScrollable(true):show()
basalt.debugLabel = basalt.debugFrame:addLabel("debugLabel"):onClick(function() basalt.oldFrame = mainFrame basalt.debugFrame:show() end):setBackground(colors.black):setForeground(colors.white):setAnchor("bottomLeft"):ignoreOffset():setZIndex(20):show()

return basalt