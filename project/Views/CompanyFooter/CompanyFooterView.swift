import UIKit

class CompanyFooterView: UITableViewCell {

    @IBOutlet weak var buttonsEstimizeHeight: NSLayoutConstraint!

    @IBOutlet weak var addToWatchlistButton: UIButton!

    @IBOutlet weak var revenueEstimizeButton: UIButton!
    @IBOutlet weak var epsEstimizeButton: UIButton!
    @IBOutlet weak var tradingViewButton: UIButton!
    
    @IBOutlet weak var buyPointLabel: UILabel!
    @IBOutlet weak var growthPotential: UILabel!
    @IBOutlet weak var stopLoss: UILabel!
    @IBOutlet weak var targetPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        revenueEstimizeButton.layer.cornerRadius = 25.0
        revenueEstimizeButton.layer.borderColor = UIColor.red.cgColor
        revenueEstimizeButton.layer.borderWidth = 1.0
        
        epsEstimizeButton.layer.cornerRadius = 25.0
        epsEstimizeButton.layer.borderColor = UIColor.red.cgColor
        epsEstimizeButton.layer.borderWidth = 1.0
    }
    
    func setCompany(_ company: CompanyModel) {
        buyPointLabel.text = company.rate.replacingOccurrences(of: ",", with: ".") + Values.Currency
        growthPotential.text = "\(company.growthPotential)" + "%"
        stopLoss.text = company.stopLoss.replacingOccurrences(of: ",", with: ".") + Values.Currency
        targetPrice.text = company.targetPrice + Values.Currency
        
        if company.isCrypto() {
            buttonsEstimizeHeight.constant = 0
        }
    }
}
