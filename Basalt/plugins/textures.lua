local images = require("images")

local sub = string.sub

return {
    VisualObject = function(base)
        local images = {}

        local object = {
            addTexture = function(self, path, x, y, w, h, stretch, animate, infinitePlay)
                if(type(path)=="function")then
                    table.insert(images, path)
                else
                    if(type(path)=="table")then
                        x, y, w, h, stretch, animate, infinitePlay = path.x, path.y, path.w, path.h, path.stretch, path.animate, path.infinitePlay
                        path = path.path
                    end
                    local img = images.loadImageAsBimg(path)
                    local newEntry = {
                        image = img,
                        x = x,
                        y = y,
                        w = w,
                        h = h,
                        animated = animate,
                        curTextId = 1,
                        infinitePlay = infinitePlay,
                    }
                    if(stretch)then
                        newEntry.w = self:getWidth()
                        newEntry.h = self:getHeight()
                        newEntry.image = images.resizeBIMG(img, newEntry.w, newEntry.h)
                    end
                    table.insert(images, newEntry)
                    if(animate)then
                        if(img.animated)then
                            self:listenEvent("other_event")
                            local t = img[newEntry.curTextId].duration or img.secondsPerFrame or 0.2
                            newEntry.timer = os.startTimer(t)
                        end
                    end
                end
                self:setDrawState("texture-base", true)
                self:updateDraw()
                return self
            end,

            removeTexture = function(self, id)
                table.remove(images, id)
                if(#images==0)then
                    self:setDrawState("texture-base", false)
                end
                self:updateDraw()
                return self
            end,

            clearTextures = function(self)
                images = {}
                self:setDrawState("texture-base", false)
                self:updateDraw()
                return self
            end,

            eventHandler = function(self, event, timerId, ...)
                base.eventHandler(self, event, timerId, ...)
                if(event=="timer")then
                    for _,v in pairs(images)do
                        if(type(v)=="table")then
                            if(v.timer==timerId)then
                                if(v.animated)then
                                    if(v.image[v.curTextId+1]~=nil)then
                                        v.curTextId = v.curTextId + 1
                                        local t = v.image[v.curTextId].duration or v.image.secondsPerFrame or 0.2
                                        v.timer = os.startTimer(t)
                                        self:updateDraw()
                                    else
                                        if(v.infinitePlay)then
                                            v.curTextId = 1
                                            local t = v.image[v.curTextId].duration or v.image.secondsPerFrame or 0.2
                                            v.timer = os.startTimer(t)
                                            self:updateDraw()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end,

            draw = function(self)
                base.draw(self)
                self:addDraw("texture-base", function()
                    for _,v in pairs(images)do
                        if(type(v)=="table")then
                            local tWidth = #v.image[v.curTextId][1][1]
                            local tHeight = #v.image[v.curTextId][1]
                            local textureWidth = v.w>tWidth and tWidth or v.w
                            local textureHeight = v.h>tHeight and tHeight or v.h
                            for k = 1, textureHeight do
                                if(v.image[k]~=nil)then
                                local t, f, b = table.unpack(v.image[k])
                                    self:addBlit(1, k, sub(t, 1, textureWidth), sub(f, 1, textureWidth), sub(b, 1, textureWidth))
                                end
                            end
                        else
                            if(type(v)=="function")then
                                v(self)
                            end
                        end
                    end
                end)
                self:setDrawState("texture-base", false)
            end
        }

        return object
    end
}