//
//  AssetCatalogTests.swift
//  AssetResizer
//
//  Created by Jean-Étienne on 2/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import XCTest

@testable import AssetResizer

class AssetCatalogTests: XCTestCase {

    func testFindAssetCatalog() {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let beeTestFolder = documentDirectoryURL.appendingPathComponent("Cookie")

        let paths = AssetCatalog.findAppIconSets(inFolder: beeTestFolder)
        let assetCatalog = AssetCatalog(atPath: paths[0])
        let sizes = assetCatalog.sizes
        
        for size in sizes {
            print(size)
        }        
    }

}
