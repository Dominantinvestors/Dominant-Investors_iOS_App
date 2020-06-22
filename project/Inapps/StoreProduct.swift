import Foundation
import StoreKit

public struct StoreProduct {
    // ProductId format <app>.<inapp_type>.<inapp_name>
    // inapp_type - enum(lifetime, subscription, subscription_with_trial)
    public let id: String
    public let description: String
    public let title: String
    public let price: NSDecimalNumber
    public let priceLocale: Locale
    
    public lazy var localizedPrice: String? = {
        let formatter = NumberFormatter()
        formatter.locale = priceLocale
        formatter.numberStyle = .currency
        
        return formatter.string(from: price)
    }()
    
    init(product: SKProduct) {
        id = product.productIdentifier
        description = product.localizedDescription
        title = product.localizedTitle
        price = product.price
        priceLocale = product.priceLocale
    }
}
