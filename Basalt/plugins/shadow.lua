return {
    VisualObject = function(base)
        local shadow = false        

        local object = {
            setShadow = function(self, color)
                shadow = color
                self:updateDraw()
                return self
            end,

            getShadow = function(self)
                return shadow
            end,

            draw = function(self)
                base.draw(self)
                self:addDraw("shadow", function()
                    if(shadow~=false)then
                        local w,h = self:getSize()
                        if(shadow)then               
                            self:addBackgroundBox(w+1, 2, 1, h, shadow)
                            self:addBackgroundBox(2, h+1, w, 1, shadow)
                            self:addForegroundBox(w+1, 2, 1, h, shadow)
                            self:addForegroundBox(2, h+1, w, 1, shadow)
                        end
                    end
                end)
            end,

            setValuesByXMLData = function(self, data)
                base.setValuesByXMLData(self, data)
                if(xmlValue("shadow", data)~=nil)then self:setShadow(xmlValue("shadow", data)) end
                return self
            end
        }

        return object
    end
}