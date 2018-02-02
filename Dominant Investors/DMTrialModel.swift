//
//  DMTrialModel.swift
//  Dominant Investors
//
//  Created by ios_nikitos on 29.11.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMTrialModel: NSObject {

    var id                : String?
    var name              : String?
    var deviceUDID        : String?
    var trialBuyed        : Bool?
    var trialStarted      : Date?
    
    init(response : DMResponseObject) {
        super.init()
        
        self.id = response.id ?? ""
        self.name = response.fields["name"] as? String ?? ""
        self.trialBuyed = response.fields["trialBuyed"] as? Bool ?? false
        self.deviceUDID = response.fields["deviceUDID"] as? String ?? ""
        
        if let trialStartedResp = response.fields["trialStarted"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            self.trialStarted = formatter.date(from: trialStartedResp)
        } else {
            self.trialStarted = Date()
        }
        
        
    
    }
}
