Lists are objects where you can create endless entries, and the user is able to select one of them

[Object](objects/Object.md) methods also apply for lists.

|   |   |
|---|---|
|[addItem](objects/List/addItem.md)|Adds a new item into the list
|[removeItem](objects/List/removeItem.md)|Removes a item from the list
|[editItem](objects/List/editItem.md)|Changes a already existing item in the list
|[getItem](objects/List/getItem.md)|Returns a item by its index
|[getItemCount](objects/List/getItemCount.md)|Returns the item count
|[getAll](objects/List/getAll.md)|Returns the entire list as a table
|[selectItem](objects/List/selectItem.md)|Selects a item
|[clear](objects/List/clear.md)|Makes the entire list empty
|[getItemIndex](objects/List/getItemIndex.md)|Returns the currently active item index
|[setSelectedItem](objects/List/setSelectedItem.md)|Changes the default bg and fg, when the user selects a item
|[setOffset](objects/List/setOffset.md)|Changes the list offset
|[getOffset](objects/List/getOffset.md)|Returns the current offset
|[setScrollable](objects/List/setScrollable.md)|Makes the list scrollable


A item-table in lists looks like the following example:

```lua
item = {
  text="1. Entry",  -- the text its showing
  bgCol=colors.black,  -- the background color
  fgCol=colors.white -- the foreground color
  args = {} -- custom args you want to pass, which you will be able to access in for example onChange events
}
```