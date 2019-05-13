import UIKit
import StoreKit

private let  investmentTournamentId = "3892887888"

class PayViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var product: SKProduct?
    
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
    
    @IBAction func terms(_ sender: Any) {
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func restore(_ sender: Any) {
        SKPaymentQueue.default().restoreCompletedTransactions()
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
                print("Payment processed successfully.")
            case .restored:
                print("Payment restored successfully.")
            case .failed:
                showAlertWith(transaction.error ?? "" as! Error)
            case .deferred:
                print("Payment is waiting for outside action.")
            }
        }
    }
    
}
