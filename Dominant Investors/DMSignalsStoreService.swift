//
//  DMSignalsStoreService.swift
//  Dominant Investors
//
//  Created by Nekit on 18.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMSignalsStoreService: NSObject {

    static let sharedInstance = DMSignalsStoreService()
    
    open func checkSubscription(completion : @escaping (DMSubscriptionModel?) -> Void) {
        DMQuickBloxService.sharedInstance.checkSubscription(completion: completion)
    }
    
    open func successPurchaseWith(expired_date : Date, completion : @escaping (Bool) -> Void) {
        DMQuickBloxService.sharedInstance.successPurchaseWith(expired_date : expired_date, completion : completion)
    }
    
    open func isSubscriptionValid(subscription : DMSubscriptionModel) -> Bool {
        if (subscription.expired_date?.compare(Date()) != ComparisonResult.orderedAscending) {
            return true
        }
        return false
    }
}
