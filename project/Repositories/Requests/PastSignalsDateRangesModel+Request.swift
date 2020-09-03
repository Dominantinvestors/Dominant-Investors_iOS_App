//
//  PastSignalsDateRangesModel+Request.swift
//  DominantInvestors
//
//  Created by Andrew Konovalskiy on 30.08.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import Foundation

extension PastSignalsDateRangesModel {
    
    static func get() -> RequestProvider {
        return URLEncodingRequestBuilder(path: "/date-ranges/")
    }
}
