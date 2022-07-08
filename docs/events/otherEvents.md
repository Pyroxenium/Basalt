There are also other useful events you can listen to:

# onChange
`onChange(self)`<br>
This is a custom event which gets triggered as soon as the function :setValue() is called. This function is also called by basalt, for example if you change the input, textfield or checkbox (or all the different types of lists) objects.

Here is a example on how to add a onChange event to your input, and also another example for your checkbox:

```lua
local basalt = require("Basalt")

local mainFrame = basalt.createFrame("myMainFrame"):show()
local aInput = mainFrame:addInput("specialInput"):setPosition(3,3):show()
local aCheckbox = mainFrame:addCheckbox("specialCheckbox"):setPosition(3,5):show()

local function checkInput(input)
    if(string.lower(input:getValue())=="hello")then
        basalt.debug("Hello back!")
    end
end

local function checkCheckbox(checkbox)
    if(checkbox:getValue()==true)then -- or if(checkbox:getValue())then
        basalt.debug("Checkbox is active, let us do something!")
    end
end

aInput:onChange(checkInput)
aCheckbox:onChange(checkCheckbox)
```

# onResize
`onResize(self)`<br>
This is a custom event which gets triggered as soon as the parent frame gets resized.

Here is a example on how to add a onResize event to your button:

```lua
local basalt = require("Basalt")

local mainFrame = basalt.createFrame("myMainFrame"):show()
local aButton = mainFrame:addButton("myButton"):setPosition(3,3):show()

local function onButtonResize(button)
    local width = mainFrame:getWidth()
    button:setSize()
end

aButton:onResize(onButtonResize)
```
# onLoseFocus
`onLoseFocus(self)`<br>
This event gets triggered as soon as the object loses its focus.

```lua
local basalt = require("Basalt")

local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("exampleButton"):setPosition(3,3):onLoseFocus(
        function(self) 
            basalt.debug("Please come back... :(") 
        end
):show()
```

# onGetFocus
`onGetFocus(self)`<br>
This event gets triggered as soon as the object is the currently focused object.

```lua
local basalt = require("Basalt")

local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aButton = mainFrame:addButton("exampleButton"):setPosition(3,3):onGetFocus(
        function(self) 
            basalt.debug("Welcome back!") 
        end
):show()
```
