//
//  Bundle+Tests.swift
//  Speller
//
//  Created by Jean-Étienne Parrot on 12/2/17.
//  Copyright © 2017 Speller. All rights reserved.
//

import Foundation

extension Bundle {

    static var tests: Bundle {
        return Bundle(for: AssetResizerTests.self)
    }

}
