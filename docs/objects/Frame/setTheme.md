## setTheme

Sets the default theme, of that frame children objects always try to get the theme of its parent frame, if it does not exist it goes to its parent parent frame, and so on until it reaches the basalt manager's theme - which is stored in theme.lua (Please checkout [theme](https://github.com/Pyroxenium/Basalt/blob/master/Basalt/plugins/themes.lua) for how it could look like.

#### Parameters:

1. `table` theme layout look into [theme](https://github.com/Pyroxenium/Basalt/blob/master/Basalt/plugins/themes.lua) for a example

#### Returns:

1. `frame` The frame being used

#### Usage:

- Creates a new base frame and adds a new theme which only changes the default color of buttons.

```lua
local myFrame = basalt.createFrame():setTheme({
    ButtonBG = colors.yellow,
    ButtonText = colors.red,
})
```
