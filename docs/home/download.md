Basalt offers three unique versions for different use cases: a Source version, a Minified/Packed version, and a Web version.

## Source Version

The Source version, as the name suggests, contains the unmodified source code of Basalt. Use this version if you want to explore the code, add custom content, or prefer working with the original source.

To download the Source version, use the following command:

`wget run https://basalt.madefor.cc/install.lua source [foldername] [branch]`

- `foldername` (optional): The folder name for the Basalt installation (default: `basalt`).
- `branch` (optional): Choose between `master` and `dev` branches (default: `master`).

## Minified/Packed Version

The Minified/Packed version is a compressed version of the Basalt code. It reduces the file size and combines the code into a single file instead of a folder, making it easier to manage.

To download the Minified/Packed version, use the following command:

`wget run https://basalt.madefor.cc/install.lua packed [filename] [branch]`

- `filename` (optional): The file name for the Basalt installation (default: `basalt.lua`).
- `branch` (optional): Choose between `master` and `dev` branches (default: `master`).

## Web Version

The Web version is designed for minimal project size and fetches the required code from the web when needed. This version is recommended for projects that don't require frequent restarts. If your program reboots often due to user input or errors, it's better to use the Source or Minified versions.

To download the Web version, use the following command:

`wget run https://basalt.madefor.cc/install.lua web [version] [filename]`

- `version` (optional): Specify the desired version of Basalt (default: latest version). [Click here](https://github.com/Pyroxenium/Basalt/tree/master/docs/versions) to see the available versions.
- `filename` (optional): The file name for the Basalt installation (default: `basaltWeb.lua`).

**Note**: If using the Web version, remember to change `local basalt = require("basalt")` to `local basalt = require("basaltWeb")` in your code.