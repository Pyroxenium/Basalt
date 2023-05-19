
local function flexObjectPlugin(base, basalt)
    local flexGrow = 0
    local flexShrink = 0
    local flexBasis = 12

    local object = {
        getFlexGrow = function(self)
            return flexGrow
        end,

        setFlexGrow = function(self, value)
            flexGrow = value
            return self
        end,

        getFlexShrink = function(self)
            return flexShrink
        end,

        setFlexShrink = function(self, value)
            flexShrink = value
            return self
        end,

        getFlexBasis = function(self)
            return flexBasis
        end,

        setFlexBasis = function(self, value)
            flexBasis = value
            return self
        end
    }

    for k,v in pairs(object)do
        base[k] = v
    end

    return base
end

return function(name, basalt)
    local base = basalt.getObject("ScrollableFrame")(name, basalt)
    local objectType = "Flexbox"

    local direction = "row"
    local spacing = 1
    local justifyContent = "flex-start"
    local wrap = "nowrap"
    local children = {}
    local sortedChildren = {}
    local updateLayout = false
    local lineBreakFakeObject = flexObjectPlugin({
        getHeight = function(self) return 0 end,
        getWidth = function(self) return 0 end,
        getPosition = function(self) return 0, 0 end,
        getSize = function(self) return 0, 0 end,
        isType = function(self) return false end,
        getType = function(self) return "lineBreakFakeObject" end,
        setPosition = function(self) end,
        setSize = function(self) end,
    })
    lineBreakFakeObject:setFlexBasis(0)

    local function sortChildren(self)
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
                    sortedChildren[index] = {offset=lineOffset, v}
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

            for _,v in pairs(children)do
                if(sortedChildren[index]==nil)then sortedChildren[index]={offset=1} end

                local childHeight = direction == "row" and v:getHeight() or v:getWidth()
                if childHeight > lineSize then
                    lineSize = childHeight
                end

                if v == lineBreakFakeObject then
                    lineOffset = lineOffset + lineSize + spacing
                    lineSize = 1
                    index = index + 1
                    sortedChildren[index] = {offset=lineOffset, v}
                else
                    local objSize = direction == "row" and v:getWidth() or v:getHeight()
                    if(objSize+usedSize>maxSize)then
                        lineOffset = lineOffset + lineSize + spacing
                        lineSize = direction == "row" and v:getHeight() or v:getWidth()
                        index = index + 1
                        usedSize = objSize + spacing
                        sortedChildren[index] = {offset=lineOffset, v}
                    else
                        usedSize = usedSize + objSize + spacing
                        table.insert(sortedChildren[index], v)
                    end
                end
            end
        end
    end

    local function calculateRow(self, children)
        local containerWidth, containerHeight = self:getSize()
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

                if totalFlexGrow > 0 then
                    childWidth = child:getFlexBasis() + flexGrow / totalFlexGrow * remainingSpace
                else
                    childWidth = child:getFlexBasis()
                end

                if remainingSpace < 0 and totalFlexShrink > 0 then
                    childWidth = child:getFlexBasis() + flexShrink / totalFlexShrink * remainingSpace
                end

                child:setPosition(currentX, children.offset or 1)
                child:setSize(childWidth, child:getHeight())
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

                if totalFlexGrow > 0 then
                    childHeight = child:getFlexBasis() + flexGrow / totalFlexGrow * remainingSpace
                else
                    childHeight = child:getFlexBasis()
                end

                if remainingSpace < 0 and totalFlexShrink > 0 then
                    childHeight = child:getFlexBasis() + flexShrink / totalFlexShrink * remainingSpace
                end

                child:setPosition(children.offset, currentY)
                child:setSize(child:getWidth(), childHeight)
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
        if direction == "row" then
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
        getType = function()
            return objectType
        end,

        isType = function(self, t)
            return objectType == t or base.isType ~= nil and base.isType(t) or false
        end,

        setJustifyContent = function(self, value)
            justifyContent = value
            updateLayout = true
            return self
        end,

        getJustifyContent = function(self)
            return justifyContent
        end,

        setDirection = function(self, value)
            direction = value
            updateLayout = true
            return self
        end,

        getDirection = function(self)
            return direction
        end,

        setSpacing = function(self, value)
            spacing = value
            updateLayout = true
            return self
        end,

        getSpacing = function(self)
            return spacing
        end,

        setWrap = function(self, value)
            wrap = value
            updateLayout = true
            return self
        end,

        updateLayout = function(self)
            updateLayout = true
        end,

        addBreak = function(self)
            table.insert(children, lineBreakFakeObject)
            updateLayout = true
            return self
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

