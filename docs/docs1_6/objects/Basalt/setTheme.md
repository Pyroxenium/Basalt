# Basalt

## setTheme

Sets the base theme of the project! Make sure to cover all existing objects, otherwise it will result in errors. A good example is [theme](https://github.com/Pyroxenium/Basalt/blob/bb1b1beb795e3cf06a84ca79408244bca715961e/Basalt/theme.lua). The theme can also be gotten with [`basalt.getTheme()`](objects/Basalt/getTheme)

### Parameters

1. `table` theme layout look into [theme](https://github.com/Pyroxenium/Basalt/blob/bb1b1beb795e3cf06a84ca79408244bca715961e/Basalt/theme.lua) for a example

### Usage

* Sets the default theme of basalt.

```lua
basalt.setTheme({
    ButtonBG = colors.yellow,
    ButtonText = colors.red,
    ...,
})
```
