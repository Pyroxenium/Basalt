With panes you are able to create background without any functionality

Because panes don't have any unique functionality, there is also no method list for them. 

[Object](objects/Object.md) methods also apply for panes.

## Example:

```lua
local mainFrame = basalt.createFrame()
local aPane = mainFrame:addPane()
aPane:setSize(30, 10)
aPane:setBackground(colors.yellow)
aPane:show()
```
```xml
<pane width="30" height="10" bg="yellow" />
```