Lists are objects that allow you to create a collection of entries from which the user can make a selection.

In addition to the Object and VisualObject methods, lists also have the following methods:

|   |   |
|---|---|
|[addItem](objects/List/addItem.md)|Adds a new item into the list
|[removeItem](objects/List/removeItem.md)|Removes an item from the list
|[editItem](objects/List/editItem.md)|Changes an already existing item in the list
|[getItem](objects/List/getItem.md)|Returns an item by its index
|[getItemCount](objects/List/getItemCount.md)|Returns the item count
|[setOptions](objects/List/setOptions.md)|Updates the list options
|[getOptions](objects/List/getOptions.md)|Returns the entire list as a table
|[selectItem](objects/List/selectItem.md)|Selects an item
|[clear](objects/List/clear.md)|Makes the entire list empty
|[getItemIndex](objects/List/getItemIndex.md)|Returns the currently active item index
|[setOffset](objects/List/setOffset.md)|Changes the list offset
|[getOffset](objects/List/getOffset.md)|Returns the current offset
|[setScrollable](objects/List/setScrollable.md)|Makes the list scrollable
|[setSelectionColor](objects/List/setSelectionColor.md)|Changes the default bg and fg when the user selects an item
|[getSelectionColor](objects/List/getSelectionColor.md)|Returns default bg and fg selection color
|[isSelectionColorActive](objects/List/isSelectionColorActive.md)|Returns if it is using selection color

## Events

|   |   |
|---|---|
|[onSelect](objects/List/onSelect.md)|Fires when a item on the list get's selected

A item-table in lists looks like the following example:

```lua
item = {
  text="1. Entry",  -- the text its showing
  bgCol=colors.black,  -- the background color
  fgCol=colors.white -- the foreground color
  args = {} -- custom args you want to pass, which you will be able to access in for example onChange events
}
```

## Example

Lua:

```lua
local main = basalt.createFrame()
local aList = main:addList()
aList:addItem("Item 1")
aList:addItem("Item 2", colors.yellow)
aList:addItem("Item 3", colors.yellow, colors.green)

aList:onSelect(function(self, event, item)
  basalt.debug("Selected item: ", item.text)
end)
```

XML:

```xml
<list>
  <item><text>Item 1</text></item>
  <item><text>Item 2</text><bg>yellow</bg></item>
  <item><text>Item 3</text><bg>yellow</bg><fg>green</fg></item>
  <onChange>
    basalt.debug("Selected item: ", item.text)
  </onChange>
</list>
```
