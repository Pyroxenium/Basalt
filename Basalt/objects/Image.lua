local images = require("images")
local bimg = require("bimg")
local unpack,sub,max,min = table.unpack,string.sub,math.max,math.min
return function(name, basalt)
    -- Image
    local base = basalt.getObject("VisualObject")(name, basalt)
    local objectType = "Image"

    local bimgLibrary = bimg()
    local bimgFrame = bimgLibrary.getFrameObject(1)
    local originalImage
    local image
    local activeFrame = 1

    local infinitePlay = false
    local animTimer
    local usePalette = false

    local xOffset, yOffset = 0, 0

    base:setSize(24, 8)
    base:setZIndex(2)

    local function getPalette(id)
        local p = {}
        for k,v in pairs(colors)do
            if(type(v)=="number")then
                p[k] = {term.nativePaletteColor(v)}
            end
        end
        local globalPalette = bimgLibrary.getMetadata("palette")
        if(globalPalette~=nil)then
            for k,v in pairs(globalPalette)do
                p[k] = tonumber(v)
            end
        end
        local localPalette = bimgLibrary.getFrameData("palette")
        basalt.log(localPalette)
        if(localPalette~=nil)then
            for k,v in pairs(localPalette)do
                p[k] = tonumber(v)
            end
        end
        return p
    end

    local object = {
        getType = function(self)
            return objectType
        end,
        isType = function(self, t)
            return objectType==t or base.isType~=nil and base.isType(t) or false
        end,

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
            return xOffset, yOffset
        end,

        selectFrame = function(self, id)
            if(bimgLibrary.getFrameObject(id)==nil)then
                bimgLibrary.addFrame(id)
            end
            bimgFrame = bimgLibrary.getFrameObject(id)
            image = bimgFrame.getImage(id)
            selectedFrame = id
            self:updateDraw()
        end,

        addFrame = function(self, id)
            bimgLibrary.addFrame(id)
            return self
        end,

        getFrame = function(self, id)
            return bimgLibrary.getFrame(id)
        end,

        getFrameObject = function(self, id)
            return bimgLibrary.getFrameObject(id)
        end,

        removeFrame = function(self, id)
            bimgLibrary.removeFrame(id)
            return self
        end,

        moveFrame = function(self, id, dir)
            bimgLibrary.moveFrame(id, dir)
            return self
        end,

        getFrames = function(self)
            return bimgLibrary.getFrames()
        end,

        getFrameCount = function(self)
            return #bimgLibrary.getFrames()
        end,

        getActiveFrame = function(self)
            return activeFrame
        end,

        loadImage = function(self, path)
            if(fs.exists(path))then
                local newBimg = images.loadBIMG(path)
                bimgLibrary = bimg(newBimg)
                selectedFrame = 1
                bimgFrame = bimgLibrary.getFrameObject(1)
                originalImage = bimgLibrary.createBimg()
                image = bimgFrame.getImage()
                self:updateDraw()
            end     
            return self
        end,

        setImage = function(self, t)
            if(type(t)=="table")then
                bimgLibrary = bimg(t)
                selectedFrame = 1
                bimgFrame = bimgLibrary.getFrameObject(1)
                originalImage = bimgLibrary.createBimg()
                image = bimgFrame.getImage()
                self:updateDraw()
            end
            return self
        end,

        clear = function(self)
            bimgLibrary = bimg()
            bimgFrame = bimgLibrary.getFrameObject(1)
            image = nil
            self:updateDraw()
            return self
        end,

        getImage = function(self)
            return bimgLibrary.createBimg()
        end,

        getImageFrame = function(self, id)
            return bimgFrame.getImage(id)
        end,

        usePalette = function(self, use)
            usePalette = use~=nil and use or true
            return self
        end,

        play = function(self, inf)
            if(bimgLibrary.getMetadata("animated"))then
                local t = bimgLibrary.getMetadata("duration") or bimgLibrary.getMetadata("secondsPerFrame") or 0.2
                self:listenEvent("other_event")
                animTimer = os.startTimer(t)
                infinitePlay = inf or false
            end
            return self
        end,

        stop = function(self)
            os.cancelTimer(animTimer)
            animTimer = nil
            infinitePlay = false
            return self
        end,

        eventHandler = function(self, event, timerId, ...)
            base.eventHandler(self, event, timerId, ...)
            if(event=="timer")then
                if(timerId==animTimer)then
                    if(bimgLibrary.getFrame(activeFrame+1)~=nil)then
                        activeFrame = activeFrame + 1
                        self:selectFrame(activeFrame)
                        local t = bimgLibrary.getFrameData(activeFrame, "duration") or bimgLibrary.getMetadata("secondsPerFrame") or 0.2
                        animTimer = os.startTimer(t)
                    else
                        if(infinitePlay)then
                            activeFrame = 1
                            self:selectFrame(activeFrame)
                            local t = bimgLibrary.getFrameData(activeFrame, "duration") or bimgLibrary.getMetadata("secondsPerFrame") or 0.2
                            animTimer = os.startTimer(t)
                        end
                    end
                    self:updateDraw()
                end
            end
        end,

        setMetadata = function(self, key, value)
            bimgLibrary.setMetadata(key, value)
            return self
        end,

        getMetadata = function(self, key)
            return bimgLibrary.getMetadata(key)
        end,

        getFrameMetadata = function(self, id, key)
            return bimgLibrary.getFrameData(id, key)
        end,

        setFrameMetadata = function(self, id, key, value)
            bimgLibrary.setFrameData(id, key, value)
            return self
        end,

        blit = function(self, text, fg, bg, _x, _y)
            x = _x or x
            y = _y or y
            bimgFrame.blit(text, fg, bg, x, y)
            image = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        setText = function(self, text, _x, _y)
            x = _x or x
            y = _y or y
            bimgFrame.text(text, x, y)
            image = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        setBg = function(self, bg, _x, _y)
            x = _x or x
            y = _y or y
            bimgFrame.bg(bg, x, y)
            image = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        setFg = function(self, fg, _x, _y)
            x = _x or x
            y = _y or y
            bimgFrame.fg(fg, x, y)
            image = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        getImageSize = function(self)
            return bimgLibrary.getSize()
        end,

        setImageSize = function(self, w, h)
            bimgLibrary.setSize(w, h)
            image = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        resizeImage = function(self, w, h)
            local newBimg = images.resizeBIMG(originalImage, w, h)
            bimgLibrary = bimg(newBimg)
            selectedFrame = 1
            bimgFrame = bimgLibrary.getFrameObject(1)
            image = bimgFrame.getImage()
            self:updateDraw()
            return self
        end,

        draw = function(self)
            base.draw(self)
            self:addDraw("image", function()
                local w,h = self:getSize()
                local x, y = self:getPosition()
                local wParent, hParent = self:getParent():getSize()
                local parentXOffset, parentYOffset = self:getParent():getOffset()
                
                if(x - parentXOffset > wParent)or(y - parentYOffset > hParent)or(x - parentXOffset + w < 1)or(y - parentYOffset + h < 1)then
                    return
                end

                if(usePalette)then
                    self:getParent():setPalette(getPalette(activeFrame))
                end

                if(image~=nil)then
                    for k,v in pairs(image)do
                        if(k+yOffset<=h)and(k+yOffset>=1)then
                            local t,f,b = v[1],v[2],v[3]

                            local startIdx = max(1 - xOffset, 1)
                            local endIdx = min(w - xOffset, #t)
                            
                            t = sub(t, startIdx, endIdx)
                            f = sub(f, startIdx, endIdx)
                            b = sub(b, startIdx, endIdx)

                            self:addBlit(max(1 + xOffset, 1), k + yOffset, t, f, b)
                        end
                    end
                end
            end)
        end,
    }

    object.__index = object
    return setmetatable(object, base)
end