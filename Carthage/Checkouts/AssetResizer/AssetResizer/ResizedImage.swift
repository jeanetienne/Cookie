//
//  ResizedImage.swift
//  AssetResizer
//
//  Created by Jean-Étienne on 1/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import AppKit

public struct ResizedImage {
    
    public let image: NSImage
    
    public let sizeDescription: SizeDescription
    
    public func save(to path: URL, type: NSBitmapImageFileType = .PNG) throws {
        try image.save(to: path, type: type)
    }
    
}

public struct SizeDescription {
    
    public let name: String
    
    public let size: NSSize
    
    public let pixelDensity: Int
    
    private let pointSize: NSSize
    
    public var canonicalName: String {
        return "\(name)-\(Int(pointSize.width))x\(Int(pointSize.height))@\(pixelDensity)x"
    }
    
    public init(name aName: String, size aSize: NSSize, pixelDensity aPixelDensity: Int) {
        name = aName
        size = NSSize(width: aSize.width * CGFloat(aPixelDensity),
                      height: aSize.height * CGFloat(aPixelDensity))
        pixelDensity = aPixelDensity
        pointSize = aSize
    }
    
}

extension SizeDescription: CustomDebugStringConvertible {

    public var debugDescription: String {
        return canonicalName
    }
    
}
