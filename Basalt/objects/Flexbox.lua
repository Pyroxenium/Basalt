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