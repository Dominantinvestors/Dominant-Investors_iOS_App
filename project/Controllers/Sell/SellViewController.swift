import UIKit

class SellViewController: BuyViewController {

    var maxAmount: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("MARKET SELL", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buyDataSource.text = maxAmount
    }
    
    override func onSubmit() {
        let sellPoints = Double(buyDataSource.text) ?? 0.0
        let maxSellPoints = Double(maxAmount) ?? 0.0
        guard maxSellPoints >= sellPoints else {
            showAlertWith(message: "You try to sell more then you have!!!")
            return
        }
        
        showActivityIndicator()
        PortfolioDataProvider.default().sell(buyDataSource.text, company) { success, error in
            self.dismissActivityIndicator()
            if success {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.showAlertWith(message: error)
            }
        }
    }
}
