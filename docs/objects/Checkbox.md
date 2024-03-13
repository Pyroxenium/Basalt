The Checkbox object is derived from the ChangeableObject class and allows users to set a boolean value to true or false by clicking on it. Checkboxes are commonly used in forms and settings to enable or disable specific options.

In addition to the Object, VisualObject and ChangeableObject methods, checkboxes also have the following method:

|   |   |
|---|---|
|[setSymbol](objects/Checkbox/setSymbol.md)|Changes the symbol when checkbox is checked

# Example
Here's an example of how to create a Checkbox object and attach an event that gets fired when the value changes:

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

```xml
<checkbox onChange="checkboxChange">
  <onChange>
    local checked = self:getValue()
    basalt.debug("The value got changed into ", checked)
  </onChange>
</checkbox>
```

In these examples, a checkbox is created, and when the value changes, a debug message prints the new value of the checkbox.
