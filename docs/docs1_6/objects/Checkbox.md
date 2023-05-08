With checkboxes the user can set a boolean to true or false by clicking on them.

[Object](objects/Object.md) methods also apply for checkboxes.

|   |   |
|---|---|
|[setSymbol](objects/Checkbox/setSymbol.md)|Changes the symbol when checkbox is checked


# Example
This is how you would create a event which gets fired as soon as the value gets changed:
```lua
local main = basalt.createFrame()
local aCheckbox = main:addCheckbox()

local function checkboxChange(self)
   local checked = self:getValue()
   basalt.debug("The value got changed into ", checked)
end
aCheckbox:onChange(checkboxChange)
```

also possible via xml:
```lua
local main = basalt.createFrame():addLayout("example.xml")

basalt.setVariable("checkboxChange", function(self)
  local checked = self:getValue()
  basalt.debug("The value got changed into ", checked)
end)
```

```xml
<checkbox onChange="checkboxChange" />
```

