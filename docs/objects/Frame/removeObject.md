## removeObject 
Removes a child object from the frame

#### Parameters:
1. `string|object` The name of the child object or the object itself

#### Returns: 
1. `boolean` Whether the object with the given name was properly removed

#### Usage:
* Adds a button with the id "myFirstButton", then removes it with the aforementioned id
```lua
local main = basalt.createFrame()
main:addButton("myFirstButton"):setText("Close")
    :onClick(function(self)
        main:removeObject("myFirstButton") -- or main:removeObject(self) 
    end)
```