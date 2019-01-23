//
//  AssetResizer
//  Copyright © 2019 Jean-Étienne. All rights reserved.
//

import XCTest

@testable import AssetResizer

class SizeDescriptionTests: XCTestCase {

    func testJSONParsing() {
        let json = [
            "size": "200x300",
            "filename": "sample-file.png",
            "idiom": "iphone",
            "scale": "3x"
        ]

        if let jsonSizeDescription = SizeDescription(json: json) {
            let expectedSizeDescription = SizeDescription(name: "iphone",
                                                          pointSize: NSSize(width: 200, height: 300),
                                                          pixelDensity: 3)
            XCTAssertEqual(jsonSizeDescription, expectedSizeDescription, "Size description initialized with JSON is incorrect")
        } else {
            XCTAssertTrue(false, "Size description could not be initialized from JSON")
        }
    }
    
    func testJSONParsingWithoutFilename() {
        let json = [
            "size": "50x100",
            "idiom": "ipad",
            "scale": "2x"
        ]

        if let jsonSizeDescription = SizeDescription(json: json) {
            let expectedSizeDescription = SizeDescription(name: "ipad",
                                                          pointSize: NSSize(width: 50, height: 100),
                                                          pixelDensity: 2)
            XCTAssertEqual(jsonSizeDescription, expectedSizeDescription, "Size description initialized with JSON is incorrect")
        } else {
            XCTAssertTrue(false, "Size description could not be initialized from JSON")
        }
    }
    
    func testJSONParsingMissingCriticalKey() {
        let json = [
            "size": "50x100",
            "filename": "sample-file.png",
            "idiom": "ipad"
        ]

        XCTAssertNil(SizeDescription(json: json), "Size description could be initialized with missing JSON key/values")
    }
    
}
