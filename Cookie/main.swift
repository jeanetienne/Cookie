//
//  main.swift
//  Cookie
//
//  Created by Jean-Étienne on 3/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import Foundation

let cookie = Cookie()

do {
    try cookie.cli.parse()
} catch {
    cookie.cli.printUsage(error)
    exit(EX_USAGE)
}

// Finding .appiconset folders
print("-> Looking for a .appiconset in:")
print(cookie.projectFolder.path)
let paths = AssetCatalog.findAppIconSets(inFolder: cookie.projectFolder)

// Choosing which .appiconset folder to use
let appIconSetPath = paths[0]
if paths.count > 1 {
    let relativePath = Path(appIconSetPath.path).relativeString(to: cookie.projectFolder.path)
    print("-> Multiple .appiconset found, using:")
    print(relativePath)
}

// Reading sizing options from content.json
let sizeDescriptions = AssetCatalog(atPath: appIconSetPath).sizes

// Cutting images
let resizedImages = cookie.cut(atSizes: sizeDescriptions)

// Saving images
for resizedImage in resizedImages {
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let resizedImageURL = currentDirectoryURL.appendingPathComponent("\(resizedImage.sizeDescription.canonicalName).png")
//    try? resizedImage.save(to: resizedImageURL, type: .PNG)
}
