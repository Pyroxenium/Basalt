## getObject 
Returns a child object of the frame

#### Parameters: 
1. `string` The name of the child object

#### Returns: 
1. `object | nil` The object with the supplied name, or `nil` if there is no object present with the given name 

#### Usage:
* Adds a button with id "myFirstButton", then retrieves it again through the frame object
```lua
myFrame:addButton("myFirstButton")
local aButton = myFrame:getObject("myFirstButton")
```