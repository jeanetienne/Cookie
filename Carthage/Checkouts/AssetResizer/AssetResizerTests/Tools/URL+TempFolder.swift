//
//  AssetResizer
//  Copyright © 2019 Jean-Étienne. All rights reserved.
//

import Foundation

extension URL {

    static var cacheFolder: URL = { () -> URL in
        let folderPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return folderPath.appendingPathComponent(AssetResizerTests.identifier)
    }()

}
