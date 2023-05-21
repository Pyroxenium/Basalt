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
            getChildren = function(self)
                return children
            end,

            setParent = function(self, p)
                if(parent~=nil)then
                    parent.removeChild(parent.findChildrenByText(node.getText()))
                end
                parent = p
                base:updateDraw()
                return node
            end,

            getParent = function(self)
                return parent
            end,

            addChild = function(self, text, expandable)
                local childNode = newNode(text, expandable)
                childNode.setParent(node)
                table.insert(children, childNode)
                base:updateDraw()
                return childNode
            end,

            setExpanded = function(self, exp)
                if(expandable)then
                    expanded = exp
                end
                base:updateDraw()
                return node
            end,

            isExpanded = function(self)
                return expanded
            end,

            onSelect = function(self, ...)
                for _,v in pairs(table.pack(...))do
                    if(type(v)=="function")then
                        onSelect = v
                    end
                end
                return node
            end,

            callOnSelect = function(self)
                if(onSelect~=nil)then
                    onSelect(node)
                end
            end,

            setExpandable = function(self, expandable)
                expandable = expandable
                base:updateDraw()
                return node
            end,

            isExpandable = function(self)
                return expandable
            end,

            removeChild = function(self, index)
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

            findChildrenByText = function(self, searchText)
                local foundNodes = {}
                for _, child in ipairs(children) do
                    if string.find(child.getText(), searchText) then
                        table.insert(foundNodes, child)
                    end
                end
                return foundNodes
            end,

            getText = function(self)
                return text
            end,

            setText = function(self, t)
                text = t
                base:updateDraw()
                return node
            end
        }

        return node
    end

    local root = newNode("Root", true)
    root:setExpanded(true)

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

        setXOffset = function(self, x)
            return self:setOffset(x, yOffset)
        end,

        setYOffset = function(self, y)
            return self:setOffset(xOffset, y)
        end,

        getOffset = function(self)
            return xOffset, yOffset
        end,

        getXOffset = function(self)
            return xOffset
        end,

        getYOffset = function(self)
            return yOffset
        end,

        setScrollable = function(self, scroll)
            scrollable = scroll
            return self
        end,

        getScrollable = function(self, scroll)
            return scrollable
        end,

        setSelectionColor = function(self, bgCol, fgCol, active)
            itemSelectedBG = bgCol or self:getBackground()
            itemSelectedFG = fgCol or self:getForeground()
            selectionColorActive = active~=nil and active or true
            self:updateDraw()
            return self
        end,

        setSelectionBG = function(self, bgCol)
            return self:setSelectionColor(bgCol, nil, selectionColorActive)
        end,

        setSelectionFG = function(self, fgCol)
            return self:setSelectionColor(nil, fgCol, selectionColorActive)
        end,

        getSelectionColor = function(self)
            return itemSelectedBG, itemSelectedFG
        end,

        getSelectionBG = function(self)
            return itemSelectedBG
        end,

        getSelectionFG = function(self)
            return itemSelectedFG
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
                            node:setExpanded(not node:isExpanded())
                            self:selectionHandler(node)
                            self:setValue(node)
                            self:updateDraw()
                            return true
                        end
                    end
                    currentLine = currentLine + 1
                    if node:isExpanded() then
                        for _, child in ipairs(node:getChildren()) do
                            if checkNodeClick(child, level + 1) then
                                return true
                            end
                        end
                    end
                    return false
                end
        
                for _, item in ipairs(root:getChildren()) do
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
                            if node:isExpanded() then
                                for _, child in ipairs(node:getChildren()) do
                                    countVisibleLines(child, level + 1)
                                end
                            end
                        end
        
                        for _, item in ipairs(root:getChildren()) do
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
                               
                    if node:isExpanded() then
                        for _, child in ipairs(node:getChildren()) do
                            drawNode(child, level + 1)
                        end
                    end
                end
        
                for _, item in ipairs(root:getChildren()) do
                    drawNode(item, 1)
                end
            end)
        end,


    }

    object.__index = object
    return setmetatable(object, base)
end