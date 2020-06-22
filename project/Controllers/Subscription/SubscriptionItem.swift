//
//  SubscriptionItem.swift
//  Inapps
//
//  Created by Andrew Konovalskiy on 18.06.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import UIKit

enum SubscriptionItem: Int, CaseIterable {
    case alers
    case notifications
    case professional
    
    var title: String {
        switch self {
        case .alers:
            return """
            Use high-precision trading signals
            that tell you when to buy when to sell
            and when to take profits
            """
        case .notifications:
            return """
            Our algorithm analyzes more than 7500
            companies and can recognize breakout
            stocks with huge growth potential
            """
        case .professional:
            return """
            Access to private chat rooms in
            which top investors discuss
            trade deals
            """
        }
    }
    
    var image: UIImage? {
        switch self {
        case .alers:
            return UIImage(named: "Subscription/alerts")
        case .notifications:
            return UIImage(named: "Subscription/notification")
        case .professional:
            return UIImage(named: "Subscription/profi")
        }
    }
    
    var description: String {
        switch self {
        case .alers:
            return """
            Alerts on when to increase positions
            take profits or cut losses
            """
        case .notifications:
            return """
            Buy & Sell signals
            via push notifications
            """
        case .professional:
            return """
            Professional traders guiding you
            during bear and bull markets
            """
        }
    }
}
