Radio objects are a collection of items that you can freely place on the interface, allowing users to select an item from the radio-list.

In addition to the Object, VisualObject, and List methods, Radio objects have a modified item-table structure that includes x and y coordinates:

A item-table in lists looks like the following example:

```lua
item = {
  text="1. Entry",  -- the text it's showing
  bgCol=colors.black,  -- the background color
  fgCol=colors.white,  -- the foreground color
  x=10,  -- the x-coordinate of the item's position
  y=20,  -- the y-coordinate of the item's position
  args = {}  -- custom arguments you want to pass, which you will be able to access in, for example, onChange events
}
```

No unique methods are available for Radio objects beyond those inherited from the Object, VisualObject, and List classes, and the modified addItem/editItem methods.

|   |   |
|---|---|
|[addItem](objects/List/addItem.md)|Adds a new item into the list with specified x and y coordinates
|[editItem](objects/List/editItem.md)|Changes an already existing item in the list, including x and y coordinates
