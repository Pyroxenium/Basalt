With checkbox objects the user can set a bool to true or false

Remember checkbox also inherits from [Object](objects/Object.md)

A checkbox does not have any custom methods. All required methods are provided by the base [object](objects/Object.md) class.

# Example
This is how you would create a event which gets fired as soon as the value gets changed:
```lua
local mainFrame = basalt.createFrame()
local aCheckbox = mainFrame:addCheckbox()

local function checkboxChange(self)
   local checked = self:getValue()
   basalt.debug("The value got changed into ", checked)
end
aCheckbox:onChange(checkboxChange)
```

also possible via xml:
```lua
local mainFrame = basalt.createFrame():addLayout("example.xml")

basalt.setVariable("checkboxChange", function(self)
  local checked = self:getValue()
  basalt.debug("The value got changed into ", checked)
end)
```

```xml
<checkbox onChange="checkboxChange" />
```

