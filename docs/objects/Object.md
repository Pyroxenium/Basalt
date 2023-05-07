The Object class is the fundamental building block class in Basalt, from which all other objects and components are derived. You can think of it as the "origin" of all objects within the framework. The Object class provides essential functions that are common to all derived objects, such as adding and removing event listeners and managing inheritance and relationships between objects.

In simple terms, the Object class is like a common ancestor that passes down basic functions and properties to all subsequent objects. This makes it easier to keep the behavior of objects throughout the framework consistent and predictable.

|   |   |
|---|---|
|[enable](objects/Object/enable.md)|Enables the event listeners
|[disable](objects/Object/disable.md)|Disables the event listeners
|[getType](objects/Object/getType.md)|Returns the object type
|[isType](objects/Object/isType.md)|Checks if the object is of a specific type
|[getName](objects/Object/getName.md)|Returns the name
|[getParent](objects/Object/getParent.md)|Returns the parent
|[setParent](objects/Object/setParent.md)|Changes the parent
|[getZIndex](objects/Object/getZIndex.md)|Returns the z-index
|[remove](objects/Object/remove.md)|Removes the object from its parent

## Events

Events are actions or occurrences that happen during the execution of your program. In Basalt, objects can respond to various events, such as user interactions or changes in their properties. The following is a list of all available events for all objects:

|   |   |
|---|---|
|[onClick](objects/Object/onClick.md)|Fires when the object is clicked
|[onClickUp](objects/Object/onClickUp.md)|Fires when the mouse button is released on the object
|[onRelease](objects/Object/onRelease.md)|Fires when the mouse button is released
|[onScroll](objects/Object/onScroll.md)|Fires when scrolling with the mouse wheel
|[onDrag](objects/Object/onDrag.md)|Fires when the object is being dragged
|[onHover](objects/Object/onHover.md)|CraftOS-PC - fires when the mouse hovers over an object
|[onLeave](objects/Object/onLeave.md)|CraftOS-PC - fires when the mouse leaves an object
|[onKey](objects/Object/onKey.md)|Fires when the object is focused and a keyboard key is pressed
|[onChar](objects/Object/onChar.md)|Fires when the object is focused and a character key is pressed
|[onKeyUp](objects/Object/onKeyUp.md)|Fires when the object is focused and a keyboard key is released
|[onGetFocus](objects/Object/onGetFocus.md)|Fires when the object gains focus
|[onLoseFocus](objects/Object/onLoseFocus.md)|Fires when the object loses focus
|[onEvent](objects/Object/onEvent.md)|Fires for any other event

Sidenote: When you use return false, the object's event handler will be skipped. Here is an example of that.

This code would make it impossible to enter the letter 'a' into the input:

```lua
local basalt = require("basalt")

local main = basalt.createFrame()
local input = main:addInput()
  :setPosition(3,3)

local function checkInput(self, event, char)
  if(char=="a")then
    return false
  end
end
main:onChar(checkInput)
```

In this example, the checkInput function is defined to return false when the character 'a' is entered. When this occurs, the event handler for the input is skipped, preventing the letter 'a' from being added to the input.
