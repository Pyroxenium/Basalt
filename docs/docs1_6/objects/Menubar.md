Menubars are like lists but instead of being vertical, they are horizontal. Imagine you are creating a Operating System and you would like to add a taskbar, menubars would be exactly what you need, because they are also scrollable, which means they can have endless entries.

[Object](objects/Object.md) methods also apply for menubars.

|   |   |
|---|---|
|[addItem](objects/Menubar/addItem.md)|Adds a new item into the list
|[removeItem](objects/Menubar/removeItem.md)|Removes a item from the list
|[editItem](objects/Menubar/editItem.md)|Changes a already existing item in the list
|[getItem](objects/Menubar/getItem.md)|Returns a item by its index
|[getItemCount](objects/Menubar/getItemCount.md)|Returns the item count
|[getAll](objects/Menubar/getAll.md)|Returns the entire list as a table
|[selectItem](objects/Menubar/selectItem.md)|Selects a item
|[clear](objects/Menubar/clear.md)|Makes the entire list empty
|[getItemIndex](objects/Menubar/getItemIndex.md)|Returns the currently active item index
|[setSelectedItem](objects/Menubar/setSelectedItem.md)|Changes the default bg and fg, when the user selects a item
|[setOffset](objects/Menubar/setOffset.md)|Changes the list offset
|[getOffset](objects/Menubar/getOffset.md)|Returns the current offset
|[setScrollable](objects/Menubar/setScrollable.md)|Makes the list scrollable
|[setSpace](objects/Menubar/setSpace.md)|Adds space between the entries


A item-table in menubars looks like the following example:

```lua
item = {
  text="1. Entry",  -- the text its showing
  bgCol=colors.black,  -- the background color
  fgCol=colors.white -- the foreground color
  args = {} -- custom args you want to pass, which you will be able to access in for example onChange events
}
```