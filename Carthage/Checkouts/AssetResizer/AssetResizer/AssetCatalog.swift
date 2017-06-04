//
//  AssetCatalog.swift
//  AssetResizer
//
//  Created by Jean-Étienne on 2/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import Foundation

public struct AssetCatalog {
    
    private let path: URL
    
    private var jsonPath: URL {
        return path.appendingPathComponent("Contents.json")
    }
    
    private var jsonContents: [String: Any]?
    
    public var sizes: [SizeDescription] {
        if let jsonSizes = jsonContents?["images"] as? [[String: String]] {
            return jsonSizes.map { jsonSize -> SizeDescription? in
                return AssetCatalog.sizeDescription(forJSON: jsonSize)
                }.flatMap { $0 }
        } else {
            return []
        }
    }
    
    public init(atPath aPath: URL) {
        path = aPath
        jsonContents = readContents(atPath: jsonPath)
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
    
    // MARK: - Private helpers
    private func readContents(atPath path: URL) -> [String: Any]? {
        if let data = try? Data(contentsOf: path),
            let JSON = try? JSONSerialization.jsonObject(with: data) {
            return JSON as? [String: Any]
        } else {
            return nil
        }
    }
    
    private static func sizeDescription(forJSON json: [String: String]) -> SizeDescription? {
        guard
            let name = json["idiom"],
            let sizeComponents = json["size"]?.components(separatedBy: "x"),
            let width = Double(sizeComponents[0]),
            let height = Double(sizeComponents[1]),
            let pixelDensityString = json["scale"],
            let pixelDensity = Int(pixelDensityString.replacingOccurrences(of: "x", with: ""))
            else {
            return nil
        }

        return SizeDescription(name: name,
                               size: NSSize(width: width, height: height),
                               pixelDensity: pixelDensity)
    }
    
}
