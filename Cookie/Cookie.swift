//
//  Cookie.swift
//  Cookie
//
//  Created by Jean-Étienne on 4/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
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
                            helpMessage: "Path to the output folder. If no path is given, images are directly replaced in the .appiconset.")
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
    
    var projectFolder: URL {
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
                if let resizedImage = image.resize(to: sizeDescription.size) {
                    return ResizedImage(image: resizedImage,
                                        sizeDescription: sizeDescription)
                } else {
                    return nil
                }
            }
            .flatMap { $0 }
    }
}
