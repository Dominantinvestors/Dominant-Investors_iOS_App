//
//  StoreKitManager.swift
//  Inapps
//
//  Created by Andrew Konovalskiy on 18.06.2020.
//  Copyright © 2020 DS. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import StoreKit

enum ProductId: String, CaseIterable {
    case monthly = "signal_subscription_monthly_renewable"
    case annually = "signal_subscription_annually_renewable"
}

// StoreKitManager assumes that we have only auto renewable subscriptions in our productIds
// For another type of products we must extend this manager
final class StoreKitManager {
    
    static let `default`: StoreKitManager = { return StoreKitManager() }()
    
    private(set) var products: [StoreProduct]?
    private(set) var subscriptions: [StoreSubscription]?
    private(set) var productIds: [String] = []
    
    private var isLoadingProducts = false
    private var isLoadingSubscriptions = false
    private var productsSubscriptions: [String: Bool] = [:]
    private var productsCompletion: (([StoreProduct]?, Error?) -> Void)?
    private var subscriptionsCompletion: (([StoreSubscription]?, Error?) -> Void)?
    private var secret: String? = "5e07eb06d97542508769bfd7547e89e7"
    
    private init() {
        validatePendingTransactions()
    }
    
    func configure(productIds: [String], secret: String?) {
        self.productIds = productIds
        self.secret = secret
        
        restoreSavedSubscriptions()
        loadProducts()
        verifySubscriptions(forceRefresh: true)
    }
    
    func isSubscribed(productId: String) -> Bool? {
        return productsSubscriptions[productId]
    }
    
    func products(productIds: [String], completion: @escaping ([StoreProduct]?, Error?) -> Void) {
        if let products = products {
            completion(products.filter { productIds.contains($0.id) }, nil)
        } else {
            self.productsCompletion = { products, error in
                completion(products?.filter { productIds.contains($0.id) }, error)
            }
            if !isLoadingProducts {
                loadProducts()
            }
        }
    }
    
    func canMakePayments() -> Bool {
        return SwiftyStoreKit.canMakePayments
    }
    
    func buy(productId: String, source: String,
             additionalParams: [String: AnyHashable]? = nil,
             completion: @escaping (Error?) -> Void) {
        var params: [String: AnyHashable] = ["source": source, "inapp_id": productId]
        
        if let additionalParams = additionalParams {
            params = params.merging(additionalParams) { current, _ in current }
        }
        
        SwiftyStoreKit.purchaseProduct(productId, atomically: true) { [unowned self] result in
            
            switch result {
            case .success(let purchase):
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
//                self.productsSubscriptions.accept(true)
                self.verifySubscriptions(forceRefresh: false)
                
                completion(nil)
            case .error(let error):
                self.logInappError(error: error, params: params)
                
                completion(error)
            }
        }
    }
    
    /// Method where you can implement Analytics for handle erros with Inapps
    private func logInappError(error: SKError, params: [String: AnyHashable]) {
        var params = params
        
        let code: String
        switch error.code {
        case .clientInvalid:
            code = "clientInvalid"
        case .cloudServiceNetworkConnectionFailed:
            code = "cloudServiceNetworkConnectionFailed"
        case .cloudServicePermissionDenied:
            code = "cloudServicePermissionDenied"
        case .cloudServiceRevoked:
            code = "cloudServiceRevoked"
        case .paymentCancelled:
            code = "paymentCancelled"
        case .paymentInvalid:
            code = "paymentInvalid"
        case .paymentNotAllowed:
            code = "paymentNotAllowed"
        case .storeProductNotAvailable:
            code = "storeProductNotAvailable"
        default:
            code = "unknown"
        }
        
        params["code"] = code
        print("Error code: \(code)")
    }
    
    func restore(completion: @escaping ([StoreSubscription]?, Error?) -> Void) {
        if let subscriptions = subscriptions {
            completion(subscriptions, nil)
        } else {
            self.subscriptionsCompletion = completion
            if !isLoadingSubscriptions {
                verifySubscriptions(forceRefresh: true)
            }
        }
    }
}

// MARK: Private methods
extension StoreKitManager {
    private func loadProducts() {
        assert(!productIds.isEmpty, "Manager don't have productIds")
        
        isLoadingProducts = true
        SwiftyStoreKit.retrieveProductsInfo(Set(productIds)) { [unowned self] result in
            self.products = result.retrievedProducts.map { StoreProduct(product: $0) }
            
            for invalidProductId in result.invalidProductIDs {
                print("Invalid product identifier: \(invalidProductId)")
            }
            
            self.productsCompletion?(self.products, result.error)
            self.productsCompletion = nil
            self.isLoadingProducts = false
        }
    }
    
    private func validatePendingTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
    }
    
    // - Parameter forceRefresh: If true, refreshes the receipt even if one already exists.
    private func verifySubscriptions(forceRefresh: Bool) {
        isLoadingSubscriptions = true
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: secret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: forceRefresh) { [unowned self] result in
            switch result {
            case .success(let receipt):
                var subscriptions: [StoreSubscription] = []
                
                for productId in self.productIds {
                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: .autoRenewable,
                        productId: productId,
                        inReceipt: receipt)
                    let subscription = StoreSubscription(id: productId, result: purchaseResult)
                    subscriptions.append(subscription)
                    self.productsSubscriptions[productId] = subscription.status == .purchased
                }
                
                self.subscriptions = subscriptions
                self.saveSubscriptionsToDisk()
                self.subscriptionsCompletion?(subscriptions, nil)
            case .error(let error):
                self.subscriptionsCompletion?(nil, error)
            }
            self.isLoadingSubscriptions = false
            self.subscriptionsCompletion = nil
        }
    }
    
    private func subscriptionsUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("subscriptions")
    }
    
    private func restoreSavedSubscriptions() {
        var savedData: [String: Bool] = [:]
        if let data = try? Data(contentsOf: subscriptionsUrl()) {
            let decoder = PropertyListDecoder()
            savedData = (try? decoder.decode([String: Bool].self, from: data)) ?? [:]
        }
        
        for productId in productIds {
            productsSubscriptions[productId] = savedData[productId] ?? false
        }
    }
    
    private func saveSubscriptionsToDisk() {
        let data = productsSubscriptions.mapValues { $0 }
        let encoder = PropertyListEncoder()
        
        try? encoder.encode(data).write(to: subscriptionsUrl())
    }
}
