## setTheme

### Description

Sets the base theme of the project! Make sure to cover all existing objects, otherwise it will result in errors. A good example is [theme](https://github.com/Pyroxenium/Basalt/blob/master/Basalt/plugins/themes.lua). The theme can also be retrieved with [`basalt.getTheme()`](objects/Basalt/getTheme)

### Parameters

1. `table` theme - A table containing the theme layout. Look into [theme](https://github.com/Pyroxenium/Basalt/blob/master/Basalt/plugins/themes.lua) for an example

### Usage

* Sets the default theme of Basalt.

```lua
basalt.setTheme({
    ButtonBG = colors.yellow,
    ButtonText = colors.red,
    ...,
})
```
