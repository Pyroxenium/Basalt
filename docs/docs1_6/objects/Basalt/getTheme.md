# Basalt

## basalt.getTheme

Returns the current base-theme. This base-theme can be set using setTheme.md.
A list of base-theme keys can be found [here](https://github.com/Pyroxenium/Basalt/blob/master/Basalt/theme.lua).

### Returns

1. `number` The color of the requested base-theme key.

### Usage

* Displays the color of the main background in the debug console

```lua
basalt.debug(basalt.getTheme("BasaltBG"))
```
