Menubars are similar to lists but are displayed horizontally instead of vertically. They are ideal for creating user interfaces like taskbars in operating systems, as they can be scrollable, allowing for endless entries.

In addition to the Object, VisualObject, and List methods, Menubars also have the following method:

|   |   |
|---|---|
|[setSpace](objects/Menubar/setSpace.md)|Adds space between the entries
|[getSpace](objects/Menubar/getSpace.md)|Returns the space between entries

A item-table in menubars looks like the following example:

```lua
item = {
  text="1. Entry",  -- the text its showing
  bgCol=colors.black,  -- the background color
  fgCol=colors.white -- the foreground color
  args = {} -- custom args you want to pass, which you will be able to access in for example onChange events
}
```
