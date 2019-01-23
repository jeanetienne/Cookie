//
//  Cookie
//  Copyright © 2019 Jean-Étienne. All rights reserved.
//

import AppKit

struct Cookie {
    
    let cli: CommandLine
    
    private let imagePathOption: StringOption = {
        return StringOption(shortFlag: "i", longFlag: "image", required: true,
                            helpMessage: "Path to the input image.")
    }()

    private let parentFolderOption: StringOption = {
        return StringOption(shortFlag: "p", longFlag: "parent", required: false,
                            helpMessage: "Path to the parent folder in which to look for an .appiconset. Defaults to current path.")
    }()
    
    private let outputFolderOption: StringOption = {
        return StringOption(shortFlag: "o", longFlag: "output", required: false,
                            helpMessage: "Path to the output folder. If no path is given, images are placed in the .appiconset folder and the Contents.json file is updated accordingly")
    }()
    
    private var imagePath: URL? {
        if let imagePathValue = imagePathOption.value {
            return Path(imagePathValue).absolute().url
        } else {
            return nil
        }
    }
    
    private var image: NSImage? {
        if let path = imagePath {
            return NSImage(contentsOf: path)
        } else {
            return nil
        }
    }
    
    var parentFolder: URL {
        if let parentFolderValue = parentFolderOption.value {
            return Path(parentFolderValue).absolute().url
        } else {
            return URL(fileURLWithPath: FileManager.default.currentDirectoryPath,
                       isDirectory: true)
        }
    }

    var outputFolder: URL? {
        if let outputFolderValue = outputFolderOption.value {
            return Path(outputFolderValue).absolute().url
        } else {
            return nil
        }
    }

    init() {
        let commandLine = CommandLine()
        commandLine.addOptions(
            imagePathOption,
            parentFolderOption,
            outputFolderOption
        )
        
        cli = commandLine
    }

    func cut(atSizes sizeDescriptions: [SizeDescription]) -> [ResizedImage] {
        guard let image = cookie.image else {
            return []
        }

        return sizeDescriptions
            .map { sizeDescription -> ResizedImage? in
                return ResizedImage(original: image,
                                    name: sizeDescription.canonicalName,
                                    resizing: sizeDescription,
                                    bitmapType: .png)
            }
            .compactMap { $0 }
    }
}
