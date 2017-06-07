//
//  ResizedImage.swift
//  AssetResizer
//
//  Created by Jean-Étienne on 1/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import AppKit

/// A value that represents the resized version of an original image
public struct ResizedImage {

    /// Resized image
    public let image: NSImage

    /// Name of the image
    public let name: String

    /// Description of the size used to resize the original
    public let sizeDescription: SizeDescription

    /// The bitmap type to be used when saving this image to disk
    public let bitmapType: NSBitmapImageFileType

    /// The filename to be used when saving this image to disk
    public var filename: String {
        return "\(name).\(bitmapType.fileExtension)"
    }

    /// Initializes with the original image
    ///
    /// - Parameter original: The original to used to create the resized version.
    /// - Parameter name: The name to use for this image.
    /// - Parameter resizing: The size description to use to resize the original.
    /// - Parameter bitmapType: The bitmap type to be used when saving this image to disk.
    ///
    /// Returns nil if the original couldn't be resized.
    init?(original: NSImage,
          name aName: String,
          resizing aSizeDescription: SizeDescription,
          bitmapType aBitmapType: NSBitmapImageFileType) {
        guard let resizedOriginal = original.resize(to: aSizeDescription.pixelSize) else {
            return nil
        }
        image = resizedOriginal
        name = aName
        sizeDescription = aSizeDescription
        bitmapType = aBitmapType
    }

    /// Saves the image to disk at `path`, using the name and bitmap type
    /// provided at initialization.
    ///
    /// - Parameter path: Path at which to write the image to disk.
    public func save(at path: URL) throws {
        try image.save(to: path.appendingPathComponent(filename), type: bitmapType)
    }
    
}

public struct SizeDescription {
    
    public let name: String
    
    public var pixelSize: NSSize {
        return NSSize(width: pointSize.width * CGFloat(pixelDensity),
                      height: pointSize.height * CGFloat(pixelDensity))
    }
    
    public let pixelDensity: Int
    
    private let pointSize: NSSize
    
    public var canonicalName: String {
        return "\(name)-\(pointSize.description)@\(pixelDensity)x"
    }
    
    public init(name aName: String, pointSize aSize: NSSize, pixelDensity aPixelDensity: Int) {
        name = aName
        pixelDensity = aPixelDensity
        pointSize = aSize
    }

    public init?(json: [String: String]) {
        guard
            let aName = json["idiom"],
            let sizeComponents = json["size"]?.components(separatedBy: "x"),
            let width = Double(sizeComponents[0]),
            let height = Double(sizeComponents[1]),
            let pixelDensityString = json["scale"],
            let aPixelDensity = Int(pixelDensityString.replacingOccurrences(of: "x", with: ""))
            else {
                return nil
        }

        name = aName
        pixelDensity = aPixelDensity
        pointSize = NSSize(width: width, height: height)
    }
}

extension SizeDescription: Equatable {

    public static func ==(lhs: SizeDescription, rhs: SizeDescription) -> Bool {
        return lhs.canonicalName == rhs.canonicalName
    }

}

extension SizeDescription: CustomDebugStringConvertible {

    public var debugDescription: String {
        return canonicalName
    }
    
}

private extension NSSize {

    var description: String {
        if width == height {
            return width.description
        } else {
            return "\(width.description)x\(height.description)"
        }
    }

}

private extension CGFloat {

    var description: String {
        if ceil(self) == self {
            return "\(Int(self))"
        } else {
            return String(format: "%.1f", self)
        }
    }

}

private extension NSBitmapImageFileType {

    var fileExtension: String {
        switch self {
        case .TIFF:
            return "tiff"
        case .BMP:
            return "bmp"
        case .GIF:
            return "gif"
        case .JPEG:
            return "jpg"
        case .PNG:
            return "png"
        case .JPEG2000:
            return "jpg"
        }
    }

}
