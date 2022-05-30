# Pane

Panes are very simple sizeable background objects.

The following list is only available to panes: <br>
Remember pane also inherits from [object](/Object):

Pane doesn't have any custom functionallity. If you want to change the color/position or size, just check out the [object](/Object) wikipage.

## Example:

````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aPane = mainFrame:addPane("myFirstBackground")
aPane:setSize(30, 10)
aPane:setBackground(colors.yellow)
aPane:show()
````