Dropdowns are objects where the user can click on a button, which opens a list from which the user can choose an item.

List Object methods also apply for dropdowns.
In addition to the Object, VisualObject and List methods, Dropdowns also have the following methods:

|   |   |
|---|---|
|[setDropdownSize](objects/Dropdown/setDropdownSize.md)|Changes the dropdown size

A item-table in dropdowns looks like the following example:

```lua
item = {
  text="1. Entry",  -- the text its showing
  bgCol=colors.black,  -- the background color
  fgCol=colors.white -- the foreground color
  args = {} -- custom args you want to pass, which you will be able to access in for example onChange events
}
```

Here's an example of how to create a fully functional dropdown using the Dropdown object:

Lua:

```lua
local main = basalt.createFrame()
local aDropdown = main:addDropdown()
aDropdown:addItem("Item 1")
aDropdown:addItem("Item 2", colors.yellow)
aDropdown:addItem("Item 3", colors.yellow, colors.green)

aDropdown:onChange(function(self, item)
  basalt.debug("Selected item: ", item.text)
end)
```

XML:

```xml
<dropdown>
  <item><text>Item 1</text></item>
  <item><text>Item 2</text><bg>yellow</bg></item>
  <item><text>Item 3</text><bg>yellow</bg><fg>green</fg></item>
  <onChange>
    basalt.debug("Selected item: ", item.text)
  </onChange>
</dropdown>
```
