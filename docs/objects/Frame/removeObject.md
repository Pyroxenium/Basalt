## removeObject 
Removes a child object from the frame

#### Parameters:
1. `string` The name of the child object

#### Returns: 
1. `boolean` Whether the object with the given name was properly removed

#### Usage:
* Adds a button with the id "myFirstButton", then removes it with the aforementioned id
```lua
myFrame:addButton("myFirstButton")
myFrame:removeObject("myFirstButton")
```