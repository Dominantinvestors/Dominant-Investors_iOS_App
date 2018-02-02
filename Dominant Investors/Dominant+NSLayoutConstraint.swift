//
//  Dominant+NSLayoutConstraint.swift
//  Dominant Investors
//
//  Created by ios_nikitos on 06.12.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import Foundation
import UIKit
extension NSLayoutConstraint {
 
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
