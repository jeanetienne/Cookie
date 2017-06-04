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

        let sizeDescriptions = [
            SizeDescription(name: "iphone", size: NSSize(width: 500, height: 500), pixelDensity: 2),
            SizeDescription(name: "ipad", size: NSSize(width: 100, height: 100), pixelDensity: 2)
        ]
        
        let resizedImages = sizeDescriptions.map { sizeDescription -> ResizedImage? in
            if let resizedImage = original.resize(to: sizeDescription.size) {
                return ResizedImage(image: resizedImage,
                                    sizeDescription: sizeDescription)
            } else {
                return nil
            }
        }.flatMap { $0 }
        
        for resizedImage in resizedImages {
            let resizedImageURL = TestData.desktopPath(forFile: "\(resizedImage.sizeDescription.canonicalName).png")
            try? resizedImage.save(to: resizedImageURL, type: .PNG)
        }

        XCTAssertEqual(resizedImages.count, 2)
    }
    
}
