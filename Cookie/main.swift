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
let paths = AppIconSet.findAppIconSets(inFolder: cookie.projectFolder)

// Choosing which .appiconset folder to use
let appIconSetPath = paths[0]
let appIconSetRelativePath = Path(appIconSetPath.path).relativeString(to: cookie.projectFolder.path)
if paths.count > 1 {
    print("-> Multiple .appiconset found, using:")
    print(appIconSetRelativePath)
}

// Reading sizing options from content.json
guard var appIconSet = AppIconSet(atPath: appIconSetPath) else {
    print("Error: could not read app icon set at path: \(appIconSetPath)")
    exit(EX_USAGE)
}
let sizeDescriptions = appIconSet.sizes

// Cutting images
let resizedImages = cookie.cut(atSizes: sizeDescriptions)

// Saving images in .appiconset
for resizedImage in resizedImages {
    try? resizedImage.save(at: appIconSetPath)
}

// Updating .appiconset Content.json
try? appIconSet.update(with: resizedImages)
print("-> Updated \(appIconSetRelativePath) with \(resizedImages.count) images")
