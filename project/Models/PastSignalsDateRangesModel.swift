//
//  PastSignalsDateRangesModel.swift
//  DominantInvestors
//
//  Created by Andrew Konovalskiy on 30.08.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import Foundation
import ObjectMapper

struct PastSignalsDateRangesModel: Mappable, Hashable {
    
    var title: String = ""
    var startDate: String = ""
    var endDate: String = ""
    
    init?(map: Map) { }

    mutating func mapping(map: Map) {
        title <- map["title"]
        startDate <- map["start_date"]
        endDate <- map["end_date"]
    }
}
