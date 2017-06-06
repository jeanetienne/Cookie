//
//  TestData.swift
//  AssetResizer
//
//  Created by Jean-Étienne on 1/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import AppKit

struct TestData {

    static func createCacheFolder() {
        self.removeCacheFolder()
        try? FileManager.default.createDirectory(at: URL.cacheFolder,
                                                 withIntermediateDirectories: true,
                                                 attributes: nil)
    }

    static func removeCacheFolder() {
        try? FileManager.default.removeItem(at: URL.cacheFolder)
    }

    static func copyCompressedSampleAppIconSetToCacheFolder() {
        let fileManager = FileManager.default
        let compressedSampleAppIconSetPath = Bundle.tests.url(forResource: "SampleAppIcon.appiconset", withExtension: "zip")!
        do {
            try fileManager.copyItem(at: compressedSampleAppIconSetPath, to: URL.cacheFolder.appendingPathComponent("SampleAppIcon.appiconset.zip"))
        } catch {
            print("Could not move 'SampleAppIcon.appiconset' to test folder")
        }
    }

    static func decompressSampleAppIconSet() {
        let compressedSampleAppIconSetPath = URL.cacheFolder.appendingPathComponent("SampleAppIcon.appiconset.zip")
        let unzipProcess = Process()
        unzipProcess.launchPath = "/usr/bin/unzip"
        unzipProcess.arguments = [
            compressedSampleAppIconSetPath.path,
            "-d",
            URL.cacheFolder.path
        ]
        unzipProcess.launch()
        unzipProcess.waitUntilExit()
    }

    static func image(named name: String) -> NSImage? {
        if let imageURL = Bundle.tests.url(forResource: name, withExtension: "png") {
            return NSImage(contentsOf: imageURL)
        } else {
            return nil
        }
    }
    
}
