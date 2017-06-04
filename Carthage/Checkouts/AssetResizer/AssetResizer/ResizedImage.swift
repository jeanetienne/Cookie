//
//  ResizedImage.swift
//  AssetResizer
//
//  Created by Jean-Étienne on 1/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import AppKit

public struct ResizedImage {
    
    public let name: String

    public let image: NSImage
    
    public let sizeDescription: SizeDescription

    public let bitmapType: NSBitmapImageFileType

    public var filename: String {
        return "\(name).\(bitmapType.fileExtension)"
    }

    public func save(at path: URL) throws {
        try image.save(to: path.appendingPathComponent(filename), type: bitmapType)
    }
    
}

public struct SizeDescription {
    
    public let name: String
    
    public var size: NSSize {
        return NSSize(width: pointSize.width * CGFloat(pixelDensity),
                      height: pointSize.height * CGFloat(pixelDensity))
    }
    
    public let pixelDensity: Int
    
    private let pointSize: NSSize
    
    public var canonicalName: String {
        return "\(name)-\(Int(pointSize.width))x\(Int(pointSize.height))@\(pixelDensity)x"
    }
    
    public init(name aName: String, size aSize: NSSize, pixelDensity aPixelDensity: Int) {
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

extension NSBitmapImageFileType {

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
