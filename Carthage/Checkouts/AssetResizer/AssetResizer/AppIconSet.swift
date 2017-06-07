//
//  AppIconSet.swift
//  AssetResizer
//
//  Created by Jean-Étienne on 2/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import Foundation

/// A value that represents the content of an App Icon Set (*.appiconset) in a
/// Xcode asset catalog.
public struct AppIconSet {

    /// Errors thrown when dealing with the `Contents.json` file within the app
    /// icon set. Possible values:
    ///
    /// - `UnknownImageSizes`
    /// - `WriteError`
    enum AppIconSetJSONSerializationError: Error {

        /// Error thrown when the "images" JSON sub-object of the
        /// `Contents.json` can't be read as a `[[String: String]]`.
        case UnknownImageSizes

        /// Error thrown when the `Contents.json` can't be written to.
        case WriteError

    }

    private static let pathExtension = "appiconset"

    private let path: URL
    
    private var jsonPath: URL {
        return path.appendingPathComponent("Contents.json")
    }
    
    private var jsonContents: [String: Any]!

    /// For internal use only.
    internal var jsonRepresentation: [String: Any] {
        return jsonContents
    }

    /// The sizes required by this app icon set
    public var sizes: [SizeDescription] {
        if let jsonSizes = jsonContents["images"] as? [[String: String]] {
            return jsonSizes.map { jsonSize -> SizeDescription? in
                return SizeDescription(json: jsonSize)
                }.flatMap { $0 }
        } else {
            return []
        }
    }
    
    /// Returns the paths of all `*.appiconset` folders found in `folder`.
    ///
    /// - Parameter folder: A folder in which to search for app icon sets
    /// - Returns: An array of paths in which the last component is a folder
    ///   with the `*.appiconset` extension, in the order they are traversed.
    ///   Can be empty.
    public static func find(in folder: URL) -> [URL] {
        return self.findItems(withExtension: self.pathExtension, inFolder: folder)
    }
    
    private static func findItems(withExtension fileExtension: String, inFolder folder: URL) -> [URL] {
        let keys = [URLResourceKey.isDirectoryKey]
        if let enumerator = FileManager.default.enumerator(at: folder, includingPropertiesForKeys: keys) {
            let allPaths = enumerator.allObjects as! [URL]
            return allPaths.filter { $0.pathExtension == fileExtension }
        } else {
            return []
        }
    }
    
    /// Initializes with a path to an app icon set
    ///
    /// - Parameter aPath: Path to a folder with an `*.appiconset` extension
    ///
    /// Returns nil if the path doesn't lead to a folder with a `*.appiconset`
    /// extension, or if it doesn't contain a readable `Contents.json` file.
    public init?(atPath aPath: URL) {
        if aPath.pathExtension != AppIconSet.pathExtension {
            return nil
        }

        path = aPath

        if let contents = AppIconSet.readContents(atPath: jsonPath) {
            jsonContents = contents
        } else {
            return nil
        }
    }

    /// Updates the `Contents.json` file with the filenames of the assets for
    /// the corresponding sizes.
    ///
    /// - Parameter resizedImages: An array of resized images
    public mutating func update(with resizedImages: [ResizedImage]) throws {
        guard let jsonSizes = jsonContents["images"] as? [[String: String]] else {
            throw AppIconSetJSONSerializationError.UnknownImageSizes
        }

        jsonContents["images"] = jsonSizes
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

        do {
            try AppIconSet.write(jsonContents: jsonContents, atPath: jsonPath)
        } catch {
            throw AppIconSetJSONSerializationError.WriteError
        }
    }

    // MARK: - Private helpers
    private static func readContents(atPath path: URL) -> [String: Any]? {
        if let data = try? Data(contentsOf: path),
            let JSON = try? JSONSerialization.jsonObject(with: data) {
            return JSON as? [String: Any]
        } else {
            return nil
        }
    }

    private static func write(jsonContents contents: [String: Any], atPath path: URL) throws {
        try JSONSerialization
            .data(withJSONObject: contents, options: .prettyPrinted)
            .write(to: path)
    }

}
