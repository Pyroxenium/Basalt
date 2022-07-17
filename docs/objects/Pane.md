Panes are very simple sizeable background objects.

The following list is only available to panes: <br>
Remember Pane also inherits from [Object](objects/Object.md)

Pane doesn't have any custom functionallity. If you want to change the color/position or size, just check out the [object](https://github.com/NoryiE/basalt/wiki/Object) wikipage.

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