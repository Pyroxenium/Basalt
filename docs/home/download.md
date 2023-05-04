Basalt provides several options for downloading the UI Framework. Here's a list of all the available methods to download Basalt:

## Release Version

The Release version provides a specific, stable version of Basalt. Use this version if you want to work with a particular release of Basalt, ensuring consistency and compatibility with your project.

To download the Release version, use the following command:

`wget run https://basalt.madefor.cc/install.lua release [remote_filename] [local_filename]`

In most cases, you'll likely want to use:

`wget run https://basalt.madefor.cc/install.lua release latest.lua`

- `remote_filename`: The file name of the Basalt release you want to download (e.g., basalt-1.6.6.lua, latest.lua).
- `local_filename` (optional): The file name for the Basalt installation on your local system (e.g., basalt.lua).

A list of all available versions can be found [here](https://github.com/Pyroxenium/Basalt/tree/master/docs/versions).

## Minified/Packed Version

The Minified/Packed version is a compressed version of the Basalt code directly downloaded from GitHub. It reduces the file size and combines the code into a single file instead of a folder, making it easier to manage. Remember, this method always automatically downloads the most recent version from the GitHub repository and is meant for quick fixes between releases.

To download the Minified/Packed version, use the following command:

`wget run https://basalt.madefor.cc/install.lua packed [filename] [branch]`

- `filename` (optional): The file name for the Basalt installation (default: `basalt.lua`).
- `branch` (optional): Choose between `master` and `dev` branches (default: `master`).

## Source Version

The Source version, as the name suggests, contains the unmodified source code of Basalt, downloaded directly from GitHub. Use this version if you want to explore the code, add custom content, or prefer working with the original source.

To download the Source version, use the following command:

`wget run https://basalt.madefor.cc/install.lua source [foldername] [branch]`

- `foldername` (optional): The folder name for the Basalt installation (default: `basalt`).
- `branch` (optional): Choose between `master` and `dev` branches (default: `master`).

## Web Version

The Web version is designed for minimal project size and fetches the required code from the web when needed. This version is recommended for projects that don't require frequent restarts. If your program reboots often due to user input or errors, it's better to use the Source or Minified versions.

To download the Web version, use the following command:

`wget run https://basalt.madefor.cc/install.lua web [version] [filename]`

- `version` (optional): Specify the desired version of Basalt (default: latest version). [Click here](https://github.com/Pyroxenium/Basalt/tree/master/docs/versions) to see the available versions.
- `filename` (optional): The file name for the Basalt installation (default: `basaltWeb.lua`).

**Note**: If using the Web version, remember to change `local basalt = require("basalt")` to `local basalt = require("basaltWeb")` in your code.