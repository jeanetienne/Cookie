//
//  NSImage+Saving.swift
//  AssetResizer
//
//  Created by Jean-Étienne on 1/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import AppKit

extension NSImage {

    enum ImageSavingError: Error {
        case WritingBitmapRepresentationFailed
    }

    func save(to url: URL, type: NSBitmapImageFileType) throws {
        if let bitmapRepresentation = representation(forType: type) {
            try bitmapRepresentation.write(to: url, options: .atomicWrite)
        } else {
            throw ImageSavingError.WritingBitmapRepresentationFailed
        }
    }

    private func representation(forType type: NSBitmapImageFileType) -> Data? {
        if let tiff = self.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            return tiffData.representation(using: type, properties: [:])
        }
        
        return nil
    }
    
}
