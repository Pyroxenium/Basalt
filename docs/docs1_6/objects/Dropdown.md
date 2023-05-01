Dropdowns are objects where the user can click on a button, this will open a list where the user can choose from.

[Object](objects/Object.md) methods also apply for dropdowns.

|   |   |
|---|---|
|[addItem](objects/Dropdown/addItem.md)|Adds a new item into the list
|[removeItem](objects/Dropdown/removeItem.md)|Removes a item from the list
|[editItem](objects/Dropdown/editItem.md)|Changes a already existing item in the list
|[getItem](objects/Dropdown/getItem.md)|Returns a item by its index
|[getItemCount](objects/Dropdown/getItemCount.md)|Returns the item count
|[getAll](objects/Dropdown/getAll.md)|Returns the entire list as a table
|[selectItem](objects/Dropdown/selectItem.md)|Selects a item
|[clear](objects/Dropdown/clear.md)|Makes the entire list empty
|[getItemIndex](objects/Dropdown/getItemIndex.md)|Returns the currently active item index
|[setSelectedItem](objects/Dropdown/setSelectedItem.md)|Changes the default bg and fg, when the user selects a item
|[setOffset](objects/Dropdown/setOffset.md)|Changes the list offset
|[getOffset](objects/Dropdown/getOffset.md)|Returns the current offset
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