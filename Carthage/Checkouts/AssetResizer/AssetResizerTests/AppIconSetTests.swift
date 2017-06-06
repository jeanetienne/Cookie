//
//  AppIconSetTests.swift
//  AssetResizer
//
//  Created by Jean-Étienne on 2/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import XCTest

@testable import AssetResizer

class AppIconSetTests: XCTestCase {

    override func setUp() {
        super.setUp()
        TestData.createCacheFolder()
        TestData.copyCompressedSampleAppIconSetToCacheFolder()
        TestData.decompressSampleAppIconSet()
    }

    override func tearDown() {
        super.tearDown()
        TestData.removeCacheFolder()
    }

    func testFindAppIconSet() {
        let paths = AppIconSet.findAppIconSets(inFolder: URL.cacheFolder)

        XCTAssertEqual(paths.count, 1, "AppIconSet didn't find exactly one .appiconset")
    }
    
    func testNotFindAppIconSetInsideAppIconSet() {
        let paths = AppIconSet.findAppIconSets(inFolder: URL.cacheFolder.appendingPathComponent("SampleAppIcon.appiconset"))

        XCTAssertEqual(paths.count, 0, "AppIconSet found an .appiconset")
    }

    func testInitializingWithWrongFolder() {
        XCTAssertNil(AppIconSet(atPath: URL.cacheFolder), "AppIconSet found some sizes")
    }

    func testGettingSizes() {
        let paths = AppIconSet.findAppIconSets(inFolder: URL.cacheFolder)
        let appIconSetPath = paths[0]
        if let appIconSet = AppIconSet(atPath: appIconSetPath) {
            let sizes = appIconSet.sizes

            XCTAssertEqual(sizes.count, 44, "AppIconSet didn't find exactly 44 sizes")
        } else {
            XCTAssertTrue(false, "AppIconSet could not be initialized")
        }
    }

    func testUpdate() {
        let originalImage = TestData.image(named: "sample-red-app-icon")!
        let paths = AppIconSet.findAppIconSets(inFolder: URL.cacheFolder)
        let appIconSetPath = paths[0]
        guard var appIconSet = AppIconSet(atPath: appIconSetPath) else {
            return XCTAssertTrue(false, "AppIconSet could not be initialized")
        }

        let resizedImages = appIconSet.sizes.map { sizeDescription -> ResizedImage? in
            return ResizedImage(original: originalImage,
                                name: sizeDescription.canonicalName,
                                resizing: sizeDescription,
                                bitmapType: .PNG)
            }.flatMap { $0 }

        do {
            try appIconSet.update(with: resizedImages)
        } catch {
            XCTAssertTrue(false, "AppIconSet could not update the contents")
        }

        if let updatedSizes = AppIconSet(atPath: appIconSetPath)?.jsonRepresentation["images"] as? [[String: String]] {
            let updatedFilenames = updatedSizes.map { $0["filename"] }.flatMap { $0 }.sorted()
            let expectedFilenames = [
                "car-60x60@2x.png",
                "car-60x60@3x.png",
                "ipad-20x20@1x.png",
                "ipad-20x20@2x.png",
                "ipad-29x29@1x.png",
                "ipad-29x29@2x.png",
                "ipad-40x40@1x.png",
                "ipad-40x40@2x.png",
                "ipad-50x50@1x.png",
                "ipad-50x50@2x.png",
                "ipad-72x72@1x.png",
                "ipad-72x72@2x.png",
                "ipad-76x76@1x.png",
                "ipad-76x76@2x.png",
                "ipad-83x83@2x.png",
                "iphone-20x20@2x.png",
                "iphone-20x20@3x.png",
                "iphone-29x29@1x.png",
                "iphone-29x29@2x.png",
                "iphone-29x29@3x.png",
                "iphone-40x40@2x.png",
                "iphone-40x40@3x.png",
                "iphone-57x57@1x.png",
                "iphone-57x57@2x.png",
                "iphone-60x60@2x.png",
                "iphone-60x60@3x.png",
                "mac-16x16@1x.png",
                "mac-16x16@2x.png",
                "mac-32x32@1x.png",
                "mac-32x32@2x.png",
                "mac-128x128@1x.png",
                "mac-128x128@2x.png",
                "mac-256x256@1x.png",
                "mac-256x256@2x.png",
                "mac-512x512@1x.png",
                "mac-512x512@2x.png",
                "watch-24x24@2x.png",
                "watch-27x27@2x.png",
                "watch-29x29@2x.png",
                "watch-29x29@3x.png",
                "watch-40x40@2x.png",
                "watch-44x44@2x.png",
                "watch-86x86@2x.png",
                "watch-98x98@2x.png"
            ].sorted()

            XCTAssertEqual(updatedFilenames, expectedFilenames, "AppIconSet didn't find the expected updated contents")
        } else {
            XCTAssertTrue(false, "AppIconSet could not read the updated catalog")
        }
    }

}
