local XMLParser = require("xmlParser")

return {
    VisualObject = function(base)
        local inline = true
        local borderColors = {top = false, bottom = false, left = false, right = false}

        local object = {
            setBorder = function(self, ...)
                local t = {...}
                if(t~=nil)then
                    for k,v in pairs(t)do
                        if(v=="left")or(#t==1)then
                            borderColors["left"] = t[1]
                        end
                        if(v=="top")or(#t==1)then
                            borderColors["top"] = t[1]
                        end
                        if(v=="right")or(#t==1)then
                            borderColors["right"] = t[1]
                        end
                        if(v=="bottom")or(#t==1)then
                            borderColors["bottom"] = t[1]
                        end
                    end
                end
                self:updateDraw()
                return self
            end,

            draw = function(self)
                base.draw(self)
                self:addDraw("border", function()
                    local x, y = self:getPosition()
                    local w,h = self:getSize()      
                    local bgCol = self:getBackground()          
                    if(inline)then
                        if(borderColors["left"]~=false)then
                            self:addTextBox(1, 1, 1, h, "\149")
                            if(bgCol~=false)then self:addBackgroundBox(1, 1, 1, h, bgCol) end
                            self:addForegroundBox(1, 1, 1, h, borderColors["left"])
                        end
                        
                        if(borderColors["top"]~=false)then
                            self:addTextBox(1, 1, w, 1, "\131")
                            if(bgCol~=false)then self:addBackgroundBox(1, 1, w, 1, bgCol) end
                            self:addForegroundBox(1, 1, w, 1, borderColors["top"])
                        end
                        
                        if(borderColors["left"]~=false)and(borderColors["top"]~=false)then
                            self:addTextBox(1, 1, 1, 1, "\151")
                            if(bgCol~=false)then self:addBackgroundBox(1, 1, 1, 1, bgCol) end
                            self:addForegroundBox(1, 1, 1, 1, borderColors["left"])
                        end
                        if(borderColors["right"]~=false)then
                            self:addTextBox(w, 1, 1, h, "\149")
                            if(bgCol~=false)then self:addForegroundBox(w, 1, 1, h, bgCol) end
                            self:addBackgroundBox(w, 1, 1, h, borderColors["right"])
                        end
                        if(borderColors["bottom"]~=false)then
                            self:addTextBox(1, h, w, 1, "\143")
                            if(bgCol~=false)then self:addForegroundBox(1, h, w, 1, bgCol) end
                            self:addBackgroundBox(1, h, w, 1, borderColors["bottom"])
                        end
                        if(borderColors["top"]~=false)and(borderColors["right"]~=false)then
                            self:addTextBox(w, 1, 1, 1, "\148")
                            if(bgCol~=false)then self:addForegroundBox(w, 1, 1, 1, bgCol) end
                            self:addBackgroundBox(w, 1, 1, 1, borderColors["right"])
                        end
                        if(borderColors["right"]~=false)and(borderColors["bottom"]~=false)then
                            self:addTextBox(w, h, 1, 1, "\133")
                            if(bgCol~=false)then self:addForegroundBox(w, h, 1, 1, bgCol) end
                            self:addBackgroundBox(w, h, 1, 1, borderColors["right"])
                        end
                        if(borderColors["bottom"]~=false)and(borderColors["left"]~=false)then
                            self:addTextBox(1, h, 1, 1, "\138")
                            if(bgCol~=false)then self:addForegroundBox(0, h, 1, 1, bgCol) end
                            self:addBackgroundBox(1, h, 1, 1, borderColors["left"])
                        end
                    end
                end)
            end,

            setValuesByXMLData = function(self, data, scripts)
                base.setValuesByXMLData(self, data)
                local borders = {}
                if(XMLParser.XmlValue("border", data)~=nil)then 
                    borders["top"] = colors[XMLParser.XmlValue("border", data)]
                    borders["bottom"] = colors[XMLParser.XmlValue("border", data)]
                    borders["left"] = colors[XMLParser.XmlValue("border", data)]
                    borders["right"] = colors[XMLParser.XmlValue("border", data)]
                end
                if(XMLParser.XmlValue("borderTop", data)~=nil)then borders["top"] = colors[XMLParser.XmlValue("borderTop", data)] end
                if(XMLParser.XmlValue("borderBottom", data)~=nil)then borders["bottom"] = colors[XMLParser.XmlValue("borderBottom", data)] end
                if(XMLParser.XmlValue("borderLeft", data)~=nil)then borders["left"] = colors[XMLParser.XmlValue("borderLeft", data)] end
                if(XMLParser.XmlValue("borderRight", data)~=nil)then borders["right"] = colors[XMLParser.XmlValue("borderRight", data)] end
                self:setBorder(borders["top"], borders["bottom"], borders["left"], borders["right"])
                return self
            end
        }

        return object
    end
}