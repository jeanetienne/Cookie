//
//  Path+Relative.swift
//  Cookie
//
//  Created by Jean-Étienne on 4/6/17.
//  Copyright © 2017 Jean-Étienne. All rights reserved.
//

import Foundation

extension Path {
    
    func relativeString(to referencePathString: String) -> String {
        let referencePath = Path(URL(fileURLWithPath: referencePathString).path).absolute()
        return self
            .absolute()
            .string
            .replacingOccurrences(of: referencePath.string,
                                  with: ".")
    }
    
}
