//
//  ResizedImageTests.swift
//  AssetResizer
//
//  Created by Jean-Étienne on 5/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import XCTest

@testable import AssetResizer

class ResizedImageTests: XCTestCase {

    override func setUp() {
        super.setUp()
        TestData.createCacheFolder()
    }
    
    override func tearDown() {
        super.tearDown()
        TestData.removeCacheFolder()
    }

    func testFailingInitialization() {
        let image = NSImage()
        let sizeDescription = SizeDescription(name: "failed",
                                              pointSize: NSSize(width: 0, height: 0),
                                              pixelDensity: 0)
        let resizedImage = ResizedImage(original: image,
                                        name: "failed",
                                        resizing: sizeDescription,
                                        bitmapType: .PNG)
        XCTAssertNil(resizedImage)
    }

    func testFilenameInPNG() {
        let image = TestData.image(named: "sample-blue-app-icon")
        let sizeDescription = SizeDescription(name: "iphone",
                                              pointSize: NSSize(width: 10, height: 10),
                                              pixelDensity: 1)
        if let resizedImage = ResizedImage(original: image!,
                                           name: "foo",
                                           resizing: sizeDescription,
                                           bitmapType: .PNG) {
            XCTAssertEqual(resizedImage.filename, "foo.png", "Resized image has wrong filename")
        } else {
            XCTAssertTrue(false, "Resized image could not be initialized")
        }
    }
    
    func testFilenameInTIFF() {
        let image = TestData.image(named: "sample-blue-app-icon")
        let sizeDescription = SizeDescription(name: "iphone",
                                              pointSize: NSSize(width: 10, height: 10),
                                              pixelDensity: 1)
        if let resizedImage = ResizedImage(original: image!,
                                           name: "bar",
                                           resizing: sizeDescription,
                                           bitmapType: .TIFF) {
            XCTAssertEqual(resizedImage.filename, "bar.tiff", "Resized image has wrong filename")
        } else {
            XCTAssertTrue(false, "Resized image could not be initialized")
        }
    }
    
    func testFilenameInJPEG2000() {
        let image = TestData.image(named: "sample-blue-app-icon")
        let sizeDescription = SizeDescription(name: "iphone",
                                              pointSize: NSSize(width: 10, height: 10),
                                              pixelDensity: 1)
        if let resizedImage = ResizedImage(original: image!,
                                           name: "baz",
                                           resizing: sizeDescription,
                                           bitmapType: .JPEG2000) {
            XCTAssertEqual(resizedImage.filename, "baz.jpg", "Resized image has wrong filename")
        } else {
            XCTAssertTrue(false, "Resized image could not be initialized")
        }
    }

    func testFilenameInBMP() {
        let image = TestData.image(named: "sample-blue-app-icon")
        let sizeDescription = SizeDescription(name: "iphone",
                                              pointSize: NSSize(width: 10, height: 10),
                                              pixelDensity: 1)
        if let resizedImage = ResizedImage(original: image!,
                                           name: "baz",
                                           resizing: sizeDescription,
                                           bitmapType: .BMP) {
            XCTAssertEqual(resizedImage.filename, "baz.bmp", "Resized image has wrong filename")
        } else {
            XCTAssertTrue(false, "Resized image could not be initialized")
        }
    }

    func testFilenameInGIF() {
        let image = TestData.image(named: "sample-blue-app-icon")
        let sizeDescription = SizeDescription(name: "iphone",
                                              pointSize: NSSize(width: 10, height: 10),
                                              pixelDensity: 1)
        if let resizedImage = ResizedImage(original: image!,
                                           name: "baz",
                                           resizing: sizeDescription,
                                           bitmapType: .GIF) {
            XCTAssertEqual(resizedImage.filename, "baz.gif", "Resized image has wrong filename")
        } else {
            XCTAssertTrue(false, "Resized image could not be initialized")
        }
    }

    func testFilenameInJPEG() {
        let image = TestData.image(named: "sample-blue-app-icon")
        let sizeDescription = SizeDescription(name: "iphone",
                                              pointSize: NSSize(width: 10, height: 10),
                                              pixelDensity: 1)
        if let resizedImage = ResizedImage(original: image!,
                                           name: "baz",
                                           resizing: sizeDescription,
                                           bitmapType: .JPEG) {
            XCTAssertEqual(resizedImage.filename, "baz.jpg", "Resized image has wrong filename")
        } else {
            XCTAssertTrue(false, "Resized image could not be initialized")
        }
    }

    func testSavingToDisk() {
        let image = TestData.image(named: "sample-blue-app-icon")
        let sizeDescription = SizeDescription(name: "iphone",
                                              pointSize: NSSize(width: 50, height: 50),
                                              pixelDensity: 2)
        if let resizedImage = ResizedImage(original: image!,
                                           name: sizeDescription.canonicalName,
                                           resizing: sizeDescription,
                                           bitmapType: .PNG) {
            try? resizedImage.save(at: URL.cacheFolder)
            let resizedImageURL = URL.cacheFolder.appendingPathComponent(resizedImage.filename)
            XCTAssertNotNil(NSImage(contentsOf: resizedImageURL),
                            "Resized image didn't save to disk")
        } else {
            XCTAssertTrue(false, "Resized image could not be saved")
        }
    }

}
