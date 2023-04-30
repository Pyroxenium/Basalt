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
            debugFrame = mainFrame:addMovableFrame("basaltDebuggingFrame"):setSize(w-20, h-10):setBackground(colors.lightGray):setForeground(colors.white):setZIndex(100):hide()
            debugFrame:addPane():setSize("parent.w", 1):setPosition(1, 1):setBackground(colors.black):setForeground(colors.white)
            debugFrame:setPosition(-w, h/2-debugFrame:getHeight()/2):setBorder(colors.black)
            local resizeButton = debugFrame:addButton()
                :setPosition("parent.w", "parent.h")
                :setSize(1, 1)
                :setText("\133")
                :setForeground(colors.lightGray)
                :setBackground(colors.black)
                :onClick(function(self, event, btn, xOffset, yOffset)
                end)
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

            debugExitButton = debugFrame:addButton():setText("Exit"):setPosition("parent.w - 6", 1):setSize(7, 1):setBackground(colors.red):setForeground(colors.white):onClick(function() 
                debugFrame:animatePosition(-w, h/2-debugFrame:getHeight()/2, 0.5)
            end)
            debugList = debugFrame:addList():setSize("parent.w - 2", "parent.h - 3"):setPosition(2, 3):setBackground(colors.lightGray):setForeground(colors.white):setSelectionColor(colors.lightGray, colors.gray)
            if(debugLabel==nil)then 
                debugLabel = mainFrame:addLabel()
                :setPosition(1, "parent.h")
                :setBackground(colors.black)
                :setForeground(colors.white)
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