//
//  DMUserProfileModel.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import Foundation
import Quickblox

class DMUserProfileModel: NSObject, NSCoding {
    
    var userID            : String!
    var userName          : String!
    var userProfileImage  : String!
    var createdAt         : Date?
    
    var userRating        : UInt!
        
    init(response : DMResponseObject) {
        super.init()
        self.userID           = response.id
        self.userName         = response.login
        self.userProfileImage = response.customData
        self.userRating       = 0
        self.createdAt        = response.createdAt
    }
    
    // MARK: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        self.userID           = aDecoder.decodeObject(forKey: "userID") as! String
        self.userName         = aDecoder.decodeObject(forKey: "userName") as! String
        self.userRating       = aDecoder.decodeObject(forKey: "userRating") as! UInt
        
        
        if let timeInterval = aDecoder.decodeDouble(forKey: "createdAt") as? Double{
            let date = Date(timeIntervalSince1970: timeInterval)
            self.createdAt = date
        }
       
    }
    
     public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userID, forKey: "userID")
        aCoder.encode(self.userName, forKey: "userName")
        aCoder.encode(self.userRating, forKey: "userRating")
        
        if let createdDate = self.createdAt {
            var nowInterval = createdDate.timeIntervalSince1970                                  // 1491800604.362141
            let data = Data(bytes: &nowInterval, count: MemoryLayout<TimeInterval>.size)    // 8 bytes
            let timeInterval: Double = data.withUnsafeBytes{ $0.pointee }
        
            aCoder.encode(timeInterval, forKey: "createdAt")
        }
        
    }
}
