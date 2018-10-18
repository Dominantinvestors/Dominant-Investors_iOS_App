import UIKit

class AssetsTableViewCell: UITableViewCell {

    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var buyPoint: UILabel!
    @IBOutlet weak var mktPrice: UILabel!
    @IBOutlet weak var profitPoints: UILabel!
    @IBOutlet weak var profitValue: UILabel!
    
    func set(mkt: Double) {
        mktPrice.setValue(mkt)
    }
    
    func set(profit: String) {
        profitPoints.setValue(Double(profit) ?? 0)
    }
}

extension UILabel {
    
    func setValue(_ value: Double) {
        if value > 0.0 {
            textColor = UIColor.init(red: 120/255, green: 187/255, blue: 50/255, alpha: 1)
        } else {
            textColor = .red
        }
        text = String(value)
    }
}
