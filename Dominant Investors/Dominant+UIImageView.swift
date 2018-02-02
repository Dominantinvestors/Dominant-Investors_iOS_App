//
//  Dominant+UIImageView.swift
//  Dominant Investors
//
//  Created by Nekit on 30.05.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    
    func asCircle(){
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true
    }
    
}
