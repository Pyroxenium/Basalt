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

        node = {
            getChildren = function()
                return children
            end,

            setParent = function(p)
                parent = p
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
            end,

            isExpanded = function()
                return expanded
            end,

            setExpandable = function(expandable)
                expandable = expandable
                base:updateDraw()
            end,

            isExpandable = function()
                return expandable
            end,

            removeChild = function(index)
                table.remove(children, index)
            end,

            findChildrenByText = function(searchText)
                local foundNodes = {}
                for _, child in ipairs(children) do
                    if child.getText() == searchText then
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

        mouseHandler = function(self, button, x, y)
            if base.mouseHandler(self, button, x, y) then
                local currentLine = 1 - yOffset
                local obx, oby = self:getAbsolutePosition()
                local w, h = self:getSize()
                local function checkNodeClick(node, level)
                    if y == oby+currentLine-1 then
                        if x >= obx and x < obx + w then
                            node.setExpanded(not node.isExpanded())
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