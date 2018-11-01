import UIKit

class AssetsTableViewCell: UITableViewCell {

    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var buyPoint: UILabel!
    @IBOutlet weak var mktPrice: UILabel!
    @IBOutlet weak var profitPoints: UILabel!
    @IBOutlet weak var profitValue: UILabel!
}

extension UILabel {
    
    func setGreen() {
        textColor = UIColor.init(red: 120/255, green: 187/255, blue: 50/255, alpha: 1)
    }
    
    func setRed() {
        textColor = .red
    }
}
