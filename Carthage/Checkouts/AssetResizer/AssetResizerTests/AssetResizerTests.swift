//
//  AssetResizerTests.swift
//  AssetResizer
//
//  Created by Jean-Étienne on 1/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import XCTest

@testable import AssetResizer

class AssetResizerTests: XCTestCase {

    func test_iOS_app_icon() {
        guard let original = TestData.image(named: "sample-blue-app-icon") else {
            XCTAssertTrue(false, "Could not load sample image")
            return
        }

        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let sampleProjectFolder = documentDirectoryURL.appendingPathComponent("Cookie")

        let paths = AssetCatalog.findAppIconSets(inFolder: sampleProjectFolder)
        let appIconSetPath = paths[0]
        var assetCatalog = AssetCatalog(atPath: appIconSetPath)
        let sizeDescriptions = assetCatalog.sizes

        let resizedImages = sizeDescriptions.map { sizeDescription -> ResizedImage? in
            if let resizedImage = original.resize(to: sizeDescription.size) {
                return ResizedImage(name: sizeDescription.canonicalName,
                                    image: resizedImage,
                                    sizeDescription: sizeDescription,
                                    bitmapType: .PNG)
            } else {
                return nil
            }
        }.flatMap { $0 }

        try? assetCatalog.updateContents(with: resizedImages)

        for resizedImage in resizedImages {
            try? resizedImage.save(at: appIconSetPath)
        }

//        XCTAssertEqual(resizedImages.count, 6)
    }
    
}
