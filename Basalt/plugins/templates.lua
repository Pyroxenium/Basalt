local split = require("utils").splitString

local function copy(t)
    local new = {}
    for k,v in pairs(t)do
        new[k] = v
    end
    return new
end

local plugin = {
    VisualObject = function(base, basalt)
        return {
            __getElementPathTypes = function(self, types)
                if(types~=nil)then
                    table.insert(types, 1, self:getTypes())
                else
                    types = {self:getTypes()}
                end
                local parent = self:getParent()
                if(parent~=nil)then
                    return parent:__getElementPathTypes(types)
                else
                    return types
                end
            end,

            init = function(self)
                base.init(self)
                local template = basalt.getTemplate(self)
                local objects = basalt.getObjects()
                if(template~=nil)then
                    for k,v in pairs(template)do
                        if(objects[k]==nil)then
                            if(colors[v]~=nil)then
                                self:setProperty(k, colors[v])
                            else
                                self:setProperty(k, v)
                            end
                        end
                    end
                end
                return self
            end,
        }
    end,

    basalt = function()
        local baseTemplate = {
            default = {
                Background = colors.gray,
                Foreground = colors.black,
            },
            BaseFrame = {
                Background = colors.lightGray,
                Foreground = colors.black,
                Button = {
                    Background = "{self.clicked ? black : gray}",
                    Foreground = "{self.clicked ? lightGray : black}"
                },
                Container = {
                    Background = colors.gray,
                    Foreground = colors.black,
                    Button = {
                        Background = "{self.clicked ? lightGray : black}",
                        Foreground = "{self.clicked ? black : lightGray}"
                    },
                },
                Checkbox = {
                    Background = colors.gray,
                    Foreground = colors.black,
                    Text = "Checkbox"
                },
                Input = {
                    Background = "{self.focused ? gray : black}",
                    Foreground = "{self.focused ? black : lightGray}",
                },
            },
        }

        local function addTemplate(newTemplate)
            if(type(newTemplate)=="string")then
                local file = fs.open(newTemplate, "r")
                if(file~=nil)then
                    local data = file.readAll()
                    file.close()
                    baseTemplate = textutils.unserializeJSON(data)
                else
                    error("Could not open template file "..newTemplate)
                end
            end
            if(type(newTemplate)=="table")then
                for k,v in pairs(newTemplate)do
                    baseTemplate[k] = v
                end
            end
        end

        local function lookUpTemplate(template, allTypes)
            local elementData = copy(baseTemplate.default)
            local tLink = template
            if(tLink~=nil)then
                for _, v in pairs(allTypes)do
                    for _, b in pairs(v)do
                        if(tLink[b]~=nil)then
                            tLink = tLink[b]
                            for k, v in pairs(tLink) do
                                elementData[k] = v
                            end
                            break
                        else
                            for k, v in pairs(baseTemplate.default) do
                                elementData[k] = v
                            end
                        end
                    end
                end
            end
            return elementData
        end
        
        return {
            getTemplate = function(element)
                return lookUpTemplate(baseTemplate, element:__getElementPathTypes())
            end,

            addTemplate = addTemplate,
        }
    end
}

return plugin