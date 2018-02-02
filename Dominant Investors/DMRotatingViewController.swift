//
//  DMRotatingViewController.swift
//  Dominant Investors
//
//  Created by Nekit on 25.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit
import StoreKit

class DMRotatingViewController: DMViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    

    var viewControllers = [DMViewController]()
    var buttons         = [UIButton]()
    var containers      : [UIView]!
    var loaded          = false
    
    let tabIcons    = [UIImage(named: "ideas"), UIImage(named: "screener"), UIImage(named: "folio"), UIImage(named: "rating")]
    let activeIcons = [UIImage(named: "ideas_active"), UIImage(named: "screener_active"), UIImage(named: "folio_active"), UIImage(named: "rating_active")]
    
    //MARK: SKProduct
    
    var productIDs = [String]()
    var productsArray = [SKProduct]()
    
    var transactionInProgress = false
    
    //MARK: Autorotate
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var analyticsContainer : UIView!
    @IBOutlet weak var portfolioContainer : UIView!
    @IBOutlet weak var ratingsContainer   : UIView!
    @IBOutlet weak var screenerContainer  : UIView!
    
    @IBOutlet weak var stackView          : UIStackView!
    
    
    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupForSubscription()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.showTrial()
        
        if (!loaded) {
            setupControllers()
            setupContainers()
            setupNotificationCenterObserving()
            setupTabButtons()
            showDefaultPage()
            loaded = true
        }
        
        let showed = UserDefaults.standard.bool(forKey: "kInfoShowed")
        
        if !showed {
            let introView = Bundle.main.loadNibNamed("DMInfoIntroView", owner: nil, options: nil)![0] as! DMInfoIntroView
            introView.addTo(superview: self.view)
            UserDefaults.standard.set(true, forKey: "kInfoShowed")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let someValue : String = segue.identifier != nil ? segue.identifier! : ""
        switch someValue {
        case "analytics":
            self.viewControllers.append(segue.destination as! DMViewController)
            break;
        case "portfolio":
            self.viewControllers.append(segue.destination as! DMViewController)
            break;
        case "ratings":
            self.viewControllers.append(segue.destination as! DMViewController)
            break;
        case "screener":
            self.viewControllers.append(segue.destination as! DMViewController)
            break;
        default:
            
            break;
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Private
    private func setupTabButtons() {
        for index in 0...self.viewControllers.count - 1 {
            let newButton = UIButton()
            newButton.setImage(tabIcons [index], for: .normal)
            newButton.imageView?.contentMode = .scaleAspectFill
            newButton.tag = index
            newButton.addTarget(self, action: #selector(showTab(_:)), for: .touchUpInside)
            buttons.append(newButton)
            stackView.addArrangedSubview(newButton)
        }
    }
    
    private func setupContainers() {
        self.containers = [self.analyticsContainer, self.screenerContainer, self.portfolioContainer, self.ratingsContainer]
    }
    
    private func setupNotificationCenterObserving() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDefaultPage), name: NSNotification.Name(rawValue: "kShowSignals"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSignalsHistory), name: NSNotification.Name(rawValue: "kShowHSignalsHistory"), object: nil)
    }
    
    
    
    private func setupControllers() {
        //#WARNING : кОСТЫЛИУС!!!
        var actualCont = [DMViewController(),DMViewController(),DMViewController(),DMViewController()]
        for cont in self.viewControllers {
            if cont is DMAnalyticsViewController {
                actualCont[0] = cont
            } else if cont is DMScreenerViewController {
                actualCont[1] = cont
            } else if cont is DMPortfolioViewController {
                actualCont[2] = cont
            } else {
                actualCont[3] = cont
            }
        }
        
        self.viewControllers = actualCont
    }
    
    @objc private func showDefaultPage() {
        self.showTab(index: Values.DMDefaultScreen)
        for button in buttons { button.setImage(tabIcons[button.tag], for: .normal) }
        buttons[0].setImage(activeIcons[0], for: .normal)
    }
    
    @objc private func showSignalsHistory() {
        self.showTab(index: Values.DMPortfolioScreen)
        for button in buttons {
            button.setImage(tabIcons[button.tag], for: .normal)
        }
        buttons[2].setImage(activeIcons[2], for: .normal)
    }
    
    @objc private func showTab(index : Int) {
        self.view.bringSubview(toFront: containers[index])
    }
    
    // MARK: Actions
    
    @objc private func showTab(_ sender : UIButton) {
        showTab(index: sender.tag)
        self.viewControllers[sender.tag].refreshData()
        for button in buttons { button.setImage(tabIcons[button.tag], for: .normal) }
        sender.setImage(activeIcons[sender.tag], for: .normal)
    }
    
    //MARK: Trial
    
    fileprivate func showTrial() {
        
        let trialBuyed = UserDefaults.standard.bool(forKey: "kTrialBuyed")
        if trialBuyed == true {
            DMAPIService.sharedInstance.trialBuyed()
            return;
        }
        
        if let registrationDate = DMAuthorizationManager.sharedInstance.userProfile.createdAt {
         

            let dateRangeStart = Date(timeIntervalSinceReferenceDate: 536850000) //APP VERSION WITH TRIAL RELEASE DATE
            let components = Calendar.current.dateComponents([.day, .hour], from: registrationDate, to: dateRangeStart)
            
            if let differense = components.day {
                if (differense > 0) {
                    return
                }
            }
        }
        
        //HARD TRIAL LOGIC
        DMAPIService.sharedInstance.checkTrialPeriodStartedExpired(userName: DMAuthorizationManager.sharedInstance.userProfile.userName) { (trialObjects) in
            DispatchQueue.main.async {
                
                if trialObjects?.count != 0 {
                    
                    for object in trialObjects! {
                        
                        //AKK EXIST
                        
                        if object.name == DMAuthorizationManager.sharedInstance.userProfile.userName {
                            if object.trialBuyed == true {
                                return
                            }
                            
                            let dateRangeStart = Date()
                            let dateRangeEnd = object.trialStarted
                            let components = Calendar.current.dateComponents([.day, .hour], from:dateRangeEnd! , to: dateRangeStart)
                            if let differense = components.day {
                                if (differense > 0) {
                                    self.proposeToBuy()
                                    return
                                } else {
                                    return
                                }
                            }
                        }
                        //
                        
                        //DEVICE EXIST
                        
                        if object.deviceUDID == UIDevice.current.identifierForVendor!.uuidString {
                            if object.trialBuyed == true && object.name == DMAuthorizationManager.sharedInstance.userProfile.userName {
                                return
                            }
                            
                            let dateRangeStart = Date()
                            let dateRangeEnd = object.trialStarted
                            let components = Calendar.current.dateComponents([.day, .hour], from:dateRangeEnd! , to: dateRangeStart)
                            if let differense = components.day {
                                if (differense > 0) {
                                    self.proposeToBuy()
                                    return
                                } else {
                                    return
                                }
                            }
                        }
                        //
                    }
                }
                
                self.proposeTrial()
            }
        }
    }
    
    open func proposeToBuy() {
        let trialView = Bundle.main.loadNibNamed("DMTrialView", owner: nil, options: nil)![0] as! DMTrialView
        trialView.delegate = self
        trialView.addTo(superview: self.view)
    }
    
    open func proposeTrial() {
        let trialView = Bundle.main.loadNibNamed("DMTrialUsageView", owner: nil, options: nil)![0] as! DMTrialUsageView
        trialView.delegate = self
        trialView.addTo(superview: self.view)
    }
    
    //MARK: SKPaymentTransactionObserver
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
            }
        } else {
            print("There are no products.")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        self.dismissActivityIndicator()
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                
                print("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                
                DispatchQueue.main.async {
                    
                    if (transaction.transactionDate != nil) {
                        NotificationCenter.default.post(name: NSNotification.Name("kBuyedName"), object: nil)
                        DMAPIService.sharedInstance.trialBuyed()
                        UserDefaults.standard.set(true, forKey: "kTrialBuyed")
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
    
    //MARK : Buy Actions
    
    fileprivate func setupForSubscription() {
        productIDs.append("dominantOne")
        self.requestProductInfo()
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
    
    open func restore() {
        
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
    
    open func buyApp() {
        self.showActivityIndicator()
        self.showActions()
    }
    
    private func showActions() {
        
        if transactionInProgress {
            return
        }
        
        let actionSheetController = UIAlertController(title: "Dominant stock signals".localized,
                                                      message: "Buy a subsscription right now and get unlimited access to the app".localized,
                                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.default) { (action) -> Void in
            DispatchQueue.main.async {
                
                if (self.productsArray.count > 0) {
                    
                    let payment = SKPayment(product: self.productsArray[0] as SKProduct)
                    SKPaymentQueue.default().add(self as SKPaymentTransactionObserver)
                    SKPaymentQueue.default().add(payment)
                    self.transactionInProgress = true
                } else {
                    self.dismissActivityIndicator()
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
    
    open func changeAccount() {
        DMAuthorizationManager.sharedInstance.signOut()
        DMPersonalPortfolioService.sharedInstance.changeUser()
        
        let auth = UIStoryboard(name: "Authorization", bundle: nil).instantiateInitialViewController()
        let navigation = UINavigationController.init(rootViewController: auth!)
        navigation.setNavigationBarHidden(true, animated: false)
        self.present(navigation, animated: true, completion: nil)
    }

}
