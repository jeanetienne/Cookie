//
//  AssetCatalog.swift
//  AssetResizer
//
//  Created by Jean-Étienne on 2/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import Foundation

public struct AssetCatalog {

    enum AssetCatalogError: Error {
        case CouldNotReadImageSizesFromJSON
    }

    private let path: URL
    
    private var jsonPath: URL {
        return path.appendingPathComponent("Contents.json")
    }
    
    private var jsonContents: [String: Any]?
    
    public var sizes: [SizeDescription] {
        if let jsonSizes = jsonContents?["images"] as? [[String: String]] {
            return jsonSizes.map { jsonSize -> SizeDescription? in
                return SizeDescription(json: jsonSize)
                }.flatMap { $0 }
        } else {
            return []
        }
    }
    
    public static func findAppIconSets(inFolder folder: URL) -> [URL] {
        return AssetCatalog.findCatalogs(withExtension: "appiconset", inFolder: folder)
    }
    
    public static func findCatalogs(withExtension fileExtension: String, inFolder folder: URL) -> [URL] {
        let keys = [URLResourceKey.isDirectoryKey]
        if let enumerator = FileManager.default.enumerator(at: folder, includingPropertiesForKeys: keys) {
            let allPaths = enumerator.allObjects as! [URL]
            return allPaths.filter { $0.pathExtension == fileExtension }
        }
        
        return []
    }
    
    public init(atPath aPath: URL) {
        path = aPath
        jsonContents = readContents(atPath: jsonPath)
    }

    public mutating func updateContents(with resizedImages: [ResizedImage]) throws {
        guard let jsonSizes = jsonContents?["images"] as? [[String: String]] else {
            throw AssetCatalogError.CouldNotReadImageSizesFromJSON
        }

        jsonContents?["images"] = jsonSizes
            .map { jsonSize -> [String: String]? in
                guard let jsonSizeDescription = SizeDescription(json: jsonSize) else {
                    return nil
                }

                let resizedImage = resizedImages.first { resizedImage -> Bool in
                    resizedImage.sizeDescription == jsonSizeDescription
                }

                var newJsonSize = jsonSize
                newJsonSize["filename"] = resizedImage?.filename

                return newJsonSize
            }
            .flatMap { $0 }

        if let jsonContents = jsonContents {
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonContents, options: .prettyPrinted)
            try? jsonData?.write(to: path.appendingPathComponent("Contents.json"))
        }
    }

    // MARK: - Private helpers
    private func readContents(atPath path: URL) -> [String: Any]? {
        if let data = try? Data(contentsOf: path),
            let JSON = try? JSONSerialization.jsonObject(with: data) {
            return JSON as? [String: Any]
        } else {
            return nil
        }
    }
    
}
