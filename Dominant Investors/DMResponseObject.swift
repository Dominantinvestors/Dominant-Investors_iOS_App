//
//  DMResponseObject.swift
//  Dominant Investors
//
//  Created by Nekit on 22.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import Foundation
import Quickblox

class DMResponseObject: NSObject {

    var id     : String?
    var login  : String?
    var email  : String?
    var userID : String?
    var createdAt : Date?
    var customData : String?
    
    var fields = [String : Any]()
    
    
    init(user : QBUUser) {
        super.init()
        self.id = String(user.id)
        self.login  = user.login
        self.email  = user.email
    
        
        if let registrationDate = user.createdAt {
            self.createdAt = registrationDate
        }

        self.customData = user.customData
    }
    
    init(customObject : QBCOCustomObject) {
        super.init()
        self.id = customObject.id
        self.userID = String(customObject.userID)
        
        for (value, key) in customObject.fields {
            self.fields[value as! String] = key
        }
    }
    
}
