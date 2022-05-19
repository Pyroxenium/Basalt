local updaterActive = false
local function basaltUpdateEvent(event, p1, p2, p3, p4)
    if (event == "mouse_click") then
        activeFrame:mouseClickHandler(event, p1, p2, p3, p4)
    end
    if (event == "mouse_drag") then
        activeFrame:mouseClickHandler(event, p1, p2, p3, p4)
    end
    if (event == "mouse_up") then
        activeFrame:mouseClickHandler(event, p1, p2, p3, p4)
    end
    if (event == "mouse_scroll") then
        activeFrame:mouseClickHandler(event, p1, p2, p3, p4)
    end
    if (event == "key") or (event == "char") then
        activeFrame:keyHandler(event, p1)
        activeFrame:backgroundKeyHandler(event, p1)
    end
    for _, value in pairs(frames) do
        value:eventHandler(event, p1, p2, p3, p4)
    end
    if (updaterActive) then
        activeFrame:draw()
        drawHelper.update()
    end
end

function basalt.autoUpdate(isActive)
    parentTerminal.clear()
    updaterActive = isActive or true
    activeFrame:draw()
    drawHelper.update()
    while updaterActive do
        local event, p1, p2, p3, p4 = os.pullEventRaw() -- change to raw later
        basaltUpdateEvent(event, p1, p2, p3, p4)
    end
end

function basalt.update(event, p1, p2, p3, p4)
    if (event ~= "nil") then
        basaltUpdateEvent(event, p1, p2, p3, p4)
    else
        activeFrame:draw()
        drawHelper.update()
    end
end

function basalt.stop()
    updaterActive = false
end

function basalt.getFrame(name)
    for _, value in pairs(frames) do
        if (value.name == name) then
            return value
        end
    end
end

function basalt.getActiveFrame()
    return activeFrame
end

function basalt.setActiveFrame(frame)
    if (frame:getType() == "Frame") then
        activeFrame = frame
        return true
    end
    return false
end

function basalt.createFrame(name)
    local frame = Frame(name)
    return frame
end

function basalt.removeFrame(name)
    for key, value in pairs(frames) do
        if (value.name == name) then
            frames[key] = nil
            return true
        end
    end
    return false
end

if (basalt.debugger) then
    basalt.debugFrame = basalt.createFrame("basaltDebuggingFrame"):showBar():setBackground(colors.lightGray):setBar("Debug", colors.black, colors.gray)
    basalt.debugList = basalt.debugFrame:addList("debugList"):setSize(basalt.debugFrame.width - 2, basalt.debugFrame.height - 3):setPosition(2, 3):setScrollable(true):show()
    basalt.debugFrame:addButton("back"):setAnchor("right"):setSize(1, 1):setText("\22"):onClick(function()
        basalt.oldFrame:show()
    end)  :setBackground(colors.red):show()
    basalt.debugLabel = basalt.debugFrame:addLabel("debugLabel"):onClick(function()
        basalt.oldFrame = activeFrame
        basalt.debugFrame:show()
    end)                      :setBackground(colors.black):setForeground(colors.white):setAnchor("bottom"):setZIndex(20):show()
end

if (basalt.debugger) then
    function basalt.debug(...)
        local args = { ... }
        if (activeFrame.name ~= "basaltDebuggingFrame") then
            if (activeFrame ~= basalt.debugLabel.frame) then
                basalt.debugLabel:setParent(activeFrame)
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
        basalt.debugLabel:show()
    end
end

return basalt