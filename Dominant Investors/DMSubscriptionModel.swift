//
//  DMSubscriptionModel.swift
//  Dominant Investors
//
//  Created by Nekit on 26.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMSubscriptionModel: NSObject {

    var id                : String?
    var userID            : String?
    var userName          : String?
    var expired_date      : Date?
    
    init(response : DMResponseObject) {
        super.init()
        self.id               = response.id
        self.userID           = response.userID
        let expiredDateString = response.fields["expiredDate"] as! String
        self.expired_date     = DMDateService.sharedInstance.dominantDateFrom(string: expiredDateString.substring(to: 10))
        self.userName = response.fields["name"] as? String
    }
}
