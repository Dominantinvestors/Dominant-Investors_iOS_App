//
//  SubscriptionItem.swift
//  Inapps
//
//  Created by Andrew Konovalskiy on 18.06.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import UIKit

enum SubscriptionItem: Int, CaseIterable {
    case notifications
    case alers
    case professional
    case invest
    
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
            24 hours acces to chat rooms with mentors
            """
        case .invest:
            return """
            Invest with Pro
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
        case .invest:
            return UIImage(named: "Subscription/follow")
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
            List of the best stocks to buy now
            """
        case .professional:
            return """
            Professional traders guiding you
            during bear and bull markets
            """
        case .invest:
            return """
            Take the quality of your investment
            portfolio management to the next level
            """
        }
    }
}
