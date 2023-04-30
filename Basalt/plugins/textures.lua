local images = require("images")

return {
    VisualObject = function(base)
        local textureId, infinitePlay = 1, true
        local bimg, texture, textureTimerId
        local textureMode = "default"

        local object = {
            addTexture = function(self, path, animate)
                bimg = images.loadImageAsBimg(path)
                texture = bimg[1]
                if(animate)then
                    if(bimg.animated)then
                        self:listenEvent("other_event")
                        local t = bimg[textureId].duration or bimg.secondsPerFrame or 0.2
                        textureTimerId = os.startTimer(t)
                    end
                end
                self:setBackground(false)
                self:setForeground(false)
                self:setDrawState("texture-base", true)
                self:updateDraw()
                return self
            end,

            setTextureMode = function(self, mode)
                textureMode = mode or textureMode
                self:updateDraw()
                return self
            end,

            setInfinitePlay = function(self, state)
                infinitePlay = state
                return self
            end,

            eventHandler = function(self, event, timerId, ...)
                base.eventHandler(self, event, timerId, ...)
                if(event=="timer")then
                    if(timerId == textureTimerId)then
                        if(bimg[textureId+1]~=nil)then
                            textureId = textureId + 1
                            texture = bimg[textureId]
                            local t = bimg[textureId].duration or bimg.secondsPerFrame or 0.2
                            textureTimerId = os.startTimer(t)
                            self:updateDraw()
                        else
                            if(infinitePlay)then
                                textureId = 1
                                texture = bimg[1]
                                local t = bimg[textureId].duration or bimg.secondsPerFrame or 0.2
                                textureTimerId = os.startTimer(t)
                                self:updateDraw()
                            end
                        end
                    end
                end
            end,

            draw = function(self)
                base.draw(self)
                self:addDraw("texture-base", function()
                    local obj = self:getParent() or self
                    local x, y = self:getPosition()
                    local w,h = self:getSize()
                    local wP,hP = obj:getSize()

                    local textureWidth = bimg.width or #bimg[textureId][1][1]
                    local textureHeight = bimg.height or #bimg[textureId]

                    local startX, startY = 0, 0

                    if (textureMode == "center") then
                        startX = x + math.floor((w - textureWidth) / 2 + 0.5) - 1
                        startY = y + math.floor((h - textureHeight) / 2 + 0.5) - 1
                    elseif (textureMode == "default") then
                        startX, startY = x, y
                    elseif (textureMode == "right") then
                        startX, startY = x + w - textureWidth, y + h - textureHeight
                    end

                    local textureX = x - startX
                    local textureY = y - startY

                    if startX < x then
                        startX = x
                        textureWidth = textureWidth - textureX
                    end
                    if startY < y then
                        startY = y
                        textureHeight = textureHeight - textureY
                    end
                    if startX + textureWidth > x + w then
                        textureWidth = (x + w) - startX
                    end
                    if startY + textureHeight > y + h then
                        textureHeight = (y + h) - startY
                    end

                    for k = 1, textureHeight do
                        if(texture[k+textureY]~=nil)then
                        local t, f, b = table.unpack(texture[k+textureY])
                            self:addBlit(1, k, t:sub(textureX, textureX + textureWidth), f:sub(textureX, textureX + textureWidth), b:sub(textureX, textureX + textureWidth))
                        end
                    end
                end, 1)
                self:setDrawState("texture-base", false)
            end,

            setValuesByXMLData = function(self, data)
                base.setValuesByXMLData(self, data)
                if(xmlValue("texture", data)~=nil)then self:addTexture(xmlValue("texture", data), xmlValue("animate", data)) end
                if(xmlValue("textureMode", data)~=nil)then self:setTextureMode(xmlValue("textureMode", data)) end
                if(xmlValue("infinitePlay", data)~=nil)then self:setInfinitePlay(xmlValue("infinitePlay", data)) end
                return self
            end
        }

        return object
    end
}