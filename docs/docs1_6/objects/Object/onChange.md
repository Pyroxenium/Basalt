# Object - Event

## onChange

`onChange(self)`

This is a custom event which gets triggered as soon as the function :setValue() is called. This function is also called by basalt, for example if you change the input, textfield or checkbox (or all the different types of lists) objects.

Here is a example on how to add a onChange event to your input, and also another example for your checkbox:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local aInput = main:addInput():setPosition(3,3)
local aCheckbox = main:addCheckbox():setPosition(3,5)

local function checkInput(input)
    if(string.lower(input:getValue())=="hello")then
        basalt.debug("Hello back!")
    end
end

local function checkCheckbox(checkbox)
    if(checkbox:getValue()==true)then -- or if(checkbox:getValue())then
        basalt.debug("Checkbox is active, let's do something!")
    end
end

aInput:onChange(checkInput)
aCheckbox:onChange(checkCheckbox)
```
