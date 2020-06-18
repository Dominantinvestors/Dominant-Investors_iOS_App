import Foundation
import SwiftyStoreKit

enum StoreSubscriptionStatus {
    case purchased
    case expired
    case notPurchased
}

struct StoreSubscription {
    let id: String
    let status: StoreSubscriptionStatus
    let receipts: [ReceiptItem]?
    let expirationDate: Date?
    
    init(id: String, result: VerifySubscriptionResult) {
        self.id = id
        
        switch result {
        case .purchased(let expiryDate, let items):
            status = .purchased
            expirationDate = expiryDate
            receipts = items
        case .expired(let expiryDate, let items):
            status = .expired
            expirationDate = expiryDate
            receipts = items
        case .notPurchased:
            status = .notPurchased
            expirationDate = nil
            receipts = nil
        }
    }
}
