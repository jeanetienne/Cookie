# 🍪 Cookie 

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/jeanetienne/Cookie/master/LICENSE.md) [![GitHub release](https://img.shields.io/github/release/jeanetienne/Cookie.svg)](https://github.com/jeanetienne/Cookie/releases)

A command line cookie cutter for your Xcode app icons.

## Usage

Using `cookie` is as simple as:

```
cookie -i my-app-icon.png 
```

with this command, `cookie` detects the asset sizes your project needs by reading the `Contents.json` file inside your `AppIcon.appiconset`, generates all the sizes from the source `my-app-icon.png` and update the `Contents.json` accordingly.

### Options

- `-i` or `--image`: Path to the input image.
- `-p` or `--parent`: Path to the parent folder in which to look for an `.appiconset` folder. Defaults to current path.
- `-o`, `--output`: Path to the output folder. If no path is given, images are placed in the `.appiconset` folder and the `Contents.json` file is updated accordingly.

## Installation

1. Clone or download this repository
2. Open and build the project with Xcode
3. Move or copy the produced binary (found under the project's DerivedData Build/Products/Debug folder) to `usr/local/bin`

## License

Cookie is released under the [MIT License](https://raw.githubusercontent.com/jeanetienne/Cookie/master/LICENSE.md).
