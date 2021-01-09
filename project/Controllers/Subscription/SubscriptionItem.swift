//
//  SubscriptionItem.swift
//  Inapps
//
//  Created by Andrew Konovalskiy on 18.06.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import UIKit

enum SubscriptionItem: Int, CaseIterable {
    case professional
    case alers
    case notifications
    
    var title: String {
        switch self {
        case .professional:
            return """
            Take the quality of your investment portfolio
            management to the next level
            """
        case .alers:
            return """
            Increase the performance of your
            investment portfolio several times using
            Copy Trading technology
            """
        case .notifications:
            return """
            Get exact trading recommendations
            when to buy, when to sell and
            when to take profits
            """
        }
    }
    
    var image: UIImage? {
        switch self {
        case .notifications:
            return UIImage(named: "Subscription/notification")
        case .alers:
            return UIImage(named: "Subscription/alerts")
        case .professional:
            return UIImage(named: "Subscription/profi")
        }
    }
    
    var description: String {
        switch self {
        case .professional:
            return """
            Invest like a pro
            """
        case .alers:
            return """
            Follow the trading signals of top investors
            """
        case .notifications:
            return """
            Receive useful notifications
            """
        }
    }
}
