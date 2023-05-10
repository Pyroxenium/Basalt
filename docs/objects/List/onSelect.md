## onSelect

### Description

`onSelect(self, event, item)`

The onSelect event is triggered when a item on the list gets selected.

### Returns

1. `object` The object in use

### Usage

* Add an onSelect event to a list:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local list = main:addList()

list:addItem("Entry 1")
list:addItem("Entry 2")

function listOnSelect(self, event, item)
  basalt.debug("Item got selected:", item.text)
end

list:onSelect(listOnSelect)

basalt.autoUpdate()
```
