local Object = require("Object")
local tHex = require("tHex")
local xmlValue = require("utils").getValueFromXML
local bimgLib = require("bimg")
local images = require("images")

local sub,len,max,min = string.sub,string.len,math.max,math.min

return function(name)
    -- Graphic
    local base = Object(name)
    local objectType = "Graphic"
    local imgData = bimgLib()
    local bimgFrame = imgData.getFrameObject(1)
    local bimg
    local selectedFrame = 1
    base:setZIndex(5)

    local xOffset, yOffset = 0, 0
   
    local object = {
        getType = function(self)
            return objectType
        end;

        setOffset = function(self, _x, _y, rel)
            if(rel)then
                xOffset = xOffset + _x or 0
                yOffset = yOffset + _y or 0
            else
                xOffset = _x or xOffset
                yOffset = _y or yOffset
            end
            self:updateDraw()
            return self
        end,

        getOffset = function(self)
            return xOffset,yOffset
        end,

        setValuesByXMLData = function(self, data)
            base.setValuesByXMLData(self, data)
        
            return self
        end,

        selectFrame = function(self, id)
            if(imgData.getFrameObject(id)==nil)then
                imgData.addFrame(id)
            end
            bimgFrame = imgData.getFrameObject(id)
            bimg = bimgFrame.getImage(id)
            selectedFrame = id
            self:updateDraw()
        end,

        addFrame = function(self, id)
            imgData.addFrame(id)
            return self
        end,

        getFrameMetadata = function(self, id, key)
            return imgData.getFrameData(id, key)
        end,

        setFrameMetadata = function(self, id, key, val)
            imgData.setFrameData(id, key, val)
            return self
        end,

        getMetadata = function(self, key)
            return imgData.getMetadata(key)
        end,

        setMetadata = function(self, key, value)
            return imgData.setMetadata(key, value)
        end,

        getFrame = function(self, id)
            return imgData.getFrame(id)
        end,

        getFrameObject = function(self, id)
            return imgData.getFrameObject(id)
        end,

        removeFrame = function(self, id)
            imgData.removeFrame(id)
            return self
        end,

        moveFrame = function(self, id, dir)
            imgData.moveFrame(id, dir)
            return self
        end,

        getFrames = function(self)
            return imgData.getFrames()
        end,

        getFrameCount = function(self)
            return #imgData.getFrames()
        end,

        getSelectedFrame = function(self)
            return selectedFrame
        end,

        blit = function(self, text, fg, bg, _x, _y)
            x = _x or x
            y = _y or y
            bimgFrame.blit(text, fg, bg, x, y)
            bimg = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        setText = function(self, text, _x, _y)
            x = _x or x
            y = _y or y
            bimgFrame.text(text, x, y)
            bimg = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        setBg = function(self, bg, _x, _y)
            x = _x or x
            y = _y or y
            bimgFrame.bg(bg, x, y)
            bimg = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        setFg = function(self, fg, _x, _y)
            x = _x or x
            y = _y or y
            bimgFrame.fg(fg, x, y)
            bimg = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        getImageSize = function(self)
            return imgData.getSize()
        end,

        setImageSize = function(self, w, h)
            imgData.setSize(w, h)
            bimg = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        resizeImage = function(self, w, h)
            local newBimg = images.resizeBIMG(imgData.createBimg(), w, h)
            imgData = bimgLib(newBimg)
            selectedFrame = 1
            bimgFrame = imgData.getFrameObject(1)
            bimg = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        loadImage = function(self, path)
            if(fs.exists(path))then
                local newBimg = images.loadBIMG(path)
                imgData = bimgLib(newBimg)
                selectedFrame = 1
                bimgFrame = imgData.getFrameObject(1)
                bimg = bimgFrame.getImage()
                self:updateDraw()
            end     
            return self
        end,

        clear = function(self)
            imgData = bimgLib()
            bimg = nil
            self:updateDraw()
            return self
        end,

        getImage = function(self)
            return imgData.createBimg()
        end,

        draw = function(self)
            if (base.draw(self)) then
                if (self.parent ~= nil) then
                    local obx, oby = self:getAnchorPosition()
                    local w,h = self:getSize()
                    if(bimg~=nil)then
                        for k,v in pairs(bimg)do
                            if(k<=h-yOffset)and(k+yOffset>=1)then
                                self.parent:blit(obx+xOffset, oby+k-1+yOffset, v[1], v[2], v[3])
                            end
                        end
                    end
                end
            end
        end,

        init = function(self)
            if(base.init(self))then
                self.bgColor = self.parent:getTheme("GraphicBG")
            end
        end,
    }

    return setmetatable(object, base)
end