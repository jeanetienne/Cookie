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
        let paths = AppIconSet.find(in: URL.cacheFolder)

        XCTAssertEqual(paths.count, 1, "AppIconSet didn't find exactly one .appiconset")
    }
    
    func testNotFindAppIconSetInsideAppIconSet() {
        let paths = AppIconSet.find(in: URL.cacheFolder.appendingPathComponent("SampleAppIcon.appiconset"))

        XCTAssertEqual(paths.count, 0, "AppIconSet found an .appiconset")
    }

    func testInitializingWithWrongFolder() {
        XCTAssertNil(AppIconSet(atPath: URL.cacheFolder), "AppIconSet found some sizes")
    }

    func testGettingSizes() {
        let paths = AppIconSet.find(in: URL.cacheFolder)
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
        let paths = AppIconSet.find(in: URL.cacheFolder)
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
                "car-60@2x.png",
                "car-60@3x.png",
                "ipad-20@1x.png",
                "ipad-20@2x.png",
                "ipad-29@1x.png",
                "ipad-29@2x.png",
                "ipad-40@1x.png",
                "ipad-40@2x.png",
                "ipad-50@1x.png",
                "ipad-50@2x.png",
                "ipad-72@1x.png",
                "ipad-72@2x.png",
                "ipad-76@1x.png",
                "ipad-76@2x.png",
                "ipad-83.5@2x.png",
                "iphone-20@2x.png",
                "iphone-20@3x.png",
                "iphone-29@1x.png",
                "iphone-29@2x.png",
                "iphone-29@3x.png",
                "iphone-40@2x.png",
                "iphone-40@3x.png",
                "iphone-57@1x.png",
                "iphone-57@2x.png",
                "iphone-60@2x.png",
                "iphone-60@3x.png",
                "mac-16@1x.png",
                "mac-16@2x.png",
                "mac-32@1x.png",
                "mac-32@2x.png",
                "mac-128@1x.png",
                "mac-128@2x.png",
                "mac-256@1x.png",
                "mac-256@2x.png",
                "mac-512@1x.png",
                "mac-512@2x.png",
                "watch-24@2x.png",
                "watch-27.5@2x.png",
                "watch-29@2x.png",
                "watch-29@3x.png",
                "watch-40@2x.png",
                "watch-44@2x.png",
                "watch-86@2x.png",
                "watch-98@2x.png"
            ].sorted()

            XCTAssertEqual(updatedFilenames, expectedFilenames, "AppIconSet didn't find the expected updated contents")
        } else {
            XCTAssertTrue(false, "AppIconSet could not read the updated catalog")
        }
    }

}
