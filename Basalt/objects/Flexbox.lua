
local function flexObjectPlugin(base, basalt)
    local baseWidth, baseHeight = base:getSize()

    if(base:getType()~="lineBreakFakeObject")then
        base:addProperty("FlexGrow", "number", 0)
        base:addProperty("FlexShrink", "number", 0)
        base:addProperty("FlexBasis", "number", 0)
    end

    local object = {
        getBaseSize = function(self)
            return baseWidth, baseHeight
        end,

        getBaseWidth = function(self)
            return baseWidth
        end,

        getBaseHeight = function(self)
            return baseHeight
        end,

        setSize = function(self, width, height, rel, internalCall)
            base.setSize(self, width, height, rel)
            if not internalCall then
                baseWidth, baseHeight = base:getSize()
            end
            return self
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end

return function(name, basalt)
    local base = basalt.getObject("ScrollableFrame")(name, basalt)
    base:setType("Flexbox")

    local updateLayout = false

    base:addProperty("FlexDirection", {"row", "column"}, "row", nil, function(self, direction)
        if(direction=="row")then
            base:setDirection("horizontal")
        elseif(direction=="column")then
            base:setDirection("vertical")
        end
    end)
    base:addProperty("Spacing", "number", 1, nil, function(self, spacing)
        updateLayout = true
    end)
    base:addProperty("JustifyContent", {"flex-start", "flex-end", "center", "space-between", "space-around", "space-evenly"}, "flex-start", nil, function(self, justifyContent)
        updateLayout = true
    end)
    base:addProperty("Wrap", {"nowrap", "wrap"}, "nowrap", nil, function(self, wrap)
        updateLayout = true
    end)

    local children = {}
    local sortedChildren = {}
    local lineBreakFakeObject = flexObjectPlugin({
        getBaseHeight = function(self) return 0 end,
        getBaseWidth = function(self) return 0 end,
        getPosition = function(self) return 0, 0 end,
        getSize = function(self) return 0, 0 end,
        isType = function(self) return false end,
        getType = function(self) return "lineBreakFakeObject" end,
        setPosition = function(self) end,
        setSize = function(self) end,
        getFlexGrow = function(self) return 0 end,
        getFlexShrink = function(self) return 0 end,
        getFlexBasis = function(self) return 0 end,
    })
    local function sortChildren(self)
        local direction = self:getDirection()
        local spacing = self:getSpacing()
        local wrap = self:getWrap()

        if(wrap=="nowrap")then
            sortedChildren = {}
            local index = 1
            local lineSize = 1
            local lineOffset = 1
            for _,v in pairs(children)do
                if(sortedChildren[index]==nil)then sortedChildren[index]={offset=1} end

                local childHeight = direction == "row" and v:getHeight() or v:getWidth()
                if childHeight > lineSize then
                    lineSize = childHeight
                end
                if(v == lineBreakFakeObject)then
                    lineOffset = lineOffset + lineSize + spacing
                    lineSize = 1
                    index = index + 1
                    sortedChildren[index] = {offset=lineOffset}
                else
                    table.insert(sortedChildren[index], v)
                end
            end
        elseif(wrap=="wrap")then
            sortedChildren = {}
            local lineSize = 1
            local lineOffset = 1

            local maxSize = direction == "row" and self:getWidth() or self:getHeight()
            local usedSize = 0
            local index = 1

            for _,v in pairs(children) do
                if(sortedChildren[index]==nil) then sortedChildren[index]={offset=1} end

                if v == lineBreakFakeObject then
                    lineOffset = lineOffset + lineSize + spacing
                    usedSize = 0
                    lineSize = 1
                    index = index + 1
                    sortedChildren[index] = {offset=lineOffset}
                else
                    local objSize = direction == "row" and v:getBaseWidth() or v:getBaseHeight()
                    if(objSize+usedSize<=maxSize) then
                        table.insert(sortedChildren[index], v)
                        usedSize = usedSize + objSize + spacing
                    else
                        lineOffset = lineOffset + lineSize + spacing
                        lineSize = direction == "row" and v:getBaseHeight() or v:getBaseWidth()
                        index = index + 1
                        usedSize = objSize + spacing
                        sortedChildren[index] = {offset=lineOffset, v}
                    end

                    local childHeight = direction == "row" and v:getBaseHeight() or v:getBaseWidth()
                    if childHeight > lineSize then
                        lineSize = childHeight
                    end
                end
            end
        end
    end

    local function calculateRow(self, children)
        local containerWidth, containerHeight = self:getSize()
        local spacing = self:getSpacing()
        local justifyContent = self:getJustifyContent()

        local totalFlexGrow = 0
        local totalFlexShrink = 0
        local totalFlexBasis = 0

        for _, child in ipairs(children) do
            totalFlexGrow = totalFlexGrow + child:getFlexGrow()
            totalFlexShrink = totalFlexShrink + child:getFlexShrink()
            totalFlexBasis = totalFlexBasis + child:getFlexBasis()
        end

        local remainingSpace = containerWidth - totalFlexBasis - (spacing * (#children - 1))

        local currentX = 1
        for _, child in ipairs(children) do
            if(child~=lineBreakFakeObject)then
                local childWidth

                local flexGrow = child:getFlexGrow()
                local flexShrink = child:getFlexShrink()

                local baseWidth = child:getFlexBasis() ~= 0 and child:getFlexBasis() or child:getBaseWidth()
                if totalFlexGrow > 0 then
                    childWidth = baseWidth + flexGrow / totalFlexGrow * remainingSpace
                else
                    childWidth = baseWidth
                end

                if remainingSpace < 0 and totalFlexShrink > 0 then
                    childWidth = baseWidth + flexShrink / totalFlexShrink * remainingSpace
                end

                child:setPosition(currentX, children.offset or 1)
                child:setSize(childWidth, child:getHeight(), false, true)
                currentX = currentX + childWidth + spacing
            end
        end

        if justifyContent == "flex-end" then
            local totalWidth = currentX - spacing
            local offset = containerWidth - totalWidth + 1
            for _, child in ipairs(children) do
                local x, y = child:getPosition()
                child:setPosition(x + offset, y)
            end
        elseif justifyContent == "center" then
            local totalWidth = currentX - spacing
            local offset = (containerWidth - totalWidth) / 2 + 1
            for _, child in ipairs(children) do
                local x, y = child:getPosition()
                child:setPosition(x + offset, y)
            end
        elseif justifyContent == "space-between" then
            local totalWidth = currentX - spacing
            local offset = (containerWidth - totalWidth) / (#children - 1) + 1
            for i, child in ipairs(children) do
                if i > 1 then
                    local x, y = child:getPosition()
                    child:setPosition(x + offset * (i - 1), y)
                end
            end
        elseif justifyContent == "space-around" then
            local totalWidth = currentX - spacing
            local offset = (containerWidth - totalWidth) / #children
            for i, child in ipairs(children) do
                local x, y = child:getPosition()
                child:setPosition(x + offset * i - offset / 2, y)
            end
        elseif justifyContent == "space-evenly" then
            local numSpaces = #children + 1
            local totalChildWidth = 0
            for _, child in ipairs(children) do
                totalChildWidth = totalChildWidth + child:getWidth()
            end
            local totalSpace = containerWidth - totalChildWidth
            local offset = math.floor(totalSpace / numSpaces)
            local remaining = totalSpace - offset * numSpaces
            currentX = offset + (remaining > 0 and 1 or 0)
            remaining = remaining > 0 and remaining - 1 or 0
            for _, child in ipairs(children) do
                child:setPosition(currentX, 1)
                currentX = currentX + child:getWidth() + offset + (remaining > 0 and 1 or 0)
                remaining = remaining > 0 and remaining - 1 or 0
            end
        end
    end

    local function calculateColumn(self, children)
        local containerWidth, containerHeight = self:getSize()
        local spacing = self:getSpacing()
        local justifyContent = self:getJustifyContent()

        local totalFlexGrow = 0
        local totalFlexShrink = 0
        local totalFlexBasis = 0

        for _, child in ipairs(children) do
            totalFlexGrow = totalFlexGrow + child:getFlexGrow()
            totalFlexShrink = totalFlexShrink + child:getFlexShrink()
            totalFlexBasis = totalFlexBasis + child:getFlexBasis()
        end

        local remainingSpace = containerHeight - totalFlexBasis - (spacing * (#children - 1))

        local currentY = 1

        for _, child in ipairs(children) do
            if(child~=lineBreakFakeObject)then
                local childHeight

                local flexGrow = child:getFlexGrow()
                local flexShrink = child:getFlexShrink()

                local baseHeight = child:getFlexBasis() ~= 0 and child:getFlexBasis() or child:getBaseHeight()
                if totalFlexGrow > 0 then
                    childHeight = baseHeight + flexGrow / totalFlexGrow * remainingSpace
                else
                    childHeight = baseHeight
                end

                if remainingSpace < 0 and totalFlexShrink > 0 then
                    childHeight = baseHeight + flexShrink / totalFlexShrink * remainingSpace
                end

                child:setPosition(children.offset, currentY)
                child:setSize(child:getWidth(), childHeight, false, true)
                currentY = currentY + childHeight + spacing
            end
        end

        if justifyContent == "flex-end" then
            local totalHeight = currentY - spacing
            local offset = containerHeight - totalHeight + 1
            for _, child in ipairs(children) do
                local x, y = child:getPosition()
                child:setPosition(x, y + offset)
            end
        elseif justifyContent == "center" then
            local totalHeight = currentY - spacing
            local offset = (containerHeight - totalHeight) / 2
            for _, child in ipairs(children) do
                local x, y = child:getPosition()
                child:setPosition(x, y + offset)
            end
        elseif justifyContent == "space-between" then
            local totalHeight = currentY - spacing
            local offset = (containerHeight - totalHeight) / (#children - 1) + 1
            for i, child in ipairs(children) do
                if i > 1 then
                    local x, y = child:getPosition()
                    child:setPosition(x, y + offset * (i - 1))
                end
            end
        elseif justifyContent == "space-around" then
            local totalHeight = currentY - spacing
            local offset = (containerHeight - totalHeight) / #children
            for i, child in ipairs(children) do
                local x, y = child:getPosition()
                child:setPosition(x, y + offset * i - offset / 2)
            end
        elseif justifyContent == "space-evenly" then
            local numSpaces = #children + 1
            local totalChildHeight = 0
            for _, child in ipairs(children) do
                totalChildHeight = totalChildHeight + child:getHeight()
            end
            local totalSpace = containerHeight - totalChildHeight
            local offset = math.floor(totalSpace / numSpaces)
            local remaining = totalSpace - offset * numSpaces
            currentY = offset + (remaining > 0 and 1 or 0)
            remaining = remaining > 0 and remaining - 1 or 0
            for _, child in ipairs(children) do
                local x, y = child:getPosition()
                child:setPosition(x, currentY)
                currentY = currentY + child:getHeight() + offset + (remaining > 0 and 1 or 0)
                remaining = remaining > 0 and remaining - 1 or 0
            end
        end
    end

    local function applyLayout(self)
        sortChildren(self)
        if self:getFlexDirection() == "row" then
            for _,v in pairs(sortedChildren)do
                calculateRow(self, v)
            end
        else
            for _,v in pairs(sortedChildren)do
                calculateColumn(self, v)
            end
        end
        updateLayout = false
    end

    local object = {
        updateLayout = function(self)
            updateLayout = true
            self:updateDraw()
        end,

        addBreak = function(self)
            table.insert(children, lineBreakFakeObject)
            updateLayout = true
            self:updateDraw()
            return self
        end,

        customEventHandler = function(self, event, ...)
            base.customEventHandler(self, event, ...)
            if event == "basalt_FrameResize" then
                updateLayout = true
            end
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("flexboxDraw", function()
                if updateLayout then
                    applyLayout(self)
                end
            end, 1)
        end
    }

    for k, _ in pairs(basalt.getObjects()) do
        object["add" .. k] = function(self, name)
            local baseChild = base["add" .. k](self, name)
            local child = flexObjectPlugin(baseChild, basalt)
            table.insert(children, child)
            updateLayout = true
            return child
        end
    end

    object.__index = object
    return setmetatable(object, base)
end