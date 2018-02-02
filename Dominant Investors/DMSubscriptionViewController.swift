//
//  DMSubscriptionViewController.swift
//  Dominant Investors
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit
import StoreKit
import MBProgressHUD

class DMSubscriptionViewController: DMViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    var expiredDate : Date?
    var transactionInProgress = false
    var delegate : DMContainerDelegate!
    
    var productIDs = [String]()
    var productsArray = [SKProduct]()
    
    
    @IBOutlet var backgroundImageView : UIImageView!
    @IBOutlet var overlayView : FXBlurView!
    
    // MARK: ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if (self.checkPremiumAccounts() == true) {
            showSignals()
            return
        // }
        
        self.drawBlurView()
        self.backgroundImageView.image = self.DMAuthScreensBackground
        productIDs.append("dominantOne")
        self.requestProductInfo()
        self.showActivityIndicator()
        DMSignalsStoreService.sharedInstance.checkSubscription { (subscription) in
            DispatchQueue.main.async {
                self.dismissActivityIndicator()
                if (subscription != nil) {
                    if (DMSignalsStoreService.sharedInstance.isSubscriptionValid(subscription: subscription!)) {
                        self.showSignals()
                    } else {
                        self.delegate.showContainer()
                    }
                } else {
                    self.delegate.showContainer()
                }
            }
        }
    }

    
    // MARK: Actions
    
    @IBAction func buy() {
        self.showActivityIndicator()
        self.showActions()
    }
    
    @IBAction func restore() {
        
        if transactionInProgress {
            return
        } else {
            DispatchQueue.main.async {
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().restoreCompletedTransactions()
                self.transactionInProgress = true
            }
        }
        
    }
    
    @IBAction func closeAction() {
        self.delegate.dismiss()
    }
    

    //MARK: SKProductsRequestDelegate
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
            }
        } else {
            print("There are no products.")
        }
    }
    
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    // MARK: Private
    
    private func checkPremiumAccounts() -> Bool {
        if let name = DMAuthorizationManager.sharedInstance.userProfile.userName {
            if (name == "" || name == "ChuckBo4" || name == "PichaiSF" || name == "doncooljuan" || name == "rch7" || name == "mosworldtour" || name == "eokennedy" || name == "savvygaby" || name == "ccrunner62" || name == "Pavel" || name == "eokennedy") {
                return true;
            }
        }
        return false;
    }
    
    private func showActions() {
        
        if transactionInProgress {
            return
        }
        
        let actionSheetController = UIAlertController(title: "Dominant stock signals",
                                                      message: "Get investment signals subscription for one month?",
                                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.default) { (action) -> Void in
            DispatchQueue.main.async {
        
                if (self.productsArray.count > 0) {
                   
                    let payment = SKPayment(product: self.productsArray[0] as SKProduct)
                    SKPaymentQueue.default().add(self as SKPaymentTransactionObserver)
                    SKPaymentQueue.default().add(payment)
                    self.transactionInProgress = true
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            self.dismissActivityIndicator()
        }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    
    func purchaseSuccesfull(date : Date) {
        DMSignalsStoreService.sharedInstance.successPurchaseWith(expired_date: date) { (success) in
            if (success) {
                self.showSignals()
            }
        }
    }
    
    func showSignals() {
        self.delegate.hideContainer()
    }
    
    private func drawBlurView() {
        self.overlayView.isBlurEnabled  = true
        self.overlayView.blurRadius     = 20
        self.overlayView.isDynamic      = false
        self.overlayView.tintColor      = UIColor.lightGray
    }
    
    //MARK: SKPaymentTransactionObserver
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        self.dismissActivityIndicator()
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                
                print("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                
                DispatchQueue.main.async {
                    
                    if (transaction.transactionDate != nil) {
                        let cal = NSCalendar.current
                        let date = cal.date(byAdding: .month, value: 1, to: transaction.transactionDate!)
                        self.purchaseSuccesfull(date : date!)
                    }
                    self.transactionInProgress = false
                }
                
            case .failed:
               
                print("Transaction Failed");
                SKPaymentQueue.default().finishTransaction(transaction)
                self.transactionInProgress = false
                
            default:
                print(transaction.transactionState.rawValue)
            }
        }

    }

    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
 
        if (queue.transactions.count == 0) {
            self.dismissActivityIndicator()
            let alert = UIAlertController(title: "Error", message: "Nothing to restore", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil));
            self.dismissActivityIndicator()
            self.present(alert, animated: true, completion: nil)
            self.transactionInProgress = false
            return
        }
        
        for transaction in queue.transactions {
            if (transaction.transactionIdentifier == "dominantOne") {
                                self.transactionInProgress = false
            }
        }
    }
    
}
