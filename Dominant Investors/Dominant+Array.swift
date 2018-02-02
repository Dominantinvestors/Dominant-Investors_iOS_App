//
//  Dominant+Array.swift
//  Dominant Investors
//
//  Created by Nekit on 26.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
