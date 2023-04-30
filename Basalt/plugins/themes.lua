local baseTheme = { -- The default main theme for basalt!
    BaseFrameBG = colors.lightGray,
    BaseFrameText = colors.black,
    FrameBG = colors.gray,
    FrameText = colors.black,
    ButtonBG = colors.gray,
    ButtonText = colors.black,
    CheckboxBG = colors.lightGray,
    CheckboxText = colors.black,
    InputBG = colors.black,
    InputText = colors.lightGray,
    TextfieldBG = colors.black,
    TextfieldText = colors.white,
    ListBG = colors.gray,
    ListText = colors.black,
    MenubarBG = colors.gray,
    MenubarText = colors.black,
    DropdownBG = colors.gray,
    DropdownText = colors.black,
    RadioBG = colors.gray,
    RadioText = colors.black,
    SelectionBG = colors.black,
    SelectionText = colors.lightGray,
    GraphicBG = colors.black,
    ImageBG = colors.black,
    PaneBG = colors.black,
    ProgramBG = colors.black,
    ProgressbarBG = colors.gray,
    ProgressbarText = colors.black,
    ProgressbarActiveBG = colors.black,
    ScrollbarBG = colors.lightGray,
    ScrollbarText = colors.gray,
    ScrollbarSymbolColor = colors.black,
    SliderBG = false,
    SliderText = colors.gray,
    SliderSymbolColor = colors.black,
    SwitchBG = colors.lightGray,
    SwitchText = colors.gray,
    LabelBG = false,
    LabelText = colors.black,
    GraphBG = colors.gray,
    GraphText = colors.black    
}

local plugin = {
    Container = function(base, name, basalt)
        local theme = {}

        local object = {
            getTheme = function(self, name)
                local parent = self:getParent()
                return theme[name] or (parent~=nil and parent:getTheme(name) or baseTheme[name])
            end,
            setTheme = function(self, _theme, col)
                if(type(_theme)=="table")then
                    theme = _theme
                elseif(type(_theme)=="string")then
                    theme[_theme] = col
                end
                self:updateDraw()
                return self
            end,
        }
        return object
    end,

    basaltInternal = function()
        return {
            getTheme = function(name)
                return baseTheme[name]
            end,
            setTheme = function(_theme, col)
                if(type(_theme)=="table")then
                    theme = _theme
                elseif(type(_theme)=="string")then
                    theme[_theme] = col
                end
            end
        }
    end
    
}

for k,v in pairs({"BaseFrame", "Frame", "ScrollableFrame", "MovableFrame", "Button", "Checkbox", "Dropdown", "Graph", "Graphic", "Input", "Label", "List", "Menubar", "Pane", "Program", "Progressbar", "Radio", "Scrollbar", "Slider", "Switch", "Textfield"})do
plugin[v] = function(base, name, basalt)
        local object = {
            init = function(self)
                if(base.init(self))then
                    local parent = self:getParent() or self
                    self:setBackground(parent:getTheme(v.."BG"))
                    self:setForeground(parent:getTheme(v.."Text"))      
                end
            end
        }
        return object
    end
end

return plugin