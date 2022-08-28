## showBar
Toggles the frame's upper bar

#### Parameters: 
1. `boolean | nil` Whether the frame's bar is visible or if supplied `nil`, is automatically visible

#### Returns:
1. `frame` The frame being used

#### Usage:
* Sets myFrame to have a bar titled "Hello World!" and subsequently displays it.
```lua
myFrame:setBar("Hello World!"):showBar()
```
```xml
<frame bar="true"></frame>
```