Hello! This page contains some tips on how to create cool designs with Basalt

To understand this page, it is recommended to familiarize yourself with [Animations](../objects/Animation.md) as animations are important for creating cool looking designs

## Animation-move
Here i will show you how you can move objects by using the animation object.

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local sub = main:addFrame():setSize("parent.w - 2",12):setPosition("-parent.w",4)
      sub:addLabel()
        :setText("Cool Title")
        :setBackground(colors.black)
        :setForeground(colors.lightGray)
        :setSize("parent.w", 1)

local button = sub:addButton()
    :setBackground(colors.black)
    :setForeground(colors.lightGray)
    :setPosition(-12,9)
local button2 = sub:addButton()
    :setBackground(colors.black)
    :setForeground(colors.lightGray)
    :setPosition("parent.w + 12",9)

local anim = main:addAnimation()
    :setObject(sub)
    :move(2,4,1.5)
    :setObject(button)
    :move(2,9,1,1.5)
    :setObject(button2)
    :move(sub:getWidth()-12,9,1,1.5)
    :play()

basalt.autoUpdate()
```

As you can see, you only need 1 animation but you can still move 3 objects.

## Animation-offset
Here is a example which changes the offset on your base frame. It shows you, how you could create multiple pages and switch between them in a cool looking way:
```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local mainAnim = main:addAnimation()

local frames = {
    main:addFrame():setPosition(1,2):setSize("parent.w", "parent.h-1"):setBackground(colors.lightGray),
    main:addFrame():setPosition("parent.w+1",2):setSize("parent.w", "parent.h-1"):setBackground(colors.lightGray),
    main:addFrame():setPosition("parent.w*2+1",2):setSize("parent.w", "parent.h-1"):setBackground(colors.lightGray),
    main:addFrame():setPosition("parent.w*3+1",2):setSize("parent.w", "parent.h-1"):setBackground(colors.lightGray),
}

frames[1]:addLabel():setText("This is frame 1")
frames[2]:addLabel():setText("This is frame 2")
frames[3]:addLabel():setText("This is frame 3")
frames[4]:addLabel():setText("This is frame 4")

local menubar = main:addMenubar():ignoreOffset()
        :addItem("Page 1",nil,nil,1)
        :addItem("Page 2",nil,nil,2)
        :addItem("Page 3",nil,nil,3)
        :addItem("Page 4",nil,nil,4)
        :setSpace(3)
        :setSize("parent.w",1)
        :onChange(function(self, value)
            mainAnim:clear()
                    :cancel()
                    :setObject(main)
                    :offset(value.args[1] * main:getWidth() - main:getWidth(), 0, 2)
                    :play()
        end)


basalt.autoUpdate()
```

## Visually showing
Here I'll show you how to visually show the user when something isn't working. this is just one example that you can apply to other topics as well.
```lua
local basalt = require("basalt")

local password = "12345"

local main = basalt.createFrame()

main:addLabel():setText("Password:"):setPosition(2,2)
local input = main:addInput():setInputType("password"):setPosition(2,3):setSize(24,1)
local submit = main:addButton():setPosition(2,5):setText("Submit")
submit:onClick(basalt.schedule(function()
    if(password==input:getValue())then
        basalt.debug("Password correct!")
    else
        basalt.debug("Wrong password!")
        submit:setBackground(colors.red)
        sleep(0.05)
        submit:setPosition(3,5)
        sleep(0.05)
        submit:setPosition(2,5)
        sleep(0.05)
        submit:setPosition(1,5)
        sleep(0.05)
        submit:setPosition(2,5)
        submit:setBackground(colors.gray)
    end
end))

basalt.autoUpdate()
```