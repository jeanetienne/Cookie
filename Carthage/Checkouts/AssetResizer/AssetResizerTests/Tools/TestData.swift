//
//  TestData.swift
//  AssetResizer
//
//  Created by Jean-Étienne on 1/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import AppKit

struct TestData {

    static func desktopPath(forFile filename: String) -> URL {
        let desktopDirectoryURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0]
        return desktopDirectoryURL.appendingPathComponent(filename)
    }
    
    static func image(named name: String) -> NSImage? {
        if let imageURL = Bundle.tests.url(forResource: name, withExtension: "png") {
            return NSImage(contentsOf: imageURL)
        } else {
            return nil
        }
    }
    
}
