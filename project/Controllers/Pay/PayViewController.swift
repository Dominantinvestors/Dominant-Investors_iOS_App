import UIKit
import StoreKit

private let investmentTournamentId = "3892887888"

class PayViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var product: SKProduct?
    
    class func isBought() -> Bool {
        return UserDefaults.standard.bool(forKey: "isBought")
    }
    
    class func buy() {
        UserDefaults.standard.set(true, forKey: "isBought")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProducts()
        showActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func loadProducts() {
        let identifiers = Set([investmentTournamentId])
        let request = SKProductsRequest(productIdentifiers: identifiers)
        request.delegate = self
        request.start()
    }
    
    @IBAction func buy(_ sender: Any) {
        if let product = product {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            showAlertWith(message: "No purchasable products available.")
        }
    }
    
    @IBAction func restore(_ sender: Any) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    fileprivate func success() {
        PayViewController.buy()
        navigationController?.popViewController(animated: true)
    }
}

extension PayViewController: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        dismissActivityIndicator()

        if response.products.count > 0 {
            product = response.products.last
            print("Purchasable products available!")
        } else {
            print("No purchasable products available.")
        }
    }
}

extension PayViewController: SKPaymentTransactionObserver {

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("The payment is being processed.")
            case .purchased:
                success()
                print("Payment processed successfully.")
            case .restored:
                success()
                print("Payment restored successfully.")
            case .failed:
                showAlertWith(transaction.error ?? "" as! Error)
            case .deferred:
                print("Payment is waiting for outside action.")
            }
        }
    }
    
}
