With checkbox, the user can set a bool to true or false

Here are all possible functions available for checkbox:<be>
Remember button also inherits from [Object](objects/Object.md)


Create a onChange event:
```lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aCheckbox = mainFrame:addCheckbox("myFirstCheckbox"):onChange(function(self) basalt.debug("The value got changed into "..self:getValue()) end):show()

```

