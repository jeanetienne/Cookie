//
//  NSImage+Resizing.swift
//  AssetResizer
//
//  Created by Jean-Étienne on 1/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import AppKit

extension NSImage {
    
    func resize(to size: NSSize) -> NSImage? {
        let frame = CGRect(origin: CGPoint.zero, size: size)
        guard let bestRepresentation = self.bestRepresentation(for: frame,
                                                               context: nil,
                                                               hints: [NSImageHintInterpolation: NSImageInterpolation.high])
            else {
            return nil
        }

        return NSImage(size: size, flipped: false) { _ -> Bool in
            return bestRepresentation.draw(in: frame)
        }
    }
    
}
