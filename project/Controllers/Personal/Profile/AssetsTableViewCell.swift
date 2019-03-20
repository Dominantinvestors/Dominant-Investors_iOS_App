import UIKit

class AssetsTableViewCell: UITableViewCell {

    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var buyPoint: UILabel!
    @IBOutlet weak var mktPrice: UILabel!
    @IBOutlet weak var profitPoints: UILabel!
    @IBOutlet weak var profitValue: UILabel!
    @IBOutlet weak var profitValueView: UIView!

    @IBOutlet weak var background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profitValueView.layer.cornerRadius = 2
    }
}

extension UILabel {
    
    func setGreen() {
        textColor = Colors.green
    }
    
    func setRed() {
        textColor =  Colors.red
    }
}
