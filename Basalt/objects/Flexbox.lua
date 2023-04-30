return function(name, basalt)
    local base = basalt.getObject("Frame")(name, basalt)
    local objectType = "Flexbox"

    local flexDirection = "row" -- "row" oder "column"
    local justifyContent = "flex-start" -- "flex-start", "flex-end", "center", "space-between", "space-around"
    local spacing = 1

    local function applyLayout(self)
        local objects = self:getObjects()
        local totalElements = #objects
        local _, _ = self:getPosition()
        local width, height = self:getSize()
    
        local totalChildSize = 0
        for _, obj in ipairs(objects) do
            if flexDirection == "row" then
                local objWidth, _ = obj.element:getSize()
                totalChildSize = totalChildSize + objWidth
            else
                local _, objHeight = obj.element:getSize()
                totalChildSize = totalChildSize + objHeight
            end
        end
    
        local availableSpace = (flexDirection == "row" and width or height) - totalChildSize - (spacing * (totalElements - 1))
    
        local currentOffset = 0
        if justifyContent == "center" then
            currentOffset = availableSpace / 2
        elseif justifyContent == "flex-end" then
            currentOffset = availableSpace
        end
    
        for _, obj in ipairs(objects) do
            if flexDirection == "row" then
                obj.element:setPosition(currentOffset, 1) -- Ändere den y-Wert auf 1
                local objWidth, _ = obj.element:getSize()
                currentOffset = currentOffset + objWidth + spacing
            else
                obj.element:setPosition(1, math.floor(currentOffset+0.5)) -- Ändere den x-Wert auf 1
                local _, objHeight = obj.element:getSize()
                currentOffset = currentOffset + objHeight + spacing
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